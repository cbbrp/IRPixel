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
local AdminPerks = false
local ShowID = false
local muted = false
local first = false
local time = 0
local disPlayerNames = 50
local event = nil
local ForceToVisible = false
local owned = false
local currentTags = {}
local playerDistances = {}
local playerinfo = {}

Citizen.CreateThread(function()

		while ESX == nil do
			TriggerEvent("esx:getSharedObject",function(obj)
					ESX = obj
                end)
                
			Citizen.Wait(0)
            PlayerData = ESX.GetPlayerData()

            if first then
                ESX.SetPlayerData('aduty',0)
                first = false
            end
            
        end
        
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded",function(xPlayer)

        PlayerData = xPlayer
        TriggerEvent('chat:addSuggestion', '/deattach', 'jahat bardashtan component haye aslahe', {
            { name="Type", help="(silencer, eclip, dclip, flashlight, grip, all)" }
        })
        
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(job)

        PlayerData.job = job
        
end)

RegisterNetEvent("OnDutyHandler")
AddEventHandler("OnDutyHandler",function()

    ESX.SetPlayerData('aduty',1)
    -- adminperks()
    -- ShowPlayerNames()
    
    TriggerServerEvent('DiscordBot:ToDiscord', 'duty', GetPlayerName(PlayerId()), 'OnDuty shod','user', true, source, false)

end)

RegisterNetEvent("OffDutyHandler")
AddEventHandler("OffDutyHandler",function()

        -- ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        --     local isMale = skin.sex == 0

        --     TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
        --         ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        --             TriggerEvent('skinchanger:loadSkin', skin)
        --         end)
        --     end)

        -- end)

        AdminPerks = false
        ShowID = false
        ESX.SetPlayerData('aduty',0)
        -- adminperks()
        -- ShowPlayerNames()

        TriggerServerEvent('DiscordBot:ToDiscord', 'duty', GetPlayerName(PlayerId()), 'OffDuty shod','user', true, source, false)

end)

RegisterNetEvent("OffDutyHandlerForJail")
AddEventHandler("OffDutyHandlerForJail",function()

    ESX.SetPlayerData('aduty',0)
    TriggerEvent("OffDutyHandler")
	TriggerEvent('aduty:removeSuggestions')
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"[SYSTEM]", "^0Shoma ^1OffDuty ^0Shodid!"}
        })
    TriggerServerEvent('aduty:changeDutyStatus', source)

end)

RegisterNetEvent("resetpedHandler")
AddEventHandler("resetpedHandler",function(skin)

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        local isMale = skin.sex == 0
        exports.esx_checker:changeWhiteList(true)

        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()

            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
                
                Citizen.CreateThread(function()
                    Citizen.Wait(250)
                    exports.esx_checker:changeWhiteList(false)
                end)

            end)
            
        end)

    end)

end)

RegisterNetEvent("aduty:pedHandler")
AddEventHandler("aduty:pedHandler",function(skin)

    print("this is just a debug")
    Citizen.CreateThread(function()
    local model = GetHashKey(skin)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    SetPlayerModel(PlayerId(), model)
    end)

end)

RegisterNetEvent("armorHandler")
AddEventHandler("armorHandler",function(armor)

    local ped = GetPlayerPed(-1)
    SetPedArmour(ped, armor) 

end)

RegisterNetEvent("aduty:vehiclelicenseHandler")
AddEventHandler("aduty:vehiclelicenseHandler",function(licenseplate)

    local player = GetPlayerPed(-1)
    if (IsPedSittingInAnyVehicle(player)) then
        
        local vehicle = GetVehiclePedIsIn(player, true)
        SetVehicleNumberPlateText(vehicle, licenseplate)
        ESX.ShowNotification("~g~Shomare pelak be: ~o~" .. licenseplate .. "~g~ taghir kard")

    else
        ESX.ShowNotification("~r~~h~Shoma baraye estefade az in command bayad dakhel mashin bashid")
    end

end)

RegisterNetEvent("aduty:setMuteStatus")
AddEventHandler("aduty:setMuteStatus", function(status)
  
  muted = status
  MutePlayer()

end)

RegisterNetEvent("aduty:forceStatus")
AddEventHandler("aduty:forceStatus", function(status)
  
  ForceToVisible = status
  print(ForceToVisible)
  visibility()

end)

RegisterNetEvent("aduty:refuel")
AddEventHandler("aduty:refuel", function()
  
   local ped = GetPlayerPed(-1)

   if IsPedInAnyVehicle(ped) then

        local vehicle = GetVehiclePedIsIn(ped)
        SetVehicleFuelLevel(vehicle, 100.0)

   else

      TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma baraye estefade az in command bayad dakhel mashin bashid!")

   end

end)

RegisterNetEvent("aduty:vanish")
AddEventHandler("aduty:vanish", function()
  
   vanish = not vanish
   local ped = GetPlayerPed(-1)

    if vanish then -- activé
    local id = PlayerId()
    -- TriggerServerEvent('esx_idoverhead:modifyHideOnes', "add", id)
    TriggerServerEvent('esx_idoverhead:changeLabelHideStatus', id, true)
    exports.esx_checker:SetVisible(false)
    ESX.ShowNotification("Character shoma ba movafaghiat ~r~Gheyb ~w~shod")
    else
    local id = PlayerId()
    -- TriggerServerEvent('esx_idoverhead:modifyHideOnes', "remove", id)
    TriggerServerEvent('esx_idoverhead:changeLabelHideStatus', id, false)
    exports.esx_checker:SetVisible(true)
    ESX.ShowNotification("Character shoma ba movafaghiat ~g~Zaher ~w~shod")
    end

end)

RegisterNetEvent("aduty:visibleForce")
AddEventHandler("aduty:visibleForce", function()
  
    exports.esx_checker:SetVisible(true)

end)

-- RegisterNetEvent("aduty:changeShowStatus")
-- AddEventHandler("aduty:changeShowStatus", function()
  
--     if ShowID then

--         ShowID = false
--         -- ShowPlayerNames()
--         TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma halat didan player ha ra ^1Khamosh ^0kardid!")
    
--     else
    
--         ShowID = true
--         -- ShowPlayerNames()
--         TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma halat didan player ha ra ^2Roshan ^0kardid!")

--     end

-- end)

RegisterNetEvent('aduty:tag')
AddEventHandler('aduty:tag',function(own)
    owned = own
end)


RegisterNetEvent('aduty:setEventCoords')
AddEventHandler('aduty:setEventCoords', function()
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            if coords ~= nil then
                TriggerServerEvent('aduty:setEventCoords', coords)
            else
                print("Theere was a problem with getting coords")
            end
        end

    end)
end)

RegisterNetEvent('aduty:tpEvent')
AddEventHandler('aduty:tpEvent', function()
    ESX.TriggerServerCallback('esx_aduty:getEventCoords', function(coords)

        if coords ~= "nothing" then
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)

            while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                RequestCollisionAtCoord(coords.x, coords.y, coords.z)
                Citizen.Wait(0)
            end

            SetEntityCoords(GetPlayerPed(-1), coords)
        else
            print("problem with getting coords")
        end

    end)
end)

RegisterNetEvent('aduty:setEventCoords')
AddEventHandler('aduty:setEventCoords', function()
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            if coords ~= nil then
                TriggerServerEvent('aduty:setEventCoords', coords)
            else
                print("Theere was a problem with getting coords")
            end
        end

    end)
end)

RegisterNetEvent('aduty:tagChanger')
AddEventHandler('aduty:tagChanger',function(add)
    

    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(perm)

        local id = PlayerId()
        local label

        if perm >= 1 and perm < 3 then
            label = { display = "[HELPER]", height = 1.2, toggle = false, badge = false}
        elseif perm >= 3 and perm < 4 then
            label = { display = "[ADMIN]", height = 1.2, toggle = false, badge = false}
        elseif perm >= 4 and perm < 6 then
            label = { display = "[SENIOR ADMIN]", height = 1.2, toggle = false, badge = false}
        elseif perm >= 6 and perm < 7 then
            label = { display = "[EXECUTIVE ADMIN]", height = 1.2, toggle = false, badge = false}
        elseif perm >= 9 and perm < 10 then
            label = { display = "[MANAGEMENT]", height = 1.2, toggle = false, badge = false}
        elseif perm >= 10 and perm < 11 then
            label = { display = "[DEVELOPER]", height = 1.2, toggle = false, badge = false}
        elseif perm >= 11 and perm < 12 then
            label = { display = "[CoOWNER]", height = 1.2, toggle = false, badge = false}
        elseif perm >= 12 and perm < 13 then
            label = { display = "[OWNER]", height = 1.2, toggle = false, badge = false}
        end

        if add then
            TriggerServerEvent('esx_idoverhead:modifyLabel', id, label)
        else
            TriggerServerEvent('esx_idoverhead:removeLabel', id, add)
        end
        

    end)

  
end)


RegisterNetEvent('aduty:returnStatus')
AddEventHandler('aduty:returnStatus', function()
    TriggerServerEvent('aduty:statusHandler', owned)
end)

RegisterNetEvent('aduty:set_tags')
AddEventHandler('aduty:set_tags', function (admins)
    currentTags = admins
end)

RegisterNetEvent('aduty:bringALL')
AddEventHandler('aduty:bringALL', function (target)
    SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) 
end)

RegisterNetEvent('aduty:flip')
AddEventHandler('aduty:flip', function (target)
    local ped = GetPlayerPed(-1)
    if IsPedSittingInAnyVehicle(ped) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        SetVehicleOnGroundProperly(vehicle)
    else
        local vehicle = ESX.Game.GetVehicleInDirection(4)
        if vehicle ~= 0 then
            NetworkRequestControlOfEntity(vehicle)
            while not NetworkHasControlOfEntity(vehicle) do
                Citizen.Wait(100)
            end
            SetVehicleOnGroundProperly(vehicle)
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Hich mashini nazdik shoma nist!"}})
        end
    end
end)

RegisterCommand('dobject', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then

            if args[1] then
                local coords = GetEntityCoords(GetPlayerPed(-1))
                local object = GetClosestObjectOfType(coords, 100.0, GetHashKey(args[1]), false, false, false)
                
                if DoesEntityExist(object) then
                    ESX.Game.DeleteObject(object)
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0},
                        multiline = true,
                        args = {"[SYSTEM]", "Shoma yek ^2" .. args[1] .. "^0 delete kardid!"}
                    })
                else
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0},
                        multiline = true,
                        args = {"[SYSTEM]", "Hich objecti peyda nashod"}
                    })
                end

            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"[SYSTEM]", "Shoma dar ghesmat esm object chizi varred nakardid"}
                })
            end
           

        end

     end)
end, false)


RegisterCommand('mcar', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 4 then


            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if isAduty then

                    if not args[1] then 

                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = true,
                            args = {"[SYSTEM]", "Shoma dar ghesmat model mashin chizi vared nakardid!"}
                        })

                        return
                    end

                    if not args[2] then 

                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = true,
                            args = {"[SYSTEM]", "Shoma dar ghesmat turbo chizi vared nakardid!"}
                        })

                        return
                    end

                    local turbo = args[2]
                    local model = args[1]
                    local colors = {a = 0, b = 0, c = 0}

                    if args[3] then 

                        colors.a = tonumber(args[3])

                    end

                    if args[4] then 

                        colors.b = tonumber(args[4])

                    end

                    if args[5] then 

                        colors.c = tonumber(args[5])

                    end

                    if turbo == "true" then

                        local playerPed = PlayerPedId()
                        local coords    = GetEntityCoords(playerPed)
                
                        ESX.Game.SpawnVehicle(model, coords, GetEntityHeading(GetPlayerPed(-1)), function(vehicle)
                            TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                            SetVehicleMaxMods(vehicle, true, colors)
                        
                                TriggerEvent('chat:addMessage', {
                                    color = { 255, 0, 0},
                                    multiline = true,
                                    args = {"[SYSTEM]", "^2 " .. model .. "^0 ba ^3turbo ^0spawn shod!"}
                                })
                
                        end)
                
                    elseif turbo == "false" then
                
                        local playerPed = PlayerPedId()
                        local coords    = GetEntityCoords(playerPed)
                
                        ESX.Game.SpawnVehicle(model, coords, GetEntityHeading(GetPlayerPed(-1)), function(vehicle)
                            TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                            SetVehicleMaxMods(vehicle, false, colors)
                                local carModel = GetEntityModel(vehicle)
                                local carName = GetDisplayNameFromVehicleModel(vehicle)
                        
                                TriggerEvent('chat:addMessage', {
                                    color = { 255, 0, 0},
                                    multiline = true,
                                    args = {"[SYSTEM]", "^2 " .. model .. "^0 spawn shod!"}
                                })
                
                        end)

                    else

                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = true,
                            args = {"[SYSTEM]", "^2 Shoma dar ghesmat turbo statement eshtebahi vared kardid!"}
                        })
                
                    end
                    
                else
    
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}})
    
                end
        
            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}})

        end

        end)
end, false)

local spectate = {ped = 0, active = false}
RegisterCommand('spectate', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 4 then


            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)
                
                if not args[1] or not tonumber(args[1]) then
                    if spectate.active and spectate.ped then
                       NetworkSetInSpectatorMode(false, spectate.ped)
                       spectate.active = false
                       spectate.ped = 0
                    else
                        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma hich kas ra spect nemikonid!")
                    end
                  return
                end

                local target = tonumber(args[1])

                if GetPlayerName(PlayerId()) == GetPlayerName(GetPlayerFromServerId(target)) then
                    TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid khodetan ra spect konid!")
                    return
                end
                
                local name = GetPlayerName(GetPlayerFromServerId(target))
                if name == "**Invalid**" then
                    TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0ID vared shode eshtebah ast")
                    return
                end

                if not spectate.active and spectate.ped == 0 then
                    spectate.ped = GetPlayerPed(GetPlayerFromServerId(target))
                    print(spectate.ped, DoesEntityExist(spectate.ped))
                    spectate.active = true
                    NetworkSetInSpectatorMode(true, spectate.ped)
                    TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma ba movafaghiat spect kardan ^2" .. name .. "^0 ra aghaz kardid!")
                else
                    TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar hale hazer darid shakhsi ra spect mikonid!")
                end
                

            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}})

        end

    end)
end, false)

RegisterCommand('livery', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then

            if not args[1] then
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dar ghesmat livery chizi vared nakardid"}})
                return
            end

            if not tonumber(args[1]) then
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dar ghesmat livery faghat mitavanid adad vared konid"}})
                return
            end
            local livery = tonumber(args[1])

            local ped = GetPlayerPed(-1)
            if IsPedSittingInAnyVehicle(ped) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                SetVehicleLivery(vehicle, livery)
            else
                local vehicle = ESX.Game.GetVehicleInDirection(4)
                if vehicle ~= 0 then
                    NetworkRequestControlOfEntity(vehicle)
                    while not NetworkHasControlOfEntity(vehicle) do
                        Citizen.Wait(100)
                    end
                    SetVehicleLivery(vehicle, livery)
                else
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Hich mashini nazdik shoma nist!"}})
                end
            end

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma admin nistid!"}})

        end

        end)
end, false)

RegisterCommand('modkit', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then

            if not args[1] then
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dar ghesmat modkit chizi vared nakardid"}})
                return
            end

            if not tonumber(args[1]) then
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dar ghesmat modkit faghat mitavanid adad vared konid"}})
                return
            end
            local modkit = tonumber(args[1])

            local ped = GetPlayerPed(-1)
            if IsPedSittingInAnyVehicle(ped) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                SetVehicleModKit(vehicle, modkit)
            else
                local vehicle = ESX.Game.GetVehicleInDirection(4)
                if vehicle ~= 0 then
                    NetworkRequestControlOfEntity(vehicle)
                    while not NetworkHasControlOfEntity(vehicle) do
                        Citizen.Wait(100)
                    end
                    SetVehicleModKit(vehicle, modkit)
                else
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Hich mashini nazdik shoma nist!"}})
                end
            end

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma admin nistid!"}})

        end

    end)
end, false)

RegisterCommand('alock', function(source)
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then

            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if isAduty then

                    if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then

                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                        local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                        vehicleLabel = GetLabelText(vehicleLabel)
                        local lock = GetVehicleDoorLockStatus(vehicle)
        
                        if lock == 1 or lock == 0 then
                            SetVehicleDoorShut(vehicle, 0, false)
                            SetVehicleDoorShut(vehicle, 1, false)
                            SetVehicleDoorShut(vehicle, 2, false)
                            SetVehicleDoorShut(vehicle, 3, false)
                            SetVehicleDoorsLocked(vehicle, 2)
                            PlayVehicleDoorCloseSound(vehicle, 1)
                            local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                            TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
                            ESX.ShowNotification('You have ~r~locked~s~ your ~y~'..vehicleLabel..'~s~.')
                        elseif lock == 2 then
                            SetVehicleDoorsLocked(vehicle, 1)
                            PlayVehicleDoorOpenSound(vehicle, 0)
                            local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                            TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
                            ESX.ShowNotification('You have ~g~unlocked~s~ your ~y~'..vehicleLabel..'~s~.')
                        end
                        
                    else
        
                        local vehicle = ESX.Game.GetVehicleInDirection(4)
                        local lock = GetVehicleDoorLockStatus(vehicle)
        
                        if vehicle ~= 0 then
        
                            local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                            vehicleLabel = GetLabelText(vehicleLabel)
        
                            if lock == 1 or lock == 0 then
                                SetVehicleDoorShut(vehicle, 0, false)
                                SetVehicleDoorShut(vehicle, 1, false)
                                SetVehicleDoorShut(vehicle, 2, false)
                                SetVehicleDoorShut(vehicle, 3, false)
                                SetVehicleDoorsLocked(vehicle, 2)
                                PlayVehicleDoorCloseSound(vehicle, 1)
                                local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                            TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
                                ESX.ShowNotification('You have ~r~locked~s~ your ~y~'..vehicleLabel..'~s~.')
                            elseif lock == 2 then
                                SetVehicleDoorsLocked(vehicle, 1)
                                PlayVehicleDoorOpenSound(vehicle, 0)
                                local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                                TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
                                ESX.ShowNotification('You have ~g~unlocked~s~ your ~y~'..vehicleLabel..'~s~.')
                            end
        
                        else
        
                            ESX.ShowNotification("~r~~h~Hich mashini nazdik shoma nist!")
        
                        end
                        
                    end
                    
                else
    
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}})
    
                end
        
            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma admin nistid!"}})

        end

    end)
end, false)

RegisterCommand('getin', function(source)
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then

            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if isAduty then

                    local vehicle = ESX.Game.GetVehicleInDirection(4)
                    if vehicle ~= 0 then
        
                      if DoesEntityExist(vehicle) then
                          if IsVehicleSeatFree(vehicle, -1) then
                              SetPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
                          else
                            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Mashin ranande darad!"}})
                          end
                      end
    
                    else
    
                        ESX.ShowNotification("~r~~h~Hich mashini nazdik shoma nist!")
    
                    end
                    
                else
    
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}})
    
                end
        
            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma admin nistid!"}})

        end

    end)
end, false)

RegisterCommand('creategang', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 9 then


            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if args[1] and tonumber(args[2]) then
                    TriggerServerEvent('gangs:registerGang', args[1], args[2])
                else
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Parameter haye vared shode sahih nist!"}})
                end
        
            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}})

        end

    end)
end, false)

RegisterCommand('savegangs', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 9 then


            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                TriggerServerEvent('gangs:saveGangs')
        
            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}})

        end

    end)
end, false)

RegisterCommand('changegangdata', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 9 then


            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                ESX.TriggerServerCallback('esx_aduty:doesGangExist', function(GangExist)

                    local playerPos = GetEntityCoords(GetPlayerPed(-1))
                    if GangExist then
                        
                        if args[2] == 'blip' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = playerPos.z + 0.5 }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos)
                        elseif args[2] == 'armory' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos)
                        elseif args[2] == 'locker' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos)
                        elseif args[2] == 'boss' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos)
                        elseif args[2] == 'veh' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos)
                        elseif args[2] == 'vehdel' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos)
                        elseif args[2] == 'search' then
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], nil)
                        elseif args[2] == 'vehspawn' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = playerPos.z , a = GetEntityHeading(GetPlayerPed(-1)) }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos)
                        elseif args[2] == 'expire' then
                            if tonumber(args[3]) then
                                TriggerServerEvent('gangs:changeGangData', args[1], args[2], args[3])
                            else
                                ESX.ShowNotification("~h~Shoma dar ghesmat roz faghat mitavanid adad vared konid")
                            end
                        elseif args[2] == 'bulletproof' then
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], nil)
                        else
                            ESX.ShowNotification("~h~Option vared shode eshtebah ast")
                        end

                    else
                       ESX.ShowNotification("~h~Gang vared shode eshtebah ast")
                    end
            
                end, args[1], 6)
        
            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}})

        end

    end)
end, false)

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(500)
        
        if AdminPerks then
            ResetPlayerStamina(PlayerId())
            SetEntityInvincible(GetPlayerPed(-1), true)
            SetPlayerInvincible(PlayerId(), true)
            SetPedCanRagdoll(GetPlayerPed(-1), false)
            ClearPedBloodDamage(GetPlayerPed(-1))
            ResetPedVisibleDamage(GetPlayerPed(-1))
            ClearPedLastWeaponDamage(GetPlayerPed(-1))
            SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
            SetEntityCanBeDamaged(GetPlayerPed(-1), false)
        else
            SetEntityInvincible(GetPlayerPed(-1), false)
            SetPlayerInvincible(PlayerId(), false)
            SetPedCanRagdoll(GetPlayerPed(-1), true)
            ClearPedLastWeaponDamage(GetPlayerPed(-1))
            SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
            SetEntityCanBeDamaged(GetPlayerPed(-1), true)
        end

    end
    
end)

RegisterNetEvent("esx_aduty:dobject")
AddEventHandler("esx_aduty:dobject",function(model)

    Citizen.CreateThread(function()

        local ped = PlayerPedId()
        local model = model
        print("running", model)
        local handle, object = FindFirstObject()
        local finished = false
        repeat
        Citizen.Wait(1)
    
        if GetEntityModel(object) == model then
            DeleteObjects(object)
        end

        finished, object = FindNextObject(handle)
    
        until not finished
        EndFindObject(handle)
            
    end)    
        
end)

function DeleteObjects(object)
    if DoesEntityExist(object) then
        NetworkRequestControlOfEntity(object)
        while not NetworkHasControlOfEntity(object) do
            Citizen.Wait(1)
        end
        
        if IsEntityAttached(object) then
            DetachEntity(object, 0, false)
        end

        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
        SetEntityAsMissionEntity(object, true, true)
        SetEntityAsNoLongerNeeded(object)
        DeleteEntity(object)

    end
end


-- function visibility()

--     Citizen.CreateThread( function()
--         while true do
--             Citizen.Wait(0)
            
--             if ForceToVisible then
--                 SetEntityVisible(GetPlayerPed(-1), true, false)
--             end

--         end
        
--     end)

-- end

-- Citizen.CreateThread(function()

-- 	while true do
--         Wait(1)
            
--             if (IsControlPressed(1, 21) and IsControlPressed(1, 38)) then
                
--                 if time == 0 then

--                     time = 3

--                     ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

--                         if isAdmin then

--                             if ESX.GetPlayerData()['aduty'] == 1 then

--                                 local playerPed = GetPlayerPed(-1)
--                                 local WaypointHandle = GetFirstBlipInfoId(8)
--                                 if DoesBlipExist(WaypointHandle) then
--                                     local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
--                                     SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.5, false, false, false, true)
--                                     ESX.ShowNotification("Shoma be marker roye map teleport shodid!")
--                                 else
--                                     ESX.ShowNotification("Markeri baraye teleport shodan vojoud nadarad!")
--                                 end

--                             else

--                                 TriggerEvent('chat:addMessage', {
--                                     color = { 255, 0, 0},
--                                     multiline = true,
--                                     args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0be marker roye map teleport konid!"}
--                                 })

--                             end

--                             end

--                         end)

--              end


--         end
        
--         while time > 0 do

--             Citizen.Wait(1000)

--             time = time -1
            
--         end
       
		
--     end

-- end)
    


RegisterNetEvent("aduty:addSuggestions")
AddEventHandler("aduty:addSuggestions",function()

        TriggerEvent('chat:addSuggestion', '/aduty', 'Jahat on/off duty shodan admini', {
        })

        TriggerEvent('chat:addSuggestion', '/changeped', 'Jahat avaz kardan ped', {
            { name="EsmPed", help="Esm ped mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/resetped', 'Jahat reset kardan ped be halat admini', {
        })

        TriggerEvent('chat:addSuggestion', '/w', 'Jahat ferestadan whisper admini', {
            { name="Peygham", help="Peygham mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/livery', 'Jahat avaz kardan livery mashin', {
            { name="ID", help="ID livery mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/alock', 'Jahat baz ya baste kardan dare mashini ke darid be an negah mikonid', {
        })

        TriggerEvent('chat:addSuggestion', '/getin', 'Jahat raftan be dakhel mashin', {
        })

        TriggerEvent('chat:addSuggestion', '/setarmor', 'Jahat avaz kardan armor player', {
            { name="ID", help="ID player mored nazar" },
            { name="Armor", help="Meghdar armor beyn 0-100" }
        })

        TriggerEvent('chat:addSuggestion', '/fineoffline', 'Jarime kardan player be sorat offline', {
            { name="Esm", help="Esm daghigh player ba horof bozorg va kochik" },
            { name="Meghdar", help="Meghdar jarime" },
            { name="Dalil", help="Dalil jarime" }
        })

        TriggerEvent('chat:addSuggestion', '/changegangdata', 'Taqir dadan option haye gang', {
            { name="GangName", help="Esme Gang" },
	        { name="Option", help="Entekhabe option:(blip, armory, locker, boss, veh, vehdel, vehspawn, expire, search, bulletproof)" },
        })

        TriggerEvent('chat:addSuggestion', '/creategang', 'Sakhtan gang', {
            { name="GangName", help="Esme Gang" },
	        { name="Expire", help="Modat etebar gang" },
        })

        TriggerEvent('chat:addSuggestion', '/savegangs', 'Zakhire kardan gang haye movaghat dar ram', {
        })

        TriggerEvent('chat:addSuggestion', '/fine', 'Jarime kardan player be sorat online', {
            { name="ID", help="ID player mored nazar" },
            { name="Meghdar", help="Meghdar jarime" },
            { name="Dalil", help="Dalil jarime" }
        })

        TriggerEvent('chat:addSuggestion', '/ajailoffline', 'Admin jail kardan player be sorat offline', {
            { name="Esm", help="Esm daghigh player ba horof bozorg va kochik" },
            { name="Zaman", help="Zaman admin jail be daghighe" },
            { name="Dalil", help="Dalil admin jail" }
        })

        TriggerEvent('chat:addSuggestion', '/ajail', 'Admin jail kardan player be sorat online', {
            { name="ID", help="ID player mored nazar" },
            { name="Zaman", help="Zaman admin jail be daghighe" },
            { name="Dalil", help="Dalil admin jail" }
        })

        TriggerEvent('chat:addSuggestion', '/aunjail', 'Admin unjail kardan player be sorat online', {
            { name="ID", help="ID player mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/money', 'Taghir dadan pol player', {
            { name="ID", help="ID player mored nazar" },
            { name="NoePool", help="Noe pool ebarat ast az cash/bank/black" },
            { name="Meghdar", help="Meghdar pool mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/plate', 'Avaz kardan shomare pelak mashin', {
            { name="Pelak", help="Pelak mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/a', 'Ferestadan adminchat', {
            { name="Peygham", help="Peygham mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/kick', 'Kick kardan player', {
            { name="ID", help="ID player mored nazar" },
            { name="Dalil", help="Dalil kick shodan" }
        })

        TriggerEvent('chat:addSuggestion', '/mute', 'Jahat mute kardan player', {
            { name="ID", help="ID player mored nazar" },
            { name="Dalil", help="Dalil mute shodan player" }
        })

        TriggerEvent('chat:addSuggestion', '/unmute', 'Jahat unmute kardan player', {
            { name="ID", help="ID player mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/toggleid', 'Jahat toggle kardan halat didan ID playerha', {
        })

        TriggerEvent('chat:addSuggestion', '/resetaccount', 'Jahat reset kardan account player', {
            { name="ESM", help="Esm player mored nazar" },
            { name="Dalil", help="Dalil reset kardan account" }
        })

        TriggerEvent('chat:addSuggestion', '/disband', 'Jahat disband kardan family', {
            { name="ESM", help="Esm family mored nazar" },
            { name="Dalil", help="Dalil disband kardan gang" }
        })

        TriggerEvent('chat:addSuggestion', '/ban', 'Ban kardan player ba ID', {
            { name="ID", help="ID player mored nazar" },
            { name="ZAMAN", help="Zaman ra be roz vared konid (0 = permanent ban)" },
            { name="DALIL", help="Dalil ban shodan player ra vared konid" },
        })

        TriggerEvent('chat:addSuggestion', '/banoffline', 'Ban kardan player ba esm IC', {
            { name="name", help="Esm IC player mored nazar" },
            { name="ZAMAN", help="Zaman ra be roz vared konid (0 = permanent ban)" },
            { name="DALIL", help="Dalil ban shodan player ra vared konid" },
        })

        TriggerEvent('chat:addSuggestion', '/unban', 'Unban kardan player ba esm IC', {
            { name="name", help="Esm IC player mored nazar" },
        })

        TriggerEvent('chat:addSuggestion', '/charmenu', 'Reload player skin', {
            { name="Player", help="Player ID" },
        })

        TriggerEvent('chat:addSuggestion', '/vanish', 'baraye avaz kardan vaziat dide shodan', {
        })  

        TriggerEvent('chat:addSuggestion', '/atoggle', 'toggle kardan tag admini baraye hame', {
        })

        TriggerEvent('chat:addSuggestion', '/owntoggle', 'toggle kardan tag admini baraye khod', {
        })

        TriggerEvent('chat:addSuggestion', '/creategang', 'Sakhtan Gang, Hasas be Horofe bozorg va Kochak', {
            { name="GangName", help="Esme Gang" },
            { name="Expire", help="Tedad Roz etebare Gang ra Vared konid" },
        })

        TriggerEvent('chat:addSuggestion', '/savegangs', 'Zakhire Kardane Gang\'e Sakhte Shode', {})

        TriggerEvent('chat:addSuggestion', '/spectate', 'Jahat spect kardan player mored nazar', {
            { name="ID", help="ID player mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/togglenotify', 'Jahat toggle kardan notification haye anticheat', {
        })
end)

RegisterNetEvent("aduty:removeSuggestions")
AddEventHandler("aduty:removeSuggestions",function()

        TriggerEvent('chat:removeSuggestion', '/aduty')

        TriggerEvent('chat:removeSuggestion', '/livery')

        TriggerEvent('chat:removeSuggestion', '/changeped')

        TriggerEvent('chat:removeSuggestion', '/resetped')

        TriggerEvent('chat:removeSuggestion', '/w')

        TriggerEvent('chat:removeSuggestion', '/setarmor')

        TriggerEvent('chat:removeSuggestion', '/fineoffline')

        TriggerEvent('chat:removeSuggestion', '/fine')

        TriggerEvent('chat:removeSuggestion', '/ajailoffline')

        TriggerEvent('chat:removeSuggestion', '/ajail')

        TriggerEvent('chat:removeSuggestion', '/aunjail')

        TriggerEvent('chat:removeSuggestion', '/money')

        TriggerEvent('chat:removeSuggestion', '/plate')

        TriggerEvent('chat:removeSuggestion', '/a')

        TriggerEvent('chat:removeSuggestion', '/kick')

        TriggerEvent('chat:removeSuggestion', '/mute')

        TriggerEvent('chat:removeSuggestion', '/unmute')

        TriggerEvent('chat:removeSuggestion', '/toggleid')

        TriggerEvent('chat:removeSuggestion', '/resetaccount')

        TriggerEvent('chat:removeSuggestion', '/disband')

        TriggerEvent('chat:removeSuggestion', '/vanish')

        TriggerEvent('chat:removeSuggestion', '/dv2')

        TriggerEvent('chat:removeSuggestion', '/charmenu')

        TriggerEvent('chat:removeSuggestion', '/savegangs')

        TriggerEvent('chat:removeSuggestion', '/creategang')

        TriggerEvent('chat:removeSuggestion', '/alock')

        TriggerEvent('chat:removeSuggestion', '/getin')

        TriggerEvent('chat:removeSuggestion', '/owntoggle')

        TriggerEvent('chat:removeSuggestion', '/changegangdata')

        TriggerEvent('chat:removeSuggestion', '/savegangs')

        TriggerEvent('chat:removeSuggestion', '/creategang')

        TriggerEvent('chat:removeSuggestion', '/spectate')
        
        TriggerEvent('chat:removeSuggestion', '/togglenotify')

        TriggerEvent('chat:removeSuggestion', '/ban')

        TriggerEvent('chat:removeSuggestion', '/banoffline')

        TriggerEvent('chat:removeSuggestion', '/unban')

end)

function MutePlayer()

    Citizen.CreateThread(function()

		while muted do

			DisableControlAction(0, Keys['N'], true)

            Citizen.Wait(0)
            
		end

	end)

end

function SetVehicleMaxMods(vehicle, turbo, colors)

        local props = {
            modEngine       =   3,
            modBrakes       =   2,
            windowTint      =   1,
            modArmor        =   4,
            modTransmission =   2,
            modSuspension   =   -1,
            modTurbo        =   turbo,
            modXenon     = true,
            color1 = colors.a,
            color2 = colors.b,
            pearlescentColor = colors.c
        }
            
    ESX.Game.SetVehicleProperties(vehicle, props)

end

--// Civilian Section
local time = 0
RegisterCommand('w', function(source, args)
	
    if not args[1] then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID chizi vared nakardid!")
        return
    end
    
    if not tonumber(args[1]) then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID faghat mojaz be vared kardan adad hastid!")
        return
    end

    if not args[2] then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma baraye whisper kardan hadeaghal bayad yek kalame bayad type konid!")
        return
    end

    local target = tonumber(args[1])
    local message = table.concat(args, " ", 2)

    if GetPlayerName(PlayerId()) == GetPlayerName(GetPlayerFromServerId(target)) then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid be khodetan whisper dahid!")
        return
    end

    if GetPlayerName(GetPlayerFromServerId(target)) == "**Invalid**" then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0ID vared shode eshtebah ast")
        return
    end
    
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local tcoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))

    if GetDistanceBetweenCoords(coords, tcoords, true) > 2 then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Fasele shoma az player mored nazar ziad ast")
        return
    end
    
    TriggerEvent("chatMessage", "[Whisper]", {255, 197, 0}, message)
    TriggerServerEvent('aduty:sendMessage', target, message)

    if GetGameTimer() - time > 5000 then
        time = GetGameTimer()
        TriggerServerEvent('3dme:shareDisplay', "Shoro mikone be dare goshi sohbat kardan", false)
    end


end, false)

RegisterCommand('sl', function(source, args)
	
    if not args[1] then
        TriggerServerEvent('aduty:showlicense', GetPlayerServerId(PlayerId()))
        return
    end
    
    if not tonumber(args[1]) then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID faghat mojaz be vared kardan adad hastid!")
        return
    end

    local target = tonumber(args[1])

    if GetPlayerName(PlayerId()) == GetPlayerName(GetPlayerFromServerId(target)) then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid be khodetan license neshan dahid!")
        return
    end

    if GetPlayerName(GetPlayerFromServerId(target)) == "**Invalid**" then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0ID vared shode eshtebah ast")
        return
    end
    
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local tcoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))

    if GetDistanceBetweenCoords(coords, tcoords, true) > 2 then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Fasele shoma az player mored nazar ziad ast")
        return
    end
    
    TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "Shoma ba movafaghiat license khod ra be ^2" .. target .. "^0 neshan dadid!")
    TriggerServerEvent('aduty:showlicense', target)


end, false)

RegisterCommand('neon', function(source, args)
    local player = GetPlayerPed(-1)
    if (IsPedSittingInAnyVehicle(player)) then
        local car = GetVehiclePedIsIn(player, false)
        if car then
            if GetPedInVehicleSeat(car, -1) == player then
                local veh = GetVehiclePedIsUsing(player)
        
                if args[1] == "on" then
                    SetVehicleNeonLightEnabled(veh, 0, true)
                    SetVehicleNeonLightEnabled(veh, 1, true)
                    SetVehicleNeonLightEnabled(veh, 2, true)
                    SetVehicleNeonLightEnabled(veh, 3, true)
                    ESX.ShowNotification("~g~~h~Neon haye mashin roshan shodand!")
                elseif args[1] == "off" then
                    SetVehicleNeonLightEnabled(veh, 0, false)
                    SetVehicleNeonLightEnabled(veh, 1, false)
                    SetVehicleNeonLightEnabled(veh, 2, false)
                    SetVehicleNeonLightEnabled(veh, 3, false)
                    ESX.ShowNotification("~g~~h~Neon haye mashin khamosh shodanad!")
                else
                    ESX.ShowNotification("~g~~h~Dar ghesmat statement neon chizi vared nakardid!")
                end

            else 
                ESX.ShowNotification("~r~~h~Faghat ranande mitavanad az in dastor estefade konad!")
            end
                
        end
     else
        ESX.ShowNotification("~r~~h~Shoma baraye estefade az in command bayad dakhel mashin bashid")
     end
end, false)

Citizen.CreateThread(function()
    TriggerEvent('chat:removeSuggestion', '/report')
    TriggerEvent('chat:removeSuggestion', '/cancelreport')
    TriggerEvent('chat:addSuggestion', '/report', 'Porsidan soal ya gozaresh ghanon shekani', {
        { name="Noe Report", help="0 = Soal, 1 = Gozaresh ghanon shekani" },
        { name="Matn", help="Matn gozaresh ya soal" },
    })
    TriggerEvent('chat:addSuggestion', '/cancelreport', 'Laghv kardan report ersali', {
    })
end)