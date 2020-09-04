ESX = nil
-- hidePlayers = {}
labels = {}
netIds = {}
timePlays = {}

TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)

-- RegisterServerEvent('esx_idoverhead:modifyHideOnes')
-- AddEventHandler('esx_idoverhead:modifyHideOnes', function(type, id)

--     if id == nil then return end

-- 	local xPlayer = ESX.GetPlayerFromId(source)

--     if xPlayer.permission_level > 0 then
--         local id = id
--         local identifier = GetPlayerIdentifier(source)

--         if type == "add" then
--             TriggerClientEvent("esx_idoverhead:modifyHides", -1, "add", id)
--             if not hidePlayers[id] then
--                 hidePlayers[id] = id
--                 if not netIds[identifier] then
--                     netIds[identifier] = {}
--                 end
--                 netIds[identifier]["hide"] = id
--             end
--         elseif type == "remove" then
--             TriggerClientEvent("esx_idoverhead:modifyHides", -1, "remove", id)
--             if hidePlayers[id] then
--                 hidePlayers[id] = nil
--                 netIds[identifier]["hide"] = nil
--             end
--         end

-- 	else
-- 		TriggerEvent('esx_logger:log', source, "Attempted to modify hide players")
--         DropPlayer(source, "Jedan chera mikhain to hamechi angosht konin siktir")
-- 	end
-- end)

RegisterServerEvent('esx_idoverhead:changeLabelHideStatus')
AddEventHandler('esx_idoverhead:changeLabelHideStatus', function(id, status)

    if id == nil then return end
    if type(status) ~= "boolean" then return end

	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level > 0 then
        if labels[id] then
            TriggerClientEvent('esx_idoverhead:changeLabelHideStatus', -1, id, status)
        end
	else
		print(('esx_idoverhead: %s attempted to modify label hide status!'):format(xPlayer.identifier))
	end
end)    

RegisterNetEvent('esx_idoverhead:modifyLabel')
AddEventHandler('esx_idoverhead:modifyLabel', function(id, label)

    if id == nil then return end
    if label == nil then return end

    local xPlayer = ESX.GetPlayerFromId(source)

    if label.badge == false then

        if xPlayer.permission_level > 0 then

            if not labels[id] then
                labels[id] = {}
            end

            if DoesTagExist(id, label.badge) then
                RemoveTag(id, label.badge)
            end
            
            if not DoesTagExist(id, label.badge) then
                table.insert(labels[id], label)
                TriggerClientEvent("esx_idoverhead:modifyLabel", -1, id, label)
                AddToNet(xPlayer.source, "label", id)
            else
                print("Error regarding adding admin tag because already exist!")
            end
                
        else
            TriggerEvent('esx_logger:log', source, "Attempted to modify admin labels")
            DropPlayer(source, "Jedan chera mikhain to hamechi angosht konin siktir")
        end

    elseif label.badge == true then
        if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" then

            if not labels[id] then
                labels[id] = {}
            end

            if DoesTagExist(id, label.badge) then
                RemoveTag(id, label.badge)
            end
            
            if not DoesTagExist(id, label.badge) then
                table.insert(labels[id], label)
                TriggerClientEvent("esx_idoverhead:modifyLabel", -1, id, label)
                AddToNet(xPlayer.source, "label", id)
            else
                print("Error regarding adding job tag because already exist!")
            end


        else
            TriggerEvent('esx_logger:log', source, "Attempted to modify job labels")
            DropPlayer(source, "Jedan chera mikhain to hamechi angosht konin siktir")
        end

    end

end)

RegisterNetEvent('esx_idoverhead:removeLabel')
AddEventHandler('esx_idoverhead:removeLabel', function(id, state)

    if id == nil then return end
    if state == nil then return end

    local xPlayer = ESX.GetPlayerFromId(source)

    if state == false then

        if xPlayer.permission_level > 0 then


            if DoesTagExist(id, state) then
                RemoveTag(id, state)
            end
    
            if not DoesTagExist(id, state) then
                TriggerClientEvent('esx_idoverhead:updateLabels', -1, labels)
            end
                
        else
            TriggerEvent('esx_logger:log', source, "Attempted to remove admin labels")
            DropPlayer(source, "Jedan chera mikhain to hamechi angosht konin siktir")
        end

    elseif state == true then

        if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" then

            if DoesTagExist(id, state) then
                RemoveTag(id, state)
            end

            if not DoesTagExist(id, state) then
                TriggerClientEvent('esx_idoverhead:updateLabels', -1, labels)
            end

        else
            TriggerEvent('esx_logger:log', source, "Attempted to remove job labels")
            DropPlayer(source, "Jedan chera mikhain to hamechi angosht konin siktir")
        end

    end

end)

AddEventHandler('esx:playerLoaded', function(source)

    local _source = source
    -- TriggerClientEvent('esx_idoverhead:updateTags', source, hidePlayers)
    TriggerClientEvent('esx_idoverhead:updateLabels', source, labels)

end)

ESX.RegisterServerCallback("esx_idoverhead:retrievePlayTime", function(source, cb)

	local src = source
	local identifier = GetPlayerIdentifier(src)


	MySQL.Async.fetchAll("SELECT timePlay FROM users WHERE identifier = @identifier", { ["@identifier"] = identifier }, function(result)

        if result then

            local timePlayP = result[1].timePlay
            if timePlayP < 43200 then
                cb(true)
            else
                cb(false)
            end

        end

    end)
    
end)


RegisterNetEvent('esx_idoverhead:checkTimePlay')
AddEventHandler('esx_idoverhead:checkTimePlay', function(playerId)

    if source == nil then return end
    if playerId == nil then return end
    local src = source

    if timePlays[playerId] == nil then

        local identifier = GetPlayerIdentifier(src)

        MySQL.Async.fetchAll("SELECT timePlay FROM users WHERE identifier = @identifier", { ["@identifier"] = identifier }, function(result)

            if result then

                local timePlayP = result[1].timePlay
                timePlays[playerId] = {source = src, joinTime = os.time(), timePlay = timePlayP}       
                
                if timePlayP < 43200 then

                    local label = { display = "~y~[Newbie]", height = 1.2, toggle = false, badge = true}
                    addNewPlayer(src, playerId, label)

                else
                    AddToNet(src, "timePlay", playerId)
                end

            end

        end)

    else
        print("LUA EXECUTOR OR A BUG IS HAPPENING!")
        -- TriggerEvent('esx_logger:log', src, "Attempted to modify play time")
        -- DropPlayer(src, "Fix that shit ")
    end

end)


AddEventHandler("playerDropped", function()

    local _source = source
    if _source ~= nil then
        local identifier = GetPlayerIdentifier(_source)

        if netIds[identifier] == nil then
            return
        end

    --    if netIds[identifier].hide ~= nil then
    --         hidePlayers[netIds[identifier].hide] = nil
    --         netIds[identifier]["hide"] = nil
    --         TriggerClientEvent('esx_idoverhead:updateTags', -1, hidePlayers)
    --    end

       if netIds[identifier].label ~= nil then
           labels[netIds[identifier].label] = nil
           netIds[identifier]["label"] = nil
           TriggerClientEvent('esx_idoverhead:updateLabels', -1, labels)
       end
       
       if netIds[identifier].new ~= nil then
            if timePlays[netIds[identifier].new] ~= nil then

                local leaveTime = os.time()
                local saveTime = leaveTime - timePlays[netIds[identifier].new].joinTime

                MySQL.Async.execute('UPDATE users SET timePlay = timePlay + @timePlay WHERE identifier=@identifier', 
                {
                    ['@identifier'] = identifier,
                    ['@timePlay'] = saveTime
                    
                }, function()

                    timePlays[netIds[identifier].new] = nil
                    labels[netIds[identifier].new] = nil
                    netIds[identifier]["new"] = nil
                    TriggerClientEvent('esx_idoverhead:updateLabels', -1, labels)

                end)

            else
                print("There was an error regarding saving play time!")
            end

        elseif netIds[identifier].timePlay ~= nil then


            local leaveTime = os.time()
            local saveTime = leaveTime - timePlays[netIds[identifier].timePlay].joinTime

            MySQL.Async.execute('UPDATE users SET timePlay = timePlay + @timePlay WHERE identifier=@identifier', 
            {
                ['@identifier'] = identifier,
                ['@timePlay'] = saveTime
                
            }, function()

                timePlays[netIds[identifier].timePlay] = nil
                netIds[identifier]["timePlay"] = nil

            end)
            
       end

    end

end)

function addNewPlayer(source, id, label)
    if id == nil then return end
    if label == nil then return end

    if label.badge == true then

        if not labels[id] then
            labels[id] = {}
        end

        if DoesTagExist(id, label.badge) then
            RemoveTag(id, label.badge)
        end
        
        if not DoesTagExist(id, label.badge) then
            table.insert(labels[id], label)
            TriggerClientEvent("esx_idoverhead:modifyLabel", -1, id, label)
            AddToNet(source, "new", id)
        else
            print("Error regarding adding new tag because already exist!")
        end


    else
        TriggerEvent('esx_logger:log', source, "Attempted to modify new labels")
        DropPlayer(source, "Jedan chera mikhain to hamechi angosht konin siktir (#03)")
    end

end

function DoesTagExist(player, badge)
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

function AddToNet(source, netType, id)
    if source == nil then return end
    if netType == nil then return end

    local identifier = GetPlayerIdentifier(source)

    if netIds[identifier] == nil then
        netIds[identifier] = {}
    end

    if netIds[identifier][netType] == nil then
        netIds[identifier][netType] = id
    end 
end