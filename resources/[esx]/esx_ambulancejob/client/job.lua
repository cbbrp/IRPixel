local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}

local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum

local IsBusy, Ended = false, false

local spawnedVehicles, isInShopMenu = {}, false

local callsign = nil

RegisterNetEvent('esx:setcallsign')
AddEventHandler('esx:setcallsign', function(sign)
	if ESX.PlayerData.job.name == "ambulance" then
		callsign = sign
	end
end)

function OpenAmbulanceActionsMenu()

	local elements = {

		{label = _U('cloakroom'), value = 'cloakroom'}

	}



	if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'boss' then

		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})

	end



	ESX.UI.Menu.CloseAll()



	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {

		title    = _U('ambulance'),

		align    = 'top-left',

		elements = elements

	}, function(data, menu)

		if data.current.value == 'cloakroom' then

			OpenCloakroomMenu()

		elseif data.current.value == 'boss_actions' then

			TriggerEvent('esx_society:openBosirpixelsMenu', 'ambulance', function(data, menu)

				menu.close()

			end, {wash = false})

		end

	end, function(data, menu)

		menu.close()

	end)

end

function OpenMobileAmbulanceActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'top-left',
		elements = {
			{label = _U('ems_menu'), value = 'citizen_interaction'}
		}
	}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('ems_menu_title'),
				align    = 'top-left',
				elements = {
					-- {label = _U('ems_menu_revive'), value = 'revive'},
					{label = _U('ems_menu_small'), value = 'small'},
					{label = _U('ems_menu_big'), value = 'big'},
					-- {label = _U('ems_menu_putincar'), value = 'put_in_vehicle'}
				}
			}, function(data, menu)
				if IsBusy then return end

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 1.0 then
					ESX.ShowNotification(_U('no_players'))
				else

					-- if data.current.value == 'revive' then

						-- ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
						-- 	if quantity > 0 then
						-- 		local closestPlayerPed = GetPlayerPed(closestPlayer)

						-- 		ESX.TriggerServerCallback('ambulance_job:checkdeath', function(IsDead)
						-- 			if IsDead then
						-- 				ESX.UI.Menu.CloseAll()
						-- 				local camanimDict = "mini@cpr@char_a@cpr_def"
						-- 				local camanimDict1 = "mini@cpr@char_a@cpr_str"
						-- 				local playerPed = GetPlayerPed(-1)
						-- 				TriggerServerEvent('esx_ambulancejob:syncDeadBody', PedToNet(GetPlayerPed(-1)),GetPlayerServerId(closestPlayer))
						-- 				ESX.ShowNotification(_U('revive_inprogress'))
						-- 				ESX.Streaming.RequestAnimDict(camanimDict1)
						-- 				local canceld = false
				
						-- 				TriggerEvent("mythic_progbar:client:progress", {
						-- 					name = "revive_player",
						-- 					duration = 49900,
						-- 					label = "Revive kardan",
						-- 					useWhileDead = false,
						-- 					canCancel = true,
						-- 					controlDisables = {
						-- 						disableMovement = true,
						-- 						disableCarMovement = true,
						-- 						disableMouse = false,
						-- 						disableCombat = true,
						-- 					}
						-- 				}, function(status)
						-- 					if not status then
							
						-- 						TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
						-- 						TriggerServerEvent('esx_ambulancejob:reirpixelvive', GetPlayerServerId(closestPlayer))
						-- 						-- Show revive award?
						-- 						if Config.ReviveReward > 0 then
						-- 							ESX.ShowNotification(_U('revive_complete_award', GetPlayerName(closestPlayer), Config.ReviveReward))
						-- 						else
						-- 							ESX.ShowNotification(_U('revive_complete', GetPlayerName(closestPlayer)))
						-- 						end
						-- 						IsBusy = false

						-- 					elseif status then
						-- 						IsBusy = false
						-- 						canceld = true
						-- 					end
						-- 				end)

						-- 				ESX.Streaming.RequestAnimDict(camanimDict, function()
						-- 					Citizen.Wait(500)		
						-- 					TaskPlayAnim(playerPed, camanimDict, "cpr_intro", 8.0, 8.0, -1, 0, 0, false, false, false)
						-- 					Citizen.Wait(15800)
						-- 					if not canceld then
						-- 					TaskPlayAnim(playerPed, camanimDict1, "cpr_pumpchest", 8.0, 8.0, -1, 1, 0, false, false, false)
						-- 					Citizen.Wait(5000)
						-- 						if not canceld then
						-- 							TaskPlayAnim(playerPed, camanimDict1, "cpr_success", 8.0, 8.0, -1, 0, 0, false, false, false)
						-- 							Citizen.Wait(28600)
						-- 						end
						-- 					end
						-- 				end)					

						-- 			else
						-- 				ESX.ShowNotification("~r~Player mored nazar zakhmi nist")
						-- 			end
						-- 		end, GetPlayerServerId(closestPlayer))
						-- 	else
						-- 		ESX.ShowNotification(_U('not_enough_medikit'))
						-- 	end

						-- end, 'medikit')

					if data.current.value == 'small' then

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									IsBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_bandage'))
							end
						end, 'bandage')

					elseif data.current.value == 'big' then

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									IsBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_medikit'))
							end
						end, 'medikit')

					elseif data.current.value == 'put_in_vehicle' then
						TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end


-- Draw markers & Marker logic

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)

		local playerCoords = GetEntityCoords(PlayerPedId())

		local letSleep, isInMarker, hasExited = true, false, false

		local currentHospital, currentPart, currentPartNum



		for hospitalNum,hospital in pairs(Config.Hospitals) do



			-- Ambulance Actions

			for k,v in ipairs(hospital.AmbulanceActions) do

				local distance = GetDistanceBetweenCoords(playerCoords, v, true)



				if distance < Config.DrawDistance then

					DrawMarker(22, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, true, true, 2, true, nil, nil, false)

					letSleep = false

				end



				if distance < Config.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceActions', k

				end

			end



			-- Pharmacies

			for k,v in ipairs(hospital.Pharmacies) do

				local distance = GetDistanceBetweenCoords(playerCoords, v, true)



				if distance < Config.DrawDistance then

					DrawMarker(21, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, true, true, 2, true, nil, nil, false)

					letSleep = false

				end



				if distance < Config.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Pharmacy', k

				end

			end



			-- Vehicle Spawners

			for k,v in ipairs(hospital.Vehicles) do

				local distance = GetDistanceBetweenCoords(playerCoords, v.Spawner, true)



				if distance < Config.DrawDistance then

					DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)

					letSleep = false

				end



				if distance < v.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Vehicles', k

				end

			end

			-- Vehicle Spawners

			for k,v in ipairs(hospital.VehiclesDeleter) do

				local distance = GetDistanceBetweenCoords(playerCoords, v.Deleter, true)



				if distance < Config.DrawDistance then

					DrawMarker(v.Marker.type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)

					letSleep = false

				end



				if distance < v.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'VehiclesDeleter', k

				end

			end

			-- Helicopter Spawners

			for k,v in ipairs(hospital.Helicopters) do

				local distance = GetDistanceBetweenCoords(playerCoords, v.Spawner, true)



				if distance < Config.DrawDistance then

					DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)

					letSleep = false

				end



				if distance < v.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Helicopters', k

				end

			end


		end



		-- Logic for exiting & entering markers

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then



			if

				(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and

				(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)

			then

				TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)

				hasExited = true

			end



			HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum



			TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentHospital, currentPart, currentPartNum)



		end



		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

			HasAlreadyEnteredMarker = false

			TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)

		end



		if letSleep then

			Citizen.Wait(500)

		end

	end

end)

RegisterNetEvent('esx_ambulancejob:finishCPR')
AddEventHandler('esx_ambulancejob:finishCPR', function(ped)
	local NersPed 	= NetToPed(ped)
	local PlayerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(PlayerPed)
	local head 		= GetEntityHeading(PlayerPed)
	
	local camanimDict = "mini@cpr@char_b@cpr_def"
	local camanimDict1 = "mini@cpr@char_b@cpr_str"
	local loadedanim = false

	ESX.Streaming.RequestAnimDict(camanimDict1)
	ESX.Streaming.RequestAnimDict(camanimDict, function()
		loadedanim = true
	end)

	while not loadedanim do
		Citizen.Wait(5)
	end

	ClearPedTasksImmediately(PlayerPed)
	AttachEntityToEntity(PlayerPed, NersPed, 28422, -0.1, 1.15, 0.0, 0.0, 0.0, 75.0, false, false, false, true, 2, true)
	
	TaskPlayAnim(PlayerPed, camanimDict, "cpr_intro", 8.0, 8.0, -1, 0, 0, false, false, false)
	Citizen.Wait(800)
	DetachEntity(PlayerPed, true, false)
	Citizen.Wait(15000)
	TaskPlayAnim(PlayerPed, camanimDict1, "cpr_pumpchest", 8.0, 8.0, -1, 1, 0, false, false, false)
	Citizen.Wait(5000)
	TaskPlayAnim(PlayerPed, camanimDict1, "cpr_success", 8.0, 8.0, -1, 0, 0, false, false, false)
	Citizen.Wait(28600)
	ClearPedTasksImmediately(NersPed)
	ClearPedTasksImmediately(PlayerPed)
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

		if part == 'AmbulanceActions' then

			CurrentAction = part

			CurrentActionMsg = _U('actions_prompt')

			CurrentActionData = {}

		elseif part == 'Pharmacy' then

			CurrentAction = part

			CurrentActionMsg = _U('open_pharmacy')

			CurrentActionData = {}

		elseif part == 'Vehicles' then

			CurrentAction = part

			CurrentActionMsg = _U('garage_prompt')

			CurrentActionData = {hospital = hospital, partNum = partNum}

		elseif part == 'VehiclesDeleter' then

			if IsPedInAnyVehicle(GetPlayerPed(-1),  false) then

				local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		  
				if DoesEntityExist(vehicle) then
				  CurrentAction     = 'VehiclesDeleter'
				  CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid ta repair she!'
				  CurrentActionData = {vehicle = vehicle}
				end
		  
			end

		elseif part == 'Helicopters' then

			CurrentAction = part

			CurrentActionMsg = _U('helicopter_prompt')

			CurrentActionData = {hospital = hospital, partNum = partNum}

		end

	end

end)



AddEventHandler('esx_ambulancejob:hasExitedMarker', function(hospital, part, partNum)

	if not isInShopMenu then

		ESX.UI.Menu.CloseAll()

	end



	CurrentAction = nil

end)



-- Key Controls

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)



		if CurrentAction then

			ESX.ShowHelpNotification(CurrentActionMsg)



			if IsControlJustReleased(0, Keys['E']) then



				if CurrentAction == 'AmbulanceActions' then

					OpenAmbulanceActionsMenu()

				elseif CurrentAction == 'Pharmacy' then

					OpenPharmacyMenu()

				elseif CurrentAction == 'Vehicles' then

					if callsign ~= nil then

						ESX.TriggerServerCallback('esx_policejob:checkForVehicle', function(DoesHaveVehicle)
							if not DoesHaveVehicle then
	
								OpenVehicleSpawnerMenu(CurrentActionData.hospital, CurrentActionData.partNum)
								
							else
								ESX.ShowNotification("~h~Vahed shoma dar hale hazer yek mashin darad")
							end
						end, callsign)				
					 
					else
						ESX.ShowNotification("~h~Shoma Callsign nadarid")
					end

				elseif CurrentAction == 'VehiclesDeleter' then
					-- print(CurrentActionData.vehicle)
					-- ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
					local ped = GetPlayerPed(-1)
					local vehicle = GetVehiclePedIsUsing(ped)
					local model = GetEntityModel(vehicle)
				
					if IsAllowedVehicle(exports["esx_vehiclecontrol"]:GetVehicles(ESX.PlayerData.job.name), model) then
						SetVehicleFixed(vehicle)
						SetVehicleDirtLevel(vehicle, 0.0)
					else
						ESX.ShowNotification("~r~Shoma Savar mashin police nistid!")
					end

				elseif CurrentAction == 'Helicopters' then

					if callsign ~= nil then

						ESX.TriggerServerCallback('esx_policejob:checkForVehicle', function(DoesHaveVehicle)
							if not DoesHaveVehicle then
								OpenHelicopterSpawnerMenu(CurrentActionData.hospital, CurrentActionData.partNum)
							else
								ESX.ShowNotification("~h~Vahed shoma dar hale hazer yek vasile naghlie darad")
							end
						end, callsign)

					else
						ESX.ShowNotification("~h~Shoma Callsign nadarid")
					end
					
				end



				CurrentAction = nil



			end



		-- elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' and not IsDead then

		-- 	if IsControlJustReleased(0, Keys['F6']) then

		-- 		OpenMobileAmbulanceActionsMenu()

		-- 	end

		-- else

		-- 	Citizen.Wait(500)

		end

	end

end)



RegisterNetEvent('esx_ambulancejob:putInVehicle')

AddEventHandler('esx_ambulancejob:putInVehicle', function(vehicle)

	local veh = NetworkGetEntityFromNetworkId(vehicle)
	local ped = GetPlayerPed(-1)

	if IsVehicleSeatFree(veh, 1) then

		TaskWarpPedIntoVehicle(ped, veh, 1)

	elseif IsVehicleSeatFree(veh, 2) then

		TaskWarpPedIntoVehicle(ped, veh, 2)

	end
	InVehicle = true
	TriggerEvent('seatbelt:changeStatus', true)
	Citizen.Wait(250)
	ClearPedTasks(GetPlayerPed(-1))

end)



function OpenCloakroomMenu()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {

		title    = _U('cloakroom'),

		align    = 'top-left',

		elements = {

			{label = _U('ems_clothes_civil'), value = 'citizen_wear'},

			{label = _U('ems_clothes_ems'), value = 'ambulance_wear'},

		}

	}, function(data, menu)

		if data.current.value == 'citizen_wear' then

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

				TriggerEvent('skinchanger:loadSkin', skin)

			end)

		elseif data.current.value == 'ambulance_wear' then

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

				if skin.sex == 0 then

					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)

				else

					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)

				end

			end)

		end



		menu.close()

	end, function(data, menu)

		menu.close()

	end)

end



function OpenVehicleSpawnerMenu(hospital, partNum)


			local shopCoords = Config.Hospitals[hospital].Vehicles[partNum].InsideShop

			local elements = {}



			local authorizedVehicles = Config.AuthorizedVehicles[ESX.PlayerData.job.grade_name]

			for i=1, #authorizedVehicles, 1 do

				table.insert(elements, { label = authorizedVehicles[i].label, model = authorizedVehicles[i].model, extras = authorizedVehicles[i].extras })

			end



			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',

			{

				title    = _U('garage_title'),

				align    = 'top-right',

				elements = elements

			}, function(data, menu)

				menu.close()

	

				local model   = data.current.model

				local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(hospital, 'Vehicles', partNum)

	

				if not DoesEntityExist(vehicle) then

	

					local playerPed = PlayerPedId()



						if foundSpawn then

	

							ESX.Game.SpawnVehicle(model, spawnPoint.coords, spawnPoint.heading, function(vehicle)

								TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
								local NetId = NetworkGetNetworkIdFromEntity(vehicle)

								if model == "polchgr" then
									SetVehicleMods(vehicle, false, nil, nil, nil, callsign)
									SetVehicleLivery(vehicle, 0)
								elseif model == "fibc" or model == "fbi2" then
									SetVehicleMods(vehicle, true, 39, 39, 39, callsign)
									SetVehicleLivery(vehicle, 0)
								else
								 	SetVehicleMods(vehicle, false, nil, nil, nil, callsign)
								end

								TriggerServerEvent("esx_policejob:addVehicle", callsign, NetId)
								VehicleHandler(vehicle, data.current.extras)


							end)



						else

							ESX.ShowNotification(_U('garage_notavailable'))

						end



					end

	

			end, function(data, menu)

				menu.close()

	

				CurrentAction     = 'menu_vehicle_spawner'

				CurrentActionMsg  = _U('vehicle_spawner')

				CurrentActionData = {station = station, partNum = partNum}

	

			end)

end



function StoreNearbyVehicle(playerCoords)

	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}



	if #vehicles > 0 then

		for k,v in ipairs(vehicles) do



			-- Make sure the vehicle we're saving is empty, or else it wont be deleted

			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then

				table.insert(vehiclePlates, {

					vehicle = v,

					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))

				})

			end

		end

	else

		ESX.ShowNotification(_U('garage_store_nearby'))

		return

	end



	ESX.TriggerServerCallback('esx_ambulancejob:storeNearbyVehicle', function(storeSuccess, foundNum)

		if storeSuccess then

			local vehicleId = vehiclePlates[foundNum]

			local attempts = 0

			ESX.Game.DeleteVehicle(vehicleId.vehicle)

			IsBusy = true



			Citizen.CreateThread(function()

				while IsBusy do

					Citizen.Wait(0)

					drawLoadingText(_U('garage_storing'), 255, 255, 255, 255)

				end

			end)



			-- Workaround for vehicle not deleting when other players are near it.

			while DoesEntityExist(vehicleId.vehicle) do

				Citizen.Wait(500)

				attempts = attempts + 1



				-- Give up

				if attempts > 30 then

					break

				end



				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)

				if #vehicles > 0 then

					for k,v in ipairs(vehicles) do

						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then

							ESX.Game.DeleteVehicle(v)

							break

						end

					end

				end

			end



			IsBusy = false

			ESX.ShowNotification(_U('garage_has_stored'))

		else

			ESX.ShowNotification(_U('garage_has_notstored'))

		end

	end, vehiclePlates)

end



function GetAvailableVehicleSpawnPoint(hospital, part, partNum)

	local spawnPoints = Config.Hospitals[hospital][part][partNum].SpawnPoints

	local found, foundSpawnPoint = false, nil



	for i=1, #spawnPoints, 1 do

		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then

			found, foundSpawnPoint = true, spawnPoints[i]

			break

		end

	end



	if found then

		return true, foundSpawnPoint

	else

		ESX.ShowNotification(_U('garage_blocked'))

		return false

	end

end



function OpenHelicopterSpawnerMenu(hospital, partNum)


	if not Config.AuthorizedHelicopters[ESX.PlayerData.job.grade_name] then ESX.ShowNotification("~h~Shoma dastresi be helicopter nadarid!") return end

	local shopCoords = Config.Hospitals[hospital].Vehicles[partNum].InsideShop

			local elements = {}



			local authorizedHelicopters = Config.AuthorizedHelicopters[ESX.PlayerData.job.grade_name]

				if #authorizedHelicopters > 0 then

		

				else

					ESX.ShowNotification(_U('helicopter_notauthorized'))

					return

				end

			for i=1, #authorizedHelicopters, 1 do

				table.insert(elements, { label = authorizedHelicopters[i].label, model = authorizedHelicopters[i].model})

			end



			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',

			{

				title    = _U('garage_title'),

				align    = 'top-right',

				elements = elements

			}, function(data, menu)

				menu.close()

	

				local model   = data.current.model

				local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(hospital, 'Helicopters', partNum)

	

				if not DoesEntityExist(vehicle) then

	

					local playerPed = PlayerPedId()



						if foundSpawn then

	

							ESX.Game.SpawnVehicle(model, spawnPoint.coords, spawnPoint.heading, function(vehicle)

								TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

								 SetVehicleModKit(vehicle, 1)

		 						 SetVehicleLivery(vehicle, 1)

								 SetVehicleMods(vehicle, true, 27, 27, 27)

								 local NetId = NetworkGetNetworkIdFromEntity(vehicle)
								 TriggerServerEvent("esx_policejob:addVehicle", callsign, NetId)

								 Citizen.CreateThread(function()
								 	 Citizen.Wait(2000)
									 SetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1)), 100.0)
								 end)

							end)





						else

							ESX.ShowNotification(_U('garage_notavailable'))

						end



					end

	

			end, function(data, menu)

				menu.close()

	

				CurrentAction     = 'menu_vehicle_spawner'

				CurrentActionMsg  = _U('vehicle_spawner')

				CurrentActionData = {station = station, partNum = partNum}

	

			end)



	--[[local playerCoords = GetEntityCoords(PlayerPedId())

	ESX.PlayerData = ESX.GetPlayerData()

	local elements = {

		{label = _U('helicopter_garage'), action = 'garage'},

		{label = _U('helicopter_store'), action = 'store_garage'},

		{label = _U('helicopter_buy'), action = 'buy_helicopter'}

	}



	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'helicopter_spawner', {

		title    = _U('helicopter_title'),

		align    = 'top-left',

		elements = elements

	}, function(data, menu)



		if data.current.action == 'buy_helicopter' then

			local shopCoords = Config.Hospitals[hospital].Helicopters[partNum].InsideShop

			local shopElements = {}



			local authorizedHelicopters = Config.AuthorizedHelicopters[ESX.PlayerData.job.grade_name]



			if #authorizedHelicopters > 0 then

				for k,helicopter in ipairs(authorizedHelicopters) do

					table.insert(shopElements, {

						label = ('%s - <span style="color:green;">%s</span>'):format(helicopter.label, _U('shop_item', ESX.Math.GroupDigits(helicopter.price))),

						name  = helicopter.label,

						model = helicopter.model,

						price = helicopter.price,

						type  = 'helicopter'

					})

				end

			else

				ESX.ShowNotification(_U('helicopter_notauthorized'))

				return

			end



			OpenShopMenu(shopElements, playerCoords, shopCoords)

		elseif data.current.action == 'garage' then

			local garage = {}



			ESX.TriggerServerCallback('esx_vehicleshop:retrieveJobVehicles', function(jobVehicles)

				if #jobVehicles > 0 then

					for k,v in ipairs(jobVehicles) do

						local props = json.decode(v.vehicle)

						local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))

						local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)



						if v.stored then

							label = label .. ('<span style="color:green;">%s</span>'):format(_U('garage_stored'))

						else

							label = label .. ('<span style="color:darkred;">%s</span>'):format(_U('garage_notstored'))

						end



						table.insert(garage, {

							label = label,

							stored = v.stored,

							model = props.model,

							vehicleProps = props

						})

					end



					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'helicopter_garage', {

						title    = _U('helicopter_garage_title'),

						align    = 'top-left',

						elements = garage

					}, function(data2, menu2)

						if data2.current.stored then

							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(hospital, 'Helicopters', partNum)



							if foundSpawn then

								menu2.close()



								ESX.Game.SpawnVehicle(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)

									ESX.Game.SetVehicleProperties(vehicle, data2.current.vehicleProps)



									TriggerServerEvent('esx_vehicleshop:setJobVehicleState', data2.current.vehicleProps.plate, false)

									ESX.ShowNotification(_U('garage_released'))

								end)

							end

						else

							ESX.ShowNotification(_U('garage_notavailable'))

						end

					end, function(data2, menu2)

						menu2.close()

					end)



				else

					ESX.ShowNotification(_U('garage_empty'))

				end

			end, 'helicopter')



		elseif data.current.action == 'store_garage' then

			StoreNearbyVehicle(playerCoords)

		end



	end, function(data, menu)

		menu.close()

	end)--]]



end



function OpenShopMenu(elements, restoreCoords, shopCoords)

	local playerPed = PlayerPedId()

	isInShopMenu = true



	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {

		title    = _U('vehicleshop_title'),

		align    = 'top-left',

		elements = elements

	}, function(data, menu)



		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {

			title    = _U('vehicleshop_confirm', data.current.name, data.current.price),

			align    = 'top-left',

			elements = {

				{ label = _U('confirm_no'), value = 'no' },

				{ label = _U('confirm_yes'), value = 'yes' }

			}

		}, function(data2, menu2)



			if data2.current.value == 'yes' then

				local newPlate = exports['esx_vehicleshop']:GeneratePlate()

				local vehicle  = GetVehiclePedIsIn(playerPed, false)

				local props    = ESX.Game.GetVehicleProperties(vehicle)

				props.plate    = newPlate



				ESX.TriggerServerCallback('esx_ambulancejob:buyJobVehicle', function (bought)

					if bought then

						ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))



						isInShopMenu = false

						ESX.UI.Menu.CloseAll()

				

						DeleteSpawnedVehicles()

						FreezeEntityPosition(playerPed, false)

						exports.esx_checker:SetVisible(true)

						ESX.Game.Teleport(playerPed, restoreCoords)

					else

						ESX.ShowNotification(_U('vehicleshop_money'))

						menu2.close()

					end

				end, props, data.current.type)

			else

				menu2.close()

			end



		end, function(data2, menu2)

			menu2.close()

		end)



		end, function(data, menu)

		isInShopMenu = false

		ESX.UI.Menu.CloseAll()



		DeleteSpawnedVehicles()

		FreezeEntityPosition(playerPed, false)

		exports.esx_checker:SetVisible(true)



		ESX.Game.Teleport(playerPed, restoreCoords)

	end, function(data, menu)

		DeleteSpawnedVehicles()



		WaitForVehicleToLoad(data.current.model)

		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)

			table.insert(spawnedVehicles, vehicle)

			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

			FreezeEntityPosition(vehicle, true)

		end)

	end)



	WaitForVehicleToLoad(elements[1].model)

	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)

		table.insert(spawnedVehicles, vehicle)

		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

		FreezeEntityPosition(vehicle, true)

	end)

end



Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)



		if isInShopMenu then

			DisableControlAction(0, 75, true)  -- Disable exit vehicle

			DisableControlAction(27, 75, true) -- Disable exit vehicle

		else

			Citizen.Wait(500)

		end

	end

end)



function DeleteSpawnedVehicles()

	while #spawnedVehicles > 0 do

		local vehicle = spawnedVehicles[1]

		ESX.Game.DeleteVehicle(vehicle)

		table.remove(spawnedVehicles, 1)

	end

end



function WaitForVehicleToLoad(modelHash)

	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))



	if not HasModelLoaded(modelHash) then

		RequestModel(modelHash)



		while not HasModelLoaded(modelHash) do

			Citizen.Wait(0)



			DisableControlAction(0, Keys['TOP'], true)

			DisableControlAction(0, Keys['DOWN'], true)

			DisableControlAction(0, Keys['LEFT'], true)

			DisableControlAction(0, Keys['RIGHT'], true)

			DisableControlAction(0, 176, true) -- ENTER key

			DisableControlAction(0, Keys['BACKSPACE'], true)



			drawLoadingText(_U('vehicleshop_awaiting_model'), 255, 255, 255, 255)

		end

	end

end



function drawLoadingText(text, red, green, blue, alpha)

	SetTextFont(4)

	SetTextScale(0.0, 0.5)

	SetTextColour(red, green, blue, alpha)

	SetTextDropshadow(0, 0, 0, 0, 255)

	SetTextEdge(1, 0, 0, 0, 255)

	SetTextDropShadow()

	SetTextOutline()

	SetTextCentre(true)



	BeginTextCommandDisplayText("STRING")

	AddTextComponentSubstringPlayerName(text)

	EndTextCommandDisplayText(0.5, 0.5)

end



function OpenPharmacyMenu()

	ESX.UI.Menu.CloseAll()



	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {

		title    = _U('pharmacy_menu_title'),

		align    = 'top-left',

		elements = {

			{label = _U('pharmacy_take', _U('medikit')), value = 'medikit'},

			{label = _U('pharmacy_take', _U('bandage')), value = 'bandage'}

		}

	}, function(data, menu)

		TriggerServerEvent('esx_ambulancejob:giveItem', data.current.value)

	end, function(data, menu)

		menu.close()

	end)

end



function WarpPedInClosestVehicle(ped)

	local coords = GetEntityCoords(ped)



	local vehicle, distance = ESX.Game.GetClosestVehicle(coords)



	if distance ~= -1 and distance <= 5.0 then

		local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)



		for i=maxSeats - 1, 0, -1 do

			if IsVehicleSeatFree(vehicle, i) then

				freeSeat = i

				break

			end

		end



		if freeSeat then

			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)

		end

	else

		ESX.ShowNotification(_U('no_vehicles'))

	end

end



RegisterNetEvent('esx_ambulancejob:heal')

AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)

	local playerPed = PlayerPedId()

	local maxHealth = GetEntityMaxHealth(playerPed)



	if healType == 'small' then

		local health = GetEntityHealth(playerPed)

		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))

		SetEntityHealth(playerPed, newHealth)

	elseif healType == 'big' then

		SetEntityHealth(playerPed, maxHealth)

	end



	if not quiet then

		ESX.ShowNotification(_U('healed'))

	end

end)



function SetVehicleMods(vehicle, color, colorA, colorB, colorC, plate)

	

	local props = {}



	if not color then

		local plate = string.gsub(plate, "-", "")

		props = {

			modEngine       =   3,

			modBrakes       =   2,

			windowTint      =   -1,

			modArmor        =   4,

			modTransmission =   2,

			modSuspension   =   -1,

			plate           =   plate,

			modTurbo        =   true,

		}



	else



		props = {

			modEngine       =   3,

			modBrakes       =   2,

			windowTint      =   -1,

			modArmor        =   4,

			modTransmission =   2,

			modSuspension   =   -1,

			color1 = colorA,

			color2 = colorB,

			pearlescentColor = colorC,

			plate           =   plate,

			modTurbo        =   true,

		}

	

	end

	



	ESX.Game.SetVehicleProperties(vehicle, props)

	SetVehicleDirtLevel(vehicle, 0.0)

end

function IsAllowedVehicle(table, val)
	for i = 1, #table do
		if table[i] == val then
			return true
		end
	end
	return false
  end

function VehicleHandler(vehicle, extras)

	local vehicle = vehicle
	local extras = extras

	if extras then
		for i,v in ipairs(extras) do
			SetVehicleExtra(vehicle, v, 0)
		end

	
		SetVehicleFixed(vehicle)
		Citizen.Wait(2000)
		SetVehicleFuelLevel(vehicle, 100.0)
	end

 end