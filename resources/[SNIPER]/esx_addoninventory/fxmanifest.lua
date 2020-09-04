fx_version 'bodacious'
game 'gta5'

description 'ESX Addon Inventory'

version '1.1.0'

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'server/classes/addoninventory.lua',
	'server/main.lua'
}

dependency 'essentialmode'