import ballerina/grpc;
import ballerina/time;

// LOCAL DATA MODELS


public type LocalProperty record {|
    readonly string property_id;
    string name;
    string location;
    string property_type;
    float price_per_night;
    string status;
|};

public type LocalUserProfile record {|
    readonly string username;
    string role;
    string email;
|};

public type LocalBookingRequest record {|
    readonly string property_id;
    string check_in_date;
    string check_out_date;
    string guest_username;
|};

public type LocalBooking record {|
    readonly string booking_id;
    readonly string property_id;
    string guest_username;
    string check_in_date;
    string check_out_date;
    float total_cost;
|};




table<LocalProperty> key(property_id) propertiesTable = table [];

table<LocalUserProfile> key(username) usersTable = table [];

table<LocalBookingRequest> key(property_id) temporaryCartTable = table [];

table<LocalBooking> key(booking_id) bookingsTable = table [];


// HELPER FUNCTIONS


// Converts YYYY-MM-DD into a UTC value.
//
// This lets us compare dates and calculate the number of nights.
function dateToUtc(string dateString) returns time:Utc|error {
    return time:utcFromString(dateString + "T00:00:00Z");
}


// Calculate the number of nights between two dates.
function calculateNights(string checkIn, string checkOut) returns int|error {
    time:Utc checkInTime = check dateToUtc(checkIn);
    time:Utc checkOutTime = check dateToUtc(checkOut);

    time:Seconds difference = time:utcDiffSeconds(checkOutTime, checkInTime);

    int nights = <int>(difference / 86400);

    return nights;
}


// Check whether two bookings overlap.
function datesOverlap(
    string newCheckIn,
    string newCheckOut,
    string existingCheckIn,
    string existingCheckOut
) returns boolean|error {

    time:Utc newStart = check dateToUtc(newCheckIn);
    time:Utc newEnd = check dateToUtc(newCheckOut);

    time:Utc existingStart = check dateToUtc(existingCheckIn);
    time:Utc existingEnd = check dateToUtc(existingCheckOut);

    return newStart < existingEnd && newEnd > existingStart;
}



// gRPC SERVICE

@grpc:Descriptor {value: ACCOMMODATION_DESC}
service "RentalService" on new grpc:Listener(9443) {

    // ========================================================
    // 1. ADD PROPERTY
    // ========================================================

    remote function AddProperty(Property value)
        returns PropertyResponse|error {

        if propertiesTable.hasKey(value.property_id) {
            return {
                property_id: value.property_id,
                status_message: "Error: Property ID already exists."
            };
        }

        LocalProperty property = {
            property_id: value.property_id,
            name: value.name,
            location: value.location,
            property_type: value.property_type,
            price_per_night: <float>value.price_per_night,
            status: value.status
        };

        propertiesTable.add(property);

        return {
            property_id: value.property_id,
            status_message: "Property successfully registered."
        };
    }


    // ========================================================
    // 2. CREATE USERS - CLIENT STREAMING
    // ========================================================

    remote function CreateUsers(
        stream<UserProfile, grpc:Error?> clientStream
    ) returns UserCreationSummary|error {

        int count = 0;

        error? streamError = clientStream.forEach(
            function(UserProfile user) {

                if !usersTable.hasKey(user.username) {

                    LocalUserProfile newUser = {
                        username: user.username,
                        role: user.role,
                        email: user.email
                    };

                    usersTable.add(newUser);
                    count += 1;
                }
            }
        );

        if streamError is error {
            return streamError;
        }

        return {
            status: "Success",
            total_registered: count
        };
    }


    // ========================================================
    // 3. UPDATE PROPERTY
    // ========================================================

    remote function UpdateProperty(Property value)
        returns PropertyResponse|error {

        if !propertiesTable.hasKey(value.property_id) {
            return {
                property_id: value.property_id,
                status_message: "Error: Property not found."
            };
        }

        LocalProperty updatedProperty = {
            property_id: value.property_id,
            name: value.name,
            location: value.location,
            property_type: value.property_type,
            price_per_night: <float>value.price_per_night,
            status: value.status
        };

        propertiesTable.put(updatedProperty);

        return {
            property_id: value.property_id,
            status_message: "Property successfully updated."
        };
    }


    // ========================================================
    // 4. REMOVE PROPERTY
    // ========================================================

    remote function RemoveProperty(RemovePropertyRequest value)
        returns PropertyList|error {

        if !propertiesTable.hasKey(value.property_id) {
            return {
                properties: []
            };
        }

        _ = propertiesTable.remove(value.property_id);

        Property[] remainingProperties =
            from LocalProperty property in propertiesTable
            where property.location == value.region
            select {
                property_id: property.property_id,
                name: property.name,
                location: property.location,
                property_type: property.property_type,
                price_per_night: property.price_per_night,
                status: property.status
            };

        return {
            properties: remainingProperties
        };
    }


    // ========================================================
    // 5. LIST AVAILABLE PROPERTIES - SERVER STREAMING
    // ========================================================

    remote function ListAvailableProperties(SearchFilter value)
        returns stream<Property, error?>|error {

        Property[] matchingProperties =
            from LocalProperty property in propertiesTable
            where property.location == value.location
                && property.price_per_night <= <float>value.max_price
                && property.status == "Available"
            select {
                property_id: property.property_id,
                name: property.name,
                location: property.location,
                property_type: property.property_type,
                price_per_night: property.price_per_night,
                status: property.status
            };

        return matchingProperties.toStream();
    }


    // ========================================================
    // 6. SEARCH PROPERTY
    // ========================================================

    remote function SearchProperty(PropertySearchRequest value)
        returns PropertyDetailsResponse|error {

        if !propertiesTable.hasKey(value.property_id) {

            return {
                status: "Not Available",
                property: {
                    property_id: "",
                    name: "",
                    location: "",
                    property_type: "",
                    price_per_night: 0.0,
                    status: ""
                }
            };
        }

        LocalProperty property = propertiesTable.get(value.property_id);

        Property result = {
            property_id: property.property_id,
            name: property.name,
            location: property.location,
            property_type: property.property_type,
            price_per_night: property.price_per_night,
            status: property.status
        };

        return {
            status: "Available",
            property: result
        };
    }


    // ========================================================
    // 7. BOOK PROPERTY
    // ========================================================

    remote function BookProperty(BookingRequest value)
        returns BookingCartResponse|error {

        // Check property exists.
        if !propertiesTable.hasKey(value.property_id) {

            return {
                status: "Failed",
                message: "Property does not exist."
            };
        }

        // Check guest exists.
        if !usersTable.hasKey(value.guest_username) {

            return {
                status: "Failed",
                message: "Guest user does not exist."
            };
        }

        // Validate the dates.
        int nights = check calculateNights(
            value.check_in_date,
            value.check_out_date
        );

        if nights <= 0 {

            return {
                status: "Failed",
                message: "Check-out date must be after check-in date."
            };
        }

        // Check whether the same property already has
        // a temporary request.
        if temporaryCartTable.hasKey(value.property_id) {

            return {
                status: "Failed",
                message: "This property already has a booking in the temporary cart."
            };
        }

        LocalBookingRequest cartItem = {
            property_id: value.property_id,
            check_in_date: value.check_in_date,
            check_out_date: value.check_out_date,
            guest_username: value.guest_username
        };

        temporaryCartTable.put(cartItem);

        return {
            status: "In Cart",
            message: "Property added to temporary booking cart."
        };
    }


    // ========================================================
    // 8. CONFIRM BOOKING
    // ========================================================

    remote function ConfirmBooking(ConfirmationRequest value)
        returns BookingConfirmation|error {

        // ----------------------------------------------------
        // A. Check cart and property
        // ----------------------------------------------------

        if !temporaryCartTable.hasKey(value.property_id) {

            return {
                booking_id: "",
                total_cost: 0.0,
                message: "Error: No matching reservation in cart."
            };
        }

        if !propertiesTable.hasKey(value.property_id) {

            return {
                booking_id: "",
                total_cost: 0.0,
                message: "Error: Property no longer exists."
            };
        }


        // ----------------------------------------------------
        // B. Retrieve booking request and property
        // ----------------------------------------------------

        LocalBookingRequest request =
            temporaryCartTable.get(value.property_id);

        LocalProperty property =
            propertiesTable.get(value.property_id);


        // ----------------------------------------------------
        // C. Make sure the guest matches
        // ----------------------------------------------------

        if request.guest_username != value.guest_username {

            return {
                booking_id: "",
                total_cost: 0.0,
                message: "Error: Guest does not match the booking cart."
            };
        }


        // ----------------------------------------------------
        // D. Calculate number of nights
        // ----------------------------------------------------

        int nights = check calculateNights(
            request.check_in_date,
            request.check_out_date
        );

        if nights <= 0 {

            return {
                booking_id: "",
                total_cost: 0.0,
                message: "Error: Invalid booking dates."
            };
        }


        // ----------------------------------------------------
        // E. Check existing bookings for date overlap
        // ----------------------------------------------------

        foreach LocalBooking existingBooking in bookingsTable {

            if existingBooking.property_id == value.property_id {

                boolean overlap = check datesOverlap(
                    request.check_in_date,
                    request.check_out_date,
                    existingBooking.check_in_date,
                    existingBooking.check_out_date
                );

                if overlap {

                    return {
                        booking_id: "",
                        total_cost: 0.0,
                        message: "Booking failed: selected dates overlap an existing booking."
                    };
                }
            }
        }


        // ----------------------------------------------------
        // F. Calculate total cost
        // ----------------------------------------------------

        float totalCost =
            property.price_per_night * <float>nights;


        // ----------------------------------------------------
        // G. Create booking
        // ----------------------------------------------------

        string bookingId =
    "BK-" + value.property_id + "-" +
    value.guest_username + "-" +
    request.check_in_date;

        LocalBooking confirmedBooking = {
            booking_id: bookingId,
            property_id: value.property_id,
            guest_username: value.guest_username,
            check_in_date: request.check_in_date,
            check_out_date: request.check_out_date,
            total_cost: totalCost
        };

        bookingsTable.put(confirmedBooking);


        // ----------------------------------------------------
        // H. Remove temporary cart item
        // ----------------------------------------------------

        _ = temporaryCartTable.remove(value.property_id);


        // ----------------------------------------------------
        // I. Update property status
        // ----------------------------------------------------

        property.status = "Booked";

        propertiesTable.put(property);


        // ----------------------------------------------------
        // J. Return confirmation
        // ----------------------------------------------------

        return {
            booking_id: bookingId,
            total_cost: totalCost,
            message: "Booking confirmed for "
                + value.guest_username
                + " from "
                + request.check_in_date
                + " to "
                + request.check_out_date
                + " for "
                + nights.toString()
                + " night(s)."
        };
    }
}
