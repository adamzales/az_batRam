fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'adamzales'
description 'script na beranidlo'


dependency 'ox_lib'
dependency 'ox_target'
dependency 'ox_doorlock'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}

client_scripts {
	'client/client.lua',
}

shared_scripts{
	'@ox_lib/init.lua',
	'config.lua'
}

data_file 'DLC_ITYP_REQUEST' 'stream/beranidlo.ytyp'
