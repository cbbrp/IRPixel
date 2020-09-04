local rob = false
local robbers = {}
local robbingStores = {}
local activeRobberys = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_holdup:toofar')
AddEventHandler('esx_holdup:toofar', function(robb)
	local _source = source
	rob = false
	for k,v in pairs(exports.esx_scoreboard:GetJob("police")) do
		TriggerClientEvent('esx:showNotification', k, _U('robbery_cancelled_at', Stores[robb].nameofstore))
		TriggerClientEvent('esx_holdup:killblip', k, Stores[robb].nameofstore)
		if robbingStores[Stores[robb].nameofstore] then
			robbingStores[Stores[robb].nameofstore] = nil
		end
	end

	if robbers[_source] then
		TriggerClientEvent('esx_holdup:toofarlocal', _source)
		robbers[_source] = nil
		TriggerClientEvent('esx:showNotification', _source, _U('robbery_cancelled_at', Stores[robb].nameofstore))
	end
end)

RegisterServerEvent('esx_holdup:rob')
AddEventHandler('esx_holdup:rob', function(robb)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local oocname =  GetPlayerName(source)

	if Stores[robb] then
		local store = Stores[robb]

		if (os.time() - store.lastrobbed) < Config.TimerBeforeNewRob and store.lastrobbed ~= 0 then
			TriggerClientEvent('esx:showNotification', _source, _U('recently_robbed', Config.TimerBeforeNewRob - (os.time() - store.lastrobbed)))
			return
		end

		if not rob then
			if exports.esx_scoreboard:GetCounts("police") >= Config.PoliceNumberRequired then

				-- local blowtorch = xPlayer.getInventoryItem("blowtorch")

				-- if blowtorch.count > 0 then
					local name = exports.esx_shop:GetShopName(store.number) .. " " ..  store.nameofstore

					for k,v in pairs(exports.esx_scoreboard:GetJob("police")) do
						TriggerClientEvent('esx:showNotification', k, _U('rob_in_prog', name))
						TriggerClientEvent('esx_holdup:setblip', k, store.nameofstore, store.position)
					end

					-- xPlayer.removeInventoryItem("blowtorch", 1)
					local info = {source= _source, type = "Shop", action = "Started", location = name}
					exports.sniperlog:RobLog(info)

					TriggerClientEvent('esx_holdup:currentlyrobbing', _source, robb)
					TriggerClientEvent('esx_holdup:dotherobbery', _source, robb)
					robbingStores[store.nameofstore] = store.position
					Stores[robb].lastrobbed = os.time()
					activeRobberys[_source] = {robbery = robb, details = {source = _source, type = "Shop", action = "Canceld (Exit)", location = name, discord = exports.sniperlog:GetDiscord(_source), name = GetPlayerName(_source), icname = exports.essentialmode:IcName(_source)}}
				
				-- else

				-- TriggerClientEvent('esx:showNotification', _source, 'Shoma baraye baaz kardan sandogh bayad ~y~BlowTorch ~s~dashte bashid!')
				
				-- end
	
			else
				TriggerClientEvent('esx:showNotification', _source, _U('min_police', Config.PoliceNumberRequired))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('robbery_already'))
		end
	end
end)

RegisterServerEvent('esx_holdup:robcomplete')
AddEventHandler('esx_holdup:robcomplete', function(robb)

	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local store = Stores[robb]
	local name = exports.esx_shop:GetShopName(store.number) .. " " ..  store.nameofstore

		local shopRemove = exports.esx_shop:RobShop(store.number)
		local award = store.reward + shopRemove
		local info = {source= _source, type = "Shop", action = "Completed", location = name, amount = award}
		exports.sniperlog:RobLog(info)
		TriggerClientEvent('esx_holdup:robberycomplete', _source, award)
		xPlayer.addMoney(award)
		if activeRobberys[_source] then activeRobberys[_source] = nil end

	for k,v in pairs(exports.esx_scoreboard:GetJob("police")) do
		TriggerClientEvent('esx:showNotification', k, _U('robbery_complete_at', name))
		TriggerClientEvent('esx_holdup:killblip', k, store.nameofstore)
		if robbingStores[store.nameofstore] then
			robbingStores[store.nameofstore] = nil
		end
	end
	
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	if xPlayer.job.name == "police" then
		for k,v in pairs(robbingStores) do
			TriggerClientEvent('esx_holdup:setblip', xPlayer.source, k, v)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('rob_in_prog', k))
		end
	end
end)

AddEventHandler('playerDropped', function()
	local _source = source
	
	if _source ~= nil then
		
		if activeRobberys[_source] then
			TriggerEvent('esx_holdup:robcancel', activeRobberys[_source].robbery, activeRobberys[_source].details)
		end
		
	end	
end)

RegisterServerEvent('esx_holdup:robcancel')
AddEventHandler('esx_holdup:robcancel', function(robb, details)

	local _source = tonumber(source)
	local store = Stores[robb]
	local award = store.reward
	local name = exports.esx_shop:GetShopName(store.number) .. " " ..  store.nameofstore

	if activeRobberys[_source] then activeRobberys[_source] = nil end

	if _source then
		local info = {source = _source, type = "Shop", action = "Canceld", location = name}
		exports.sniperlog:RobLog(info)
	else
		exports.sniperlog:RobLogF(details)
	end
	
	for k,v in pairs(exports.esx_scoreboard:GetJob("police")) do
		TriggerClientEvent('esx:showNotification', k, "Robbery dar " .. store.nameofstore .. " cancel shod" )
		TriggerClientEvent('esx_holdup:killblip', k, store.nameofstore)
		if robbingStores[store.nameofstore] then
			robbingStores[store.nameofstore] = nil
		end
	end
	
end)