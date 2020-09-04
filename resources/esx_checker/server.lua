ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local BlacklistedModels = {
    [GetHashKey("cargoplane")] = {name = "Cargo Plane", ban = true},
    [GetHashKey("luxor2")] = {name = "Luxur2", ban = true},
    [GetHashKey("dump")] = {name = "Dump", ban = true},
    [GetHashKey("avenger")] = {name = "Avenger", ban = true},
    [GetHashKey("avenger2")] = {name = "Avenger2", ban = true},
    [GetHashKey("luxor")] = {name = "Luxor", ban = false},
    [GetHashKey("khanjali")] = {name = "Khanjali", ban = true},
    [GetHashKey("rhino")] = {name = "Rhino", ban = true},
    [GetHashKey("insurgent")] = {name = "Insurgent", ban = true},
    [GetHashKey("oppressor")] = {name = "Oprresor", ban = true},
    [GetHashKey("oppressor2")] = {name = "Oprresor2", ban = true},
    [GetHashKey("maverick")] = {name = "Maverick", ban = true},
    [GetHashKey("blimp2")] = {name = "blimp2", ban = true},
    [GetHashKey("blimp")] = {name = "blimp", ban = false},
    [GetHashKey("blimp3")] = {name = "blimp3", ban = true},
    [GetHashKey("freight")] = {name = "Freight", ban = true},
    [GetHashKey("freightcar")] = {name = "FreightCar", ban = true},
    [GetHashKey("limo2")] = {name = "Limo2", ban = true},
    [GetHashKey("freightcont1")] = {name = "FreightCont1", ban = true},
    [GetHashKey("freightcont2")] = {name = "FreightCont2", ban = true},
    [GetHashKey("freightgrain")] = {name = "FreightGrain", ban = true},
    [GetHashKey("cerberus3")] = {name = "Cerberus3", ban = true},
    [GetHashKey("cerberus2")] = {name = "Cerberus2", ban = true},
    [GetHashKey("cerberus")] = {name = "Cerberus", ban = true},
    [GetHashKey("buzzard")] = {name = "Buzzard", ban = false},
    [GetHashKey("phantom2")] = {name = "Phantom2", ban = true},
    [GetHashKey("issi6")] = {name = "Issi6", ban = true},
    -- [GetHashKey("issi3")] = {name = "Issi3", ban = true},
    [GetHashKey("issi4")] = {name = "Issi4", ban = true},
    [GetHashKey("issi5")] = {name = "Issi5", ban = true},
    [GetHashKey("savage")] = {name = "Savage", ban = true},
    [GetHashKey("hunter")] = {name = "Hunter", ban = true},
    [GetHashKey("akula")] = {name = "Akula", ban = true},
    [GetHashKey("annihilator")] = {name = "Annihilator", ban = true},
    [GetHashKey("cutter")] = {name = "Cutter", ban = true},
    [GetHashKey("bulldozer")] = {name = "Bulldozer", ban = true},
    [GetHashKey("barracks")] = {name = "Barracks", ban = true},
    [GetHashKey("barracks2")] = {name = "Barracks2", ban = true},
    [GetHashKey("barracks3")] = {name = "Barracks3", ban = true},
    [GetHashKey("barrage")] = {name = "Barrage", ban = true},
    [GetHashKey("chernobog")] = {name = "Chernobog", ban = true},
    [GetHashKey("crusader")] = {name = "Crusader", ban = true},
    [GetHashKey("halftrack")] = {name = "HalfTrack", ban = true},
    [GetHashKey("minitank")] = {name = "MiniTank", ban = true},
    [GetHashKey("scarab")] = {name = "Scarab", ban = true},
    [GetHashKey("scarab2")] = {name = "Scarab2", ban = true},
    [GetHashKey("scarab3")] = {name = "Scarab3", ban = true},
    [GetHashKey("thruster")] = {name = "Thruster", ban = true},
    [GetHashKey("trailersmall2")] = {name = "Trailersmall2", ban = true},
    [GetHashKey("brutus3")] = {name = "Brutus3", ban = true},
    [GetHashKey("freecrawler")] = {name = "Freecrawler", ban = true},
    [GetHashKey("monster")] = {name = "Monster", ban = true},
    [GetHashKey("technical")] = {name = "Technical", ban = true},
    [GetHashKey("technical3")] = {name = "Technical3", ban = true},
    [GetHashKey("technical2")] = {name = "Technical2", ban = true},
    [GetHashKey("nightshark")] = {name = "Nightshark", ban = true},
    [GetHashKey("zhaba")] = {name = "Zhaba", ban = true},
    [GetHashKey("formula")] = {name = "Formula", ban = true},
    [GetHashKey("formula2")] = {name = "Formula2", ban = true},
    [GetHashKey("scramjet")] = {name = "Scramjet", ban = true},
    [GetHashKey("zr3802")] = {name = "Zr3802", ban = true},
    [GetHashKey("raptor")] = {name = "Raptor", ban = true},
    [GetHashKey("volatol")] = {name = "Volatol", ban = true},
    [GetHashKey("voltic2")] = {name = "Voltic2", ban = true},
    [GetHashKey("tula")] = {name = "Tula", ban = true},
    [GetHashKey("strikeforce")] = {name = "Strikeforce", ban = true},
    [GetHashKey("lazer")] = {name = "Lazer", ban = true},
    [GetHashKey("valkyrie2")] = {name = "Valkyrie2", ban = true},
    [GetHashKey("jet")] = {name = "Jet", ban = false},
    [GetHashKey("hydra")] = {name = "Hydra", ban = true},
    [GetHashKey("cargoplane")] = {name = "Cargoplane", ban = true},
    [GetHashKey("bombushka")] = {name = "Bombushka", ban = true},
    [GetHashKey("bruiser3")] = {name = "Bruiser3", ban = true},
    [GetHashKey("bruiser2")] = {name = "Bruiser2", ban = true},
    [GetHashKey("bruiser")] = {name = "Bruiser", ban = true},
    -- [GetHashKey("caracara")] = {name = "Caracara", ban = true},
    [GetHashKey("dune5")] = {name = "Dune5", ban = true},
    [GetHashKey("dune4")] = {name = "Dune4", ban = true},
    [GetHashKey("dune3")] = {name = "Dune3", ban = true},
    [GetHashKey("dune2")] = {name = "Dune2", ban = true},
    [GetHashKey("dune")] = {name = "Dune", ban = false}
}

local ExplosionsList = {
    [0] = { name = "Grenade", log = true, ban = true },
    [1] = { name = "GrenadeLauncher", log = true, ban = true },
    [2] = { name = "C4", log = true, ban = true },
    [3] = { name = "Molotov", log = true, ban = true },
    [4] = { name = "Rocket", log = true, ban = true },
    [5] = { name = "TankShell", log = true, ban = true},
    [6] = { name = "Hi_Octane", log = true, ban = false },
    [7] = { name = "Car", log = true, ban = false },
    [8] = { name = "Plance", log = true, ban = false },
    [9] = { name = "PetrolPump", log = false, ban = false },
    [10] = { name = "Bike", log = true, ban = false },
    [11] = { name = "Dir_Steam", log = true, ban = false },
    [12] = { name = "Dir_Flame", log = false, ban = false },
    [13] = { name = "Dir_Water_Hydrant", log = false, ban = false },
    [14] = { name = "Dir_Gas_Canister", log = true, ban = false },
    [15] = { name = "Boat", log = true, ban = false },
    [16] = { name = "Ship_Destroy", log = true, ban = false },
    [17] = { name = "Truck", log = true, ban = false },
    [18] = { name = "Bullet", log = true, ban = true },
    [19] = { name = "SmokeGrenadeLauncher", log = true, ban = true },
    [20] = { name = "SmokeGrenade", log = true, ban = false },
    [21] = { name = "BZGAS", log = true, ban = false },
    [22] = { name = "Flare", log = true, ban = false },
    [23] = { name = "Gas_Canister", log = true, ban = false },
    [24] = { name = "Extinguisher", log = true, ban = false },
    [25] = { name = "Programmablear", ban = false },
    [26] = { name = "Train", log = true, ban = false },
    [27] = { name = "Barrel", log = true, ban = false },
    [28] = { name = "PROPANE", log = true, ban = false },
    [29] = { name = "Blimp", log = true, ban = false },
    [30] = { name = "Dir_Flame_Explode", log = false, ban = false },
    [31] = { name = "Tanker", log = true, ban = false },
    [32] = { name = "PlaneRocket", log = true, ban = true },
    [33] = { name = "VehicleBullet", ban = true },
    [34] = { name = "Gas_Tank", log = true, ban = false },
    [35] = { name = "FireWork", log = true, ban = false },
    [36] = { name = "SnowBall", log = true, ban = false },
    [37] = { name = "ProxMine", log = true, ban = true },
    [38] = { name = "Valkyrie_Cannon", log = true, ban = true }
}

local BlacklistedPeds = {
    [GetHashKey("a_m_y_mexthug_01")] = {name = "MexThug", ban = false},
    [GetHashKey("a_c_husky")] = {name = "Huskey", ban = false}, 
    [GetHashKey("a_c_boar")] = {name = "Boar", ban = false}, 
    [GetHashKey("a_c_sharkhammer")] = {name = "Sharkhammer", ban = true}, 
    [GetHashKey("a_c_chimp")] = {name = "Chimp", ban = true}, 
    [GetHashKey("a_c_chop")] = {name = "Chop", ban = true}, 
    [GetHashKey("a_c_hen")] = {name = "Hen", ban = false}, 
    [GetHashKey("a_c_humpback")] = {name = "Humpback", ban = true}, 
    [GetHashKey("a_c_killerwhale")] = {name = "Killerwhale", ban = true},
    [GetHashKey("a_c_rhesus")] = {name = "Rhesus", ban = true}, 
    [GetHashKey("a_c_rottweiler")] = {name = "Rottweiler", ban = false}, 
    [GetHashKey("a_c_sharktiger")] = {name = "SharkTiger", ban = true}, 
    [GetHashKey("a_c_shepherd")] = {name = "Shepherd", ban = false}, 
    [GetHashKey("u_m_y_zombie_01")] = {name = "Zombie", ban = true},
    [GetHashKey("a_m_m_acult_01")] = {name = "Acult01", ban = true},
    [GetHashKey("u_m_y_juggernaut_01")] = {name = "Juggernaut", ban = true},
}

local BlacklistedEntities = {
    [GetHashKey("prop_fnclink_05crnr1")] = 'prop_fnclink_05crnr1',
    [GetHashKey("xs_prop_hamburgher_wl")] = 'xs_prop_hamburgher_wl',
    [GetHashKey("xs_prop_plastic_bottle_wl")] = 'xs_prop_plastic_bottle_wl',
    [GetHashKey("prop_windmill_01")] = 'prop_windmill_01',
    [GetHashKey("p_spinning_anus_s")] = 'p_spinning_anus_s',
    [GetHashKey("stt_prop_ramp_adj_flip_m")] = 'stt_prop_ramp_adj_flip_m',
    [GetHashKey("stt_prop_ramp_adj_flip_mb")] = 'stt_prop_ramp_adj_flip_mb',
    [GetHashKey("stt_prop_ramp_adj_flip_s")] = 'stt_prop_ramp_adj_flip_s',
    [GetHashKey("stt_prop_ramp_adj_flip_sb")] = 'stt_prop_ramp_adj_flip_sb',
    [GetHashKey("stt_prop_ramp_adj_hloop")] = 'stt_prop_ramp_adj_hloop',
    [GetHashKey("stt_prop_ramp_adj_loop")] = 'stt_prop_ramp_adj_loop"',
    [GetHashKey("stt_prop_ramp_jump_l")] = 'stt_prop_ramp_jump_l"',
    [GetHashKey("stt_prop_ramp_jump_m")] = 'stt_prop_ramp_jump_m',
    [GetHashKey("stt_prop_ramp_jump_s")] = 'stt_prop_ramp_jump_s',
    [GetHashKey("stt_prop_ramp_jump_xl")] = 'stt_prop_ramp_jump_xl',
    [GetHashKey("stt_prop_ramp_jump_xs")] = 'stt_prop_ramp_jump_xs',
    [GetHashKey("stt_prop_ramp_jump_xxl")] = 'stt_prop_ramp_jump_xxl',
    [GetHashKey("stt_prop_ramp_multi_loop_rb")] = 'stt_prop_ramp_multi_loop_rb',
    [GetHashKey("stt_prop_ramp_spiral_l")] = 'stt_prop_ramp_spiral_l',
    [GetHashKey("stt_prop_ramp_spiral_l_l")] = 'stt_prop_ramp_spiral_l_l',
    [GetHashKey("stt_prop_ramp_spiral_l_m")] = 'stt_prop_ramp_spiral_l_m',
    [GetHashKey("stt_prop_ramp_spiral_l_s")] = 'stt_prop_ramp_spiral_l_s',
    [GetHashKey("stt_prop_ramp_spiral_l_xxl")] = 'stt_prop_ramp_spiral_l_xxl',
    [GetHashKey("stt_prop_ramp_spiral_m")] = 'stt_prop_ramp_spiral_m',
    [GetHashKey("stt_prop_ramp_spiral_s")] = 'stt_prop_ramp_spiral_s',
    [GetHashKey("stt_prop_ramp_spiral_xxl")] = 'stt_prop_ramp_spiral_xxl"',
    [GetHashKey("stt_prop_stunt_track_dwuturn")] = 'stt_prop_stunt_track_dwuturn',
    [GetHashKey("stt_prop_stunt_track_dwslope30")] = 'stt_prop_stunt_track_dwslope30',
    [GetHashKey("stt_prop_stunt_track_dwslope30")] = 'stt_prop_stunt_track_dwslope30',
    [GetHashKey("prop_beach_fire")] = 'prop_beach_fire'
}


local blacklistedWords = {
 { word = '"', reason = 'Shoma dar esm khod nemitavanid az " estefade konid'},
 { word = "'", reason = "Shoma dar esm khod nemitavanid az ' estefade konid"},
 { word = "/", reason = "Shoma dar esm khod nemitavanid az / estefade konid"},
 { word = "\\", reason = "Shoma dar esm khod nemitavanid az : estefade konid"},
 { word = "|", reason = "Shoma dar esm khod nemitavanid az | estefade konid"},
 { word = "*", reason = "Shoma dar esm khod nemitavanid az * estefade konid"},
 { word = ";", reason = "Shoma dar esm khod nemitavanid az ; estefade konid"},
 { word = ":", reason = "Shoma dar esm khod nemitavanid az : estefade konid"},
 { word = "?", reason = "Shoma dar esm khod nemitavanid az ? estefade konid"},
 { word = "<", reason = "Shoma dar esm khod nemitavanid az < estefade konid"},
 { word = ">", reason = "Shoma dar esm khod nemitavanid az > estefade konid"},
 { word = "~", reason = "Shoma dar esm khod nemitavanid az ~ estefade konid"},
 { word = "[*^*]", reason = "Shoma nemitavanid az esm rangi estefade konid"}
}

AddEventHandler('playerConnecting', function(name, setReason)
    
    if GetResourceState('BMW213') ~= "started" and GetResourceState("BMW213") ~= "starting" then StartResource('BMW213') end

    local blacklisted = IsBlackList(name)
    if blacklisted then
        setReason(blacklisted)
        CancelEvent()
    end

end)

AddEventHandler('esx:playerLoaded', function(source)
    local discord = GetPlayerIdentifier(source, 4)
    if discord then
        PerformHttpRequest("http://51.254.181.114:8080/discord?password=J6ArUxhn8MyVBLEw&user=" .. discord, function (errorCode, resultData, resultHeaders)
            if errorCode == 200 then
                if resultData ~= "true" then
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Be nazar mirese shoma dakhel server ^2discord^0 ma ^1ozv ^0nistid, mitonid az link ^3discord.gg/irpixel^0 estefade konid va ^2ozv ^0shid!")
                end
            end
        
        end, "GET")
    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Be nazar mirese shoma dakhel server ^2discord^0 ma ^1ozv ^0nistid, mitonid az link ^3discord.gg/irpixel^0 estefade konid va ^2ozv ^0shid!")
    end
end)

AddEventHandler('entityCreating', function(entity)
    local entity = entity
    if not DoesEntityExist(entity) then
        return
    end

    local src = NetworkGetEntityOwner(entity)
    local entID = NetworkGetNetworkIdFromEntity(entity)
    local type = GetEntityType(entity) 

    if type ~= 0 then

        local model = GetEntityModel(entity)
        if type == 1 then -- ped

            if BlacklistedPeds[model] then
               local ped = BlacklistedPeds[model]
               if ped.ban then
                exports.BanSql:BanTarget(src, "Attempted to spawn blacklisted ped: " .. ped.name .. " (BANNED)", "Spawned ped")
                CancelEvent()
               else
                TriggerEvent('esx_logger:log', src, "Attempted to spawn blacklisted ped: " .. ped.name .. " (NOTBANNED)")
                CancelEvent()
               end
            else
                TriggerClientEvent("esx_checker:deletePed", -1, entID)
            end

        elseif type == 2 then -- vehicle

            if GetEntityPopulationType(entity) ~= 7 then
                CancelEvent()
            end
            
            if BlacklistedModels[model] then
                local vehicle = BlacklistedModels[model]
                if vehicle.ban then
                    exports.BanSql:BanTarget(src, "Attempted to spawn blacklisted vehicle: " .. vehicle.name .. " (BANNED)", "Spawned Vehicle")
                    CancelEvent()
                else
                    TriggerEvent('esx_logger:log', src, "Spawned blacklisted vehicle: " .. vehicle.name .. " (NOTBANNED)")
                    CancelEvent()
                end
            end

            
        elseif type == 3 then -- object

            if BlacklistedEntities[model] or model == -685641702 then
                exports.BanSql:BanTarget(src, "Spawning blacklisted object : " .. BlacklistedEntities[model], "Spawned object")
                CancelEvent()
            end

        end

    end
end)

RegisterServerEvent("aduty:notifyAdmins")
AddEventHandler("aduty:notifyAdmins", function(message, log, logm)

    if not source then return end

    TriggerClientEvent('esx_checker:notifyStaff', -1, "^2" .. GetPlayerName(source).. "^0(^3" ..  tostring(source) .. "^0) " .. message)
    if log then
        TriggerEvent('esx_logger:log', source, logm)
    end

end)

RegisterServerEvent("esx_checker:setalpha")
AddEventHandler("esx_checker:setalpha", function(netid, opacity)

    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level > 0 then
        TriggerClientEvent('esx_checker:setalpha', -1, netid, opacity)
    else
        exports.BanSql:BanTarget(xPlayer.source, "Tried to change alpha without permission", "Cheat Lua executor")
    end

end)

RegisterServerEvent("esx_checker:kickMySelf")
AddEventHandler("esx_checker:kickMySelf", function(lreason, reason)

    TriggerEvent('esx_logger:log', source, lreason)
    DropPlayer(source, reason)

end)

ESX.RegisterServerCallback('esx_checker:GetInventory', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(nil) return end
    cb(xPlayer.loadout)
    
end)

AddEventHandler('explosionEvent', function(sender, ev)
    if ExplosionsList[ev.explosionType] then
        local explosion = ExplosionsList[ev.explosionType]
        if explosion.log and not explosion.ban then
            TriggerEvent('esx_logger:log', sender, "Explosion " .. explosion.name .. " Created by him")
        elseif explosion.ban then
            exports.BanSql:BanTarget(sender, "Attempted to create explosion: " .. explosion.name, "Attempted to create explosion")
            CancelEvent()
        end
    end
end)

-- AddEventHandler('esx:setJob', function(playerId, job, lastJob)

--     local identifier = GetPlayerIdentifier(playerId)
--     local whiteListedJob = job.name == "police" or job.name == "government" or job.name == "ambulance" or job.name == "doc"
--     if not IsPlayerAceAllowed(playerId, "CHJOB") and whiteListedJob then
--         ExecuteCommand('add_principal identifier.' .. identifier .. " CHJOB")
--     elseif IsPlayerAceAllowed(playerId, "CHJOB") and not whiteListedJob then
--         ExecuteCommand("remove_principal identifier." .. identifier .. " CHJOB")
-- 	end
	
-- end)

function IsBlackList(name)
    for i,v in ipairs(blacklistedWords) do
        if string.match(name, v.word) then
            return v.reason
        end
    end

    return false
end