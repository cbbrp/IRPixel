fx_version 'bodacious'
game 'gta5'

description 'Gang Account'

version '1.0.1'

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'server/classes/addonaccount.lua',
	'server/main.lua'
}

dependency 'essentialmode'