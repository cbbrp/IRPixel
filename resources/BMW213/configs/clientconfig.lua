ChocoHaxCc = {}

ChocoHaxCc.GeneralStuff = false -- Includes: NO INFINITE AMMO, NO GODMODE, NO ANTI RUNOFF

--//Anti GodMode//--
ChocoHaxCc.AntiGodMode = false-- Master switch for AntiGodMode
    ChocoHaxCc.AntiGodModeTimer = 20000 -- AntiGodMode Timer, default: 200000 / 20 seconds, it does the check every x ms
    ChocoHaxCc.AntiGodModeDemiGod = false -- Detects a player that get detected with demigod during the check (DO NOT USE THIS ON VRP)
    ChocoHaxCc.MaxPlayerHealth = 200 -- Max player health
    ChocoHaxCc.AntiGodModeKick = false -- Kick the AntiGodMode detected player
    ChocoHaxCc.AntiGodModeBan = false -- Ban the AntiGodMode detected player

--//Anti AdminStuff//--
ChocoHaxCc.AntiPlayerBlips = false -- Detects a user that activated Player Blips and is not allowed
ChocoHaxCc.AntiSpectate = false -- Detects a user that is spectating someone else and is not allowed
                                           
--//Automatic Model Deleter//-- This script is going to delete any BLACKLISTED Model (NOT RECOMMENDED FOR LOW-END/LOW SERVERS) (blacklistedmodels.lua)
ChocoHaxCc.AutomaticMDModel = false
ChocoHaxCc.AutomaticMDEntity = false
ChocoHaxCc.AutomaticMDPeds = false
    ChocoHaxCc.AutomaticMDTimer = 7500 -- Timer default: 7500 / 7.5 seconds (lower the timer/higher the load aka. lag)

--//Anti Cheat Engine//--
ChocoHaxCc.AntiDamageModifier = false -- Detects if a player tries to modify his damage or defence value

ChocoHaxCc.AntiWeaponManipulator = false -- MasterSwitch for weapon damange modifier
    ChocoHaxCc.AntiWeaponDamageModifier = false -- Detects if a player tried to modify the weapon damage
    ChocoHaxCc.AntiExplosiveWeapons = false -- Detects if a player modified his weapon to shoot explosive bullets, or explosive punch
    ChocoHaxCc.WeaponDamagesTable = {
    [-1357824103] = 34, -- AdvancedRifle
    [453432689] = 26, -- Pistol
    [1593441988] = 27, -- CombatPistol
    [584646201] = 25, -- APPistol
    [-1716589765] = 51, -- Pistol50
    [-1045183535] = 160, -- Revolver
    [-1076751822] = 28, -- SNSPistol
    [-771403250] = 40, -- HeavyPistol
    [137902532] = 34, -- VintagePistol
    [324215364] = 21, -- MicroSMG
    [736523883] = 22, -- SMG
    [-270015777] = 23, -- AssaultSMG
    [-1121678507] = 22, -- MiniSMG
    [-619010992] = 27, -- MachinePistol
    [171789620] = 28, -- CombatPDW
    [487013001] = 29, -- PumpShotgun
    [2017895192] = 40, -- SawnoffShotgun
    [-494615257] = 32, -- AssaultShotgun
    [-1654528753] = 14, -- BullpupShotgun
    [984333226] = 117, -- HeavyShotgun
    [-1074790547] = 30, -- AssaultRifle
    [-2084633992] = 32, -- CarbineRifle
    [-1063057011] = 32, -- SpecialCarbine
    [2132975508] = 32, -- BullpupRifle
    [1649403952] = 34, -- CompactRifle
    [-1660422300] = 40, -- MG
    [2144741730] = 45, -- CombatMG
    [1627465347] = 34, -- Gusenberg
    [100416529] = 101, -- SniperRifle
    [205991906] = 216, -- HeavySniper
    [-952879014] = 65, -- MarksmanRifle
    [1119849093] = 30, -- Minigun
    [-1466123874] = 165, -- Musket
    [911657153] = 1, -- StunGun
    [1198879012] = 10, -- FlareGun
    [-598887786] = 220, -- MarksmanPistol
    [1834241177] = 30, -- Railgun
    [-275439685] = 30, -- DoubleBarrelShotgun
    [-1746263880] = 81, -- Double Action Revolver
    [-2009644972] = 30, -- SNS Pistol Mk II
    [-879347409] = 200, -- Heavy Revolver Mk II
    [-1768145561] = 32, -- Special Carbine Mk II
    [-2066285827] = 33, -- Bullpup Rifle Mk II
    [1432025498] = 32, -- Pump Shotgun Mk II
    [1785463520] = 75, -- Marksman Rifle Mk II
    [961495388] = 40, -- Assault Rifle Mk II
    [-86904375] = 33, -- Carbine Rifle Mk II
    [-608341376] = 47, -- Combat MG Mk II
    [177293209] = 230, -- Heavy Sniper Mk II
    [-1075685676] = 32, -- Pistol Mk II
    [2024373456] = 25, -- SMG Mk II
    }

ChocoHaxCc.AntiVehicleHashChanger = false -- Detects if a player tried to change his vehicle hash model

ChocoHaxCc.AntiModelChanger = false -- Detects if a player tried to change his model to a blacklisted model
    ChocoHaxCc.AntiModelChangerTable = {
	"s_m_y_swat_01",
	"a_m_y_mexthug_01", 
    "a_c_cat_01", 
    "a_c_boar", 
    "a_c_sharkhammer", 
    "a_c_coyote", 
    "a_c_chimp",  
    "a_c_cow", 
    "a_c_deer", 
    "a_c_dolphin", 
    "a_c_fish", 
    "a_c_hen", 
    "a_c_humpback", 
    "a_c_killerwhale", 
    "a_c_mtlion",
    "a_c_rabbit_01",  
    "a_c_rhesus",  
    "a_c_sharktiger", 
	"u_m_y_zombie_01"
}

--//Resource Injection Protection//--
--<<ANTI RESTART BOOLS>> (DO NOT RESTART SCRIPTS IF YOU ENALBED THESE!!!)
ChocoHaxCc.ResourceCounter = true -- This script will check if a player have a diffrent amount of resources
ChocoHaxCc.AntiResourceRestart = true -- This scripts will check if a player tries to restart scripts
ChocoHaxCc.AntiResourceStop = true -- This script will check if a player tries to STOP a script
ChocoHaxCc.AntiFCommands = true -- This script will check if a player injected custom commands into the server