fx_version 'bodacious'
game 'gta5'

client_script {
	"client.lua"
}

server_script {
	'@mysql_async/lib/MySQL.lua',
	"server.lua"
}


-- {
-- 	"display": "Police",
-- 	"subMenu": [
-- 		{
-- 			"title": "Envoyer un message",
-- 			"eventName": "esx_addons_gcphone:call",
-- 			"type": {
-- 				"number": "police"
-- 			}
-- 		}
-- 	]
-- }