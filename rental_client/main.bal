import ballerina/io;
import ballerina/grpc;

public function main() returns error? {
    RentalServiceClient rentalClient = check new ("http://localhost:9090");

    // --- Test 1: add a property so we have something to list later ---
    Property newProp = {
        property_id: "",
        name: "Test Cabin",
        location: "Windhoek",
        property_type: "House",
        price_per_night: 50.0,
        status: "AVAILABLE"
    };
    Property added = check rentalClient->add_property(newProp);
    io:println("Added property with id: ", added.property_id);

    // --- Test 2: create_users (client-streaming) ---
    Create_usersStreamingClient userStream = check rentalClient->create_users();

    User u1 = {user_id: "u1", name: "Alice", role: "GUEST", email: "alice@example.com"};
    User u2 = {user_id: "u2", name: "Bob", role: "HOST", email: "bob@example.com"};

    check userStream->sendUser(u1);
    check userStream->sendUser(u2);
    check userStream->complete();

    UserCreationConfirmation? confirmation = check userStream->receiveUserCreationConfirmation();
    io:println("create_users result: ", confirmation);

    // --- Test 3: list_available_properties (server-streaming) ---
    PropertyFilter filter = {location: "Windhoek", max_price: 0.0};
    stream<Property, grpc:Error?> propStream = check rentalClient->list_available_properties(filter);

    io:println("Properties in Windhoek:");
    check propStream.forEach(function(Property p) {
        io:println(" - ", p.name, " ($", p.price_per_night, ")");
    });
}