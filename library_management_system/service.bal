import ballerina/http;
import ballerina/time;

// ==============================
// COMPONENT
// ==============================

public type Component record {|
    string compId;
    string name;
    string description;
|};


// ==============================
// SCHEDULE
// ==============================

public type Schedule record {|
    string scheduleId;
    string type;
    string dueDate;
    string description;
|};


// ==============================
// TASK
// ==============================

public type Task record {|
    string taskId;
    string description;
    string status;
|};


// ==============================
// WORK ORDER
// ==============================

public type WorkOrder record {|
    string orderId;
    string status;
    string description;
    Task[] tasks;
|};


// ==============================
// ASSET
// ==============================

public type Asset record {|
    readonly string assetTag;
    string name;
    string description;
    string institution;
    string site;
    string dateAcquired;
    string status;
    Component[] components;
    Schedule[] schedules;
    WorkOrder[] workOrders;
|};


// ==============================
// DATA STORAGE
// ==============================

table<Asset> key(assetTag) assetsTable = table [];
service /library on new http:Listener(9090) {

    resource function post assets(@http:Payload Asset asset)
        returns http:Response|error {

        if assetsTable.hasKey(asset.assetTag) {
            return <http:Response>{
                statusCode: 409,
                body: {
                    error: "Asset already exists."
                }
            };
        }

        assetsTable.add(asset);

        return <http:Response>{
            statusCode: 201,
            body: {
                message: "Asset created successfully.",
                assetTag: asset.assetTag
            }
        };
    }
}
resource function get assets()
        returns Asset[]|error {

    Asset[] result = [];

    foreach Asset asset in assetsTable {
        result.push(asset);
    }

    return result;
}
resource function put assets/[string assetTag](@http:Payload Asset updatedAsset)
        returns http:Response|error {

    if !assetsTable.hasKey(assetTag) {
        return <http:Response>{
            statusCode: 404,
            body: {
                error: "Asset not found."
            }
        };
    }

    Asset newAsset = {
        assetTag: assetTag,
        name: updatedAsset.name,
        description: updatedAsset.description,
        institution: updatedAsset.institution,
        site: updatedAsset.site,
        dateAcquired: updatedAsset.dateAcquired,
        status: updatedAsset.status,
        components: updatedAsset.components,
        schedules: updatedAsset.schedules,
        workOrders: updatedAsset.workOrders
    };

    assetsTable.put(newAsset);

    return <http:Response>{
        statusCode: 200,
        body: {
            message: "Asset updated successfully."
        }
    };
}
resource function delete assets/[string assetTag]()
        returns http:Response|error {

    if !assetsTable.hasKey(assetTag) {
        return <http:Response>{
            statusCode: 404,
            body: {
                error: "Asset not found."
            }
        };
    }

    _ = assetsTable.remove(assetTag);

    return <http:Response>{
        statusCode: 200,
        body: {
            message: "Asset deleted successfully."
        }
    };
}