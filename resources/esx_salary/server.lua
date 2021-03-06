local ESX = nil
local Vehicles = {}
local Salaries = {}

-- ESX
TriggerEvent("esx:getSharedObject", function(obj)
        ESX = obj
    end)

-- RegisterCommand("debugs", function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     if xPlayer.permission_level == 10 then
--         print(ESX.dump(Salaries))
--     else
--         TriggerClientEvent("esx:showNotification", source, "~r~Kos kesh to ino az koja peyda kardi?")
--     end
-- end,false)

ESX.RegisterServerCallback('esx_salary:changename', function(source, cb, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    if name then
        if xPlayer.bank >= 50000 then

            if string.find(name, "_") then
                local words = {}
                for w in (name):gmatch("([^_]*)") do 
                    table.insert(words, firstToUpper(removespecial(w)))
                end
                
                if words[1] and words[2] then
                    if string.len(words[1]) >= 3 and string.len(words[3]) >= 3 then

                        MySQL.Async.fetchScalar('SELECT lastchange FROM users WHERE identifier = @identifier', {
                            ['@identifier'] = xPlayer.identifier
                        }, function(lastchange)
                            if os.time() - lastchange >= 2592000 then
                                local lname = words[1] .. "_" .. words[3]

                                MySQL.Async.fetchAll('SELECT identifier FROM users WHERE `playerName` = @playerName', {
                                    ['@playerName']	= lname
                                }, function(result)
                                    if not result[1] then
                                        MySQL.Async.execute('UPDATE users SET lastchange = @lastchange WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier, ["@lastchange"] = os.time() })
                                
                                        xPlayer.removeBank(50000)
                                        
                                        ToDiscord(xPlayer.source, "**".. xPlayer.name .. "** esm khod ra be **" .. lname .. "** taghir dad!")
                                        xPlayer.setName(lname)
                                        cb(7, lname)
                                    else
                                        cb(6)
                                    end
                                end)
                              
                            else
                                cb(5)
                            end                            
                        end)

                    else
                        cb(4)
                    end
                
                else
                    cb(3)
                end
    
            else
                cb(2)
            end

        else
            cb(1)
        end
   
    end
end)  

RegisterServerEvent("esx-salary:calculateSalary")
AddEventHandler("esx-salary:calculateSalary", function(source)
        local housesesPrice = calculateTaxForHouses(source)
        local vehiclesPrice = calculateTaxForCars(source)
        local totalMoney = calculateTaxForMoney(source)
        Citizen.Wait(1000)

        if housesesPrice ~= nil and vehiclesPrice ~= nil and totalMoney ~= nil then
            local totalPrice = housesesPrice + vehiclesPrice + totalMoney
            local tax = ESX.Math.Round(totalPrice / 200000)

            if tax > 45 then
                tax = 45
            end

            local identifier = GetPlayerIdentifier(source)

            local amount = Salaries[identifier].salary
            if amount >= 1000 and amount ~= nil then
                local salary = amount - (amount * tax / 100)

                MySQL.Async.execute(
                    "UPDATE users SET salary = 0 WHERE identifier=@identifier",
                    {
                        ["@identifier"] = identifier
                    },
                    function(rowsChanged)
                        if rowsChanged > 0 then
                            local xPlayer = ESX.GetPlayerFromId(source)

                            if xPlayer then
                                if Salaries[identifier] then
                                    xPlayer.addBank(salary)
                                    TriggerClientEvent("esx-salary:modify", source, "set", 0)
                                    Salaries[identifier].salary = 0
                                    TriggerClientEvent(
                                        "chatMessage",
                                        source,
                                        "[Bank]",
                                        {255, 0, 0},
                                        " ^0Shoma ba movafaghiat ^2" ..
                                            salary .. "$ ^0ba etekhaz ^1" .. tax .. "% ^0maliat daryaft kardid!"
                                    )
                                else
                                    TriggerClientEvent(
                                        "esx:showHelpNotification",
                                        source,
                                        "~r~Moshkeli dar pardakht salary shoma be vojoud amad lotfan admin ra motale konid!"
                                    )
                                end
                            end
                        else
                            TriggerClientEvent(
                                "esx:showHelpNotification",
                                source,
                                "~r~Moshkeli dar pardakht salary shoma be vojoud amad lotfan admin ra motale konid!"
                            )
                        end
                    end
                )
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[Bank]",
                    {255, 0, 0},
                    " ^0Hade aghal mablagh pardakht salary ^2$1000 ^0mibashad!"
                )
            end
        else
            TriggerClientEvent(
                "esx:showHelpNotification",
                source,
                "~r~Moshkeli dar system pish amade lotfan be amdin etela dahid!"
            )
        end
    end
)

RegisterServerEvent("esx-salary:passTheVehicleName")
AddEventHandler("esx-salary:passTheVehicleName", function(vehicle)
    local identifier = GetPlayerIdentifier(source)

    if Vehicles[identifier] then
        Vehicles[identifier] = nil
    end

    Vehicles[identifier] = {source = source, Vehicles = vehicle}
end)

RegisterServerEvent("esx-salary:modify")
AddEventHandler("esx-salary:modify", function(target, type, amount)

    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        local identifier = GetPlayerIdentifier(target)
        if type == "add" then
            if Salaries[identifier] then
                Salaries[identifier].salary = Salaries[identifier].salary + amount
                TriggerClientEvent("esx-salary:modify", target, "add", amount)
            end
        elseif type == "set" then
            if Salaries[identifier] then
                Salaries[identifier].salary = amount
                TriggerClientEvent("esx-salary:modify", target, "set", amount)
            end
        end

    else
        exports.BanSql:BanTarget(ource, "Attempted to modify salaries", "Cheat Lua executor")
    end

end)

function calculateTaxForCars(target)
    local identifier = GetPlayerIdentifier(target)
    local price = 0
    MySQL.Async.fetchAll(
        "SELECT * FROM owned_vehicles WHERE owner = @identifier",
        {
            ["@identifier"] = identifier
        },
        function(result)
            if result then
                for i = 1, #result, 1 do
                    Citizen.Wait(10)
                    local vehicle = json.decode(result[i].vehicle)

                    if vehicle.model then
                        local vehicleModel = vehicle.model
                        TriggerClientEvent("esx-salary:checkModelForVehicle", target, vehicleModel)
                    end
                end

                Citizen.Wait(100)
                if Vehicles[identifier].Vehicles then
                    for i = 1, #Vehicles[identifier].Vehicles, 1 do
                        if Vehicles[identifier].Vehicles[i] ~= "CARNOTFOUND" then
                            MySQL.Async.fetchAll(
                                "SELECT price, category FROM vehicles WHERE model = @model",
                                {
                                    ["@model"] = string.lower(Vehicles[identifier].Vehicles[i])
                                },
                                function(result2)
                                    if result2 then


                                        price = price + result2[1].price
                                            
    
                                    end
                                end)
                        end
                    end
                end
            end
        end
    )
    Wait(500)
    return price
end

function calculateTaxForHouses(target)
    local identifier = GetPlayerIdentifier(target)
    local price = 0
    MySQL.Async.fetchAll(
        "SELECT price FROM owned_properties WHERE owner = @identifier AND rented = false",
        {
            ["@identifier"] = identifier
        },
        function(result)
            if result then
                for i = 1, #result, 1 do
                    Citizen.Wait(10)
                    price = price + result[i].price
                end
                Citizen.Wait(500)
            end
        end)

    Wait(500)
    return price
end

function calculateTaxForMoney(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        local totalMoney = xPlayer.money + xPlayer.bank
        return totalMoney
    end
end

AddEventHandler("esx:playerLoaded",function(source)
    local _source = source
    local identifier = GetPlayerIdentifier(_source)
    MySQL.Async.fetchAll(
        "SELECT salary FROM users WHERE identifier = @identifier",
        {["@identifier"] = identifier},
        function(result)
            local salary = result[1].salary
            Salaries[identifier] = {source = _source, salary = result[1].salary}
            TriggerClientEvent("esx-salary:modify", _source, "set", Salaries[identifier].salary)
        end)
end)

AddEventHandler("playerDropped", function()

    local _source = source
    if _source ~= nil then
        local identifier = GetPlayerIdentifier(_source)

        if Salaries[identifier] ~= nil then
            MySQL.Async.execute(
                "UPDATE users SET salary = @salary WHERE identifier=@identifier",
                {
                    ["@identifier"] = identifier,
                    ["@salary"] = Salaries[identifier].salary
                },
                function(rowsChanged)
                    if rowsChanged == 0 then
                        print(
                            "Moshkeli dar save kardan salarie " ..
                                GetPlayerName(_source) .. "pish amad lotfan peygiri konid!"
                        )
                    end
                    Salaries[identifier] = nil
                end
            )
        end
    end

end)

function ToDiscord(source, Message)
    local date = os.date('*t')
	
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    
    TriggerEvent('DiscordBot:ToDiscord', 'changename', "Sabte Ahval", Message .. ' `' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`' ,'user', true, source, false)
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function removespecial(str)
    return str:gsub('[%p%c%s]', '')
end
