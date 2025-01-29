------------------------------------
-- http://scripts.perrituber.xyz/ --
------------------------------------

fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'PerriTuber'
description 'A script to give away a starter car to your players using metadata'

client_scripts {
    'Client/client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'Server/main.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'Config.lua'
}
