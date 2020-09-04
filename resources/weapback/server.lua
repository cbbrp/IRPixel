local weapons = {}

RegisterServerEvent('weapBack:addWeapon')
AddEventHandler('weapBack:addWeapon', function(netWorkID)

    local identifier = GetPlayerIdentifier(source)
    if not weapons[identifier] then
        weapons[identifier] = {}
    end

    table.insert(weapons[identifier], netWorkID)

end)

RegisterServerEvent('weapBack:removeWeapon')
AddEventHandler('weapBack:removeWeapon', function(weapon)

    local identifier = GetPlayerIdentifier(source)
    if weapons[identifier] then
        for i,v in ipairs(weapons[identifier]) do
           if v == weapon then
               table.remove(weapons[identifier], i)
           end
        end
    end
    
end)

AddEventHandler('playerDropped', function()
    local _source = source
    local identifier = GetPlayerIdentifier(_source)
    if weapons[identifier] then
        for i,v in ipairs(weapons[identifier]) do
            TriggerClientEvent('weapBack:removeWeapon', -1, v)
        end

        weapons[identifier] = nil
    end
end)