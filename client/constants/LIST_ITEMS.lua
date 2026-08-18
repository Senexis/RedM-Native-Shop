---@class LIST_ITEMS : EnumRegistry
---@field GetHash fun(self, id: number): integer|nil
---@field GetPrompt fun(self, id: number): integer|nil
---@field GetIdFromHash fun(self, hash: integer): number|nil
---@field GetNameFromId fun(self, id: number): string|nil
---@field GetIdFromName fun(self, name: string): number|nil
---@field ToString fun(self, id: number): string
local LIST_ITEMS = {
    BUSINESS  = 1,
    COUPON    = 2,
    HAIR      = 3,
    INVENTORY = 4,
    PALETTE   = 5,
    STABLE    = 6,
    STEPPER   = 7,
    TEXT      = 8,
    SWATCH    = 9,
}

---@type LIST_ITEMS | EnumRegistry
LIST_ITEM = Enums.CreateRegistry(LIST_ITEMS)

LIST_ITEM:AddAttribute("Hash", {
    [LIST_ITEMS.BUSINESS]  = `GSUI_BUSINESS_LIST_ITEM`,
    [LIST_ITEMS.COUPON]    = `GSUI_COUPON_LIST_ITEM`,
    [LIST_ITEMS.HAIR]      = `GSUI_HAIR_LIST_ITEM`,
    [LIST_ITEMS.INVENTORY] = `GSUI_INVENTORY_LIST_ITEM`,
    [LIST_ITEMS.PALETTE]   = `GSUI_PALETTE_LIST_ITEM`,
    [LIST_ITEMS.STABLE]    = `GSUI_STABLE_LIST_ITEM`,
    [LIST_ITEMS.STEPPER]   = `GSUI_STEPPER_LIST_ITEM`,
    [LIST_ITEMS.TEXT]      = `GSUI_TEXT_LIST_ITEM`,
    [LIST_ITEMS.SWATCH]    = `GSUI_SWATCH_LIST_ITEM`,
})
