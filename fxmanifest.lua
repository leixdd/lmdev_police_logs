fx_version 'adamant'

game 'gta5'

description 'LMDEV ESX Police Job Logs '

version '1.0'

ui_page 'html/ui.html'


files {
	'html/ui.html',
	'html/style.css',
	'html/app.js',
	'html/img.js',
	'html/header.jpg',
	'html/searchicon.png',
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'server/server.lua',
}

dependencies {
	'es_extended',
	'esx_policejob'
}
