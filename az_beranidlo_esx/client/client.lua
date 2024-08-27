
RegisterNetEvent("az_beranidlo:beruse")
AddEventHandler("az_beranidlo:beruse", function(playerId)
    beranidlo()
end)

function unlock()
    job = exports["es_extended"]:getSharedObject().PlayerData.job.name
    hasJob = false
    for i = 1 , #Config.policeJobs do
        if Config.policeJobs[i] == job then
            hasJob = true
        end
    end
    local playerPed = PlayerPedId()
    if hasJob then
        local pos = GetEntityCoords(playerPed)
        lib.callback.await("az_test", false, pos)
    end
end

local holdingber = false
local ad1 = "weapons@first_person@aim_idle@remote_clone@melee@two_handed@golf_club"
local ad1a = "aim_high_loop"

function beranidlo()
    local playerped = GetPlayerPed(-1)
    --TaskPlayAnim(playerped, "weapons@first_person@aim_idle@remote_clone@melee@two_handed@golf_club", "aim_high_loop", 8.0, 1.0, -1, 49, 1, 0, 0, 0)
    
    local ber = -300463280    --1245865676
    local plyCoords = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 0.0, -5.0)
    --local netid = ObjToNet(berspw)

    if (DoesEntityExist(playerped) and not IsEntityDead(playerped)) then 
        RequestModel(ber)
        loadAnimDict(ad1)
        if holdingber then
            Wait(100)
            ClearPedSecondaryTask(playerped)
            DetachEntity(ber_net, 1, 1)
            DeleteEntity(ber_net)
            berspw = nil
            holdingber = false
            --removeDoors()
        else
            TaskPlayAnim(playerped,ad1, ad1a, 8.0, 1.0, -1, 49, 1, 0, 0, 0)
            Wait(500)
            berspw = CreateObject(ber, plyCoords.x, plyCoords.y, plyCoords.z, true, true, false)
            AttachEntityToEntity(berspw,playerped,GetPedBoneIndex(playerped, 28422),0.0,0.0,0.0,285.0,0.0,340.0,1,1,0,1,0,1)
            Wait(120)
            ber_net = berspw
            holdingber = true
            --TriggerServerEvent("az_getData", GetPlayerServerId(PlayerId()))
            CreateThread(function ()
                while holdingber do
                    Wait(0)
                    if not IsEntityPlayingAnim(playerped,ad1, ad1a, 49) then
                        TaskPlayAnim(playerped,ad1, ad1a, 8.0, 1.0, -1, 49, 1, 0, 0, 0)
                    end
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(0, 140, true)
                    if IsControlJustReleased(0, 38) then
                        berprogress()
                    end
                end
            end)
        end
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do 
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function berprogress()
    if lib.progressBar({
        duration = 2000,
        label = 'Vyrážíš dveře',
        useWhileDead = false,
        canCancel = true,
        disable = {
        combat = true,
        move = true,
        mouse = true
        },
    
    })
    then 
    pos = GetEntityCoords(GetPlayerPed(-1))
    TriggerServerEvent("az_sSound", pos)
    unlock()
     end    
end

RegisterNetEvent("az_clSound")
AddEventHandler("az_clSound", function (pos)
    PlaySoundFromCoord(-1 , "Gate_Lock_Break", pos.x, pos.y, pos.z, "DLC_HEISTS_ORNATE_BANK_FINALE_SOUNDS", 1, 50, 0)
end)

--LOCKPICK

RegisterNetEvent("az_beranidlo:hackuse")
AddEventHandler("az_beranidlo:hackuse", function(playerId)
    job = exports["es_extended"]:getSharedObject().PlayerData.job.name
    hasJob = false
    for i = 1 , #Config.policeJobs do
        if Config.policeJobs[i] == job then
            hasJob = true
        end
    end
    if hasJob then hackprogress() end
end)

RegisterNetEvent("az_beranidlo:lockuse")
AddEventHandler("az_beranidlo:lockuse", function(playerId)
    lockprogress()
end)




function lockprogress()
    if lib.progressBar({
        duration = 10000,
        label = 'Lockpickuješ dveře',
        useWhileDead = false,
        canCancel = true,
        disable = {
        combat = true,
        move = true,
        mouse = true
        },
        anim = {
        dict = 'amb@medic@standing@tendtodead@base',
        clip = 'base',
        },  
    }) then unlock() end    
end

function hackprogress()
    if lib.progressBar({
        duration = 10000,
        label = 'Hackuješ elektronický zámek',
        useWhileDead = false,
        canCancel = true,
        disable = {
        combat = true,
        move = true,
        mouse = true
        },
        anim = {
        dict = 'amb@medic@standing@tendtodead@base',
        clip = 'base',
        },  
    }) 
    then  
        ran = math.random(100)
        if ran >= 50 then
            lib.notify({
                title = 'Nepodařilo se',
                description = 'Nepodařilo se hacknout elektronický zámek a byl jsi zablokován musíš nyní použít hrubou sílu',
                type = 'error'
            }) 
        end
        if ran <= 49 then unlock() end
    end    
end