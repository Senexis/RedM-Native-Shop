fx_version "cerulean"
rdr3_warning "I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships."
game "rdr3"

name "Native Shop"
author "Senexis <https://github.com/Senexis>"
description "A full implementation of the truly native shop UI"
version "1.0.0"
repository "https://github.com/Senexis/RedM-Native-Shop"
license "GNU GPL v3"

client_scripts {
    -- Load modules in dependency order
    "client/util_dataview.lua",
    "client/util_items.lua",
    "client/util_ticker.lua",
    "client/util_toasts.lua",
    "client/shop_events.lua",
    "client/shop_navigator.lua",
    "client/shop_ui.lua",
    "client/shop_data.lua",
    "client/res_events.lua",
    "client/res_exports.lua",

    -- Optional demonstration menus
    "shops/**/*.lua"
}
