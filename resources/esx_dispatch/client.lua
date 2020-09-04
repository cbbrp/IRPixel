ESX = nil
local PlayerData              = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx_dispatch:assignBadge')
AddEventHandler('esx_dispatch:assignBadge',function(label)
   if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
        local id = PlayerId()
        TriggerServerEvent('esx_idoverhead:modifyLabel', id, label)
   end
end)