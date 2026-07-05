fx_version 'cerulean'
game 'gta5'

author 'Ster'
description 'ATM Robbery'
version '1.0.0'

lua54 'yes'

client_scripts {
  'client/main.lua',
}

server_scripts {
  'server/main.lua',
}

shared_scripts {
  '@qb-core/shared/locale.lua',
  'shared/config.lua',
}

files {
  'ui/build/**',
  'ui/build/index.html',
}

ui_page 'ui/build/index.html'
