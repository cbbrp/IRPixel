ESX = nil
local units = {}
local callsigns = {}
local calls = {}
local vehicles = {}
local handcuffs = {}
local swats = {}
local callid = 1
rdict = {
	police = "^2pasgah",
	ambulance = "^2medical center",
	government = "^2markaz",
	doc = "^2zendan"
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'police', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

RegisterServerEvent('esx_policejob:giveWeapon')
AddEventHandler('esx_policejob:giveWeapon', function(weapon, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "police" or xPlayer.job.name == "doc" then
		xPlayer.addWeapon(weapon, ammo)
	else
		print(('esx_policejob: %s attempted give weapon (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:loadSigns')
AddEventHandler('esx_policejob:loadSigns', function()

	local identifier = GetPlayerIdentifier(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then
		if units[identifier] then
			local callsign = units[identifier].callsign
			TriggerClientEvent('esx:setcallsign', source, callsign)
			if vehicles[callsign] then
				TriggerClientEvent("esx_policejob:trackVehicle", source, vehicles[callsign])
				TriggerClientEvent("esx_vehiclecontol:changePointed", source, vehicles[callsign])
			end
		else
			if GetPlayerUnitIsIN(identifier) ~= nil then
				local callsign = GetPlayerUnitIsIN(identifier).callsign
				TriggerClientEvent('esx:setcallsign', source, callsign)
				if vehicles[callsign] then
					TriggerClientEvent("esx_policejob:trackVehicle", source, vehicles[callsign])
					TriggerClientEvent("esx_vehiclecontol:changePointed", source, vehicles[callsign])
				end
			end
		end

	end

end)

RegisterServerEvent('esx_policejob:addHandCuff')
AddEventHandler('esx_policejob:addHandCuff', function(NetID)

	local identifier = GetPlayerIdentifier(source)
	handcuffs[identifier] = NetID

end)

RegisterServerEvent('esx_policejob:removeHandCuff')
AddEventHandler('esx_policejob:removeHandCuff', function(NetID)

	local identifier = GetPlayerIdentifier(source)
	if handcuffs[identifier] then
	  handcuffs[identifier] = nil
	end

end)

RegisterServerEvent('esx_policejob:hairpixelndcuff')
AddEventHandler('esx_policejob:hairpixelndcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == "doc" then
		TriggerClientEvent('esx_policejob:hairpixelndcuff', target)
	else
		print(('esx_policejob: %s attempted to handcuff a player (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then
		TriggerClientEvent('esx_policejob:drag', target, source)
	else
		print(('esx_policejob: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target, NetID)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then
		TriggerClientEvent('esx_policejob:putInVehicle', target, NetID)
	else
		print(('esx_policejob: %s attempted to put in vehicle (not cop)!'):format(xPlayer.identifier))
	end
	
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'government' or xPlayer.job.name == "doc" then
		TriggerClientEvent('esx_policejob:OutVehicle', target)
	else
		print(('esx_policejob: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:getStockItem')
AddEventHandler('esx_policejob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name ~= "police" then
		exports.BanSql:BanTarget(_source, "Tried to access police inventory items without permission", "Cheat Lua executor")
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

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
				TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Withdrawn x' ..count ..' '..inventoryItem.label ,'user', true, source, false)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)

end)

RegisterServerEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name ~= "police" then
		exports.BanSql:BanTarget(source, "Tried to access police inventory items without permission", "Cheat Lua executor")
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited x' ..count ..' '.. itemName ,'user', true, source, false)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

	end)

end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then

			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)


				retrivedInfo.owner = string.gsub(result2[1].playerName, "_", " ")
	
				cb(retrivedInfo)
			end)

		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					cb(result2[1].name, true)
				end

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('esx_policejob:checkForVehicle', function(source, cb, callsign)
	if vehicles[callsign] ~= nil then
		cb(true)
	else
		cb(false)
	end 
end)

RegisterServerEvent('esx_policejob:addVehicle')
AddEventHandler('esx_policejob:addVehicle', function(callsign, netid)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then
		vehicles[callsign] = netid

		TriggerClientEvent("esx_policejob:trackVehicle", _source, vehicles[callsign])
		TriggerClientEvent("esx_vehiclecontol:changePointed", _source, vehicles[callsign])
		Wait(2000)
		for k,v in pairs(units[callsigns[callsign].owner].members) do
			xPlayer = ESX.GetPlayerFromIdentifier(k)
			if xPlayer then
				TriggerClientEvent("esx_policejob:trackVehicle", xPlayer.source, vehicles[callsign])
				TriggerClientEvent("esx_vehiclecontol:changePointed", xPlayer.source, vehicles[callsign])
			end
		end
		
	end
end)

ESX.RegisterServerCallback('esx_policejob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name ~= "police" then
		exports.BanSql:BanTarget(source, "Tried to access police armory items without permission", "Cheat Lua executor")
		return
	end

	if removeWeapon then
		if xPlayer.hasWeapon(weaponName) then
			xPlayer.removeWeapon(weaponName)
		else
			return
		end
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

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
		
			TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', true, source, false)

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

ESX.RegisterServerCallback('esx_policejob:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name ~= "police" then
		exports.BanSql:BanTarget(source, "Tried to access police armory items without permission", "Cheat Lua executor")
		return
	end

	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

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
		
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Withdrawn ' .. weaponName ,'user', true, source, false)

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


ESX.RegisterServerCallback('esx_policejob:buy', function(source, cb, amount)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
		if account.money >= amount then
			account.removeMoney(amount)
			cb(true)
		else
			cb(false)
		end
	end)

end)

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source
	
	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)
		local identifier = GetPlayerIdentifier(_source)
		
		-- Is it worth telling all clients to refresh?
		if handcuffs[identifier] then
			TriggerClientEvent('esx_policejob:requestDelete', -1, handcuffs[identifier])
		end

		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
			Citizen.Wait(5000)
			TriggerClientEvent('esx_policejob:updateBlip', -1)
		end
		
	end	
end)

-- RegisterServerEvent('esx_policejob:spawned')
-- AddEventHandler('esx_policejob:spawned', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
	
-- 	if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' then
-- 		Citizen.Wait(5000)
-- 		TriggerClientEvent('esx_policejob:updateBlip', -1)
-- 	end
-- end)

-- RegisterServerEvent('esx_policejob:forceBlip')
-- AddEventHandler('esx_policejob:forceBlip', function()
-- 	TriggerClientEvent('esx_policejob:updateBlip', -1)
-- end)

-- AddEventHandler('onResourceStart', function(resource)
-- 	if resource == GetCurrentResourceName() then
-- 		Citizen.Wait(5000)
-- 		TriggerClientEvent('esx_policejob:updateBlip', -1)
-- 	end
-- end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'police')
	end
end)

RegisterServerEvent('esx_policejob:message')
AddEventHandler('esx_policejob:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

RegisterServerEvent('esx_policejob:requestarrest')
AddEventHandler('esx_policejob:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('esx_policejob:getarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('esx_policejob:doarrested', _source)
end)

RegisterServerEvent('esx_policejob:requestrelease')
AddEventHandler('esx_policejob:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('esx_policejob:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('esx_policejob:douncuffing', _source)
end)

--------------------------------------------
------- Division Command Section  ----------
--------------------------------------------

RegisterCommand("pdivision", function(source, args)
	local sPlayer = ESX.GetPlayerFromId(source)
	if sPlayer.job.name == "police" and sPlayer.job.grade >= 7 then 
	
		if not args[1] and not args[2] and not tonumber(args[1]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode eshtebah ast")
			return
		end
	
		local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
		if not xPlayer then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "ID vared shode eshtebah ast")
			return
		end
	
		if not xPlayer.hasDivision(args[2], args[3]) then
	
			if xPlayer.addDivision(args[2], args[3]) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Division ^2" .. args[2] .. " ^0ba movafaghiat be ^3" .. GetPlayerName(tonumber(args[1])) .. " ^0Dade shod!")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Moshkeli dar dadan divison pish amad lotfan log ra barresi konid")
			end
			
		else 
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Player ^2" .. GetPlayerName(tonumber(args[1])) .. " ^0Division ^3" .. args[2] .. " ^0ra darad!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi nadarid")
	end
	
end, false)

RegisterCommand("pgetdivisions", function(source, args)
	local sPlayer = ESX.GetPlayerFromId(source)
	if sPlayer.job.name == "police" and sPlayer.job.grade >= 7 then 

		if not tonumber(args[1]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode eshtebah ast")
			return
		end

		local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
		if not xPlayer then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "ID vared shode eshtebah ast")
			return
		end
		print(ESX.dump(xPlayer.getDivisions()))

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi nadarid")
	end
end, false)

RegisterCommand("prdivision", function(source, args)
	local sPlayer = ESX.GetPlayerFromId(source)
	if sPlayer.job.name == "police" and sPlayer.job.grade >= 7 then 
	
		if not args[2] and not tonumber(args[1]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode eshtebah ast")
			return
		end
		local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
		if not xPlayer then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "ID vared shode eshtebah ast")
			return
		end

		if xPlayer.hasDivision(args[2]) then

			if xPlayer.removeDivision(args[2]) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Division ^2" .. args[2] .. " ^0ba movafaghiat az ^3" .. GetPlayerName(tonumber(args[1])) .. " ^0gerefte shod!")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Moshkeli dar hazf kardan division pish amad lotfan log ra barresi konid")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Player ^2" .. GetPlayerName(tonumber(args[1])) .. " ^0Division ^3" .. args[2] .. " ^0ra nadarad!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi nadarid")
	end
end, false)

RegisterCommand("padddivision", function(source, args)
	local sPlayer = ESX.GetPlayerFromId(source)
	if sPlayer.job.name == "police" and sPlayer.job.grade >= 7 then 

		if not args[1] and not args[2] and not args[3] and not args[4] and not args[5] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode eshtebah ast")
			return
		end

		if ESX.AddDivision("police", args[1], args[2], args[3], args[4], args[5]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Division ^2" .. args[1] .. " ^0ba movafaghiat be ^3 police ^0ezafe shod!")
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Moshkeli dar ezfe kardan division pish amad lotfan log ra barresi konid")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi nadarid")
	end
end, false)

RegisterCommand("prsdivision", function(souruce, args)
	local sPlayer = ESX.GetPlayerFromId(source)
	if sPlayer.job.name == "police" and sPlayer.job.grade >= 7 then 

		if not args[1] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode eshtebah ast")
			return
		end
		
		if ESX.RemoveDivision("police", args[1]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Division ^2" .. args[1] .. " ^0ba movafaghiat az ^3 police ^0hazf shod!")
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Moshkeli dar hazf kardan divison pish amad lotfan log ra barresi konid")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi nadarid")
	end
end, false)

RegisterCommand("pcheckdivision", function(source, args)
	local sPlayer = ESX.GetPlayerFromId(source)
	if sPlayer.job.name == "police" and sPlayer.job.grade >= 7 then 

		if not tonumber(args[1]) and not args[2] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode eshtebah ast")
			return
		end

		local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))

		if not xPlayer then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "ID vared shode eshtebah ast")
			return
		end
		
		if xPlayer.job.name == "police" then
			if xPlayer.hasDivision(args[2], args[3]) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Player ^2" .. GetPlayerName(tonumber(args[1])) .. " ^0Division ^3" .. args[2] .. " ^0ra darad!")
			else 
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Player ^2" .. GetPlayerName(tonumber(args[1])) .. " ^0Division ^3" .. args[2] .. " ^0ra nadarad!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Player mored nazar police nist")
		end
		
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi nadarid")
	end
end, false)

RegisterCommand("addgrade", function(source, args)
	local sPlayer = ESX.GetPlayerFromId(source)
	if sPlayer.job.name == "police" and sPlayer.job.grade >= 7 then 

		if not args[1] and not args[2] and not args[3] and not args[4] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode eshtebah ast")
			return
		end
		
		if ESX.AddGrade("police", args[1], args[2], args[3], args[4]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Grade ba movafaghiat add shod")
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Moshkeli dar add kardan grade pish amad lotfan log ra barresi konid")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi nadarid")
	end
end, false)

RegisterCommand("removegrade", function(source, args)
	local sPlayer = ESX.GetPlayerFromId(source)
		if sPlayer.job.name == "police" and sPlayer.job.grade >= 7 then 

		if not args[1] and not args[2] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode eshtebah ast")
			return
		end

		if ESX.RemoveGrade("police", args[1], args[2]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Grade ba movafaghiat remove shod")
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Moshkeli dar remove kardan grade pish amad lotfan log ra barresi konid")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi nadarid")
	end
end, false)


RegisterCommand("getsvd", function(source)

	local sPlayer = ESX.GetPlayerFromId(source)
	if sPlayer.job.name ~= "police" and sPlayer.job.grade ~= 8 then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi nadarid")
		return
	end
	
	print(ESX.dump(ESX.getServerDivisions()))
end, false)

---------------------------------------------------------------------------------------------------------
----------------------------------------- Dispatch Commands --------------------------------------------
--------------------------------------------------------------------------------------------------------

RegisterCommand('createunit', function(source, args)
	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode eshtebah ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then
		local identifier = xPlayer.identifier

		if units[identifier] == nil and not IsPlayerInAnyUnit(identifier) then

			local uidentifier = string.upper(args[1])

			if callsigns[uidentifier] == nil then
				units[identifier] = {callsign = uidentifier, members = {}, job = xPlayer.job.name}
				callsigns[uidentifier] = {owner = identifier, name = xPlayer.name, job = xPlayer.job.name}
				TriggerClientEvent('esx:setcallsign', source, uidentifier)
				TriggerClientEvent('esx_policejob:notifyp', -1, "Vahed ^2" .. uidentifier .. "^0 tavasot ^3" .. string.gsub(xPlayer.name, "_", " ") .. "^0 sakhte shod!", xPlayer.job.name)
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Callsign ^2" .. uidentifier .. "^0 ghablan tavasot ^3" .. callsigns[uidentifier].name .. "^0 sakhte shode ast!")
			end

		else
			if not IsPlayerInAnyUnit(identifier) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma ghablan unit sakhte id")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar hale hazer unit darid")
			end	
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end

end, false)

RegisterCommand('clearunit', function(source, args)
	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode eshtebah ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" and xPlayer.job.grade >= 5 then
		local identifier = xPlayer.identifier
		local job = xPlayer.job.name
		local Name = string.gsub(xPlayer.name, "_", " ")

			local uidentifier = string.upper(args[1])

			if callsigns[uidentifier] ~= nil then

				if callsigns[uidentifier].job == xPlayer.job.name then

					local identifier = callsigns[uidentifier].owner
					xPlayer = ESX.GetPlayerFromIdentifier(identifier)
					if xPlayer then
						TriggerClientEvent('esx:setcallsign', xPlayer.source, nil)
					end
					
					if TableLength(units[identifier].members) > 0 then
						for k,v in pairs(units[identifier].members) do
							xPlayer = ESX.GetPlayerFromIdentifier(k)
							if xPlayer then
								TriggerClientEvent('esx:setcallsign', xPlayer.source, nil)
							end
						end
					end

					callsigns[uidentifier] = nil
					units[identifier] = nil
					if vehicles[uidentifier] ~= nil then
						local vehicle = NetworkGetEntityFromNetworkId(vehicles[uidentifier])
						if DoesEntityExist(vehicle) then
							Citizen.InvokeNative(0xFAA3D236, vehicle)
						else
							TriggerClientEvent('chatMessage', source, "[DISPATCH]", {0, 95, 254}, "Betty natavanest vahed in mashin ra peyda konad!")
						end
						vehicles[uidentifier] = nil
					end		
					TriggerClientEvent('esx_policejob:notifyp', -1, "Vahed ^2" .. uidentifier .. "^0 tavsot ^3" .. Name .. "^0 monhal shod!", job)

				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma faghat vahed haye department khod ra mitavanid pak konid")
				end

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Callsign vared shode vojod nadarad")
			end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma Dastresi kafi baraye in dastor ra nadarid")
	end

end, false)

RegisterCommand('renameunit', function(source, args)

	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode eshtebah ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then

		local identifier = xPlayer.identifier
		local job = xPlayer.job.name

		if units[identifier] ~= nil then
			
			local csign = units[identifier].callsign -- previous call sign
			local uidentifier = string.upper(args[1])

			if csign == uidentifier then 
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma nemitavanid callsign ghabli khod ra entekhab konid!")
				return
			end

			units[identifier].callsign = uidentifier
			callsigns[csign] = nil 
			callsigns[uidentifier] = {owner = identifier, job = xPlayer.job.name, name = string.gsub(xPlayer.name, "_", " ")}
			TriggerClientEvent('esx:setcallsign', source, uidentifier)
			if TableLength(units[identifier].members) > 0 then
				for k,v in pairs(units[identifier].members) do
					xPlayer = ESX.GetPlayerFromIdentifier(k)
					if xPlayer then
						TriggerClientEvent('esx:setcallsign', xPlayer.source, uidentifier)
					end
				end
			end
			if vehicles[csign] then
				local tempNetID = vehicles[csign]
				vehicles[uidentifier] = tempNetID
				vehicles[csign] = nil
				local plate = string.gsub(uidentifier, "-", "")
				TriggerClientEvent("esx_policejob:modifyVehicle", source, vehicles[uidentifier], plate)
			end
			TriggerClientEvent('esx_policejob:notifyp', -1, "Vahed ^2" .. csign .. "^0 be ^3" .. uidentifier .. "^0 taghir yaft!", job)

		else
			if not IsPlayerInAnyUnit(identifier) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma hich uniti nadarid")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma saheb in unit nistid")
			end	
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end

end, false)

RegisterCommand('disbandunit', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then
		local identifier = xPlayer.identifier

		if units[identifier] ~= nil then
			
			if vehicles[units[identifier].callsign] == nil then
				local csign = units[identifier].callsign
				TriggerClientEvent('esx:setcallsign', source, nil, xPlayer.job.name)
				callsigns[csign] = nil
				units[identifier] = nil
				TriggerClientEvent("esx_vehiclecontol:changePointed", source, nil)		
				TriggerClientEvent('esx_policejob:notifyp', -1, "Vahed ^2" .. csign .. "^0 monhal shod!", xPlayer.job.name)
			else
				TriggerClientEvent('chatMessage', source, "[DISPATCH]", {0, 95, 254}, "Vasile naghlie vahed shoma bargardande nashode, nemitavanid vahed ra monhal konid")
			end

		else
			if not IsPlayerInAnyUnit(identifier) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma hich uniti nadarid")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma saheb in unit nistid")
			end	
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end

end, false)

RegisterCommand('units', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then
		local identifier = xPlayer.identifier
		local job = xPlayer.job.name

		if TableLength(callsigns) > 0 then

			if args[1] == "all" then
				if xPlayer.job.name == "government" then
					for k,v in pairs(callsigns) do
						TriggerClientEvent('chatMessage', source, "[INFO]", {226, 239, 93}, "UNIT ^3'" .. k .. "'^0,   Leader: ^2" .. v.name .. "^0, Members: ^1" .. TableLength(units[v.owner].members))
					end
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye in dastor ra nadarid!")
				end
			else
				for k,v in pairs(callsigns) do
					if v.job == job then
						TriggerClientEvent('chatMessage', source, "[INFO]", {226, 239, 93}, "UNIT ^3'" .. k .. "'^0,   Leader: ^2" .. v.name .. "^0, Members: ^1" .. TableLength(units[v.owner].members))
					end
				end
			end

		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Hich vahedi baraye namayesh vojod nadarad!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastoor ra nadarid")
	end

end, false)

RegisterCommand('joinunit', function(source, args)
	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode eshtebah ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then

		local identifier = xPlayer.identifier

		if units[identifier] == nil and not IsPlayerInAnyUnit(identifier) then

			local uidentifier = string.upper(args[1])
			if callsigns[uidentifier] ~= nil then
				units[callsigns[uidentifier].owner].members[identifier] = xPlayer.name
				TriggerClientEvent('esx:setcallsign', source, uidentifier)
				if vehicles[uidentifier] then
					TriggerClientEvent("esx_policejob:trackVehicle", source, vehicles[uidentifier])
					TriggerClientEvent("esx_vehiclecontol:changePointed", source, vehicles[uidentifier])
				end
				TriggerClientEvent('esx_policejob:notifyp', -1, "^3" ..string.gsub(xPlayer.name, "_", " ") .. "^0 be vahed ^2" .. uidentifier .. "^0 molhagh shod!", xPlayer.job.name)
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "In callsign vojoud nadarad!")
			end

		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar hale hazer unit darid!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma police nistid")
	end
end, false)

RegisterCommand('leaveunit', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then

		local identifier = xPlayer.identifier

		if units[identifier] == nil and IsPlayerInAnyUnit(identifier) then

			for k,v in pairs(units) do
				if v.members[identifier] then
					TriggerClientEvent('esx_policejob:notifyp', -1, "^3" ..string.gsub(xPlayer.name, "_", " ") .. "^0 az vahed ^2" .. v.callsign .. "^0 kharej shod!", xPlayer.job.name)
					v.members[identifier] = nil
					TriggerClientEvent('esx_policejob:stopTrack', source)
					break
				end
			end
			TriggerClientEvent("esx_vehiclecontol:changePointed", xPlayer.source, nil)		

		else
			if units[identifier] == nil then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dakhel hich uniti nistid!")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma nemitavanid az vahed khod kharej shavid!")
			end
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end
end, false)

--------------------------------------------------------------------------------------------------------
------------------------------------------- Call System ------------------------------------------------
--------------------------------------------------------------------------------------------------------


RegisterCommand('resp', function(source, args)

	if not tonumber(args[1]) then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode estebah ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)
	local Pjob = xPlayer.job.name

	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then

		local identifier = xPlayer.identifier

		if units[identifier] == nil or units[identifier].callsign == nil then

			if not IsPlayerInAnyUnit(identifier) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma callsign nadarid!")
				return
			else
				identifier = GetUnitOwner(identifier)
				if identifier == nil then
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Khatayi dar system pish amad lotfan be developer etelaa dahid!")
					return
				end
			end
			
		end
		
		if calls[args[1]] ~= nil then
			if calls[args[1]].identifier ~= units[identifier].callsign then
				if AlreadyRespond(identifier) then

					for k,v in pairs(calls) do
						if v.responds[identifier] == identifier then
							TriggerClientEvent("esx_policejob:closecall", source)
							v.responds[identifier] = nil
						end
					end

					if TableLength(units[identifier].members) > 0 then
			
						for k,v in pairs(units[identifier].members) do
							xPlayer = ESX.GetPlayerFromIdentifier(k)
							for k2,v2 in pairs(calls) do
								if v2.responds[identifier] == k then
									TriggerClientEvent("esx_policejob:closecall", xPlayer.source)
									v2.responds[identifier] = nil
								end
							end
						end
						
					end
				end

					if TableLength(units[identifier].members) > 0 then

						xPlayer = ESX.GetPlayerFromIdentifier(identifier)
						Pjob = xPlayer.job.name
						TriggerClientEvent("esx_policejob:respcall", xPlayer.source, calls[args[1]])
						calls[args[1]].responds[xPlayer.identifier] = xPlayer.identifier

						for k,v in pairs(units[identifier].members) do
							xPlayer = ESX.GetPlayerFromIdentifier(k)
							if xPlayer then
								TriggerClientEvent("esx_policejob:respcall", xPlayer.source, calls[args[1]])
								calls[args[1]].responds[xPlayer.identifier] = xPlayer.identifier
							end
						end

					else
						TriggerClientEvent("esx_policejob:respcall", source, calls[args[1]])
						calls[args[1]].responds[identifier] = identifier
					end

					if calls[args[1]].job ~= Pjob then
						TriggerClientEvent('esx_policejob:notifyp', -1, "Darkhast ^3poshtibani^0 ^1(" .. args[1] ..  ")^0 tavasot ^2" .. units[identifier].callsign .. "^0 ghabol shod!")
					else
						TriggerClientEvent('esx_policejob:notifyp', -1, "Darkhast ^3poshtibani^0 ^1(" .. args[1] ..  ")^0 tavasot ^2" .. units[identifier].callsign .. "^0 ghabol shod!", xPlayer.job.name)
					end
					
				
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma nemitavanid be call khod javab bedid!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Call mored nazar vojod nadarad!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end

end, false)

RegisterCommand('calls', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then

		local identifier = xPlayer.identifier
		local job = xPlayer.job.name

		if units[identifier] == nil or units[identifier].callsign == nil then
			if not IsPlayerInAnyUnit(identifier)  then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma callsign nadarid!")
				return
			end
		end
		
		if TableLength(calls) > 0 then
			for k,v in pairs(calls) do
				local display = "^5" .. v.job
				if v.job == "ambulance" then
					display = "^1medic"
				elseif v.job == "government" then
					display = "^0gov"
				elseif v.job == "doc" then
					display = "^3doc"
				end

				TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "^5[^0" .. string.upper(display) .. "^5] ^5[^0" .. k .. "^5] ^5[^0" .. v.type .. "^5] ^5[^0" .. v.identifier .. "^5]")
				
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Hich Calli baraye namayesh vojod nadarad!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end

end, false)

RegisterCommand('delcruiser', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then

		local identifier = xPlayer.identifier
		if units[identifier] == nil or units[identifier].callsign == nil then

			if not IsPlayerInAnyUnit(identifier) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma callsign nadarid!")
				return
			else
				identifier = GetUnitOwner(identifier)
				if identifier == nil then
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Khatayi dar system pish amad lotfan be developer etelaa dahid!")
					return
				end
			end
			
		end

		if vehicles[units[identifier].callsign] ~= nil then
			local vehicle = NetworkGetEntityFromNetworkId(vehicles[units[identifier].callsign])
			if DoesEntityExist(vehicle) then
				TriggerClientEvent('esx_policejob:stopTrack', source, nil)
				stopTrack(identifier)
				Citizen.InvokeNative(0xFAA3D236, vehicle)
				vehicles[units[identifier].callsign] = nil
				TriggerClientEvent('chatMessage', source, "[DISPATCH]", {0, 95, 254}, "Betty mashin ra be " .. rdict[xPlayer.job.name] .. "^0 bargardand")
			else
				TriggerClientEvent('chatMessage', source, "[DISPATCH]", {0, 95, 254}, "Betty nemitavand mashin ra peyda konad!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Vahed shoma hich vasile naghliyeyi nadarad")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end

end, false)

RegisterCommand('closecall', function(source, args)

	if not tonumber(args[1]) then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Syntax vared shode estebah ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then

		local identifier = xPlayer.identifier

		if units[identifier] == nil or units[identifier].callsign == nil then
			if not IsPlayerInAnyUnit(identifier) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma callsign nadarid!")
				return
			else
				identifier = GetUnitOwner(identifier)
				if identifier == nil then
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Khatayi dar system pish amad lotfan be developer etelaa dahid!")
					return
				end
			end
		end
		
		if calls[args[1]] ~= nil then
		
			if calls[args[1]].job == xPlayer.job.name then
				if TableLength(calls[args[1]].responds) > 0 then
					for k,v in pairs(calls[args[1]].responds) do
						local Tplayer = ESX.GetPlayerFromIdentifier(v)
						if Tplayer then
							TriggerClientEvent("esx_policejob:closecall", Tplayer.source)
							TriggerClientEvent('esx_policejob:notifyp', Tplayer.source, "Darkhast ^3poshtibani^0 ^1(" .. args[1] ..  ")^0 tavasot ^2" .. units[identifier].callsign .. "^0 baste shod!")
						end
					end
				end
	
				calls[args[1]] = nil
				TriggerClientEvent('esx_policejob:notifyp', -1, "Darkhast ^3poshtibani^0 ^1(" .. args[1] ..  ")^0 tavasot ^2" .. units[identifier].callsign .. "^0 baste shod!", xPlayer.job.name)

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma faghat mitavanid call haye marbot be department khod ra bebandid!")
			end
			

		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Call mored nazar vojod nadarad!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end

end, false)

RegisterServerEvent('esx_policejob:addbackup')
AddEventHandler('esx_policejob:addbackup', function(backup)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then
	
		local call = backup
		calls[tostring(callid)] = {
			coords = backup.coords,
			identifier = backup.identifier,
			name = string.gsub(xPlayer.name, "_", " "),
			NetID = backup.NetID,
			responds = {},
			type = backup.type,
			job = xPlayer.job.name
		}

		local temp = string.lower(backup.type)
		if temp == "backup" then
			TriggerClientEvent('esx_policejob:notifyp', -1, "Darkhast ^3poshtibani^0 az taraf ^2" .. calls[tostring(callid)].identifier .. "^0 ^4  (/resp " .. tostring(callid) .. ")  ^0 jahat javab dadan be call!", xPlayer.job.name)
			TriggerClientEvent('esx_policejob:playSound', -1, "demo", 0.5, xPlayer.job.name)
		elseif temp == "panic" then
			if xPlayer.job.name == "police" then
				TriggerClientEvent('esx_policejob:notifyp', -1, "Vahed ^2" .. calls[tostring(callid)].identifier .. "^0 mored ^1hamle ^0 gharar gerefte ast ^4  (/resp " .. tostring(callid) .. ")  ^0 jahat javab dadan be panic!", xPlayer.job.name)
				TriggerClientEvent('esx_policejob:playSound', -1, "panic", 0.5, xPlayer.job.name)
			else
				TriggerClientEvent('esx_policejob:notifyp', -1, "Vahed ^2" .. calls[tostring(callid)].identifier .. "^0 mored ^1hamle ^0 gharar gerefte ast ^4  (/resp " .. tostring(callid) .. ")  ^0 jahat javab dadan be panic!")
				TriggerClientEvent('esx_policejob:playSound', -1, "panic", 0.5)
			end
		end

		callid = callid + 1


	end
end)


function stopTrack(identifier)
	if units[identifier] then
		for k,v in pairs(units[identifier].members) do
			local xPlayer = ESX.GetPlayerFromIdentifier(k)
			if xPlayer then
				TriggerClientEvent('esx_policejob:stopTrack', xPlayer.source)
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------
------------------------------------------------ Functions ----------------------------------------------
---------------------------------------------------------------------------------------------------------
function TableLength(table)

	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count

end

function AlreadyRespond(identifier)
	for k,v in pairs(calls) do
		if v.responds[identifier] ~= nil then
			return true
		end
	end

	return false
end

function IsPlayerInAnyUnit(identifier)
	for k,v in pairs(units) do
		if v.members[identifier] then
			return true
		end
	end
	return false
end

function GetPlayerUnitIsIN(identifier)
	for k,v in pairs(units) do
		if v.members[identifier] then
			return v
		end
	end
	return nil
end

function GetUnitOwner(identifier)
	for k,v in pairs(units) do
		if v.members[identifier] then
			return k
		end
	end
	return nil
end