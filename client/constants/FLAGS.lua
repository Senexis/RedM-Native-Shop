---@class FLAGS : EnumRegistry
---@field GetNameFromId fun(self, id: number): string|nil
---@field GetIdFromName fun(self, name: string): number|nil
---@field ToString fun(self, id: number): string
local FLAGS = {
    UI_ENTRY                = 1 << 1,
    UI_BYPASS               = 1 << 2,
    FOCUSED                 = 1 << 3,
    PALETTE_CHANGED         = 1 << 4,
    ITEM_SELECTED           = 1 << 5,
    NEXT_ACTIVITY           = 1 << 6,
    NEXT_PAGE               = 1 << 7,
    FILTER_CHANGED          = 1 << 8,
    NEXT_SCENE              = 1 << 9,
    PREV_SCENE              = 1 << 10,
    EXIT                    = 1 << 11,
    STATE_CHANGED           = 1 << 12,
    NEW_COLLECTION          = 1 << 13,
    COLLECTION_REQUEST      = 1 << 14,
    STEPPER_DELTA_CHANGE    = 1 << 15,
    UNFOCUSED               = 1 << 16,
    STEPPER_ABSOLUTE_CHANGE = 1 << 17,
    TOAST_INTERACTION       = 1 << 18,
}

---@type FLAGS | EnumRegistry
FLAG = Enums.CreateRegistry(FLAGS)
