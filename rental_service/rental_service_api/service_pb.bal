import ballerina/grpc;
import ballerina/protobuf;

public const string SERVICE_DESC = "0A0D736572766963652E70726F746F120672656E74616C22C0010A0850726F7065727479121F0A0B70726F70657274795F6964180120012809520A70726F7065727479496412120A046E616D6518022001280952046E616D65121A0A086C6F636174696F6E18032001280952086C6F636174696F6E12230A0D70726F70657274795F74797065180420012809520C70726F70657274795479706512260A0F70726963655F7065725F6E69676874180520012801520D70726963655065724E6967687412160A067374617475731806200128095206737461747573222D0A0A50726F70657274794964121F0A0B70726F70657274795F6964180120012809520A70726F70657274794964226C0A0C536561726368526573756C7412140A05666F756E641801200128085205666F756E64122C0A0870726F706572747918022001280B32102E72656E74616C2E50726F7065727479520870726F706572747912180A076D65737361676518032001280952076D65737361676522400A0C50726F70657274794C69737412300A0A70726F7065727469657318012003280B32102E72656E74616C2E50726F7065727479520A70726F70657274696573225D0A045573657212170A07757365725F6964180120012809520675736572496412120A046E616D6518022001280952046E616D6512120A04726F6C651803200128095204726F6C6512140A05656D61696C1804200128095205656D61696C22590A18557365724372656174696F6E436F6E6669726D6174696F6E12230A0D746F74616C5F63726561746564180120012805520C746F74616C4372656174656412180A076D65737361676518022001280952076D65737361676522490A0E50726F706572747946696C746572121A0A086C6F636174696F6E18012001280952086C6F636174696F6E121B0A096D61785F707269636518022001280152086D617850726963652284010A0E426F6F6B696E6752657175657374121F0A0B70726F70657274795F6964180120012809520A70726F7065727479496412190A0867756573745F696418022001280952076775657374496412190A08636865636B5F696E1803200128095207636865636B496E121B0A09636865636B5F6F75741804200128095208636865636B4F7574224B0A13426F6F6B696E6743617274526573706F6E7365121A0A0861636365707465641801200128085208616363657074656412180A076D65737361676518022001280952076D657373616765226C0A13426F6F6B696E67436F6E6669726D6174696F6E121C0A09636F6E6669726D65641801200128085209636F6E6669726D6564121D0A0A746F74616C5F636F73741802200128015209746F74616C436F737412180A076D65737361676518032001280952076D657373616765328D040A0D52656E74616C5365727669636512320A0C6164645F70726F706572747912102E72656E74616C2E50726F70657274791A102E72656E74616C2E50726F706572747912350A0F7570646174655F70726F706572747912102E72656E74616C2E50726F70657274791A102E72656E74616C2E50726F7065727479123B0A0F72656D6F76655F70726F706572747912122E72656E74616C2E50726F706572747949641A142E72656E74616C2E50726F70657274794C697374123B0A0F7365617263685F70726F706572747912122E72656E74616C2E50726F706572747949641A142E72656E74616C2E536561726368526573756C7412400A0C6372656174655F7573657273120C2E72656E74616C2E557365721A202E72656E74616C2E557365724372656174696F6E436F6E6669726D6174696F6E280112470A196C6973745F617661696C61626C655F70726F7065727469657312162E72656E74616C2E50726F706572747946696C7465721A102E72656E74616C2E50726F7065727479300112440A0D626F6F6B5F70726F706572747912162E72656E74616C2E426F6F6B696E67526571756573741A1B2E72656E74616C2E426F6F6B696E6743617274526573706F6E736512460A0F636F6E6669726D5F626F6F6B696E6712162E72656E74616C2E426F6F6B696E67526571756573741A1B2E72656E74616C2E426F6F6B696E67436F6E6669726D6174696F6E620670726F746F33";

public isolated client class RentalServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SERVICE_DESC);
    }

    isolated remote function add_property(Property|ContextProperty req) returns Property|grpc:Error {
        map<string|string[]> headers = {};
        Property message;
        if req is ContextProperty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("rental.RentalService/add_property", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Property>result;
    }

    isolated remote function add_propertyContext(Property|ContextProperty req) returns ContextProperty|grpc:Error {
        map<string|string[]> headers = {};
        Property message;
        if req is ContextProperty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("rental.RentalService/add_property", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Property>result, headers: respHeaders};
    }

    isolated remote function update_property(Property|ContextProperty req) returns Property|grpc:Error {
        map<string|string[]> headers = {};
        Property message;
        if req is ContextProperty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("rental.RentalService/update_property", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Property>result;
    }

    isolated remote function update_propertyContext(Property|ContextProperty req) returns ContextProperty|grpc:Error {
        map<string|string[]> headers = {};
        Property message;
        if req is ContextProperty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("rental.RentalService/update_property", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Property>result, headers: respHeaders};
    }

    isolated remote function remove_property(PropertyId|ContextPropertyId req) returns PropertyList|grpc:Error {
        map<string|string[]> headers = {};
        PropertyId message;
        if req is ContextPropertyId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("rental.RentalService/remove_property", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PropertyList>result;
    }

    isolated remote function remove_propertyContext(PropertyId|ContextPropertyId req) returns ContextPropertyList|grpc:Error {
        map<string|string[]> headers = {};
        PropertyId message;
        if req is ContextPropertyId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("rental.RentalService/remove_property", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PropertyList>result, headers: respHeaders};
    }

    isolated remote function search_property(PropertyId|ContextPropertyId req) returns SearchResult|grpc:Error {
        map<string|string[]> headers = {};
        PropertyId message;
        if req is ContextPropertyId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("rental.RentalService/search_property", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SearchResult>result;
    }

    isolated remote function search_propertyContext(PropertyId|ContextPropertyId req) returns ContextSearchResult|grpc:Error {
        map<string|string[]> headers = {};
        PropertyId message;
        if req is ContextPropertyId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("rental.RentalService/search_property", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SearchResult>result, headers: respHeaders};
    }

    isolated remote function book_property(BookingRequest|ContextBookingRequest req) returns BookingCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        BookingRequest message;
        if req is ContextBookingRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("rental.RentalService/book_property", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <BookingCartResponse>result;
    }

    isolated remote function book_propertyContext(BookingRequest|ContextBookingRequest req) returns ContextBookingCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        BookingRequest message;
        if req is ContextBookingRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("rental.RentalService/book_property", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <BookingCartResponse>result, headers: respHeaders};
    }

    isolated remote function confirm_booking(BookingRequest|ContextBookingRequest req) returns BookingConfirmation|grpc:Error {
        map<string|string[]> headers = {};
        BookingRequest message;
        if req is ContextBookingRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("rental.RentalService/confirm_booking", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <BookingConfirmation>result;
    }

    isolated remote function confirm_bookingContext(BookingRequest|ContextBookingRequest req) returns ContextBookingConfirmation|grpc:Error {
        map<string|string[]> headers = {};
        BookingRequest message;
        if req is ContextBookingRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("rental.RentalService/confirm_booking", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <BookingConfirmation>result, headers: respHeaders};
    }

    isolated remote function create_users() returns Create_usersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("rental.RentalService/create_users");
        return new Create_usersStreamingClient(sClient);
    }

    isolated remote function list_available_properties(PropertyFilter|ContextPropertyFilter req) returns stream<Property, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        PropertyFilter message;
        if req is ContextPropertyFilter {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("rental.RentalService/list_available_properties", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        PropertyStream outputStream = new PropertyStream(result);
        return new stream<Property, grpc:Error?>(outputStream);
    }

    isolated remote function list_available_propertiesContext(PropertyFilter|ContextPropertyFilter req) returns ContextPropertyStream|grpc:Error {
        map<string|string[]> headers = {};
        PropertyFilter message;
        if req is ContextPropertyFilter {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("rental.RentalService/list_available_properties", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        PropertyStream outputStream = new PropertyStream(result);
        return {content: new stream<Property, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public isolated client class Create_usersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUser(User message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUser(ContextUser message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveUserCreationConfirmation() returns UserCreationConfirmation|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <UserCreationConfirmation>payload;
        }
    }

    isolated remote function receiveContextUserCreationConfirmation() returns ContextUserCreationConfirmation|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <UserCreationConfirmation>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class PropertyStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Property value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is () {
            return streamValue;
        } else if streamValue is grpc:Error {
            return streamValue;
        } else {
            record {|Property value;|} nextRecord = {value: <Property>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public isolated client class RentalServicePropertyListCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendPropertyList(PropertyList response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextPropertyList(ContextPropertyList response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class RentalServiceUserCreationConfirmationCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUserCreationConfirmation(UserCreationConfirmation response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUserCreationConfirmation(ContextUserCreationConfirmation response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class RentalServiceBookingConfirmationCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBookingConfirmation(BookingConfirmation response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBookingConfirmation(ContextBookingConfirmation response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class RentalServiceBookingCartResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBookingCartResponse(BookingCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBookingCartResponse(ContextBookingCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class RentalServicePropertyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProperty(Property response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProperty(ContextProperty response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class RentalServiceSearchResultCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSearchResult(SearchResult response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSearchResult(ContextSearchResult response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextUserStream record {|
    stream<User, error?> content;
    map<string|string[]> headers;
|};

public type ContextPropertyStream record {|
    stream<Property, error?> content;
    map<string|string[]> headers;
|};

public type ContextPropertyList record {|
    PropertyList content;
    map<string|string[]> headers;
|};

public type ContextUser record {|
    User content;
    map<string|string[]> headers;
|};

public type ContextBookingRequest record {|
    BookingRequest content;
    map<string|string[]> headers;
|};

public type ContextBookingCartResponse record {|
    BookingCartResponse content;
    map<string|string[]> headers;
|};

public type ContextUserCreationConfirmation record {|
    UserCreationConfirmation content;
    map<string|string[]> headers;
|};

public type ContextBookingConfirmation record {|
    BookingConfirmation content;
    map<string|string[]> headers;
|};

public type ContextSearchResult record {|
    SearchResult content;
    map<string|string[]> headers;
|};

public type ContextPropertyFilter record {|
    PropertyFilter content;
    map<string|string[]> headers;
|};

public type ContextProperty record {|
    Property content;
    map<string|string[]> headers;
|};

public type ContextPropertyId record {|
    PropertyId content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SERVICE_DESC}
public type PropertyList record {|
    Property[] properties = [];
|};

@protobuf:Descriptor {value: SERVICE_DESC}
public type User record {|
    string user_id = "";
    string name = "";
    string role = "";
    string email = "";
|};

@protobuf:Descriptor {value: SERVICE_DESC}
public type BookingRequest record {|
    string property_id = "";
    string guest_id = "";
    string check_in = "";
    string check_out = "";
|};

@protobuf:Descriptor {value: SERVICE_DESC}
public type BookingCartResponse record {|
    boolean accepted = false;
    string message = "";
|};

@protobuf:Descriptor {value: SERVICE_DESC}
public type UserCreationConfirmation record {|
    int total_created = 0;
    string message = "";
|};

@protobuf:Descriptor {value: SERVICE_DESC}
public type BookingConfirmation record {|
    boolean confirmed = false;
    float total_cost = 0.0;
    string message = "";
|};

@protobuf:Descriptor {value: SERVICE_DESC}
public type SearchResult record {|
    boolean found = false;
    Property property = {};
    string message = "";
|};

@protobuf:Descriptor {value: SERVICE_DESC}
public type PropertyFilter record {|
    string location = "";
    float max_price = 0.0;
|};

@protobuf:Descriptor {value: SERVICE_DESC}
public type Property record {|
    string property_id = "";
    string name = "";
    string location = "";
    string property_type = "";
    float price_per_night = 0.0;
    string status = "";
|};

@protobuf:Descriptor {value: SERVICE_DESC}
public type PropertyId record {|
    string property_id = "";
|};
