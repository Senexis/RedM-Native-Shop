fx_version "cerulean"
rdr3_warning "I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships."
game "rdr3"

name "Native Shop"
author "Senexis <https://github.com/Senexis>"
description "A full implementation of the truly native shop UI"
version "1.0.0"
repository "https://github.com/Senexis/RedM-Native-Shop"
license "GNU GPL v3"

file_set 'outfits' {
    "data/outfits_male.json",
    "data/outfits_female.json",
}

client_scripts {
    -- Utilities
    "client/utils/dataview.lua",
    "client/utils/**/*.lua",

    -- Enums and constants
    "client/constants/**/*.lua",

    -- Load configuration
    "client/config.lua",

    -- Load modules in dependency order
    "client/shop/validator.lua",
    "client/shop/events.lua",
    "client/shop/navigator.lua",
    "client/shop/ui.lua",
    "client/shop/data.lua",

    -- External-facing
    "client/external/**/*.lua",

    -- External API, this is what you import
    "client/api.lua",

    -- Optional demonstration menus
    "shops/**/*.lua"
}
