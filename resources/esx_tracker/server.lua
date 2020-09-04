ESX = nil
local Blips = {

	["police"] = {

	},

	["ambulance"] = {

	},

	["government"] = {

	},

	["doc"] = {
		 
	},

	["mecano"] = {

	},

	["taxi"] = {

	},

	["weazel"] = {
		
	}
	
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('playerDropped', function()
	local _source = source
	
	if _source ~= nil then

		local part = isPlayerPartOfAnyBlip(_source)
		if part then
			Blips[part][_source] = nil
			TriggerClientEvent('esx_tracker:updateTable', -1, Blips)
		end
		
	end	
end)

AddEventHandler('esx:playerLoaded',function(source, xPlayer)
	if xPlayer then
		if Blips[xPlayer.job.name] then
			Blips[xPlayer.job.name][source] = {id = source, name = string.gsub(xPlayer.name, "_", " "), job = xPlayer.job, gang = xPlayer.gang}
			TriggerClientEvent('esx_tracker:updateTable', -1, Blips)
			Wait(300)
			TriggerClientEvent('esx_tracker:updateBlips', -1, xPlayer.job.name)
		end
	end
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	local part = isPlayerPartOfAnyBlip(playerId)

	if part then
		Blips[part][playerId] = nil
		TriggerClientEvent('esx_tracker:updateTable', -1, Blips)
		Wait(300)
		TriggerClientEvent('esx_tracker:updateBlips', -1, part)
	end

	if Blips[job.name] then
		local xPlayer = ESX.GetPlayerFromId(playerId)

		  if xPlayer then
			 Blips[xPlayer.job.name][xPlayer.source] = {id = xPlayer.source, name = string.gsub(xPlayer.name, "_", " "), job = xPlayer.job, gang = xPlayer.gang}
			 TriggerClientEvent('esx_tracker:updateTable', -1, Blips)
			 Wait(300)
			 TriggerClientEvent('esx_tracker:updateBlips', -1, xPlayer.job.name)
		  end

	end
	
end)

-- AddEventHandler('onResourceStart', function(resourceName)
-- 	if (GetCurrentResourceName() == resourceName) then
-- 	  Wait(2000)
-- 	  local xPlayers = ESX.GetPlayers()
-- 		for i=1, #xPlayers, 1 do

-- 		  local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

-- 			if xPlayer then
-- 			  if Blips[xPlayer.job.name] then
-- 				 Blips[xPlayer.job.name][xPlayer.source] = {id = xPlayer.source, name = string.gsub(xPlayer.name, "_", " "), job = xPlayer.job, gang = xPlayer.gang}
-- 			  end
-- 			end

-- 		end
-- 		TriggerClientEvent('esx_tracker:updateTable', -1, Blips)
-- 		Wait(300)
-- 	end
-- end)


RegisterCommand('templ', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "police" and xPlayer.hasDivision("xray") then
		if not args[1] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat ID chizi vared nakardid!")
			return
		end

		if not tonumber(args[1]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat ID faghat adad mitavanid vared konid!")
			return
		end

		local target = tonumber(args[1])

		if not GetPlayerName(target) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "ID vared shode eshtebah ast!")
			return
		end

		if not args[2] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat status chizi vared nakardid!")
			return
		end

		if args[2] == "true" then
			TriggerClientEvent('esx_tracker:flyLicense', target, true)
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma vaziat license movaghat ^3" .. GetPlayerName(target) .. "^0 ra be ^2true ^0taghir dadid!")
		elseif args[2] == "false" then
			TriggerClientEvent('esx_tracker:flyLicense', target, false)
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma vaziat license movaghat ^3" .. GetPlayerName(target) .. "^0 ra be ^1false ^0taghir dadid!")
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat status meghdar eshtebahi gharar kardid!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
	end
end, false)



ESX.RegisterServerCallback('esx_tracker:getBlips', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "ambulance" or xPlayer.job.name == "police" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then
		cb(Blips)
	else
		exports.BanSql:BanTarget(source, "Tried to fetch blips without permission", "Cheat lua executor")
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_tracker:CheckLicense', function(source, cb)
	local identifier = GetPlayerIdentifier(source)
	PerformHttpRequest("https://irpixel.ir/ChekLicsence.php?id=" .. identifier, function (errorCode, resultData, resultHeaders)

		if errorCode == 200 then
			if resultData ~= "SIKTIR" then
				local license = json.decode(resultData)

				if license.fly then
					cb(true)
				else
					cb(false)
				end

			else
				TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Khatayi dar gereftan license shoma pish amad lotfan be developer etelaa dahid!")
				cb(false)
			end
		else
			TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Khatayi dar gereftan license shoma pish amad lotfan be developer etelaa dahid!")
			cb(false)
		end

	end, "GET")
end)

function isPlayerPartOfAnyBlip(source)
	for k,v in pairs(Blips) do
		if Blips[k][source] then
			return k
		end
	end

	return false
end
