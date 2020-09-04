ChocoHaxCs = {}

--//LoliHunter//--
ChocoHaxCs.ConfigVersion = 8 -- Don't touch, it's better
ChocoHaxCs.License = "293035901515464705dfwm"
ChocoHaxCs.DiscordWebhookLink = "https://discordapp.com/api/webhooks/663755961118359562/_hI6N97hzH7WYPADXVizVkoBPwAC6_54Cz02wdmSPooxTuiZgizKaboz1U4r-1agvq3I"

--//Log System//--
ChocoHaxCs.ConsoleLog = true -- This will log on console warnings/kicks/bans/infos
ChocoHaxCs.DiscordLog = true -- This will log on discord webhook warnings/kicks/bans/infos
ChocoHaxCs.ChatLog = false -- This will log on ingame chat FOR ALL PLAYERS warnings/kicks/bans

--//Chat Control Stuff//--
ChocoHaxCs.BlacklistedWordsDetection = false -- Detects and log the player that tried to say something blacklisted (configs/blacklistedwords.lua)
ChocoHaxCs.BlacklistedWordsKick = false -- Kick the player that tried to say a blacklisted word (require BlacklistedWordsDetection = true)
ChocoHaxCs.BlacklistedWordsBan = false -- Ban the player that tried to say a blacklisted word (require BlacklistedWordsDetection = true)

--//Default Stuff//--
ChocoHaxCs.TriggerDetection = true -- Kick the player that tried to execute or call a blacklisted trigger (remember to edit or obfuscate your original triggers), this will find all newbie cheaters/skids

--//Ban System//--
ChocoHaxCs.GlobalBan = false -- This on true will use the Global Ban List (All verified detected cheaters are on that list) HIGHLY RECOMMENDED!
ChocoHaxCs.BanSystem = false -- This on false will disable the ChocoHax's Ban System

--//Kick Message//--
ChocoHaxCs.KickMessage = "Shoma tavasot anticheat kick shodid, dar sorati ke fekr mikonid eshtebah shode dar discord ticket baz konid!" -- You can edit this UwU

--//Anti Explosion System (tables are in tables folder)//--
ChocoHaxCs.DetectExplosions = false -- Automatically detect blacklisted explosions from (tables/blacklistedexplosions.lua)

--//Anti Blacklisted Models//--
ChocoHaxCs.BlacklistedWeapons = true
ChocoHaxCs.KawaiiFuckMethod = false

--//Permission System//-- DO NOT TOUCH IF YOU DON'T KNOW WHAT ARE U DOING 
ChocoHaxCs.Bypass = {"chocohaxadministrator","chocohaxmoderator"} -- This will allow the user with these perms to bypass Violation detections such as mod menus/weapons/godmode, etc.
ChocoHaxCs.AdminMenu = {"chocohaxadministrator"} -- This will allow the user with these perms to load the ChocoMenu.
ChocoHaxCs.Spectate = {"chocohaxadministrator","chocohaxmoderator"} -- This will allow the user with these perms to spectate other users.
ChocoHaxCs.Blips = {"chocohaxadministrator","chocohaxmoderator","chocohaxjobs"} -- This will allow the user with these perms to use Player Blips.