import ballerina/http;

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

map<Asset> assets = {};


service /library on new http:Listener(8080) {
    resource function post assets(@http:Payload Asset newAsset) returns Asset|http:Conflict {
        if assets.hasKey(newAsset.assetTag) {
            return http:CONFLICT;
        }
        assets[newAsset.assetTag] = newAsset;
        return newAsset;
    }
    
    resource function get assets() returns Asset[] {
    Asset[] allAssets = assets.toArray();
    return allAssets;
}
}


