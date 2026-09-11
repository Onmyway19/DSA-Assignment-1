import ballerina/grpc;
import ballerina/uuid;

map<Property> properties = {};

map<User> users = {};

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
    return {accepted: false, message: "Not implemented yet - G3's responsibility"};
}

remote function confirm_booking(BookingRequest req) returns BookingConfirmation|error {
    return {confirmed: false, total_cost: 0.0, message: "Not implemented yet - G3's responsibility"};
}
}