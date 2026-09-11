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

type Institution record {
    string name;
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

type ErrorDetail record {
    string message;
    string path?;
};

const string[] VALID_STATUSES = ["AVAILABLE", "LOANED_OUT", "OCCUPIED", "UNDER_MAINTENANCE", "DISPOSED"];

function isValidStatus(string status) returns boolean {
    return VALID_STATUSES.indexOf(status) is int;
}

function badRequest(string message, string path) returns http:BadRequest {
    ErrorDetail err = {message: message, path: path};
    return {body: err};
}

function notFound(string message, string path) returns http:NotFound {
    ErrorDetail err = {message: message, path: path};
    return {body: err};
}

map<Institution> institutions = {};
map<Asset> assets = {};

service /library on new http:Listener(8080) {
    resource function post assets(@http:Payload Asset newAsset)
            returns Asset|http:Conflict|http:BadRequest {
        if newAsset.assetTag.trim().length() == 0 {
            return badRequest("assetTag is required", "/assets");
        }
        if !isValidStatus(newAsset.status) {
            return badRequest(string `status must be one of ${VALID_STATUSES.toBalString()}`, "/assets");
        }
        if assets.hasKey(newAsset.assetTag) {
            return http:CONFLICT;
        }
        assets[newAsset.assetTag] = newAsset;
        return newAsset;
    }

    resource function get assets() returns Asset[] {
        return assets.toArray();
    }

    resource function get assets/[string assetTag]() returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag);
        }
        return assets.get(assetTag);
    }

    resource function put assets/[string assetTag](@http:Payload Asset updateAsset)
            returns Asset|http:NotFound|http:BadRequest {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag);
        }
        if !isValidStatus(updateAsset.status) {
            return badRequest(string `status must be one of ${VALID_STATUSES.toBalString()}`, "/assets/" + assetTag);
        }
        assets[assetTag] = updateAsset;
        return updateAsset;
    }

    resource function delete assets/[string assetTag]() returns http:NoContent|http:NotFound {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag);
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

    resource function post institutions(@http:Payload Institution newInstitution)
            returns Institution|http:Conflict|http:BadRequest {
        if newInstitution.name.trim().length() == 0 {
            return badRequest("institution name is required", "/institutions");
        }
        if institutions.hasKey(newInstitution.name) {
            return http:CONFLICT;
        }
        institutions[newInstitution.name] = newInstitution;
        return newInstitution;
    }

    resource function get institutions() returns Institution[] {
        return institutions.toArray();
    }

    resource function get institutions/[string name]() returns Institution|http:NotFound {
        if !institutions.hasKey(name) {
            return notFound("no institution named " + name, "/institutions/" + name);
        }
        return institutions.get(name);
    }

    resource function delete institutions/[string name]() returns http:NoContent|http:NotFound {
        if !institutions.hasKey(name) {
            return notFound("no institution named " + name, "/institutions/" + name);
        }
        Institution _ = institutions.remove(name);
        return http:NO_CONTENT;
    }

    resource function post assets/[string assetTag]/schedules(@http:Payload Schedule newSchedule)
            returns Asset|http:NotFound|http:BadRequest {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag + "/schedules");
        }
        if newSchedule.scheduleId.trim().length() == 0 {
            return badRequest("scheduleId is required", "/assets/" + assetTag + "/schedules");
        }
        Asset asset = assets.get(assetTag);
        asset.schedules.push(newSchedule);
        assets[assetTag] = asset;
        return asset;
    }

    resource function put assets/[string assetTag]/schedules/[string scheduleId]
            (@http:Payload Schedule updatedSchedule) returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag + "/schedules/" + scheduleId);
        }
        Asset asset = assets.get(assetTag);
        boolean found = false;
        Schedule[] updated = [];
        foreach Schedule s in asset.schedules {
            if s.scheduleId == scheduleId {
                updated.push(updatedSchedule);
                found = true;
            } else {
                updated.push(s);
            }
        }
        if !found {
            return notFound("no schedule " + scheduleId + " on asset " + assetTag,
                    "/assets/" + assetTag + "/schedules/" + scheduleId);
        }
        asset.schedules = updated;
        assets[assetTag] = asset;
        return asset;
    }

    resource function delete assets/[string assetTag]/schedules/[string scheduleId]()
            returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag + "/schedules/" + scheduleId);
        }
        Asset asset = assets.get(assetTag);
        asset.schedules = from Schedule s in asset.schedules
            where s.scheduleId != scheduleId
            select s;
        assets[assetTag] = asset;
        return asset;
    }

    resource function post assets/[string assetTag]/components(@http:Payload Component newComponent)
            returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag + "/components");
        }
        Asset asset = assets.get(assetTag);
        asset.components.push(newComponent);
        assets[assetTag] = asset;
        return asset;
    }

    resource function delete assets/[string assetTag]/components/[string compId]()
            returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag + "/components/" + compId);
        }
        Asset asset = assets.get(assetTag);
        asset.components = from Component c in asset.components
            where c.compId != compId
            select c;
        assets[assetTag] = asset;
        return asset;
    }

    resource function post assets/[string assetTag]/workorders(@http:Payload WorkOrder newWorkOrder)
            returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag + "/workorders");
        }
        Asset asset = assets.get(assetTag);
        asset.workOrders.push(newWorkOrder);
        assets[assetTag] = asset;
        return asset;
    }

    resource function put assets/[string assetTag]/workorders/[string orderId]
            (@http:Payload WorkOrder updatedWorkOrder) returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag + "/workorders/" + orderId);
        }
        Asset asset = assets.get(assetTag);
        WorkOrder[] updatedOrders = [];
        foreach WorkOrder wo in asset.workOrders {
            updatedOrders.push(wo.orderId == orderId ? updatedWorkOrder : wo);
        }
        asset.workOrders = updatedOrders;
        assets[assetTag] = asset;
        return asset;
    }

    resource function delete assets/[string assetTag]/workorders/[string orderId]()
            returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag + "/workorders/" + orderId);
        }
        Asset asset = assets.get(assetTag);
        asset.workOrders = from WorkOrder wo in asset.workOrders
            where wo.orderId != orderId
            select wo;
        assets[assetTag] = asset;
        return asset;
    }

    resource function post assets/[string assetTag]/workorders/[string orderId]/tasks(@http:Payload Task newTask)
            returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag + "/workorders/" + orderId + "/tasks");
        }
        Asset asset = assets.get(assetTag);
        boolean woFound = false;
        foreach int i in 0 ..< asset.workOrders.length() {
            if asset.workOrders[i].orderId == orderId {
                asset.workOrders[i].tasks.push(newTask);
                woFound = true;
            }
        }
        if !woFound {
            return notFound("no work order " + orderId + " on asset " + assetTag,
                    "/assets/" + assetTag + "/workorders/" + orderId + "/tasks");
        }
        assets[assetTag] = asset;
        return asset;
    }

    resource function put assets/[string assetTag]/workorders/[string orderId]/tasks/[string taskId]
            (@http:Payload Task updatedTask) returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag);
        }
        Asset asset = assets.get(assetTag);
        boolean taskFound = false;
        foreach int i in 0 ..< asset.workOrders.length() {
            if asset.workOrders[i].orderId == orderId {
                Task[] tasks = asset.workOrders[i].tasks;
                foreach int j in 0 ..< tasks.length() {
                    if tasks[j].taskId == taskId {
                        tasks[j] = updatedTask;
                        taskFound = true;
                    }
                }
            }
        }
        if !taskFound {
            return notFound("no task " + taskId + " on work order " + orderId,
                    "/assets/" + assetTag + "/workorders/" + orderId + "/tasks/" + taskId);
        }
        assets[assetTag] = asset;
        return asset;
    }

    resource function delete assets/[string assetTag]/workorders/[string orderId]/tasks/[string taskId]()
            returns Asset|http:NotFound {
        if !assets.hasKey(assetTag) {
            return notFound("no asset with tag " + assetTag, "/assets/" + assetTag);
        }
        Asset asset = assets.get(assetTag);
        boolean woFound = false;
        foreach int i in 0 ..< asset.workOrders.length() {
            if asset.workOrders[i].orderId == orderId {
                asset.workOrders[i].tasks = from Task t in asset.workOrders[i].tasks
                    where t.taskId != taskId
                    select t;
                woFound = true;
            }
        }
        if !woFound {
            return notFound("no work order " + orderId + " on asset " + assetTag,
                    "/assets/" + assetTag + "/workorders/" + orderId);
        }
        assets[assetTag] = asset;
        return asset;
    }
}
