ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Config = {}

-- priority list can be any identifier. (hex steamid, steamid32, ip) Integer = power over other people with priority
-- a lot of the steamid converting websites are broken rn and give you the wrong steamid. I use https://steamid.xyz/ with no problems.
-- you can also give priority through the API, read the examples/readme.
local loadFile = LoadResourceFile(GetCurrentResourceName(), "./people.json")
local people = json.decode(loadFile)

Config.Priority = {}

MySQL.ready(function()
    local admins = MySQL.Sync.fetchAll('SELECT * FROM users WHERE permission_level > 0')
    for i,v in ipairs(admins) do
        Config.Priority[v.identifier] = v.permission_level
    end

    for i,v in ipairs(people) do
        Config.Priority[v.identifier] = v.perm
    end
end)

RegisterCommand('aqueue', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level >= 10 then

        if not args[1] or not tonumber(args[1]) or not args[2] or not tonumber(args[2]) then
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Syntax vared shode eshtebah ast!")
            return
        end
    
        local target = tonumber(args[1])
        local perm = tonumber(args[2])
    
        local name = GetPlayerName(target)
        if name then
            local identifier = GetPlayerIdentifier(target)
            if not Config.Priority[identifier] then
                table.insert(people, {identifier = identifier, perm = perm})
                SaveResourceFile(GetCurrentResourceName(), "people.json", json.encode(people), -1)
                Config.Priority[identifier] = perm
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^2 " .. name .. "^0 ba priority ^1" .. perm .. "^0 ezafe shod!")
            else
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0In shakhs dar list hast!")
            end
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID vared shode eshtebah ast!")
        end

    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye in dastor ra nadarid!")
    end

end, false)


-- require people to run steam
Config.RequireSteam = true

-- "whitelist" only server
Config.PriorityOnly = false

-- disables hardcap, should keep this true
Config.DisableHardCap = true

-- will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- i have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough
Config.ConnectTimeOut = 600

-- will remove players from queue if the server doesn't recieve a message from them within: __ seconds
Config.QueueTimeOut = 90

-- will give players temporary priority when they disconnect and when they start loading in
Config.EnableGrace = true

-- how much priority power grace time will give
Config.GracePower = 5

-- how long grace time lasts in seconds
Config.GraceTime = 480

-- on resource start, players can join the queue but will not let them join for __ milliseconds
-- this will let the queue settle and lets other resources finish initializing
Config.JoinDelay = 30000

-- will show how many people have temporary priority in the connection message
Config.ShowTemp = true

-- simple localization
Config.Language = {
    joining = "\xF0\x9F\x8E\x89Joining...",
    connecting = "\xE2\x8F\xB3Connecting...",
    idrr = "\xE2\x9D\x97[Queue] Error: Couldn't retrieve any of your id's, try restarting.",
    err = "\xE2\x9D\x97[Queue] There was an error",
    pos = "\xF0\x9F\x90\x8CYou are %d/%d in queue \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[Queue] Error: Error adding you to connecting list",
    timedout = "\xE2\x9D\x97[Queue] Error: Timed out?",
    wlonly = "\xE2\x9D\x97[Queue] You must be whitelisted to join this server",
    steam = "\xE2\x9D\x97 [Queue] Error: Steam must be running"
}