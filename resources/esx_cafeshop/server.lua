ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_cafeshop:giveItem')
AddEventHandler('esx_cafeshop:giveItem', function(itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(itemName)
    
        if xPlayer.job.name == "coffee" or xPlayer.gang.name == "TaraFamily" then

            if xPlayer.job.name == "coffee" then
                if xPlayer.job.grade < 1 then
                  return
                end
            end

            if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then 
                TriggerClientEvent('esx:showNotification', source, "~h~Shoma jaye khali baraye bardashtan in item nadarid")
            else
                local price = getPrice(xItem.name)
                if xPlayer.money >= price then
                    xPlayer.removeMoney(price)
                    xPlayer.addInventoryItem(itemName, 1)
                    TriggerClientEvent('esx:showNotification', source, "~h~Shoma ~o~x1 ~g~" .. xItem.label .. "~w~ be gheymat ~r~" .. price .. "$~w~ Kharidid!")
                else
                    TriggerClientEvent('esx:showNotification', source, "~h~Shoma pool ~r~kafi~w~ baraye kharid ~g~" .. xItem.label .. "~w~ nadarid!")
                end
            end
        else
            exports.BanSql:BanTarget(ource, "Attempted to get stuff from coffee shop without having stuff", "Cheat vehicle hash changer")
        end

end)


function getPrice(item)
    for k,v in pairs(Config.AuthorizedFoods) do
        if v.name == item then
            return v.price
        end
    end

    return nil
end