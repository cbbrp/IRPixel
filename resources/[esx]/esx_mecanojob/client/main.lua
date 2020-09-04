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
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local OnJob                   = false
local CurrentlyTowedVehicle   = nil
local Blips                   = {}
local blipsMechanic           = {}
local hasAlreadyJoined        = false
local NPCOnJob                = false
local NPCTargetTowable        = nil
local NPCTargetTowableZone    = nil
local NPCHasSpawnedTowable    = false
local NPCLastCancel           = GetGameTimer() - 5 * 60000
local NPCHasBeenNextToTowable = false
local NPCTargetDeleterZone    = false
local IsDead                  = false
local IsBusy                  = false

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

function OpenMecanoActionsMenu()

  local elements = {
    {label = _U('vehicle_list'),   value = 'vehicle_list'},
    {label = _U('work_wear'),      value = 'cloakroom'},
    {label = _U('civ_wear'),       value = 'cloakroom2'},
    {label = _U('deposit_stock'),  value = 'put_stock'},
    {label = _U('withdraw_stock'), value = 'get_stock'}
  }
  if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
    table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mecano_actions',
    {
      title    = _U('mechanic'),
      align    = 'top-left',
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'vehicle_list' then


            local elements = {
              {label = _U('flat_bed'),  value = 'flatbed'},
              {label = _U('towtruck'),  value = 'towtruck'},
              {label = _U('tow_truck'), value = 'towtruck2'}
            }

            if Config.EnablePlayerManagement and PlayerData.job ~= nil and
              (PlayerData.job.grade_name == 'boss') then
              table.insert(elements, {label = 'SlamVan', value = 'slamvan3'})
            end

            ESX.UI.Menu.CloseAll()

            ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'spawn_vehicle',
              {
                title    = _U('service_vehicle'),
                align    = 'top-left',
                elements = elements
              },
              function(data, menu)
                ESX.Game.SpawnVehicle(data.current.value, Config.VehicleSpawnPoint[CurrentActionData].Pos, Config.VehicleSpawnPoint[CurrentActionData].Heading, function(vehicle)
                  local playerPed = GetPlayerPed(-1)
                  TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

                  local netId = NetworkGetNetworkIdFromEntity(vehicle)
                  TriggerEvent('esx_vehiclecontol:changePointed', netId)

                  Citizen.CreateThread(function()
                    Citizen.Wait(2000)
                    SetVehicleFuelLevel(vehicle, 100.0)
                  end)
                  
                end)
                  
                menu.close()
              end,
              function(data, menu)
                menu.close()
                OpenMecanoActionsMenu()
              end
            )

          end


      if data.current.value == 'cloakroom' then
        menu.close()
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
            else
                TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
            end

        end)
      end

      if data.current.value == 'cloakroom2' then
        menu.close()
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

            TriggerEvent('skinchanger:loadSkin', skin)

        end)
      end

      if data.current.value == 'put_stock' then
        OpenPutStocksMenu()
      end

      if data.current.value == 'get_stock' then
        OpenGetStocksMenu()
      end

      if data.current.value == 'boss_actions' then
        TriggerEvent('esx_society:openBosirpixelsMenu', 'mecano', function(data, menu)
          menu.close()
        end)
      end

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'mecano_actions_menu'
      CurrentActionMsg  = _U('open_actions')
      CurrentActionData = {}
    end
  )
end

function OpenMobileMecanoActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_mecano_actions',
    {
      title    = _U('mechanic'),
      align    = 'top-left',
      elements = {
        {label = _U('billing'),       value = 'billing'},
        -- {label = _U('hijack'),        value = 'hijack_vehicle'},
        {label = _U('repair'),        value = 'fix_vehicle'},
        {label = _U('clean'),         value = 'clean_vehicle'},
        {label = _U('imp_veh'),       value = 'del_vehicle'},
        {label = _U('flat_bed'),      value = 'dep_vehicle'},
        {label = _U('place_objects'), value = 'object_spawner'}
      }
    },
	function(data, menu)
      if IsBusy then return end

      if data.current.value == 'billing' then
        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'billing',
          {
            title = _U('invoice_amount')
          },
          function(data, menu)
            local amount = tonumber(data.value)
            if amount == nil or amount < 0 then
              ESX.ShowNotification(_U('amount_invalid'))
            else
              
              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
              if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification(_U('no_players_nearby'))
			  else
				menu.close()
                TriggerServerEvent('esx_billing:send2Bill', GetPlayerServerId(closestPlayer), 'society_mecano', _U('mechanic'), amount)
              end
            end
          end,
        function(data, menu)
          menu.close()
        end
        )
      end

    --   if data.current.value == 'hijack_vehicle' then

		-- local playerPed = GetPlayerPed(-1)
		-- local vehicle   = ESX.Game.GetVehicleInDirection()
		-- local coords    = GetEntityCoords(playerPed)

		-- if IsPedSittingInAnyVehicle(playerPed) then
		-- 	ESX.ShowNotification(_U('inside_vehicle'))
		-- 	return
		-- end

		-- if DoesEntityExist(vehicle) then
		-- 	IsBusy = true
		-- 	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
		-- 	Citizen.CreateThread(function()
		-- 		Citizen.Wait(10000)

		-- 		SetVehicleDoorsLocked(vehicle, 1)
		-- 		SetVehicleDoorsLockedForAllPlayers(vehicle, false)
		-- 		ClearPedTasksImmediately(playerPed)

		-- 		ESX.ShowNotification(_U('vehicle_unlocked'))
		-- 		IsBusy = false
		-- 	end)
		-- else
		-- 	ESX.ShowNotification(_U('no_vehicle_nearby'))
		-- end

	if data.current.value == 'fix_vehicle' then

      local vehicle = ESX.Game.GetVehicleInDirection(4)
      if vehicle == 0 then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
        return
      end
      exports["esx_vehiclecontrol"]:RepairVehicle(vehicle)

	elseif data.current.value == 'clean_vehicle' then

      local vehicle = ESX.Game.GetVehicleInDirection(4)
      if vehicle == 0 then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
        return
      end
      exports["esx_vehiclecontrol"]:CleanVehicle(vehicle)

  elseif data.current.value == 'del_vehicle' then

      local vehicle = ESX.Game.GetVehicleInDirection(4)
      if vehicle == 0 then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
        return
      end
      exports["esx_vehiclecontrol"]:DeleteVehicle(vehicle)

  end

      if data.current.value == 'dep_vehicle' then

        local playerped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(playerped, true)

        local towmodel = GetHashKey('flatbed')
        local isVehicleTow = IsVehicleModel(vehicle, towmodel)

        if isVehicleTow then
          local targetVehicle = ESX.Game.GetVehicleInDirection()

          if CurrentlyTowedVehicle == nil then
            if targetVehicle ~= 0 then
              if not IsPedInAnyVehicle(playerped, true) then
                if vehicle ~= targetVehicle then

                  NetworkRequestControlOfEntity(targetVehicle)
                  local timeout = 2000
                  while timeout > 0 and not NetworkHasControlOfEntity(targetVehicle) do
                    Wait(100)
                    timeout = timeout - 100
                  end

                  AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                  CurrentlyTowedVehicle = targetVehicle
                  ESX.ShowNotification(_U('vehicle_success_attached'))

                else
                  ESX.ShowNotification(_U('cant_attach_own_tt'))
                end
              end
            else
              ESX.ShowNotification(_U('no_veh_att'))
            end
          else

            NetworkRequestControlOfEntity(CurrentlyTowedVehicle)

            local timeout = 2000
            while timeout > 0 and not NetworkHasControlOfEntity(CurrentlyTowedVehicle) do
              Wait(100)
              timeout = timeout - 100
            end

            AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
            DetachEntity(CurrentlyTowedVehicle, true, true)


            CurrentlyTowedVehicle = nil

            ESX.ShowNotification(_U('veh_det_succ'))
          end
        else
          ESX.ShowNotification(_U('imp_flatbed'))
        end
      end

      if data.current.value == 'object_spawner' then
		local playerPed = GetPlayerPed(-1)

		if IsPedSittingInAnyVehicle(playerPed) then
			ESX.ShowNotification(_U('inside_vehicle'))
			return
		end

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'mobile_mecano_actions_spawn',
          {
            title    = _U('objects'),
            align    = 'top-left',
            elements = {
              {label = _U('roadcone'),     value = 'prop_roadcone02a'},
              {label = _U('toolbox'), value = 'prop_toolchest_01'},
            },
          },
          function(data2, menu2)

            local model     = data2.current.value
            local coords    = GetEntityCoords(playerPed)
            local forward   = GetEntityForwardVector(playerPed)
            local x, y, z   = table.unpack(coords + forward * 1.0)

            if model == 'prop_roadcone02a' then
              z = z - 2.0
            elseif model == 'prop_toolchest_01' then
              z = z - 2.0
            end

            ESX.Game.SpawnObject(model, {
              x = x,
              y = y,
              z = z
            }, function(obj)
              SetEntityHeading(obj, GetEntityHeading(playerPed))
              PlaceObjectOnGroundProperly(obj)
            end)

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

    end,
  function(data, menu)
    menu.close()
  end
  )
end

function OpenGetStocksMenu()
  ESX.TriggerServerCallback('esx_mecanojob:getStockItems', function(items)
    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('mechanic_stock'),
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
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              TriggerServerEvent('esx_mecanojob:getStockItem', itemName, count)

              Citizen.Wait(1000)
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

ESX.TriggerServerCallback('esx_mecanojob:getPlayerInventory', function(inventory)

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
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              TriggerServerEvent('esx_mecanojob:putStockItems', itemName, count)

              Citizen.Wait(1000)
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


RegisterNetEvent('esx_mecanojob:onHijack')
AddEventHandler('esx_mecanojob:onHijack', function()
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    local crochete = math.random(100)
    local alarm    = math.random(100)

    if DoesEntityExist(vehicle) then
      if alarm <= 33 then
        SetVehicleAlarm(vehicle, true)
        StartVehicleAlarm(vehicle)
      end
      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
      Citizen.CreateThread(function()
        Citizen.Wait(10000)
        if crochete <= 66 then
          SetVehicleDoorsLocked(vehicle, 1)
          SetVehicleDoorsLockedForAllPlayers(vehicle, false)
          ClearPedTasksImmediately(playerPed)
          ESX.ShowNotification(_U('veh_unlocked'))
        else
          ESX.ShowNotification(_U('hijack_failed'))
          ClearPedTasksImmediately(playerPed)
        end
      end)
    end

  end
end)

RegisterNetEvent('esx_mecanojob:onCarokit')
AddEventHandler('esx_mecanojob:onCarokit', function()
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
      Citizen.CreateThread(function()
        Citizen.Wait(10000)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        ClearPedTasksImmediately(playerPed)
        ESX.ShowNotification(_U('body_repaired'))
      end)
    end
  end
end)

RegisterNetEvent('esx_mecanojob:onFixkit')
AddEventHandler('esx_mecanojob:onFixkit', function()
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
      TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
      Citizen.CreateThread(function()
        Citizen.Wait(20000)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        ClearPedTasksImmediately(playerPed)
        ESX.ShowNotification(_U('veh_repaired'))
      end)
    end
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job

  -- Citizen.Wait(5000)
	-- TriggerServerEvent('esx_mecanojob:forceBlip')
end)

AddEventHandler('esx_mecanojob:hasEnteredMarker', function(zone)

  if zone == 'MecanoActions' or zone == 'MecanoActions2' then
    CurrentAction     = 'mecano_actions_menu'
    CurrentActionMsg  = _U('open_actions')

    if zone == 'MecanoActions' then
      CurrentActionData = 1
    elseif zone == 'MecanoActions2' then
      CurrentActionData = 2
    end

  elseif zone == 'VehicleDeleter' or zone == 'VehicleDeleter2' then
  
      local ped = GetPlayerPed(-1)
      if IsPedInAnyVehicle(ped) then
  
        local vehicle = GetVehiclePedIsIn(ped)
  
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('veh_stored')
        CurrentActionData = {vehicle = vehicle}

      end

  end


end)

AddEventHandler('esx_mecanojob:hasExitedMarker', function(zone)
  CurrentAction = nil
  CurrentActionData = nil
  ESX.UI.Menu.CloseAll()
end)

AddEventHandler('esx_mecanojob:hasEnteredEntityZone', function(entity)

  local playerPed = GetPlayerPed(-1)

  if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' and not IsPedInAnyVehicle(playerPed, false) and not CurrentAction then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = _U('press_remove_obj')
    CurrentActionData = {entity = entity}
  end

end)

AddEventHandler('esx_mecanojob:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
  local specialContact = {
    name       = _U('mechanic'),
    number     = 'mecano',
    base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAAA4BJREFUWIXtll9oU3cUx7/nJA02aSSlFouWMnXVB0ejU3wcRteHjv1puoc9rA978cUi2IqgRYWIZkMwrahUGfgkFMEZUdg6C+u21z1o3fbgqigVi7NzUtNcmsac40Npltz7S3rvUHzxQODec87vfD+/e0/O/QFv7Q0beV3QeXqmgV74/7H7fZJvuLwv8q/Xeux1gUrNBpN/nmtavdaqDqBK8VT2RDyV2VHmF1lvLERSBtCVynzYmcp+A9WqT9kcVKX4gHUehF0CEVY+1jYTTIwvt7YSIQnCTvsSUYz6gX5uDt7MP7KOKuQAgxmqQ+neUA+I1B1AiXi5X6ZAvKrabirmVYFwAMRT2RMg7F9SyKspvk73hfrtbkMPyIhA5FVqi0iBiEZMMQdAui/8E4GPv0oAJkpc6Q3+6goAAGpWBxNQmTLFmgL3jSJNgQdGv4pMts2EKm7ICJB/aG0xNdz74VEk13UYCx1/twPR8JjDT8wttyLZtkoAxSb8ZDCz0gdfKxWkFURf2v9qTYH7SK7rQIDn0P3nA0ehixvfwZwE0X9vBE/mW8piohhl1WH18UQBhYnre8N/L8b8xQvlx4ACbB4NnzaeRYDnKm0EALCMLXy84hwuTCXL/ExoB1E7qcK/8NCLIq5HcTT0i6u8TYbXUM1cAyyveVq8Xls7XhYrvY/4n3gC8C+dsmAzL1YUiyfWxvHzsy/w/dNd+KjhW2yvv/RfXr7x9QDcmo1he2RBiCCI1Q8jVj9szPNixVfgz+UiIGyDSrcoRu2J16d3I6e1VYvNSQjXpnucAcEPUOkGYZs/l4uUhowt/3kqu1UIv9n90fAY9jT3YBlbRvFTD4fw++wHjhiTRL/bG75t0jI2ITcHb5om4Xgmhv57xpGOg3d/NIqryOR7z+r+MC6qBJB/ZB2t9Om1D5lFm843G/3E3HI7Yh1xDRAfzLQr5EClBf/HBHK462TG2J0OABXeyWDPZ8VqxmBWYscpyghwtTd4EKpDTjCZdCNmzFM9k+4LHXIFACJN94Z6FiFEpKDQw9HndWsEuhnADVMhAUaYJBp9XrcGQKJ4qFE9k+6r2+MG3k5N8VQ22TVglbX2ZwOzX2VvNKr91zmY6S7N6zqZicVT2WNLyVSehESaBhxnOALfMeYX+K/S2yv7wmMAlvwyuR7FxQUyf0fgc/jztfkJr7XeGgC8BJJgWNV8ImT+AAAAAElFTkSuQmCC'
  }
  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Create Blipss
Citizen.CreateThread(function()
  for i,v in ipairs(Config.Blips) do
    local blip = AddBlipForCoord(v.x, v.y, v.z)
    SetBlipSprite (blip, 643)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.9)
    SetBlipColour (blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('mechanic'))
    EndTextCommandSetBlipName(blip)
  end
end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then

      local coords, letSleep = GetEntityCoords(PlayerPedId()), true

      for k,v in pairs(Config.Zones) do
        if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
          DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, true, false, false, false)
          letSleep = false
        end
      end

      if letSleep then
				Citizen.Wait(500)
      end

    else
			Citizen.Wait(500)
    end
    
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
      local coords      = GetEntityCoords(GetPlayerPed(-1))
      local isInMarker  = false
      local currentZone = nil
      for k,v in pairs(Config.Zones) do
        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
          isInMarker  = true
          currentZone = k
        end
      end
      if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
        HasAlreadyEnteredMarker = true
        LastZone                = currentZone
        TriggerEvent('esx_mecanojob:hasEnteredMarker', currentZone)
      end
      if not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('esx_mecanojob:hasExitedMarker', LastZone)
      end
    end
  end
end)

Citizen.CreateThread(function()

  local trackedEntities = {
      'prop_roadcone02a',
      'prop_toolchest_01'
  }

  while true do

    Citizen.Wait(1000)

    local playerPed = GetPlayerPed(-1)
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
        TriggerEvent('esx_mecanojob:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end

    else

      if LastEntity ~= nil then
        TriggerEvent('esx_mecanojob:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end

    end

  end
end)

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if CurrentAction ~= nil then

          SetTextComponentFormat('STRING')
          AddTextComponentString(CurrentActionMsg)
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)

          if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then

            if CurrentAction == 'mecano_actions_menu' then
                OpenMecanoActionsMenu()
            elseif CurrentAction == 'delete_vehicle' then

              local model = GetEntityModel(CurrentActionData.vehicle) 
              if IsAllowedVehicle(exports["esx_vehiclecontrol"]:GetVehicles(PlayerData.job.name), model)  then
                ESX.Game.DeleteVehicle(CurrentActionData.vehicle) 
              else
                ESX.ShowNotification("In mashin, mashin mechanici nist")
              end

            elseif CurrentAction == 'remove_entity' then
              ESX.Game.DeleteObject(CurrentActionData.entity)
            end
                
            
            CurrentAction = nil
          end
        end

        if IsControlJustReleased(0, Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
          OpenMobileMecanoActionsMenu()
        end

  end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
  isDead = false
  
  -- if not hasAlreadyJoined then
  --   TriggerServerEvent('esx_mecanoJob:spawned')
  -- end
  hasAlreadyJoined = true
end)

function IsAllowedVehicle(table, val)
	for i = 1, #table do
		if table[i] == val then
			return true
		end
	end
	return false
end
  -- Create blip for colleagues
  -- function createBlip(id, name)
	--   local ped = GetPlayerPed(id)
	--   local blip = GetBlipFromEntity(ped)
  
	--   if not DoesBlipExist(blip) then -- Add blip and create head display on player
	-- 	  blip = AddBlipForEntity(ped)
	-- 	  SetBlipSprite(blip, 1)
	-- 	  ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
	-- 	  SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
	-- 	  SetBlipNameToPlayerName(blip, id) -- update blip name
  --     SetBlipScale(blip, 0.85) -- set scale
  --     SetBlipColour(blip, 25)
  --     SetBlipAsShortRange(blip, true)
      
  --     BeginTextCommandSetBlipName("STRING")
  --     AddTextComponentString(name)
  --     EndTextCommandSetBlipName(blip)
		  
	-- 	  table.insert(blipsMechanic, blip) -- add blip to array so we can remove it later
	--   end
  -- end
  
  -- RegisterNetEvent('esx_mecanoJob:updateBlip')
  -- AddEventHandler('esx_mecanoJob:updateBlip', function()
	--   -- Refresh all blips
	--   for k, existingBlip in pairs(blipsMechanic) do
	-- 	  RemoveBlip(existingBlip)
	--   end
	  
	--   -- Clean the blip table
	--   blipsMechanic = {}
    
	--   if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
	-- 	  ESX.TriggerServerCallback('esx_society:getOnlirpixelinePlayers', function(players)
  --       for i=1, #players, 1 do

  --         local name
  --         if players[i].name then
  --           name = string.gsub(players[i].name, "_", " ")
  --         else
  --           name = GetPlayerName(GetPlayerFromServerId(GetPlayerServerId(PlayerPedId())))
  --         end
          

	-- 			  if players[i].job.name == nil or players[i].job.name == 'mecano' then
	-- 				  local id = GetPlayerFromServerId(players[i].source)
	-- 				  if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
	-- 					  createBlip(id, name)
	-- 				  end
	-- 			  end
	-- 		  end
	-- 	  end)
	--   end
  
  -- end)

---------------------------------------------------------------------------------------------------------
--NB : gestion des menu
---------------------------------------------------------------------------------------------------------

RegisterNetEvent('NB:openMenuMecano')
AddEventHandler('NB:openMenuMecano', function()
	OpenMobileMecanoActionsMenu()
end)