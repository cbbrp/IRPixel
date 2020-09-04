ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }
local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', }
local drawInfo = nil
local drawInfo2 = nil
local isLoaded = false
local isGpsOn = false
local newBie = false
local playerID = GetPlayerServerId(PlayerId())
local hide = false
local timestamp = 0
local rgb = {r = 64, g = 64, b = 64}

-- Give text a slight nudge to help center the text.
local direction_offset = {
  ["N"] = 0.008,
  ["NE"] = 0.004,
  ["E"] = 0.010,
  ["SE"] = 0.004,
  ["S"] = 0.008,
  ["SW"] = 0,
  ["W"] = 0.006,
  ["NW"] = 0,
}
local text_offset = 0.290

RegisterNetEvent("streetlabel:timestamp")
AddEventHandler("streetlabel:timestamp", function(time)

	timestamp = tostring(time)
	
end)

RegisterNetEvent("streetlabel:changeLoadStatus")
AddEventHandler("streetlabel:changeLoadStatus", function(status)

  if type(status) ~= "boolean" then
    print("esx_streetlabel: can't insert non boolean value")
    return
  end

	isLoaded = status
	
end)

RegisterNetEvent("streetlabel:changeGpsStatus")
AddEventHandler("streetlabel:changeGpsStatus", function(status)

  if type(status) ~= "boolean" then
    print("esx_streetlabel: can't insert non boolean value")
    return
  end

	isGpsOn = status
	
end)

RegisterNetEvent("streetlabel:modifyHide")
AddEventHandler("streetlabel:modifyHide", function(status)

  hide = status
  
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()

  ESX.TriggerServerCallback("esx_idoverhead:retrievePlayTime", function(isNewbie)

      newBie = isNewbie
		
	end)
    
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())

    local var1_name = GetStreetNameFromHashKey(var1)
    local var2_name = GetStreetNameFromHashKey(var2)

    local zone_name = GetNameOfZone(pos.x, pos.y, pos.z)
    local current_zone = zones[zone_name]

    for k,v in pairs(directions)do
      direction = GetEntityHeading(GetPlayerPed(-1))
      if(math.abs(direction - k) < 22.5)then
        direction = v
        break;
      end
    end

    if(var1_name and zone_name)then
      if(zones[zone_name] and tostring(var1_name))then
        drawInfo = {
          [1] = {x = x-0.345, y = y+0.66, width = 1.0, height = 1.5, scale = 1.4, text = " | ", r = border_r, g = border_g, b = border_b, a = border_a},
          [2] = {x = x-0.310, y = y+0.66, width = 1.0, height = 1.5, scale = 1.4, text = " | ", r = border_r, g = border_g, b = border_b, a = border_a},
          [3] = {x = x-0.330 + direction_offset[direction], y = y + 0.42, width = 1.0, height = 1.0, scale = 1.0, text = direction, r = dir_r, g = dir_g, b = dir_b, a = dir_a}
        }
        -- draw = drawTxt(x-0.345, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
        -- draw = drawTxt(x-0.310, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
        -- draw = drawTxt(x-0.330 + direction_offset[direction], y + 0.42, 1.0, 1.0, 1.0, direction, dir_r, dir_g, dir_b, dir_a)
        if tostring(var2_name) == "" then
          drawInfo2 = {
            [1] = {x = x - text_offset, y = y + 0.45, width = 1.0, height = 1.0, scale = 0.45, text = current_zone, r = town_r, g = town_g, b = town_b, a = town_a}
          }
          -- d = drawTxt2(x - text_offset, y + 0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
        else
          drawInfo2 = {
            [1] = {x = x - text_offset, y = y + 0.45, width = 1.0, height = 1.0, scale = 0.45, text = tostring(var2_name) .. ", " .. zones[zone_name], r = str_around_r, g = str_around_g, b = str_around_b, a = str_around_a}
          }
          -- draw2 = drawTxt2(x - text_offset, y + 0.45, 1.0,1.0,0.45, tostring(var2_name) .. ", " .. zones[zone_name], str_around_r, str_around_g, str_around_b, str_around_a)
        end
        drawInfo2[2] = {x = x - text_offset, y = y + 0.42, width = 1.0, height = 1.0, scale = 0.55, text = tostring(var1_name), r = curr_street_r, g = curr_street_g, b = curr_street_b, a = curr_street_a}
      end
    end
  end
end)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if drawInfo ~= nil and isGpsOn and isLoaded then

      if not hide then

        for k,v in pairs(drawInfo) do
          drawTxt(v.x, v.y, v.width, v.height, v.scale, v.text, v.r, v.g, v.b, v.a)
        end
  
        for k,v in pairs(drawInfo2) do
          drawTxt2(v.x, v.y, v.width, v.height, v.scale, v.text, v.r, v.g, v.b, v.a)
        end

      end
      

    end

    if isLoaded then

      if not hide then

        if isGpsOn then
          drawTxt(x-0.335, y+0.39, 1.0,1.0,0.45, "~y~ID: ~w~" .. playerID .. " | " .. timestamp  , town_r, town_g, town_b, town_a)
  
          if newBie then
            drawTxt(x-0.335, y+0.36, 1.0,1.0,0.45, "[Newbie]" , rgb.r, rgb.g, rgb.b, town_a)
          end
  
        else
          drawTxt(x-0.335, y+0.43, 1.0,1.0,0.45, "~y~ID: ~w~" .. playerID .. " | " .. timestamp  , town_r, town_g, town_b, town_a)
  
          if newBie then
            drawTxt(x-0.335, y+0.40, 1.0,1.0,0.45, "[Newbie]" , rgb.r, rgb.g, rgb.b, town_a)
          end
          
        end
  
        rgb = RGBRainbow(1)
        
      end
      
    end

  end
end)

function RGBRainbow(frequency)
  local result = {}
  local curtime = GetGameTimer() / 1000

  result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
  result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
  result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

  return result
end

function drawTxt(x, y, width, height, scale, text, r, g, b, a)
  SetTextFont(4)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x - width/2, y - height/2 + 0.005)
end

function drawTxt2(x, y, width, height, scale, text, r, g, b, a)
  SetTextFont(6)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x - width/2, y - height/2 + 0.005)
end