local guiEnabled = false
local myIdentity = {}
local needRegister = false
local loaded       = false
ESX                = nil

Citizen.CreateThread(function ()
	EnableGui(false)
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function EnableGui(enable)
    SetNuiFocus(enable, enable)
    guiEnabled = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end

function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE");
    else
        StopAudioScene("MP_LEADERBOARD_SCENE");
    end
end

function showLoadingPromt(label, time)
    Citizen.CreateThread(function()
        BeginTextCommandBusyString(tostring(label))
        EndTextCommandBusyString(3)
        Citizen.Wait(time)
        RemoveLoadingPrompt()
    end)
end

function loadToGround()
	-- TriggerServerEvent('spawn:playerLoaded')
	-- TriggerEvent('spawn:playerLoaded')
	TriggerServerEvent('getSkin')
	SwitchInPlayer(PlayerPedId())
	while GetPlayerSwitchState() ~= 12 do
		Wait(1000)
	end
	TriggerEvent('es_admin:freezePlayer', false)
	TriggerEvent('esx:restoreLoadout')
	TriggerEvent('streetlabel:changeLoadStatus', true)
	TriggerEvent('esx_voice:changeLoadStatus', true)
	TriggerEvent('esx_status:setLastStats')
	TriggerServerEvent('esx_policejob:loadSigns')
	ESX.SetPlayerData('IsLoaded', 1)
	loaded = true
	Wait(500)
	exports.esx_checker:SetVisible(true)
	TriggerEvent('esx_checker:checkVanish')
	TriggerEvent('esx_jail:CheckForJail')
	-- ToggleSound(false)
end

RegisterNetEvent('registerForm')
AddEventHandler('registerForm', function(bool)
needRegister = bool
end)

RegisterNetEvent("showRegisterForm")
AddEventHandler("showRegisterForm", function()
  EnableGui(true)
end)

RegisterNUICallback('register', function(data)
	local player = {}
	player.playerName 	= data.name ..'_'.. data.family
	player.dateofbirth 	= data.dateofbirth
	ESX.TriggerServerCallback('nameAvalibity' , function(avalible)
		if avalible then
			TriggerServerEvent('db:updateUser', player)
			TriggerServerEvent('es:newName', player.playerName)
			EnableGui(false)
			Wait (500)
			loadToGround()
		else
			SendNUIMessage({
				action = 'notification',
				message= 'In moshakhasat qablan sabt shode, lotfan dobare emtehan konid!'
			})
		end
	end ,player.playerName)
end)

Citizen.CreateThread(function()
    -- ToggleSound(true)
	if not IsPlayerSwitchInProgress() then
		exports.esx_checker:SetVisible(false)
		SwitchOutPlayer(PlayerPedId(), 32, 1)	
    end	
    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
    end
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()
	showLoadingPromt("PCARD_JOIN_GAME", 500000)
	while needRegister == nil do
		Wait(5000)
	end

	if needRegister then
		Wait(10000)
		showLoadingPromt("PCARD_JOIN_GAME", 0)
		EnableGui(true)
	else
		Wait(10000)
		showLoadingPromt("PCARD_JOIN_GAME", 0)
		loadToGround()
	end
end)

Citizen.CreateThread(function()
    while true do
        if guiEnabled then
            DisableControlAction(0, 18, guiEnabled) -- Enter
            DisableControlAction(0, 322, guiEnabled) -- ESC
        end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while not loaded do
		Citizen.Wait(250)
		exports.esx_checker:SetVisible(false)
	end
end)