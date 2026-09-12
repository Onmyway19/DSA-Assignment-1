import ballerina/grpc;
import ballerina/uuid;
import ballerina/time;

map<Property> properties = {};

map<User> users = {};
map<BookingRequest> bookingCart = {};
map<BookingRequest[]> confirmedBookings = {};

function datesOverlap(string aIn, string aOut, string bIn, string bOut) returns boolean {
    return aIn < bOut && bIn < aOut;
}

function nightsBetween(string checkIn, string checkOut) returns int|error {
    time:Utc inUtc = check time:utcFromString(checkIn + "T00:00:00.00Z");
    time:Utc outUtc = check time:utcFromString(checkOut + "T00:00:00.00Z");
    time:Seconds diff = time:utcDiffSeconds(outUtc, inUtc);
    return <int>(diff / 86400);
}

@grpc:Descriptor {value: SERVICE_DESC}
service "RentalService" on new grpc:Listener(9090) {

    remote function add_property(Property req) returns Property|error {
        string newId = uuid:createType1AsString();
        Property newProperty = {
            property_id: newId,
            name: req.name,
            location: req.location,
            property_type: req.property_type,
            price_per_night: req.price_per_night,
            status: req.status
        };
        properties[newId] = newProperty;
        return newProperty;
    }

    remote function update_property(Property req) returns Property|error {
        if !properties.hasKey(req.property_id) {
            return error("Property not found");
        }
        properties[req.property_id] = req;
        return req;
    }

    remote function remove_property(PropertyId req) returns PropertyList|error {
        if properties.hasKey(req.property_id) {
            _ = properties.remove(req.property_id);
        }
        Property[] remaining = properties.toArray();
        PropertyList list = {properties: remaining};
        return list;
    }

    remote function search_property(PropertyId req) returns SearchResult|error {
        if properties.hasKey(req.property_id) {
            Property p = properties.get(req.property_id);
            SearchResult result = {found: true, property: p, message: "Property found"};
            return result;
        } else {
            Property empty = {property_id: "", name: "", location: "", property_type: "", price_per_night: 0.0, status: ""};
            SearchResult result = {found: false, property: empty, message: "Not Available"};
            return result;
        }
    }
    

    remote function create_users(stream<User, grpc:Error?> clientStream) returns UserCreationConfirmation|error {
    int count = 0;
    check from User u in clientStream
        do {
            lock {
                users[u.user_id] = u.clone();
            }
            count += 1;
        };
    return {total_created: count, message: "Users registered successfully"};
}
       
remote function list_available_properties(PropertyFilter req) returns stream<Property, error?>|error {
    Property[] matches = [];
    lock {
        foreach Property p in properties {
            boolean matchesLocation = req.location == "" || p.location == req.location;
            boolean matchesPrice = req.max_price == 0.0 || p.price_per_night <= req.max_price;
            if matchesLocation && matchesPrice {
                matches.push(p.clone());
            }
        }
    }
    return matches.toStream();
}

remote function book_property(BookingRequest req) returns BookingCartResponse|error {
    if !properties.hasKey(req.property_id) {
        return {accepted: false, message: "Property does not exist"};
    }

    int|error nights = nightsBetween(req.check_in, req.check_out);
    if nights is error || nights <= 0 {
        return {accepted: false, message: "Check-out date must be after check-in date"};
    }

    lock {
        bookingCart[req.guest_id] = req.clone();
    }
    return {accepted: true, message: "Booking request added to cart"};
}

remote function confirm_booking(BookingRequest req) returns BookingConfirmation|error {
    if !bookingCart.hasKey(req.guest_id) {
        return {confirmed: false, total_cost: 0.0, message: "No pending booking found for this guest"};
    }

    if !properties.hasKey(req.property_id) {
        return {confirmed: false, total_cost: 0.0, message: "Property no longer exists"};
    }

    BookingRequest[] existing = confirmedBookings.hasKey(req.property_id) ? confirmedBookings.get(req.property_id) : [];
    foreach BookingRequest b in existing {
        if datesOverlap(req.check_in, req.check_out, b.check_in, b.check_out) {
            lock {
                _ = bookingCart.remove(req.guest_id);
            }
            return {confirmed: false, total_cost: 0.0, message: "Dates no longer available"};
        }
    }

    int nights = check nightsBetween(req.check_in, req.check_out);
    Property p = properties.get(req.property_id);
    float totalCost = <float>nights * p.price_per_night;

    lock {
        BookingRequest[] updated = existing.clone();
        updated.push(req.clone());
        confirmedBookings[req.property_id] = updated;
        _ = bookingCart.remove(req.guest_id);
    }

    return {confirmed: true, total_cost: totalCost, message: "Booking confirmed"};
}
}