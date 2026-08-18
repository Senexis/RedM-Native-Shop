Outfit = {}
Outfit.__index = Outfit

-- ===================================================================
-- Private Helper Functions
-- ===================================================================

---Resolves a value to a numeric hash
---@param value number|string
---@return number
local function _resolveHash(value)
    if type(value) == "number" then
        return value
    elseif type(value) == "string" then
        if value:sub(1, 2) == "0x" then
            return tonumber(value) or 0
        end
        return joaat(value)
    end
    return 0
end

function Outfit.new(data)
    local self = setmetatable({}, Outfit)

    -- Pre-hash all fields for performance
    self.outfitType = _resolveHash(data.outfit_type)
    self.partial = data.partial == true
    self.partialType = _resolveHash(data.partial_type)
    self.swatchItem = _resolveHash(data.swatch_item)
    self.playerType = _resolveHash(data.player_type)

    -- Process components: hash both key (type) and value (drawable/item)
    self.components = {}
    if data.components then
        for compType, compValue in pairs(data.components) do
            local typeHash = _resolveHash(compType)
            local valueHash = _resolveHash(compValue)
            self.components[typeHash] = valueHash
        end
    end

    return self
end

-- Getters
function Outfit:getOutfitType()
    return self.outfitType
end

function Outfit:isPartial()
    return self.partial
end

function Outfit:getPartialType()
    return self.partialType
end

function Outfit:getSwatchItem()
    return self.swatchItem
end

function Outfit:getPlayerType()
    return self.playerType
end

-- Returns the table of [componentHash] = drawableHash
function Outfit:getComponents()
    return self.components
end

-- Helper to get a specific component value by its name or hash
function Outfit:getComponentValue(compName)
    local hash = _resolveHash(compName)
    return self.components[hash]
end
