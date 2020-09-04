fx_version 'bodacious'
game 'gta5'

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

server_only 'yes'

server_exports {
	'GeneratePlate'
}

dependencies {
	'essentialmode',
	'mysql_async'
}