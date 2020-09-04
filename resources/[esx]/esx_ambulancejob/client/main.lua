Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local FirstSpawn, PlayerLoaded = true, false

IsDead = false
injured = false
ESX = nil
local busy = false
local PedIsBeingCarried = nil
local isDragging = false
local stabilize = false
local hasAlreadyJoined = false
InVehicle = false
local blipsmedic = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	-- Citizen.Wait(5000)
	-- TriggerServerEvent('esx_ambulancejob:forceBlip')
end)

-- RegisterNetEvent('esx_ambulancejob:ReviveIfDead')
-- AddEventHandler('esx_ambulancejob:ReviveIfDead', function()
-- 	if ESX.GetPlayerData().IsDead then
-- 		local playerPed = PlayerPedId()
-- 		local coords = GetEntityCoords(playerPed)
	
-- 		TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	
-- 		Citizen.CreateThread(function()
-- 			DoScreenFadeOut(800)
	
-- 			while not IsScreenFadedOut() do
-- 				Citizen.Wait(50)
-- 			end
	
-- 			local formattedCoords = {
-- 				x = ESX.Math.Round(coords.x, 1),
-- 				y = ESX.Math.Round(coords.y, 1),
-- 				z = ESX.Math.Round(coords.z, 1)
-- 			}
	
-- 			ESX.SetPlayerData('lastPosition', formattedCoords)
	
-- 			TriggerServerEvent('esx:updateLastPosition', formattedCoords)
	
-- 			RespawnPed(playerPed, formattedCoords, 0.0)
	
-- 			StopScreenEffect('DeathFailOut')
-- 			DoScreenFadeIn(800)
-- 		end)
-- 	end
-- end)

--------------------------------------------------------------------
------------------------ Medic Commands ----------------------------
--------------------------------------------------------------------
RegisterCommand('cpr', function(source, args)
	if ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "ambulance" then

		if not args[1] then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID chizi vared nakardid!")
			return
		end
		
		if not tonumber(args[1]) then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID faghat mojaz be vared kardan adad hastid!")
			return
		end

		local target = tonumber(args[1])

		if GetPlayerName(PlayerId()) == GetPlayerName(GetPlayerFromServerId(target)) then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid khodetan ra cpr konid!")
			return
		end

		if GetPlayerName(GetPlayerFromServerId(target)) == "**Invalid**" then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0ID vared shode eshtebah ast")
			return
		end
		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local tcoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))

		if GetDistanceBetweenCoords(coords, tcoords, true) > 2 then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Faselel shoma az player mored nazar ziad ast")
			return
		end
		

		ESX.TriggerServerCallback('ambulance_job:checkdeath', function(IsDead)
			if IsDead then

				ESX.TriggerServerCallback('ambulance_job:getCprStatus', function(IsCpr)
					if not IsCpr then
		
						TriggerServerEvent('esx_ambulancejob:chagneCprStatus', target, true)
						TriggerEvent("mythic_progbar:client:progress", {
							name = "cpr_player",
							duration = 10000,
							label = "Dar hale CPR kardan",
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
							animation = {
								animDict = "mini@cpr@char_a@cpr_str",
								anim = "cpr_pumpchest",
							}
						}, function(status)
							if not status then
					
								TriggerServerEvent('esx_ambulancejob:healplayer', target)
								TriggerServerEvent('esx_ambulancejob:cprmsg', target) 
						
							elseif status then
								TriggerServerEvent('esx_ambulancejob:chagneCprStatus', target, false)
							end
						end)
		
					else
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Player mored nazar ghablan CPR shode ast!")
					end
				end, target)


			else
				TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid player zende ra cpr konid!")
			end
		end, target)	

	else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
	end
end, false)

RegisterCommand('drag', function(source, args)
	local target = tonumber(args[1])

	if ESX.PlayerData.job.name == "ambulance" then

		if busy == true and PedIsBeingCarried ~= nil then

			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma brankard ra vel kardid!")
			busy = false
			PedIsBeingCarried = nil
			isDragging = false
			return

		end

	   if args[1] then

			if target then

				if GetPlayerName(GetPlayerFromServerId(target)) ~= "**Invalid**" then

					if GetPlayerName(PlayerId()) == GetPlayerName(GetPlayerFromServerId(target)) then
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid khodetan ra drag koid!")
						return
					end

					local coords = GetEntityCoords(GetPlayerPed(-1))
					local tcoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))

					if GetDistanceBetweenCoords(coords, tcoords, true) < 2 then


						ESX.TriggerServerCallback('ambulance_job:checkdeath', function(IsDead)
							if IsDead then

								isDragging = true
								PedIsBeingCarried = target
								busy = true
						
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma ba movafaghiat ^1" .. GetPlayerName(GetPlayerFromServerId(target))  .. "^0 ra roye brankard gozashtid")

							else
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid player zende ra roye brankard gharar dahid!")
							end
						end, target)

					else
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma az player mored nazar khili door hastid!")
					end

				else
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Player mored nazar online nist!")
				end

			else
				TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
			end

	   else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID chizi vared nakardid!")
	   end

	else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma medic nistid!")
	end
end, false)

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(2000)

		if isDragging and PedIsBeingCarried then
			coords = GetEntityCoords(GetPlayerPed(-1))
			x, y, z = coords.x, coords.y, coords.z
			local formattedCoords = {
				x = ESX.Math.Round(coords.x, 1),
				y = ESX.Math.Round(coords.y, 1),
				z = ESX.Math.Round(coords.z, 1) - 1
			}
			TriggerServerEvent('esx_ambulancejob:RequestTeleport', PedIsBeingCarried, formattedCoords.x, formattedCoords.y, formattedCoords.z)
		end

	end

end)

RegisterCommand('loadpt', function(source, args)
	if ESX.PlayerData.job.name == "ambulance" then

		if busy == true and PedIsBeingCarried ~= nil or isDragging then

			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitvaniid dar hale hamle brankard bimar ra savar konid!")
			return

		end

	   if args[1] then
			local target = tonumber(args[1])

			if target then

				if GetPlayerName(GetPlayerFromServerId(target)) ~= "**Invalid**" then

					if GetPlayerName(PlayerId()) == GetPlayerName(GetPlayerFromServerId(target)) then
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid khodetan ra vared ambulance konid")
						return
					end

					if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitvanaid hengami ke dakhel mashin hastid az command estefade konid")
						return
					end

					local coords = GetEntityCoords(GetPlayerPed(-1))
					local vehicle = ESX.Game.GetVehicleInDirection(4)
					if vehicle ~= 0 then


						if DoesEntityExist(vehicle) then

							if not contains(exports["esx_vehiclecontrol"]:GetVehicles(ESX.PlayerData.job.name), GetEntityModel(vehicle)) then
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0In vasile ghabeliat haml bimar ra nadarad!")
								return
							end

						else
							return
						end

					else
						return
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
					end

					local tcoords = GetEntityCoords(vehicle)
					local pcoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))

					if GetDistanceBetweenCoords(pcoords, tcoords, true) < 5 then


						ESX.TriggerServerCallback('ambulance_job:checkdeath', function(IsDead)
							if IsDead then

								local NetId = NetworkGetNetworkIdFromEntity(vehicle)
								TriggerServerEvent('esx_ambulancejob:putInVehicle', target, NetId)
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma ba movafaghiat ^1" .. GetPlayerName(GetPlayerFromServerId(target))  .. "^0 ra vared ambulance kardid")

							else
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid player zende ra daron ambulance gharar dahid!")
							end
						end, target)

					else
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Player mored nazar az ambulance khili door ast!")
					end

				else
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Player mored nazar online nist!")
				end

			else
				TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
			end

	   else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID chizi vared nakardid!")
	   end

	else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma medic nistid!")
	end
end, false)

RegisterCommand('stabilize', function(source, args)
	if ESX.PlayerData.job.name == "ambulance" then

		if busy == true and PedIsBeingCarried ~= nil or isDragging then

			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitvaniid dar hale hamle brankard bimar ra stabilize konid!")
			return

		end

	   if args[1] then
			local target = tonumber(args[1])

			if target then

				if GetPlayerName(GetPlayerFromServerId(target)) ~= "**Invalid**" then

					if GetPlayerName(PlayerId()) == GetPlayerName(GetPlayerFromServerId(target)) then
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid khodetan ra stabilize konid")
						return
					end

					if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitvanaid hengami ke dakhel mashin hastid az command estefade konid")
						return
					end

					local coords = GetEntityCoords(GetPlayerPed(-1))
					local pcoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))

					if GetDistanceBetweenCoords(coords, pcoords, true) < 2 then

							ESX.TriggerServerCallback('ambulance_job:checkdeath', function(IsDead)
								if IsDead then

									TriggerEvent("mythic_progbar:client:progress", {
										name = "cpr_player",
										duration = 10000,
										label = "Dar hale Stabilize kardan",
										useWhileDead = false,
										canCancel = true,
										controlDisables = {
											disableMovement = true,
											disableCarMovement = true,
											disableMouse = false,
											disableCombat = true,
										},
										animation = {
											animDict = "mini@cpr@char_a@cpr_str",
											anim = "cpr_pumpchest",
										}
									}, function(status)
										if not status then
								
											TriggerServerEvent('esx_ambulancejob:changeStabilizeStatus', target, true)
											TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma ba movafaghiat ^1" .. GetPlayerName(GetPlayerFromServerId(target))  .. "^0 ra stabilize kardid!")

										end
									end)

								else
									TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid player zende ra stabilize konid!")
								end
							end, target)
							
					else
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Player mored nazar khili door ast!")
					end

				else
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Player mored nazar online nist!")
				end

			else
				TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
			end

	   else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID chizi vared nakardid!")
	   end

	else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma medic nistid!")
	end
end, false)

RegisterCommand('deliverpt', function(source, args)
	if ESX.PlayerData.job.name == "ambulance" then

		if busy == true and PedIsBeingCarried ~= nil or isDragging then

			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitvaniid dar hale hamle brankard bimar ra tahvil dadid!")
			return

		end

	   if args[1] then
			local target = tonumber(args[1])

			if target then

				if GetPlayerName(GetPlayerFromServerId(target)) ~= "**Invalid**" then

					if GetPlayerName(PlayerId()) == GetPlayerName(GetPlayerFromServerId(target)) then
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid khodetan ra darman konid")
						return
					end

					if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma baraye estefade az in command bayad dakhel mashin bashid")
						return
					end

					local pPed = GetPlayerPed(GetPlayerFromServerId(target))

					       local hcoords = {

							   Hospitals ={
									Pos= {
										{x = 290.38, y = -590.5, z = 43.19, spawncoords = {x= 299.87, y= -578.79, z= 43.26}},
										{x = 1826.85, y = 3693.19, z = 34.22, spawncoords = {x= 1839.67, y= 3667.2, z= 32.68}},
										{x = -241.81, y = 6336.11, z = 31.43, spawncoords = {x= -247.3, y= 6330.77, z= 31.43}},
										{x = 351.78, y = -588.14, z = 74.17, spawncoords = {x= 364.52, y= -579.63, z= 27.84}},
										{x = 302.27, y = -1433.16, z = 29.8, spawncoords = {x= 337.93, y= -1402.85, z= 32.51}},
										{x = 299.43, y = -1453.34, z = 46.51, spawncoords = {x= 337.93, y= -1402.85, z= 32.51}},
										{x = 313.37, y = -1465.18, z = 46.51, spawncoords = {x= 337.93, y= -1402.85, z= 32.51}}
									}

								}

							}

							local pcoords = GetEntityCoords(pPed)
							local hospitalpos = {x = nil, y = nil, z = nil}

							function checkDistance()
								for k,v in pairs(hcoords) do
									for i=1, #v.Pos, 1 do
										if GetDistanceBetweenCoords(pcoords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 10 then
											hospitalpos.x = v.Pos[i].spawncoords.x
											hospitalpos.y = v.Pos[i].spawncoords.y
											hospitalpos.z = v.Pos[i].spawncoords.z
											return true
										end
									end
								end
								return false
							end

					if checkDistance() then


						ESX.TriggerServerCallback('ambulance_job:checkdeath', function(IsDead)
							if IsDead then

								TriggerServerEvent('esx_ambulancejob:RequestTeleport', target, hospitalpos.x, hospitalpos.y, hospitalpos.z)
								TriggerServerEvent('esx_ambulancejob:reirpixelvive', target)
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma ba movafaghiat ^1" .. GetPlayerName(GetPlayerFromServerId(target))  .. "^0 ra darman kardid")

							else
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid player zende ra darman konid!")
								return
							end
						end, target)

					else
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Bimar nazdik bimarestan nist!")
					end


				else
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Player mored nazar online nist!")
				end

			else
				TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
			end

	   else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID chizi vared nakardid!")
	   end

	else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma medic nistid!")
	end
end, false)
------------------------------------------------------------------------
---------------------------- End of those shits ------------------------
------------------------------------------------------------------------

AddEventHandler('playerSpawned', function()
		if not hasAlreadyJoined then
			exports.spawnmanager:setAutoSpawn(false) -- disable respawn
			-- TriggerServerEvent('esx_ambulancejob:spawned')
		end
		hasAlreadyJoined = true
end)

AddEventHandler('esx:playerLoaded', function(source)
	if FirstSpawn then
		FirstSpawn = false

		ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
			if isDead and Config.AntiCombatLog then
				while not PlayerLoaded do
					Citizen.Wait(1000)
				end

				ESX.ShowNotification(_U('combatlog_message'))
				RemoveItemsAfterRPDeath()

				local formattedCoords = {
					x = Config.RespawnPoint.coords.x,
					y = Config.RespawnPoint.coords.y,
					z = Config.RespawnPoint.coords.z
				}
				Citizen.Wait(5000)
				SetEntityCoordsNoOffset(GetPlayerPed(-1), formattedCoords.x, formattedCoords.y, formattedCoords.z, false, false, false, true)
				SetEntityHeading(GetPlayerPed(-1), Config.RespawnPoint.heading)
			end
		end)

	end
    
end)

-- Create blips
Citizen.CreateThread(function()
	for i,v in ipairs(Config.Hospitals.CentralLosSantos.Blips) do
		local blip = AddBlipForCoord(v.coords)

		SetBlipSprite(blip, v.sprite)
		SetBlipScale(blip, v.scale)
		SetBlipColour(blip, v.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('hospital'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Disable most inputs when dead
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsDead then
			DisableAllControlActions(0)
			EnableControlAction(0, Keys['G'], true)
			EnableControlAction(0, Keys['T'], true)
			EnableControlAction(0, Keys['N'], true)
		else
			Citizen.Wait(500)
		end
	end
end)

function StartDeathAnim(ped, coords, heading)
	local animDict = 'missfbi5ig_0'
	local animName = 'lyinginpain_loop_steve'
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	SetPlayerHealthRechargeMultiplier(PlayerId(-1), 0.0)
	SetEntityHealth(ped, 150)
	ESX.Streaming.RequestAnimDict(animDict, function()
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 1.0, 0, 0, 0)
	end)
	ESX.UI.Menu.CloseAll()
end

function OnPlayerDeath()
	if injured == false then
		IsDead = true

    	StartScreenEffect('DeathFailOut', 0, false)
    	local ped = PlayerPedId()
    	local coords = GetEntityCoords(ped)
    	Citizen.Wait(2000)

    	-- Player jaii ke morde respawn mishe
    	local formattedCoords = {
    	    x = ESX.Math.Round(coords.x, 1),
    	    y = ESX.Math.Round(coords.y, 1),
    	    z = ESX.Math.Round(coords.z, 1) - 1
    	}
    	ESX.SetPlayerData('lastPosition', formattedCoords)
    	TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(playerPed, formattedCoords, 0.0)
		injured = true
		TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)
		TriggerServerEvent('esx_ambulancejob:chagneCprStatus', GetPlayerServerId(PlayerId()), false)
		ESX.SetPlayerData('IsDead',1)

		SetPlayerHealthRechargeMultiplier(PlayerId(-1), 0.0)
		SetEntityHealth(ped, 150)
    	-- Animation e mordan shoru mishe
    	RequestAnimDict("amb@world_human_bum_slumped@male@laying_on_left_side@base")
    	while not HasAnimDictLoaded("amb@world_human_bum_slumped@male@laying_on_left_side@base") do
    	    Citizen.Wait(250)
    	end
    	TaskPlayAnim(ped, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 0, -1, 1, 1.0, 0, 0, 0)
		StartDistressSignal()
    	Citizen.Wait(100)
		FreezeEntityPosition(ped , true)
		--Agar HP player kamtar az %50 beshe respawn mikone
    	while injured do
    	    local health = GetEntityHealth(ped)
			if health < 100 then
				local thatped = ClonePed(GetPlayerPed(-1), GetEntityHeading(GetPlayerPed(-1)), true, false)
				SetEntityHealth(thatped, 0)
				local netID = NetworkGetNetworkIdFromEntity(thatped)
				TriggerServerEvent('esx_ambulancejob:addDeadBody',netID)

				RemoveItemsAfterRPDeath()
				Citizen.Wait(1000)
				IsDead = false
				injured = false
				stabilize = false
				FreezeEntityPosition(ped , false)

				--AfterDeathWalk()
				--Wait(300000)
				--DeletePed(asd)
			end
			Citizen.Wait(100)
    	end
    end
end

-- Age player halate injure mord respawn mishe az bimarestan
Citizen.CreateThread(function()
	local ped = PlayerPedId()
	while injured do
			local deathinjured = IsPedInjured(ped)
			if deathinjured == 1 then
				--local asd = ClonePed(GetPlayerPed(-1), GetEntityHeading(GetPlayerPed(-1)), true, false)
				RemoveItemsAfterRPDeath()
				Citizen.Wait(1000)
				IsDead = false
				injured = false
				FreezeEntityPosition(ped , false)
				-- Wait(2000)
				--AfterDeathWalk()
				--Wait(300000)
				--DeletePed(asd)
			end
		Citizen.Wait(0)
	end
end)

function AfterDeathWalk()
	local ped = GetPlayerPed(-1)
	RequestAnimSet("move_m@injured")
	SetPedMovementClipset(ped ,"move_m@injured" , 1.0)
end

-- Dokme haye player halate injure gheyre faal mishe va faghat mitune type kone
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsDead then
			DisableAllControlActions(0)
			EnableControlAction(0, Keys['T'], true)
			EnableControlAction(0, Keys['G'], true)
		else
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()

	while true do
		if IsDead == true and injured == true then
			local stopped = IsPedStopped(GetPlayerPed(-1))
			--local anim = IsEntityPlayingAnim(player1, "amb@world_human_bum_slumped@male@laying_on_left_side@base","base", 3)
			if stopped == false then
				RequestAnimDict("amb@world_human_bum_slumped@male@laying_on_left_side@base")
    			while not HasAnimDictLoaded("amb@world_human_bum_slumped@male@laying_on_left_side@base") do
    	    		Citizen.Wait(250)
    			end
				TaskPlayAnim(ped, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 1, -1, 1, 1.0, 0, 0, 0)
			end

			if not IsEntityPlayingAnim(GetPlayerPed(-1), "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 1) and not InVehicle then
				TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 1, -1, 1, 1.0, 0, 0, 0)
			end

		end
		Citizen.Wait(100)
	end
end)

-- Har 10 sanie 1 HP az player tu halate mordan kam mikone
Citizen.CreateThread(function()
	while true do
		if injured == true and IsDead == true and stabilize == false then
			local hp = GetEntityHealth(GetPlayerPed(-1))
			hp = hp - 1
			SetEntityHealth(GetPlayerPed(-1), hp)
			Citizen.Wait(10000)
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'medikit' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end
	
			TriggerEvent('esx_ambulancejob:heal', 'big', true)
			ESX.ShowNotification(_U('used_medikit'))
		end)

	elseif itemName == 'bandage' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_ambulancejob:heal', 'small', true)
			ESX.ShowNotification(_U('used_bandage'))
		end)
	end
end)

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = Config.BleedoutTimer

		while timer > 0 and IsDead do
			Citizen.Wait(2)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.175, 0.805)

			if IsControlPressed(0, Keys['G']) then
				SendDistressSignal()

				Citizen.CreateThread(function()
					Citizen.Wait(1000 * 60 * 5)
					if IsDead then
						StartDistressSignal()
					end
				end)

				break
			end
		end
	end)
end

function SendDistressSignal()
	local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)
	
	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }

	ESX.ShowNotification(_U('distress_sent'))

    TriggerServerEvent('esx_addons_gcphone:startCall', 'ambulance', _U('distress_message'), PlayerCoords, {

		PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
	})
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function StartDeathTimer()
	local canPayFine = false

	if Config.EarlyRespawnFine then
		ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(canPay)
			canPayFine = canPay
		end)
	end

	local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
	local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)

	Citizen.CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and IsDead do
			Citizen.Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and IsDead do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and IsDead do
			Citizen.Wait(0)
			text = _U('respawn_available_in', secondsToClock(earlySpawnTimer))

			DrawGenericTextThisFrame()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		-- bleedout timer
		while bleedoutTimer > 0 and IsDead do
			Citizen.Wait(0)
			text = _U('respawn_bleedout_in', secondsToClock(bleedoutTimer))

			if not Config.EarlyRespawnFine then
				text = text .. _U('respawn_bleedout_prompt')

				if IsControlPressed(0, Keys['E']) and timeHeld > 60 then
					RemoveItemsAfterRPDeath()
					break
				end
			elseif Config.EarlyRespawnFine and canPayFine then
				text = text .. _U('respawn_bleedout_fine', ESX.Math.GroupDigits(Config.EarlyRespawnFineAmount))

				if IsControlPressed(0, Keys['E']) and timeHeld > 60 then
					TriggerServerEvent('esx_ambulancejob:payFine')
					RemoveItemsAfterRPDeath()
					break
				end
			end

			if IsControlPressed(0, Keys['E']) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end
			
		if bleedoutTimer < 1 and IsDead then
			RemoveItemsAfterRPDeath()
		end
	end)
end

function RemoveItemsAfterRPDeath()
	IsDead = false
	ESX.SetPlayerData('IsDead', false)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
			local formattedCoords = {
				x = Config.RespawnPoint.coords.x,
				y = Config.RespawnPoint.coords.y,
				z = Config.RespawnPoint.coords.z
			}

			ESX.SetPlayerData('lastPosition', formattedCoords)
			ESX.SetPlayerData('loadout', {})

			TriggerServerEvent('esx:updateLastPosition', formattedCoords)
			RespawnPed(PlayerPedId(), formattedCoords, Config.RespawnPoint.heading)

			StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(800)
		end)
	end)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)

	ESX.UI.Menu.CloseAll()
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ambulance',
		number     = 'ambulance',
		base64Icon = 'data:image/png;base64,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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	OnPlayerDeath(data.deathCause)
end)

RegisterNetEvent('esx_ambulancejob:reirpixelvive')
AddEventHandler('esx_ambulancejob:reirpixelvive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	IsDead = false
	injured = false
	stabilize = false

	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	TriggerServerEvent('esx_ambulancejob:chagneCprStatus', GetPlayerServerId(PlayerId()), false)
	ESX.SetPlayerData('IsDead',0)


	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed(playerPed, formattedCoords, 0.0)
		local ped = GetPlayerPed(-1)
		local maxhealth = GetEntityMaxHealth(ped)
		SetEntityHealth(ped, maxhealth)
		FreezeEntityPosition(playerPed , false)
		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		
	end)
end)

-- Load unloaded IPLs
if Config.LoadIpl then
	Citizen.CreateThread(function()
		RequestIpl('Coroner_Int_on') -- Morgue
	end)
end

RegisterNetEvent('esx_ambulancejob:changeStabilizeStatus')
AddEventHandler('esx_ambulancejob:changeStabilizeStatus', function(status)
	if type(status) == "boolean" then
		stabilize = status
	else
		print('cant insert none boolean status')
	end
end)

RegisterNetEvent('esx_ambulancejob:teleportPatient')
AddEventHandler('esx_ambulancejob:teleportPatient', function(x, y, z)
	TriggerEvent('seatbelt:changeStatus', false)
	InVehicle = false
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
end)

function contains(table, val)
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end
--[[RegisterCommand("didan", function()
    if not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 3) then
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end
end)
]]

RegisterNetEvent("esx_ambulancejob:healplayer")
AddEventHandler("esx_ambulancejob:healplayer",function()

	local sourcePed = GetPlayerPed(-1)
	local hp = GetEntityHealth(sourcePed)
	hp = hp + 30
	SetEntityHealth(sourcePed, hp)
	ESX.ShowNotification("~g~~h~Shoma CPR shodid!")

end)

RegisterNetEvent("esx_ambulancejob:healr")
AddEventHandler("esx_ambulancejob:healr",function()
	SetEntityHealth(GetPlayerPed(-1), 200)
end)

RegisterNetEvent("esx_ambulancejob:deletePed")
AddEventHandler("esx_ambulancejob:deletePed",function(NetId)

	local ped = NetworkGetEntityFromNetworkId(NetId)
	if DoesEntityExist(ped) then
		ESX.Game.DeleteObject(ped)
		Citizen.Wait(2100)
		if not DoesEntityExist(ped) then 
			TriggerServerEvent('esx_ambulancejob:removeDeadBody', NetId)
		end
	end

end)