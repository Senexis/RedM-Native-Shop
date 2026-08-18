---@class UI_EVENTS : EnumRegistry
---@field GetHash fun(self, id: number): integer|nil
---@field GetIdFromHash fun(self, hash: integer): number|nil
---@field GetNameFromId fun(self, id: number): string|nil
---@field GetIdFromName fun(self, name: string): number|nil
---@field ToString fun(self, id: number): string
local UI_EVENTS = {
    NEW_PAGE                         = 1,
    ITEM_FOCUSED                     = 2,
    ITEM_HOLD_ACTION_CANCELLED       = 3,
    FEED_MESSAGE_INTERACTED          = 4,
    ITEM_SELECTED                    = 5,
    DATA_ADJUSTABLE_CHANGED          = 6,
    DATA_ADJUSTABLE_CHANGED_ABSOLUTE = 7,
    TAB_PAGE_DECREMENT               = 8,
    ITEM_UNFOCUSED                   = 9,
    PAGED_COLLECTION_INITIALIZED     = 10,
    PAGED_COLLECTION_RESET           = 11,
    PAGED_COLLECTION_REQUEST         = 12,
    TAB_PAGE_INCREMENT               = 13,
    NEW_ACTIVITY                     = 14,
}

---@type UI_EVENTS | EnumRegistry
UI_EVENT = Enums.CreateRegistry(UI_EVENTS)

UI_EVENT:AddAttribute("Hash", {
    [UI_EVENTS.NEW_PAGE]                         = `NEW_PAGE`,
    [UI_EVENTS.ITEM_FOCUSED]                     = `ITEM_FOCUSED`,
    [UI_EVENTS.ITEM_HOLD_ACTION_CANCELLED]       = `ITEM_HOLD_ACTION_CANCELLED`,
    [UI_EVENTS.FEED_MESSAGE_INTERACTED]          = `FEED_MESSAGE_INTERACTED`,
    [UI_EVENTS.ITEM_SELECTED]                    = `ITEM_SELECTED`,
    [UI_EVENTS.DATA_ADJUSTABLE_CHANGED]          = `DATA_ADJUSTABLE_CHANGED`,
    [UI_EVENTS.DATA_ADJUSTABLE_CHANGED_ABSOLUTE] = `DATA_ADJUSTABLE_CHANGED_ABSOLUTE`,
    [UI_EVENTS.TAB_PAGE_DECREMENT]               = `TAB_PAGE_DECREMENT`,
    [UI_EVENTS.ITEM_UNFOCUSED]                   = `ITEM_UNFOCUSED`,
    [UI_EVENTS.PAGED_COLLECTION_INITIALIZED]     = `PAGED_COLLECTION_INITIALIZED`,
    [UI_EVENTS.PAGED_COLLECTION_RESET]           = `PAGED_COLLECTION_RESET`,
    [UI_EVENTS.PAGED_COLLECTION_REQUEST]         = `PAGED_COLLECTION_REQUEST`,
    [UI_EVENTS.TAB_PAGE_INCREMENT]               = `TAB_PAGE_INCREMENT`,
    [UI_EVENTS.NEW_ACTIVITY]                     = `NEW_ACTIVITY`,
})
