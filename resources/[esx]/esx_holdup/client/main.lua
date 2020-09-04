local holdingup = false
local store = ""
local blipRobbery = {}
ESX = nil

local Keys = {
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

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_holdup:currentlyrobbing')
AddEventHandler('esx_holdup:currentlyrobbing', function(robb)
	holdingup = true
	store = robb
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if job ~= "police" then
		removeAllBlips()
	end
end)

RegisterNetEvent('esx_holdup:killblip')
AddEventHandler('esx_holdup:killblip', function(storeName)
	if blipRobbery[storeName] then
		RemoveBlip(blipRobbery[storeName])
		blipRobbery[storeName] = nil
	else
		print("Bug happened")
	end
end)

RegisterNetEvent('esx_holdup:setblip')
AddEventHandler('esx_holdup:setblip', function(storeName, position)
	blipRobbery[storeName] = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(blipRobbery[storeName] , 161)
	SetBlipScale(blipRobbery[storeName] , 2.0)
	SetBlipColour(blipRobbery[storeName], 3)
	PulseBlip(blipRobbery[storeName])
end)

RegisterNetEvent('esx_holdup:toofarlocal')
AddEventHandler('esx_holdup:toofarlocal', function()
	holdingup = false
	ESX.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	incircle = false
end)


RegisterNetEvent('esx_holdup:dotherobbery')
AddEventHandler('esx_holdup:dotherobbery', function(robb)

	ESX.SetPlayerData('robbing', 1)
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "process_robbery",
		duration = 240000,
		label = "Dar hale baz kardan gavsandogh",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)
		if not status then

			ClearPedTasksImmediately(GetPlayerPed(-1))
			TriggerServerEvent('esx_holdup:robcomplete', robb)
			ESX.SetPlayerData('robbing', 0)

		elseif status then

			ClearPedTasksImmediately(GetPlayerPed(-1))
			TriggerServerEvent('esx_holdup:robcancel', robb)
			ESX.ShowNotification("Shoma robbery ra ~r~cancel ~w~kardid!")
			ESX.SetPlayerData('robbing', 0)
			incircle = false
			holdingup = false

		end
	end)

end)

RegisterNetEvent('esx_holdup:robberycomplete')
AddEventHandler('esx_holdup:robberycomplete', function(award)
	holdingup = false
	ESX.ShowNotification(_U('robbery_complete', award))
	store = ""
	incircle = false
end)


incircle = false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(PlayerPedId(), true)

		for k,v in pairs(Stores)do
			local pos2 = v.position

			if Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0 then
				if not holdingup then
					DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0 then
						if not incirle then
							ESX.ShowHelpNotification(_U('press_to_rob', v.nameofstore))
						end

						incircle = true
						if IsControlJustReleased(0, Keys['E']) then
							if IsPedArmed(PlayerPedId(), 6) then
								SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
								TriggerServerEvent('esx_holdup:rob', k)
							else
								ESX.ShowNotification("Maghaze dar az shoma nemitarsad, aslahe khod ra be dast begirid!")
							end
						end

					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end
				end
			end
		end
	end
end)


function removeAllBlips()
	for k,v in pairs(blipRobbery) do
		RemoveBlip(v)
	end
end