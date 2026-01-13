fx_version "cerulean"
rdr3_warning "I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships."
game "rdr3"

name "Native Shop"
author "Senexis <https://github.com/Senexis>"
description "A full implementation of the truly native shop UI"
version "1.0.0"
repository "https://github.com/Senexis/RedM-Native-Shop"
license "GNU GPL v3"

-- Load modules in dependency order
client_scripts {
    "client/dataview.lua",
    "client/itemdatabase.lua",
    "client/ticker.lua",
    "client/toast.lua",

    "client/events.lua",
    "client/navigation.lua",
    "client/ui.lua",
    "client/shop.lua",

    "client/shops/*.lua"
}
