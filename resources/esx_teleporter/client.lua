ESX                           = nil
local PlayerData              = {}
local Ipls = {
    bike = {name = "bike", fuc = exports.bob74_ipl:GetBikerClubhouse2Object()},
    executive3 = {name = "executive3", fuc = exports.bob74_ipl:GetExecApartment3Object() },
    executive2 = {name = "executive2", fuc = exports.bob74_ipl:GetExecApartment2Object() },
    executive1 = {name = "executive1", fuc = exports.bob74_ipl:GetExecApartment1Object() }
}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().gang == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end) 

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function (gang)
	PlayerData.gang = gang
end)

positions = {
    -- Marker Types: https://docs.fivem.net/docs/game-references/markers/
    -- Blips types, colour: https://docs.fivem.net/docs/game-references/blips/
    -- Press key types: https://docs.fivem.net/docs/game-references/controls/
    
    {marker = 0, enter = { position = vector3(132.89, -1293.76, 29.27), heading = 119.39}, exit = {position = vector3(132.46, -1287.4, 29.27), heading = 37.08}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false, key = {["tarafamily"] = 1} },
    {marker = 0, enter = { position = vector3(1845.94, 2585.92, 45.67), heading = 273.5}, exit = {position = vector3(1845.1, 2585.21, -26.28), heading = 87.49}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false},
    {marker = 0, enter = { position = vector3(1690.76, 2591.19, 45.91), heading = 0.42}, exit = {position = vector3(1688.01, 2595.92, -49.71), heading = 179.97}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false},
    {marker = 0, enter = { position = vector3(343.47, -1398.53, 32.51), heading = 46.23}, exit = {position = vector3(275.72, -1361.44, 24.54), heading = 42.75}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false}, --Hospital
    {marker = 0, enter = { position = vector3(247.14, -1371.71, 24.54), heading = 316.55}, exit = {position = vector3(335.34, -1432.04, 46.51), heading = 133.06}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false}, --Hospital Heli
    {marker = 0, enter = { position = vector3(1791.55, 2593.78, 45.8), heading = 271.61}, exit = {position = vector3(1789.64, 2598.46, -49.72), heading = 88.64}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false},
    {marker = 0, enter = { position = vector3(1819.46, 2594.45, -26.28), heading = 267.08}, exit = {position = vector3(1818.67, 2594.41, 45.72), heading = 102.4}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false},
    {marker = 0, enter = { position = vector3(-1516.65, 851.62, 181.59), heading = 341.07}, exit = {position = vector3(-786.79, 315.73, 187.91), heading = 266.47}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false, key = {["michelson"] = 1}, ipl = "executive3" },
    {marker = 0, enter = { position = vector3(-113.06, 985.91, 235.75), heading = 112.95}, exit = {position = vector3(-786.85, 315.7, 217.64), heading = 273.55}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false, key = {["mafia"] = 1}, ipl = "executive1" },
    {marker = 1, enter = { position = vector3(-1317.64, -763.0, 18.96), heading = 127.722}, exit = {position = vector3(1000.21, -3164.42, -39.91), heading = 269.13}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 3.5, p2 = 3.5, p3 = 1.0}, vehicle = true, key = {["shaftaks"] = 1}, ipl = "bike" },
    {marker = 0, enter = { position = vector3(1395.391, 1141.94, 114.64), heading = 83.75}, exit = {position = vector3(1396.42, 1141.78, 114.33), heading = 270.72}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false, key = {["lafuente"] = 1} },
    {marker = 0, enter = { position = vector3(1400.56, 1127.39, 114.33), heading = 180.48}, exit = {position = vector3(1400.34, 1129.17, 114.33), heading = 356.89}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false, key = {["lafuente"] = 1} },
    {marker = 0, enter = { position = vector3(445.92, -996.85, 30.69), heading = 357.06}, exit = {position = vector3(136.14, -761.84, 242.15), heading = 157.4}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false}, -- PD interior
    {marker = 1, enter = { position = vector3(211.82, -939.2, 23.12), heading = 237.3}, exit = {position = vector3(1041.94, -3197.27, -39.16), heading = 178.48}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 3.5, p2 = 3.5, p3 = 1.0}, vehicle = true, key = {["mafia"] = 1}},
    {marker = 0, enter = { position = vector3(-1077.93, -254.54, 44.02), heading = 29.47}, exit = {position = vector3(-1072.72, -246.66, 54.01), heading = 302.46}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false}, -- Weazel Elevator
    {marker = 0, enter = { position = vector3(-1048.23, -238.23, 44.02), heading = 118.1}, exit = {position = vector3(-1047.12, -237.74, 44.02), heading = 295.06}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false, key = {["weazel"] = 0} }, -- Weazel Meeting Room
    {marker = 0, enter = { position = vector3(2515.49, -357.23, 94.13), heading = 118.1}, exit = {position = vector3(2154.76, 2920.9, -61.9), heading = 295.06}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false, key = {["government"] = 0, ["police"] = 4} }, -- government facility
    {marker = 0, enter = { position = vector3(2475.88, -384.15, 94.4), heading = 118.1}, exit = {position = vector3(2060.4, 2992.75, -72.7), heading = 295.06}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false, key = {["government"] = 0, ["police"] = 4} }, -- government facility
    {marker = 0, enter = { position = vector3(-1500.41, 103.2, 55.64), heading = 226.54}, exit = {position = vector3(-775.66, 343.3, 196.69), heading = 178.66}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false, key = {["divas"] = 4}, ipl = "executive2" }, -- Divas room
    {marker = 0, enter = { position = vector3(1630.02, 2567.76, -49.7), heading = 5.71}, exit = {position = vector3(1636.31, 2565.52, 45.56), heading = 176.3}, color = {r = 237, g = 228, b = 47}, scale = {p1 = 0.5, p2 = 0.5, p3 = 0.5}, vehicle = false},

}

MIndicator = {
    [0] = 1
}

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(5)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)

        for _,location in ipairs(positions) do

            DrawLocation(location)

            if Vdist(coords.x, coords.y, coords.z, location.enter.position.x, location.enter.position.y, location.enter.position.z) <= location.scale.p1/2 then 
                helpNotification("Dokme ~INPUT_CONTEXT~ ra jahat teleport feshar dahid!")
                if IsControlJustReleased(1, 38) then
                    
                    if not CheckLock(location) then

                        local entity = selectHandler(location)
                        if entity then
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "entering_ipl",
                                duration = 3000,
                                label = "Dar hale baz kardan dar",
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
                    
                                    DoScreenFadeOut(0)
                                    Teleport(entity, location.exit.position, location.exit.heading, MIndicator[location.marker] or 0)
                                    if location.ipl then
                                        interior(location.ipl, true)
                                    end
                                    Citizen.Wait(500)
                                    DoScreenFadeIn(500)
                                    
                                end
                                
                            end)
                        end   

                    else
                        sendMessage("Shoma dastresi be kilid in dar ra nadarid!")
                    end
                  
                end
            elseif Vdist(coords.x, coords.y, coords.z, location.exit.position.x, location.exit.position.y, location.exit.position.z) <= location.scale.p1/2 then
                helpNotification("Dokme ~INPUT_CONTEXT~ ra jahat teleport feshar dahid!")
                if IsControlJustReleased(1, 38) then

                    if not CheckLock(location) then

                        local entity = selectHandler(location)
                        if entity then
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "exit_ipl",
                                duration = 3000,
                                label = "Dar hale baz kardan dar",
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
                    
                                    DoScreenFadeOut(0)
                                    Teleport(entity, location.enter.position, location.enter.heading, MIndicator[location.marker] or 0)
                                    if location.ipl then
                                        interior(location.ipl, false)
                                    end
                                    Citizen.Wait(500)
                                    DoScreenFadeIn(500)
                                    
                                end
                                
                            end)
                        end
                        
                    else
                        sendMessage("Shoma dastresi be kilid in dar ra nadarid!")
                    end
                  
                end
            end

        end
    end
end)

RegisterCommand('getint', function(source, args)
    local ped = GetPlayerPed(-1)
    local interior = GetInteriorFromEntity(ped)
    print(interior)
end, false)

function interior(int, state)
    if Ipls[int] then

        intHandler(Ipls[int].name, state)

    end
end

function intHandler(name, state)
    local interior = Ipls[name].fuc
    if name == "bike" then
        if state then
            interior.Ipl.Interior.Load()
            interior.LoadDefault()
        else
            interior.Ipl.Interior.Remove()
            interior.Walls.Clear(false)
            interior.Furnitures.Clear(false)
            interior.Decoration.Clear(false)
            interior.Mural.Clear(false)
            interior.GunLocker.Clear(false)
            interior.ModBooth.Clear(false)
            interior.Meth.Clear(false)
            interior.Cash.Clear(false)
            interior.Weed.Clear(false)
            interior.Coke.Clear(false)
            interior.Counterfeit.Clear(false)
            interior.Documents.Clear(false)
            RefreshInterior(interior.interiorId)
        end
    elseif name == "executive3" then
        if state then
            interior.LoadDefault()
        else
            interior.Style.Clear(false)
            interior.Strip.Enable({interior.Strip.A, interior.Strip.B, interior.Strip.C}, false)
            interior.Booze.Enable({interior.Booze.A, interior.Booze.B, interior.Booze.C}, false)
            interior.Smoke.Clear(true)
        end
    elseif name == "executive2" then
        if state then
           interior.LoadDefault()
        else
            interior.Style.Clear(false)
            interior.Strip.Enable({interior.Strip.A, interior.Strip.B, interior.Strip.C}, false)
            interior.Booze.Enable({interior.Booze.A, interior.Booze.B, interior.Booze.C}, false)
            interior.Smoke.Clear(true)
        end
    elseif name == "executive1" then
        if state then
            interior.LoadDefault()
        else
            interior.Style.Clear(false)
            interior.Strip.Enable({interior.Strip.A, interior.Strip.B, interior.Strip.C}, false)
            interior.Booze.Enable({interior.Booze.A, interior.Booze.B, interior.Booze.C}, false)
            interior.Smoke.Clear(true)
        end
    end
end

function DrawLocation(location)
    DrawMarker(location.marker, location.enter.position.x, location.enter.position.y, location.enter.position.z, 0, 0, 0, 0, 0, 0, location.scale.p1, location.scale.p2, location.scale.p3, location.color.r, location.color.g, location.color.b, 200, 0, 0, 0, 1)
    DrawMarker(location.marker, location.exit.position.x, location.exit.position.y, location.exit.position.z, 0, 0, 0, 0, 0, 0, location.scale.p1, location.scale.p2, location.scale.p3, location.color.r, location.color.g, location.color.b, 200, 0, 0, 0, 1)
end

function Teleport(entity, coords, heading, indicate)
    local indicate = indicate
    RequestCollisionAtCoord(coords.x, coords.y, coords.z - indicate)

	while not HasCollisionLoadedAroundEntity(entity) do
		RequestCollisionAtCoord(coords.x, coords.y, coords.z - indicate)
		Citizen.Wait(0)
    end
    
    exports.esx_checker:notSend(true)
    SetEntityCoords(entity, coords.x, coords.y, coords.z - indicate)
    Citizen.CreateThread(function()
		Citizen.Wait(1250)
		exports.esx_checker:notSend(false)
	end)
    SetEntityHeading(entity, heading)
end

function CheckLock(location)
    if location.key then
        if location.key[PlayerData.job.name] then
            if PlayerData.job.grade < location.key[PlayerData.job.name] then return true else return false end
        elseif location.key[string.lower(PlayerData.gang.name)] then
            if PlayerData.gang.grade < location.key[string.lower(PlayerData.gang.name)] then return true else return false end 
        else
            return true
        end
    else 
        return false
    end
end

function selectHandler(location)
    local entity
    if location.vehicle then
       local ped = GetPlayerPed(-1)
       if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped)
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                entity = vehicle
            else
                sendMessage("Shoma ranande mashin nistid!")
            end
       else
        entity = ped
       end
    else
        local ped = GetPlayerPed(-1)
        if IsPedOnFoot(ped) then
            entity = ped
        else
            sendMessage("Shoma nemitavanid ba vasile naghlie vared shavid!")
        end  
    end

    return entity
end

function sendMessage(message)
    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0" .. message}})
end

function helpNotification(msg)
    if not IsHelpMessageOnScreen() then
		BeginTextCommandDisplayHelp('STRING')
		AddTextComponentSubstringWebsite(msg)
		EndTextCommandDisplayHelp(0, false, true, -1)
	end
end