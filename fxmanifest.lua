fx_version 'cerulean'
game 'gta5'

author 'z1ks'
version '1.0.0'


client_script {
   'client/main.lua',
   'client/utilities.lua',
   'client/camera.lua',
}

shared_script {
   'config.lua'
}

ui_page {
   'web/dist/index.html'
}

files {
   'web/dist/index.html',
   'web/dist/js/*.js',
   'web/dist/css/*.css',
   'web/src/main.js',
   'web/dist/img/*',
}

lua54 'yes'
