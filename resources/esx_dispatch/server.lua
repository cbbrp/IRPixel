ESX = nil
local badges = {}
local dictonary = {
    ["police"] = "Officers",
    ["mecano"] = "Mechanics",
    ["ambulance"] = "Medics",
    ["doc"] = "Docs",
    ["taxi"] = "Taxi",
    ["government"] = "Karkonan",
    ["coffee"] = "Karkonan"
}

local rankdict = {
    [1] = "^*HELPER",
    [2] = "^*HELPER",
    [3] = "^*ADMIN",
    [4] = "^*SENIOR ADMIN",
    [5] = "^*SENIOR ADMIN",
    [6] = "^*EXECUTIVE ADMIN",
    [9] = "^*MANAGEMENT",
    [10] = "^*DEVELOPER",
    [11] = "^*CoOWNER",
    [12] = "^*OWNER"
}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('flist', function(source, args)
    
        local xPlayer = ESX.GetPlayerFromId(source)
        local onduties = 0
        local offduties = 0
        local total1 = 0

        if dictonary[xPlayer.job.name] then

            local job = xPlayer.job.name
            local xPlayers = ESX.GetPlayers()
            for i=1, #xPlayers, 1 do
                xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                
                if xPlayer.job.name == job then
                    onduties = onduties + 1
                    TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = true, args = {"^4[^2^*On-Duty^4] ^3" .. string.gsub(xPlayer.name, "_", " ") }})
                elseif xPlayer.job.name == 'off' .. job then
                    offduties = offduties + 1
                    TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = true, args = {"^4[^2^*Off-Duty^4] ^3" .. string.gsub(xPlayer.name, "_", " ") }})
                end

            end
            total1 = onduties + offduties
            TriggerClientEvent('esx:showNotification', source, '~h~~g~' .. total1 .. '~w~ '.. dictonary[job] .. ' Online' .. '~n~On Duty: ~g~' .. onduties .. '~w~~n~Off Duty: ~r~' .. offduties)   

        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
        end

    end)

    RegisterCommand('admins', function(source, args)
    
        local xPlayer = ESX.GetPlayerFromId(source)
        local onduties = 0
        local offduties = 0
        local total1 = 0
        local color 
        local admins = exports.esx_scoreboard:GetAdmins()
        
        if TableLength(admins) == 0 then
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Hich admini baraye namayesh vojod nadarad!")
            return
        end

        for k,v in pairs(admins) do
            local xPlayer = ESX.GetPlayerFromId(v.id)
            local aduty = xPlayer.get('aduty')
            if aduty then
                color = "^2"
                onduties = onduties + 1
                TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = true, args = {"^4[" .. color.. rankdict[v.perm] .."^4] ^3" .. GetPlayerName(v.id) }})
            else
                color = "^1"
                offduties = offduties + 1
                TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = true, args = {"^4[" .. color.. rankdict[v.perm] .."^4] ^3" .. GetPlayerName(v.id) }})
            end
        end

        total1 = onduties + offduties
        TriggerClientEvent('esx:showNotification', source,'~h~~g~' .. total1 .. '~w~ Staff Online.' .. '~n~On Duty: ~g~' .. onduties .. '~w~~n~Off Duty: ~r~' .. offduties)   
      
      end)

    RegisterCommand('f', function(source, args)

        local xPlayer = ESX.GetPlayerFromId(source)
    
        if xPlayer.job.name == "police" or xPlayer.job.name == "offpolice" or xPlayer.job.name == "psuspend" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "offambulance" or xPlayer.job.name == "mecano" or xPlayer.job.name == "offmecano" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" or xPlayer.job.name == "offdoc" or string.lower(xPlayer.gang.name) == "mafia" then
            if not args[1] then
                return
            end
    
                local dutytext = nil
                local job = xPlayer.job.name
                local jobGrade = xPlayer.job.grade_label
                local name = GetPlayerName(source)
                local message = table.concat(args, " ")
                

                if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "mecano" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then
                    dutytext = "^4[^2^*On-Duty ^4| ^1^*"
                elseif xPlayer.job.name == "offpolice" or xPlayer.job.name == "offambulance" or xPlayer.job.name == "offmecano" or xPlayer.job.name == "offdoc" then
                    dutytext = "^4[^2^*Off-Duty ^4| ^1^*"
                elseif xPlayer.job.name == "psuspend" then
                    dutytext = "^4[^2^*Suspended ^4| ^1^*"
                end
    
                local xPlayers = ESX.GetPlayers()
                for i=1, #xPlayers do
                    local tplayer = ESX.GetPlayerFromId(xPlayers[i])
                    if tplayer.job.name == job or tplayer.job.name == "off" .. job then
                        TriggerClientEvent('chatMessage', xPlayers[i], "", {255, 0, 0}, dutytext .. "^1" ..jobGrade .. "^4]: ^3" .. name .. " ^4(( " .. "^0^*" .. message .. "^4 ))")
                    end
                end
            
    
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
        end
    
    end)


    RegisterCommand("r", function(source, args)
        local freq = exports.mumble_voip:GetRadioChannel(source)
        if freq ~= 0 then
            if not args[1] then
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat message chizi vared nakardid!")
                return
            end
            
            local message = table.concat(args, " ", 1)
            TriggerClientEvent("sendProximityMessageradio",-1, source, "^4[^2^*Radio^4] ^3" .. source .." ^8^*: ^r", "^0^* " .. message , false)
            TriggerClientEvent('rp_radio:recieveMessage', -1, {id = source, freq = freq, message = message})

        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Lotfan radio khod ra roshan konid!")
        end
    end, false)

    RegisterCommand("sr", function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == "police" or xPlayer.job.name == "mecano" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" then
            if not args[1] then
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid payam khali befrestid!")
                return
            end

            if xPlayer.job.grade >= 4 then
                local name = string.gsub(xPlayer.name, "_", " ")
                local job = xPlayer.job.name
                local jobGrade = xPlayer.job.grade_label
                local message = table.concat(args, " ", 1)
    
                TriggerClientEvent("sendProximityMessageradio",-1, source, "^4[^2^*Radio^4] ^3" .. name.." ^8^*: ^r", "^0^* " .. message , false)
    
                local xPlayers = ESX.GetPlayers()
                for i=1, #xPlayers do
                    local tplayer = ESX.GetPlayerFromId(xPlayers[i])
                    if tplayer.job.name == job then
                        TriggerClientEvent('InteractSound_CL:PlayOnOne', tplayer.source, 'pager', 1.0)
                        TriggerClientEvent('chatMessage', tplayer.source, "", {255, 0, 0}, "^4[^2^*Radio ^4| ^1^*".. jobGrade .. "^4] ^3" .. name.." ^8^*^~>>^r" .. "^2^* " .. message)
                    end
                end
            else
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
            end

        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Ozv hich organ dolati nistid!")
        end
    end, false)

    RegisterCommand("dep", function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == "police"  or xPlayer.job.name == "mecano" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "doc" then
            if not args[1] then
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid payam khali befrestid!")
                return
            end

            local name = string.gsub(xPlayer.name, "_", " ")
            local job  = string.upper(xPlayer.job.name)
            local message = table.concat(args, " ", 1)

            TriggerClientEvent("sendProximityMessageradio",-1, source, "^4[^2^*Radio^4] ^3" .. name.." ^8^*: ^r", "^0^* " .. message , false)

            local xPlayers = ESX.GetPlayers()
            for i=1, #xPlayers do
                local tplayer = ESX.GetPlayerFromId(xPlayers[i])
                if tplayer.job.name == "police" or tplayer.job.name == "mecano" or tplayer.job.name == "ambulance" or tplayer.job.name == "government" or tplayer.job.name == "doc" then
                    TriggerClientEvent('chatMessage', tplayer.source, "", {255, 0, 0}, "^4[^2^*Department ^4| ^1^*".. job .. "^4] ^3" .. name.." ^8^*:^r" .. "^0^* " .. message)
                end
            end

        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Ozv hich organ dolati nistid!")
        end
    end, false)


    RegisterCommand('badge', function(source)

        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" then
            
                local identifier = xPlayer.identifier

                if not badges[identifier] then
                    badges[identifier] = {badge = 0, hide = false, isOn = false}
                end

                local badge = badges[identifier].badge

                if badge == 0 then
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma badge nadarid!")
                    return
                end

                local color
                if xPlayer.job.name == "police" then
                    color = "~b~"
                elseif xPlayer.job.name == "ambulance" then
                    color = "~r~" 
                end

                local label = {display = color .. "#" .. tostring(badge) .. " " .. xPlayer.job.grade_label, height = 1.15, toggle = false, badge = true}
                TriggerClientEvent('esx_dispatch:assignBadge', source, label)
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma badge khod ra gozashtid!")
                badges[identifier].isOn = true
            
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Ozv hich organ dolati nistid!")
        end
        
    end, false)

    RegisterCommand('tbadge', function(source)

        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" then
           
            local identifier = xPlayer.identifier
            local badge = badges[identifier]
            if badge.isOn then

                local color
                if xPlayer.job.name == "police" then
                    color = "~b~"
                elseif xPlayer.job.name == "ambulance" then
                    color = "~r~" 
                end
                
                if badge.hide then
                    badges[identifier].hide = false
                    local label = {display = color .. "#" .. tostring(badge.badge) .. " " .. xPlayer.job.grade_label, height = 1.15, toggle = false, badge = true}
                    TriggerClientEvent('esx_dispatch:assignBadge', source, label)
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma badge khod ra gozashtid!")
                else
                    badges[identifier].hide = true
                    local label = {display = color .. "#" .. tostring(badge.badge) .. " " .. xPlayer.job.grade_label, height = 1.15, toggle = true, badge = true}
                    TriggerClientEvent('esx_dispatch:assignBadge', source, label)
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma badge khod ra bardashtid!")
                end
                
            else
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Badge shoma roshan nist!")
            end
            
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Ozv hich organ dolati nistid!")
        end
        
    end, false)

    RegisterCommand('assign', function(source, args)

        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" then

            local perm
            if xPlayer.job.name == "police" then
                perm = 6
            elseif xPlayer.job.name == "ambulance" then
                perm = 3
            end

            if perm > xPlayer.job.grade then
                if not xPlayer.hasDivision("hr") then
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Dastresi shoma baraye in dastor kafi nist!")
                    return
                end
            end

            if not args[1] then 
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID chizi vared nakardid!")
                return
            end
    
            if not tonumber(args[1]) then 
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
                return
            end
    
            if not args[2] then 
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat badge chizi vared nakardid!")
                return
            end
    
            if not tonumber(args[2]) then 
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat badge faghat mitavanid adad vared konid!")
                return
            end
    
            if string.len(args[2]) > 4 then
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Badge nemitavanad bishtar az 4 ragham bashad!")
                return
            end

            local target = tonumber(args[1])
            local zPlayer = ESX.GetPlayerFromId(target)
        
            if not zPlayer then
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID playe rmored nazar sahih nist!")
                return
            end

            if zPlayer.job.name == xPlayer.job.name then
                if badges[zPlayer.identifier] then
                    badges[zPlayer.identifier].badge = tonumber(args[2])
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma badge ^3 " .. string.gsub(zPlayer.name, "_", " ") .. "^0 ra be ^2" .. args[2] .. "^0 taghir dadid!")
                    TriggerClientEvent('chatMessage', zPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Badge shoma be ^1 " .. args[2] .. "^0 taghir yaft!")
                else
                    badges[zPlayer.identifier] = {badge = tonumber(args[2]), hide = false, isOn = false}
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma badge ^3 " .. string.gsub(zPlayer.name, "_", " ") .. "^0 ra be ^2" .. args[2] .. "^0 taghir dadid!")
                    TriggerClientEvent('chatMessage', zPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Badge shoma be ^1 " .. args[2] .. "^0 taghir yaft!")
                end
            else
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Fard mored nazar ham shoghl shoma nist!")
            end
            
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Ozv hich organ dolati nistid!")
        end
        
    end, false)

    AddEventHandler('esx:playerLoaded', function(source)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "offambulance" or xPlayer.job.name == "offpolice" then

            MySQL.Async.fetchAll("SELECT badge FROM users WHERE identifier = @identifier", { ["@identifier"] = xPlayer.identifier }, function(result)

                if result then
        
                    local badge = result[1].badge
                    badges[xPlayer.identifier] = {badge = badge, hide = false, isOn = false}

        
                else
                    print('Moshkeli dar gereftan badge ' .. GetPlayerName(_source) .. ' pish amad lotfan peygiri konid!')
                end
        
            end)
        
        end
    
    end)

    AddEventHandler('playerDropped', function()
	
        local _source = source

            if _source ~= nil then
                local identifier = GetPlayerIdentifier(_source)

                if badges[identifier] then
                    local badgeN = badges[identifier].badge

                    MySQL.Async.execute('UPDATE users SET badge = @badge WHERE identifier=@identifier', 
                    {
                        ['@identifier'] = identifier,
                        ['@badge'] = badgeN
                        
                    }, function(rowsChanged)
    
                        if rowsChanged == 0 then
                            print('Moshkeli dar save kardan badge ' .. GetPlayerName(_source) .. ' pish amad lotfan peygiri konid!')
                            return
                        end

                        badges[identifier] = nil
    
                    end)

                    
                end
    
            end
    
    end)
    

    RegisterCommand("invite", function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = xPlayer.job.name
        if job == "police" or job == "ambulance" then
            if job == "police" then
                if xPlayer.hasDivision("hr") then
                    if not args[1] then
                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID chizi vared nakardid!")
                       return
                    end

                    if not tonumber(args[1]) then
                         TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid")
                        return
                    end

                    local target = tonumber(args[1])

                    local zPlayer = ESX.GetPlayerFromId(target)
                    
                    if zPlayer then
                        if zPlayer.job.name == "unemployed" then
                            zPlayer.setJob(job, 0)
                            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ba movafaghiat ^3" .. string.gsub(zPlayer.source, "_", " ") .. "^0 ra estekhdam kardid!")
                            TriggerClientEvent('chatMessage', zPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma be estekhdam ^2police ^0 darmadid!")
                        else
                            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid yek fard shaghel ra estekhdam konid!")
                        end
                    else
                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID vared shode eshtebah ast")
                    end
                else
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Dastresi shoma baraye estefade az in dastor kafi nist!")
                end
            elseif job == "ambulance" then
                if xPlayer.job.grade >= 5 then
                    if not args[1] then
                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID chizi vared nakardid!")
                       return
                    end

                    if not tonumber(args[1]) then
                         TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid")
                        return
                    end

                    local target = tonumber(args[1])

                    local zPlayer = ESX.GetPlayerFromId(target)
                    
                    if zPlayer then
                        if zPlayer.job.name == "unemployed" then
                            zPlayer.setJob(job, 0)
                            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ba movafaghiat ^3" .. string.gsub(zPlayer.source, "_", " ") .. "^0 ra estekhdam kardid!")
                            TriggerClientEvent('chatMessage', zPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma be estekhdam ^2Medic ^0 darmadid!")
                        else
                            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid yek fard shaghel ra estekhdam konid!")
                        end
                    else
                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID vared shode eshtebah ast")
                    end

                else
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Dastresi shoma baraye estefade az in dastor kafi nist!")
                end
            end
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Dastresi shoma baraye estefade az in dastor kafi nist!")
        end
    end, false)

function TableLength(table)

    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count

end