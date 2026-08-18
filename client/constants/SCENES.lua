---@class SCENES : EnumRegistry
---@field GetNameFromId fun(self, id: number): string|nil
---@field GetIdFromName fun(self, name: string): number|nil
---@field ToString fun(self, id: number): string
local SCENES = {
    BOUNTY_MANAGEMENT             = 1,
    CLOTHING_MODIFY               = 2,
    CLOTHING_STAT_INFO_BOX        = 3,
    HORSE_MANAGEMENT              = 4,
    HORSE_STAT_INFO_BOX           = 5,
    ITEM_GRID                     = 6,
    ITEM_LIST                     = 7,
    ITEM_LIST_COLOUR_PALETTE      = 8,
    ITEM_LIST_DESCRIPTION         = 9,
    ITEM_LIST_HORSE_STATS         = 10,
    ITEM_LIST_RECIPES             = 11,
    ITEM_LIST_RPG_STATS           = 12,
    ITEM_LIST_SLIDER              = 13,
    ITEM_LIST_TEXTURE_DESCRIPTION = 14,
    ITEM_LIST_VEHICLE_STATS       = 15,
    ITEM_LIST_WEAPON_STATS        = 16,
    ITEM_SELL_LIST_HORSE_STATS    = 17,
    MENU_LIST                     = 18,
    MENU_LIST_HORSE_STATS         = 19,
    MENU_LIST_WEAPON_STATS        = 20,
    MENU_STYLE_SELECTOR           = 21,
    SADDLE_MANAGEMENT             = 22,
    VEHICLE_MANAGEMENT            = 23,
    WEAPON_MANAGEMENT             = 24,
}

---@type SCENES | EnumRegistry
SCENE = Enums.CreateRegistry(SCENES)
