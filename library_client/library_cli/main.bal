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

final http:Client libraryClient = check new ("http://localhost:8080/library");

public function main() returns error? {
    boolean running = true;
    while running {
        printMenu();
        string choice = io:readln("Choose an option: ").trim();
        match choice {
            "1" => { check globalView(); }
            "2" => { check campusView(); }
            "3" => { check loanOrBook(); }
            "4" => { check overdueDashboard(); }
            "5" => { check scheduleManager(); }
            "0" => { running = false; }
            _ => { io:println("Unknown option, try again."); }
        }
        io:println("");
    }
    io:println("Goodbye.");
}

function printMenu() {
    io:println("===== Library & Resource Management CLI =====");
    io:println("1. Global View (all assets)");
    io:println("2. Campus View (filter by institution or site)");
    io:println("3. Loan / Book an asset");
    io:println("4. Overdue Dashboard");
    io:println("5. Schedule Manager");
    io:println("0. Exit");
}

function globalView() returns error? {
    Asset[] allAssets = check libraryClient->/assets;
    if allAssets.length() == 0 {
        io:println("No assets registered yet.");
        return;
    }
    foreach Asset a in allAssets {
        printAssetSummary(a);
    }
}

function campusView() returns error? {
    string mode = io:readln("Filter by (1) institution or (2) site? ").trim();
    Asset[] results;
    if mode == "1" {
        string institution = io:readln("Institution name: ").trim();
        results = check libraryClient->/assets/institution/[institution];
    } else {
        string site = io:readln("Site/campus name: ").trim();
        results = check libraryClient->/assets/site/[site];
    }
    if results.length() == 0 {
        io:println("No matching assets found.");
        return;
    }
    foreach Asset a in results {
        printAssetSummary(a);
    }
}

function loanOrBook() returns error? {
    string assetTag = io:readln("Asset tag to loan/book: ").trim();
    Asset|http:ClientError current = libraryClient->/assets/[assetTag];
    if current is http:ClientError {
        io:println("Could not find asset " + assetTag + ": " + current.message());
        return;
    }
    io:println("Current status: " + current.status);
    string newStatus = io:readln("New status (LOANED_OUT / OCCUPIED / AVAILABLE): ").trim();
    Asset updated = current;
    updated.status = newStatus;
    Asset|http:ClientError result = libraryClient->/assets/[assetTag].put(updated);
    if result is http:ClientError {
        io:println("Update failed: " + result.message());
    } else {
        io:println("Asset " + assetTag + " is now " + result.status);
    }
}

function overdueDashboard() returns error? {
    Asset[] overdue = check libraryClient->/assets/overdue;
    if overdue.length() == 0 {
        io:println("Nothing overdue. All clear.");
        return;
    }
    io:println("--- OVERDUE ASSETS ---");
    foreach Asset a in overdue {
        printAssetSummary(a);
        foreach Schedule s in a.schedules {
            io:println("    schedule " + s.scheduleId + " due " + s.dueDate + " (" + s.scheduleType + ")");
        }
    }
}

function scheduleManager() returns error? {
    string assetTag = io:readln("Asset tag: ").trim();
    string action = io:readln("(1) Add (2) Update (3) Remove schedule: ").trim();

    if action == "1" {
        Schedule newSchedule = {
            scheduleId: io:readln("Schedule ID: ").trim(),
            scheduleType: io:readln("Type (MAINTENANCE/BOOKING/SERVICING): ").trim(),
            dueDate: io:readln("Due date (YYYY-MM-DD): ").trim(),
            description: io:readln("Description: ").trim()
        };
        Asset|http:ClientError result = libraryClient->/assets/[assetTag]/schedules.post(newSchedule);
        reportResult(result);
    } else if action == "2" {
        string scheduleId = io:readln("Schedule ID to update: ").trim();
        Schedule updated = {
            scheduleId: scheduleId,
            scheduleType: io:readln("New type: ").trim(),
            dueDate: io:readln("New due date (YYYY-MM-DD): ").trim(),
            description: io:readln("New description: ").trim()
        };
        Asset|http:ClientError result = libraryClient->/assets/[assetTag]/schedules/[scheduleId].put(updated);
        reportResult(result);
    } else if action == "3" {
        string scheduleId = io:readln("Schedule ID to remove: ").trim();
        Asset|http:ClientError result = libraryClient->/assets/[assetTag]/schedules/[scheduleId].delete();
        reportResult(result);
    } else {
        io:println("Unknown action.");
    }
}

function printAssetSummary(Asset a) {
    io:println(a.assetTag + " | " + a.name + " | " + a.institution + " - " + a.site + " | " + a.status);
}

function reportResult(Asset|http:ClientError result) {
    if result is http:ClientError {
        io:println("Request failed: " + result.message());
    } else {
        io:println("Success. Asset now has " + result.schedules.length().toString() + " schedule(s).");
    }
}
