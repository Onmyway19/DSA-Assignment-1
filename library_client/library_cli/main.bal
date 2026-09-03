import ballerina/http;
import ballerina/io;

type Task record {
    string taskId;
    string description;
};

type WorkOrder record {
    string orderId;
    string status;
    string description;
    Task[] tasks;
};

type Schedule record {
    string scheduleId;
    string scheduleType;
    string dueDate;
    string description;
};

type Component record {
    string compId;
    string name;
    string description;
};

type Asset record {
    string assetTag;
    string name;
    string description;
    string institution;
    string site;
    string status;
    string dateAcquired;
    Component[] components;
    Schedule[] schedules;
    WorkOrder[] workOrders;
};

http:Client libraryClient = check new ("http://localhost:8080/library");

public function main() returns error? {
    Asset[] allAssets = check libraryClient->get("/assets");
    io:println("=== All Assets (Global View) ===");
    foreach Asset a in allAssets {
        io:println(a.assetTag, " | ", a.name, " | ", a.status, " | ", a.institution);
    }
}