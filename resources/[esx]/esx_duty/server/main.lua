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
            xPlayer.removeWeapon("WEAPON_ADVANCEDRIFLE")
            xPlayer.removeWeapon("WEAPON_SPECIALCARBINE")
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
    local bandage = xPlayer.getInventoryItem('bandage')
    local medikit = xPlayer.getInventoryItem('medikit')

    if job == "ambulance" then
        xPlayer.setJob('offambulance', grade)
           if bandage and bandage.count > 0 then xPlayer.removeInventoryItem('bandage', bandage.count) end 
           if medikit and medikit.count > 0 then xPlayer.removeInventoryItem('medikit', medikit.count) end 
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

RegisterServerEvent('duty:coffee')
AddEventHandler('duty:coffee', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = xPlayer.job.name
        local grade = xPlayer.job.grade

        if job == "coffee" then
            xPlayer.setJob('offcoffee', grade)
        elseif job == "offcoffee" then
            xPlayer.setJob('coffee', grade)
        end
end)

RegisterServerEvent('duty:weazel')
AddEventHandler('duty:weazel', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = xPlayer.job.name
        local grade = xPlayer.job.grade

        if job == "weazel" then
            xPlayer.setJob('offweazel', grade)
        elseif job == "offweazel" then
            xPlayer.setJob('weazel', grade)
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

RegisterServerEvent('duty:doc')
AddEventHandler('duty:doc', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = xPlayer.job.name
        local grade = xPlayer.job.grade

        if job == "doc" then
            xPlayer.removeWeapon("WEAPON_STUNGUN")
            xPlayer.removeWeapon("WEAPON_CARBINERIFLE")
            xPlayer.removeWeapon("WEAPON_NIGHTSTICK")
            xPlayer.removeWeapon("WEAPON_HEAVYSNIPER")
            xPlayer.setJob('offdoc', grade)
        elseif job == "offdoc" then
            xPlayer.setJob('doc', grade)
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