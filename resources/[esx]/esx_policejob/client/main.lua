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
  
  local PlayerData              = {}
  local HasAlreadyEnteredMarker = false
  local LastStation             = nil
  local LastPart                = nil
  local LastPartNum             = nil
  local LastEntity              = nil
  local CurrentAction           = nil
  local CurrentActionMsg        = ''
  local CurrentActionData       = {}
  local IsHandcuffed            = false
  local HandcuffTimer           = {}
  local DragStatus              = {}
  DragStatus.IsDragged          = false
  local hasAlreadyJoined        = false
  local blipsCops               = {}
  local isDead                  = false
  local CurrentTask             = {}
  local playerInService         = false
  local RadioBusy               = false
  local callsign                = nil
  local blip                
  local handcuffOBJ
  local blips                   = {ped = nil, color = 0}
  local trackvehicle
  local trackvehicles           = nil
  local IsOnSwatDuty            = false
  ESX                           = nil

  local NumberCharset = {}
  local Charset = {}

	for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
	for i = 65,  90 do table.insert(Charset, string.char(i)) end
	for i = 97, 122 do table.insert(Charset, string.char(i)) end
	
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
  
  function SetVehicleMaxMods(vehicle, plate, window, colors)
	local plate = string.gsub(plate, "-", "")
	local props

	if colors then
	props = {
		modEngine       =   3,
		modBrakes       =   2,
		windowTint      =   window,
		modArmor        =   4,
		modTransmission =   2,
		modSuspension   =   -1,
		modTurbo        =   true,
		plate           =   plate,
		color1 = colors.a,
		color2 = colors.b,
	}
	else
	 props = {
		modEngine       =   3,
		modBrakes       =   2,
		windowTint      =   window,
		modArmor        =   4,
		modTransmission =   2,
		modSuspension   =   -1,
		modTurbo        =   true,
		plate           =   plate,
	}
	end

	  ESX.Game.SetVehicleProperties(vehicle, props)
	  SetVehicleDirtLevel(vehicle, 0.0)
  end

  function VehicleHandler(vehicle, extras, nonextras, livery)

	local vehicle = vehicle
	local livery = livery
	local extras = extras
	local nonextras = nonextras

	if extras then
		for i,v in ipairs(extras) do
			SetVehicleExtra(vehicle, v, 0)
		end

		if nonextras then
			for i,v in ipairs(nonextras) do
				SetVehicleExtra(vehicle, v, 1)
			end
		end
	
		SetVehicleFixed(vehicle)
	end

	if livery then
		SetVehicleLivery(vehicle, livery)
	end

	Citizen.Wait(2000)
	SetVehicleFuelLevel(vehicle, 100.0)

  end
  
  function cleanPlayer(playerPed)
	  SetPedArmour(playerPed, 0)
	  ClearPedBloodDamage(playerPed)
	  ResetPedVisibleDamage(playerPed)
	  ClearPedLastWeaponDamage(playerPed)
	  ResetPedMovementClipset(playerPed, 0)
  end
  
  function setUniform(job, playerPed)
  
	  TriggerEvent('skinchanger:getSkin', function(skin)
  
		  if skin.sex == 0 then
  
			  if Config.Uniforms[job].male ~= nil then
				  TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			  else
				  ESX.ShowNotification(_U('no_outfit'))
			  end
  
			  if job ~= "citizen_wear"  then
				  SetPedArmour(playerPed, 100)
			  end
  
		  else
  
			  if Config.Uniforms[job].female ~= nil then
				  TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			  else
				  ESX.ShowNotification(_U('no_outfit'))
			  end
  
			  if job ~= "citizen_wear" then
				  SetPedArmour(playerPed, 100)
			  end
  
		  end
  
	  end)
  end

  function OpenCloakroomMenu()
  
	  local playerPed = PlayerPedId()
	  local grade = PlayerData.job.grade_name
  
	  local elements = {
		  { label = _U('citizen_wear'), value = 'citizen_wear' },
	  }

	
		table.insert(elements, {label = "Police Outfit S", value = grade .. '_wear'})
		table.insert(elements, {label = "Police Outfit L", value = grade .. '_wearl'})
		table.insert(elements, {label = "Bullet Wear", value = 'vest'})
  
	  if PlayerData.divisions["police"] and PlayerData.divisions.police.swat then
		  table.insert(elements, {label = ('Swat Outfit'), value = 'swat_wear'})
	  end

	  if PlayerData.divisions["police"] and PlayerData.divisions.police.sheriff then
		table.insert(elements, {label = ('Sheriff Outfit S'), value = 'sheriff_wear_' .. grade})
		table.insert(elements, {label = ('Sheriff Outfit L'), value = 'sheriff_wearl_' .. grade})
	  end

	  if PlayerData.divisions["police"] and PlayerData.divisions.police.sheriff then
		table.insert(elements, {label = ('Sheriff Vest'), value = 'sheriff_vest'})
	  end
  
	  if grade == 'boss' then
		  table.insert(elements, {label = ('Chief Wear'), value = 'boss_wear'})
	  end
  
	  if Config.EnableNonFreemodePeds then
		  table.insert(elements, {label = 'Sheriff wear', value = 'freemode_ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'})
		  table.insert(elements, {label = 'Police wear', value = 'freemode_ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'})
		  table.insert(elements, {label = 'Swat wear', value = 'freemode_ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'})
	  end
  
	  ESX.UI.Menu.CloseAll()
  
	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	  {
		  title    = _U('cloakroom'),
		  align    = 'top-left',
		  elements = elements
	  }, function(data, menu)
  
		  cleanPlayer(playerPed)
  
		  if data.current.value == 'citizen_wear' then
			ESX.SetPlayerData('IsSwat', 0)
			IsOnSwatDuty = false
			  if Config.EnableNonFreemodePeds then
				  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					  local isMale = skin.sex == 0
  
					  TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							  TriggerEvent('skinchanger:loadSkin', skin)
						  end)
					  end)
  
				  end)
			  else
				  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					  TriggerEvent('skinchanger:loadSkin', skin)
				  end)
			  end
  
			  if Config.MaxInService ~= -1 then
  
				  ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					  if isInService then
  
						  playerInService = false
  
						  local notification = {
							  title    = _U('service_anonunce'),
							  subject  = '',
							  msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							  iconType = 1
						  }
  
						  TriggerServerEvent('esx_service:notifyAllInService', notification, 'police')
  
						  TriggerServerEvent('esx_service:disableService', 'police')
						  TriggerEvent('esx_policejob:updateBlip')
						  ESX.ShowNotification(_U('service_out'))
					  end
				  end, 'police')
			  end
  
		  end
  
		  if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			  local serviceOk = 'waiting'
  
			  ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				  if not isInService then
  
					  ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						  if not canTakeService then
							  ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						  else
  
							  serviceOk = true
							  playerInService = true
  
							  local notification = {
								  title    = _U('service_anonunce'),
								  subject  = '',
								  msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								  iconType = 1
							  }
	  
							  TriggerServerEvent('esx_service:notifyAllInService', notification, 'police')
							  TriggerEvent('esx_policejob:updateBlip')
							  ESX.ShowNotification(_U('service_in'))
						  end
					  end, 'police')
  
				  else
					  serviceOk = true
				  end
			  end, 'police')
  
			  while type(serviceOk) == 'string' do
				  Citizen.Wait(5)
			  end
  
			  -- if we couldn't enter service don't let the player get changed
			  if not serviceOk then
				  return
			  end
		  end
  
		  if

			data.current.value == grade .. '_wear' or
			data.current.value == grade .. '_wearl' or
			data.current.value == 'vest' or
			data.current.value == 'swat_wear' or
			data.current.value == 'sheriff_wear_' .. grade or
			data.current.value == 'sheriff_wearl_' .. grade or
			data.current.value == 'sheriff_vest'

		  then
			  if data.current.value == "swat_wear" then
				ESX.SetPlayerData('IsSwat', 1)
				IsOnSwatDuty = true
			  else
				ESX.SetPlayerData('IsSwat', 0)
				IsOnSwatDuty = false
			  end

			  if data.current.value == "sheriff_wear_" .. grade or data.current.value == "sheriff_wearl_" .. grade or data.current.value == "sheriff_vest" then
				ESX.SetPlayerData('IsSheriff', 1)
			  else
				ESX.SetPlayerData('IsSheriff', 0)
			  end

			  setUniform(data.current.value, playerPed)
		  end
  
		  if data.current.value == 'freemode_ped' then
			  local modelHash = ''
  
			  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				  if skin.sex == 0 then
					  modelHash = GetHashKey(data.current.maleModel)
				  else
					  modelHash = GetHashKey(data.current.femaleModel)
				  end
  
				  ESX.Streaming.RequestModel(modelHash, function()
					  SetPlayerModel(PlayerId(), modelHash)
					  SetModelAsNoLongerNeeded(modelHash)
				  end)
			  end)
  
		  end
  
  
  
	  end, function(data, menu)
		  menu.close()
  
		  CurrentAction     = 'menu_cloakroom'
		  CurrentActionMsg  = _U('open_cloackroom')
		  CurrentActionData = {}
	  end)
  end
  
  function OpenArmoryMenu(station)
  
	if Config.EnableArmoryManagement then
  
	  local elements = {
		--{label = _U('get_weapon'),     value = 'get_weapon'},
		{label = _U('put_weapon'),     value = 'put_weapon'},
		--{label = _U('remove_object'),  value = 'get_stock'},
		{label = _U('deposit_object'), value = 'put_stock'}
	  }
  
	  if PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
	  end
	  
		table.insert(elements, {label = _U('remove_object'), value = 'get_stock'})
		table.insert(elements, {label = _U('get_weapon'), value = 'get_weapon'})
  
	  ESX.UI.Menu.CloseAll()
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory',
		{
		  title    = _U('armory'),
		  align    = 'top-left',
		  elements = elements,
		},
		function(data, menu)
  
		  if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()
		  end
  
		  if data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
		  end
  
		  if data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu(station)
		  end
  
		  if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		  end
  
		  if data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		  end
  
		end,
		function(data, menu)
  
		  menu.close()
  
		  CurrentAction     = 'menu_armory'
		  CurrentActionMsg  = _U('open_armory')
		  CurrentActionData = {station = station}
		end)
  
	else
  
	  local elements = {}

	  for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
		local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
		table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
	  end
  
	  ESX.UI.Menu.CloseAll()
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory',
		{
		  title    = _U('armory'),
		  align    = 'top-left',
		  elements = elements,
		},
		function(data, menu)
		  local weapon = data.current.value
		  TriggerServerEvent('esx_policejob:giveWeapon', weapon,  1000)
		end,
		function(data, menu)
  
		  menu.close()
  
		  CurrentAction     = 'menu_armory'
		  CurrentActionMsg  = _U('open_armory')
		  CurrentActionData = {station = station}
  
		end
	  )
  
	end
  
  end
  
  function OpenVehicleSpawnerMenu(station, partNum)
  
	  local vehicles = Config.PoliceStations[station].Vehicles
	  ESX.UI.Menu.CloseAll()
  
		  local elements = {}
		
		  if PlayerData.divisions.police ~= nil and PlayerData.divisions.police.detective then
			table.insert(elements, { label = "Detective Schafter", model =  "polschafter3"})
			table.insert(elements, { label = "Detective Charger", model = "2018charger", livery = 1, extras = {2, 3, 4, 8}, nonextras = {1,5,6,7} })
		  end

		  if PlayerData.divisions.police ~= nil and PlayerData.divisions.police.swat then
			table.insert(elements, { label = "S.W.A.T Brickade", model =  "brickade"})
		  end

		  if PlayerData.divisions.police ~= nil and PlayerData.divisions.police.swat and ESX.GetPlayerData()['IsSwat'] == 1 then
			table.insert(elements, { label = "S.W.A.T Insurgent", model = "insurgent2"})
			table.insert(elements, { label = "S.W.A.T Riot2", model =  "riot2"})
			table.insert(elements, { label = "S.W.A.T Riot", model =  "riot"})
			table.insert(elements, { label = "S.W.A.T Crusier", model =  "fbi"})
			table.insert(elements, { label = "S.W.A.T Granger", model =  "fbi2"})
			table.insert(elements, { label = "S.W.A.T Dubsta", model =  "dubsta3"})
			table.insert(elements, { label = "S.W.A.T Charger", model = "2018charger", livery = 3, extras = {2, 3, 4, 8}, nonextras = {1,5,6,7} })
			table.insert(elements, { label = "S.W.A.T MRap", model = "mrap", livery = 0, extras = {2, 3, 4, 8, 9}, nonextras = {1,5,6,7} })
		  end

		  if PlayerData.divisions.police ~= nil and PlayerData.divisions.police.sheriff and ESX.GetPlayerData()['IsSheriff'] == 1 then
			table.insert(elements, { label = "Sheriff Cruiser", model = "chgr"})
			table.insert(elements, { label = "Sheriff Cruiser2", model = "sheriff"})
			table.insert(elements, { label = "Sheriff Highway", model = "sheriff2"})
			table.insert(elements, { label = "Sheriff SUV", model = "bcscout"})
			table.insert(elements, { label = "Sheriff SUV2", model = "sherscout"})
			table.insert(elements, { label = "Sheriff Charger", model = "2018charger", livery = 2, extras = {1, 2, 3, 4, 8}, nonextras = {5, 6, 7} })
		  end

		if PlayerData.divisions.police ~= nil and PlayerData.divisions.police.traffic then
			table.insert(elements, { label = "High Speed Unit", model = "polvacca"})
		end
		
		  local sharedVehicles = Config.AuthorizedVehicles.Shared
		  for i=1, #sharedVehicles, 1 do
			  table.insert(elements, { label = sharedVehicles[i].label, model = sharedVehicles[i].model})
		  end
  
		  local authorizedVehicles = Config.AuthorizedVehicles[PlayerData.job.grade_name]
		  for i=1, #authorizedVehicles, 1 do
			  table.insert(elements, { label = authorizedVehicles[i].label, model = authorizedVehicles[i].model, livery = authorizedVehicles[i].livery, extras = authorizedVehicles[i].extras, nonextras = authorizedVehicles[i].nonextras})
		  end
  
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
		  {
			  title    = _U('vehicle_menu'),
			  align    = 'top-left',
			  elements = elements
		  }, function(data, menu)
			  menu.close()
  
			  local model   = data.current.model
  
			  if ESX.Game.IsSpawnPointClear({x = vehicles[partNum].SpawnPoint.x, y = vehicles[partNum].SpawnPoint.y, z = vehicles[partNum].SpawnPoint.z}, 5.0) then
  
				  local playerPed = PlayerPedId()

					  ESX.Game.SpawnVehicle(model, vehicles[partNum].SpawnPoint, vehicles[partNum].Heading, function(vehicle)
						  TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						  if model == "insurgent2" or model == "brickade" or model == "riot2" or model == "riot" or model == "fbi2" or model == "fbi" or model == "dubsta3" then
							 local colors = {a = 0, b = 0}
						 	 SetVehicleMaxMods(vehicle, callsign, 1, colors)
						  else
							if model == "polschafter3" then
								local plate = string.upper(GetRandomLetter(3) .. ' ' .. GetRandomNumber(4))
								SetVehicleMaxMods(vehicle, plate, 1)
							elseif model == "2018charger" then
								SetVehicleMaxMods(vehicle, callsign, 1)
								VehicleHandler(vehicle, data.current.extras, data.current.nonextras, data.current.livery)
							else
								SetVehicleMaxMods(vehicle, callsign, -1)
								VehicleHandler(vehicle, data.current.extras, data.current.nonextras, data.current.livery)
							end
							
						  end
						  local NetId = NetworkGetNetworkIdFromEntity(vehicle)
						  TriggerServerEvent("esx_policejob:addVehicle", callsign, NetId)
					  end)
  
			  else
				  ESX.ShowNotification(_U('vehicle_out'))
			  end
  
		  end, function(data, menu)
			  menu.close()
  
			  CurrentAction     = 'menu_vehicle_spawner'
			  CurrentActionMsg  = _U('vehicle_spawner')
			  CurrentActionData = {station = station, partNum = partNum}
  
		  end)
  
	  end

	  function OpenHelicopterSpawnerMenu(station, partNum)
  
		local vehicles = Config.PoliceStations[station].Helicopters
		ESX.UI.Menu.CloseAll()
	
			local elements = {}
		  
			table.insert(elements, { label = "Police Maverick", model = "polmav", livery = 0})
			table.insert(elements, { label = "Sheriff Maverick", model = "polmav", livery = 3})
	
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'helicopter_spawner',
			{
				title    = "Select Vehicle",
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				menu.close()
	
				local model   = data.current.model
	
				if ESX.Game.IsSpawnPointClear({x = vehicles[partNum].SpawnPoint.x, y = vehicles[partNum].SpawnPoint.y, z = vehicles[partNum].SpawnPoint.z}, 5.0) then
	
					local playerPed = PlayerPedId()
	
	
						ESX.Game.SpawnVehicle(model, vehicles[partNum].SpawnPoint, vehicles[partNum].Heading, function(vehicle)
							SetVehicleModKit(vehicle, 0)
							SetVehicleLivery(vehicle, data.current.livery)
							SetVehicleMaxMods(vehicle, callsign, 1)
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
							local NetId = NetworkGetNetworkIdFromEntity(vehicle)
							TriggerServerEvent("esx_policejob:addVehicle", callsign, NetId)
							Citizen.CreateThread(function()
								Citizen.Wait(2000)
								SetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1)), 100.0)
							end)
						end)
						
				else
					ESX.ShowNotification(_U('vehicle_out'))
				end
	
			end, function(data, menu)
				menu.close()
	
				CurrentAction     = 'menu_vehicle_spawner'
				CurrentActionMsg  = _U('vehicle_spawner')
				CurrentActionData = {station = station, partNum = partNum}
	
			end)
	
		end
  
  function OpenPoliceActionsMenu()
	  ESX.UI.Menu.CloseAll()
  
	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions',
	  {
		  title    = 'Police',
		  align    = 'top-left',
		  elements = {
			  {label = _U('citizen_interaction'),	value = 'citizen_interaction'},
			  {label = _U('vehicle_interaction'),	value = 'vehicle_interaction'},
			  {label = _U('object_spawner'),		value = 'object_spawner'}
			  --{label = "Jail Menu",               value = 'jail_menu'} 
		  }
	  }, function(data, menu)
			  
			  
		  if data.current.value == 'citizen_interaction' then
			  local elements = {
				  {label = _U('id_card'),			value = 'identity_card'},
				  {label = _U('search'),			value = 'body_search'},
				  {label = _U('handcuff'),		value = 'handcuff'},
				  {label = _U('uncuff'),			value = 'uncuff'},
				  {label = _U('drag'),			value = 'drag'},
				  {label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
				  {label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},
				--   {label = "GSR - برسی تفنگ",			value = 'gsr_test'},
				  {label = _U('fine'),			value = 'fine'},
				  {label = _U('unpaid_bills'),	value = 'unpaid_bills'},
				  {label = "Zendan",            value = 'jail_menu'}
			  }
		  
			--   if Config.EnableLicenses then
			-- 	  table.insert(elements, { label = _U('license_check'), value = 'license' })
			--   end
		  
			  ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'citizen_interaction',
			  {
				  title    = _U('citizen_interaction'),
				  align    = 'top-left',
				  elements = elements
			  }, function(data2, menu2)
				  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				  if closestPlayer ~= -1 and closestDistance <= 3.0 then
					  local action = data2.current.value
					  
					  if action == 'identity_card' then
						  if Config.EnableJobLogs == true then
							  TriggerServerEvent('esx_joblogs:AddInLog',"police" ,"id_card" ,GetPlayerName(PlayerId()) , GetPlayerName(closestPlayer))
						  end
						  OpenIdentityCardMenu(closestPlayer)
					  elseif action == 'jail_menu' then
						  TriggerEvent("esx-qalle-jail:openJailMenu")
					  elseif action == 'body_search' then
						  if Config.EnableJobLogs == true then
							  TriggerServerEvent('esx_joblogs:AddInLog',"police" ,"being_searched" ,GetPlayerName(PlayerId()) , GetPlayerName(closestPlayer))
						  end
						  TriggerServerEvent('esx_policejob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
						  OpenBodySearchMenu(closestPlayer)
					  elseif action == 'handcuff' then
						  local target, distance = ESX.Game.GetClosestPlayer()
						  playerheading = GetEntityHeading(GetPlayerPed(-1))
						  playerlocation = GetEntityForwardVector(PlayerPedId())
						  playerCoords = GetEntityCoords(GetPlayerPed(-1))
						  local target_id = GetPlayerServerId(target)
						  if distance <= 2.0 then
							  TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
						  else
							  ESX.ShowNotification('Not Close Enough To Cuff.')
						  end
					  elseif action == 'uncuff' then
						  local target, distance = ESX.Game.GetClosestPlayer()
						  playerheading = GetEntityHeading(GetPlayerPed(-1))
						  playerlocation = GetEntityForwardVector(PlayerPedId())
						  playerCoords = GetEntityCoords(GetPlayerPed(-1))
						  local target_id = GetPlayerServerId(target)
						  if distance <= 2.0 then
							  TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
						  else
							  ESX.ShowNotification('Not Close Enough To UnCuff.')
						  end
					  elseif action == 'drag' then
						  TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
					  elseif action == 'put_in_vehicle' then
						
						local vehicle = ESX.Game.GetVehicleInDirection(4)
							if vehicle == 0 then
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
								return
							end
						local NetId = NetworkGetNetworkIdFromEntity(vehicle)
						TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer), NetId)

					  elseif action == 'out_the_vehicle' then
						  TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
					  elseif action == 'fine' then
						  OpenFineMenu(closestPlayer)
					--   elseif action == 'license' then
					-- 	  ShowPlayerLicense(closestPlayer)
					  elseif action == 'unpaid_bills' then
						  OpenUnpaidBillsMenu(closestPlayer)
					  elseif action == 'gsr_test' then
						  TriggerServerEvent('GSR:Status2', GetPlayerServerId(closestPlayer))
					  end
  
				  else
					  ESX.ShowNotification(_U('no_players_nearby'))
				  end
			  end, function(data2, menu2)
				  menu2.close()
			  end)
		  elseif data.current.value == 'vehicle_interaction' then
			  local elements  = {}
			  local playerPed = PlayerPedId()
			  local coords    = GetEntityCoords(playerPed)
			  local vehicle   = ESX.Game.GetVehicleInDirection()
			  
			  if DoesEntityExist(vehicle) then
				  table.insert(elements, {label = _U('vehicle_info'),	value = 'vehicle_infos'})
				--   table.insert(elements, {label = _U('pick_lock'),	value = 'hijack_vehicle'})
				  table.insert(elements, {label = _U('impound'),		value = 'impound'})
			  end
			  
			  table.insert(elements, {label = _U('search_database'), value = 'search_database'})
  
			  ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'vehicle_interaction',
			  {
				  title    = _U('vehicle_interaction'),
				  align    = 'top-left',
				  elements = elements
			  }, function(data2, menu2)
				  coords  = GetEntityCoords(playerPed)
				  vehicle = ESX.Game.GetVehicleInDirection()
				  action  = data2.current.value
				  
				  if action == 'search_database' then
					  LookupVehicle()
				  elseif DoesEntityExist(vehicle) then
					  local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
					  if action == 'vehicle_infos' then
						  OpenVehicleInfosMenu(vehicleData)
						  
					  elseif action == 'hijack_vehicle' then
						  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
							  Citizen.Wait(20000)
							  ClearPedTasksImmediately(playerPed)
  
							  SetVehicleDoorsLocked(vehicle, 1)
							  SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							  ESX.ShowNotification(_U('vehicle_unlocked'))
							  if Config.EnableJobLogs == true then
								  TriggerServerEvent('esx_joblogs:AddInLog',"police" ,"hijack_vehicle" ,GetPlayerName(PlayerId()))
							  end
						  end
					  elseif action == 'impound' then
					  
						local vehicle = ESX.Game.GetVehicleInDirection(4)
							if vehicle == 0 then
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
								return
							end
						exports["esx_vehiclecontrol"]:ImpoundPolice(vehicle)

					  end
				  else
					  ESX.ShowNotification(_U('no_vehicles_nearby'))
				  end
  
			  end, function(data2, menu2)
				  menu2.close()
			  end
			  )
  
		  elseif data.current.value == 'object_spawner' then
			  ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'citizen_interaction',
			  {
				  title    = _U('traffic_interaction'),
				  align    = 'top-left',
				  elements = {
					{label = _U('cone'),		value = 'prop_mp_cone_01'},
					{label = _U('barrier'),		value = 'prop_mp_barrier_02b'},
					{label = _U('barrier1'),		value = 'prop_barrier_work05'},
					{label = _U('barrier2'),		value = 'prop_mp_arrow_barrier_01'},
					{label = _U('spikestrips'),	value = 'p_ld_stinger_s'},
					{label = _U('cash'),		value = 'hei_prop_cash_crate_half_full'}
				  }
			  }, function(data2, menu2)
				  local model     = data2.current.value
				  local playerPed = PlayerPedId()
				  local coords    = GetEntityCoords(playerPed)
				  local forward   = GetEntityForwardVector(playerPed)
				  local x, y, z   = table.unpack(coords + forward * 1.0)
  
				  if model == 'prop_roadcone02a' then
					  z = z - 2.0
				  end
  
				  ESX.Game.SpawnObject(model, {
					  x = x,
					  y = y,
					  z = z
				  }, function(obj)
					  SetEntityHeading(obj, GetEntityHeading(playerPed))
					  PlaceObjectOnGroundProperly(obj)
					  FreezeEntityPosition(obj, true)
				  end)
  
			  end, function(data2, menu2)
				  menu2.close()
			  end)
		  end
  
	  end, function(data, menu)
		  menu.close()
	  end)
  end
  
  function OpenIdentityCardMenu(player)
  
	  ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)
  
		  local elements    = {}
		  local nameLabel   = _U('name', data.name)
		  local jobLabel    = nil
		  local sexLabel    = nil
		  local idLabel     = nil
	  
		  if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			  jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		  else
			  jobLabel = _U('job', data.job.label)
		  end
	  
		  if Config.EnableESXIdentity then
	  
			  nameLabel = _U('name', data.name)
	  
			  --[[if data.sex ~= nil then
				  if string.lower(data.sex) == 'm' then
					  sexLabel = _U('sex', _U('male'))
				  else
					  sexLabel = _U('sex', _U('female'))
				  end
			  else
				  sexLabel = _U('sex', _U('unknown'))
			  end
	  ]]
			  if data.dob ~= nil then
				  dobLabel = _U('dob', data.dob)
			  else
				  dobLabel = _U('dob', _U('unknown'))
			  end
	  
			  if data.height ~= nil then
				  heightLabel = _U('height', data.height)
			  else
				  heightLabel = _U('height', _U('unknown'))
			  end
	  
			  --[[if data.name ~= nil then
				  idLabel = _U('id', data.name)
			  else
				  idLabel = _U('id', _U('unknown'))
			  end]]
	  
		  end
	  
		  local elements = {
			  {label = nameLabel, value = nil},
			  {label = jobLabel,  value = nil},
		  }
	  
	  --[[	if Config.EnableESXIdentity then
			  table.insert(elements, {label = sexLabel, value = nil})
			  table.insert(elements, {label = idLabel, value = nil})
		  end
	  ]]
		  if data.drunk ~= nil then
			  table.insert(elements, {label = _U('bac', data.drunk), value = nil})
		  end
	  
		  if data.licenses ~= nil then
	  
			  table.insert(elements, {label = _U('license_label'), value = nil})
	  
			  for i=1, #data.licenses, 1 do
				  table.insert(elements, {label = data.licenses[i].label, value = nil})
			  end
	  
		  end
	  
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
		  {
			  title    = _U('citizen_interaction'),
			  align    = 'top-left',
			  elements = elements,
		  }, function(data, menu)
	  
		  end, function(data, menu)
			  menu.close()
		  end)
	  
	  end, GetPlayerServerId(player))
  
  end
  
  function OpenBodySearchMenu(player)
  
	  ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)
  
		  local elements = {}
		  ESX.TriggerServerCallback('esx_government:getmoney', function(money)
			table.insert(elements, {label = "----- Cash -----", value = nil})
			table.insert(elements, {
				label = 'Pol: $' .. ESX.Math.GroupDigits(money),
				value = 'money',
				itemType = 'item_money',
				amount = money
			})

			table.insert(elements, {label = _U('guns_label'), value = nil})
  
			for i=1, #data.weapons, 1 do
				table.insert(elements, {
					label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
					value    = data.weapons[i].name,
					itemType = 'item_weapon',
					amount   = data.weapons[i].ammo
				})
			end
	
			table.insert(elements, {label = _U('inventory_label'), value = nil})
	
			for i=1, #data.inventory, 1 do
				if data.inventory[i].count > 0 then
					table.insert(elements, {
					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
					})
				end
			end
	
	
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search',
			{
				title    = _U('search'),
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)
	
				local itemType = data.current.itemType
				local itemName = data.current.value
				local amount   = data.current.amount
	
				if data.current.value ~= nil then
					Wait(math.random(0, 500))
					TriggerServerEvent('esx:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
					OpenBodySearchMenu(player) 
				end
	
			end, function(data, menu)
				menu.close()
			end)

		end, GetPlayerServerId(player))

		 
	  end, GetPlayerServerId(player))
  
  end
  
  function OpenFineMenu(player)
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'fine',
	  {
		title    = _U('fine'),
		align    = 'top-left',
		elements = {
		  {label = _U('traffic_offense'), value = 0},
		  {label = _U('minor_offense'),   value = 1},
		  {label = _U('average_offense'), value = 2},
		  {label = _U('major_offense'),   value = 3}
		},
	  },
	  function(data, menu)
  
		OpenFineCategoryMenu(player, data.current.value)
  
	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  
  end
  
  function OpenFineCategoryMenu(player, category)
  
	ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)
  
	  local elements = {}
  
	  for i=1, #fines, 1 do
		table.insert(elements, {
		  label     = fines[i].label .. ' <span style="color: green;">$' .. fines[i].amount .. '</span>',
		  value     = fines[i].id,
		  amount    = fines[i].amount,
		  fineLabel = fines[i].label
		})
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'fine_category',
		{
		  title    = _U('fine'),
		  align    = 'top-left',
		  elements = elements,
		},
		function(data, menu)
  
		  local label  = data.current.fineLabel
		  local amount = data.current.amount
  
		  menu.close()
  
		  if Config.EnablePlayerManagement then
			TriggerServerEvent('esx_billing:send2Bill', GetPlayerServerId(player), 'society_police', _U('fine_total', label), amount)
		  else
			TriggerServerEvent('esx_billing:send2Bill', GetPlayerServerId(player), '', _U('fine_total', label), amount)
		  end
		  if Config.EnableJobLogs == true then
				  TriggerServerEvent('esx_joblogs:AddInLog',"police" ,"SendFine" ,GetPlayerName(PlayerId()) ,GetPlayerName(player) ,label ,amount)
			  end
		  ESX.SetTimeout(300, function()
			OpenFineCategoryMenu(player, category)
		  end)
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end, category)
  
  end
  
  function LookupVehicle()
	  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
	  {
		  title = _U('search_database_title'),
	  }, function(data, menu)
		  local length = string.len(data.value)
		  if data.value == nil or length < 2 or length > 13 then
			  ESX.ShowNotification(_U('search_database_error_invalid'))
		  else
			  ESX.TriggerServerCallback('esx_policejob:getVehicleFromPlate', function(owner, found)
				  if found then
					  ESX.ShowNotification(_U('search_database_found', owner))
				  else
					  ESX.ShowNotification(_U('search_database_error_not_found'))
				  end
			  end, data.value)
			  menu.close()
		  end
	  end, function(data, menu)
		  menu.close()
	  end)
  end
  
--   function ShowPlayerLicense(player)
-- 	  local elements = {}
-- 	  local targetName
-- 	  ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)
-- 		  if data.licenses ~= nil then
-- 			  for i=1, #data.licenses, 1 do
-- 				  if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
-- 					  table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
-- 				  end
-- 			  end
-- 		  end
		  
-- 		  targetName = data.name
		  
-- 		  ESX.UI.Menu.Open(
-- 		  'default', GetCurrentResourceName(), 'manage_license',
-- 		  {
-- 			  title    = _U('license_revoke'),
-- 			  align    = 'top-left',
-- 			  elements = elements,
-- 		  },
-- 		  function(data, menu)
-- 			  ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
-- 			  TriggerServerEvent('esx_policejob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))
			  
-- 			  TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)
			  
-- 			  ESX.SetTimeout(300, function()
-- 				  ShowPlayerLicense(player)
-- 			  end)
-- 		  end,
-- 		  function(data, menu)
-- 			  menu.close()
-- 		  end
-- 		  )
  
-- 	  end, GetPlayerServerId(player))
--   end
  
  function OpenUnpaidBillsMenu(player)
  
	  local elements = {}
  
	  ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		  for i=1, #bills, 1 do
			  table.insert(elements, {label = bills[i].label .. ' - <span style="color: red;">$' .. bills[i].amount .. '</span>', value = bills[i].id})
		  end
  
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
		  {
			  title    = _U('unpaid_bills'),
			  align    = 'top-left',
			  elements = elements
		  }, function(data, menu)
	  
		  end, function(data, menu)
			  menu.close()
		  end)
	  end, GetPlayerServerId(player))
  end
  
  function OpenVehicleInfosMenu(vehicleData)
  
	  ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
  
		  local elements = {}
  
		  table.insert(elements, {label = _U('plate', retrivedInfo.plate), value = nil})
  
		  if retrivedInfo.owner == nil then
			  table.insert(elements, {label = _U('owner_unknown'), value = nil})
		  else
			  table.insert(elements, {label = _U('owner', retrivedInfo.owner), value = nil})
		  end
  
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos',
		  {
			  title    = _U('vehicle_info'),
			  align    = 'top-left',
			  elements = elements
		  }, nil, function(data, menu)
			  menu.close()
		  end)
  
	  end, vehicleData.plate)
  
  end
  
  function OpenGetWeaponMenu()
  
	ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)
  
	  local elements = {}
	  local sharedWeapons = Config.AuthorizedWeapons.Shared
	  local authorizedWeapons = Config.AuthorizedWeapons[PlayerData.job.grade_name]
	  local IsSwat = ESX.GetPlayerData()['IsSwat']
	  
	  for i=1, #weapons, 1 do
		if weapons[i].count > 0 then

			if weapons[i].name == "WEAPON_MICROSMG" or weapons[i].name == "WEAPON_ADVANCEDRIFLE" then
				if IsSwat == 1 then
					wname = ESX.GetWeaponLabel(weapons[i].name)
					table.insert(elements, {label = 'x ' .. weapons[i].count .. ' ' .. wname, value = weapons[i].name})
				end
			end

			if contains(sharedWeapons, weapons[i].name) then
				wname = ESX.GetWeaponLabel(weapons[i].name)
				table.insert(elements, {label = 'x ' .. weapons[i].count .. ' ' .. wname, value = weapons[i].name})
			else

			if contains(authorizedWeapons, weapons[i].name) then
				wname = ESX.GetWeaponLabel(weapons[i].name)
				table.insert(elements, {label = 'x ' .. weapons[i].count .. ' ' .. wname, value = weapons[i].name})
			end

		 end
		end

		

	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory_get_weapon',
		{
		  title    = _U('get_weapon_menu'),
		  align    = 'top-left',
		  elements = elements
		},
		function(data, menu)
  
		  menu.close()
  
		  ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
			OpenGetWeaponMenu()
		  end, data.current.value)
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end)
  
  end
  
  function OpenPutWeaponMenu()
  
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()
  
	for i=1, #weaponList, 1 do
  
	  local weaponHash = GetHashKey(weaponList[i].name)
  
	  if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
		table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
	  end
  
	end
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'armory_put_weapon',
	  {
		title    = _U('put_weapon_menu'),
		align    = 'top-left',
		elements = elements
	  },
	  function(data, menu)
  
		menu.close()
  
		ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
		  OpenPutWeaponMenu()
		end, data.current.value, true)
  
	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  
  end
  
  function OpenBuyWeaponsMenu(station)
  
	ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)
  
	  local elements = {}
  
	  for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
  
		local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
		local count  = 0
  
		for i=1, #weapons, 1 do
		  if weapons[i].name == weapon.name then
			count = weapons[i].count
			break
		  end
		end
  
		table.insert(elements, {label = 'x' .. count .. ' ' .. weapon.name .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})
  
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory_buy_weapons',
		{
		  title    = _U('buy_weapon_menu'),
		  align    = 'top-left',
		  elements = elements,
		},
		function(data, menu)
  
		  ESX.TriggerServerCallback('esx_policejob:buy', function(hasEnoughMoney)
  
			if hasEnoughMoney then
			  ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
				OpenBuyWeaponsMenu(station)
			  end, data.current.value, false)
			else
			  ESX.ShowNotification(_U('not_enough_money'))
			end
  
		  end, data.current.price)
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end)
  
  end
  
  function OpenGetStocksMenu()
  
	ESX.TriggerServerCallback('esx_policejob:getStockItems', function(items)
  
  
	  local elements = {}
	  local IsSwat = ESX.GetPlayerData()['IsSwat']
  
	  for i=1, #items, 1 do
		if items[i].name == "eclip" then
			if IsSwat then
				table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
			end
		else
			table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		end
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'stocks_menu',
		{
		  title    = _U('police_stock'),
		  align    = 'top-left',
		  elements = elements
		},
		function(data, menu)
  
		  local itemName = data.current.value
  
		  ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
			{
			  title = _U('quantity')
			},
			function(data2, menu2)
  
			  local count = tonumber(data2.value)
  
			  if count == nil then
				ESX.ShowNotification(_U('quantity_invalid'))
			  else
				menu2.close()
				menu.close()
				TriggerServerEvent('esx_policejob:getStockItem', itemName, count)
  
				Citizen.Wait(300)
				OpenGetStocksMenu()
			  end
  
			end,
			function(data2, menu2)
			  menu2.close()
			end
		  )
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end)
  
  end
  
  function OpenPutStocksMenu()
  
	ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)
  
	  local elements = {}
  
	  for i=1, #inventory.items, 1 do
  
		local item = inventory.items[i]
  
		if item.count > 0 then
		  table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
		end
  
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'stocks_menu',
		{
		  title    = _U('inventory'),
		  align    = 'top-left',
		  elements = elements
		},
		function(data, menu)
  
		  local itemName = data.current.value
  
		  ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
			{
			  title = _U('quantity')
			},
			function(data2, menu2)
  
			  local count = tonumber(data2.value)
  
			  if count == nil then
				ESX.ShowNotification(_U('quantity_invalid'))
			  else
				menu2.close()
				menu.close()
				TriggerServerEvent('esx_policejob:putStockItems', itemName, count)
  
				Citizen.Wait(300)
				OpenPutStocksMenu()
			  end
  
			end,
			function(data2, menu2)
			  menu2.close()
			end
		  )
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end)
  
  end
  
  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
	  PlayerData.job = job
	  
	--   Citizen.Wait(5000)
	--   TriggerServerEvent('esx_policejob:forceBlip')
  end)
  
  RegisterNetEvent('esx:setDivision')
  AddEventHandler('esx:setDivision', function(division)
	  PlayerData.divisions = division
  end)

  RegisterNetEvent('esx:setcallsign')
  AddEventHandler('esx:setcallsign', function(sign)
	if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" then
		callsign = sign
	end
  end)

  RegisterNetEvent('esx_policejob:notifyp')
  AddEventHandler('esx_policejob:notifyp', function(message, passedJob)
	if not passedJob then
	  if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" then
		TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[DISPATCH]", message}})
	  end
	else
		if PlayerData.job.name == passedJob then
			TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[DISPATCH]", message}})
		end
	end
  end)

  RegisterNetEvent('esx_policejob:playSound')
  AddEventHandler('esx_policejob:playSound', function(file, volume, passedJob)
	if not passedJob then
		if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" then
			TriggerEvent('InteractSound_CL:PlayOnOne', file, volume)
		end
	  else
		  if PlayerData.job.name == passedJob then
			TriggerEvent('InteractSound_CL:PlayOnOne', file, volume)
		  end
	  end
  end)

  RegisterNetEvent('esx_policejob:respcall')
  AddEventHandler('esx_policejob:respcall', function(request)
	if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" then

		local call = request
		local ped = NetworkGetEntityFromNetworkId(call.NetID)
		--   local coords
		local color
		if string.lower(call.type) == "backup" then
			color = 38
		elseif string.lower(call.type) == "panic" then
			color = 1
		end

		if DoesEntityExist(ped) then

			local coords = GetEntityCoords(ped)
			blip = (AddBlipForCoord(coords.x, coords.y, coords.z))
			SetBlipSprite(blip, 409)
			SetBlipRoute(blip,  true)
			SetBlipRouteColour(blip, color)
			SetBlipColour(blip, color)
			blips.ped = ped
			blips.color = color

		end

	end
  end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(2000)

		if blip ~= nil then
			if blips.ped ~= nil and blips.color ~= 0 then
				if DoesEntityExist(blips.ped) then
					RemoveBlip(blip)
					coords = GetEntityCoords(blips.ped)
					blip = (AddBlipForCoord(coords.x, coords.y, coords.z))
					SetBlipRoute(blip,  true)
					SetBlipRouteColour(blip, blips.color)
					SetBlipColour(blip, blips.color)
				end
			end
		end

	end

end)

  RegisterNetEvent('esx_policejob:trackVehicle')
  AddEventHandler('esx_policejob:trackVehicle', function(vehicle)
	if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" then

	  local ownVehicle = NetworkGetEntityFromNetworkId(vehicle)

	  if DoesEntityExist(ownVehicle) then
		coords = GetEntityCoords(ownVehicle)
		trackvehicle = (AddBlipForCoord(coords.x, coords.y, coords.z))
		SetBlipSprite(trackvehicle, 225)
		SetBlipCategory(trackvehicle, 2)
		SetBlipColour(trackvehicle, 29)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(callsign)
		EndTextCommandSetBlipName(trackvehicle)
		trackvehicles = ownVehicle

	  end
	end
  end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(2000)

		if trackvehicle ~= nil then
			if trackvehicles ~= nil then
				if DoesEntityExist(trackvehicles) then
					RemoveBlip(trackvehicle)
					coords = GetEntityCoords(trackvehicles)
					trackvehicle = (AddBlipForCoord(coords.x, coords.y, coords.z))
					SetBlipSprite(trackvehicle, 225)
					SetBlipCategory(trackvehicle, 2)
					SetBlipColour(trackvehicle, 29)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(callsign)
					EndTextCommandSetBlipName(trackvehicle)
				else
					RemoveBlip(trackvehicle)
				end
			end
		else
			Citizen.Wait(3000)
		end

	end

end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(500)

		local ped = GetPlayerPed(-1)
		if IsOnSwatDuty and PlayerData.job.name == "police" then
			SetPedConfigFlag(ped, 438, false)
		else
			SetPedConfigFlag(ped, 438, true)
		end

	end

end)

  RegisterNetEvent('esx_policejob:stopTrack')
  AddEventHandler('esx_policejob:stopTrack', function()
	if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" then
		RemoveBlip(trackvehicle)
		trackvehicle = nil
		trackvehicles = nil
	end
  end)

  RegisterNetEvent('esx_policejob:closecall')
  AddEventHandler('esx_policejob:closecall', function()
	if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" then
	  RemoveBlip(blip)
	  blip = nil
	  blips.ped = nil
	  blips.color = 0
	end
  end)

	RegisterCommand("setcall", function(source, args)
		if not tonumber(args[1]) then
			TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Syntax vared shode eshtebah ast"}})
			return
		end
		
		if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" then
			if blip ~= nil then
				RemoveBlip(blip)
				blip = nil
			else
				TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Shoma be hich calli javab nadadid"}})
			end
		else
			TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Shoma police nistid"}})
		end
	end, false)

	RegisterCommand('delobject', function(source, args, rawCommand)
		if PlayerData.job.name == "police" then
		  local prop = 0
		  local deelz = 10
		  local deelxy = 2
		  for offsety=-2,2 do
			  for offsetx=-2,2 do
				  for offsetz=-8,8 do
					  local CoordFrom = GetEntityCoords(PlayerPedId(), true)
					  local CoordTo = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
					  local RayHandle = StartShapeTestRay(CoordFrom.x, CoordFrom.y, CoordFrom.z-(offsetz/deelz), CoordTo.x+(offsetx/deelxy), CoordTo.y+(offsety/deelxy), CoordTo.z-(offsetz/deelz), 16, PlayerPedId(), 0)
					  local _, _, _, _, object = GetShapeTestResult(RayHandle)
					  if object ~= 0 then
						  prop = object
						  break
					  end
				  end
			  end
		  end
		  if prop == 0 then
			  TriggerEvent('chatMessage', '', {255,255,255}, '^8Error: ^0could not detect object.')
		  else

			ESX.Game.DeleteObject(prop)
				
		   end
		else
		  ESX.ShowNotification('~r~~h~Shoma police nistid')
		  end
		
		end, false)
  
  RegisterNetEvent('esx_phone:loaded')
  AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	  local specialContact = {
		  name       = _U('phone_police'),
		  number     = 'police',
		  base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7XpZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhXPDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkWshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMxpIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuXPZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHWshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
	  }
  
	  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
  end)
  
  -- don't show dispatches if the player isn't in service
  AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
  
	  if type(PlayerData.job.name) == 'string' and PlayerData.job.name == 'police' and PlayerData.job.name == dispatchNumber then
		  -- if esx_service is enabled
		  if Config.MaxInService ~= -1 and not playerInService then
			  CancelEvent()
		  end
	  end
  end)
  
  
  AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)
  
	if part == 'Cloakroom' then
	  CurrentAction     = 'menu_cloakroom'
	  CurrentActionMsg  = _U('open_cloackroom')
	  CurrentActionData = {}
	end
  
	if part == 'Armory' then
	  CurrentAction     = 'menu_armory'
	  CurrentActionMsg  = _U('open_armory')
	  CurrentActionData = {station = station}
	end
  
	if part == 'VehicleSpawner' then
	  CurrentAction     = 'menu_vehicle_spawner'
	  CurrentActionMsg  = _U('vehicle_spawner')
	  CurrentActionData = {station = station, partNum = partNum}
	end
  
	if part == 'HelicopterSpawner' then
		CurrentAction     = 'menu_helicopter_spawner'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro baraye select kardan helicopter bezanid'
		CurrentActionData = {station = station, partNum = partNum}
	end
  
	if part == 'VehicleDeleter' then
  
	  local playerPed = PlayerPedId()
	  local coords    = GetEntityCoords(playerPed)
  
	  if IsPedInAnyVehicle(playerPed,  false) then
  
		local vehicle = GetVehiclePedIsIn(playerPed, false)
  
		if DoesEntityExist(vehicle) then
		  CurrentAction     = 'delete_vehicle'
		  CurrentActionMsg  =  "Dokme ~INPUT_CONTEXT~ ro fehar bedid ta mashin repair she"  --_U('store_vehicle')
		  CurrentActionData = {vehicle = vehicle}
		end
  
	  end
  
	end
  
	if part == 'BossActions' then
	  CurrentAction     = 'menu_boss_actions'
	  CurrentActionMsg  = _U('open_bossmenu')
	  CurrentActionData = {}
	end
  
  end)
  
  AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
  end)
  
  AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)
  
	local playerPed = PlayerPedId()
  
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' and not IsPedInAnyVehicle(playerPed, false) then
	  CurrentAction     = 'remove_entity'
	  CurrentActionMsg  = _U('remove_prop')
	  CurrentActionData = {entity = entity}
	end
  
	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
  
	  local playerPed = PlayerPedId()
	  local coords    = GetEntityCoords(playerPed)
  
	  if IsPedInAnyVehicle(playerPed,  false) then
  
		local vehicle = GetVehiclePedIsIn(playerPed)
  
		for i=0, 7, 1 do
		  SetVehicleTyreBurst(vehicle,  i,  true,  1000)
		end
  
	  end
  
	end
  
  end)
  
  AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)
  
	if CurrentAction == 'remove_entity' then
	  CurrentAction = nil
	end
  
  end)
  
  RegisterNetEvent('esx_policejob:hairpixelndcuff')
  AddEventHandler('esx_policejob:hairpixelndcuff', function()
	  local playerPed = PlayerPedId()
  
	  Citizen.CreateThread(function()
		  if IsHandcuffed then
  
			  if Config.EnableHandcuffTimer then
  
				  if HandcuffTimer.Active then
					  ESX.ClearTimeout(HandcuffTimer.Task)
				  end
  
				  StartHandcuffTimer()
			  end
  
		  else
  
			  if Config.EnableHandcuffTimer and HandcuffTimer.Active then
				  ESX.ClearTimeout(HandcuffTimer.Task)
			  end
		  end
	  end)
  
  end)
  
  RegisterNetEvent('esx_policejob:unrestrain')
  AddEventHandler('esx_policejob:unrestrain', function()
	  if IsHandcuffed then
		  local playerPed = PlayerPedId()
		  IsHandcuffed = false
  
		  ClearPedSecondaryTask(playerPed)
		  SetEnableHandcuffs(playerPed, false)
		  DisablePlayerFiring(playerPed, false)
		  SetPedCanPlayGestureAnims(playerPed, true)
		  FreezeEntityPosition(playerPed, false)
		  DisplayRadar(true)
  
		  -- end timer
		  if Config.EnableHandcuffTimer and HandcuffTimer.Active then
			  ESX.ClearTimeout(HandcuffTimer.Task)
		  end
	  end
  end)
  
  RegisterNetEvent('esx_policejob:drag')
  AddEventHandler('esx_policejob:drag', function(copID)
	  if not IsHandcuffed then
		  return
	  end
  
	  DragStatus.IsDragged = not DragStatus.IsDragged
	  DragStatus.CopId     = tonumber(copID)
  end)

--   RegisterNetEvent('esx_policejob:deleteVehicle')
--   AddEventHandler('esx_policejob:deleteVehicle', function(vehicle, identifier)
-- 	  if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" then
-- 		  local identifier = identifier
-- 		  local vehicle = NetworkGetEntityFromNetworkId(vehicle)

-- 		  if DoesEntityExist(vehicle) then
		
-- 			NetworkRequestControlOfEntity(vehicle)
    
-- 			local timeout = 2000
-- 			while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do
-- 				Wait(100)
-- 				timeout = timeout - 100
-- 			end
		
-- 			SetEntityAsMissionEntity(vehicle, true, true)
			
-- 			local timeout = 2000
-- 			while timeout > 0 and not IsEntityAMissionEntity(vehicle) do
-- 				Wait(100)
-- 				timeout = timeout - 100
-- 			end
			
-- 			if not IsAnyPedInVehicle(vehicle) then
-- 				Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle) )
-- 				DeleteEntity(vehicle)
-- 				if not DoesEntityExist(vehicle) then
-- 					TriggerServerEvent("esx_policejob:removeVehicle", callsign)
-- 					TriggerServerEvent("esx_policejob:stopTrackForALL", identifier) 
-- 					TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[DISPATCH]", "Betty mashin ra be pasgah bargardand"}})
-- 				else
-- 					TriggerEvent('chat:addMessage', { color = {255, 0, 0}, multiline = true, args = {"[SYSTEM]", "System hazf mashin be moshkel barkhord be developer etelaa dahid!"}})
-- 				end
-- 			else
-- 				TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[DISPATCH]", "Betty nemitavand mashin ra peyda konad"}})
-- 			end

-- 		  else
-- 			TriggerEvent('chat:addMessage', { color = {255, 0, 0}, multiline = true, args = {"[SYSTEM]", "In mashin vojod naddarad lotfan be admin etelaa dahid"}})
-- 		  end

-- 	  end
--   end)

  RegisterNetEvent('esx_policejob:modifyVehicle')
  AddEventHandler('esx_policejob:modifyVehicle', function(vehicle, plate)
	  if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "doc" then
		  local vehicle = NetworkGetEntityFromNetworkId(vehicle)

		  if DoesEntityExist(vehicle) then
		
			NetworkRequestControlOfEntity(vehicle)
    
			local timeout = 2000
			while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do
				Wait(100)
				timeout = timeout - 100
			end

			SetVehicleNumberPlateText(vehicle, plate)
		  end

	  end
  end)
  
  Citizen.CreateThread(function()
	  local playerPed
	  local targetPed
  
	  while true do
		  Citizen.Wait(1)
  
		  if IsHandcuffed then
			  playerPed = PlayerPedId()
  
			  if DragStatus.IsDragged then
				  targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))
  
				  -- undrag if target is in an vehicle
				  if not IsPedSittingInAnyVehicle(targetPed) then
					  AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				  else
					  DragStatus.IsDragged = false
					  DetachEntity(playerPed, true, false)
				  end
  
			  else
				  DetachEntity(playerPed, true, false)
			  end
		  else
			  Citizen.Wait(500)
		  end
	  end
  end)
  
  RegisterNetEvent('esx_policejob:putInVehicle')
  AddEventHandler('esx_policejob:putInVehicle', function(vehicle)
	if IsHandcuffed then
		local veh = NetworkGetEntityFromNetworkId(vehicle)
		local ped = GetPlayerPed(-1)

		if IsVehicleSeatFree(veh, 1) then

			TaskWarpPedIntoVehicle(ped, veh, 1)
			TriggerEvent('seatbelt:changeStatus', true)

		elseif IsVehicleSeatFree(veh, 2) then

			TaskWarpPedIntoVehicle(ped, veh, 2)
			TriggerEvent('seatbelt:changeStatus', true)

		end
	end	
  end)
  
  RegisterNetEvent('esx_policejob:OutVehicle')
  AddEventHandler('esx_policejob:OutVehicle', function()
	  local playerPed = PlayerPedId()
  
	  if not IsPedSittingInAnyVehicle(playerPed) then
		  return
	  end
  
	  local vehicle = GetVehiclePedIsIn(playerPed, false)
	  TaskLeaveVehicle(playerPed, vehicle, 16)
  end)
  
  RegisterNetEvent('esx_policejob:getarrested')
  AddEventHandler('esx_policejob:getarrested', function(playerheading, playercoords, playerlocation)
	if ESX.GetPlayerData()['HandCuffed'] ~= 1 then
	  playerPed = GetPlayerPed(-1)
	  ESX.SetPlayerData('HandCuffed', 1)
	  SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	  local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	  SetEntityCoords(GetPlayerPed(-1), x, y, z)
	  SetEntityHeading(GetPlayerPed(-1), playerheading)
	  Citizen.Wait(250)
	  loadanimdict('mp_arrest_paired')
	  TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	  Citizen.Wait(3760)
	  TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'cuff', 1.0)
	  IsHandcuffed = true
	  TriggerEvent('esx_policejob:hairpixelndcuff')
	  loadanimdict('mp_arresting')
	  TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)

	  --//handcuff prop
	  local model = "prop_cs_cuffs_01"
	  RequestModel(GetHashKey(model))  
		while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(100)
		end

	 local plyCoords = GetEntityCoords(playerPed, false)
	 handcuffOBJ = CreateObject(GetHashKey(model), plyCoords.x, plyCoords.y, plyCoords.z, true, true, false)
	 local netID = NetworkGetNetworkIdFromEntity(handcuffOBJ)
	 TriggerServerEvent('esx_policejob:addHandCuff', netID)
	 AttachEntityToEntity(handcuffOBJ, playerPed, GetPedBoneIndex(playerPed, 60309), 0.0, 0.05, 0.0, 0.0, 0.0, 80.0, 1, 0, 0, 0, 0, 1)
	end
  end)
  
  RegisterNetEvent('esx_policejob:doarrested')
  AddEventHandler('esx_policejob:doarrested', function()
	  SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	  Citizen.Wait(250)
	  loadanimdict('mp_arrest_paired')
	  TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	  Citizen.Wait(3000) 
  end) 
  
  RegisterNetEvent('esx_policejob:douncuffing')
  AddEventHandler('esx_policejob:douncuffing', function()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	  Citizen.Wait(250)
	  loadanimdict('mp_arresting')
	  TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	  Citizen.Wait(5500)
	  ClearPedTasks(GetPlayerPed(-1))
  end)
  
  RegisterNetEvent('esx_policejob:getuncuffed')
  AddEventHandler('esx_policejob:getuncuffed', function(playerheading, playercoords, playerlocation)
	  local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	  SetEntityCoords(GetPlayerPed(-1), x, y, z)
	  SetEntityHeading(GetPlayerPed(-1), playerheading)
	  Citizen.Wait(250)
	  loadanimdict('mp_arresting')
	  TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	  Citizen.Wait(5500)
	  IsHandcuffed = false
	  TriggerEvent('esx_policejob:hairpixelndcuff')
	  ClearPedTasks(GetPlayerPed(-1))
	  ESX.SetPlayerData('HandCuffed', 0)
	  TriggerServerEvent('esx_policejob:removeHandCuff')
	  ESX.Game.DeleteObject(handcuffOBJ)
  end)

  RegisterNetEvent('esx_policejob:requestDelete')
  AddEventHandler('esx_policejob:requestDelete', function(netID)
	  local object = NetworkGetEntityFromNetworkId(netID)
	  if DoesEntityExist(object) then
		ESX.Game.DeleteObject(object)
	  end
  end)
  
  -- Handcuff
  Citizen.CreateThread(function()
	  while true do
		  Citizen.Wait(1)
		  if IsHandcuffed then
			  --DisableControlAction(2, 1, true) -- Disable pan
			--   DisableControlAction(2, 2, true) -- Disable tilt
			  DisableControlAction(2, 24, true) -- Attack
			  DisableControlAction(0, 69, true) -- Attack in car
			  DisableControlAction(0, 70, true) -- Attack in car 2
			  DisableControlAction(0, 68, true) -- Attack in car 3
			  DisableControlAction(0, 66, true) -- Attack in car 4
			  DisableControlAction(0, 167, true) -- F6
			  DisableControlAction(0, 67, true) -- Attack in car 5
			  DisableControlAction(2, 257, true) -- Attack 2
			  DisableControlAction(2, 25, true) -- Aim
			  DisableControlAction(2, 263, true) -- Melee Attack 1
			--   DisableControlAction(0, 30,  true) -- MoveLeftRight
			--   DisableControlAction(0, 31,  true) -- MoveUpDown
			  DisableControlAction(0, 29,  true) -- B
			  DisableControlAction(0, 74,  true) -- H
			  DisableControlAction(0, 71,  true) -- W CAR
			  DisableControlAction(0, 72,  true) -- S CAR
			  DisableControlAction(0, 63,  true) -- A CAR
			  DisableControlAction(0, 64,  true) -- D CAR
			  DisableControlAction(2, Keys['R'], true) -- Reload
			--   DisableControlAction(2, Keys['LEFTSHIFT'], true) -- run
			  DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
			  DisableControlAction(2, Keys['SPACE'], true) -- Jump
			  DisableControlAction(2, Keys['Q'], true) -- Cover
			  DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
			  DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
			  DisableControlAction(2, Keys['F1'], true) -- Disable phone
			  DisableControlAction(2, Keys['F2'], true) -- Inventory
			  DisableControlAction(2, Keys['F3'], true) -- Animations
			  DisableControlAction(2, Keys['V'], true) -- Disable changing view
			  DisableControlAction(2, Keys['X'], true) -- Disable changing view
			  DisableControlAction(2, Keys['P'], true) -- Disable pause screen
			  DisableControlAction(2, Keys['L'], true) -- Disable seatbelt
			  DisableControlAction(2, Keys['Z'], true)
			  DisableControlAction(2, 59, true) -- Disable steering in vehicle
			  DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
			  DisableControlAction(0, 47, true)  -- Disable weapon
			  DisableControlAction(0, 264, true) -- Disable melee
			  DisableControlAction(0, 257, true) -- Disable melee
			  DisableControlAction(0, 140, true) -- Disable melee
			  DisableControlAction(0, 141, true) -- Disable melee
			  DisableControlAction(0, 142, true) -- Disable melee
			  DisableControlAction(0, 143, true) -- Disable melee
			  DisableControlAction(0, 75, true)  -- Disable exit vehicle
			  DisableControlAction(27, 75, true) -- Disable exit vehicle

			  if not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 1) then
				TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
			  end

		  else
			  Citizen.Wait(500)
		  end
	  end
  end)
  
  -- Create blips
  Citizen.CreateThread(function()
  
	for k,v in pairs(Config.PoliceStations) do
  
	  local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)
  
	  SetBlipSprite (blip, v.Blip.Sprite)
	  SetBlipDisplay(blip, v.Blip.Display)
	  SetBlipScale  (blip, v.Blip.Scale)
	  SetBlipColour (blip, v.Blip.Colour)
	  SetBlipAsShortRange(blip, true)
  
	  BeginTextCommandSetBlipName("STRING")
	  AddTextComponentString(_U('map_blip'))
	  EndTextCommandSetBlipName(blip)
  
	end
  
  end)
  
  -- Display markers
  Citizen.CreateThread(function()
	while true do
  
	  Wait(0)
  
	  if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
  
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
  
		for k,v in pairs(Config.PoliceStations) do
  
		  for i=1, #v.Cloakrooms, 1 do
			if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.DrawDistance then
			  DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 64, 123, 174, 100, true, true, 2, true, false, false, false)
			end
		  end
  
		  for i=1, #v.Armories, 1 do
			if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.DrawDistance then
			  DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 64, 123, 174, 100, true, true, 2, true, false, false, false)
		   end
		  end
  
		  for i=1, #v.Vehicles, 1 do
			if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.DrawDistance then
			  DrawMarker(Config.MarkerTypeveh, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 64, 123, 174, 100, true, true, 2, true, false, false, false)
			end
		  end

		  for i=1, #v.Helicopters, 1 do
			if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config.DrawDistance then
			  DrawMarker(7, v.Helicopters[i].Spawner.x, v.Helicopters[i].Spawner.y, v.Helicopters[i].Spawner.z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 64, 123, 174, 100, true, true, 2, true, false, false, false)
			end
		  end
  
		  for i=1, #v.VehicleDeleters, 1 do
			if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
			  DrawMarker(Config.MarkerTypevehdel, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 64, 123, 174, 100, true, true, 2, true, false, false, false)
			end
		  end
  
		  if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then
  
			for i=1, #v.BossActions, 1 do
			  if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerTypeboss, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 64, 123, 174, 100, true, true, 2, true, false, false, false)
			  end
			end
  
		  end
  
		end
  
	  end
  
	end
  end)
  
  -- Enter / Exit marker events
  Citizen.CreateThread(function()
  
	while true do
  
	  Wait(0)
  
	  if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
  
		local playerPed      = PlayerPedId()
		local coords         = GetEntityCoords(playerPed)
		local isInMarker     = false
		local currentStation = nil
		local currentPart    = nil
		local currentPartNum = nil
  
		for k,v in pairs(Config.PoliceStations) do
  
		  for i=1, #v.Cloakrooms, 1 do
			if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'Cloakroom'
			  currentPartNum = i
			end
		  end
  
		  for i=1, #v.Armories, 1 do
			if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'Armory'
			  currentPartNum = i
			end
		  end
  
		  for i=1, #v.Vehicles, 1 do
  
			if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'VehicleSpawner'
			  currentPartNum = i
			end
  
			if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'VehicleSpawnPoint'
			  currentPartNum = i
			end
  
		  end
  
		  for i=1, #v.Helicopters, 1 do
  
			if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'HelicopterSpawner'
			  currentPartNum = i
			end
  
			if GetDistanceBetweenCoords(coords,  v.Helicopters[i].SpawnPoint.x,  v.Helicopters[i].SpawnPoint.y,  v.Helicopters[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'HelicopterSpawnPoint'
			  currentPartNum = i
			end
  
		  end
  
		  for i=1, #v.VehicleDeleters, 1 do
			if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'VehicleDeleter'
			  currentPartNum = i
			end
		  end
  
		  if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then
  
			for i=1, #v.BossActions, 1 do
			  if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'BossActions'
				currentPartNum = i
			  end
			end
  
		  end
  
		end
  
		local hasExited = false
  
		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
  
		  if
			(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
			(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
		  then
			TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			hasExited = true
		  end
  
		  HasAlreadyEnteredMarker = true
		  LastStation             = currentStation
		  LastPart                = currentPart
		  LastPartNum             = currentPartNum
  
		  TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end
  
		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
  
		  HasAlreadyEnteredMarker = false
  
		  TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end
  
	  end
  
	end
  end)
  
  -- Enter / Exit entity zone events
  Citizen.CreateThread(function()
  
	local trackedEntities = {
	  'prop_mp_cone_01',
	  'prop_roadcone02a',
	  'prop_mp_arrow_barrier_01',
	  'prop_mp_barrier_02b',
	  'prop_barrier_work05',
	  'p_ld_stinger_s',
	  'prop_boxpile_07d',
	  'hei_prop_cash_crate_half_full'
	}
  
	while true do
  
	  Citizen.Wait(1000)
  
	  local playerPed = PlayerPedId()
	  local coords    = GetEntityCoords(playerPed)
  
	  local closestDistance = -1
	  local closestEntity   = nil
  
	  for i=1, #trackedEntities, 1 do
  
		local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)
  
		if DoesEntityExist(object) then
  
		  local objCoords = GetEntityCoords(object)
		  local distance  = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  objCoords.x,  objCoords.y,  objCoords.z,  true)
  
		  if closestDistance == -1 or closestDistance > distance then
			closestDistance = distance
			closestEntity   = object
		  end
  
		end
  
	  end
  
	  if closestDistance ~= -1 and closestDistance <= 3.0 then
  
		if LastEntity ~= closestEntity then
		  TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
		  LastEntity = closestEntity
		end
  
	  else
  
		if LastEntity ~= nil then
		  TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
		  LastEntity = nil
		end
  
	  end
  
	end
  end)
  
  -- Key Controls
  Citizen.CreateThread(function()
	local time = 0

	  while true do
  
		  Citizen.Wait(1)
  
		  if CurrentAction ~= nil then
			  SetTextComponentFormat('STRING')
			  AddTextComponentString(CurrentActionMsg)
			  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
  
			  if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' then
  
				  if CurrentAction == 'menu_cloakroom' then
					  OpenCloakroomMenu()
				  elseif CurrentAction == 'menu_armory' then
					  if Config.MaxInService == -1 then
						  OpenArmoryMenu(CurrentActionData.station)
					  elseif playerInService then
						  OpenArmoryMenu(CurrentActionData.station)
					  else
						  ESX.ShowNotification(_U('service_not'))
					  end
				  elseif CurrentAction == 'menu_vehicle_spawner' then
					if callsign ~= nil then

						ESX.TriggerServerCallback('esx_policejob:checkForVehicle', function(DoesHaveVehicle)
							if not DoesHaveVehicle then
	
								OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
								
							else
								ESX.ShowNotification("~h~Vahed shoma dar hale hazer yek mashin darad")
							end
						end, callsign)				
					 
					else
						ESX.ShowNotification("~h~Shoma Callsign nadarid")
					end
				elseif CurrentAction == 'menu_helicopter_spawner' then
					if callsign ~= nil then

						ESX.TriggerServerCallback('esx_policejob:checkForVehicle', function(DoesHaveVehicle)
							if not DoesHaveVehicle then
								
								if PlayerData.divisions.police ~= nil and PlayerData.divisions.police.xray then 
									OpenHelicopterSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
								else
									ESX.ShowNotification("~h~Shoma ozv Division xray nistid")
								end
								
							else
								ESX.ShowNotification("~h~Vahed shoma dar hale hazer yek mashin darad")
							end
						end, callsign)				
					 
					else
						ESX.ShowNotification("~h~Shoma Callsign nadarid")
					end
				  elseif CurrentAction == 'delete_vehicle' then

					local ped = GetPlayerPed(-1)
					if IsPedInAnyVehicle(ped) then
						TriggerEvent("mythic_progbar:client:progress", {
							name = "police_repair",
							duration = 15000,
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
				
								local vehicle = GetVehiclePedIsUsing(ped)
								local model = GetEntityModel(vehicle)
							
								if PlayerData.divisions.police ~= nil and PlayerData.divisions.police.detective then
									SetVehicleFixed(vehicle)
									SetVehicleDirtLevel(vehicle, 0.0)
									SetVehicleFuelLevel(vehicle, 100.0)
								else
									if IsAllowedVehicle(exports["esx_vehiclecontrol"]:GetVehicles(PlayerData.job.name), model) then
										SetVehicleFixed(vehicle)
										SetVehicleDirtLevel(vehicle, 0.0)
										SetVehicleFuelLevel(vehicle, 100.0)
									else
										ESX.ShowNotification("~r~Shoma Savar mashin police nistid!")
									end
								end
								
							end
							
						end)
					else
						ESX.ShowNotification("Shoma savar hich vasile naghlieyi nistid!")
					end						

				  elseif CurrentAction == 'menu_boss_actions' then
					  ESX.UI.Menu.CloseAll()
					  TriggerEvent('esx_society:openBosirpixelsMenu', 'police', function(data, menu)
						  menu.close()
						  CurrentAction     = 'menu_boss_actions'
						  CurrentActionMsg  = _U('open_bossmenu')
						  CurrentActionData = {}
					  end, { wash = false }) -- disable washing money
				  elseif CurrentAction == 'remove_entity' then
					ESX.Game.DeleteObject(CurrentActionData.entity)
				  end
				  
				  CurrentAction = nil
			  end
		  end -- CurrentAction end
		  
		  if IsControlJustReleased(0, Keys['F6']) and not isDead and PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
			  if Config.MaxInService == -1 then
				  OpenPoliceActionsMenu()
			  elseif playerInService then
				  OpenPoliceActionsMenu()
			  else
				  ESX.ShowNotification(_U('service_not'))
			  end
		  end
		  
		  if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy then
			  ESX.ShowNotification(_U('impound_canceled'))
			  ESX.ClearTimeout(CurrentTask.Task)
			  ClearPedTasks(PlayerPedId())
			  
			  CurrentTask.Busy = false
		  end

		  if IsControlJustPressed(1, Keys['B']) and IsControlPressed(1, Keys['LEFTALT']) then

			if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == "government" or PlayerData.job.name == "doc" then
				
				if callsign ~= nil then

					if GetGameTimer() - time > 60000 then
						local ped = GetPlayerPed(-1)
	
						local backup = {
							identifier = callsign,
							coords = GetEntityCoords(ped),
							NetID = NetworkGetNetworkIdFromEntity(ped),
							type = "Backup"
						}
						TriggerServerEvent('3dme:shareDisplay', "Dastesho mibare be samte radio va dokme backup ro feshar mide", false)
		
						TriggerServerEvent("esx_policejob:addbackup", backup)
						time = GetGameTimer()
					else
						ESX.ShowNotification("~r~~h~Backup shoma roye cooldown ast")
					end
					
				else
					ESX.ShowNotification("~r~~h~Shoma callsign nadarid")
				end

			end
			
		  end

		  if IsControlJustPressed(1, Keys['E']) and IsControlPressed(1, Keys['LEFTALT']) then

			if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == "government" or PlayerData.job.name == "doc" then
				
			if callsign ~= nil then

					if GetGameTimer() - time > 60000 then
						local ped = GetPlayerPed(-1)

						local backup = {
							identifier = callsign,
							coords = GetEntityCoords(ped),
							NetID = NetworkGetNetworkIdFromEntity(ped),
							type = "Panic"
						}
		
						TriggerServerEvent("esx_policejob:addbackup", backup)
						TriggerServerEvent('3dme:shareDisplay', "Dastesho mibare be samte radio va dokme panic ro feshar mide", false)
						time = GetGameTimer()
					else
						ESX.ShowNotification("~r~~h~Panic shoma roye cooldown ast")
					end
					
				else
					ESX.ShowNotification("~r~~h~Shoma callsign nadarid")
				end
			end
		  end

		  if IsControlJustReleased(0, Keys['Y']) then
			TriggerEvent("esx_vehiclecontol:trigger")
		  end
	  end
  end)
  
  -- Create blip for colleagues
--   function createBlip(id, color, name)
-- 	  local ped = GetPlayerPed(id)
-- 	  local blip = GetBlipFromEntity(ped)
  
-- 	  if not DoesBlipExist(blip) then -- Add blip and create head display on player
-- 		  blip = AddBlipForEntity(ped)
-- 		  SetBlipSprite(blip, 1)
-- 		  ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
-- 		  SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
-- 		  SetBlipNameToPlayerName(blip, id) -- update blip name
-- 		  SetBlipScale(blip, 0.85) -- set scale
-- 		  SetBlipColour(blip, color)
-- 		  SetBlipAsShortRange(blip, true)

-- 		  BeginTextCommandSetBlipName("STRING")
-- 		  AddTextComponentString(name)
-- 		  EndTextCommandSetBlipName(blip)
		  
-- 		  table.insert(blipsCops, blip) -- add blip to array so we can remove it later
-- 	  end
--   end
  
--   RegisterNetEvent('esx_policejob:updateBlip')
--   AddEventHandler('esx_policejob:updateBlip', function()
	  
-- 	  -- Refresh all blips
-- 	  for k, existingBlip in pairs(blipsCops) do
-- 		  RemoveBlip(existingBlip)
-- 	  end
	  
-- 	  -- Clean the blip table
-- 	  blipsCops = {}
  
-- 	  -- Enable blip?
-- 	  if Config.MaxInService ~= -1 and not playerInService then
-- 		  return
-- 	  end
  
-- 	  if not Config.EnableJobBlip then
-- 		  return
-- 	  end
	  
-- 	  -- Is the player a cop? In that case show all the blips for other cops
-- 	  if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
-- 		  ESX.TriggerServerCallback('esx_society:getOnlirpixelinePlayers', function(players)
-- 			  for i=1, #players, 1 do

-- 				  local name = string.gsub(players[i].name, "_", " ")

-- 				  if players[i].job.name == 'police' then
-- 					  local id = GetPlayerFromServerId(players[i].source)
-- 					  if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
-- 						  createBlip(id, 38, name)
-- 					  end
-- 				  end

-- 				  if players[i].job.name == 'ambulance' then
-- 					local id = GetPlayerFromServerId(players[i].source)
-- 					if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
-- 						createBlip(id, 49, name)
-- 					end
-- 				  end

-- 				  if players[i].job.name == 'doc' then
-- 					local id = GetPlayerFromServerId(players[i].source)
-- 					if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
-- 						createBlip(id, 31, name)
-- 					end
-- 				  end

-- 			  end
-- 		  end)
-- 	  end
  
--   end)
  
  AddEventHandler('playerSpawned', function(spawn)
	  isDead = false
	  TriggerEvent('esx_policejob:unrestrain')
	  
	  if not hasAlreadyJoined then
		--   TriggerServerEvent('esx_policejob:spawned')
	  end
	  hasAlreadyJoined = true
  end)
  
  AddEventHandler('esx:onPlayerDeath', function(data)
	  isDead = true
  end)
  
  AddEventHandler('onResourceStop', function(resource)
	  if resource == GetCurrentResourceName() then
		  TriggerEvent('esx_policejob:unrestrain')
		  TriggerEvent('esx_phone:removeSpecialContact', 'police')
  
		  if Config.MaxInService ~= -1 then
			  TriggerServerEvent('esx_service:disableService', 'police')
		  end
  
		  if Config.EnableHandcuffTimer and HandcuffTimer.Active then
			  ESX.ClearTimeout(HandcuffTimer.Task)
		  end
	  end
  end)
  
  -- handcuff timer, unrestrain the player after an certain amount of time
  function StartHandcuffTimer()
	  if Config.EnableHandcuffTimer and HandcuffTimer.Active then
		  ESX.ClearTimeout(HandcuffTimer.Task)
	  end
  
	  HandcuffTimer.Active = true
  
	  HandcuffTimer.Task = ESX.SetTimeout(Config.HandcuffTimer, function()
		  ESX.ShowNotification(_U('unrestrained_timer'))
		  TriggerEvent('esx_policejob:unrestrain')
		  HandcuffTimer.Active = false
	  end)
  end
  
  -- TODO
  --   - return to garage if owned
  --   - message owner that his vehicle has been impounded
--   function ImpoundVehicle(vehicle)
-- 	  --local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
-- 	  ESX.Game.DeleteVehicle(vehicle) 
-- 	  ESX.ShowNotification(_U('impound_successful'))
-- 	  CurrentTask.Busy = false
--   end
  
  if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') and (GetGameTimer() - GUI.Time) > 150 then
	  OpenPoliceActionsMenu()
	  GUI.Time = GetGameTimer()
  end
  
  function JailPlayer(player)
	  ESX.UI.Menu.Open(
		  'dialog', GetCurrentResourceName(), 'jail_menu',
		  {
			  title = _U('jail_menu_info'),
		  },
	  function (data2, menu)
		  local jailTime = tonumber(data2.value)
		  if jailTime == nil then
			  ESX.ShowNotification(_U('invalid_amount'))
		  else
			  TriggerServerEvent("esx_jairpixelil:sendToJail", player, jailTime * 60)
			  menu.close()
		  end
	  end,
	  function (data2, menu)
		  menu.close()
	  end
	  )
  end
  ---------------------------------------------------------------------------------------------------------
  ----------------------------------------------- Detective -----------------------------------------------
  ---------------------------------------------------------------------------------------------------------
  RegisterCommand('changeoutfit', function(source)
	 if PlayerData.job.name == "police" then
		if PlayerData.divisions["police"] and PlayerData.divisions.police.detective then

			TriggerEvent('skinchanger:getSkin', function(skin)
				--  male
						if skin.sex == 0 then
							local clothesSkin = {
							['bproof_1'] = 0, ['bproof_2'] = 0,
							['tshirt_1'] = 42, ['tshirt_2'] = 0,
							['torso_1'] = 95, ['torso_2'] = 1,
							['pants_1'] = 28, ['pants_2'] = 0,
							['decals_1'] = 0, ['decals_2'] = 0,
							['arms'] = 11, 
							['helmet_1'] = -1,
							['mask_1'] = 0, ['mask_2'] = 0,
							['shoes_1'] = 10, ['shoes_2'] = 0,
							['chain_1'] = 6, ['chain_2'] = 0,
							['glasses_1'] = 5, ['glasses_2'] = 0
							}
							TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				--  female
						elseif skin.sex == 1 then
							ESX.ShowNotification("~r~~h~Bara dokhtar outfit nadarim :|")
						end
				end)

		else
			ESX.ShowNotification("~h~Shoma ozv division Detective nistid")
		end
	 else
	 	ESX.ShowNotification("~h~Shoma police nistid")
	 end
  end, false)

  RegisterCommand('vest', function(source)
	if PlayerData.job.name == "police" then
	   if PlayerData.divisions["police"] and PlayerData.divisions.police.detective then

		TriggerEvent('skinchanger:getSkin', function(skin)
            --  male
                   if skin.sex == 0 then
                    if skin.tshirt_1 == 42 and skin.tshirt_2 == 0 and skin.torso_1 == 95 and skin.torso_2 == 1 and skin.pants_1 == 28 and skin.pants_2 == 0 and skin.decals_1 == 0 and skin.decals_2 == 0 and skin.arms == 11 and skin.helmet_1 == -1 and skin.shoes_1 == 10 and skin.shoes_2 == 0 and skin.chain_1 == 6 and skin.chain_2 == 0 and skin.glasses_1 == 5 and skin.glasses_2 == 0 then
                        if skin.bproof_1 == 12 and skin.bproof_2 == 4 then
                     local clothesSkin = {
                        ['bproof_1'] = 0, ['bproof_2'] = 0
                     }
                     TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                     ESX.ShowNotification("~g~~h~Shoma Jelighe khod ra daravardid") 
                    else
                        local clothesSkin = {
                            ['bproof_1'] = 12, ['bproof_2'] = 4
                         }
                         TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                         ESX.ShowNotification("~g~~h~Shoma jelighe poshidid")
                    end
                    else
                        ESX.ShowNotification("~r~~h~Shoma lebas detective nadarid!")
                    end
            --  female
                   elseif skin.sex == 1 then
                    if skin.bproof_1 == 11 and skin.bproof_2 == 4 then
                        local clothesSkin = {
                           ['bproof_1'] = 0, ['bproof_2'] = 0
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        ESX.ShowNotification("~g~~h~Shoma Jelighe khod ra daravardid") 
                       else
                           local clothesSkin = {
                               ['bproof_1'] = 7, ['bproof_2'] = 0
                            }
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                            ESX.ShowNotification("~g~~h~Shoma jelighe poshidid")
                       end 
                    end
            end)
			   
	   else
		   ESX.ShowNotification("~h~Shoma ozv division Detective nistid")
	   end
	else
		ESX.ShowNotification("~h~Shoma police nistid")
	end
 end, false)

 RegisterCommand('mask', function(source)
	if PlayerData.job.name == "police" then
	   if PlayerData.divisions["police"] and PlayerData.divisions.police.detective then

		TriggerEvent('skinchanger:getSkin', function(skin)
            --  male
                   if skin.sex == 0 then
                    if skin.tshirt_1 == 42 and skin.tshirt_2 == 0 and skin.torso_1 == 95 and skin.torso_2 == 1 and skin.pants_1 == 28 and skin.pants_2 == 0 and skin.decals_1 == 0 and skin.decals_2 == 0 and skin.arms == 11 and skin.helmet_1 == -1 and skin.shoes_1 == 10 and skin.shoes_2 == 0 and skin.chain_1 == 6 and skin.chain_2 == 0 and skin.glasses_1 == 5 and skin.glasses_2 == 0 then
                        if skin.mask_1 == 0 then
                     local clothesSkin = {
                        ['mask_1'] = math.random(1, 147), ['mask_2'] = 0
                     }
                     TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                     ESX.ShowNotification("~g~~h~Shoma az mask estefade kardid") 
                    else
                        local clothesSkin = {
                            ['mask_1'] = 0, ['mask_2'] = 0
                         }
                         TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                         ESX.ShowNotification("~g~~h~Shoma mask ra daravardid")
                    end
                    else
                        ESX.ShowNotification("~r~~h~Shoma lebas detective nadarid!")
                    end
            --  female
                   elseif skin.sex == 1 then
                    if skin.mask_1 == 0 then
                        local clothesSkin = {
                           ['mask_1'] = math.random(1, 147), ['mask_2'] = 0
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        ESX.ShowNotification("~g~~h~Shoma az mask estefade kardid") 
                       else
                           local clothesSkin = {
                               ['mask_1'] = 0, ['mask_2'] = 0
                            }
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                            ESX.ShowNotification("~g~~h~Shoma mask ra daravardid")
                       end
                    end
            end)

	   else
		   ESX.ShowNotification("~h~Shoma ozv division Detective nistid")
	   end
	else
		ESX.ShowNotification("~h~Shoma police nistid")
	end
 end, false)


 RegisterCommand('changecolor', function(source)
	if PlayerData.job.name == "police" then
	   if PlayerData.divisions["police"] and PlayerData.divisions.police.detective then

		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
		if vehicle then
			
			if IsNearRepairs() then
				local props = {
					color1 = math.random(0, 159),
					color2 = math.random(0, 159),
				}
			
				ESX.Game.SetVehicleProperties(vehicle, props)
				SetVehicleDirtLevel(vehicle, 0.0)
			else
				ESX.ShowNotification("~h~SHoma nazdik hich yek az repair point ha nistid")
			end

		else
			ESX.ShowNotification("~h~Shoma savar hich mashini nistid")
		end

	   else
		   ESX.ShowNotification("~h~Shoma ozv division Detective nistid")
	   end
	else
		ESX.ShowNotification("~h~Shoma police nistid")
	end
 end, false)

  ---------------------------------------------------------------------------------------------------------
  ----------------------------------------------- Functions -----------------------------------------------
  ---------------------------------------------------------------------------------------------------------
  
  function loadanimdict(dictname)
	  if not HasAnimDictLoaded(dictname) then
		  RequestAnimDict(dictname) 
		  while not HasAnimDictLoaded(dictname) do 
			  Citizen.Wait(1)
		  end
	  end
  end
  
  function contains(table, val)
	  for i = 1, #table do
		  if table[i].name == val then
			  return true
		  end
	  end
	  return false
  end

  function IsAllowedVehicle(table, val)
	for i = 1, #table do
		if table[i] == val then
			return true
		end
	end
	return false
  end

  function IsNearRepairs()
	  local coords = GetEntityCoords(GetPlayerPed(-1))
	  for k,v in pairs(Config.PoliceStations) do
		for i=1, #v.VehicleDeleters, 1 do
			if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < 5 then
			  return true
			end
		  end
	  end
	  return false
  end

  function IsAnyPedInVehicle(veh)
	return (GetVehicleNumberOfPassengers(veh)+(IsVehicleSeatFree(veh,-1) and 0 or 1))>0
  end

  function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end