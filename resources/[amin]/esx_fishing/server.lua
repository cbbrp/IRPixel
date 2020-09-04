-- iteme rod
-- mahi giri
-- forushe mahi
-- remove kardane choobe mahigiri baad az tamum shodan


ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local fishingPlayers = {}

local grabitems = {
    [1] = { name = 'mahigoli', price = 650 },
    [2] = { name = 'ghezelala', price = 800 },
    [3] = { name = 'hamoor', price = 1100 },
    [4] = { name = 'salomon', price = 600 },
    [5] = { name = 'dampaii', price = 100 },
    [6] = { name = 'meygoo', price = 850 },
}
 
ESX.RegisterUsableItem('fishingrod', function(source)

  TriggerClientEvent('fishing:start', source)
    
end)

RegisterServerEvent('fishing:done')
AddEventHandler('fishing:done', function(number)
    local grab = grabitems[number]
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(grab.name)
    if xItem.count >= xItem.limit then
        TriggerClientEvent('esx:showNotification', source, 'Shoma Fazaye khali baraye ' .. xItem.label .. ' ra nadarid')
        return
    end

    if fishingPlayers[source] then
        local time = os.time() - fishingPlayers[source]
        if time < 20 then
            exports.BanSql:BanTarget(source, "Tried to modify fishing timer: " .. tostring(time), "Cheat lua executor")
            return
        end
    end

    fishingPlayers[source] = os.time()

    xPlayer.addInventoryItem(grab.name, 1)

end)

ESX.RegisterServerCallback('fishing:sell', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local totalcount = 0
    local price = 0
    for i,v in ipairs(grabitems) do
        local count = xPlayer.getInventoryItem(v.name).count
        if count > 0 then
            totalcount = totalcount + count
            price = price + (v.price * count)
            xPlayer.removeInventoryItem(v.name, count)
        end
    end
	
    if price > 0 then
        xPlayer.addMoney(price)
        cb({count = totalcount, price = price})
    else
        cb(false)
    end
end)

AddEventHandler('playerDropped', function()

    if fishingPlayers[source] then
        fishingPlayers[source] = nil
    end

end)