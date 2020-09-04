ESX = nil
VehicleWanted = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Make sure all Vehicles are Stored on restart
MySQL.ready(function()
	ParkVehicles()
end)

function ParkVehicles()
	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = @stored AND `policei` = false', {
		['@stored'] = false
	}, function(rowsChanged)
		if rowsChanged > 0 then
			print(('esx_advancedgarage: %s vehicle(s) have been stored!'):format(rowsChanged))
		end
	end)
end

-- Get Owned Properties
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedProperties', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local properties = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(data)
		for _,v in pairs(data) do
			table.insert(properties, v.name)
		end
		cb(properties)
	end)
end)

-- Fetch Owned Aircrafts
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}

	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND `stored` = @stored', {
			['@owner']  = GetPlayerIdentifier(source),
			['@Type']   = 'aircraft',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedAircrafts)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type', {
			['@owner']  = GetPlayerIdentifier(source),
			['@Type']   = 'aircraft',
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedAircrafts)
		end)
	end
end)

-- Fetch Owned Boats
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedBoats', function(source, cb)
	local ownedBoats = {}

	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND `stored` = @stored', {
			['@owner']  = GetPlayerIdentifier(source),
			['@Type']   = 'boat',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedBoats, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedBoats)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type', {
			['@owner']  = GetPlayerIdentifier(source),
			['@Type']   = 'boat',
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedBoats, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedBoats)
		end)
	end
end)

-- Fetch Owned Cars
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedCars', function(source, cb)
	local ownedCars = {}
	
	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND `stored` = @stored', {
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'car',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type', {
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'car'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	end
end)

-- Store Vehicles
ESX.RegisterServerCallback('esx_advancedgarage:storeVehicle', function (source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)
	
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE (owner = @player OR LOWER(`owner`) = @gang) AND plate = @plate', {
		['@player'] = xPlayer.identifier,
		['@gang'] = string.lower(xPlayer.gang.name),
		['@plate'] = vehicleProps.plate
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then

				cb(true)
				
			else
				if Config.KickPossibleCheaters == true then
					if Config.UseCustomKickMessage == true then
						print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehiclemodel..'. Original Vehicle: '..originalvehprops.model):format(GetPlayerIdentifiers(source)[1]))
						exports.BanSql:BanTarget(xPlayer.source, "Tried to change vehicle hash", "Cheat vehicle hash changer")
						cb(false)
					else
						print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehiclemodel..'. Original Vehicle: '..originalvehprops.model):format(GetPlayerIdentifiers(source)[1]))
						exports.BanSql:BanTarget(xPlayer.source, "Tried to change vehicle hash", "Cheat vehicle hash changer")
						cb(false)
					end
				else
					print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehiclemodel..'. Original Vehicle: '..originalvehprops.model):format(GetPlayerIdentifiers(source)[1]))
					cb(false)
				end
			end
		else
			print(('esx_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(GetPlayerIdentifiers(source)[1]))
			cb(false)
		end
	end)
end)

-- Fetch Pounded Aircrafts
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifier(source),
		['@Type']   = 'aircraft',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAircrafts, vehicle)
		end
		cb(ownedAircrafts)
	end)
end)

-- Fetch Pounded Boats
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedBoats', function(source, cb)
	local ownedBoats = {}
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifier(source),
		['@Type']   = 'boat',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedBoats, vehicle)
		end
		cb(ownedBoats)
	end)
end)

-- Fetch Pounded Cars
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedCars', function(source, cb)
	local ownedCars = {}
	xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE (owner = @player or LOWER(`owner`) = @gang) AND Type = @Type AND `stored` = @stored', {
		['@player'] = xPlayer.identifier,
		['@gang'] 	= string.lower(xPlayer.gang.name),
		['@Type']   = 'car',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, {vehicle = vehicle, policeI = v.policei})
		end
		cb(ownedCars)
	end)
end)

-- Fetch Pounded Cars by police
ESX.RegisterServerCallback('esx_advancedgarage:getPoundedPolice', function(source, cb, target)
	local ownedCars = {}
	xPlayer = ESX.GetPlayerFromId(target)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE (owner = @player or LOWER(`owner`) = @gang) AND Type = @Type AND `stored` = @stored AND policei = true', {
		['@player'] = xPlayer.identifier,
		['@gang'] 	= string.lower(xPlayer.gang.name),
		['@Type']   = 'car',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, vehicle)
		end
		cb(ownedCars)
	end)
end)

RegisterCommand("rl", function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "police" and xPlayer.job.grade >= 1 then
		if not args[1] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat pelak chizi vared nakardid!")
			return
		end

		local plate = table.concat(args, " ")
		MySQL.Async.fetchAll('SELECT `owner`, policei, `stored` FROM owned_vehicles WHERE `plate` = @plate', {
			['@plate'] = plate
		}, function(data) 
			if data[1] then
				if not data[1].stored then
					if data[1].owner ~= GetPlayerIdentifier(source) then
						if data[1].policei then
							local zPlayer = ESX.GetPlayerFromIdentifier(data[1].owner)
							if zPlayer then
								if zPlayer.bank >= 20000 then
									zPlayer.removeBank(20000)

									MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true, `policei` = false WHERE `plate` = @plate', {
										['@plate'] = plate,
									}, function(rows)
										if rows > 0 then
											TriggerClientEvent('chatMessage', zPlayer.source, "[SYSTEM]", {255, 0, 0}, "Mashin shoma ba shomare pelak ^2" .. plate .. "^0 azad shod!")
											TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Mashin ba shomare pelak ^2" .. plate .. "^0 ba movafaghiat azad shod!")
										else
											TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Khatayi dar azad kardan mashin pish amad be developer etela dahid!")
										end
									end)

								else
									TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Player mored nazar^2 20000$ ^0 baraye azad kardan mashin nadarad!")
								end
							else
								if ESX.DoesGangExist(data[1].owner, 1) then
									TriggerEvent('gangaccount:getGangAccount', 'gang_' .. string.lower(data[1].owner), function(account)
										if account.money >= 20000 then 

											account.removeMoney(20000)
											MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true, `policei` = false WHERE `plate` = @plate', {
												['@plate'] = plate,
											}, function(rows)
												if rows > 0 then
													TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Mashin ba shomare pelak ^2" .. plate .. "^0 ba movafaghiat azad shod!")
												else
													TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Khatayi dar azad kardan mashin pish amad be developer etela dahid!")
												end
											end)

										else
											TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Sherkat mored nazar^2 20000$ ^0 baraye azad kardan mashin nadarad!")
										end
									end)
								else
									TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Player mored nazar online nist!")
								end
							end
						else
							TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "In mashin tavasot police impound nashode ast!")
						end
					else
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma nemitavanid mashin khodetan ra azad konid!")
					end
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Mashin mored nazar dar impound nist!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Pelak vared shode eshtebah ast!")
			end
		end)

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
	end
end, false)

-- Fetch Pounded Policing Vehicles
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedPolicingCars', function(source, cb)
	local ownedPolicingCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@job']    = 'police',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedPolicingCars, vehicle)
		end
		cb(ownedPolicingCars)
	end)
end)

-- Fetch Pounded Ambulance Vehicles
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedAmbulanceCars', function(source, cb)
	local ownedAmbulanceCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@job']    = 'ambulance',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAmbulanceCars, vehicle)
		end
		cb(ownedAmbulanceCars)
	end)
end)

-- Check Money for Pounded Aircrafts
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyAircrafts', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.AircraftPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Boats
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyBoats', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.BoatPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Cars
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyCars', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.CarPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Repair cost fee
ESX.RegisterServerCallback('esx_advancedgarage:checkRepairCost', function(source, cb, fee)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= fee then
		cb(true)
	else
		cb(false)
	end
end)
-- Check Money for Pounded Policing
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyPolicing', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.PolicingPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Ambulance
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyAmbulance', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.AmbulancePoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Pay for Pounded Aircrafts
RegisterServerEvent('esx_advancedgarage:payAircraft')
AddEventHandler('esx_advancedgarage:payAircraft', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.AircraftPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.AircraftPoundPrice)
end)

-- Pay for Pounded Boats
RegisterServerEvent('esx_advancedgarage:payBoat')
AddEventHandler('esx_advancedgarage:payBoat', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.BoatPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.BoatPoundPrice)
end)

-- Set Vehicle police impound
RegisterServerEvent('esx_advancedgarage:policeImpound')
AddEventHandler('esx_advancedgarage:policeImpound', function(plate)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "police" and xPlayer.job.grade >= 1 then

		MySQL.Async.fetchAll('SELECT `owner` FROM owned_vehicles WHERE `plate` = @plate', {
			['@plate'] = plate
		}, function(data) 
			if data[1] then

				MySQL.Async.execute('UPDATE owned_vehicles SET `policei` = true WHERE `plate` = @plate', {
					['@plate'] = plate
				}, function(rows)
					if rows > 0 then
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Mashin ba shomare pelak ^2" .. plate .. "^0 ba movafaghiat impound shod!")
					else
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Khatayi dar impound kardan mashin pish amad be developer etelaa dahid!")
					end
				end)

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Mashin impound shod vali saheb khasi nadasht!")
			end
		end)

	end
end)

RegisterServerEvent('esx_advancedgarage:ResponseFindVehicle')
AddEventHandler('esx_advancedgarage:ResponseFindVehicle', function(accessible, plate)
	VehicleWanted[plate].setState(accessible)
end)

RegisterServerEvent('esx_advancedgarage:StartFindingVehicle')
AddEventHandler('esx_advancedgarage:StartFindingVehicle', function(plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not VehicleWanted[plate] then
		xPlayer.removeMoney(Config.CarPoundPrice)
		VehicleWanted[plate] = CreateVehicleWanted(plate, _source)
		TriggerClientEvent('esx:showNotification', source, 'Shoma Mablaqe ' .. Config.CarPoundPrice .. ' Pardakht Kardid, Ma Dar hale Jostojoye Baraye Mashine Shoma hastim!')
		DeleteEVehicleByPlate(plate)
		TriggerClientEvent('esx_advancedgarage:FindVehicle', -1, plate)
	else
		TriggerClientEvent('esx:showNotification', source, 'Mashin shoma dar list mashin haye gom shode sabt shode, lotfan sabor bashid')
	end
end)

-- Pay for Pounded Policing
RegisterServerEvent('esx_advancedgarage:payPolicing')
AddEventHandler('esx_advancedgarage:payPolicing', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.PolicingPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.PolicingPoundPrice)
end)

-- Pay for Pounded Ambulance
RegisterServerEvent('esx_advancedgarage:payAmbulance')
AddEventHandler('esx_advancedgarage:payAmbulance', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.AmbulancePoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.AmbulancePoundPrice)
end)

-- Pay to Return Broken Vehicles
RegisterServerEvent('esx_advancedgarage:payhealth')
AddEventHandler('esx_advancedgarage:payhealth', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(price)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. price)
end)

-- Modify State of Vehicles
RegisterServerEvent('esx_advancedgarage:setVehicleState')
AddEventHandler('esx_advancedgarage:setVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)