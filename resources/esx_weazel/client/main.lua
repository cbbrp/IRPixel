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
local LastEntity              = nil
local Blips                   = {}

local isInMarker              = false
local isInPublicMarker        = false
local hintIsShowed            = false
local hintToDisplay           = "no hint to display"

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

RegisterNetEvent("esx_weazel:notify")
AddEventHandler("esx_weazel:notify",function(message)

  if IsJobTrue() and PlayerData.job.grade >= 1 then
    TriggerEvent('chat:addMessage', {color = {255, 0, 0}, multiline = true ,args = {"[Weazel News]", message}})
  end

end)

-- Create blips
Citizen.CreateThread(function()

    local blipMarker = Config.Blips.Blip
    local blipCoord = AddBlipForCoord(blipMarker.Pos.x, blipMarker.Pos.y, blipMarker.Pos.z)

    SetBlipSprite (blipCoord, blipMarker.Sprite)
    SetBlipDisplay(blipCoord, blipMarker.Display)
    SetBlipScale  (blipCoord, blipMarker.Scale)
    SetBlipColour (blipCoord, blipMarker.Colour)
    SetBlipAsShortRange(blipCoord, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Weazel News")
    EndTextCommandSetBlipName(blipCoord)


end)

function SetVehicleMaxMods(vehicle, colors)

  local props = {
    modEngine       =   3,
		modBrakes       =   2,
		windowTint      =   -1,
		modArmor        =   4,
		modTransmission =   2,
		modSuspension   =   -1,
		modTurbo        =   false,
		color1 = colors.a,
		color2 = colors.b,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'weazel' then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end

function IsGradeBoss()
    if PlayerData ~= nil then
        local IsGradeBoss = false
        if PlayerData.job.grade_name == 'boss' then
            IsGradeBoss = true
        end
        return IsGradeBoss
    end
end

function cleanPlayer(playerPed)
  ClearPedBloodDamage(playerPed)
  ResetPedVisibleDamage(playerPed)
  ClearPedLastWeaponDamage(playerPed)
  ResetPedMovementClipset(playerPed, 0)
end

function setClipset(playerPed, clip)
  RequestAnimSet(clip)
  while not HasAnimSetLoaded(clip) do
    Citizen.Wait(0)
  end
  SetPedMovementClipset(playerPed, clip, true)
end

function setUniform(job, playerPed)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
      if Config.Uniforms[job].male ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
      if job ~= 'citizen_wear' and job ~= 'journaliste_outfit' then
        setClipset(playerPed, "MOVE_M@POSH@")
      end
    else
      if Config.Uniforms[job].female ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
      if job ~= 'citizen_wear' and job ~= 'journaliste_outfit' then
        setClipset(playerPed, "MOVE_F@POSH@")
      end
    end

  end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function OpenCloakroomMenu()

  local playerPed = GetPlayerPed(-1)

  local elements = {
    { label = "Lebas Shakhsi",     value = 'citizen_wear'},
  }

  table.insert(elements, {label = "Lebas Kar", value = PlayerData.job.grade_name ..  "_outfit"})
	
	ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = "Komod Lebas",
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      isBarman = false
      cleanPlayer(playerPed)

      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
          TriggerEvent('skinchanger:loadSkin', skin)
        end)
      end


        setUniform(data.current.value, playerPed)

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid komod baz she"
      CurrentActionData = {}

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid komod baz she"
      CurrentActionData = {}
    end
  )
end

function OpenVehicleSpawnerMenu()

  local vehicles = Config.Zones.Vehicles

  ESX.UI.Menu.CloseAll()

    local elements = {}

    for i=1, #Config.AuthorizedVehicles, 1 do
      local vehicle = Config.AuthorizedVehicles[i]
      table.insert(elements, {label = vehicle.label, value = vehicle.name, colors = vehicle.colors})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = "List vasayel naghlie",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles.SpawnPoint.x,  vehicles.SpawnPoint.y,  vehicles.SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          local playerPed = GetPlayerPed(-1)

            ESX.Game.SpawnVehicle(model, {
              x = vehicles.SpawnPoint.x,
              y = vehicles.SpawnPoint.y,
              z = vehicles.SpawnPoint.z
            }, vehicles.Heading, function(vehicle)
              TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1) -- teleport into vehicle
              SetVehicleMaxMods(vehicle, data.current.colors)
              SetVehicleDirtLevel(vehicle, 0)
              SetVehicleLivery(vehicle, 3)
              local netId = NetworkGetNetworkIdFromEntity(vehicle)
              TriggerEvent('esx_vehiclecontol:changePointed', netId)

                Citizen.CreateThread(function()
                  Citizen.Wait(2000)
                  SetVehicleFuelLevel(vehicle, 100.0)
                end)

            end)

        else
          ESX.ShowNotification("~h~Mahal spawn vasile naghlie masdod shode ast!")
        end

      end,

      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta garage baz she"
        CurrentActionData = {}

      end)

end

function OpenHelicopterMenu()

  local vehicles = Config.Zones.Helicopters

  ESX.UI.Menu.CloseAll()

    local elements = {}

    table.insert(elements, {label = "News Helicopter", value = "frogger", colors = {a = 0, b = 0}})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'helicopter_spawner',
      {
        title    = "List vasayel naghlie",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles.SpawnPoint.x,  vehicles.SpawnPoint.y,  vehicles.SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          local playerPed = GetPlayerPed(-1)

            ESX.Game.SpawnVehicle(model, {
              x = vehicles.SpawnPoint.x,
              y = vehicles.SpawnPoint.y,
              z = vehicles.SpawnPoint.z
            }, vehicles.Heading, function(vehicle)
              TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1) -- teleport into vehicle
              SetVehicleMaxMods(vehicle, data.current.colors)
              SetVehicleDirtLevel(vehicle, 0)
              local netId = NetworkGetNetworkIdFromEntity(vehicle)
              TriggerEvent('esx_vehiclecontol:changePointed', netId)

                Citizen.CreateThread(function()
                  Citizen.Wait(2000)
                  SetVehicleFuelLevel(vehicle, 100.0)
                end)

            end)

        else
          ESX.ShowNotification("~h~Mahal spawn vasile naghlie masdod shode ast!")
        end

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'helicopter_spawner'
        CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta garage baz she"
        CurrentActionData = {}

      end)

end

AddEventHandler('esx_weazel:hasEnteredMarker', function(zone)
 
    if zone == 'BossActions' and IsGradeBoss() then
      CurrentAction     = 'menu_boss_actions'
      CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid jahat modiriat shoghl"
      CurrentActionData = {}	
    elseif zone == 'Cloakrooms' then
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid komod baz she"
      CurrentActionData = {}
    elseif zone == 'Vehicles' then
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta garage baz she"
        CurrentActionData = {}
    elseif zone == 'VehicleDeleters' or zone == 'VehicleDeleters2' then

      local playerPed = GetPlayerPed(-1)

      if IsPedInAnyVehicle(playerPed,  false) then

        local vehicle = GetVehiclePedIsIn(playerPed,  false)

        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro bezanid ta vasile naghlie park she"
        CurrentActionData = {vehicle = vehicle}
      end

    elseif zone == "Helicopters" then
      CurrentAction     = 'spawn_helicopter'
      CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta garage baz she"
      CurrentActionData = {}
    end
	
end)

AddEventHandler('esx_weazel:hasExitedMarker', function(zone)

    CurrentAction = nil
    ESX.UI.Menu.CloseAll()

end)

-- Display markers
Citizen.CreateThread(function()
    while true do

        Wait(0)
        if IsJobTrue() then

            local coords = GetEntityCoords(GetPlayerPed(-1))

            for k,v in pairs(Config.Zones) do
                if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, true, true, 2, true, false, false, false)
                end
            end

        end

    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do

        Wait(0)
        if IsJobTrue() then

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
                TriggerEvent('esx_weazel:hasEnteredMarker', currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_weazel:hasExitedMarker', LastZone)
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

      if IsControlJustReleased(0,  Keys['E']) and IsJobTrue() then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        elseif CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu()
        elseif CurrentAction == 'spawn_helicopter' then
          OpenHelicopterMenu()
        elseif CurrentAction == 'delete_vehicle' then
          local model = GetEntityModel(CurrentActionData.vehicle)
          if IsAllowedVehicle(exports["esx_vehiclecontrol"]:GetVehicles(PlayerData.job.name), model) then
            ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
          else
            ESX.ShowNotification("~r~Shoma Savar mashin weazel news nistid!")
          end
        elseif CurrentAction == 'remove_entity' then
					ESX.Game.DeleteObject(CurrentActionData.entity)
        elseif CurrentAction == 'menu_boss_actions' and IsGradeBoss() then
          ESX.UI.Menu.CloseAll()
          TriggerEvent('esx_society:openBosirpixelsMenu', 'weazel', function(data, menu)
            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}
          end, {wash = false})
        end

        CurrentAction = nil

      end

    end

    if IsControlJustReleased(0, Keys['F6']) and IsJobTrue() then
       ObjectSpawner()
    end


  end
end)

AddEventHandler('esx_weazel:hasEnteredEntityZone', function(entity)
  
    local playerPed = PlayerPedId()
    
    if IsJobTrue() and not IsPedInAnyVehicle(playerPed, false) then
      CurrentAction     = 'remove_entity'
      CurrentActionMsg  = 'press ~INPUT_CONTEXT~ to delete the object'
      CurrentActionData = {entity = entity}
    end
  
end)
  
  AddEventHandler('esx_weazel:hasExitedEntityZone', function(entity)
  
    if CurrentAction == 'remove_entity' then
      CurrentAction = nil
    end
  
  end)

 -- Enter / Exit entity zone events
Citizen.CreateThread(function()
  
    local trackedEntities = {
      'prop_studio_light_01',
      'prop_studio_light_02',
      'prop_studio_light_03',
      'prop_scrim_02',
      'prop_tv_cam_02',
      'prop_kino_light_03',
      'prop_tv_stand_01',
      'prop_generator_01a',
      'prop_dolly_01',
      'prop_dolly_02',
      'xm_prop_base_tripod_lampb'
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
        TriggerEvent('esx_weazel:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end
    
      else
    
      if LastEntity ~= nil then
        TriggerEvent('esx_weazel:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end
    
      end
    
    end
end)

function ObjectSpawner()
  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'object_spawner',
    {
      title    = "Vasayel film bardari",
      align    = 'top-left',
      elements = {
        {label = "Light 1",		value = 'prop_studio_light_01'},
        {label = "Light 2",		value = 'prop_studio_light_02'},
        {label = "Light 3",		value = 'prop_studio_light_03'},
        {label = "Light spliter", value = 'prop_kino_light_03'},
        {label = "Light stand", value = 'xm_prop_base_tripod_lampb'},
        {label = "Crane Stand 1", value = 'prop_dolly_01'},
        {label = "Crane Stand 2", value = 'prop_dolly_02'},
        {label = "Genrator", value = 'prop_generator_01a'},
        {label = "Board",		value = 'prop_scrim_02'},
        {label = "Camera Stand",		value = 'prop_tv_cam_02'},
        {label = "TV Stand",	value = 'prop_tv_stand_01'}
      }
    }, function(data2, menu2)
      local model     = data2.current.value
      local playerPed = PlayerPedId()
      local coords    = GetEntityCoords(playerPed)
      local forward   = GetEntityForwardVector(playerPed)
      local x, y, z   = table.unpack(coords + forward * 1.0)

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

function IsAllowedVehicle(table, val)
	for i = 1, #table do
		if table[i] == val then
			return true
		end
	end
	return false
end