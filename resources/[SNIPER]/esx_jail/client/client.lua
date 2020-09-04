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

ESX = nil
PlayerData = {}
local time = 0
local triggerTime = 0
local sentence = {active = false, time = 0, coords = {x = 0, y = 0, z = 0}, distance = 0, type = 0, ajail = false}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData() == nil do
		
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterCommand('ajoin', function(source, args)
	TriggerEvent('esx_jail:CheckForJail')
end, false)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	PlayerData.job = job
end)

RegisterNetEvent("esx_jail:CheckForJail")
AddEventHandler("esx_jail:CheckForJail", function()
	ESX.TriggerServerCallback("esx_jail:retriveJail", function(psentence)
		if psentence.time > 0 then
			Sentence(psentence.type, psentence.time, psentence.part)
		end
	end)
end)

RegisterNetEvent("esx_jail:unJailSelf")
AddEventHandler("esx_jail:unJailSelf", function()
	UnJail()
end)

RegisterNetEvent("esx_jail:SentencePlayer")
AddEventHandler("esx_jail:SentencePlayer", function(type, time, part)
	Sentence(type, time, part)
end)

RegisterNetEvent("esx_jail:notifications")
AddEventHandler("esx_jail:notifications", function(message)
	if PlayerData.job.name == "police" or PlayerData.job.name == "doc" then
		TriggerEvent('chat:addMessage', {color = {0, 95, 254}, multiline = true ,args = {"[DISPATCH]", message}})
	end
end)

Citizen.CreateThread(function()
	
	while true do
		Citizen.Wait(1)

		if sentence.active then
			DrawGenericText("~r~JailTime: ~w~" .. sentence.time)
			DisableControlAction(0, Keys['F3'],true)
			DisableControlAction(0, Keys[','], true)

			if sentence.ajail then
				DisableControlAction(0, Keys['F1'], true)
				DisableControlAction(0, Keys['M'], true)
				DisableControlAction(0, Keys['R'], true)
				DisableControlAction(0, 24, true) -- Attack
				DisableControlAction(0, 257, true) -- Attack 2
				DisableControlAction(0, 25, true) -- Right click
				DisableControlAction(0, 47, true)  -- Disable weapon
				DisableControlAction(0, 264, true) -- Disable melee
				DisableControlAction(0, 257, true) -- Disable melee
				DisableControlAction(0, 140, true) -- Disable melee
				DisableControlAction(0, 141, true) -- Disable melee
				DisableControlAction(0, 142, true) -- Disable melee
				DisableControlAction(0, 143, true) -- Disable melee
				DisableControlAction(0, 263, true) -- Melee Attack 1
				DisableControlAction(0, 27, true) -- Arrow up
			end
			
		else
			Citizen.Wait(1000)
		end
	
	end

end)

Citizen.CreateThread(function()
	
	while true do
		Citizen.Wait(500)

		if sentence.active then

			local ped = GetPlayerPed(-1)
			local coords = GetEntityCoords(ped)
			local distance = GetDistanceBetweenCoords(coords, sentence.coords.x, sentence.coords.y, sentence.coords.y, false)

			if distance > sentence.distance then
				ESX.Game.Teleport(ped, sentence.coords)
				ESX.ShowNotification("~r~~h~Shoma nemitavanid az zendan farar konid!")
			end

		else
			Citizen.Wait(2000)
		end
	
	end

end)

Citizen.CreateThread(function()
	
	while true do
		Citizen.Wait(1000)

		if sentence.active then
			if triggerTime == 0 then
				if GetGameTimer() - time > 60000 then
					time = GetGameTimer()
	
					sentence.time = sentence.time - 1
	
					TriggerServerEvent('esx_jail:UpdateTime')
					if sentence.time == 0 then
						sentence.active = false
					end
	
				end
			end
		end
	
	end

end)

function tTime()
	triggerTime = triggerTime - 1
	if triggerTime > 0 then
		SetTimeout(1000, tTime)
	end
end

function Sentence(type, time, part)
	local ped = GetPlayerPed(-1)
	RemoveWeapons(ped)
	changeClothes()
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "cell", 0.3)
	ESX.SetPlayerData('jailed', 1)

	sentence.time = time
	sentence.type = type
	sentence.ajail = false
	if type == "prison" then
		local place = Config.Prison
		sentence.coords = place.coords
		sentence.distance = place.distance
		ESX.Game.Teleport(ped, place.coords)
		SetEntityHeading(ped, place.heading)
	elseif type == "jail" then
		local place = Config.Jails[part]
		sentence.coords = place.coords
		sentence.distance = place.distance
		ESX.Game.Teleport(ped, place.coords)
		SetEntityHeading(ped, place.heading)
	elseif type == "solitary" then
		local place = Config.Solitaries[part]
		sentence.coords = place.coords
		sentence.distance = place.distance
		ESX.Game.Teleport(ped, place.coords)
		SetEntityHeading(ped, place.heading)
	elseif type == "admin" then
		local place = Config.Admin
		sentence.coords = place.coords
		sentence.distance = place.distance
		sentence.ajail = true
		ESX.Game.Teleport(ped, place.coords)
		SetEntityHeading(ped, place.heading)
	end

	triggerTime = 61
	tTime()

	sentence.active = true

end

function RemoveWeapons(ped)

	SetPedArmour(ped, 0)
	ClearPedBloodDamage(ped)
	ResetPedVisibleDamage(ped)
	ClearPedLastWeaponDamage(ped)
	RemoveAllPedWeapons(ped, true)

end

function UnJail()

	sentence.time = 0
	sentence.coords = {x = 0, y = 0, z = 0}
	sentence.distance = 0
	local place = Config.Unjails[sentence.type]
	ESX.SetPlayerData('jailed', 0)
	sentence.type = 0
	sentence.ajail = false
	sentence.active = false

	local ped = GetPlayerPed(-1)

	ESX.Game.Teleport(ped, place)
	SetEntityHeading(ped, place.heading)

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)

	ESX.ShowNotification("~g~~h~Shoma Azad Shodid!")

end

function changeClothes()
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			local clothesSkin = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['bags_1'] = -1,  ['bags_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['torso_1'] = 5, ['torso_2'] = 0,
			['arms'] = 5,
			['pants_1'] = 9, ['pants_2'] = 4,
			['shoes_1'] = 42, ['shoes_2'] = 2,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		elseif skin.sex == 1 then
			local clothesSkin = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['bags_1'] = -1,  ['bags_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['torso_1'] = 4, ['torso_2'] = 12,
			['arms'] = 4,
			['pants_1'] = 5, ['pants_2'] = 15,
			['shoes_1'] = 81, ['shoes_2'] = 23,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end
	end)
end

function DrawGenericText(text)
	SetTextFont(7)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(5.0, 35, 41, 37, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.40, 0.00)
end