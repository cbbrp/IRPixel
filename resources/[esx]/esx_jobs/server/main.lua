local PlayersWorking = {}
local vehicles = {}
local allowedJobs = {
	'fisherman',
	'tailor',
	'slaughterer',
	'lumberjack',
	'fueler'
}

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function Work(source, item)

	SetTimeout(item[1].time, function()

		if PlayersWorking[source] == true then

			local xPlayer = ESX.GetPlayerFromId(source)
			if xPlayer == nil then
				return
			end

			for i=1, #item, 1 do
				local itemQtty = 0
				if item[i].name ~= _U('delivery') then
					itemQtty = xPlayer.getInventoryItem(item[i].db_name).count
				end

				local requiredItemQtty = 0
				if item[1].requires ~= "nothing" then
					requiredItemQtty = xPlayer.getInventoryItem(item[1].requires).count
				end

				if item[i].name ~= _U('delivery') and itemQtty >= item[i].max then
					TriggerClientEvent('esx:showNotification', source, _U('max_limit', item[i].name))
				elseif item[i].requires ~= "nothing" and requiredItemQtty <= 0 then
					TriggerClientEvent('esx:showNotification', source, _U('not_enough', item[1].requires_name))
				else
					if item[i].name ~= _U('delivery') then
						-- Chances to drop the item
						if item[i].drop == 100 then
							xPlayer.addInventoryItem(item[i].db_name, item[i].add)
						else
							local chanceToDrop = math.random(100)
							if chanceToDrop <= item[i].drop then
								xPlayer.addInventoryItem(item[i].db_name, item[i].add)
							end
						end
					else
						xPlayer.addMoney(item[i].price)
					end
				end
			end

			if item[1].requires ~= "nothing" then
				local itemToRemoveQtty = xPlayer.getInventoryItem(item[1].requires).count
				if itemToRemoveQtty > 0 then
					xPlayer.removeInventoryItem(item[1].requires, item[1].remove)
				end
			end

			Work(source, item)

		end
	end)
end

-- // fake event
RegisterServerEvent('esx_jobs:startWork')
AddEventHandler('esx_jobs:startWork', function(item)
	exports.BanSql:BanTarget(source, "Triggered blacklisted event: esx_jobs:startWork", "Cheat Lua executor")
end)

RegisterServerEvent('esx_jobs:starirtpixelWork')
AddEventHandler('esx_jobs:starirtpixelWork', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	if IsAllowed(xPlayer.job.name) then

		if not PlayersWorking[source] then
			PlayersWorking[source] = true
			Work(source, item)
		else
			print(('esx_jobs: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(source)[1]))
		end

	else
		exports.BanSql:BanTarget(source, "Tried to bypass check job for Jobs start working", "Cheat Lua executor")
	end
end)

-- // fake event
RegisterServerEvent('esx_jobs:stopWork')
AddEventHandler('esx_jobs:stopWork', function()
	exports.BanSql:BanTarget(source, "Triggered blacklisted event: esx_jobs:stopWork", "Cheat Lua executor")
end)

RegisterServerEvent('esx_jobs:stoirppixelWork')
AddEventHandler('esx_jobs:stoirppixelWork', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if IsAllowed(xPlayer.job.name) then
		PlayersWorking[source] = false
	else
		exports.BanSql:BanTarget(source, "Tried to bypass check job for Jobs stop working", "Cheat Lua executor")
	end
end)

RegisterServerEvent('esx_jobs:addVehicle')
AddEventHandler('esx_jobs:addVehicle', function(netID)
	local identifier = GetPlayerIdentifier(source)

	if netID ~= nil then

		local vehicle = NetworkGetEntityFromNetworkId(netID)
		if DoesEntityExist(vehicle) then

			local model = GetEntityModel(vehicle)

			if model == GetHashKey("benson") then
				if not vehicles[identifier] then
					vehicles[identifier] = 0
				end
		
				vehicles[identifier] = netID
				TriggerClientEvent('esx_carlock:workVehicle', source, netID)

			end

		end
		
	else

		if not vehicles[identifier] then
			vehicles[identifier] = 0
		end
	
		vehicles[identifier] = 0
		TriggerClientEvent('esx_carlock:workVehicle', source, nil)

	end

end)

AddEventHandler('esx:playerLoaded', function(source)

	local identifier = GetPlayerIdentifier(source)
	if vehicles[identifier] ~= nil and vehicles[identifier] ~= 0 then
		TriggerClientEvent('esx_carlock:workVehicle', source, vehicles[identifier])
	end

end)

RegisterServerEvent('esx_jobs:cairpixelution')
AddEventHandler('esx_jobs:cairpixelution', function(cautionType, cautionAmount, spawnPoint, vehicle)
	local xPlayer = ESX.GetPlayerFromId(source)

	if cautionType == "take" then
		TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)
			xPlayer.removeBank(cautionAmount)
			account.addMoney(cautionAmount)
		end)

		TriggerClientEvent('esx:showNotification', source, _U('bank_deposit_taken', ESX.Math.GroupDigits(cautionAmount)))
		TriggerClientEvent('esx_jobs:spawnJobVehicle', source, spawnPoint, vehicle)
	elseif cautionType == "give_back" then

		if cautionAmount > 1 then
			print(('esx_jobs: %s is using cheat engine!'):format(xPlayer.identifier))
			return
		end

		TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)
			local caution = account.money
			local toGive = ESX.Math.Round(caution * cautionAmount)

			xPlayer.addBank(2000)
			account.removeMoney(2000)
			TriggerClientEvent('esx:showNotification', source, _U('bank_deposit_returned', ESX.Math.GroupDigits(2000)))
		end)
	end
end)


function IsAllowed(job)
	for i,v in ipairs(allowedJobs) do
		if v == job then
			return true
		end
	end

	return false
end