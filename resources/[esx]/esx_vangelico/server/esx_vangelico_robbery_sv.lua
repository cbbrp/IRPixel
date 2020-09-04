local rob = false
local robbers = {}
PlayersCrafting    = {}
local CopsConnected  = 0
ESX = nil
local thiefs = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('esx_vangelico_robbery:toofar')
AddEventHandler('esx_vangelico_robbery:toofar', function(robb)
	local source = tonumber(source)
	if(robbers[source])then

		local identifier = GetPlayerIdentifier(source)
		thiefs[identifier] = nil
		rob = false

		for k,v in pairs(exports.esx_scoreboard:GetJob("police")) do
			TriggerClientEvent('esx:showNotification', k, _U('robbery_cancelled_at') .. Stores[robb].nameofstore)
			TriggerClientEvent('esx_vangelico_robbery:killblip', k)
		end

		TriggerClientEvent('esx_vangelico_robbery:toofarlocal', source)
		local info = {source = source, type = "Jewels", action = "Canceld (Faar)", location = "Rockford Hills"}
		exports.sniperlog:RobLog(info)
		TriggerClientEvent('esx:showNotification', source, _U('robbery_has_cancelled') .. Stores[robb].nameofstore)
		robbers[source] = nil

	end
end)

RegisterServerEvent('esx_vangelico_robbery:endrob')
AddEventHandler('esx_vangelico_robbery:endrob', function(robb, details)
	local source = tonumber(source)
	if source and robbers[source] then

		rob = false
		for k,v in pairs(exports.esx_scoreboard:GetJob("police")) do
			TriggerClientEvent('esx:showNotification', k, _U('end'))
			TriggerClientEvent('esx_vangelico_robbery:killblip', k)
		end
		
		local info = {source= source, type = "Jewels", action = "Completed", location = "Rockford Hills"}
		exports.sniperlog:RobLog(info)
		robbers[source] = nil
	
	else
		exports.sniperlog:RobLog(details)
		robbers[details.source] = nil
	end
end)

RegisterServerEvent('esx_vangelico_robbery:rob')
AddEventHandler('esx_vangelico_robbery:rob', function(robb)

	local source = tonumber(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if Stores[robb] then

		local store = Stores[robb]

		if (os.time() - store.lastrobbed) < Config.SecBetwNextRob and store.lastrobbed ~= 0 then

            TriggerClientEvent('esx_vangelico_robbery:togliblip', source)
			TriggerClientEvent('esx:showNotification', source, _U('already_robbed') .. (Config.SecBetwNextRob - (os.time() - store.lastrobbed)) .. _U('seconds'))
			return
		end

		if rob == false then

			rob = true
			for k,v in pairs(exports.esx_scoreboard:GetJob("police")) do
				TriggerClientEvent('esx:showNotification', k, _U('rob_in_prog') .. store.nameofstore)
				TriggerClientEvent('esx_vangelico_robbery:setblip', k, Stores[robb].position)
			end

			thiefs[xPlayer.identifier] = 0
			TriggerClientEvent('esx:showNotification', source, _U('started_to_rob') .. store.nameofstore .. _U('do_not_move'))
			TriggerClientEvent('esx:showNotification', source, _U('alarm_triggered'))
			TriggerClientEvent('esx:showNotification', source, _U('hold_pos'))
			TriggerClientEvent('esx_vangelico_robbery:currentlyrobbing', source, robb)
			robbers[source] = {robbery = robb, details = {source = source, type = "Jewels", action = "Canceld (Exit)", location = "Rockford Hills", discord = exports.sniperlog:GetDiscord(source), name = GetPlayerName(source), icname = exports.essentialmode:IcName(source)}}
			local info = {source = source, type = "Jewels", action = "Started", location = "Rockford Hills"}
			exports.sniperlog:RobLog(info)
			Stores[robb].lastrobbed = os.time()
			
		else
			TriggerClientEvent('esx:showNotification', source, _U('robbery_already'))
		end
	end
end)

RegisterServerEvent('esx_vangelico_robbery:gioielli')
AddEventHandler('esx_vangelico_robbery:gioielli', function()

	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier

	if thiefs[identifier] ~= nil and thiefs[identifier] <= 20 then
		xPlayer.addInventoryItem('jewels', math.random(Config.MinJewels, Config.MaxJewels))
		thiefs[identifier] = thiefs[identifier] + 1
	else
		exports.BanSql:BanTarget(xPlayer.source, "Attempted to carry jewels more than it's possible", "Cheat lua executor")
	end
	
end)

RegisterServerEvent('lester:vendita')
AddEventHandler('lester:vendita', function()

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item      = xPlayer.getInventoryItem("jewels")

	if item.count >= Config.MaxJewelsSell then
		local reward = math.floor(Config.PriceForOneJewel * Config.MaxJewelsSell)

		xPlayer.removeInventoryItem('jewels', Config.MaxJewelsSell)
		xPlayer.addMoney(reward)
	else
		exports.BanSql:BanTarget(xPlayer.source, "Attempted to sell jewels without having them", "Cheat lua executor")
	end

end)

AddEventHandler('playerDropped', function()
	local _source = tonumber(source)
	
	if _source ~= nil then
		
		if robbers[_source] then
			TriggerEvent('esx_vangelico_robbery:endrob', robbers[_source].robbery, robbers[_source].details)
		end
		
	end	
end)

ESX.RegisterServerCallback('esx_vangelico_robbery:conteggio', function(source, cb)
	cb(exports.esx_scoreboard:GetCounts("police"))
end)