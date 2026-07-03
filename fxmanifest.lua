fx_version 'cerulean'
game 'gta5'

author 'Ster'
description 'ATM Robbery'
version '1.0.0'

lua54 'yes'

client_scripts {
  'client/**/*.lua',
  'client/*.lua'
}

server_scripts {
  'server/**/*.lua',
  'server/*.lua'
}


files {
  'web/dist/**',
}

ui_page 'web/dist/index.html'
