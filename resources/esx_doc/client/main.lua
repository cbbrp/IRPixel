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
  local hasAlreadyJoined        = false
  local blipsCops               = {}
  local isDead                  = false
  local CurrentTask             = {}
  local callsign                = nil
  ESX                           = nil
	
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
  
			  if job == 'vest' then
				  SetPedArmour(GetPlayerPed(-1), 100)
			  end
  
		  else
  
			  if Config.Uniforms[job].female ~= nil then
				  TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			  else
				  ESX.ShowNotification(_U('no_outfit'))
			  end
  
			  if job == 'vest' then
				  SetPedArmour(GetPlayerPed(-1), 100)
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

		table.insert(elements, {label = "Correctional Outfit", value = grade .. '_wear'})

		table.insert(elements, {label = "Bullet Wear", value = 'vest'})
  
	  ESX.UI.Menu.CloseAll()
  
	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	  {
		  title    = _U('cloakroom'),
		  align    = 'top-left',
		  elements = elements
	  }, function(data, menu)
  
		  cleanPlayer(playerPed)
  
		  if data.current.value == 'citizen_wear' then
		
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
  
		  end
  
  
		  if

			data.current.value == grade .. '_wear' or
			data.current.value == "vest"

		  then
			  setUniform(data.current.value, playerPed)
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
		{label = _U('put_weapon'),     value = 'put_weapon'},
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

	  for i=1, #Config.DocStations[station].AuthorizedWeapons, 1 do
		local weapon = Config.DocStations[station].AuthorizedWeapons[i]
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
  
	  local vehicles = Config.DocStations[station].Vehicles
	  ESX.UI.Menu.CloseAll()
  
		  local elements = {}
		
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
			  local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x, vehicles[partNum].SpawnPoint.y, vehicles[partNum].SpawnPoint.z, 3.0, 0, 71)
  
			  if not DoesEntityExist(vehicle) then
  
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
  
  function OpenPoliceActionsMenu()
	  ESX.UI.Menu.CloseAll()
  
	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'doc_actions',
	  {
		  title    = 'DOC',
		  align    = 'top-left',
		  elements = {
			  {label = _U('citizen_interaction'),	value = 'citizen_interaction'},
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
			  }

		  
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
						  OpenIdentityCardMenu(closestPlayer)
					  elseif action == 'body_search' then
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
					  end
  
				  else
					  ESX.ShowNotification(_U('no_players_nearby'))
				  end
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
	  
	  
		  end
	  
		  local elements = {
			  {label = nameLabel, value = nil},
			  {label = jobLabel,  value = nil},
		  }

	  
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
  
  function OpenGetWeaponMenu()
  
	ESX.TriggerServerCallback('esx_doc:getArmoryWeapons', function(weapons)
  
	  local elements = {}
	  local sharedWeapons = Config.AuthorizedWeapons.Shared
	  local authorizedWeapons = Config.AuthorizedWeapons[PlayerData.job.grade_name]
	  local IsSwat = ESX.GetPlayerData()['IsSwat']
	  
	  for i=1, #weapons, 1 do
		if weapons[i].count > 0 then

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
  
		  ESX.TriggerServerCallback('esx_doc:removeArmoryWeapon', function()
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
  
		ESX.TriggerServerCallback('esx_doc:addArmoryWeapon', function()
		  OpenPutWeaponMenu()
		end, data.current.value, true)
  
	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  
  end
  
  function OpenBuyWeaponsMenu(station)
  
	ESX.TriggerServerCallback('esx_doc:getArmoryWeapons', function(weapons)
  
	  local elements = {}
  
	  for i=1, #Config.DocStations[station].AuthorizedWeapons, 1 do
  
		local weapon = Config.DocStations[station].AuthorizedWeapons[i]
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
  
		  ESX.TriggerServerCallback('esx_doc:buy', function(hasEnoughMoney)
  
			if hasEnoughMoney then
			  ESX.TriggerServerCallback('esx_doc:addArmoryWeapon', function()
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
  
	ESX.TriggerServerCallback('esx_doc:getStockItems', function(items)
  
  
	  local elements = {}
  
	  for i=1, #items, 1 do
		table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
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
				TriggerServerEvent('esx_doc:getStockItem', itemName, count)
  
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
  
	ESX.TriggerServerCallback('esx_doc:getPlayerInventory', function(inventory)
  
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
				TriggerServerEvent('esx_doc:putStockItems', itemName, count)
  
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
	--   TriggerServerEvent('esx_doc:forceBlip')
  end)
  
  RegisterNetEvent('esx:setcallsign')
  AddEventHandler('esx:setcallsign', function(sign)
	if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "government" or PlayerData.job.name == "doc" then
		callsign = sign
	end
  end)  

  RegisterNetEvent('esx_doc:alarm')
  AddEventHandler('esx_doc:alarm', function(type)
	while not PrepareAlarm("PRISON_ALARMS") do
		Citizen.Wait(100)
	end
	
	if type == "start" then
		StartAlarm("PRISON_ALARMS", 0)
	elseif type == "stop" then
		StopAlarm("PRISON_ALARMS", 1)
	end
  end)  
  
  
  AddEventHandler('esx_doc:hasEnteredMarker', function(station, part, partNum)
  
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
  
  AddEventHandler('esx_doc:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
  end)
  
  AddEventHandler('esx_doc:hasEnteredEntityZone', function(entity)
  
	local playerPed = PlayerPedId()
  
	if PlayerData.job ~= nil and PlayerData.job.name == 'doc' and not IsPedInAnyVehicle(playerPed, false) then
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
  
  AddEventHandler('esx_doc:hasExitedEntityZone', function(entity)
  
	if CurrentAction == 'remove_entity' then
	  CurrentAction = nil
	end
  
  end)
  
  -- Create blips
  Citizen.CreateThread(function()
  
	for k,v in pairs(Config.DocStations) do
  
	  local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)
  
	  SetBlipSprite (blip, v.Blip.Sprite)
	  SetBlipDisplay(blip, v.Blip.Display)
	  SetBlipScale  (blip, v.Blip.Scale)
	  SetBlipColour (blip, v.Blip.Colour)
	  SetBlipAsShortRange(blip, true)
  
	  BeginTextCommandSetBlipName("STRING")
	  AddTextComponentString("Bolingbroke Penitentiary")
	  EndTextCommandSetBlipName(blip)
  
	end
  
  end)
  
  -- Display markers
  Citizen.CreateThread(function()
	while true do
  
	  Wait(0)
  
	  if PlayerData.job ~= nil and PlayerData.job.name == 'doc' then
  
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
  
		for k,v in pairs(Config.DocStations) do
  
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
  
		  for i=1, #v.VehicleDeleters, 1 do
			if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
			  DrawMarker(Config.MarkerTypevehdel, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 64, 123, 174, 100, true, true, 2, true, false, false, false)
			end
		  end
  
		  if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'doc' and PlayerData.job.grade_name == 'boss' then
  
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
  
	  if PlayerData.job ~= nil and PlayerData.job.name == 'doc' then
  
		local playerPed      = PlayerPedId()
		local coords         = GetEntityCoords(playerPed)
		local isInMarker     = false
		local currentStation = nil
		local currentPart    = nil
		local currentPartNum = nil
  
		for k,v in pairs(Config.DocStations) do
  
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
  
		  for i=1, #v.VehicleDeleters, 1 do
			if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'VehicleDeleter'
			  currentPartNum = i
			end
		  end
  
		  if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'doc' and PlayerData.job.grade_name == 'boss' then
  
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
			TriggerEvent('esx_doc:hasExitedMarker', LastStation, LastPart, LastPartNum)
			hasExited = true
		  end
  
		  HasAlreadyEnteredMarker = true
		  LastStation             = currentStation
		  LastPart                = currentPart
		  LastPartNum             = currentPartNum
  
		  TriggerEvent('esx_doc:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end
  
		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
  
		  HasAlreadyEnteredMarker = false
  
		  TriggerEvent('esx_doc:hasExitedMarker', LastStation, LastPart, LastPartNum)
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
  
			  if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'doc' then
  
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
				  elseif CurrentAction == 'delete_vehicle' then
					local ped = GetPlayerPed(-1)
					local vehicle = GetVehiclePedIsUsing(ped)
					local model = GetEntityModel(vehicle)
				
				
					if IsAllowedVehicle(exports["esx_vehiclecontrol"]:GetVehicles(PlayerData.job.name), model) then
						SetVehicleFixed(vehicle)
						SetVehicleDirtLevel(vehicle, 0.0)
						SetVehicleFuelLevel(vehicle, 100.0)
					else
						ESX.ShowNotification("~r~Shoma Savar mashin doc nistid!")
					end
				

				  elseif CurrentAction == 'menu_boss_actions' then
					  ESX.UI.Menu.CloseAll()
					  TriggerEvent('esx_society:openBosirpixelsMenu', 'doc', function(data, menu)
						  menu.close()
						  CurrentAction     = 'menu_boss_actions'
						  CurrentActionMsg  = _U('open_bossmenu')
						  CurrentActionData = {}
					  end, { wash = false }) -- disable washing money
				  end
				  
				  CurrentAction = nil
			  end
		  end -- CurrentAction end
		  
		  if IsControlJustReleased(0, Keys['F6']) and not isDead and PlayerData.job ~= nil and PlayerData.job.name == 'doc' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'doc_actions') then
			OpenPoliceActionsMenu()
		  end

	  end
  end)
  
  AddEventHandler('playerSpawned', function(spawn)
	  isDead = false
	  
	  if not hasAlreadyJoined then
		-- while not PlayerData.job do
		-- 	Citizen.Wait(100)
		-- end

		-- if PlayerData.job.name == "doc" or PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
		-- 	TriggerServerEvent('esx_doc:spawned')
		-- end 
	  end
	  hasAlreadyJoined = true
  end)
  
  AddEventHandler('esx:onPlayerDeath', function(data)
	  isDead = true
  end)

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

  function IsAnyPedInVehicle(veh)
	return (GetVehicleNumberOfPassengers(veh)+(IsVehicleSeatFree(veh,-1) and 0 or 1))>0
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