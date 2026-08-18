-- DataView implementation for binary data manipulation
-- Based on work by gottfriedleibniz: https://github.com/gottfriedleibniz

---@class DataView
---@field blob string
---@field length number
---@field offset number
---@field cangrow boolean
---@field GetInt8 fun(self, offset: number, endian: boolean|nil): number
---@field SetInt8 fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetUint8 fun(self, offset: number, endian: boolean|nil): number
---@field SetUint8 fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetInt16 fun(self, offset: number, endian: boolean|nil): number
---@field SetInt16 fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetUint16 fun(self, offset: number, endian: boolean|nil): number
---@field SetUint16 fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetInt32 fun(self, offset: number, endian: boolean|nil): number
---@field SetInt32 fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetUint32 fun(self, offset: number, endian: boolean|nil): number
---@field SetUint32 fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetInt64 fun(self, offset: number, endian: boolean|nil): number
---@field SetInt64 fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetUint64 fun(self, offset: number, endian: boolean|nil): number
---@field SetUint64 fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetFloat32 fun(self, offset: number, endian: boolean|nil): number
---@field SetFloat32 fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetFloat64 fun(self, offset: number, endian: boolean|nil): number
---@field SetFloat64 fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetLuaInt fun(self, offset: number, endian: boolean|nil): number
---@field SetLuaInt fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetUluaInt fun(self, offset: number, endian: boolean|nil): number
---@field SetUluaInt fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetLuaNum fun(self, offset: number, endian: boolean|nil): number
---@field SetLuaNum fun(self, offset: number, value: number, endian: boolean|nil): DataView
---@field GetString fun(self, offset: number, endian: boolean|nil): string
---@field SetString fun(self, offset: number, value: string, endian: boolean|nil): DataView
---@field GetFixedString fun(self, offset: number, typelen: number, endian: boolean|nil): string
---@field SetFixedString fun(self, offset: number, typelen: number, value: string, endian: boolean|nil): DataView
---@field GetFixedInt fun(self, offset: number, typelen: number, endian: boolean|nil): number
---@field SetFixedInt fun(self, offset: number, typelen: number, value: number, endian: boolean|nil): DataView
---@field GetFixedUint fun(self, offset: number, typelen: number, endian: boolean|nil): number
---@field SetFixedUint fun(self, offset: number, typelen: number, value: number, endian: boolean|nil): DataView
DataView = setmetatable({
    EndBig = ">",
    EndLittle = "<",
    Types = {
        Int8 = { code = "i1" },
        Uint8 = { code = "I1" },
        Int16 = { code = "i2" },
        Uint16 = { code = "I2" },
        Int32 = { code = "i4" },
        Uint32 = { code = "I4" },
        Int64 = { code = "i8" },
        Uint64 = { code = "I8" },
        Float32 = { code = "f", size = 4 },  -- Float (native size)
        Float64 = { code = "d", size = 8 },  -- Double (native size)

        LuaInt = { code = "j" },             -- lua_Integer
        UluaInt = { code = "J" },            -- lua_Unsigned
        LuaNum = { code = "n" },             -- lua_Number
        String = { code = "z", size = -1, }, -- Zero terminated string
    },

    FixedTypes = {
        String = { code = "c" }, -- Fixed-sized string with n bytes
        Int = { code = "i" },    -- Signed int with n bytes
        Uint = { code = "I" },   -- Unsigned int with n bytes
    },
}, {
    __call = function(_, length)
        return DataView.ArrayBuffer(length)
    end
})
DataView.__index = DataView

---Create an ArrayBuffer with a size in bytes
---@param length number Size in bytes
---@return DataView buffer DataView buffer instance
function DataView.ArrayBuffer(length)
    return setmetatable({
        ---@diagnostic disable-next-line: undefined-field
        blob = string.blob(length),
        length = length,
        offset = 1,
        cangrow = true,
    }, DataView)
end

---Wrap a non-internalized string
---@param blob string Binary data blob
---@return DataView buffer DataView buffer instance
function DataView.Wrap(blob)
    return setmetatable({
        blob = blob,
        length = blob:len(),
        offset = 1,
        cangrow = true,
    }, DataView)
end

---Return the underlying bytebuffer
---@return string blob The binary data
function DataView:Buffer()
    return self.blob
end

---Get the byte length of the buffer
---@return number length Byte length
function DataView:ByteLength()
    return self.length
end

---Get the byte offset of the buffer
---@return number offset Byte offset
function DataView:ByteOffset()
    return self.offset
end

---Create a subview of the current buffer
---@param offset number Offset for the subview
---@param length number|nil Length of the subview (defaults to remaining length)
---@return DataView subview DataView subview instance
function DataView:SubView(offset, length)
    return setmetatable({
        blob = self.blob,
        length = length or self.length,
        offset = 1 + offset,
        cangrow = false,
    }, DataView)
end

---Return the Endianness format character
---@param big boolean|nil True for big endian, false/nil for little endian
---@return string format Endianness format character
local function ef(big)
    return (big and DataView.EndBig) or DataView.EndLittle
end

---Helper function for setting fixed datatypes within a buffer
---@param self DataView DataView instance
---@param offset number Byte offset
---@param value any Value to pack
---@param code string Pack format code
---@return boolean success True if packing succeeded
local function packblob(self, offset, value, code)
    -- If cangrow is false the dataview represents a subview, i.e., a subset
    -- of some other string view. Ensure the references are the same before
    -- updating the subview
    ---@diagnostic disable-next-line: undefined-field
    local ok, packed = pcall(self.blob.blob_pack, self.blob, offset, code, value)
    if not ok then
        local msg = "Failed to pack value: %s at offset: %s with code: %s"
        error(msg:format(tostring(value), tostring(offset), tostring(code)), 3)
        return false
    end

    if self.cangrow or packed == self.blob then
        self.blob = packed
        self.length = packed:len()
        return true
    else
        return false
    end
end

-- Create the API by using DataView.Types
for label, datatype in pairs(DataView.Types) do
    if not datatype.size then -- Cache fixed encoding size
        datatype.size = string.packsize(datatype.code)
    elseif datatype.size >= 0 and string.packsize(datatype.code) ~= datatype.size then
        local msg = "Pack size of %s (%d) does not match cached length: (%d)"
        error(msg:format(label, string.packsize(datatype.code), datatype.size))
        return nil
    end

    DataView["Get" .. label] = function(self, offset, endian)
        offset = offset or 0
        if offset >= 0 then
            local o = self.offset + offset
            ---@diagnostic disable-next-line: undefined-field
            local value, _ = self.blob:blob_unpack(o, ef(endian) .. datatype.code)
            return value
        end
        return nil
    end

    DataView["Set" .. label] = function(self, offset, value, endian)
        if offset >= 0 and value then
            local o = self.offset + offset
            local valueSize = (datatype.size < 0 and value:len()) or datatype.size
            if self.cangrow or ((o + (valueSize - 1)) <= self.length) then
                if not packblob(self, o, value, ef(endian) .. datatype.code) then
                    error("cannot grow subview")
                end
            else
                error("cannot grow dataview")
            end
        end
        return self
    end
end

for label, datatype in pairs(DataView.FixedTypes) do
    datatype.size = -1 -- Ensure cached encoding size is invalidated

    DataView["GetFixed" .. label] = function(self, offset, typelen, endian)
        if offset >= 0 then
            local o = self.offset + offset
            if (o + (typelen - 1)) <= self.length then
                local code = ef(endian) .. "c" .. tostring(typelen)
                ---@diagnostic disable-next-line: undefined-field
                local value, _ = self.blob:blob_unpack(o, code)
                return value
            end
        end
        return nil -- Out of bounds
    end

    DataView["SetFixed" .. label] = function(self, offset, typelen, value, endian)
        if offset >= 0 and value then
            local o = self.offset + offset
            if self.cangrow or ((o + (typelen - 1)) <= self.length) then
                local code = ef(endian) .. "c" .. tostring(typelen)
                if not packblob(self, o, value, code) then
                    error("cannot grow subview")
                end
            else
                error("cannot grow dataview")
            end
        end
        return self
    end
end
