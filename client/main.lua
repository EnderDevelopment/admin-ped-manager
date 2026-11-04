-- Client-side script for admin ped management

local QBCore = exports['qb-core']:GetCoreObject()

-- Load configuration
local Config = {}

Citizen.CreateThread(function()
    while not QBCore do
        Citizen.Wait(200)
    end
    Config = LoadResourceFile(GetCurrentResourceName(), 'config.lua')
    Config = json.decode(Config)
end)

-- Event to add a ped
RegisterNetEvent('ender_pedmanagement:addPed')
AddEventHandler('ender_pedmanagement:addPed', function(model, stash)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Citizen.Wait(1)
    end
    
    local ped = CreatePed(4, GetHashKey(model), coords.x, coords.y, coords.z, heading, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    
    -- Add inventory and stash functionality
    -- Example: Open stash when interacting with the ped
    exports['qb-inventory']:OpenStash(stash)
    
    -- Save ped data
    local pedData = {
        model = model,
        coords = coords,
        heading = heading,
        stash = stash
    }
    TriggerServerEvent('ender_pedmanagement:savePedData', pedData)
end)