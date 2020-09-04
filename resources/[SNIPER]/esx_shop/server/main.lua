--[[ Gets the ESX library ]]--
ESX = nil 
TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

local shops = {}
local items = {
    ["fanta"] = {price = 1000, label = "Fanta"},
    ["sprite"] = {price = 200, label = "Sprite"},
    ["water"] = {price = 100, label = "Ab"},
    ["cheesebows"] = {price = 200, label = "Snack"},
    ["chips"] = {price = 160, label = "Chips"},
    ["marabou"] = {price = 120, label = "Shokolat"},
    ["pizza"] = {price = 400, label = "Pitza"},
    ["burger"] = {price = 300, label = "Burger"},
    ["bread"] = {price = 120, label = "Noon"},
    ["phone"] = {price = 2200, label = "Phone"},
    ["gps"] = {price = 1000, label = "GPS"},
    ["lighter"] = {price = 80, label = "Fandak"},
    ["lotteryticket"] = {price = 400, label = "Blit Bakht Azmayi"},
    ["fishingrod"] = {price = 4000, label = "Choob Mahigiri"},
    ["radio"] = {price = 2000, label = "Radio"},
    ["picklock"] = {price = 2500, label = "PickLock"}
}

local sellerItems = {
    ["fanta"] = {price = 1000/2, label = "Fanta"},
    ["sprite"] = {price = 200/2, label = "Sprite"},
    ["water"] = {price =  100/2, label = "Ab"},
    ["cheesebows"] = {price = 200/2, label = "Snack"},
    ["chips"] = {price = 160/2, label = "Chips"},
    ["marabou"] = {price = 120/2, label = "Shokolat"},
    ["pizza"] = {price = 400/2, label = "Pitza"},
    ["burger"] = {price = 300/2, label = "Burger"},
    ["bread"] = {price = 120/2, label = "Noon"},
    ["phone"] = {price = 2200/2, label = "Phone"},
    ["gps"] = {price = 1000/2, label = "GPS"},
    ["lighter"] = {price = 80/2, label = "Fandak"},
    ["lotteryticket"] = {price = 390, label = "Blit Bakht Azmayi"},
    ["fishingrod"] = {price = 4000/2, label = "Choob Mahigiri"},
    ["radio"] = {price = 2000/2, label = "Radio"},
    ["picklock"] = {price = 2500/2, label = "PickLock"}
}

MySQL.ready(function()
    local allShops = MySQL.Sync.fetchAll('SELECT * FROM owned_shops')
    
	for i=1, #allShops, 1 do
		shops[allShops[i].number] = {owner = json.decode(allShops[i].owner), money = allShops[i].money, shop = json.decode(allShops[i].value), name = allShops[i].name, inventory = json.decode(allShops[i].inventory)}
    end
    
end)

ESX.RegisterServerCallback('99kr-shops:CheckMoney', function(source, cb, price, account)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local money
    if account == "cash" then
        money = xPlayer.money
    else
        money = xPlayer.bank
    end

    if money >= price then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('99kr-shops:Cashier')
AddEventHandler('99kr-shops:Cashier', function(basket, account, shopNumber)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local pay
    local price = 0

    if account == "cash" then
        pay = xPlayer.removeMoney
    else
        pay = xPlayer.removeBank
    end

    for i=1, #basket do
    
        local item      = xPlayer.getInventoryItem(basket[i]["value"])
        local canTake   = ((item.limit == -1) and (basket[i]["amount"])) or ((item.limit - item.count > 0) and (item.limit - basket[i]["amount"] >= 0)) or false
        
        if canTake then
            if shops[shopNumber].owner.identifier ~= "government" then
                if not shops[shopNumber].inventory[basket[i].value] then
                    shops[shopNumber].inventory[basket[i].value] = 0
                    MySQL.Async.execute('UPDATE owned_shops SET inventory = @inventory WHERE number = @shopnumber', {
                        ['@inventory'] = json.encode(shops[shopNumber].inventory),
                        ['@shopnumber'] = shopNumber
                    })
                end

                if shops[shopNumber].inventory[basket[i].value] >= basket[i].amount then
                    shops[shopNumber].inventory[basket[i].value] = shops[shopNumber].inventory[basket[i].value] - basket[i].amount
                    price = price + (items[basket[i].value].price * basket[i].amount)
                    xPlayer.addInventoryItem(basket[i]["value"], basket[i]["amount"])
                else
                    pNotify('Maghaze mored nazar meghdar kafi az ' .. item.label .. ' nadasht mahsol mored nazar az sabad kharid hazf shod!', 'error', 7000)
                end
            else
                price = price + (items[basket[i].value].price * basket[i].amount)
                xPlayer.addInventoryItem(basket[i]["value"], basket[i]["amount"])
            end
        else
            pNotify('Shoma fazaye khali baraye ' .. item.label .. ' nadashtid az sabad kharid hazf shod!', 'error', 7000)
        end
        
    end

    if price ~= 0  then
        pay(price)
        pNotify('Shoma mahsolat ro be gheymat for <span style="color: green">$' .. price .. '</span> Kharidari kardid', 'success', 7000)
        if shops[shopNumber].owner.identifier ~= "government" then
            shops[shopNumber].money = shops[shopNumber].money + price
            MySQL.Async.execute('UPDATE owned_shops SET `money` = money + @price, inventory = @inventory WHERE number = @shopnumber', {
                ['@price'] = price,
                ['@inventory'] = json.encode(shops[shopNumber].inventory),
                ['@shopnumber'] = shopNumber
            })
        end
    end
    

end)

ESX.RegisterServerCallback('esx_shop:getShops', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM owned_shops', {},
        function(data)
            
            cb(data)
        
    end)
end)

-- [Deposit shop money event]
ESX.RegisterServerCallback('esx_shop:depositmoney', function(source, cb, shopNumber)
  local identifier = GetPlayerIdentifier(source)
  if shops[shopNumber].owner.identifier == identifier then
    if shops[shopNumber].money >= 5000 then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addMoney(shops[shopNumber].money)
        cb(shops[shopNumber].money)
        shops[shopNumber].money = 0

        MySQL.Async.execute('UPDATE owned_shops SET `money` = 0 WHERE number = @shopnumber', {
            ['@shopnumber'] = shopNumber
        })
        
    else
        TriggerClientEvent("esx:showNotification", source, "Hade aghal mablagh bardashtan pol ~g~$5000 ~w~ast!")
        cb(false)
    end 
  else
    exports.BanSql:BanTarget(source, "Tried to deposit shop money", "Cheat Lua executor")
    cb(false)
  end
end)

-- [Show inventory event]
ESX.RegisterServerCallback('esx_shop:getinventory', function(source, cb, shopNumber)
    local identifier = GetPlayerIdentifier(source)
    if shops[shopNumber].owner.identifier == identifier then
        local itemObj = {}
        for k,v in pairs(shops[shopNumber].inventory) do
            itemObj[k] = {label = items[k].label, count = v}
        end
        cb(itemObj)
    else
      exports.BanSql:BanTarget(source, "Tried to open shop inventory", "Cheat Lua executor")
      cb(false)
    end
end)

-- [Get buy prices]
ESX.RegisterServerCallback('esx_shop:getbuyprices', function(source, cb)
    local identifier = GetPlayerIdentifier(source)
    if isOwnerOfAnyShop(identifier) then
        cb(sellerItems)
    else
      exports.BanSql:BanTarget(source, "Tried to open shop seller menu", "Cheat Lua executor")
      cb(false)
    end
end)

-- [Change name event]
ESX.RegisterServerCallback('esx_shop:changename', function(source, cb, shopNumber, shopName)
    local identifier = GetPlayerIdentifier(source)
    if shops[shopNumber].owner.identifier == identifier then
        shops[shopNumber].name = shopName
        TriggerClientEvent('esx_shop:clChangeName', -1, shopNumber, shopName)

        cb(shopName)

        MySQL.Async.execute('UPDATE owned_shops SET `name` = @name WHERE number = @shopnumber', {
            ['@shopnumber'] = shopNumber,
            ['@name'] = shopName
        })
    else
      exports.BanSql:BanTarget(source, "Tried to change shop name", "Cheat Lua executor")
      cb(false)
    end
end)  

-- [Put item in stock]
ESX.RegisterServerCallback('esx_shop:buyStock', function(source, cb, stock)
    local identifier = GetPlayerIdentifier(source)
    if isOwnerOfAnyShop(identifier) then
    
       local xPlayer = ESX.GetPlayerFromId(source)
       local price = sellerItems[stock.item].price * stock.count

       if xPlayer.money >= price then
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(stock.item, stock.count)
            cb({item = stock.item, count = stock.count, price = price})
       else
        TriggerClientEvent("esx:showNotification", source, "~h~Shoma pol kafi baraye kharid~g~ " .. sellerItems[stock.item].label .. " ~w~nadarid!")
        cb(false)
       end
        
    else
      exports.BanSql:BanTarget(source, "Tried to buy stock for shop", "Cheat Lua executor")
      cb(false)
    end
end)

-- [Gut stock in items]
ESX.RegisterServerCallback('esx_shop:putStock', function(source, cb, shopNumber, stock)
    local identifier = GetPlayerIdentifier(source)
    if shops[shopNumber].owner.identifier == identifier then
    
       local xPlayer = ESX.GetPlayerFromId(source)
       local xItem = xPlayer.getInventoryItem(stock.item)
       if xItem.count >= stock.count then

        xPlayer.removeInventoryItem(stock.item, stock.count)
        shops[shopNumber].inventory[stock.item] = shops[shopNumber].inventory[stock.item] + stock.count
        cb({item = stock.item, count = stock.count})

        MySQL.Async.execute('UPDATE owned_shops SET `inventory` = @inventory WHERE number = @shopnumber', {
            ['@shopnumber'] = shopNumber,
            ['@inventory'] = json.encode(shops[shopNumber].inventory)
        })

       else
        TriggerClientEvent("esx:showNotification", source, "~h~Shoma be meghdar kafi az ~g~" .. stock.item .. " ~w~nadarid!")
        cb(false)
       end
        
    else
      exports.BanSql:BanTarget(source, "Tried to get shop inventory", "Cheat Lua executor")
      cb(false)
    end
end)

-- [buy shop]
ESX.RegisterServerCallback('esx_shop:buyShop', function(source, cb, shopNumber)
    local identifier = GetPlayerIdentifier(source)
    if shops[shopNumber].shop.forsale then
        if shops[shopNumber].owner.identifier == identifier then
            TriggerClientEvent("esx:showNotification", source, "~h~Shoma nemitavanid maghaze khod ra bekharid!")
            cb(false)
            return
        end
    
       local xPlayer = ESX.GetPlayerFromId(source)
       if xPlayer.bank >= shops[shopNumber].shop.value then

        shops[shopNumber].shop.forsale = false
        xPlayer.removeBank(shops[shopNumber].shop.value)
        if shops[shopNumber].owner.identifier ~= "government" then
            local zplayer = ESX.GetPlayerFromIdentifier(shops[shopNumber].owner.identifier)
            if zplayer then
                zplayer.addBank(shops[shopNumber].shop.value)
                TriggerClientEvent('esx:showAdvancedNotification', zplayer.source, 'Bank', 'Transaction', "~o~" .. string.gsub(xPlayer.name, "_", " ") .. "~w~ Maghaze shoma ra kharid va be hesab shoma ~g~$" .. shops[shopNumber].shop.value .. "~w~ variz shod!" , 'CHAR_BANK_MAZE', 9)
            else
                MySQL.Async.execute('UPDATE users SET `bank` = bank + @money WHERE number = @shopnumber', {
                    ['@shopnumber'] = shopNumber,
                    ['@money'] = shops[shopNumber].shop.value
                })
            end
        end
        shops[shopNumber].owner.name = string.gsub(xPlayer.name, "_", " ")
        shops[shopNumber].owner.identifier = xPlayer.identifier
        TriggerClientEvent('esx_shop:clChangedata', -1, shopNumber, {name =  shops[shopNumber].owner.name, identifier = shops[shopNumber].owner.identifier, forsale = shops[shopNumber].shop.forsale, id = source})

        cb(shopNumber)

        MySQL.Async.execute('UPDATE owned_shops SET `owner` = @owner, `value` = @value WHERE number = @shopnumber', {
            ['@shopnumber'] = shopNumber,
            ['@owner'] = json.encode(shops[shopNumber].owner),
            ['@value'] = json.encode(shops[shopNumber].shop)
        })

       else
        TriggerClientEvent("esx:showNotification", source, "~h~Shoma pol kafi baraye kharid in shop nadarid ~g~$" .. tostring(shops[shopNumber].shop.value - xPlayer.bank) .. "~r~ kam ~w~darid!")
        cb(false)
       end
        
    else
      exports.BanSql:BanTarget(source, "Tried to buy shop without being for sale", "Cheat Lua executor")
      cb(false)
    end
end)

-- [[ Get Status ]]
ESX.RegisterServerCallback('esx_shop:getstatus', function(source, cb, shopNumber)
    local identifier = GetPlayerIdentifier(source)
    if shops[shopNumber].owner.identifier == identifier then
    
       cb({forsale = shops[shopNumber].shop.forsale, value = shops[shopNumber].shop.value, money = shops[shopNumber].money})
        
    else
      exports.BanSql:BanTarget(source, "Tried to fetch shop data", "Cheat Lua executor")
      cb(false)
    end
end)

-- [[ Set Sale Status]]
ESX.RegisterServerCallback('esx_shop:setstatus', function(source, cb, shopNumber, value, type)
    local identifier = GetPlayerIdentifier(source)
    if shops[shopNumber].owner.identifier == identifier then
    
       if type == "price" then
          shops[shopNumber].shop.value = value
          TriggerClientEvent('esx_shop:clChangedataCustom', -1, shopNumber, {type = "price", value = shops[shopNumber].shop.value})
          cb(shops[shopNumber].shop.value)
          MySQL.Async.execute('UPDATE owned_shops SET `value` = @value WHERE number = @shopnumber', {
            ['@shopnumber'] = shopNumber,
            ['@value'] = json.encode(shops[shopNumber].shop)
          })
       elseif type == "status" then
          if shops[shopNumber].shop.forsale then
            shops[shopNumber].shop.forsale = false
          else
            shops[shopNumber].shop.forsale = true
          end
          TriggerClientEvent('esx_shop:clChangedataCustom', -1, shopNumber, {type = "status", forsale = shops[shopNumber].shop.forsale})
          MySQL.Async.execute('UPDATE owned_shops SET `value` = @value WHERE number = @shopnumber', {
            ['@shopnumber'] = shopNumber,
            ['@value'] = json.encode(shops[shopNumber].shop)
          })
          cb(true)
       end

       cb(false)
        
    else
      exports.BanSql:BanTarget(source, "Tried to change shop data", "Cheat Lua executor")
      cb(false)
    end
end)

function RobShop(shopNumber)
    if shops[shopNumber] then
        local robbedMoney = (shops[shopNumber].money * 30) / 100 
        if robbedMoney > 0 then
            shops[shopNumber].money = shops[shopNumber].money - robbedMoney
            MySQL.Async.execute('UPDATE owned_shops SET money = money - @remove WHERE number = @shopnumber', {
                ['@remove'] = robbedMoney,
                ['@shopnumber'] = shopNumber
            })
            return robbedMoney
        else
            return 0
        end    
    else
        return 0
    end
end

function GetShopName(shopNumber)
    if shops[shopNumber] then
        return shops[shopNumber].name
    else
        return "N/A"
    end
end

pNotify = function(message, messageType, messageTimeout)
	TriggerClientEvent("pNotify:SendNotification", source, {
		text = message,
		type = messageType,
		queue = "shop_sv",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end

AddEventHandler('esx:playerLoaded', function(source)
    local identifier = GetPlayerIdentifier(source)
    local ownedShops = {}

    for k,v in pairs(shops) do
        if v.owner.identifier == identifier then
            table.insert(ownedShops, k)
        end
    end
    
    if ownedShops ~= {} then
        TriggerClientEvent('esx_shop:passTheShops', source, ownedShops)
    end

end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        Wait(2000)
        local xPlayers = ESX.GetPlayers()

        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

            local ownedShops = {}

            for k,v in pairs(shops) do
                if v.owner.identifier == xPlayer.identifier then
                    table.insert(ownedShops, k)
                end
            end

            if ownedShops ~= {} then
                TriggerClientEvent('esx_shop:passTheShops', xPlayer.source, ownedShops)
            end
            
        end

    end
end)

function isOwnerOfAnyShop(identifier)
    for k,v in pairs(shops) do
        if v.owner.identifier == identifier then
            return true
        end
    end

    return false
end