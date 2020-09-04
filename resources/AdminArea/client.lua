ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

---------------------------------
--- Admin Area, Made by FAXES ---
---------------------------------

--- Config ---
misTxtDis = "~r~~h~Dar yek mantaghe az map RP pause ast lotfan vared mantaghe nashavid." -- Use colors from: https://gist.github.com/leonardosnt/061e691a1c6c0597d633

--- Code ---
local blips = {}

function missionTextDisplay(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

RegisterNetEvent('Fax:AdminAreaSet')
AddEventHandler("Fax:AdminAreaSet", function(blip, s)
    if s ~= nil then
        src = s
        coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
    else
        coords = blip.coords
    end
    
    if not blips[blip.index] then
        blips[blip.index] = {}
    end

    if not givenCoords then
        TriggerServerEvent('AdminArea:setCoords', tonumber(blip.index), coords)
    end

    blips[blip.index]["blip"] = AddBlipForCoord(coords.x, coords.y, coords.z)
    blips[blip.index]["radius"] = AddBlipForRadius(coords.x, coords.y, coords.z, blip.radius)
    SetBlipSprite(blips[blip.index].blip, blip.id)
    SetBlipAsShortRange(blips[blip.index].blip, true)
    SetBlipColour(blips[blip.index].blip, blip.color)
    SetBlipScale(blips[blip.index].blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blip.name)
    EndTextCommandSetBlipName(blips[blip.index].blip)

    
    SetBlipAlpha(blips[blip.index]["radius"], 80)
    SetBlipColour(blips[blip.index]["radius"], blip.color)

    missionTextDisplay(misTxtDis, 8000)
end)

RegisterNetEvent('Fax:AdminAreaClear')
AddEventHandler("Fax:AdminAreaClear", function(blipID)
    if blips[blipID] then
        RemoveBlip(blips[blipID].blip)
        RemoveBlip(blips[blipID].radius)
        blips[blipID] = nil
        missionTextDisplay("RP Dar mantaghe ~o~Admin Area(" .. blipID .. ")~r~ unpause ~w~shod!", 5000)
    else
        print("There was a issue with removing blip: " .. tostring(blipID))
    end
end)