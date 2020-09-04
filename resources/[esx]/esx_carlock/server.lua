ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('carlock:isVehicleOwner', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = GetPlayerIdentifier(source, 0)
	local gangName = xPlayer.gang.name

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(result[1].owner == identifier or result[1].owner == gangName)
		else
			cb(false)
		end
	end)
end)