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
local PlayerData = {}
local pointed = nil
local impound = {busy = false, vehicle = 0}
local time = 0
local DesiredVehicle

--  V A R I A B L E S | REGARDING TO ASSETS --
local engineoff = false
local saved = false
-- E N G I N E --
local IsEngineOn = true


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local authorizedVehicles = {
	police = {
		1912215274,
		1264341792,
		-1627000575,
		2046537925,
		-186537451,
		456714581,
		-34623805,
		-2007026063,
		831758577,
		-1973172295,
		949403409,
		-305727417,
		2071877360,
		1624609239,
		1127131465,
		-1647941228,
		-1917086021,
		-188151185,
		-1693015116,
		-982610657,
		-1083357304,
		-1205689942,
		2100335611,
		353883353,
		-834607087,
		-1661555510,
		-1683328900,
		1922257928,
		1747439474,
		2099668667
	},

	ambulance = {
		-574837267,
		-1860923259,
		-1800062819,
		-963528616,
		353883353,
		-1661555510,
		281000465,
		-2111081553,
		-1647941228
	},

	mecano = {
		1353720154,
		-1323100960,
		-442313018,
		1119641113
	},

	taxi = {
		-956048545,
		-2030171296,
		-1008861746,
		-511601230,
		1123216662,
		736902334
	},

	government = {
		-532475078,
		104532066,
		1922255844,
	},

	doc = {
		1682114128,
		456714581,
		-1205689942,
		1922257928,
		-1683328900
	},

	weazel = {
		1162065741,
		744705981
	}
}

RegisterNetEvent("esx_vehiclecontol:trigger")
AddEventHandler("esx_vehiclecontol:trigger",function()
		if PlayerData.job.name == "police" or PlayerData.job.name  == "mecano" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "taxi" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" or PlayerData.job.name == "weazel" then
						
			local ped = GetPlayerPed(-1)
			local job = PlayerData.job.name

			if IsPedSittingInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				local model = GetEntityModel(vehicle)
				if DoesHaveAccess(model, authorizedVehicles[job]) then
					TriggerEvent("esx_vehiclecontol:toggleLock", vehicle)
				else
					ESX.ShowNotification("~h~Shoma dastresi be switch in mashin ra nadarid")
				end
			else
			
				local vehicle = ESX.Game.GetVehicleInDirection(4)
				if vehicle ~= 0 then

					local model = GetEntityModel(vehicle)

					if DoesHaveAccess(model, authorizedVehicles[job]) then
						TriggerEvent("esx_vehiclecontol:toggleLock", vehicle)
					else
						ESX.ShowNotification("~h~Shoma dastresi be switch in mashin ra nadarid")
					end

				else

					if pointed then

						local model = GetEntityModel(pointed)
						if DoesHaveAccess(model, authorizedVehicles[job]) then
	
							local coords = GetEntityCoords(GetPlayerPed(-1))
							local vcoords = GetEntityCoords(pointed)
							if GetDistanceBetweenCoords(coords, vcoords, false) < 20 then
								TriggerEvent("esx_vehiclecontol:toggleLock", pointed)
							else
								ESX.ShowNotification("~h~Shoma az vasile naghlie khili fasele darid")
							end
	
						else
							ESX.ShowNotification("~h~Shoma dastresi be switch in mashin ra nadarid")
						end
					end

				end
				

			end

		else
		ESX.ShowNotification("~r~Shoma ozv hich organ dolati nistid")
		end
end)

RegisterCommand("gethash", function(source)
	ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
			local ped = GetPlayerPed(-1)
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				local model = GetEntityModel(vehicle)
				print("This is model: " .. tostring(model))
			end
        end
    end)
end, false)

RegisterCommand("getmodel", function(source)
	ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
			local ped = GetPlayerPed(-1)
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				local model = GetEntityModel(vehicle)
				print("This is spawn name: " .. tostring(GetDisplayNameFromVehicleModel(model)))
			end
        end
    end)
end, false)

RegisterNetEvent("esx_vehiclecontol:changePointed")
AddEventHandler("esx_vehiclecontol:changePointed",function(veh)
	if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" or PlayerData.job.name  == "mecano" or PlayerData.job.name == "taxi" or PlayerData.job.name == "government" or PlayerData.job.name == "weazel" then
		
		local vehicle = NetworkGetEntityFromNetworkId(veh)
		pointed = vehicle

	end
end)

RegisterNetEvent("esx_vehiclecontol:toggleLock")
AddEventHandler("esx_vehiclecontol:toggleLock",function(vehicle)
	if PlayerData.job.name == "police" or PlayerData.job.name  == "mecano" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "taxi" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" or PlayerData.job.name == "weazel" then
		local vehicle = vehicle
		local islocked = GetVehicleDoorLockStatus(vehicle)

		if (islocked == 1 or islocked == 0) then
			SetVehicleDoorsLocked(vehicle, 2)
			local NetId = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
			TriggerServerEvent("esx_vehiclecontrol:lights", NetId)
			ESX.ShowNotification("Shoma ~y~" .. GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) .. "~w~ ra ~r~ghofl ~w~kardid.")
			local dict = "anim@mp_player_intmenu@key_fob@"
			RequestAnimDict(dict)
			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(0)
			end
			if not IsPedInAnyVehicle(PlayerPedId(), true) then
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
			end
			SetVehicleDoorShut(vehicle, 0, false)
			SetVehicleDoorShut(vehicle, 1, false)
			SetVehicleDoorShut(vehicle, 2, false)
			SetVehicleDoorShut(vehicle, 3, false)
			SetVehicleDoorShut(vehicle, 4, false)
			SetVehicleDoorShut(vehicle, 5, false)
			PlayVehicleDoorCloseSound(vehicle, 1)
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "lock", 0.5)

		elseif islocked == 2 then
			SetVehicleDoorsLocked(vehicle, 1)
			local NetId = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
			TriggerServerEvent("esx_vehiclecontrol:lights", NetId)
			ESX.ShowNotification("Shoma ~y~" .. GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) .. "~w~ ra ~g~baaz ~w~kardid.")
			local dict = "anim@mp_player_intmenu@key_fob@"
			RequestAnimDict(dict)
			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(0)
			end
			if not IsPedInAnyVehicle(PlayerPedId(), true) then
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
			end
			PlayVehicleDoorCloseSound(vehicle, 1)
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 0.5)
		end

	end
end)

-- Server side sync
RegisterNetEvent("esx_vehiclecontol:ClientSync")
AddEventHandler("esx_vehiclecontol:ClientSync", function(NetId, state)
	local vehicle = NetworkGetEntityFromNetworkId(NetId)
	if DoesEntityExist(vehicle) then
		if state then
			SetVehicleDoorsLocked(vehicle, 2) -- lock the door 
		else
			SetVehicleDoorsLocked(vehicle, 1) -- unlcok the door
		end
	end
end)


RegisterNetEvent("esx_vehiclecontol:lockLights")
AddEventHandler("esx_vehiclecontol:lockLights", function(veh)
	local vehicle = NetworkGetEntityFromNetworkId(veh)
	if DoesEntityExist(vehicle) then
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
	end
	
end)

--####################### VEHICLE ASSETS Commands #############################
RegisterCommand('engine', function(source)
	EngineHandler(false)
end, false)

RegisterCommand('trunk', function(source)
	TriggerEvent('trunk')
end, false)

RegisterCommand('hood', function(source)
	TriggerEvent('hood')
end, false)

RegisterCommand('lfdoor', function(source)
	TriggerEvent('lfdoor')
end, false)

RegisterCommand('rfdoor', function(source)
	TriggerEvent('rfdoor')
end, false)

RegisterCommand('lrdoor', function(source)
	TriggerEvent('lrdoor')
end, false)

RegisterCommand('rrdoor', function(source)
	TriggerEvent('rrdoor')
end, false)

RegisterCommand('alldoors', function(source)
	TriggerEvent('alldoors')
end, false)

RegisterCommand('allwindowsdown', function(source)
	TriggerEvent('allwindowsdown')
end, false)

RegisterCommand('allwindowsup', function(source)
	TriggerEvent('allwindowsup')
end, false)
--####################### ENd OF VEHICLE ASSETS COMMANDS #############################

--####################### VEHICLE ASSETS HANDLER #############################
function EngineHandler(force)
	local player = GetPlayerPed(-1)

	if (IsPedSittingInAnyVehicle(player)) then

		DesiredVehicle = GetVehiclePedIsIn(player, false)

		if not force then

		    if GetPedInVehicleSeat(DesiredVehicle, -1) == player then
		    	if IsEngineOn == true then
		    		IsEngineOn = false
					SetVehicleEngineOn(DesiredVehicle, false, false, false)
		    	else
		    		IsEngineOn = true
		    		SetVehicleUndriveable(DesiredVehicle, false)
		    		SetVehicleEngineOn(DesiredVehicle, true, false, false)
		    	end
		    end

		else
			IsEngineOn = false
			SetVehicleEngineOn(DesiredVehicle, false, false, false)
		end
		
	end

end

Citizen.CreateThread(function()
	while true do
		if not IsEngineOn then
			SetVehicleEngineOn(DesiredVehicle, (not GetIsVehicleEngineRunning(DesiredVehicle)), false, true)
			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end
	end
end)
	
RegisterNetEvent("engineoff")
AddEventHandler("engineoff", function()
	local player = GetPlayerPed(-1)

	if (IsPedSittingInAnyVehicle(player)) then
		local vehicle = GetVehiclePedIsIn(player, false)
		engineoff = true
		ESX.ShowNotification("Engine ~r~off~s~.")
		while (engineoff) do
			SetVehicleEngineOn(vehicle, false, false, false)
			SetVehicleUndriveable(vehicle, true)
			Citizen.Wait(0)
		end
	end
end)

RegisterNetEvent("engineon")
AddEventHandler("engineon", function()
	local player = GetPlayerPed(-1)

	if (IsPedSittingInAnyVehicle(player)) then
		local vehicle = GetVehiclePedIsIn(player, false)
		engineoff = false
		SetVehicleUndriveable(vehicle, false)
		SetVehicleEngineOn(vehicle, true, false, false)
		ESX.ShowNotification("Engine ~g~on~s~.")
	end
end)

-- T R U N K --
RegisterNetEvent("trunk")
AddEventHandler("trunk", function()
	local player = GetPlayerPed(-1)
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(player, true)
	end
	
	local isopen = GetVehicleDoorAngleRatio(vehicle, 5)

	if (isopen == 0) then
		SetVehicleDoorOpen(vehicle, 5, 0, 0)
	else
		SetVehicleDoorShut(vehicle, 5, 0)
	end
end)
-- Left Front Door --
RegisterNetEvent("lfdoor")
AddEventHandler("lfdoor",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local frontLeftDoor = GetEntityBoneIndexByName(vehicle, "door_dside_f")
		if frontLeftDoor ~= -1 then
			if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 then
				SetVehicleDoorShut(vehicle, 0, false)
			else
				SetVehicleDoorOpen(vehicle, 0, false)
			end
		else
			ESX.ShowNotification("This vehicle does not have a front driver-side door.")
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- Right Front Door --
RegisterNetEvent("rfdoor")
AddEventHandler("rfdoor",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local frontRightDoor = GetEntityBoneIndexByName(vehicle, "door_pside_f")
		if frontRightDoor ~= -1 then
			if GetVehicleDoorAngleRatio(vehicle, 1) > 0.0 then
				SetVehicleDoorShut(vehicle, 1, false)
			else
				SetVehicleDoorOpen(vehicle, 1, false)
			end
		else
			ESX.ShowNotification("This vehicle does not have a front passenger-side door.")
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- Left Rear Door --
RegisterNetEvent("lrdoor")
AddEventHandler("lrdoor",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local rearLeftDoor = GetEntityBoneIndexByName(vehicle, "door_dside_r")
		if rearLeftDoor ~= -1 then
			if GetVehicleDoorAngleRatio(vehicle, 2) > 0.0 then
				SetVehicleDoorShut(vehicle, 2, false)
			else
				SetVehicleDoorOpen(vehicle, 2, false)
			end
		else
			ESX.ShowNotification("This vehicle does not have a rear driver-side door.")
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- Left Rear Door --
RegisterNetEvent("rrdoor")
AddEventHandler("rrdoor",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local rearRightDoor = GetEntityBoneIndexByName(vehicle, "door_pside_r")
		if rearRightDoor ~= -1 then
			if GetVehicleDoorAngleRatio(vehicle, 3) > 0.0 then
				SetVehicleDoorShut(vehicle, 3, false)
			else
				SetVehicleDoorOpen(vehicle, 3, false)
			end
		else
			ESX.ShowNotification("This vehicle does not have a rear passenger-side door.")
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- All Doors --
RegisterNetEvent("alldoors")
AddEventHandler("alldoors",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 then
			SetVehicleDoorShut(vehicle, 0, false)
			SetVehicleDoorShut(vehicle, 1, false)
			SetVehicleDoorShut(vehicle, 2, false)
			SetVehicleDoorShut(vehicle, 3, false)
			SetVehicleDoorShut(vehicle, 4, false)
			SetVehicleDoorShut(vehicle, 5, false)
		else
			SetVehicleDoorOpen(vehicle, 0, false)
			SetVehicleDoorOpen(vehicle, 1, false)
			SetVehicleDoorOpen(vehicle, 2, false)
			SetVehicleDoorOpen(vehicle, 3, false)
			SetVehicleDoorOpen(vehicle, 4, false)
			SetVehicleDoorOpen(vehicle, 5, false)
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- all windows down --
RegisterNetEvent("allwindowsdown")
AddEventHandler("allwindowsdown", function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local frontLeftWindow = GetEntityBoneIndexByName(vehicle, "window_lf")
		local frontRightWindow = GetEntityBoneIndexByName(vehicle, "window_rf")
		local rearLeftWindow = GetEntityBoneIndexByName(vehicle, "window_lr")
		local rearRightWindow = GetEntityBoneIndexByName(vehicle, "window_rr")
		local frontMiddleWindow = GetEntityBoneIndexByName(vehicle, "window_lm")
		local rearMiddleWindow = GetEntityBoneIndexByName(vehicle, "window_rm")
		if
			frontLeftWindow ~= -1 or frontRightWindow ~= -1 or rearLeftWindow ~= -1 or rearRightWindow ~= -1 or
				frontMiddleWindow ~= -1 or
				rearMiddleWindow ~= -1
			then
			RollDownWindow(vehicle, 0)
			RollDownWindow(vehicle, 1)
			RollDownWindow(vehicle, 2)
			RollDownWindow(vehicle, 3)
			RollDownWindow(vehicle, 4)
			RollDownWindow(vehicle, 5)
		else
			ESX.ShowNotification("This vehicle has no windows.")
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- all windows up --
RegisterNetEvent("allwindowsup")
AddEventHandler("allwindowsup", function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local frontLeftWindow = GetEntityBoneIndexByName(vehicle, "window_lf")
		local frontRightWindow = GetEntityBoneIndexByName(vehicle, "window_rf")
		local rearLeftWindow = GetEntityBoneIndexByName(vehicle, "window_lr")
		local rearRightWindow = GetEntityBoneIndexByName(vehicle, "window_rr")
		local frontMiddleWindow = GetEntityBoneIndexByName(vehicle, "window_lm")
		local rearMiddleWindow = GetEntityBoneIndexByName(vehicle, "window_rm")
		if
			frontLeftWindow ~= -1 or frontRightWindow ~= -1 or rearLeftWindow ~= -1 or rearRightWindow ~= -1 or
				frontMiddleWindow ~= -1 or
				rearMiddleWindow ~= -1
			then
			RollUpWindow(vehicle, 0)
			RollUpWindow(vehicle, 1)
			RollUpWindow(vehicle, 2)
			RollUpWindow(vehicle, 3)
			RollUpWindow(vehicle, 4)
			RollUpWindow(vehicle, 5)
		else
			ESX.ShowNotification("This vehicle has no windows.")
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- H O O D --
RegisterNetEvent("hood")
AddEventHandler("hood", function()
	local player = GetPlayerPed(-1)
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	local isopen = GetVehicleDoorAngleRatio(vehicle, 4)

		if (isopen == 0) then
			SetVehicleDoorOpen(vehicle, 4, 0, 0)
		else
			SetVehicleDoorShut(vehicle, 4, 0)
		end
end)

RegisterNetEvent("esx_vehiclecontrol:AlarmStete")
AddEventHandler("esx_vehiclecontrol:AlarmStete", function(NetId, state)
	local vehicle = NetworkGetEntityFromNetworkId(NetId)
	if DoesEntityExist(vehicle) then
		if state then
			SetVehicleAlarm(vehicle, true)
			SetVehicleAlarmTimeLeft(vehicle, 30000)
		else
			SetVehicleAlarm(vehicle, false)
			SetVehicleAlarmTimeLeft(vehicle, 0)
		end
	end
end)

RegisterNetEvent("esx_vehiclecontrol:HiJack")
AddEventHandler("esx_vehiclecontrol:HiJack", function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
      if vehicle == 0 then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
        return
	  end
	  
	HiJackVehicle(vehicle)
end)

--############# END OF VEHICLE ASSETS #################

function DoesHaveAccess(model, table)
	for k,v in pairs(table) do
		if v == model then
			return true
		end
	end

	return false
end

function GetVehicles(department)
	return authorizedVehicles[department]
end

function IsAnyPedInVehicle(veh)
	return (GetVehicleNumberOfPassengers(veh)+(IsVehicleSeatFree(veh,-1) and 0 or 1))>0
end

function Repair(vehicle)
	NetworkRequestControlOfEntity(vehicle)

	local timeout = 2000
	while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do
		Wait(100)
		timeout = timeout - 100
	end
	
	SetVehicleFixed(vehicle)
end

function Clean(vehicle)
	NetworkRequestControlOfEntity(vehicle)

	local timeout = 2000
	while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do
		Wait(100)
		timeout = timeout - 100
	end

	SetVehicleDirtLevel(vehicle, 0)
end

function HiJack(vehicle)
	SetVehicleDoorsLocked(vehicle, 1)
	local NetId = NetworkGetNetworkIdFromEntity(vehicle)
	TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
end

function ImpoundPolice(vehicle)
	if not impound.busy then
		
		local plate = GetVehicleNumberPlateText(vehicle)
		impound.busy = true
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "police_impound",
			duration = 15000,
			label = "Dar hale impound kardan mashin",
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
				TriggerServerEvent('esx_advancedgarage:policeImpound', plate)
				ESX.Game.DeleteVehicle(vehicle) 

				impound.busy = false
				impound.vehicle = 0
				
			elseif status then
				ClearPedTasksImmediately(GetPlayerPed(-1))
				impound.busy = false
				impound.vehicle = 0
			end
			
		end)

	end
end


function DeleteVehicle(vehicle)
	if not impound.busy then

		impound.busy = true
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "mechanic_impound",
			duration = 15000,
			label = "Dar hale impound kardan mashin",
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
				ESX.Game.DeleteVehicle(vehicle) 

				impound.busy = false
				impound.vehicle = 0
				
			elseif status then
				ClearPedTasksImmediately(GetPlayerPed(-1))
				impound.busy = false
				impound.vehicle = 0
			end
			
		end)

	end
end

function RepairVehicle(vehicle)
	if not impound.busy then

		impound.busy = true
		impound.vehicle = vehicle
		exports.dpemotes:PlayEmote("mechanic")
		TriggerEvent("mythic_progbar:client:progress", {
			name = "mechanic_repair",
			duration = 10000,
			label = "Dar hale tamir kardan mashin",
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
				Repair(vehicle)

				impound.busy = false
				impound.vehicle = 0
				
			elseif status then
				ClearPedTasksImmediately(GetPlayerPed(-1))
				impound.busy = false
				impound.vehicle = 0
			end
			
		end)

	end
end

function CleanVehicle(vehicle)
	if not impound.busy then

		impound.busy = true
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_MAID_CLEAN", 0, true)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "mechanic_clean",
			duration = 5000,
			label = "Dar hale tamiz kardan mashin",
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
				Clean(vehicle)

				impound.busy = false
				impound.vehicle = 0
				
			elseif status then
				ClearPedTasksImmediately(GetPlayerPed(-1))
				impound.busy = false
				impound.vehicle = 0
			end
			
		end)

	end
end

function HiJackVehicle(vehicle)
	if not impound.busy then

		if GetVehicleDoorLockStatus(vehicle) == 2 then

			TriggerServerEvent('esx_customItems:remove', 'picklock')
			impound.busy = true
			impound.vehicle = vehicle
			local plate = GetVehicleNumberPlateText(vehicle)
			local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
			local NetId = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, true)
			TriggerEvent("mythic_progbar:client:progress", {
				name = "vehicle_hijack",
				duration = 30000,
				label = "Dar hale lockpick kardan mashin",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "missheistdockssetup1clipboard@idle_a",
					anim = "idle_a",
				},
			}, function(status)
				
				if not status then

					impound.busy = false
					impound.vehicle = 0

					local number = math.random(1, 3)

					if number % 2 == 0 then
						HiJack(vehicle)
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Mashin ba movafaghiat ^1picklock ^0shod!")
						TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, false)
					else
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0PickLock shoma ^1shekast!")
						TriggerServerEvent('esx_vehiclecontrol:NotifyOwner', plate, model)
						Citizen.CreateThread(function()
							Citizen.Wait(5000)
							TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, false)
						end)
					end
					
				elseif status then
					impound.busy = false
					impound.vehicle = 0
					TriggerServerEvent('esx_vehiclecontrol:NotifyOwner', plate, model)
					Citizen.CreateThread(function()
						Citizen.Wait(5000)
						TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, false)
					end)
				end
				
			end)

		else
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Dare mashin mored nazar ghofl nist!")
		end
		
	end
end

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
	
	  if impound.busy and impound.vehicle ~= 0 then
		 
		local coords = GetEntityCoords(GetPlayerPed(-1))

		if not DoesEntityExist(impound.vehicle) then
			TriggerEvent("mythic_progbar:client:cancel")
			impound.busy = false
			impound.vehicle = 0
		end

		local vcoords = GetEntityCoords(impound.vehicle)
		local distance = GetDistanceBetweenCoords(coords, vcoords, false)

		if IsAnyPedInVehicle(impound.vehicle) then
			ESX.ShowNotification("~h~Shakhsi vared mashin shod!")
			TriggerEvent("mythic_progbar:client:cancel")
			impound.busy = false
			impound.vehicle = 0
		end

		if distance > 4 then
			ESX.ShowNotification("Mashin mored nazar az shoma ~r~door ~s~shod!")
			TriggerEvent("mythic_progbar:client:cancel")
			impound.busy = false
			impound.vehicle = 0
		end	  

	  end

	end
end)

exports("GetVehicles", GetVehicles)
exports("EngineHandler", EngineHandler)
exports("ImpoundPolice", ImpoundPolice)
exports("DeleteVehicle", DeleteVehicle)
exports("RepairVehicle", RepairVehicle)
exports("CleanVehicle", CleanVehicle)