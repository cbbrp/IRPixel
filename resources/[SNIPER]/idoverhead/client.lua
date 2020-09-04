eESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local disPlayerNames = 20
local own = true
local ownID = PlayerId()
playersInfo = {}
-- hidePlayers = {}
labels  = {}

RegisterNetEvent('esx_idoverhead:modifydistance')
AddEventHandler('esx_idoverhead:modifydistance', function(distance)

    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
            disPlayerNames = distance
        end
    end)

end)

RegisterNetEvent('esx_idoverhead:toggleOwn')
AddEventHandler('esx_idoverhead:toggleOwn', function()
    if own then
        own = false
    else
        own = true
    end
end)

-- RegisterNetEvent('esx_idoverhead:updateTags')
-- AddEventHandler('esx_idoverhead:updateTags', function(hidep)
--     hidePlayers = hidep
-- end)

RegisterNetEvent('esx_idoverhead:updateLabels')
AddEventHandler('esx_idoverhead:updateLabels', function(labelsp)
    labels = labelsp
end)

RegisterNetEvent('esx_idoverhead:changeLabelHideStatus')
AddEventHandler('esx_idoverhead:changeLabelHideStatus', function(id, status)

    if id == nil then return end
    if type(status) ~= "boolean" then return end

    if labels[id] then
        if labels[id].info then
          labels[id].info["hide"] = status
        end
    end

end)

-- RegisterNetEvent('esx_idoverhead:modifyHides')
-- AddEventHandler('esx_idoverhead:modifyHides', function(type, id)

--     if id == nil then return end
--     local id = id
--     if type == "add" then
--         if not hidePlayers[id] then
--             hidePlayers[id] = id
--         end
--     elseif type == "remove" then
--         if hidePlayers[id] then
--             hidePlayers[id] = nil
--         end
--     end

-- end)

RegisterNetEvent('esx_idoverhead:modifyLabel')
AddEventHandler('esx_idoverhead:modifyLabel', function(id, label)

   local id = id
   local label = label

    if DoesTagExist(id, label.badge) then
      RemoveTag(id, label.badge)
    end

    if not DoesTagExist(id, label.badge) then
        if not labels[id] then
            labels[id] = {}
        end
        table.insert(labels[id], label)
    else
        print("Error regarding adding tag because already exist!")
    end
   

end)

Citizen.CreateThread(function()
    Wait(50)
    while true do
        for k, v in pairs(playersInfo) do
            if GetPlayerPed(k) ~= GetPlayerPed(-1) then
                if v.info.distance < disPlayerNames and v.info.cansee and v.info.hide then
                    x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(k), true))
                    if NetworkIsPlayerTalking(k) then
                        DrawText3D(x2, y2, z2+1, GetPlayerServerId(k), 247,124,24)
                    else
                        DrawText3D(x2, y2, z2+1, GetPlayerServerId(k), 255,255,255)
                    end

                    if v.labels ~= nil then
                        for n, j in pairs(v.labels) do
                            if j.toggle == false then
                                if not j.badge then
                                    DrawText3D(x2, y2, z2 + j.height, "~r~" .. j.display .. "~w~ " .. v.info.name , 247,124,24)
                                else
                                    DrawText3D(x2, y2, z2 + j.height, j.display, 247,124,24)
                                end
                            end
                        end
                    end
                   
                end  
            end

            if own and ownID == k then
                if v.labels ~= nil then
                    if v.info.hide then

                        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

                        for n, j in pairs(v.labels) do
                            if j.toggle == false then
                                if not j.badge then
                                    DrawText3D(x, y, z + j.height, "~r~" .. j.display .. "~w~ " .. v.info.name , 247,124,24)
                                end
                            end
                        end

                    end
                end

            end

        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        for _, player in ipairs(GetActivePlayers()) do

            local coords = GetEntityCoords(GetPlayerPed(-1))
            local coords2 = GetEntityCoords(GetPlayerPed(player))
            local distance = math.floor(Vdist2(coords.x, coords.y, coords.z, coords2.x, coords2.y, coords2.z))
            local cansee = HasEntityClearLosToEntity(GetPlayerPed(-1), GetPlayerPed(player), 17)
            
            playersInfo[player] = {}
            playersInfo[player]["info"] = {}
            playersInfo[player].info["distance"] = distance
            playersInfo[player].info["cansee"] = cansee
            playersInfo[player].info["name"] = GetPlayerName(player)
            playersInfo[player].info["hide"] = IsEntityVisible(GetPlayerPed(player))
            playersInfo[player]["labels"] = getplayerTags(player)
        
        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()

    local id = PlayerId()
    TriggerServerEvent('esx_idoverhead:checkTimePlay', id)
    
end)


-- RegisterCommand("vanishww", function(source, args)
--     local id = PlayerId()
--     if args[1] == "add" then
--         TriggerServerEvent('esx_idoverhead:modifyHideOnes', "add", id)
--     elseif args[1] == "remove" then
--         TriggerServerEvent('esx_idoverhead:modifyHideOnes', "remove", id)
--     end   
-- end, false)

-- function isPlayerVanish(player)
--    for k,v in pairs(hidePlayers) do
--        if player == k then
--         return true
--        end
--    end

--    return false
-- end

function getplayerTags(player)

    if labels[player] then
        return labels[player]
    end

    return nil

end

function DoesTagExist(player, badge)
    if labels[player] == nil then return false end
    for k,v in pairs(labels[player]) do
        if v.badge == badge then
            return true
        end
    end

    return false
end


function RemoveTag(player, badge)
    for k,v in pairs(labels[player]) do
        if v.badge == badge then
            labels[player][k] = nil
        end
    end
end

function DrawText3D(x,y,z, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
-- AddEventHandler('playerSpawned', function()
--     if not hasAlreadyJoined then
--         local id = PlayerId()
--         TriggerClientEvent('esx_idoverhead:modifyLabel', id)
--     end
--     hasAlreadyJoined = true
-- end)