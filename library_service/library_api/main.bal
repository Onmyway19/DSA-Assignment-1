import ballerina/http;
import ballerina/time;

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
    resource function get assets/[string assetTag]() returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return http:NOT_FOUND;
        }
        return assets.get(assetTag);
    }
    resource function put assets/[string assetTag](@http:Payload Asset updateAsset) returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return http:NOT_FOUND;
        }
        assets[assetTag] = updateAsset;
        return updateAsset;
    }
    resource function delete assets/[string assetTag]() returns http:NoContent|http:NotFound {
        if !assets.hasKey(assetTag) {
            return http:NOT_FOUND;
        }
        Asset _ = assets.remove(assetTag);
        return http:NO_CONTENT;
    }
    resource function get assets/institution/[string institution]() returns Asset[] {
        return from Asset a in assets
        where a.institution == institution
        select a;
    }
    resource function get assets/site/[string site]() returns Asset[] {
        return from Asset a in assets
        where a.site == site
        select a;
    }

    resource function get assets/overdue() returns Asset[] {
    time:Utc now = time:utcNow();
    time:Civil civil = time:utcToCivil(now);
    string today = string `${civil.year}-${civil.month}-${civil.day}`;

    
    Asset[] overdueAssets = [];
    foreach Asset a in assets {
        foreach Schedule s in a.schedules {
            if s.dueDate < today {
                overdueAssets.push(a);
                break;
            }
        }
    }
    return overdueAssets;
}

}
