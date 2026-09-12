import ballerina/io;
import ballerina/grpc;

public function main() returns error? {

    RentalServiceClient rentalClient = check new ("http://localhost:9443");

    // --------------------------------------------------
    // 1. ADD PROPERTY
    // --------------------------------------------------

    Property property = {
        property_id: "P001",
        name: "Ocean View Apartment",
        location: "Swakopmund",
        property_type: "Apartment",
        price_per_night: 1200.0,
        status: "Available"
    };

    PropertyResponse addResponse =
        check rentalClient->AddProperty(property);

    io:println("ADD PROPERTY:");
    io:println(addResponse);


    // --------------------------------------------------
    // 2. CREATE USERS - CLIENT STREAMING
    // --------------------------------------------------

    CreateUsersStreamingClient userStream =
        check rentalClient->CreateUsers();

    UserProfile user1 = {
        username: "rischa",
        role: "Guest",
        email: "rischa@example.com"
    };

    UserProfile user2 = {
        username: "guest2",
        role: "Guest",
        email: "guest2@example.com"
    };

    check userStream->sendUserProfile(user1);
    check userStream->sendUserProfile(user2);

    // Using var here handles the dynamic streaming return safely
    var userResponse = check userStream->complete();

    io:println("CREATE USERS:");
    io:println(userResponse);


    // --------------------------------------------------
    // 3. UPDATE PROPERTY
    // --------------------------------------------------

    property.price_per_night = 1300.0;

    PropertyResponse updateResponse =
        check rentalClient->UpdateProperty(property);

    io:println("UPDATE PROPERTY:");
    io:println(updateResponse);


    // --------------------------------------------------
    // 4. SEARCH PROPERTY
    // --------------------------------------------------

    PropertySearchRequest searchRequest = {
        property_id: "P001"
    };

    PropertyDetailsResponse searchResponse =
        check rentalClient->SearchProperty(searchRequest);

    io:println("SEARCH PROPERTY:");
    io:println(searchResponse);


    // --------------------------------------------------
    // 5. LIST AVAILABLE PROPERTIES
    // --------------------------------------------------

    SearchFilter filter = {
        location: "Swakopmund",
        max_price: 2000.0
    };

    stream<Property, grpc:Error?> propertyStream =
        check rentalClient->ListAvailableProperties(filter);

    io:println("AVAILABLE PROPERTIES:");

    check propertyStream.forEach(
        function(Property availableProperty) {
            io:println(availableProperty);
        }
    );


    // --------------------------------------------------
    // 6. BOOK PROPERTY - YOUR G3 PART
    // --------------------------------------------------

    BookingRequest bookingRequest = {
        property_id: "P001",
        check_in_date: "2026-10-10",
        check_out_date: "2026-10-13",
        guest_username: "rischa"
    };

    BookingCartResponse bookingResponse =
        check rentalClient->BookProperty(bookingRequest);

    io:println("BOOK PROPERTY:");
    io:println(bookingResponse);


    // --------------------------------------------------
    // 7. CONFIRM BOOKING - YOUR MAIN G3 PART
    // --------------------------------------------------

    ConfirmationRequest confirmationRequest = {
        guest_username: "rischa",
        property_id: "P001"
    };

    BookingConfirmation confirmation =
        check rentalClient->ConfirmBooking(confirmationRequest);

    io:println("CONFIRM BOOKING:");
    io:println(confirmation);


    // --------------------------------------------------
    // 8. REMOVE PROPERTY
    // --------------------------------------------------

    RemovePropertyRequest removeRequest = {
        property_id: "P001",
        region: "Swakopmund"
    };

    PropertyList removeResponse =
        check rentalClient->RemoveProperty(removeRequest);

    io:println("REMOVE PROPERTY:");
    io:println(removeResponse);

    return;
}
