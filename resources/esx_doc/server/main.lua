ESX = nil
local alarmStatus = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'doc', 'DOC', 'society_doc', 'society_doc', 'society_doc', {type = 'public'})

RegisterServerEvent('esx_doc:getStockItem')
AddEventHandler('esx_doc:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name ~= "doc" then
		exports.BanSql:BanTarget(_source, "Tried to access doc inventory items without permission", "Cheat Lua executor")
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_doc', function(inventory)

		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
				TriggerEvent('DiscordBot:ToDiscord', 'dwi', xPlayer.name, 'Withdrawn x' ..count ..' '..inventoryItem.label ,'user', true, source, false)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)

end)

RegisterServerEvent('esx_doc:putStockItems')
AddEventHandler('esx_doc:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name ~= "doc" then
		exports.BanSql:BanTarget(source, "Tried to access doc inventory items without permission", "Cheat Lua executor")
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_doc', function(inventory)

		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerEvent('DiscordBot:ToDiscord', 'dwi', xPlayer.name, 'Deposited x' ..count ..' '.. itemName ,'user', true, source, false)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

	end)

end)

ESX.RegisterServerCallback('esx_doc:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_doc', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)


ESX.RegisterServerCallback('esx_doc:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

ESX.RegisterServerCallback('esx_doc:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= "doc" then
		exports.BanSql:BanTarget(source, "Tried to access doc armory items without permission", "Cheat Lua executor")
		return
	end

	if removeWeapon then
		if xPlayer.hasWeapon(weaponName) then
			xPlayer.removeWeapon(weaponName)
		else
			return
		end
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_doc', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		TriggerEvent('DiscordBot:ToDiscord', 'dwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', true, source, false)

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)

end)

ESX.RegisterServerCallback('esx_doc:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= "doc" then
		exports.BanSql:BanTarget(source, "Tried to access doc armory items without permission", "Cheat Lua executor")
		return
	end

	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_doc', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end
		
		TriggerEvent('DiscordBot:ToDiscord', 'dwi', xPlayer.name, 'Withdrawn ' .. weaponName ,'user', true, source, false)

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)

end)


ESX.RegisterServerCallback('esx_doc:buy', function(source, cb, amount)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_doc', function(account)
		if account.money >= amount then
			account.removeMoney(amount)
			cb(true)
		else
			cb(false)
		end
	end)

end)

ESX.RegisterServerCallback('esx_doc:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_doc', function(inventory)
		cb(inventory.items)
	end)
end)

AddEventHandler('esx:playerLoaded',function(source)
	if alarmStatus then
		TriggerClientEvent('esx_doc:alarm', source, "start")
	end
end)

-- [[ ALARM SECTION ]] -- 

RegisterCommand('alarm', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "doc" then
		if not alarmStatus then
			alarmStatus = true
			TriggerClientEvent('esx_policejob:notifyp', -1, "Zendan mored hamle gharar gerefte ast, ^1CODE 1^0 Bolingbroke!")
			TriggerClientEvent('esx_doc:alarm', -1, "start")
		else
			alarmStatus = false
			TriggerClientEvent('esx_policejob:notifyp', -1, "Alarm zendan ^2motevaghef ^0shod!")
			TriggerClientEvent('esx_doc:alarm', -1, "stop")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
	end
end, false)