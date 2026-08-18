Enums = {}

---@class EnumRegistry
---@field protected _names table<integer, string>
---@field protected _attributes table<string, table<integer, any>>
---@field protected _revAttributes table<string, table<any, integer>>
---@field Cases fun(self: table): table<number, string>
---@field Values fun(self: table): number[]
---@field Has fun(self: table, name: string): boolean
---@field Pluck fun(self: table, attrName: string, keyName: string?): table
---@field GetName fun(self: table, id: number): string|nil
---@field GetIdFromName fun(self: table, name: string): number|nil
---@field ToString fun(self: table, id: number): string
local EnumRegistry = {}
EnumRegistry.__index = EnumRegistry

local function getRegistry(t)
    local mt = getmetatable(t)
    if mt and mt.__index then
        return mt.__index
    end
    return t
end

---@generic T : table
---@param enumTable T
---@return T | EnumRegistry
function Enums.CreateRegistry(enumTable)
    local names = {}
    for name, id in pairs(enumTable) do
        names[id] = name
    end

    local instance = setmetatable({
        _names = names,
        _attributes = {},
        _revAttributes = {},
    }, EnumRegistry)

    setmetatable(enumTable, {
        __index = instance,
    })

    instance:AddAttribute("Name", names)

    return enumTable
end

function EnumRegistry:GetProp(id, attrName)
    if attrName == "Id" then return id end

    local attrTable = self._attributes[attrName]
    if not attrTable then return nil end

    return attrTable[id]
end

function EnumRegistry:GetIdByProp(value, attrName)
    if attrName == "Id" then return value end

    local revTable = self._revAttributes[attrName]
    if not revTable then return nil end

    return revTable[value]
end

function EnumRegistry:Pluck(attrName, keyName)
    local result = {}
    local reg = getRegistry(self)

    for id in pairs(reg._names) do
        local v = reg:GetProp(id, attrName)
        if not keyName then
            if v ~= nil then table.insert(result, v) end
        else
            local k = reg:GetProp(id, keyName)
            if k ~= nil and v ~= nil then result[k] = v end
        end
    end

    return result
end

function EnumRegistry:AddAttribute(attrName, data)
    self._attributes[attrName] = data

    local reverse = {}
    for id, value in pairs(data) do
        if value ~= nil then
            reverse[value] = id
        end
    end
    self._revAttributes[attrName] = reverse

    self["Get" .. attrName] = function(t, id)
        local reg = getRegistry(t)
        return reg:GetProp(id, attrName)
    end

    self["GetIdFrom" .. attrName] = function(t, value)
        local reg = getRegistry(t)
        return reg:GetIdByProp(value, attrName)
    end
end

function EnumRegistry:AddModeAttribute(attrName, modeMappedData)
    self._attributes[attrName] = modeMappedData

    local reverseMap = {}
    for modeId, data in pairs(modeMappedData) do
        reverseMap[modeId] = {}
        for id, value in pairs(data) do
            if value ~= nil then reverseMap[modeId][value] = id end
        end
    end
    self._revAttributes[attrName] = reverseMap

    self["Get" .. attrName] = function(t, id)
        local reg = getRegistry(t)
        return reg:GetProp(id, attrName)
    end

    self["GetIdFrom" .. attrName] = function(t, value)
        local reg = getRegistry(t)
        return reg:GetIdByProp(value, attrName)
    end
end

function EnumRegistry:Cases()
    local reg = getRegistry(self)
    return reg._names
end

function EnumRegistry:Values()
    local reg = getRegistry(self)
    local values = {}
    for id in pairs(reg._names) do
        table.insert(values, id)
    end
    return values
end

function EnumRegistry:Has(name)
    return rawget(self, name) ~= nil
end

function EnumRegistry:ToString(id)
    local reg = getRegistry(self)
    local name = reg._names[id]
    return name or ("UNKNOWN(%s)"):format(id)
end
