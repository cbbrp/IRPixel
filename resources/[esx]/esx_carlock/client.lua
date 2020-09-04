ESX                           = nil
local workVehicle = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

RegisterNetEvent('esx_carlock:workVehicle')
AddEventHandler('esx_carlock:workVehicle', function(netID)

	if netID ~= nil then

		local vehicle = NetworkGetEntityFromNetworkId(netID)
		local model = GetEntityModel(vehicle)

		if model == GetHashKey("benson") then
			workVehicle = netID
		end

	else
		workVehicle = 0 
	end	

end)

time = 0
Citizen.CreateThread(function()
  local dict = "anim@mp_player_intmenu@key_fob@"
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
      Citizen.Wait(0)
  end
  while true do
    Citizen.Wait(0)
	if (IsControlJustPressed(1, 303)) then
		if GetGameTimer() - time > 3000 then
			time = GetGameTimer()
			if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
				local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
	
				local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
				local hasAlreadyLocked = false
					ESX.TriggerServerCallback('carlock:isVehicleOwner', function(owner)
						if owner and hasAlreadyLocked ~= true then
							local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
							vehicleLabel = GetLabelText(vehicleLabel)
							local lock = GetVehicleDoorLockStatus(vehicle)
							if lock == 1 or lock == 0 then
								SetVehicleDoorShut(vehicle, 0, false)
								SetVehicleDoorShut(vehicle, 1, false)
								SetVehicleDoorShut(vehicle, 2, false)
								SetVehicleDoorShut(vehicle, 3, false)
								SetVehicleDoorsLocked(vehicle, 2)
								local NetId = NetworkGetNetworkIdFromEntity(vehicle)
								TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
								PlayVehicleDoorCloseSound(vehicle, 1)
								ESX.ShowNotification('You have ~r~locked~s~ your ~y~'..vehicleLabel..'~s~.')
								if not IsPedInAnyVehicle(PlayerPedId(), true) then
									TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
								end
								TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "lock", 0.5)
								hasAlreadyLocked = true
							elseif lock == 2 then
								SetVehicleDoorsLocked(vehicle, 1)
								local NetId = NetworkGetNetworkIdFromEntity(vehicle)
								TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
								PlayVehicleDoorOpenSound(vehicle, 0)
								ESX.ShowNotification('You have ~g~unlocked~s~ your ~y~'..vehicleLabel..'~s~.')
								if not IsPedInAnyVehicle(PlayerPedId(), true) then
									TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
								end
								TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 0.5)
								hasAlreadyLocked = true
							end
						else
							
							--// WORK VEHICLE SHIT THINGS
							if workVehicle ~= 0 and NetworkGetNetworkIdFromEntity(vehicle) == workVehicle then
								local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
								vehicleLabel = GetLabelText(vehicleLabel)
								local lock = GetVehicleDoorLockStatus(vehicle)
								if lock == 1 or lock == 0 then
									SetVehicleDoorShut(vehicle, 0, false)
									SetVehicleDoorShut(vehicle, 1, false)
									SetVehicleDoorShut(vehicle, 2, false)
									SetVehicleDoorShut(vehicle, 3, false)
									SetVehicleDoorsLocked(vehicle, 2)
									local NetId = NetworkGetNetworkIdFromEntity(vehicle)
									TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
									PlayVehicleDoorCloseSound(vehicle, 1)
									ESX.ShowNotification('You have ~r~locked~s~ your ~y~'..vehicleLabel..'~s~.')
									if not IsPedInAnyVehicle(PlayerPedId(), true) then
										TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
									end
									TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "lock", 0.5)
								elseif lock == 2 then
									SetVehicleDoorsLocked(vehicle, 1)
									local NetId = NetworkGetNetworkIdFromEntity(vehicle)
									TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
									PlayVehicleDoorOpenSound(vehicle, 0)
									ESX.ShowNotification('You have ~g~unlocked~s~ your ~y~'..vehicleLabel..'~s~.')
									if not IsPedInAnyVehicle(PlayerPedId(), true) then
										TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
									end
									TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 0.5)
								end
							else
								ESX.ShowNotification("~r~Shoma kilid in mashin ra nadarid")
							end
							--// END of work vehicle shit
	
						end
					end, plate)
	
			else
	
				local coords = GetEntityCoords(GetPlayerPed(-1))
				local hasAlreadyLocked = false
				cars = ESX.Game.GetVehiclesInArea(coords, 30)
				local carstrie = {}
				local cars_dist = {}		
				notowned = 0
				if #cars == 0 then
					ESX.ShowNotification("No vehicles to lock nearby.")
				else
					for j=1, #cars, 1 do
						local coordscar = GetEntityCoords(cars[j])
						local distance = Vdist(coordscar.x, coordscar.y, coordscar.z, coords.x, coords.y, coords.z)
						table.insert(cars_dist, {cars[j], distance})
					end
					for k=1, #cars_dist, 1 do
						local z = -1
						local distance, car = 999
						for l=1, #cars_dist, 1 do
							if cars_dist[l][2] < distance then
								distance = cars_dist[l][2]
								car = cars_dist[l][1]
								z = l
							end
						end
						if z ~= -1 then
							table.remove(cars_dist, z)
							table.insert(carstrie, car)
						end
					end
					for i=1, #carstrie, 1 do
	
						local plate = ESX.Math.Trim(GetVehicleNumberPlateText(carstrie[i]))
						ESX.TriggerServerCallback('carlock:isVehicleOwner', function(owner)
							if owner and hasAlreadyLocked ~= true then
								local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(carstrie[i]))
								vehicleLabel = GetLabelText(vehicleLabel)
								local lock = GetVehicleDoorLockStatus(carstrie[i])
								if lock == 1 or lock == 0 then
									SetVehicleDoorShut(carstrie[i], 0, false)
									SetVehicleDoorShut(carstrie[i], 1, false)
									SetVehicleDoorShut(carstrie[i], 2, false)
									SetVehicleDoorShut(carstrie[i], 3, false)
									SetVehicleDoorsLocked(carstrie[i], 2)
									local NetId = NetworkGetNetworkIdFromEntity(carstrie[i])
									TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
									PlayVehicleDoorCloseSound(carstrie[i], 1)
									ESX.ShowNotification('You have ~r~locked~s~ your ~y~'..vehicleLabel..'~s~.')
									if not IsPedInAnyVehicle(PlayerPedId(), true) then
										TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
									end
									TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "lock", 0.5)
									hasAlreadyLocked = true
								elseif lock == 2 then
									SetVehicleDoorsLocked(carstrie[i], 1)
									local NetId = NetworkGetNetworkIdFromEntity(carstrie[i])
									TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
									PlayVehicleDoorOpenSound(carstrie[i], 0)
									ESX.ShowNotification('You have ~g~unlocked~s~ your ~y~'..vehicleLabel..'~s~.')
									if not IsPedInAnyVehicle(PlayerPedId(), true) then
										TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
									end
									TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 0.5)
									hasAlreadyLocked = true
								end
							else
								--// WORK VEHICLE SHIT THINGS
							if workVehicle ~= 0 and NetworkGetNetworkIdFromEntity(carstrie[i]) == workVehicle then
								local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(carstrie[i]))
								vehicleLabel = GetLabelText(vehicleLabel)
								local lock = GetVehicleDoorLockStatus(carstrie[i])
								if lock == 1 or lock == 0 then
									SetVehicleDoorShut(carstrie[i], 0, false)
									SetVehicleDoorShut(carstrie[i], 1, false)
									SetVehicleDoorShut(carstrie[i], 2, false)
									SetVehicleDoorShut(carstrie[i], 3, false)
									SetVehicleDoorsLocked(carstrie[i], 2)
									local NetId = NetworkGetNetworkIdFromEntity(carstrie[i])
									TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
									PlayVehicleDoorCloseSound(carstrie[i], 1)
									ESX.ShowNotification('You have ~r~locked~s~ your ~y~'..vehicleLabel..'~s~.')
									if not IsPedInAnyVehicle(PlayerPedId(), true) then
										TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
									end
									TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "lock", 0.5)
								elseif lock == 2 then
									SetVehicleDoorsLocked(carstrie[i], 1)
									local NetId = NetworkGetNetworkIdFromEntity(carstrie[i])
									TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
									PlayVehicleDoorOpenSound(carstrie[i], 0)
									ESX.ShowNotification('You have ~g~unlocked~s~ your ~y~'..vehicleLabel..'~s~.')
									if not IsPedInAnyVehicle(PlayerPedId(), true) then
										TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
									end
									TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 0.5)
								end
							else
								notowned = notowned + 1
							end
							--// END of work vehicle shit
	
							end
							if notowned == #carstrie then
								ESX.ShowNotification("No vehicles to lock nearby.")
							end	
						end, plate)
					end			
				end
			end
			
		else
			ESX.ShowNotification("~r~Lotfan spam nakonid")
		end
		
		
	end
  end
end)

RegisterCommand('netid', function(source)
	ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))

			if vehicle then
				local netID = NetworkGetNetworkIdFromEntity(vehicle)
				TriggerEvent("chatMessage", "[DevTools]", {255, 0, 0}, "^0This is vehicle network ID: " .. tostring(netID))
			else
				TriggerEvent("chatMessage", "[DevTools]", {255, 0, 0}, "^0Shoma dakhel hich mashini nistid!")
			end

        end

    end)
end, false)