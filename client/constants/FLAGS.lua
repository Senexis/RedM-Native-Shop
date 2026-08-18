---@class FLAGS : EnumRegistry
---@field GetNameFromId fun(self, id: number): string|nil
---@field GetIdFromName fun(self, name: string): number|nil
---@field ToString fun(self, id: number): string
local FLAGS = {
    FOCUSED                 = 1 << 1,
    PALETTE_CHANGED         = 1 << 2,
    ITEM_SELECTED           = 1 << 3,
    NEXT_ACTIVITY           = 1 << 4,
    NEXT_PAGE               = 1 << 5,
    FILTER_CHANGED          = 1 << 6,
    NEXT_SCENE              = 1 << 7,
    PREV_SCENE              = 1 << 8,
    EXIT                    = 1 << 9,
    STATE_CHANGED           = 1 << 10,
    NEW_COLLECTION          = 1 << 12,
    COLLECTION_REQUEST      = 1 << 13,
    STEPPER_DELTA_CHANGE    = 1 << 14,
    UNFOCUSED               = 1 << 15,
    STEPPER_ABSOLUTE_CHANGE = 1 << 16,
    TOAST_INTERACTION       = 1 << 17,
}

---@type FLAGS | EnumRegistry
FLAG = Enums.CreateRegistry(FLAGS)
