import ballerina/http;
import ballerina/io;

type MinimalAsset record {
    string assetTag;
    string name;
    string description;
    string institution;
    string site;
    string status;
    string dateAcquired;
    json[] components;
    json[] schedules;
    json[] workOrders;
};

public function main() returns error? {
    http:Client libraryClient = check new ("http://localhost:9090/library");

    io:println("--- STARTING AUTOMATED REST CLIENT TESTS ---");

    MinimalAsset mockAsset = {
        assetTag: "NUST-LAP-001",
        name: "Dell Latitude 5420",
        description: "Core i5, 16GB RAM, 512GB SSD",
        institution: "NUST",
        site: "Main Campus Library",
        status: "AVAILABLE",
        dateAcquired: "2026-02-15",
        components: [],
        schedules: [],
        workOrders: []
    };

    io:println("\n[Test 1] Adding a new library asset via POST...");
    http:Response postResponse = check libraryClient->post("/assets", mockAsset);
    io:println("Server Response Status Code: ", postResponse.statusCode);

    io:println("\n[Test 2] Fetching all assets via GET...");
    MinimalAsset[] totalAssets = check libraryClient->get("/assets");
    foreach var asset in totalAssets {
        io:println("Found Asset -> Tag: ", asset.assetTag, " | Name: ", asset.name, " | Institution: ", asset.institution);
    }
}
