unlockRange = 3



RegisterNetEvent("az_unlockDoor")
AddEventHandler("az_unlockDoor", function(id)
    state = exports.ox_doorlock:getDoor(id)['state']
    if state == 0 then
        state = true
    else
        state = false
    end
    exports.ox_doorlock:setDoorState(id, state)
    
end)


RegisterNetEvent("az_getData")
AddEventHandler("az_getData", function(source)
    src = source
    dump = MySQL.query.await("SELECT * FROM `ox_doorlock`")
    if dump then
        for i = 1, #dump do
            id = dump[i]["id"]
            dump_data = json.decode(dump[i]["data"])
            coords = json.encode(dump_data["coords"])
            heading = 0--dump_data["doors"][1]["heading"]
            TriggerClientEvent("az_lockpick", src, coords, heading, id)
        end
    end
end)


RegisterNetEvent("az_sSound")
AddEventHandler("az_sSound", function (pos)
    TriggerClientEvent("az_clSound", -1, pos)
end)




lib.callback.register("az_test", function(source, pos)
    job = exports["es_extended"]:getSharedObject().GetPlayerFromId(source).getJob().name
    hasJob = false
    for i = 1 , #Config.policeJobs do
        if Config.policeJobs[i] == job then
            hasJob = true
        end
    end
    
    if not dump then getDoorData() end
    
    if dump and hasJob then
        for i = 1, #dump do
            row = json.decode(dump[i].data)
            pos2 = vector3(row.coords.x, row.coords.y, row.coords.z)
            local dist = #(pos - pos2)
            if dist <= unlockRange then
                id = dump[i].id
                state = exports.ox_doorlock:getDoor(id)['state']
                if state == 0 then
                    state = true
                else
                    state = false
                end
                exports.ox_doorlock:setDoorState(id, state)
            end
        end
    end
end)


function getDoorData()
    dump = MySQL.query.await("SELECT * FROM `ox_doorlock`")
end

exports["es_extended"]:getSharedObject().RegisterUsableItem("beranidlo", function(playerId)
    job = exports["es_extended"]:getSharedObject().GetPlayerFromId(playerId).getJob().name
    hasJob = false
    for i = 1 , #Config.policeJobs do
        if Config.policeJobs[i] == job then
            hasJob = true
        end
    end
    if hasJob then
    TriggerClientEvent("az_beranidlo:beruse", playerId)
    end
end)


exports["es_extended"]:getSharedObject().RegisterUsableItem("pd_hacktool", function(playerId)
    job = exports["es_extended"]:getSharedObject().GetPlayerFromId(playerId).getJob().name
    hasJob = false
    for i = 1 , #Config.policeJobs do
        if Config.policeJobs[i] == job then
            hasJob = true
        end
    end
    if hasJob then
    TriggerClientEvent("az_beranidlo:hackuse", playerId)
    end
end)

exports["es_extended"]:getSharedObject().RegisterUsableItem("pd_lockpick", function(playerId)
    job = exports["es_extended"]:getSharedObject().GetPlayerFromId(playerId).getJob().name
    hasJob = false
    for i = 1 , #Config.policeJobs do
        if Config.policeJobs[i] == job then
            hasJob = true
        end
    end
    if hasJob then
    TriggerClientEvent("az_beranidlo:lockuse", playerId)
    end
end)