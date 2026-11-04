-- Server-side script for admin ped management

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

-- Command to add a ped
QBCore.Commands.Add('addped', 'Add a ped with inventory and stash', {{name='model', help='Ped model'}, {name='stash', help='Stash name'}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == 'admin' or Player.PlayerData.job.name == 'owner' then
        local model = args[1]
        local stash = args[2]
        TriggerClientEvent('ender_pedmanagement:addPed', source, model, stash)
    else
        TriggerClientEvent('QBCore:Notify', source, 'You do not have permission to use this command', 'error')
    end
end)

-- Event to save ped data
RegisterNetEvent('ender_pedmanagement:savePedData')
AddEventHandler('ender_pedmanagement:savePedData', function(pedData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == 'admin' or Player.PlayerData.job.name == 'owner' then
        -- Save ped data to database or file
        -- Example: Save to a file
        local file = io.open('peds.json', 'w')
        if file then
            file:write(json.encode(pedData))
            file:close()
        end
    end
end)