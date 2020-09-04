ESX              = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addGroupCommand', 'setgps', 'user', function(source, args, user)
	TriggerClientEvent('gpstools:setgps', source, {
		x = tonumber(args[1]),
		y = tonumber(args[2])
	})
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, 'Insufficient Permissions.')
end, {help = 'Sets the GPS to the specified coords', params = {{name = 'x', help = 'X coords'}, {name = 'y', help = 'Y coords'}}})

TriggerEvent('es:addGroupCommand', 'getpos', 'user', function(source, args, user)
	TriggerClientEvent('gpstools:getpos', source)

end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, 'Insufficient Permissions.')
end, {help = 'Gets the player\'s current position'})

TriggerEvent('es:addGroupCommand', 'togglegps', 'user', function(source, args, user)
	TriggerClientEvent('gpstools:togglegps', source)

end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, 'Insufficient Permissions.')
end, {help = 'Toggle the big gps'})

TriggerEvent('es:addAdminCommand', 'tpw', 1, function(source, args, user)

	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('aduty') then
		TriggerClientEvent('gpstools:tpwaypoint', source)
	else

		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

	end

end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, 'Insufficient Permissions.')
end, {help = 'TP to the way-point selected on GPS'})