ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local logs = "https://discordapp.com/api/webhooks/661594336890191883/w0en1am-TPhfiDArDe08KTqYVshYM6WvabXrG7gf6wJLkXJKOCSyM_dYvXzmNBQc3pbW"
local alogs = "https://discordapp.com/api/webhooks/663755961118359562/_hI6N97hzH7WYPADXVizVkoBPwAC6_54Cz02wdmSPooxTuiZgizKaboz1U4r-1agvq3I"
local infologs = "https://discordapp.com/api/webhooks/685505917378494696/8BhuHaRyJDT_zP7GX_osT6VdQEkzfmT6r8Fm67_0qfeSF4pW5bKnM3Jp4H6ZdIyZmza5"
local ganglog = "https://discordapp.com/api/webhooks/703803987463372952/_9aNdpYUWgYdzw_x3H6v_6rW8qnngVLnOViXJO-Bzp3cfANoSLhETdL88nL_DMWwP_rG"
local homelog = "https://discordapp.com/api/webhooks/703816159212077096/-tgQbCgyOfB0Q0OAPfQkvztHAr8vn9YBwOSiUp3o8wRCZ8LeABBLfoiQTgvg614VWxWt"
local trunklog = "https://discordapp.com/api/webhooks/709692361747464212/nUMwfE3fm-oc77AB5RTgRGt8c9nkgcJf1vB0HdCRR9EyuyGa-1Uv8_yj9Th5AIIO3jvr"
local atmlog = "https://discordapp.com/api/webhooks/677038663955120128/o4jTribqap7EOENj7jO6idw-g4t7jOGFeDYRS08Q8tUh9wSpY2CnkCou75U9-S3w8WI1"
local roblog = "https://discordapp.com/api/webhooks/662584244790624256/kQfYCl8zi2STeQSfoMAWeUIDjnnw9_9YwHpuS6BK5lmzUqa4AbTFmEPDx8EfJ5Y-SXMB"
local communityname = "SNIPER log"
local communtiylogo = "https://cdn.discordapp.com/avatars/669212511551356929/590b49403f8d721d6c0311718518ac29.png?size=16" --Must end with .png

RegisterServerEvent("esx_logger:log")
AddEventHandler("esx_logger:log", function(src, reason)

    local source = src
    local name = GetPlayerName(source)
    local ip = GetPlayerEndpoint(source)
    local ping = GetPlayerPing(source)
    local steamhex = GetPlayerIdentifier(source)

    local disconnect = {
            {
                ["color"] = "16711680",
                ["title"] = "Violation has been detected",
                ["description"] = "**Player:** ".. name .." | " .. exports.essentialmode:IcName(source) .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\nReason: **"..reason.."**\nIP: **"..ip.."**\nID: **" .. source .. "**\nSteam Hex: **"..steamhex.."**\n**Discord:** " .. GetDiscord(source) .. "",
                ["footer"] = {
                    ["text"] = "Violation Log",
                    ["icon_url"] = communtiylogo,
                },
            }
        }
    
    PerformHttpRequest(alogs, function(err, text, headers) end, 'POST', json.encode({username = "Violation Log", embeds = disconnect}), { ['Content-Type'] = 'application/json' })

end)

RegisterServerEvent("esx_logger:log2")
AddEventHandler("esx_logger:log2", function(src, info)
    local source = src
    local name = GetPlayerName(source)

    local disconnect = {
            {
                ["color"] = "16711680",
                ["title"] = "Purge Details",
                ["description"] = info.iniator .. " has been requested by **".. name .."** (" .. GetDiscord(source) .. ")\n Weapon: **" .. info.weapon.. "**\nTotal users: **"..info.utotal.."**, Total users had that weapon: **" .. info.udtotal .. "**\nTotal vehicles: **"..info.vtotal.."**, Total vehicles had that weapon: **" .. info.vdtotal .. "**\nTotal properties: **"..info.ptotal.."**, Total properties had that weapon: **" .. info.pdtotal .. "**\nTotal gangs: **"..info.gtotal.."**, Total gangs had that weapon: **" .. info.gdtotal .. "**\nTotal weapons: **" .. info.dtotal .."**",
                ["footer"] = {
                    ["text"] = "Purge Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }
    
    PerformHttpRequest(infologs, function(err, text, headers) end, 'POST', json.encode({username = "Purge Handler", embeds = disconnect}), { ['Content-Type'] = 'application/json' })

end)

RegisterServerEvent("esx_logger:log3")
AddEventHandler("esx_logger:log3", function(src, info)
    local source = src
    local name = GetPlayerName(source)

    local disconnect = {
            {
                ["color"] = "16711680",
                ["title"] = "Purge Details",
                ["description"] = "Count wave has been requested by **".. name .."** (" .. GetDiscord(source) .. ")\n Type: " .. info.type .. "\n Owner: " .. info.owner,
                ["footer"] = {
                    ["text"] = "Purge Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }
    
    PerformHttpRequest(infologs, function(err, text, headers) end, 'POST', json.encode({username = "Purge Handler", embeds = disconnect}), { ['Content-Type'] = 'application/json' })

end)

function GangLog(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)

    local color
    if info.type == "Gozasht" then color = "51712" elseif info.type == "Bardasht" then color = "15852071" end

    local details = {
            {
                ["color"] = color,
                ["title"] = "Gang Log",
                ["description"] = "**Person:** ".. name ..", " .. info.icname .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n **Gang:** " .. info.gang  .."\n **Type:** " .. info.type .. "\n **Esm:** " .. info.name .. "\n **Tedad:** " .. info.count,
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }
    
    PerformHttpRequest(ganglog, function(err, text, headers) end, 'POST', json.encode({username = "Gang Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function HomeLog(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)

    local color
    if info.type == "Gozasht" then color = "51712" elseif info.type == "Bardasht" then color = "15852071" end

    local details = {
            {
                ["color"] = color,
                ["title"] = "Home Log",
                ["description"] = "**Person:** ".. name ..", " .. info.icname .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n **Type:** " .. info.type .. "\n **Esm:** " .. info.name .. "\n **Tedad:** " .. info.count,
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }
    
    PerformHttpRequest(homelog, function(err, text, headers) end, 'POST', json.encode({username = "Home Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function TrunkLog(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)
    
    local color
    if info.type == "Gozasht" then color = "51712" elseif info.type == "Bardasht" then color = "15852071" end

    local details = {
            {
                ["color"] = color,
                ["title"] = "Trunk Log",
                ["description"] = "**Person:** ".. name .." | " .. info.icname .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n **Type:** " .. info.type .. "\n**Plate:** " .. info.plate .. "\n**Esm:** " .. info.name .. "\n **Tedad:** " .. info.count,
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }
    
    PerformHttpRequest(trunklog, function(err, text, headers) end, 'POST', json.encode({username = "Trunk Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function TransActionLog(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)
    
    local color
    if info.type == "Variz" then color = "51712" elseif info.type == "Bardasht" then color = "15852071" end

    local details = {
            {
                ["color"] = color,
                ["title"] = "Transaction Log",
                ["description"] = "**Type:** " .. info.type .. "\n**Person:** ".. name .." | " .. exports.essentialmode:IcName(source) .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n**Amount:** " .. info.amount .. "$\n**Identifier:** " .. GetPlayerIdentifier(source),
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }
    
    PerformHttpRequest(atmlog, function(err, text, headers) end, 'POST', json.encode({username = "Transaction Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function TransferLog(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)
    local target = tonumber(info.target)
    local tname = GetPlayerName(info.target)

    local details = {
            {
                ["color"] = "2868934",
                ["title"] = "Transaction Log",
                ["description"] = "**Type:** " .. info.type .. "\n**Person:** ".. name .." | " .. exports.essentialmode:IcName(source) .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n**Target:** ".. tname .." | " .. exports.essentialmode:IcName(target) .. " (" .. GetDiscord(target) .. ") **[" .. target .."]**\n**Amount:** " .. info.amount .. "$\n**Identifier:** " .. GetPlayerIdentifier(source) .. "\n**Tidentifier:** " .. GetPlayerIdentifier(target),
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }
    
    PerformHttpRequest(atmlog, function(err, text, headers) end, 'POST', json.encode({username = "Transaction Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function RobLog(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)
    
    local color
    if info.type == "Shop" then color = "1883948" elseif info.type == "Jewels" then color = "14610984" elseif info.type == "Bank" then color = "16187398" end
    local amount
    if info.amount then amount = "\n **Amount:** " .. info.amount .. "$" else amount = "" end

    local details = {
            {
                ["color"] = color,
                ["title"] = "Rob Log",
                ["description"] = "**Person:** ".. name .." | " .. exports.essentialmode:IcName(source) .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n **Type:** " .. info.type .. "\n**Action:** " .. info.action .. "\n**Location:** " .. info.location .. "\n**Time:** " .. Date() .. amount,
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }
    
    PerformHttpRequest(roblog, function(err, text, headers) end, 'POST', json.encode({username = "Rob Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function RobLogF(info)
    local color
    if info.type == "Shop" then color = "1883948" elseif info.type == "Jewels" then color = "14610984" elseif info.type == "Bank" then color = "16187398" end

    local details = {
            {
                ["color"] = color,
                ["title"] = "Rob Log",
                ["description"] = "**Person:** ".. info.name .." | " .. info.icname .. " (" .. info.discord .. ") **[" .. info.source .."]**\n **Type:** " .. info.type .. "\n**Action:** " .. info.action .. "\n**Location:** " .. info.location .. "\n**Time:** " .. Date(),
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }
    
    PerformHttpRequest(roblog, function(err, text, headers) end, 'POST', json.encode({username = "Rob Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function Date()
    local date = os.date('*t')
	
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    
    return '`' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`'
end

function GetDiscord(target)
    local discord
    for k,v in ipairs(GetPlayerIdentifiers(target)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = string.gsub(v, "discord:", "")
           return "<@" .. discord .. ">"
        end
    end

    return "N/A"
end