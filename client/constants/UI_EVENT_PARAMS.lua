---@class UI_EVENT_PARAMS : EnumRegistry
---@field GetHash fun(self, id: number): integer|nil
---@field GetPrompt fun(self, id: number): integer|nil
---@field GetIdFromHash fun(self, hash: integer): number|nil
---@field GetNameFromId fun(self, id: number): string|nil
---@field GetIdFromName fun(self, name: string): number|nil
---@field ToString fun(self, id: number): string
local UI_EVENT_PARAMS = {
    BYPASS            = 1,
    ENTRY             = 2,
    EXIT              = 3,
    HAIR_STEPPER      = 4,
    NEXT_PAGE         = 5,
    NEXT_SCENE        = 6,
    PALETTE_FOCUS     = 7,
    PALETTE_FOCUSLESS = 8,
    PREV_SCENE        = 9,
    SECONDARY_SELECT  = 10,
    SELECT            = 11,
    SELECT_INFO       = 12,
    SELECT_MODIFY     = 13,
    SELECT_OPTION     = 14,
    SELECT_TOGGLE     = 15,
    STEPPER           = 16,
}

---@type UI_EVENT_PARAMS | EnumRegistry
UI_EVENT_PARAM = Enums.CreateRegistry(UI_EVENT_PARAMS)

UI_EVENT_PARAM:AddAttribute("Hash", {
    [UI_EVENT_PARAMS.BYPASS]            = `GENERIC_SHOP_UI_BYPASS`,
    [UI_EVENT_PARAMS.ENTRY]             = `GENERIC_SHOP_UI_ENTRY`,
    [UI_EVENT_PARAMS.EXIT]              = `GENERIC_SHOP_UI_EXIT`,
    [UI_EVENT_PARAMS.HAIR_STEPPER]      = `GENERIC_SHOP_UI_HAIR_STEPPER`,
    [UI_EVENT_PARAMS.NEXT_PAGE]         = `GENERIC_SHOP_UI_NEXT_PAGE`,
    [UI_EVENT_PARAMS.NEXT_SCENE]        = `GENERIC_SHOP_UI_NEXT_SCENE`,
    [UI_EVENT_PARAMS.PALETTE_FOCUS]     = `GENERIC_SHOP_UI_PALETTE_FOCUS`,
    [UI_EVENT_PARAMS.PALETTE_FOCUSLESS] = `GENERIC_SHOP_UI_PALETTE_FOCUSLESS`,
    [UI_EVENT_PARAMS.PREV_SCENE]        = `GENERIC_SHOP_UI_PREV_SCENE`,
    [UI_EVENT_PARAMS.SECONDARY_SELECT]  = `GENERIC_SHOP_UI_SECONDARY_SELECT`,
    [UI_EVENT_PARAMS.SELECT]            = `GENERIC_SHOP_UI_SELECT`,
    [UI_EVENT_PARAMS.SELECT_INFO]       = `GENERIC_SHOP_UI_SELECT_INFO`,
    [UI_EVENT_PARAMS.SELECT_MODIFY]     = `GENERIC_SHOP_UI_SELECT_MODIFY`,
    [UI_EVENT_PARAMS.SELECT_OPTION]     = `GENERIC_SHOP_UI_SELECT_OPTION`,
    [UI_EVENT_PARAMS.SELECT_TOGGLE]     = `GENERIC_SHOP_UI_SELECT_TOGGLE`,
    [UI_EVENT_PARAMS.STEPPER]           = `GENERIC_SHOP_UI_STEPPER`,
})

UI_EVENT_PARAM:AddAttribute("Prompt", {
    [UI_EVENT_PARAMS.EXIT]             = PROMPT.BACK,
    [UI_EVENT_PARAMS.SECONDARY_SELECT] = PROMPT.SELECT,
    [UI_EVENT_PARAMS.SELECT]           = PROMPT.SELECT,
    [UI_EVENT_PARAMS.SELECT_INFO]      = PROMPT.INFO,
    [UI_EVENT_PARAMS.SELECT_MODIFY]    = PROMPT.MODIFY,
    [UI_EVENT_PARAMS.SELECT_OPTION]    = PROMPT.OPTION,
    [UI_EVENT_PARAMS.SELECT_TOGGLE]    = PROMPT.TOGGLE,
    [UI_EVENT_PARAMS.STEPPER]          = PROMPT.ADJUST,
})
