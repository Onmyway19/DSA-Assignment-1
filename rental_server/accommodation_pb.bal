import ballerina/grpc;
import ballerina/protobuf;

public const string ACCOMMODATION_DESC = "0A136163636F6D6D6F646174696F6E2E70726F746F120D6163636F6D6D6F646174696F6E22C0010A0850726F7065727479121F0A0B70726F70657274795F6964180120012809520A70726F7065727479496412120A046E616D6518022001280952046E616D65121A0A086C6F636174696F6E18032001280952086C6F636174696F6E12230A0D70726F70657274795F74797065180420012809520C70726F70657274795479706512260A0F70726963655F7065725F6E69676874180520012801520D70726963655065724E6967687412160A067374617475731806200128095206737461747573225A0A1050726F7065727479526573706F6E7365121F0A0B70726F70657274795F6964180120012809520A70726F7065727479496412250A0E7374617475735F6D657373616765180220012809520D7374617475734D65737361676522530A0B5573657250726F66696C65121A0A08757365726E616D651801200128095208757365726E616D6512120A04726F6C651802200128095204726F6C6512140A05656D61696C1803200128095205656D61696C22580A13557365724372656174696F6E53756D6D61727912160A06737461747573180120012809520673746174757312290A10746F74616C5F72656769737465726564180220012805520F746F74616C5265676973746572656422500A1552656D6F766550726F706572747952657175657374121F0A0B70726F70657274795F6964180120012809520A70726F7065727479496412160A06726567696F6E1802200128095206726567696F6E22470A0C50726F70657274794C69737412370A0A70726F7065727469657318012003280B32172E6163636F6D6D6F646174696F6E2E50726F7065727479520A70726F7065727469657322470A0C53656172636846696C746572121A0A086C6F636174696F6E18012001280952086C6F636174696F6E121B0A096D61785F707269636518022001280152086D6178507269636522380A1550726F706572747953656172636852657175657374121F0A0B70726F70657274795F6964180120012809520A70726F7065727479496422660A1750726F706572747944657461696C73526573706F6E736512160A06737461747573180120012809520673746174757312330A0870726F706572747918022001280B32172E6163636F6D6D6F646174696F6E2E50726F7065727479520870726F706572747922A2010A0E426F6F6B696E6752657175657374121F0A0B70726F70657274795F6964180120012809520A70726F7065727479496412220A0D636865636B5F696E5F64617465180220012809520B636865636B496E4461746512240A0E636865636B5F6F75745F64617465180320012809520C636865636B4F75744461746512250A0E67756573745F757365726E616D65180420012809520D6775657374557365726E616D6522470A13426F6F6B696E6743617274526573706F6E736512160A06737461747573180120012809520673746174757312180A076D65737361676518022001280952076D657373616765225D0A13436F6E6669726D6174696F6E5265717565737412250A0E67756573745F757365726E616D65180120012809520D6775657374557365726E616D65121F0A0B70726F70657274795F6964180220012809520A70726F70657274794964226D0A13426F6F6B696E67436F6E6669726D6174696F6E121D0A0A626F6F6B696E675F69641801200128095209626F6F6B696E674964121D0A0A746F74616C5F636F73741802200128015209746F74616C436F737412180A076D65737361676518032001280952076D65737361676532AA050A0D52656E74616C5365727669636512470A0B41646450726F706572747912172E6163636F6D6D6F646174696F6E2E50726F70657274791A1F2E6163636F6D6D6F646174696F6E2E50726F7065727479526573706F6E7365124F0A0B4372656174655573657273121A2E6163636F6D6D6F646174696F6E2E5573657250726F66696C651A222E6163636F6D6D6F646174696F6E2E557365724372656174696F6E53756D6D6172792801124A0A0E55706461746550726F706572747912172E6163636F6D6D6F646174696F6E2E50726F70657274791A1F2E6163636F6D6D6F646174696F6E2E50726F7065727479526573706F6E736512530A0E52656D6F766550726F706572747912242E6163636F6D6D6F646174696F6E2E52656D6F766550726F7065727479526571756573741A1B2E6163636F6D6D6F646174696F6E2E50726F70657274794C69737412510A174C697374417661696C61626C6550726F70657274696573121B2E6163636F6D6D6F646174696F6E2E53656172636846696C7465721A172E6163636F6D6D6F646174696F6E2E50726F70657274793001125E0A0E53656172636850726F706572747912242E6163636F6D6D6F646174696F6E2E50726F7065727479536561726368526571756573741A262E6163636F6D6D6F646174696F6E2E50726F706572747944657461696C73526573706F6E736512510A0C426F6F6B50726F7065727479121D2E6163636F6D6D6F646174696F6E2E426F6F6B696E67526571756573741A222E6163636F6D6D6F646174696F6E2E426F6F6B696E6743617274526573706F6E736512580A0E436F6E6669726D426F6F6B696E6712222E6163636F6D6D6F646174696F6E2E436F6E6669726D6174696F6E526571756573741A222E6163636F6D6D6F646174696F6E2E426F6F6B696E67436F6E6669726D6174696F6E620670726F746F33";

public isolated client class RentalServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ACCOMMODATION_DESC);
    }

    isolated remote function AddProperty(Property|ContextProperty req) returns PropertyResponse|grpc:Error {
        map<string|string[]> headers = {};
        Property message;
        if req is ContextProperty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("accommodation.RentalService/AddProperty", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PropertyResponse>result;
    }

    isolated remote function AddPropertyContext(Property|ContextProperty req) returns ContextPropertyResponse|grpc:Error {
        map<string|string[]> headers = {};
        Property message;
        if req is ContextProperty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("accommodation.RentalService/AddProperty", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PropertyResponse>result, headers: respHeaders};
    }

    isolated remote function UpdateProperty(Property|ContextProperty req) returns PropertyResponse|grpc:Error {
        map<string|string[]> headers = {};
        Property message;
        if req is ContextProperty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("accommodation.RentalService/UpdateProperty", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PropertyResponse>result;
    }

    isolated remote function UpdatePropertyContext(Property|ContextProperty req) returns ContextPropertyResponse|grpc:Error {
        map<string|string[]> headers = {};
        Property message;
        if req is ContextProperty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("accommodation.RentalService/UpdateProperty", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PropertyResponse>result, headers: respHeaders};
    }

    isolated remote function RemoveProperty(RemovePropertyRequest|ContextRemovePropertyRequest req) returns PropertyList|grpc:Error {
        map<string|string[]> headers = {};
        RemovePropertyRequest message;
        if req is ContextRemovePropertyRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("accommodation.RentalService/RemoveProperty", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PropertyList>result;
    }

    isolated remote function RemovePropertyContext(RemovePropertyRequest|ContextRemovePropertyRequest req) returns ContextPropertyList|grpc:Error {
        map<string|string[]> headers = {};
        RemovePropertyRequest message;
        if req is ContextRemovePropertyRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("accommodation.RentalService/RemoveProperty", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PropertyList>result, headers: respHeaders};
    }

    isolated remote function SearchProperty(PropertySearchRequest|ContextPropertySearchRequest req) returns PropertyDetailsResponse|grpc:Error {
        map<string|string[]> headers = {};
        PropertySearchRequest message;
        if req is ContextPropertySearchRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("accommodation.RentalService/SearchProperty", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PropertyDetailsResponse>result;
    }

    isolated remote function SearchPropertyContext(PropertySearchRequest|ContextPropertySearchRequest req) returns ContextPropertyDetailsResponse|grpc:Error {
        map<string|string[]> headers = {};
        PropertySearchRequest message;
        if req is ContextPropertySearchRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("accommodation.RentalService/SearchProperty", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PropertyDetailsResponse>result, headers: respHeaders};
    }

    isolated remote function BookProperty(BookingRequest|ContextBookingRequest req) returns BookingCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        BookingRequest message;
        if req is ContextBookingRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("accommodation.RentalService/BookProperty", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <BookingCartResponse>result;
    }

    isolated remote function BookPropertyContext(BookingRequest|ContextBookingRequest req) returns ContextBookingCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        BookingRequest message;
        if req is ContextBookingRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("accommodation.RentalService/BookProperty", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <BookingCartResponse>result, headers: respHeaders};
    }

    isolated remote function ConfirmBooking(ConfirmationRequest|ContextConfirmationRequest req) returns BookingConfirmation|grpc:Error {
        map<string|string[]> headers = {};
        ConfirmationRequest message;
        if req is ContextConfirmationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("accommodation.RentalService/ConfirmBooking", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <BookingConfirmation>result;
    }

    isolated remote function ConfirmBookingContext(ConfirmationRequest|ContextConfirmationRequest req) returns ContextBookingConfirmation|grpc:Error {
        map<string|string[]> headers = {};
        ConfirmationRequest message;
        if req is ContextConfirmationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("accommodation.RentalService/ConfirmBooking", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <BookingConfirmation>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("accommodation.RentalService/CreateUsers");
        return new CreateUsersStreamingClient(sClient);
    }

    isolated remote function ListAvailableProperties(SearchFilter|ContextSearchFilter req) returns stream<Property, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        SearchFilter message;
        if req is ContextSearchFilter {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("accommodation.RentalService/ListAvailableProperties", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        PropertyStream outputStream = new PropertyStream(result);
        return new stream<Property, grpc:Error?>(outputStream);
    }

    isolated remote function ListAvailablePropertiesContext(SearchFilter|ContextSearchFilter req) returns ContextPropertyStream|grpc:Error {
        map<string|string[]> headers = {};
        SearchFilter message;
        if req is ContextSearchFilter {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("accommodation.RentalService/ListAvailableProperties", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        PropertyStream outputStream = new PropertyStream(result);
        return {content: new stream<Property, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public isolated client class CreateUsersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUserProfile(UserProfile message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUserProfile(ContextUserProfile message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveUserCreationSummary() returns UserCreationSummary|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <UserCreationSummary>payload;
        }
    }

    isolated remote function receiveContextUserCreationSummary() returns ContextUserCreationSummary|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <UserCreationSummary>payload, headers: headers};
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

public isolated client class RentalServicePropertyResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendPropertyResponse(PropertyResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextPropertyResponse(ContextPropertyResponse response) returns grpc:Error? {
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

public isolated client class RentalServiceUserCreationSummaryCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUserCreationSummary(UserCreationSummary response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUserCreationSummary(ContextUserCreationSummary response) returns grpc:Error? {
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

public isolated client class RentalServicePropertyDetailsResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendPropertyDetailsResponse(PropertyDetailsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextPropertyDetailsResponse(ContextPropertyDetailsResponse response) returns grpc:Error? {
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

public type ContextUserProfileStream record {|
    stream<UserProfile, error?> content;
    map<string|string[]> headers;
|};

public type ContextPropertyStream record {|
    stream<Property, error?> content;
    map<string|string[]> headers;
|};

public type ContextPropertySearchRequest record {|
    PropertySearchRequest content;
    map<string|string[]> headers;
|};

public type ContextUserProfile record {|
    UserProfile content;
    map<string|string[]> headers;
|};

public type ContextBookingCartResponse record {|
    BookingCartResponse content;
    map<string|string[]> headers;
|};

public type ContextSearchFilter record {|
    SearchFilter content;
    map<string|string[]> headers;
|};

public type ContextUserCreationSummary record {|
    UserCreationSummary content;
    map<string|string[]> headers;
|};

public type ContextPropertyResponse record {|
    PropertyResponse content;
    map<string|string[]> headers;
|};

public type ContextPropertyList record {|
    PropertyList content;
    map<string|string[]> headers;
|};

public type ContextBookingRequest record {|
    BookingRequest content;
    map<string|string[]> headers;
|};

public type ContextRemovePropertyRequest record {|
    RemovePropertyRequest content;
    map<string|string[]> headers;
|};

public type ContextBookingConfirmation record {|
    BookingConfirmation content;
    map<string|string[]> headers;
|};

public type ContextPropertyDetailsResponse record {|
    PropertyDetailsResponse content;
    map<string|string[]> headers;
|};

public type ContextProperty record {|
    Property content;
    map<string|string[]> headers;
|};

public type ContextConfirmationRequest record {|
    ConfirmationRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type PropertySearchRequest record {|
    string property_id = "";
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type UserProfile record {|
    string username = "";
    string role = "";
    string email = "";
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type BookingCartResponse record {|
    string status = "";
    string message = "";
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type SearchFilter record {|
    string location = "";
    float max_price = 0.0;
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type UserCreationSummary record {|
    string status = "";
    int total_registered = 0;
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type PropertyResponse record {|
    string property_id = "";
    string status_message = "";
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type PropertyList record {|
    Property[] properties = [];
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type BookingRequest record {|
    string property_id = "";
    string check_in_date = "";
    string check_out_date = "";
    string guest_username = "";
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type RemovePropertyRequest record {|
    string property_id = "";
    string region = "";
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type BookingConfirmation record {|
    string booking_id = "";
    float total_cost = 0.0;
    string message = "";
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type PropertyDetailsResponse record {|
    string status = "";
    Property property = {};
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type Property record {|
    string property_id = "";
    string name = "";
    string location = "";
    string property_type = "";
    float price_per_night = 0.0;
    string status = "";
|};

@protobuf:Descriptor {value: ACCOMMODATION_DESC}
public type ConfirmationRequest record {|
    string guest_username = "";
    string property_id = "";
|};
