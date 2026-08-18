---@class PROMPTS : EnumRegistry
---@field GetNameFromId fun(self, id: number): string|nil
---@field GetIdFromName fun(self, name: string): number|nil
---@field ToString fun(self, id: number): string
local PROMPTS = {
    SELECT = 1,
    OPTION = 2,
    TOGGLE = 3,
    INFO   = 4,
    ADJUST = 5,
    MODIFY = 6,
    BACK   = 7,
}

---@type PROMPTS | EnumRegistry
PROMPT = Enums.CreateRegistry(PROMPTS)
