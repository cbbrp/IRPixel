ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('duty:police')
AddEventHandler('duty:police', function(job)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade

    if job == "police" then
        xPlayer.setJob('offpolice', grade)
            xPlayer.removeWeapon("WEAPON_SMG")
            xPlayer.removeWeapon("WEAPON_STUNGUN")
            xPlayer.removeWeapon("WEAPON_CARBINERIFLE")
            xPlayer.removeWeapon("WEAPON_NIGHTSTICK")
    elseif job == "offpolice" then
        xPlayer.setJob('police', grade)
    end
end)

RegisterServerEvent('duty:ambulance')
AddEventHandler('duty:ambulance', function(job)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade

    if job == "ambulance" then
        xPlayer.setJob('offambulance', grade)
            xPlayer.removeInventoryItem('bandage', 20)
            xPlayer.removeInventoryItem('medikit', 5)
            xPlayer.removeWeapon('WEAPON_FLASHLIGHT', 250)
    elseif job == "offambulance" then
        xPlayer.setJob('ambulance', grade)
            xPlayer.addWeapon('WEAPON_FLASHLIGHT')
    end

end)

RegisterServerEvent('duty:mechanic')
AddEventHandler('duty:mechanic', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = xPlayer.job.name
        local grade = xPlayer.job.grade

        if job == "mecano" then
            xPlayer.setJob('offmecano', grade)
        elseif job == "offmecano" then
            xPlayer.setJob('mecano', grade)
        end
end)

RegisterServerEvent('duty:taxi')
AddEventHandler('duty:taxi', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = xPlayer.job.name
        local grade = xPlayer.job.grade

        if job == "taxi" then
            xPlayer.setJob('offtaxi', grade)
        elseif job == "offtaxi" then
            xPlayer.setJob('taxi', grade)
        end
end)

--notification
function sendNotification(xSource, message, messageType, messageTimeout)
    TriggerClientEvent("pNotify:SendNotification", xSource, {
        text = message,
        type = messageType,
        queue = "qalle",
        timeout = messageTimeout,
        layout = "bottomCenter"
    })
end