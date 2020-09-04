ESX                = nil
AdminPlayers = {}
tempOown = false
local rcount = 1
local reports = {}
local chats = {}
local event = {name = "none", coords = "nothing", status = true}

local resetaccountAceess = {

	'steam:110000111236158', -- matindark
	'steam:11000011539ffc4', -- Meti7Khat
	'steam:11000010934a428' -- Quiet

}

local disbandfamilyAceess = {

	'steam:110000111236158', -- matindark
	'steam:11000011539ffc4', -- Meti7Khat
	'steam:11000010934a428' -- Quiet

}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerDropped', function(source, reason)

	local _source = source

	if _source ~= nil then

		local identifier = GetPlayerIdentifier(_source)
		local name = GetPlayerName(_source)
		-- [Save into audit log]
		exports.ghmattimysql:execute('INSERT INTO audit (`identifier`, `id` ,`oname`, `timestamp`, `type`) VALUES (@identifier, @id, @name, @timestamp, @type)', {
			['identifier'] = identifier,
			['id'] = tonumber(_source),
			['name'] = name,
			['timestamp'] = os.time(),
			['type'] = "Exit(" .. reason .. ")"
		}, function(result)
			if not result or result.affectedRows <= 0 then
				print("Failed to save " .. name .. "Exit log!")
			end
		end)
		-- end of it

		if AdminPlayers[identifier] ~= nil then
			AdminPlayers[identifier] = nil
			TriggerClientEvent('aduty:set_tags', -1, AdminPlayers)
			TriggerEvent('DiscordBot:ToDiscord', 'duty', name, 'OffDuty shod','user', true, _source, false)
		end

	end

end)

AddEventHandler('esx:playerLoaded', function(source)
	local identifier = GetPlayerIdentifier(source)

	TriggerClientEvent('aduty:set_tags', -1, AdminPlayers)

	-- [Save into audit log]
	exports.ghmattimysql:execute('INSERT INTO audit (`identifier`, `id`, `oname`, `timestamp`, `type`) VALUES (@identifier, @id, @name, @timestamp, @type)', {
		['identifier'] = identifier,
		['id'] = tonumber(source),
		['name'] = GetPlayerName(source),
		['timestamp'] = os.time(),
		['type'] = "Enter"
	}, function(result)
		if not result or result.affectedRows <= 0 then
			print("Failed to save " .. name .. "Enter log!")
		end
	end)
	-- end of it

	for k,v in pairs(reports) do
		if v.owner.identifier == identifier then
			v.owner.id = source
		end
	end

end)

RegisterServerEvent("aduty:statusHandler")
AddEventHandler("aduty:statusHandler", function(status)

	tempOown = status

end)

RegisterServerEvent("aduty:changeDutyStatus")
AddEventHandler("aduty:changeDutyStatus", function()

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.set('aduty', false)
	end

end)

RegisterServerEvent("aduty:setEventCoords")
AddEventHandler("aduty:setEventCoords", function(coords)

	if coords == nil then return end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 9 then

		event.coords = coords
		TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^0Event ^3" .. event.name .. "^0 shoro shode ^1/event ^0jahat join dadan be event")

	else
		exports.BanSql:BanTarget(source, "Tried to modify event coords without permission", "Cheat lua executor")
	end

end)

-- RegisterServerEvent("aduty:playerLoaded")
-- AddEventHandler("aduty:playerLoaded", function()

-- 	TriggerClientEvent('aduty:set_tags', -1, AdminPlayers)

-- end)

ESX.RegisterServerCallback('esx_aduty:checkdutystatus', function(source, cb, target)
	CheckPlayerDutyStatus(target, cb)
end)

ESX.RegisterServerCallback('esx_aduty:doesGangExist', function(source, cb, name, grade)
	if ESX.DoesGangExist(name, grade) then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_aduty:checkAdmin', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	if not xPlayer then
		cb(false)
		return
	end
	
		if xPlayer.permission_level > 1 then
			cb(true)
		else
			cb(false)
		end

end)

ESX.RegisterServerCallback('esx_aduty:getEventCoords', function(source, cb)

	cb(event.coords)

end)

ESX.RegisterServerCallback('esx_aduty:getAdminPerm', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	cb(xPlayer.permission_level)

end)

ESX.RegisterServerCallback('esx_aduty:checkAduty', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 1 then
		cb(xPlayer.get('aduty'))
	else
		cb(false)
	end
	
end)

RegisterCommand('event', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not args[1] then
		if event.name ~= "none" then
			if event.status ~= true then
				if event.coords ~= "nothing" then
					TriggerClientEvent('aduty:tpEvent', source, event.coords)
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Hich coordi baraye event tarif nashode ast be admin etelaa dahid!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Event ghofl shode ast digar nemitavanid join dahid!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Eventi baraye TP shodan vojod nadarad!")
		end
		return
	end

	if xPlayer.permission_level >= 9 then
		if args[1] == "set" then
			if event.name == "none" then
				
				if not args[2] then
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma esm event ra vared nakardid!")
					return
				end
				local eventName = table.concat(args, " ", 2)

				event.status = false
				event.name = eventName
				TriggerClientEvent('aduty:setEventCoords', source)

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Ghablan yek event start shode ast nemitavanid start konid!")
			end
		elseif args[1] == "status" then
			if event.name ~= "none" then
				
				if args[2] == "true" then
					
					event.status = true
					TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^0Event ^3" .. event.name .. "^0 ^1ghofl^0 shod, digar nemitavanid join dahid!")

				elseif args[2] == "false" then
					
					event.status = false
					TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^0Event ^3" .. event.name .. "^0 ^2baaz^0 shod, mitavanid join dahid!")

				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat vaziat faghat mitavanid true/false vared konid!")
				 end

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Hich eventi shoro nashode ast!")
			end
		elseif args[1] == "remove" then
			if event.name ~= "none" then
				
				TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^0Event ^3" .. event.name .. "^0 ^2baste^0 shod, mamnon az tamam kasani ke join dadand!")
				event.status = true
				event.name = "none"
				event.coords = "nothing"

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Hich eventi shoro nashode ast!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Argument vared shode eshtebah ast!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kaafi baraye ^1estefade ^0az in dastor nadarid!")
	end
end, false)

RegisterCommand('aduty', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 1 then

		if xPlayer.get('aduty') then

			DutyHandler(source, false)

		else

			if not xPlayer.get('jailed') then

				DutyHandler(source, true)

			else

				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid hengami ke ^1jail ^0shodid ^2OnDuty ^0konid!")

			end

		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
	end
end)

function DutyHandler(target, state)
	local xPlayer = ESX.GetPlayerFromId(target)
	if state then
		xPlayer.set('aduty', true)
		AdminPlayers[xPlayer.identifier] = {source = xPlayer.source, permission = xPlayer.permission_level, hide = false}
		TriggerClientEvent('aduty:tagChanger', xPlayer.source, true)
		TriggerClientEvent('OnDutyHandler', xPlayer.source)
		TriggerClientEvent('aduty:addSuggestions', xPlayer.source)
		TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^2OnDuty ^0Shodid!")
	else
		xPlayer.set('aduty', false)
		AdminPlayers[xPlayer.identifier] = nil
		TriggerClientEvent('aduty:tagChanger', xPlayer.source, false)
		TriggerClientEvent("OffDutyHandler", xPlayer.source)
		TriggerClientEvent('aduty:removeSuggestions', xPlayer.source)
		TriggerClientEvent('aduty:visibleForce', xPlayer.source)
		TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1OffDuty ^0Shodid!")
	end
end

-- RegisterCommand('atoggle', function(source)
-- 	local xPlayer = ESX.GetPlayerFromId(source)

-- 	if xPlayer.permission_level > 0 then

-- 		if xPlayer.get('aduty') then

-- 			if AdminPlayers[xPlayer.identifier].hide == false then

-- 				AdminPlayers[xPlayer.identifier].hide = true
-- 				TriggerClientEvent('aduty:tagChanger', source, true, true)
-- 				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^2tag^0 khod ra khamosh kardid")

-- 			else

-- 				AdminPlayers[xPlayer.identifier].hide = false
-- 				TriggerClientEvent('aduty:tagChanger', source, false, false)
-- 				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^2tag^0 khod ra roshan kardid")

-- 			end

-- 		else
-- 			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")
-- 		end

-- 	else
-- 		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
-- 	end

-- end, false)

RegisterCommand('owntoggle', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level > 0 then

		if xPlayer.get('aduty') then

			TriggerClientEvent('esx_idoverhead:toggleOwn', source)

		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
	end

end, false)

RegisterCommand('daall', function(source , args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 5 then

		if args[1] then

			local model = GetHashKey(args[1])
			TriggerClientEvent('esx_aduty:dobject', -1, model)

		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat object name chizi vared nakardid")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
	end

end, false)

RegisterCommand('changename', function(source , args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 9 then

		if args[1] then

			if not tonumber(args[1]) then TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!") return end

			if not args[2] then TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat esm chizi vared nakardid") return end

			local target = tonumber(args[1])

			if GetPlayerName(target) then
				local zPlayer = ESX.GetPlayerFromId(target)
				if zPlayer then
					zPlayer.setName(args[2])
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ba movafaghiat esm ^1" .. GetPlayerName(target) .. "^0 ra be ^3" .. args[2] .. "^0 taghir dadid!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID vared shode eshtebah ast!")
			end

		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID chizi vared nakardid!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
	end

end, false)

RegisterCommand("changeped", function(source, args, user)

	local xPlayer = ESX.GetPlayerFromId(source)

			if xPlayer.permission_level >= 2 then

				if xPlayer.get('aduty') then

					if args[1] then

						if args[2] == nil then

							local requestped = tostring(args[1])
							TriggerClientEvent("aduty:pedHandler", source, requestped)

						else

							TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma esm ped ra faghat bayad dar argument aval vared konid")

						end

					else

						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma hich pedi vared nakardid")


					end

				else

					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

				end

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
			end

end)

RegisterCommand('resetped', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 2 then

		if xPlayer.get('aduty') then

			if not args[1] then
				TriggerClientEvent("resetpedHandler", source)
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Ped shoma ba movafaghat reset shod!")
			else

				target = tonumber(args[1])
				if not target then
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
					return
				end
				local name = GetPlayerName(target)
				if not name then
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID vared shode eshtebah ast")
					return
				end

				TriggerClientEvent("resetpedHandler", target)
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma PED " .. name .. " ra ba movafaghiat reset kardid")
				TriggerClientEvent('chatMessage', target, "[SYSTEM]", {255, 0, 0}, " ^PED shoma tavasot admin reset shod")

			end

		else

			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
	end


end)

RegisterCommand('bringall', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 9 then

		if xPlayer.get('aduty') then

			TriggerClientEvent('aduty:bringALL', -1, source)

		else

			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
	end


end)

RegisterCommand("aw", function(source, args)

local xPlayer = ESX.GetPlayerFromId(source)

if xPlayer.permission_level > 1 then
		if args[1] and args[2] then
			if tonumber(args[1]) then
				local target = tonumber(args[1])
				if GetPlayerName(target) then

				local targetPlayer = ESX.GetPlayerFromId(target)
				local message = table.concat(args, " ",2)

					TriggerClientEvent('chatMessage', target, "^0(^1" .. "^1Admin | " .. GetPlayerName(source) .. "^0)" .. " ^3>>", {255, 0, 0}, "^0" .. message)
					TriggerClientEvent('chatMessage', source, "^0(^1" .. GetPlayerName(target) .. "^0)" .. " ^3>>", {255, 0, 0}, "^0" .. message)

				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online nist!")
				end

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
			end

		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Syntax vared shode eshtebah ast!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
	end

end)


RegisterCommand('flip', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 2 then
		local target

		if not args[1] then
			target = source
		else
			target = tonumber(args[1])
			if target then
				if not GetPlayerName(target) then
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID vared shode eshtebah ast!")
					return
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
				return
			end
		end

		TriggerClientEvent('aduty:flip', target)

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
	end
end, false)

RegisterCommand("setarmor", function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 7 then

				if xPlayer.get('aduty') then

					if args[1] and args[2] then
						if tonumber(args[1]) then

							local target = tonumber(args[1])

							if tonumber(args[2]) then

									local armor = tonumber(args[2])

								if armor <= 100 then

										if GetPlayerName(target) then

										local targetPlayer = ESX.GetPlayerFromId(target)

											TriggerClientEvent('chatMessage', target, "[SYSTEM]", {255, 0, 0}, " ^2" .. GetPlayerName(source) .. " ^0 Armor shomara be ^3" .. armor ..  " ^0Taghir dad!")
											TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0 Shoma be ^2 " .. GetPlayerName(target) .. "^3 " .. armor .. " ^0Armor dadid!")
											TriggerClientEvent('armorHandler', target, armor)

										else
											TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online nist!")
										end
								else
									TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid meghdar armor ra bishtar az 100 vared konid!")
								end

								else
									TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat Armor faghat mitavanid adad vared konid!")
								end

						else
							TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
						end

					else
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Syntax vared shode eshtebah ast!")
					end

				else

					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

				end

		else
			if xPlayer.permission_level > 1 then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor nadarid!")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
			end
		end

	end)

	RegisterCommand('fineoffline', function(source, args, users)
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.permission_level >= 3 then

					if xPlayer.get('aduty') then

						if args[1] and args[2] and args[3] then

								local money = tonumber(args[2])
								if money then

									MySQL.Async.fetchAll('SELECT identifier, name, playerName, bank FROM users WHERE LOWER(playerName) = @playername',
									{
										['@playername'] = string.lower(args[1])

									}, function(data)
										if data[1] then

												local zPlayer = ESX.GetPlayerFromIdentifier(data[1].identifier)
												if zPlayer then
													TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online ast!")
												   return
												end
											
												local playerMoney = data[1].bank

												if playerMoney >= money then

														local identifier = data[1].identifier
														MySQL.Async.execute('UPDATE users SET bank = bank - @money WHERE identifier=@identifier',
														{
															['@identifier'] = identifier,
															["@money"] = money

														}, function(rowsChanged)
															if rowsChanged > 0 then

																local previousmoney = playerMoney
																local currentmoney = playerMoney - money

																TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma az^1 " .. data[1].name .. " ^0Mablagh ^2" .. money .. "$ ^0kam kardid!" )
																TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Pool ghadimi ^3" .. data[1].name .. " ^1" .. previousmoney .. "$^0 Pool jadid ^2" .. currentmoney .. "$" )

																local reason = table.concat(args, " ",3)
																TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^6" .. data[1].name .. " ^2" .. money .. "$ ^0 Jarime shod be elat ^3^*" .. reason )


																MySQL.Async.execute('INSERT INTO finelog (identifier, name, oocname, reason, fineamount, punisher, date) VALUES (@identifier, @name, @oocname, @reason, @fineamount, @punisher, @date)',
																{
																	['@identifier'] = identifier,
																	['@name'] = data[1].playerName,
																	['@oocname'] = data[1].name,
																	['@reason'] = reason,
																	['@fineamount'] = money,
																	['@punisher'] = GetPlayerName(source),
																	['@date'] = os.time()
																})

															end
														end)

													else

														TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Pool player mored nazar baraye in meghdar az jarime kafi nist!")
														TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Poole ^1" .. args[1] .. " ^2" .. playerMoney .. "$ ^0ast!" )
												end


									

										else
											TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar vojoud nadarad!")
										end
									end)


								else
									TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat fine faghat mitavanid adad vared konid!")
								end

							else
								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Syntax vared shode eshtebah ast!")
							end

					else

						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

					end

		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
		end
end)

RegisterCommand('fine', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.permission_level >= 3 then

			if xPlayer.get('aduty') then

				if args[1] and args[2] and args[3] then

					local target = tonumber(args[1])
					if not target then TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ID faghat mitavanid adad vared konid!") return end

					local zPlayer = ESX.GetPlayerFromId(target)

					if not zPlayer then TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID shakhs mored nazar eshtebah ast!") return end
		
							local money = tonumber(args[2])
							if money then

							local playerMoney = zPlayer.bank

							if zPlayer.bank >= money then
								local newmoney = playerMoney - money
								zPlayer.setBank(newmoney)
								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma az^1 " .. zPlayer.name .. " ^0Mablagh ^2" .. money .. "$ ^0kam kardid!" )
								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Pool ghadimi ^3" .. zPlayer.name .. " ^1" .. playerMoney .. "$^0 Pool jadid ^2" .. newmoney .. "$" )

								local reason = table.concat(args, " ",3)
								TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^6" .. zPlayer.name .. " ^2" .. money .. "$ ^0 Jarime shod be elat ^3^*" .. reason )

								MySQL.Async.execute('INSERT INTO finelog (identifier, name, oocname, reason, fineamount, punisher, date) VALUES (@identifier, @name, @oocname, @reason, @fineamount, @punisher, @date)',
								{
									['@identifier'] = GetPlayerIdentifier(source),
									['@name'] = zPlayer.name,
									['@oocname'] = GetPlayerName(target),
									['@reason'] = reason,
									['@fineamount'] = money,
									['@punisher'] = GetPlayerName(source),
									['@date'] = os.time()
								})
								
							else
								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Pool player mored nazar baraye in meghdar az jarime kafi nist!")
								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Poole ^1" .. zPlayer.name .. " ^2" .. playerMoney .. "$ ^0ast!" )
							end

							else
								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat fine faghat mitavanid adad vared konid!")
							end

					else
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Syntax vared shode eshtebah ast!")
					end

			else

				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

			end

		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
		end
end, false)

RegisterCommand('ajailoffline', function(source, args, users)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 3 then

				if xPlayer.get('aduty') then

					if args[1] and args[2] and args[3] then

							if tonumber(args[2]) then
								local jailTime = tonumber(args[2])


							MySQL.Async.fetchAll('SELECT identifier, name, playerName FROM users WHERE LOWER(playerName) = @playername',
							{
								['@playername'] = string.lower(args[1])

							}, function(data)
								if data[1] then

									local zPlayer = ESX.GetPlayerFromIdentifier(data[1].identifier)
									if zPlayer then
										TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online ast!")
										return
									end

									local identifier =  data[1].identifier
									local sentence = {time = jailTime, type = "admin", part = 0}
									MySQL.Async.execute('UPDATE users SET jail = @data WHERE identifier = @identifier',
									{
										['@identifier'] = identifier,
										["@data"] = json.encode(sentence)

									}, function(rowsChanged)
										if rowsChanged > 0 then


												local jailReason = table.concat(args, " ",3)


													if jailTime ~= nil then


															MySQL.Async.execute('INSERT INTO adminjaillog (identifier, name, oocname, jailreason, jailtime, punisher, date) VALUES (@identifier, @name, @oocname, @reason, @jailtime, @punisher, @date)',
															{
																['@identifier'] = identifier,
																['@name'] = data[1].playerName,
																['@jailtime'] = jailTime,
																['@reason'] = jailReason,
																['@oocname'] = data[1].name,
																['@punisher']= GetPlayerName(source),
																['@date'] = os.time()
															})

																	TriggerClientEvent('chatMessage', -1, "[AdminJail]", {255, 0, 0}, " ^1" .. data[1].name .. "^0 Admin jail shod be Dalile:^2 " .. jailReason .. "^0 Be modat ^3" .. jailTime .. " ^0Daghighe")
																	TriggerEvent('DiscordBot:ToDiscord', 'ajail', 'Jail Log', data[1].name .. ' tavasot ' .. GetPlayerName(source) .. ' jail shod be modat ' .. jailTime .. ' daghighe be dalil: ' .. jailReason,'user', true, source, false)


														TriggerClientEvent("esx:showNotification", source, args[1] .. " Zendani shod baraye ~r~~h~" .. args[2] .. " ~w~Daghighe!")

													else
														TriggerClientEvent("esx:showNotification", source, "Zaman na motabar ast!")
													end

										end
									end)

									

								else
									TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar vojoud nadarad!")
								end
							end)

						else
							TriggerClientEvent('chatMessage', src, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat Zaman faghat mitavanid adad vared konid.")
						end

					else
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Syntax vared shode eshtebah ast!")
					end

				else

					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

				end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
	end
end)

RegisterCommand('plate', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level > 1 then

				if xPlayer.get('aduty') then

					if args[1] then
						local licenseplate = table.concat(args, " ")
						TriggerClientEvent("aduty:vehiclelicenseHandler", source, licenseplate)
					else
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma hich pelaki vared nakardid!")
					end

				else

					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

				end

		else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
	end
end)

RegisterCommand('a', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level > 1 then
		if args[1] then

			local name = GetPlayerName(source)
			local message = table.concat(args, " ")

			for k,v in pairs(exports.esx_scoreboard:GetAdmins()) do
				TriggerClientEvent('chatMessage', v.id, "", {255, 0, 0}, "^4[^1AdminChat^4] ^3" .. name .. "^0: " .. "^0^*" .. message .. "^4")
			end


		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid matn khali befrestid!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
	end

end)

RegisterCommand('kick', function(source, args, user)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 2 then

		if args[1] and args[2] then

			target = tonumber(args[1])

				if target then

					local name = GetPlayerName(target)
					if name then

						targetPlayer = ESX.GetPlayerFromId(target)
						local message = table.concat(args, " ", 2)
						DropPlayer(target, GetPlayerName(source) .. " Shomara kick kard be dalil: " .. message)
						TriggerClientEvent('chatMessage', -1, "[Admin]", {255, 0, 0}, "^1" .. name .. " ^0tavasot ^2" .. GetPlayerName(source) .. " ^0kick shod dalil ^3" .. message)

					else
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online nist!")
					end

				else

					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")

				end


			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Syntax vared shode eshtebah ast!")

		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
	end

end)

RegisterCommand('mute', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level > 1 then

				if xPlayer.get('aduty') then

					if args[1] then
							local target = tonumber(args[1])
						if args[2] then
							local reason = table.concat(args, " ", 2)

								if target then

									if GetPlayerName(target) then

										if GetPlayerName(source) ~= GetPlayerName(target) then

											TriggerClientEvent('chat:setMuteStatus', target, true)
											TriggerClientEvent('aduty:setMuteStatus', target, true)
											TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^2" .. GetPlayerName(target) .. "^0 ra ^1mute ^0kardid!")
											TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, "^1" ..  GetPlayerName(target) .. " ^0tavasot ^2" .. GetPlayerName(source) .. "^0 mute shod be dalil: ^3" .. reason)

										else

											TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid khodetan ra mute konid!")

										end

									else

										TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online nist!")

									end

								else

									TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")

								end

							else
								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat Dalil chizi vared nakardid!")
							end


					else

						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID chizi vared nakardid!")

					end

				else

					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

				end

	else

		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")

	end

end)

RegisterCommand('unmute', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level > 1 then

				if xPlayer.get('aduty') then

					if args[1] then
						local target = tonumber(args[1])

							if target then

								if GetPlayerName(target) then


										TriggerClientEvent('chat:setMuteStatus', target, false)
										TriggerClientEvent('aduty:setMuteStatus', target, false)
										TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^3" .. GetPlayerName(target) .. "^0 ra ^2unmute ^0kardid!")
										TriggerClientEvent('chatMessage', target, "[SYSTEM]", {255, 0, 0}, " ^0Shoma tavasot ^2" .. GetPlayerName(source) .. "^0 ^3unmute ^0shodid!")

								else

									TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online nist!")

								end

							else

								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")

							end

					else

						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID chizi vared nakardid!")

					end

				else

					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

				end

	else

		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")

	end

end)

RegisterCommand("toggleid", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level > 1 then

				if xPlayer.get('aduty') then

					TriggerClientEvent('aduty:changeShowStatus', source)

				else

					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

				end

	else

		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")

	end

end)

RegisterCommand("resetaccount", function(source, args)

		if isAllowedToReset(source) then

			if args[1] then
				if args[2] then
					local name = args[1]
					local reason = table.concat(args, " ", 2)

					MySQL.Async.fetchAll('SELECT * FROM users WHERE playerName = @playername',
					{
						['@playername'] = name

					}, function(data)
						if data[1] then

							CK({identifier = data[1].identifier, name = name}, source, reason)

						else
							TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar vojoud nadarad!")
						end
				end)

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat dalil chizi vared nakardid!")
			end

			else

				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat esm chizi vared nakardid!")

			end


		else

			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye esfade az in dastor ra nadarid!")

		end

end, false)

RegisterCommand("removeweapon", function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 10 then
		if not args[1] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat esm gun chizi vared nakardid!")
			return
		end

		local weapon = string.upper(args[1])
		local gangs, properties, totalusers, totalvehicles, desiredWeapon = 0, 0, 0, 0, 0
		local gangsd, propertiesd, totalusersd, totalvehiclesd = 0, 0, 0, 0

		MySQL.Async.fetchAll('SELECT * FROM datastore_data', {}, function(data)

			for i=1, #data do
				if data[i].name == "property" then

						local weaponData = json.decode(data[i].data)
						if weaponData.weapons then
							local found = false

							for j,v in ipairs(weaponData.weapons) do
								if v.name == weapon then
									found = true
									-- print("found weapon on property: " .. data[i].owner .. " at index: " .. tostring(j))
									table.remove(weaponData.weapons, j)
									desiredWeapon = desiredWeapon + 1
									propertiesd = propertiesd + 1
								end
							end

							if found then
								MySQL.Async.execute('UPDATE datastore_data SET `data` = @data WHERE `owner` = @identifier', { ['@identifier'] = data[i].owner, ['@data'] = json.encode(weaponData) })
							end
							
						end
						
					properties = properties + 1
				elseif string.match(data[i].name, "gang") then
					local weaponData = json.decode(data[i].data)
					if weaponData.weapons then
						local found = false

						for j,v in ipairs(weaponData.weapons) do
							if v.name == weapon then
								found = true
								-- print("found weapon on gang: " .. data[i].name .. " at index: " .. tostring(j))
								table.remove(weaponData.weapons, j)
								desiredWeapon = desiredWeapon + 1
								gangsd = gangsd + 1
							end
						end

						if found then
							MySQL.Async.execute('UPDATE datastore_data SET `data` = @data WHERE `name` = @name', { ['@identifier'] = data[i].name, ['@data'] = json.encode(weaponData) })
						end
					end
					
					gangs = gangs + 1
				end
			end

			MySQL.Async.fetchAll('SELECT * FROM users', {}, function(users)
				for i=1, #users do
					if users[i].loadout then
						local loadout = json.decode(users[i].loadout)
						if loadout then
							local found = false

							for j,v in ipairs(loadout) do
								if v.name == weapon then
									found = true
									-- print("found weapon on player: " .. users[i].playerName .. " at index: " .. tostring(j))
									table.remove(loadout, j)
									desiredWeapon = desiredWeapon + 1
									totalusersd = totalusersd + 1
								end
							end

							if found then
								MySQL.Async.execute('UPDATE users SET `loadout` = @data WHERE `identifier` = @identifier', { ['@identifier'] = users[i].identifier, ['@data'] = json.encode(loadout) })
							end
						end
					end

					totalusers = totalusers + 1
				end

				MySQL.Async.fetchAll('SELECT * FROM trunk_inventory', {}, function(vehicles)
					for i=1, #vehicles do
						if vehicles[i].data then
							local loadout = json.decode(vehicles[i].data)
							if loadout.weapons then
								local found = false

								for j,v in ipairs(loadout.weapons) do
									if v.name == weapon then
										found = true
										-- print("found weapon on player: " .. users[i].playerName .. " at index: " .. tostring(j))
										table.remove(loadout.weapons, j)
										desiredWeapon = desiredWeapon + 1
										totalvehiclesd = totalvehiclesd + 1
									end
								end

								if found then
									MySQL.Async.execute('UPDATE trunk_inventory SET `data` = @data WHERE `id` = @id', { ['@id'] = vehicles[i].id, ['@data'] = json.encode(loadout) })
								end

							end
						end

						totalvehicles = totalvehicles + 1
					end

					local info = {
						iniator = "Purge wave",
						weapon = weapon,
						utotal = totalusers,
						udtotal = totalusersd,
						ptotal = properties,
						pdtotal = propertiesd,
						gtotal = gangs,
						gdtotal = gangsd,
						vtotal = totalvehicles,
						vdtotal = totalvehiclesd,
						dtotal = desiredWeapon
					}
					TriggerEvent('esx_logger:log2', source, info)
				end)


			end)
			
		end)

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye esfade az in dastor ra nadarid!")
	end
	
end, false)

RegisterCommand("countweapon", function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 10 then
		if not args[1] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat esm gun chizi vared nakardid!")
			return
		end

		local weapon = string.upper(args[1])
		local gangs, properties, totalusers, totalvehicles, desiredWeapon = 0, 0, 0, 0, 0
		local gangsd, propertiesd, totalusersd, totalvehiclesd = 0, 0, 0, 0

		MySQL.Async.fetchAll('SELECT * FROM datastore_data', {}, function(data)

			for i=1, #data do
				if data[i].name == "property" then

						local weaponData = json.decode(data[i].data)
						if weaponData.weapons then

							for j,v in ipairs(weaponData.weapons) do
								if v.name == weapon then
									-- TriggerEvent('esx_logger:log3', source, {type = "Property", owner = data[i].owner})
									MySQL.Async.fetchAll('SELECT playerName, job FROM users WHERE identifier = @identifier', {['@identifier'] = data[i].owner}, function(info)
										MySQL.Async.execute('INSERT INTO counter VALUES(@owner, @type, @job)', { ['@owner'] = info[1].playerName, ['@type'] = "Property Inventory", ['@job'] = info[1].job })
									end)
									-- print("found weapon on property: " .. data[i].owner .. " at index: " .. tostring(j))
									desiredWeapon = desiredWeapon + 1
									propertiesd = propertiesd + 1
								end
							end
							
						end
						
					properties = properties + 1
				elseif string.match(data[i].name, "gang") then
					local weaponData = json.decode(data[i].data)
					if weaponData.weapons then

						for j,v in ipairs(weaponData.weapons) do
							if v.name == weapon then
								-- print("found weapon on gang: " .. data[i].name .. " at index: " .. tostring(j))
								-- TriggerEvent('esx_logger:log3', source, {type = "Gang Inventory", owner = data[i].name})
								MySQL.Async.execute('INSERT INTO counter VALUES(@owner, @type, @job)', { ['@owner'] = data[i].name, ['@type'] = "Gang Inventory", ['@job'] = 'N/A' })
								desiredWeapon = desiredWeapon + 1
								gangsd = gangsd + 1
							end
						end

					end
					
					gangs = gangs + 1
				end
			end

			MySQL.Async.fetchAll('SELECT * FROM users', {}, function(users)
				for i=1, #users do
					if users[i].loadout then
						local loadout = json.decode(users[i].loadout)
						if loadout then

							for j,v in ipairs(loadout) do
								if v.name == weapon then
									-- print("found weapon on player: " .. users[i].playerName .. " at index: " .. tostring(j))
									-- TriggerEvent('esx_logger:log3', source, {type = "User Inventory", owner = users[i].playerName})
									MySQL.Async.execute('INSERT INTO counter VALUES(@owner, @type, @job)', { ['@owner'] = users[i].playerName, ['@type'] = "User Inventory", ['@job'] = users[i].job })
									desiredWeapon = desiredWeapon + 1
									totalusersd = totalusersd + 1
								end
							end

						end
					end

					totalusers = totalusers + 1
				end

				MySQL.Async.fetchAll('SELECT * FROM trunk_inventory', {}, function(vehicles)
					for i=1, #vehicles do
						if vehicles[i].data then
							local loadout = json.decode(vehicles[i].data)
							if loadout.weapons then

								for j,v in ipairs(loadout.weapons) do
									if v.name == weapon then
										-- print("found weapon on player: " .. users[i].playerName .. " at index: " .. tostring(j))
										-- TriggerEvent('esx_logger:log3', source, {type = "Trunk Inventory", owner = users[i].playerName})
										MySQL.Async.execute('INSERT INTO counter VALUES(@owner, @type, @job)', { ['@owner'] = users[i].playerName, ['@type'] = "Trunk Inventory", ['@job'] = users[i].job })
										desiredWeapon = desiredWeapon + 1
										totalvehiclesd = totalvehiclesd + 1
									end
								end

							end
						end

						totalvehicles = totalvehicles + 1
					end

					local info = {
						iniator = "Count wave",
						weapon = weapon,
						utotal = totalusers,
						udtotal = totalusersd,
						ptotal = properties,
						pdtotal = propertiesd,
						gtotal = gangs,
						gdtotal = gangsd,
						vtotal = totalvehicles,
						vdtotal = totalvehiclesd,
						dtotal = desiredWeapon
					}
					TriggerEvent('esx_logger:log2', source, info)
				end)


			end)
			
		end)

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye esfade az in dastor ra nadarid!")
	end
	
end, false)

RegisterCommand("disband", function(source, args)

	if isAllowedToDisband(source) then

		if args[1] then
			if args[2] then

				local gang = args[1]
				local reason = table.concat(args, " ", 2)

				MySQL.Async.fetchAll('SELECT gang_name FROM gangs_data WHERE gang_name = @gang',
				{
					['@gang'] = gang

				}, function(data)
					if data[1] then

						MySQL.Async.execute('DELETE FROM gangs WHERE name = @gang', { ['@gang'] = gang })
						MySQL.Async.execute('DELETE FROM gang_grades WHERE gang_name = @gang', { ['@gang'] = gang })
						MySQL.Async.execute('DELETE FROM gang_account WHERE name = @gang', { ['@gang'] = "gang_" .. string.lower(gang) })
						MySQL.Async.execute('DELETE FROM addon_inventory_items WHERE inventory_name = @gang', { ['@gang'] = "gang_" .. string.lower(gang) })
						MySQL.Async.execute('DELETE FROM gang_account_data WHERE gang_name = @gang', { ['@gang'] = "gang_" .. string.lower(gang) })
						MySQL.Async.execute('DELETE FROM datastore_data WHERE name = @gang', { ['@gang'] = "gang_" .. string.lower(gang) })
						MySQL.Async.execute('DELETE FROM datastore WHERE name = @gang', { ['@gang'] = "gang_" .. string.lower(gang) })
						MySQL.Async.execute('DELETE FROM addon_inventory WHERE name = @gang', { ['@gang'] = "gang_" .. string.lower(gang) })
						MySQL.Async.execute('DELETE FROM gangs_data WHERE gang_name = @gang', { ['@gang'] = gang })
						MySQL.Async.execute('DELETE FROM owned_vehicles WHERE owner = @gang', { ['@gang'] = gang })
						MySQL.Async.execute('UPDATE users SET gang = "nogang" WHERE gang = @gang', { ['@gang'] = gang })
						local xPlayers = ESX.GetPlayers()

						for i=1, #xPlayers, 1 do

							local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

							if xPlayer.gang.name == gang then

								xPlayer.setGang("nogang", 0)

							end

						end
					TriggerEvent('DiscordBot:ToDiscord', 'disband', 'Disband Log', GetPlayerName(source) .. " gange " .. gang .. " ra disband kard be dalil: " .. reason,'user', true, source, false)
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0gang ^1" .. gang .. " ^0ba ^2movafaghiat ^0disband shod, dalil: " ..  reason)
						TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^0gang ^2" .. gang .. " ^0be dalil ^1" .. reason .. " ^0disband shod!")


					else
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Family mored nazar vojoud nadarad!")
					end
				end)

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat dalil chizi vared nakardid!")
			end

		else

			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat esm family chizi vared nakardid!")

		end


	else

		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye esfade az in dastor ra nadarid!")

	end

end, false)

RegisterCommand('fuel', function(source, args)

		local xPlayer = ESX.GetPlayerFromId(source)

			if xPlayer.permission_level > 1 then

				if xPlayer.get('aduty') then

					local target

					if not args[1] then
						target = source
					else
						target = tonumber(args[1])
						if target then
							if not GetPlayerName(target) then
								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID vared shode eshtebah ast!")
								return
							end
						else
							TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
							return
						end
					end

					TriggerClientEvent('aduty:refuel', target)

				else

					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

				end

			else

				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")

			end

end, false)

RegisterCommand('vanish', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer.permission_level >= 4 then

			if xPlayer.get('aduty') then

				TriggerClientEvent('aduty:vanish', source)

			else

				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

			end

		else

			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")

		end

end, false)

-- RegisterCommand('forcevisible', function(source, args)

-- 	local xPlayer = ESX.GetPlayerFromId(source)

-- 		if xPlayer.permission_level > 1 then

-- 		if args[1] then

-- 			if args[1] == "true" then
-- 				TriggerClientEvent('aduty:forceStatus', -1, true)
-- 			elseif args[1] == "false" then
-- 				TriggerClientEvent('aduty:forceStatus', -1, false)
-- 			else
-- 				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Dade na malom ast!")
-- 			end

-- 		else
-- 			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Dar ghesmat dade chizi vared nakardid")
-- 		end

-- 		else

-- 			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")

-- 		end

-- end, false)

RegisterCommand('name', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

		if source == 0 or xPlayer.permission_level > 1 then

			if tonumber(args[1]) then

				local target = tonumber(args[1])
					if target then
						local targetPlayer = ESX.GetPlayerFromId(target)

							if targetPlayer then

								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Esm IC player mored nazar ^3" .. string.gsub(targetPlayer.name, "_", " ") .. " ^0ast!")

							else
								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online nist!")
							end

					else
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid.")
					end

			else

				MySQL.Async.fetchAll('SELECT playerName FROM users WHERE lower(`name`) = @name',
				{
					['@name'] = string.lower(args[1])

				}, function(data)
					if data[1] then


						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Esm IC player mored nazar ^3" .. string.gsub(data[1].playerName, "_", " ") .. " ^0ast!")


					else
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar vojoud nadarad!")
					end
				end)

			end

		else

			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")

		end

end, false)

RegisterCommand('kickall', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if source == 0 or xPlayer.permission_level >= 5 then

		KickAll()
		
	else

		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Dastresi ^0kafi baraye estefade az in dastor ra nadarid!")

	end
end, false)

--################# Report System ###################
RegisterCommand('report', function(source, args)
	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat noe report chizi vared nakardid!")
		return
	end

	if not tonumber(args[1]) then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat noe report faghat mitavanid adad vared konid!")
		return
	end

	local type = tonumber(args[1])

	if type ~= 1 and type ~= 0 then TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Noe report vared shode eshtebah ast!") return end

	if not args[2] then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid report khali befrestid!")
		return
	end

	local identifier = GetPlayerIdentifier(source)

	if doesHaveReport(identifier) then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ghablan report ferestade id lotfan shakiba bashid!")
		return
	end

	local message = table.concat(args, " ", 2)
	local name = GetPlayerName(source)
	local id = source
	reports[tostring(rcount)] = {

	owner = {
		identifier = identifier,
		name = name, 
		id = source,
	},

	respond = {
		name = "none",
		identifier = "none"
	},

		message = message,
		type = type,
		status = "open",
		time = os.time()
	}

	for k,v in pairs(exports.esx_scoreboard:GetAdmins()) do
		if type == 0 then
			if v.perm > 0 then
				TriggerClientEvent('chatMessage', v.id, "[SYSTEM]", {255, 0, 0}, " ^0Soal jadid tavasot ^2" .. name .. "^0(^3" .. id .. "^0) (^4/ar " .. rcount .. "^0) jahat javab dadan be soal")
			end
		elseif type == 1 then
			if v.perm > 2 then
				TriggerClientEvent('chatMessage', v.id, "[SYSTEM]", {255, 0, 0}, " ^0Report jadid tavasot ^2" .. name .. "^0(^3" .. id .. "^0) (^4/ar " .. rcount .. "^0) jahat javab dadan be report")
			end
		end
	end
			
	rcount = rcount + 1
	TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Report shoma sabt shod lotfan ta pasokhgoyi staff shakiba bashid!")

end, false)

RegisterCommand('ar', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level > 0 then

		if not args[1] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat ID chizi vared nakardid!")
			return
		end

		if not tonumber(args[1]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat ID faghat adad mitavanid vared konid")
			return
		end

		local identifier = GetPlayerIdentifier(source)

		if not canRespond(identifier) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma nemitavanid be report digari javab dahid aval report ghablie khod ra bebandid")
			return
		end

		if reports[args[1]] then

			if reports[args[1]].type == 1 then
				if xPlayer.permission_level < 3 then
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma nemitavanid be in report javab dahid!")
					return
				end
			end

			if reports[args[1]].status == "open" then

				local report = reports[args[1]] 

				if report.owner.identifier == identifier then
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma nemitavanid be report khod javab dahid")
					return
				end
				
				local ridentifier = report.owner.identifier
				local name = GetPlayerName(source)
				report.status = "pending"
				report.respond.name = name
				report.respond.identifier = identifier
				chats[identifier] = ridentifier
				chats[ridentifier] = identifier
				TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "Shoma report ^2" .. report.owner.name .. "^0 (^3" .. report.owner.id .. "^0) ra ghabol kardid!")
				TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "Matn report: " .. report.message)

				xPlayer = ESX.GetPlayerFromIdentifier(report.owner.identifier)
				if xPlayer then
					TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "Report shoma tavasot ^2" .. name .. "^0 ghabol shod!")
					TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "Jahat chat kardan ba admin marbote az ^3/rd ^0estefade konid!")
				end

				ReportHandler(identifier)


				for k,v in pairs(exports.esx_scoreboard:GetAdmins()) do
					if v.id ~= source then
						TriggerClientEvent('chatMessage', v.id, "[SYSTEM]", {255, 0, 0}, " ^0Report ^3" .. args[1] .. "^0 tavasot ^2" .. name .. "^0 Ghabol shod!")
					end
				end

			else
			  TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "In report ghablan tavasot kasi javab dade shode ast!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Report mored nazar vojod nadarad!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end

end, false)

RegisterCommand('cr', function(source, args)
	
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level > 0 then

		if not args[1] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat ID chizi vared nakardid!")
			return
		end

		if not tonumber(args[1]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat ID faghat adad mitavanid vared konid")
			return
		end

		if reports[args[1]] then

			if reports[args[1]].type == 1 then
				if xPlayer.permission_level < 3 then
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma nemitavanid in report ra bebandid!")
					return
				end
			end

			local report = reports[args[1]] 
			local identifier = GetPlayerIdentifier(source)
			local ridentifier = report.owner.identifier
			chats[identifier] = nil
			chats[ridentifier] = nil
			
			TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "Shoma report ^2" .. report.owner.name .. "^0 (^3" .. report.owner.id .. "^0) ra bastid!")

			xPlayer = ESX.GetPlayerFromIdentifier(report.owner.identifier)
			if xPlayer then
				TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "Report shoma tavasot ^2" .. GetPlayerName(source)  .. "^0 baste shod!")
			end

			reports[args[1]] = nil
			
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Report mored nazar vojod nadarad!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end

end, false)

RegisterCommand('cancelreport', function(source)
	
	local rnumber = getPlayerReport(source)
	if rnumber then
		if reports[rnumber].status == "open" then
			reports[rnumber] = nil
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Report shoma ba movafaghiat baste shod!")
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Report shoma javab dade shode ast nemitavanid bebandid!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma hich reporti nadarid!")
	end

end, false)

RegisterCommand('rd', function(source, args)
	local identifier = GetPlayerIdentifier(source)

	if chats[identifier] then
		if not args[1] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitvanid peygham khali befrestid")
			return
		end
		local message = table.concat(args, " ")
		local name = GetPlayerName(source)

		local xPlayer = ESX.GetPlayerFromIdentifier(chats[identifier])
		if xPlayer then
			TriggerClientEvent('chatMessage', source, "[REPORT]", {255, 0, 0}, "^2" .. name .. ":^0 " .. message)
			TriggerClientEvent('chatMessage', xPlayer.source, "[REPORT]", {255, 0, 0}, "^2" .. name .. ":^0 " .. message)
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online nist")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma hich report activi nadarid!")
	end

end, false)

RegisterCommand('reports', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level > 0 then

		local status

		if TableLength(reports) > 0 then
			for k,v in pairs(reports) do
				if v.status == "open" then status = "^2open" else status = "^8pending" end
				local type
				if v.type == 0 then type = "^4Soal^0" elseif v.type == 1 then type = "^1Report^0" end

				if v.respond.name ~= "none" then
					TriggerClientEvent('chatMessage', source, "ID: ^5" .. k .. "^0 || Owner: " .. v.owner.name .. "(^3" .. v.owner.id .. "^0)" .. "|| Type: " .. type .. " || Status: " .. status .. "^0 (^2" .. v.respond.name .. "^0)")
				else
					TriggerClientEvent('chatMessage', source, "ID: ^5" .. k .. "^0 || Owner: " .. v.owner.name .. "(^3" .. v.owner.id .. "^0)" .. " || Type: " .. type .. " || Status: " .. status)
				end
				
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Reporti jahat namayesh vojod nadarad")
		end			

	else
	 TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end

end, false)

function canRespond(identifier)
	for k,v in pairs(reports) do
		if v.respond.identifier == identifier then
			return false
		end
	end

	return true
end

function doesHaveReport(identifier)
	for k,v in pairs(reports) do
		if v.owner.identifier == identifier then
			return true
		end
	end

	return false
end

function getPlayerReport(source)
	local identifier = GetPlayerIdentifier(source)
	for k,v in pairs(reports) do
		if v.owner.identifier == identifier then
			return k
		end
	end

	return false
end

function isAllowedToReset(player)
	local allowed = false
	for i,id in ipairs(resetaccountAceess) do

		for x,pid in ipairs(GetPlayerIdentifiers(player)) do

				if string.lower(pid) == string.lower(id) then
					allowed = true

				end

			end

		end

	return allowed
end

function isAllowedToDisband(player)
	local allowed = false
	for i,id in ipairs(disbandfamilyAceess) do

		for x,pid in ipairs(GetPlayerIdentifiers(player)) do

				if string.lower(pid) == string.lower(id) then
					allowed = true

				end

			end

		end
			
	return allowed
end

function TableLength(table)

	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count

end

function CheckReports()

		for k,v in pairs(reports) do
			if os.time() - v.time >= 600 and v.respond.name == "none" then
				for i,j in pairs(exports.esx_scoreboard:GetAdmins()) do
					TriggerClientEvent('chatMessage', j.id, "[SYSTEM]", {255, 0, 0}, " ^0Report ^5" .. k .. "^0 be Dalil adam javab dar ^3zaman mogharar^0 baste shod!")
				end
				
				local xPlayer = ESX.GetPlayerFromIdentifier(reports[k].owner.identifier)
				if xPlayer then
					TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Report shoma be elaat ^3adam pasokhgoyi^0 tavasot staff dar zaman mogharar shode ^1baste shod!")
				end
				reports[k] = nil
			end
		end

	SetTimeout(15000, CheckReports)
end
CheckReports()

local lastmessage = 1
local messages = {
	[1] = "Admin OnDuty yek character OOC mahsob mishavad dar sorat moshahede be HICH onvan be sorat IC roye mic ya chat IC ba admin sohbat nakonid!",
	[2] = "ID haye balaye sare player ha code meli nistand va hich gone estefade IC nadarand, dar sorat estefade IC metagaming mashsob mishavad!",
	[3] = "Az kalamati hamchon azole X va gheyre estefade nakonid, az dastor /ooc estefade konid!",
	[4] = "Admin ha shahrdar nistand, va OOC mahsob mishan lotfan be sorat IC admin ha ra shahrdar seda nazanid!",
	[5] = "Mashin ha ra nemitavnid baraye hamle kardan be shakhse digar bishtar az yekbar ba dalil movajah estefade konid hata agar be movafaghiat naresad!"
}

function AutoMessage()

	if messages[lastmessage] then
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0,255,70, 0.5); border-radius: 3px;"><i class="far fa-newspaper"></i> ⚠️ Rahnama ⚠️<br>  {1}</div>',
			args = { "notimportant", messages[lastmessage] }
		})
		lastmessage = lastmessage + 1
	else
		lastmessage = 1
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0,255,70, 0.5); border-radius: 3px;"><i class="far fa-newspaper"></i> ⚠️ Rahnama ⚠️<br>  {1}</div>',
			args = { "notimportant", messages[lastmessage] }
		})
	end
	
	SetTimeout(420000, AutoMessage)
end

AutoMessage()

RegisterCommand('timeplay', function(source)
	MySQL.Async.fetchAll('SELECT timePlay FROM users WHERE identifier = @identifier',
		{
			['@identifier'] = GetPlayerIdentifier(source)

		}, function(result)

			if result[1] then

				
				local timeplay = result[1].timePlay
				timeplay = timeplay / 60
				timeplay = timeplay / 60
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Timeplay shoma: ^3" .. tostring(math.floor(timeplay)) .. "^0 saat ast!")

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Timeplay shoma sabt nashode ast!")
			end

		end)
end, false)


--// Civilian Section
RegisterServerEvent("aduty:sendMessage")
AddEventHandler("aduty:sendMessage", function(target, message)

	TriggerClientEvent('chatMessage', target, "Whisper(" .. source .. ")", {255, 197, 0}, message)

end)

RegisterServerEvent("aduty:showlicense")
AddEventHandler("aduty:showlicense", function(target)

	local _source = source
	local identifier = GetPlayerIdentifier(_source)
	PerformHttpRequest("https://irpixel.ir/ChekLicsence.php?id=" .. identifier, function (errorCode, resultData, resultHeaders)

		if errorCode == 200 then
			if resultData ~= "SIKTIR" then
				local license = json.decode(resultData)
				
				local xPlayer = ESX.GetPlayerFromId(_source)
				TriggerClientEvent('chatMessage', target, "", {255, 0, 0}, "^0^*------ ^3List Madarek ^0------")
				TriggerClientEvent('chatMessage', target, "", {255, 0, 0}, "^4^*Cart Shenasaei:^0 "  .. string.gsub(xPlayer.name, "_", " "))
			
				if license.driving then
					TriggerClientEvent('chatMessage', target, "", {255, 0, 0}, "^4^*Govahiname: ^2Darad")
				else
					TriggerClientEvent('chatMessage', target, "", {255, 0, 0}, "^4^*Govahiname: ^8Nadarad")
				end
			
				if license.weapon then
					TriggerClientEvent('chatMessage', target, "", {255, 0, 0}, "^4^*Mojavez aslahe: ^2Darad")
				else
					TriggerClientEvent('chatMessage', target, "", {255, 0, 0}, "^4^*Mojavez aslahe: ^8Nadarad")
				end

				if license.fly then
					TriggerClientEvent('chatMessage', target, "", {255, 0, 0}, "^4^*Mojavez Parvaz: ^2Darad")
				else
					TriggerClientEvent('chatMessage', target, "", {255, 0, 0}, "^4^*Mojavez Parvaz: ^8Nadarad")
				end
			
				TriggerClientEvent('chatMessage', target, "", {255, 0, 0}, "^0^*------ ^3List Madarek ^0------")

			else
				TriggerClientEvent('chatMessage', _source, "", {255, 0, 0}, "Khatayi dar gereftan license shoma pish amad lotfan be developer etelaa dahid!")
			end
		else
			TriggerClientEvent('chatMessage', _source, "", {255, 0, 0}, "Khatayi dar gereftan license shoma pish amad lotfan be developer etelaa dahid!")
		end

	end, "GET")

end)

local count = 0
function DeleteAccounts()
for i,v in ipairs(deleteUsers) do
	local identifier = v
	MySQL.Async.execute('DELETE FROM addon_account_data WHERE owner = @identifier', { ['@identifier'] = identifier })
	MySQL.Async.execute('DELETE FROM addon_inventory_items WHERE owner = @identifier', { ['@identifier'] = identifier })
	MySQL.Async.execute('DELETE FROM billing WHERE identifier = @identifier', { ['@identifier'] = identifier })
	MySQL.Async.execute('DELETE FROM billing WHERE sender = @identifier', { ['@identifier'] = identifier })
	MySQL.Async.execute('DELETE FROM datastore_data WHERE owner = @identifier', { ['@identifier'] = identifier })
	MySQL.Async.execute('DELETE FROM owned_properties WHERE owner = @identifier', { ['@identifier'] = identifier })
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE owner = @identifier', { ['@identifier'] = identifier })
	MySQL.Async.execute('DELETE FROM user_accounts WHERE identifier = @identifier', { ['@identifier'] = identifier })
	MySQL.Async.execute('DELETE FROM users WHERE identifier = @identifier', { ['@identifier'] = identifier })
	count = count + 1
end

print("Total Deleted users: " .. tostring(count))
end

function CK(target, iniator, reason)
local xPlayer = ESX.GetPlayerFromIdentifier(target.identifier)
if xPlayer then
	DropPlayer(xPlayer.source, "Shoma character kill shodid, lotfan dobare join dahid!")
end

MySQL.Async.execute('DELETE FROM addon_account_data WHERE owner = @identifier', { ['@identifier'] = target.identifier })
MySQL.Async.execute('DELETE FROM addon_inventory_items WHERE owner = @identifier', { ['@identifier'] = target.identifier })
MySQL.Async.execute('DELETE FROM billing WHERE identifier = @identifier', { ['@identifier'] = target.identifier })
MySQL.Async.execute('DELETE FROM billing WHERE sender = @identifier', { ['@identifier'] = target.identifier })
MySQL.Async.execute('DELETE FROM datastore_data WHERE owner = @identifier', { ['@identifier'] = target.identifier })
MySQL.Async.execute('DELETE FROM owned_properties WHERE owner = @identifier', { ['@identifier'] = target.identifier })
MySQL.Async.execute('DELETE FROM owned_vehicles WHERE owner = @identifier', { ['@identifier'] = target.identifier })
MySQL.Async.execute('DELETE FROM user_accounts WHERE identifier = @identifier', { ['@identifier'] = target.identifier })
MySQL.Async.execute('UPDATE users SET bank = 0, money = 0, job = "unemployed", job_grade = 0, inventory = "[]", loadout = "[]", position = NULL, skin = NULL WHERE identifier = @identifier', { ['@identifier'] = target.identifier })

PerformHttpRequest("https://irpixel.ir/crime.php?id=" .. target.identifier .. "&pass=zB3ekDS9KPjVvuXHvGdQJ735Cbfxs54BgVttaacKAmgFsQZxp4cHZQDtRJPT", function (errorCode, resultData, resultHeaders)

	if errorCode == 200 then
		if resultData ~= "OK" then
			if tonumber(iniator) then TriggerClientEvent('chatMessage', iniator, "", {255, 0, 0}, "Identifier shakhs mored nazar baraye pak kardan criminal record ha peyda nashod be developer etelaa dahid!") end
		end
	else
		if tonumber(iniator) then TriggerClientEvent('chatMessage', iniator, "", {255, 0, 0}, "Khatayi dar pak kardan criminal record ha pish amad be developer etelaa dahid!") end
	end

end, "GET")

TriggerEvent('DiscordBot:ToDiscord', 'disband', 'ResetAccount Log', (GetPlayerName(iniator) or iniator) .. " accounte " .. target.name .. " ra reset kard be dalil: " .. reason,'user', true, iniator or 1, false)
if tonumber(iniator) then TriggerClientEvent('chatMessage', iniator, "[SYSTEM]", {255, 0, 0}, " ^0Account ^1" .. target.name .. " ^0ba ^2movafaghiat ^0reset shod, Dalil: " .. reason) end
TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^0Account ^2" .. target.name .. " ^0be dalil ^1" .. reason .. " ^0reset shod!")
end

function ReportHandler(identifier)
exports.ghmattimysql:scalar('SELECT count FROM reports WHERE identifier = @identifier', {
	['@identifier']  = identifier
  }, function(adminExist)
	if adminExist then
		exports.ghmattimysql:execute('UPDATE reports SET count = count + 1 WHERE identifier = @identifier', {
			['@identifier'] = identifier
		})
	else
		exports.ghmattimysql:execute('INSERT INTO reports VALUES(@identifier, 1)', {
			['@identifier'] = identifier
		})
	end
end)
end

function GetSecond()
	local date = os.date('*t')

	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

	return tonumber(date.sec)
end

function KickAll()
	for _, id in ipairs(GetPlayers()) do
		DropPlayer(id, "Server dar hale restart shodan ast lotfan shakiba bashid")
	end
end

function KickAllAuto()
	Citizen.CreateThread(function()
		local second = GetSecond()

		while second < 25 do
			second = GetSecond()
			Citizen.Wait(1000)
		end

		for _, id in ipairs(GetPlayers()) do
			DropPlayer(id, "Server dar hale restart shodan ast lotfan shakiba bashid")
		end

	end)
end


TriggerEvent('cron:runAt', 23, 59, KickAllAuto)
-- TriggerEvent('cron:runAt', 7, 59, KickAllAuto)