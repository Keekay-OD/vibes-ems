local QBCore = exports['qb-core']:GetCoreObject()

local Active = false
local test = nil
local test1 = nil
local spam = true

 


if Config.UseHelpCommand then
    RegisterCommand("ems", function(source, args, raw)
        if (QBCore.Functions.GetPlayerData().metadata["isdead"]) or (QBCore.Functions.GetPlayerData().metadata["inlaststand"]) and spam then
            QBCore.Functions.TriggerCallback('vibes-ems:docOnline', function(EMSOnline, hasEnoughMoney)
                if EMSOnline <= Config.Doctor and hasEnoughMoney and spam then
                    SpawnVehicle(GetEntityCoords(PlayerPedId()))
                    TriggerServerEvent('vibes-ems:charge')
                    TriggerServerEvent('vibes-ems:notify', "The Medic is on his way from the nearest hospital. ", "success")
                else
                    if EMSOnline > Config.Doctor then
                        TriggerServerEvent('vibes-ems:notify', "There are too many medics online", "error")
                    elseif not hasEnoughMoney then
                        TriggerServerEvent('vibes-ems:notify', "Not Enough Money", "error")
                    else
                        TriggerServerEvent('vibes-ems:notify', "Wait, Paramedic is on the way", "primary")
                    end    
                end
            end)
        else
            Notify("This can only be used when dead", "error")
        end
    end)
end

RegisterNetEvent('vibes-ems:client:helpPlayer', function()
    if (QBCore.Functions.GetPlayerData().metadata["isdead"]) or (QBCore.Functions.GetPlayerData().metadata["inlaststand"]) and spam then
        QBCore.Functions.TriggerCallback('vibes-ems:docOnline', function(EMSOnline, hasEnoughMoney)
            if EMSOnline <= Config.Doctor and hasEnoughMoney and spam then
                SpawnVehicle(GetEntityCoords(PlayerPedId()))
                TriggerServerEvent('vibes-ems:notify', "The Medic is on their way from the nearest hospital. ", "success", true)
            else
                if EMSOnline > Config.Doctor then
                    TriggerServerEvent('vibes-ems:notify', "There are too many medics online", "error", true)
                elseif not hasEnoughMoney then
                    TriggerServerEvent('vibes-ems:notify', "Not Enough Money", "error", true)
                else
                    TriggerServerEvent('vibes-ems:notify', "Wait, Paramedic is on the way", "primary", true)
                end
            end
        end)
    else
        TriggerServerEvent('vibes-ems:notify', "This can only be used when dead", "error", true)
    end
end)

function TriggerAmbulanceCall()
    TriggerEvent('vibes-ems:client:helpPlayer')
end

exports('TriggerAmbulanceCall', TriggerAmbulanceCall)


local function getDistanceBetweenCoords(coords1, coords2)
    local dx = coords1.x - coords2.x
    local dy = coords1.y - coords2.y
    local dz = coords1.z - coords2.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function parseVector4String(vector4String)
    local x, y, z, heading = string.match(vector4String, "([^,]+), ([^,]+), ([^,]+), ([^,]+)")
    return { x = tonumber(x), y = tonumber(y), z = tonumber(z), heading = tonumber(heading) }
end

local function getClosestSpawnLocation(playerCoords, spawnLocations)
    local closestDistance = nil
    local closestLocation = nil

    for _, locationString in ipairs(spawnLocations) do
        local location = parseVector4String(locationString)
        local distance = getDistanceBetweenCoords(playerCoords, location)
        if closestDistance == nil or distance < closestDistance then
            closestDistance = distance
            closestLocation = location
        end
    end

    return closestLocation
end

function SpawnVehicle()
    spam = false
    local vehhash = GetHashKey(Config.Vehicle)
    local playerCoords = GetEntityCoords(PlayerPedId())

    RequestModel(vehhash)
    while not HasModelLoaded(vehhash) do
        Wait(1)
    end

    RequestModel('s_m_m_doctor_01')
    while not HasModelLoaded('s_m_m_doctor_01') do
        Wait(1)
    end

    local closestSpawn = getClosestSpawnLocation(playerCoords, Config.VehicleSpawns)

    if closestSpawn and not DoesEntityExist(vehhash) then
        mechVeh = CreateVehicle(vehhash, closestSpawn.x, closestSpawn.y, closestSpawn.z, closestSpawn.heading, true, false)
        ClearAreaOfVehicles(GetEntityCoords(mechVeh), 5000, false, false, false, false, false)
        SetVehicleOnGroundProperly(mechVeh)
        SetVehicleNumberPlateText(mechVeh, "VC EMS")
        SetEntityAsMissionEntity(mechVeh, true, true)
        SetVehicleEngineOn(mechVeh, true, true, false)

        SetVehicleSiren(mechVeh, true)
        SetVehicleHasMutedSirens(mechVeh, Config.MutedSirens)

        mechPed = CreatePedInsideVehicle(mechVeh, 26, GetHashKey('s_m_m_doctor_01'), -1, true, false)

        mechBlip = AddBlipForEntity(mechVeh)
        SetBlipFlashes(mechBlip, true)
        SetBlipColour(mechBlip, 5)

        PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", 1)
        
        Wait(2000) --time to wait before sending help. 
        TaskVehicleDriveToCoord(mechPed, mechVeh, playerCoords.x, playerCoords.y, playerCoords.z, 20.0, 0, GetEntityModel(mechVeh), 524863, 2.0)
        originalSpawnLocation = closestSpawn 
        test = mechVeh
        test1 = mechPed
        Active = true

        -- Calculate distance in miles
        local distanceInMeters = #(vector3(closestSpawn.x, closestSpawn.y, closestSpawn.z) - playerCoords)
        local distanceInMiles = distanceInMeters * 0.000621371

        -- Estimate time of arrival (assuming average speed of 60 mph)
        local estimatedTimeInHours = distanceInMiles / 60
        local estimatedTimeInSeconds = estimatedTimeInHours * 3600

        -- Set up timer
        local timer = 0
        local timerActive = true

        Citizen.CreateThread(function()
            while timerActive do
                Citizen.Wait(1000)
                timer = timer + 1
                
                -- Check if timer has exceeded 2x the estimated time
                if timer > estimatedTimeInSeconds * 2 then
                    timerActive = false
                    DriveAwayFromPlayer()
                    TriggerServerEvent('vibes-ems:notify', "The medic got stuck. Sending another one.", "error", true)
                    SpawnVehicle() -- Spawn a new vehicle
                end

                -- Check if the vehicle has arrived
                if #(GetEntityCoords(mechVeh) - playerCoords) < 5.0 then
                    timerActive = false
                    DoctorNPC()
                end
            end
        end)

        -- Display distance and ETA to the player
        TriggerServerEvent('vibes-ems:notify', string.format("Distance: %.2f miles, ETA: %.2f minutes", distanceInMiles, estimatedTimeInSeconds / 60), "info", true)
    end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        if Active then
            local loc = GetEntityCoords(GetPlayerPed(-1))
            local lc = GetEntityCoords(test)
            local ld = GetEntityCoords(test1)
            local dist = Vdist(loc.x, loc.y, loc.z, lc.x, lc.y, lc.z)
            local dist1 = Vdist(loc.x, loc.y, loc.z, ld.x, ld.y, ld.z)
            if dist <= 15 then
                if Active then
                    SetPedPathAvoidFire(test1, true)
                    SetPedPathCanUseLadders(test1, true)
                    SetPedPathCanDropFromHeight(test1, false)
                    SetPedPathPreferToAvoidWater(test1, true)
                    
                    SetPedPathAvoidFire(test1, false)

                    SetPedMoveRateOverride(test1, 1.0)
                    SetPedPathPreferToAvoidWater(test1, 1.0)

                    TaskFollowNavMeshToCoord(test1, loc.x, loc.y, loc.z, 1.0, -1, 1.0, false, 0.0)
                end
                if dist1 <= 1 then
                    Active = false
                    ClearPedTasksImmediately(test1)
                    DoctorNPC()
                end
            end
        end
    end
end)


function DoctorNPC()
    RequestAnimDict("mini@cpr@char_a@cpr_str")
    while not HasAnimDictLoaded("mini@cpr@char_a@cpr_str") do
        Citizen.Wait(1000)
    end

    TaskPlayAnim(test1, "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
    QBCore.Functions.Progressbar("revive_doc", "The doctor is giving you medical aid", Config.ReviveTime, false, false, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(test1,true)
        Citizen.Wait(500)
        if ClearPedTasks == true then
            TriggerEvent("hospital:client:Revive")
        end
        StopScreenEffect('DeathFailOut')
        TriggerServerEvent('vibes-ems:charge')
        TriggerServerEvent('vibes-ems:notify', "Your treatment is done, you were charged: $" .. Config.Price, "success", false)
        DriveAwayFromPlayer()
        spam = true
    end)
end

function DriveAwayFromPlayer()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local drivingStyle = 786603 
    
    
    TaskVehicleDriveToCoord(mechPed, mechVeh, originalSpawnLocation.x, originalSpawnLocation.y, originalSpawnLocation.z, 20.0, 0, GetEntityModel(mechVeh), drivingStyle, 1.0, true)
    
    local distance = GetDistanceBetweenCoords(GetEntityCoords(mechVeh), originalSpawnLocation.x, originalSpawnLocation.y, originalSpawnLocation.z, true)
    local threshold = 5.0 
    
    while distance > threshold do
        Citizen.Wait(1000)
        distance = GetDistanceBetweenCoords(GetEntityCoords(mechVeh), originalSpawnLocation.x, originalSpawnLocation.y, originalSpawnLocation.z, true)
    end
    
    RemovePedElegantly(test1)
    DeleteEntity(test)
    Wait(5000)
    DeleteEntity(test1)
end
