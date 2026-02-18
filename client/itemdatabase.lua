---@class ItemDatabase
---@field hash number The numeric hash of the item
---@field _info table|nil Cached item info
---@field _tags table|nil Cached tag IDs mapped to their Tag Type
---@field _effects table|nil Cached effect data
---@field _uiData table|nil Cached UI data
ItemDatabase = {}
ItemDatabase.__index = ItemDatabase

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

---Checks if a string pointer is null or empty
local function _isStringNullOrEmpty(stringPtr)
    if not stringPtr or stringPtr == 0 then return true end
    local success = pcall(function()
        Citizen.InvokeNative(0x2CF12F9ACF18F048, stringPtr, Citizen.ResultAsInteger()) -- IS_STRING_NULL_OR_EMPTY
    end)
    return not success
end

---Reads a string from a pointer
local function _readString(stringPtr)
    if not stringPtr or stringPtr == 0 then return "" end
    Citizen.InvokeNative(0xDFFC15AA63D04AAB, stringPtr)                       -- _SET_LAUNCH_PARAM_STRING
    return Citizen.InvokeNative(0xC59AB6A04333C502, Citizen.ResultAsString()) -- _GET_LAUNCH_PARAM_STRING
end

-- ===================================================================
-- Constructor
-- ===================================================================

---Creates a new ItemDatabase instance for a specific item
---@param item number|string The item hash or name
---@return ItemDatabase|nil
function ItemDatabase.new(item)
    local hash = _resolveHash(item)

    -- Validate that the item exists in the game files
    if ItemdatabaseIsKeyValid(hash, 0) ~= 1 then
        return nil
    end

    local self = setmetatable({}, ItemDatabase)
    self.hash = hash

    -- Initialize caches as nil (Lazy Loading)
    self._info = nil
    self._tags = nil
    self._effects = nil
    self._uiData = nil

    return self
end

-- ===================================================================
-- Internal Lazy Loaders (Populate Cache)
-- ===================================================================

function ItemDatabase:_ensureInfo()
    if self._info then return end

    local struct = DataView.ArrayBuffer(256)

    -- ITEMDATABASE_FILLOUT_ITEM_INFO
    if not Citizen.InvokeNative(0xFE90ABBCBFDC13B2, self.hash, struct:Buffer()) then
        self._info = {}
        return
    end

    self._info = {
        key = struct:GetInt32(0),
        category = struct:GetInt32(8),
        group = struct:GetInt32(16),
        flags = struct:GetInt32(24),
        model = struct:GetInt32(32),
        priorityaccess = struct:GetInt32(40),
        bundle = struct:GetInt32(48),
    }
end

function ItemDatabase:_ensureTags()
    if self._tags then return end

    local structData = DataView.ArrayBuffer(256)
    local structCount = DataView.ArrayBuffer(8)

    -- _ITEMDATABASE_FILLOUT_TAG_DATA
    Citizen.InvokeNative(0x5A11D6EEA17165B0, self.hash, structData:Buffer(), structCount:Buffer(), 20)

    local count = structCount:GetInt32(0)
    self._tags = {}

    for i = 0, count - 1 do
        local tagId = structData:GetInt32(16 * i + 8)
        local tagType = structData:GetInt32(16 * i + 16)

        -- Store the Tag Type as the value for filtering purposes
        self._tags[tagId] = tagType
    end
end

function ItemDatabase:_ensureUiData()
    if self._uiData then return end

    local struct = DataView.ArrayBuffer(2048)
    struct:SetInt32(8 * 2, 5)
    struct:SetInt32(8 * 18, 8)

    -- _ITEMDATABASE_FILLOUT_UI_DATA
    if not Citizen.InvokeNative(0xB86F7CC2DC67AC60, self.hash, struct:Buffer()) then
        self._uiData = {}
        return
    end

    local data = {
        labelHash = struct:GetInt32(0),
        descHash = struct:GetInt32(8),
        localization = {},
        textures = {},
    }

    for i = 0, 4 do
        local offset = 24 + (i * 8 * 3)

        if struct:GetUint8(offset) == 0 then
            break
        end

        local texturePtr = struct:GetInt64(offset)
        if not _isStringNullOrEmpty(texturePtr) then
            local texture = _readString(texturePtr)
            local textureDict = _readString(struct:GetInt64(offset + 8))
            local textureType = struct:GetInt32(offset + 16)

            data.textures[textureType] = {
                dict = textureDict,
                name = texture,
            }
        else
            break
        end
    end

    for i = 0, 7 do
        local offset = 152 + (i * 8 * 2)

        local type = struct:GetInt32(offset + 8)
        if type == 0 then break end

        local first = struct:GetInt32(offset)
        local total = ItemdatabaseLocalizationGetNumValues(self.hash, type)

        if total <= 1 then
            -- Minor optimization: Avoid making extra calls if there is only one value
            data.localization[type] = first
        else
            -- If there's more than one value, we need to read them all into an array
            local entries = {}
            for j = 0, total - 1 do
                local value = ItemdatabaseLocalizationGetValue(self.hash, type, j)
                table.insert(entries, value)
            end

            data.localization[type] = entries
        end
    end

    self._uiData = data
end

function ItemDatabase:_ensureEffects()
    if self._effects then return end

    local structIds = DataView.ArrayBuffer(256)
    structIds:SetInt32(8, 20)

    -- _ITEMDATABASE_FILLOUT_ITEM_EFFECT_IDS
    Citizen.InvokeNative(0x9379BE60DC55BBE6, self.hash, structIds:Buffer())

    local count = structIds:GetInt32(0)
    self._effects = {}

    for i = 0, count - 1 do
        local effectId = structIds:GetInt32(16 + 8 * i)
        local structInfo = DataView.ArrayBuffer(256)

        -- ITEMDATABASE_FILLOUT_ITEM_EFFECT_ID_INFO
        Citizen.InvokeNative(0xCF2D360D27FD1ABF, effectId, structInfo:Buffer())

        table.insert(self._effects, {
            id = structInfo:GetInt32(0),
            type = structInfo:GetInt32(8),
            value = structInfo:GetInt32(16),
            time = structInfo:GetInt32(24),
            timeUnits = structInfo:GetInt32(32),
            corePercent = structInfo:GetFloat32(40),
            durationCategory = structInfo:GetInt32(48),
        })
    end
end

-- ===================================================================
-- Public Getters
-- ===================================================================

---Gets the raw item info structure
---@return table
function ItemDatabase:GetInfo()
    self:_ensureInfo()
    return self._info or {}
end

---Gets the raw UI data structure
---@return table
function ItemDatabase:GetUiData()
    self:_ensureUiData()
    return self._uiData or {}
end

---Gets the localization text for a specific type
---@param filter string|number The localization type hash or name
---@return number The localized text
function ItemDatabase:GetLocalization(filter)
    local ui = self:GetUiData()
    local targetHash = _resolveHash(filter)

    local entry = ui.localization[targetHash]
    if type(entry) == "table" then
        return entry[1] -- Return the first entry if it's a table
    end

    return entry
end

---Gets all localization entries for a specific type as a table
---@param filter string|number The localization type hash or name
---@return table A table of localization entries
function ItemDatabase:GetMultiLocalization(filter)
    local ui = self:GetUiData()
    local targetHash = _resolveHash(filter)

    local entries = ui.localization[targetHash]
    if type(entries) ~= "table" then
        return { entries } -- Wrap single entry in a table for consistency
    end

    return entries
end

---Gets the localized label text
---@param useAlt boolean|nil If true, will return the alternative label if it exists
---@return string
function ItemDatabase:GetLabel(useAlt)
    if useAlt and self:GetAltLabelHash() ~= 0 then
        return self:GetAltLabel()
    end
    local ui = self:GetUiData()
    if ui.labelHash then
        return GetStringFromHashKey(ui.labelHash)
    end
    return ""
end

---Gets the raw label text hash
---@param useAlt boolean|nil If true, will return the alternative label hash if it exists
---@return number
function ItemDatabase:GetLabelHash(useAlt)
    if useAlt and self:GetAltLabelHash() ~= 0 then
        return self:GetAltLabelHash()
    end
    local ui = self:GetUiData()
    return ui.labelHash or 0
end

---Gets the localized alternative label text
---@return string
function ItemDatabase:GetAltLabel()
    local altLabelHash = self:GetLocalization(`LABEL_TYPE_ALT_NAME`)
    if altLabelHash and altLabelHash ~= 0 then
        return GetStringFromHashKey(altLabelHash)
    end
    return ""
end

---Gets the raw alternative label text hash
---@return number
function ItemDatabase:GetAltLabelHash()
    return self:GetLocalization(`LABEL_TYPE_ALT_NAME`) or 0
end

---Gets the localized description text
---@param useAlt boolean|nil If true, will return the alternative description if it exists
---@return string
function ItemDatabase:GetDescription(useAlt)
    if useAlt and self:GetAltDescriptionHash() ~= 0 then
        return self:GetAltDescription()
    end
    local ui = self:GetUiData()
    if ui.descHash then
        return GetStringFromHashKey(ui.descHash)
    end
    return ""
end

---Gets the raw description text hash
---@param useAlt boolean|nil If true, will return the alternative description hash if it exists
---@return number
function ItemDatabase:GetDescriptionHash(useAlt)
    if useAlt and self:GetAltDescriptionHash() ~= 0 then
        return self:GetAltDescriptionHash()
    end
    local ui = self:GetUiData()
    return ui.descHash or 0
end

---Gets the localized alternative description text
---@return string
function ItemDatabase:GetAltDescription()
    local altDescHash = self:GetLocalization(`LABEL_TYPE_ALT_DESC`)
    if altDescHash and altDescHash ~= 0 then
        return GetStringFromHashKey(altDescHash)
    end
    return ""
end

---Gets the raw alternative description text hash
---@return number
function ItemDatabase:GetAltDescriptionHash()
    return self:GetLocalization(`LABEL_TYPE_ALT_DESC`) or 0
end

---Gets the texture dictionary and name for a specific texture type.
---@param type string|number|nil The texture type hash or name (e.g., INVENTORY, LIST_LAYOUT). If nil, defaults to INVENTORY.
---@return string|nil txd, string|nil txn
function ItemDatabase:GetTexture(type)
    if not type then type = `INVENTORY` end

    local ui = self:GetUiData()
    local targetHash = _resolveHash(type)

    local texData = ui.textures[targetHash]
    if texData then
        return texData.dict, texData.name
    end

    return nil, nil
end

---Gets the texture dictionary and name for an item's swatch
---@param index number|nil The swatch index in the swatch texture dictionary
---@return string|nil txd, string|nil txn
function ItemDatabase:GetSwatchTexture(index)
    -- Items can have predetermined swatch textures (e.g., weapon components)
    local listTxd, listTxn = self:GetTexture(`LIST_LAYOUT`)
    if listTxd and listTxn then return listTxd, listTxn end

    -- If we are not given an index, don't try to generate a swatch texture
    if not index then return nil, nil end

    -- From this point on, we are going to use the swatch texture dict, so validate the index
    if index < 0 then error("Swatch index cannot be negative") end

    -- The item to use for swatch generation can be overriden in the case of outfits
    local item = self.hash

    if self:IsOutfit() then
        -- Outfit items aren't supported yet
        return nil, nil
    end

    -- Generate the swatch texture, depending on if this item is makeup or not
    if self:IsMakeup() then
        local tint = VarString(10, "LITERAL_STRING", "Metaped_tint_Generic_clean");
        local type = VarString(10, "LITERAL_STRING", "UIsw_flat_ck000");

        local struct = DataView.ArrayBuffer(128)
        struct:SetInt64(2 * 8, BigInt(tint, true), true)
        struct:SetInt64(1 * 8, BigInt(type, true), true)
        struct:SetInt64(3 * 8, BigInt(item, true), true)
        struct:SetInt64(4 * 8, BigInt(item, true), true)
        struct:SetInt64(5 * 8, BigInt(item, true), true)

        -- _GENERATE_SWATCH_TEXTURE_DIRECTLY
        Citizen.InvokeNative(0x646ED1A1D28487DF, index, struct:Buffer())
    else
        local pedType = self:GetPedType()
        GenerateSwatchTexture(index, item, pedType, true)
    end

    return "SwatchTxd", string.format("slot%02d", index)
end

---Gets the item category hash
---@return number
function ItemDatabase:GetCategory()
    self:_ensureInfo()
    return self._info and self._info.category or 0
end

---Checks whether the item is in a specific category
---@param category number|string The category hash or name to check against
---@return boolean
function ItemDatabase:IsInCategory(category)
    local categoryHash = _resolveHash(category)
    return self:GetCategory() == categoryHash
end

---Gets the item group hash
---@return number
function ItemDatabase:GetGroup()
    self:_ensureInfo()
    return self._info and self._info.group or 0
end

---Checks whether the item is in a specific group
---@param group number|string The group hash or name to check against
---@return boolean
function ItemDatabase:IsInGroup(group)
    local groupHash = _resolveHash(group)
    return self:GetGroup() == groupHash
end

---Gets the item model hash
---@return number
function ItemDatabase:GetModel()
    self:_ensureInfo()
    return self._info and self._info.model or 0
end

---Gets the item flags (bitfield)
---@return number
function ItemDatabase:GetFlags()
    self:_ensureInfo()
    return self._info and self._info.flags or 0
end

---Gets the item priority access hash
---@return number
function ItemDatabase:GetPriorityAccess()
    self:_ensureInfo()
    return self._info and self._info.priorityaccess or 0
end

---Gets the item bundle hash
---@return number
function ItemDatabase:GetBundle()
    self:_ensureInfo()
    return self._info and self._info.bundle or 0
end

---Gets all tags on an item, optionally filtered by a specific tag type
---@param filterType number|string|nil Optional tag type to filter by (e.g. `TAG_ITEM_PROPERTY`). If nil or 0, returns all.
---@return table An array of tag ID hashes
function ItemDatabase:GetTags(filterType)
    self:_ensureTags()
    local tags = self._tags or {}

    local typeHash = 0
    if filterType and filterType ~= 0 then
        typeHash = _resolveHash(filterType)
    end

    local result = {}
    for id, storedType in pairs(tags) do
        if typeHash == 0 or storedType == typeHash then
            table.insert(result, id)
        end
    end
    return result
end

---Checks if the item has a specific tag, optionally verifying the tag type
---@param tag number|string The tag ID hash or name
---@param filterType number|string|nil Optional tag type to verify.
---@return boolean
function ItemDatabase:HasTag(tag, filterType)
    self:_ensureTags()
    local tags = self._tags or {}

    local tagHash = _resolveHash(tag)
    local storedType = tags[tagHash]

    -- Tag does not exist
    if storedType == nil then
        return false
    end

    -- If filter provided, check if types match
    if filterType and filterType ~= 0 then
        local typeHash = _resolveHash(filterType)
        if storedType ~= typeHash then
            return false
        end
    end

    return true
end

---Determines the Ped Type for use in shop swatches.
---Returns 3 for Horse, 1 for Female, 0 for Male.
---@return number
function ItemDatabase:GetPedType()
    local group = self:GetGroup()

    if group == `HORSE_EQUIPMENT` then
        return 3
    elseif group == `CLOTHING` then
        if self:HasTag(`CI_TAG_CLOTHING_ITEM_FEMALE`) then
            return 1
        else
            return 0
        end
    end

    -- Always assume the default ped type is male
    return 0
end

---Checks if the item is a valid wardrobe outfit
---@return boolean
function ItemDatabase:IsOutfit()
    local category = self:GetCategory()
    if category == 0 then return false end

    local OUTFIT_CATEGORIES <const> = {
        [`CI_CATEGORY_WARDROBE_UPPER_GARB`] = true,
        [`CI_CATEGORY_WARDROBE_OUTFIT`]     = true,
        [`CI_CATEGORY_WARDROBE_LOWER_GARB`] = true,
    }

    return OUTFIT_CATEGORIES[category] == true
end

---Gets the name for a single item within a category, if applicable (eg., "Hat" for the "Hats" category)
---@return number|nil The item name hash, or nil if not applicable
function ItemDatabase:ClothingSingleItemName()
    local category = self:GetCategory()

    local SINGLE_ITEM_CATEGORIES <const> = {
        [`CI_CATEGORY_WARDROBE_ACCESSORIES`] = 956753366,
        [`CI_CATEGORY_WARDROBE_APRONS`] = 229848043,
        [`CI_CATEGORY_WARDROBE_BADGE`] = 588559743,
        [`CI_CATEGORY_WARDROBE_BAG`] = -1165477807,
        [`CI_CATEGORY_WARDROBE_BAG_STRAP`] = 542482997,
        [`CI_CATEGORY_WARDROBE_BANDANA`] = -1598999798,
        [`CI_CATEGORY_WARDROBE_BELTS`] = -1964604515,
        [`CI_CATEGORY_WARDROBE_WAIST_STRAP`] = -1964604515,
        [`CI_CATEGORY_WARDROBE_BLOUSES`] = -950324859,
        [`CI_CATEGORY_WARDROBE_BOOTS`] = -1768217088,
        [`CI_CATEGORY_WARDROBE_BOOTS_ACCESSORIES`] = -647442474,
        [`CI_CATEGORY_WARDROBE_BUCKLE`] = -1669395156,
        [`CI_CATEGORY_WARDROBE_CHAPS`] = 2099263972,
        [1545016984] = 2099263972, -- Chaps
        [`CI_CATEGORY_WARDROBE_COATS`] = 1177470655,
        [-1080198344] = 1177470655, -- Coat
        [`CI_CATEGORY_WARDROBE_PONCHO`] = -768798238,
        [`CI_CATEGORY_WARDROBE_BODICE`] = -145955678,
        [`CI_CATEGORY_WARDROBE_DRESSES`] = 1758406353,
        [`CI_CATEGORY_WARDROBE_GLASSES`] = 332275111,
        [`CI_CATEGORY_WARDROBE_GLOVES`] = 1533215112,
        [`CI_CATEGORY_WARDROBE_GUNBELT`] = 1990307743,
        [`CI_CATEGORY_WARDROBE_HAT`] = 1314684259,
        [`CI_CATEGORY_WARDROBE_HAT_ACCESSORIES`] = -1942508740,
        [-646147237] = 2145255488, -- Headwear
        [`CI_CATEGORY_WARDROBE_LOADOUT`] = 1735590610,
        [`CI_CATEGORY_WARDROBE_LOADOUT_3`] = -1804458598,
        [`CI_CATEGORY_WARDROBE_LOADOUT_4`] = -1804458598,
        [`CI_CATEGORY_WARDROBE_MASK`] = -2096103467,
        [`CI_CATEGORY_WARDROBE_BIG_MASK`] = -2096103467,
        [`CI_CATEGORY_WARDROBE_NECKWEAR`] = -572044425,
        [`CI_CATEGORY_WARDROBE_NECKWEAR_1`] = -1893707445,
        [`CI_CATEGORY_WARDROBE_NECKWEAR_2`] = -572044425,
        [`CI_CATEGORY_WARDROBE_OUTFIT`] = 1704476318,
        [`CI_CATEGORY_WARDROBE_OVERALLS`] = 1135086855,
        [`CI_CATEGORY_WARDROBE_PANT`] = -1118685671,
        [`CI_CATEGORY_WARDROBE_RINGS`] = 1373811563,
        [`CI_CATEGORY_WARDROBE_SATCHEL`] = -551303313,
        [`CI_CATEGORY_WARDROBE_SCARVES`] = -1962451182,
        [`CI_CATEGORY_WARDROBE_SHIRT`] = -999848467,
        [`CI_CATEGORY_WARDROBE_SKIRTS`] = 2123406071,
        [`CI_CATEGORY_WARDROBE_SPATS`] = 106280714,
        [`CI_CATEGORY_WARDROBE_STOCKINGS`] = 406014096,
        [`CI_CATEGORY_WARDROBE_SUSPENDERS`] = -350927420,
        [`CI_CATEGORY_WARDROBE_TIES`] = -494519208,
        [`CI_CATEGORY_WARDROBE_UNDERGARMENT`] = 834235656,
        [`CI_CATEGORY_WARDROBE_VEST`] = 1488981351,
        [`CI_CATEGORY_WARDROBE_BRACELET`] = -1622329839,
        [`CI_CATEGORY_WARDROBE_KNIFE_HOLSTER`] = 1995280482,
        [`CI_CATEGORY_WARDROBE_TALISMAN_BELT`] = -1596855333,
        [`CI_CATEGORY_WARDROBE_TALISMAN_BOOT`] = -1596855333,
        [`CI_CATEGORY_WARDROBE_TALISMAN_HOLSTER`] = -1596855333,
        [`CI_CATEGORY_WARDROBE_TALISMAN_NECK`] = -1596855333,
        [`CI_CATEGORY_WARDROBE_TALISMAN_SATCHEL`] = -1596855333,
        [`CI_CATEGORY_WARDROBE_VEST_ACCESSORY`] = -721165241,
        [`CI_CATEGORY_WARDROBE_WRIST_ACCESSORY`] = -1134874053,
        [`CI_CATEGORY_WARDROBE_UPPER_GARB`] = 1436397544,
        [`CI_CATEGORY_WARDROBE_LOWER_GARB`] = 1737462569,
        [`CI_CATEGORY_WARDROBE_GUNBELT_TRINKET`] = 614921588,
        [`CI_CATEGORY_WARDROBE_LEFT_RINGS`] = -1811813854,
        [`CI_CATEGORY_WARDROBE_RIGHT_RINGS`] = 1910916313,
        [`CI_CATEGORY_WARDROBE_EYEWEAR`] = 1040778386,
        [`CI_CATEGORY_WARDROBE_GAUNTLETS`] = -1084600277,
        [`CI_CATEGORY_WARDROBE_HAIR_ACCESSORY`] = -557890885,
        [`CI_CATEGORY_WARDROBE_HEADBAND`] = -1196444516,
        [`CI_CATEGORY_WARDROBE_NIGHTGOWN`] = -1875263195,
        [`CI_CATEGORY_WARDROBE_FULL_DRESS`] = -754876186,
    }

    local hash = SINGLE_ITEM_CATEGORIES[category]
    if not hash then return nil end

    return GetStringFromHashKey(hash)
end

---Checks if the item is valid makeup or facial modification
---@return boolean
function ItemDatabase:IsMakeup()
    local category = self:GetCategory()
    if category == 0 then return false end

    local MAKEUP_CATEGORIES <const> = {
        [`CI_CATEGORY_WARDROBE_BLUSH`]      = true,
        [`CI_CATEGORY_WARDROBE_EYELINER`]   = true,
        [`CI_CATEGORY_WARDROBE_EYESHADOW`]  = true,
        [`CI_CATEGORY_WARDROBE_FOUNDATION`] = true,
        [`CI_CATEGORY_WARDROBE_LIPSTICK`]   = true,
        [1115104855]                        = true, -- Facial stubble
    }

    return MAKEUP_CATEGORIES[category] == true
end

---Gets the "stars" (Quality) of the item (0-3)
---@return number
function ItemDatabase:GetQualityStars()
    if InventoryIsInventoryItemFlagEnabled(self.hash, 1 << 2) == 1 then return 3 end  -- Legendary
    if InventoryIsInventoryItemFlagEnabled(self.hash, 1 << 30) == 1 then return 3 end -- Perfect
    if InventoryIsInventoryItemFlagEnabled(self.hash, 1 << 29) == 1 then return 2 end -- High
    if InventoryIsInventoryItemFlagEnabled(self.hash, 1 << 28) == 1 then return 1 end -- Poor
    return 0
end

---Determines if the item is "special" (Overpowered or Legendary)
---@return boolean
function ItemDatabase:IsSpecial()
    if self:HasTag(`CI_TAG_ITEM_OVERPOWERED`) or self:HasTag(`CI_TAG_ITEM_QUALITY_LEGENDARY`) then
        return true
    end

    return InventoryIsInventoryItemFlagEnabled(self.hash, 1 << 2) == 1
end

---Gets the warmth rating of a clothing item
---@return number|nil
function ItemDatabase:GetWarmth()
    -- Value Map (Hash -> Value)
    local WARMTH_TAGS <const> = {
        [-1938332139] = 1,
        [-821065926]  = 2,
        [-923980501]  = 3,
        [-1679966367] = 4,
    }

    for tagId, value in pairs(WARMTH_TAGS) do
        if self:HasTag(tagId) then
            return value
        end
    end

    return nil
end

---Checks basic interaction flags (Droppable, Cookable, etc.)
---@return table { droppable, breakable, cookable, usable, drinkable, edible, readable }
function ItemDatabase:GetInteractionFlags()
    local result = {
        droppable = true,
        breakable = self:HasTag(`CI_TAG_ITEM_CAN_BREAKDOWN`),
        cookable = false,
        usable = self:HasTag(`CI_TAG_ITEM_CONSUMABLE`),
        drinkable = false,
        edible = false,
        readable = self:HasTag(`CI_TAG_ITEM_DOCUMENT`),
    }

    if self:HasTag(`CI_TAG_ITEM_CANNOT_DISCARD`) then
        result.droppable = false
    end

    if self.hash ~= `PROVISION_ROTTEN_MEAT` and self.hash ~= `CONSUMABLE_CORNEDBEEF_CAN` then
        if self:HasTag(`CI_TAG_ITEM_MEAT_ANIMAL`) or self:HasTag(`CI_TAG_ITEM_MEAT_FISH`) then
            result.cookable = true
        end
    end

    local DRINK_TAGS <const> = {
        [-273840653] = true,
        [238865292]  = true,
        [999632878]  = true,
        [1130235258] = true,
        [1177617310] = true
    }

    local FOOD_TAGS <const> = {
        [-1915958659] = true,
        [-809056541]  = true,
        [89124942]    = true,
        [1451036371]  = true,
        [1859991422]  = true,
        [1891031775]  = true
    }

    for tag, _ in pairs(DRINK_TAGS) do
        if self:HasTag(tag) then
            result.drinkable = true
            break
        end
    end

    for tag, _ in pairs(FOOD_TAGS) do
        if self:HasTag(tag) then
            result.edible = true
            break
        end
    end

    return result
end

---Parses item effects into a usable table
---@return table A map of keys (e.g., 'health', 'weaponDamage') to { value, duration }
function ItemDatabase:GetStats()
    self:_ensureEffects()
    if not self._effects then return {} end

    local stats = {}

    local DURATIONS <const> = {
        [`EFFECT_DURATION_CATEGORY_NONE`] = 0,
        [`EFFECT_DURATION_CATEGORY_1`]    = 1,
        [`EFFECT_DURATION_CATEGORY_2`]    = 2,
        [`EFFECT_DURATION_CATEGORY_3`]    = 3,
        [`EFFECT_DURATION_CATEGORY_4`]    = 4,
    }

    -- Lookup table for effect types to human readable keys and override values
    local EFFECT_MAP <const> = {
        -- Player Stats (Consumables)
        [`EFFECT_HEALTH`]                    = { key = "health", value = nil },
        [`EFFECT_HEALTH_OVERPOWERED`]        = { key = "health", value = 11 },
        [`EFFECT_STAMINA`]                   = { key = "stamina", value = nil },
        [`EFFECT_STAMINA_OVERPOWERED`]       = { key = "stamina", value = 11 },
        [`EFFECT_DEADEYE`]                   = { key = "deadeye", value = nil },
        [`EFFECT_DEADEYE_OVERPOWERED`]       = { key = "deadeye", value = 11 },
        [`EFFECT_HEALTH_CORE`]               = { key = "healthCore", value = nil },
        [`EFFECT_HEALTH_CORE_GOLD`]          = { key = "healthCore", value = 12 },
        [`EFFECT_STAMINA_CORE`]              = { key = "staminaCore", value = nil },
        [`EFFECT_STAMINA_CORE_GOLD`]         = { key = "staminaCore", value = 12 },
        [`EFFECT_DEADEYE_CORE`]              = { key = "deadeyeCore", value = nil },
        [`EFFECT_DEADEYE_CORE_GOLD`]         = { key = "deadeyeCore", value = 12 },

        -- Horse Stats (Consumables)
        [`EFFECT_HORSE_HEALTH`]              = { key = "horseHealth", value = nil },
        [`EFFECT_HORSE_HEALTH_OVERPOWERED`]  = { key = "horseHealth", value = 11 },
        [`EFFECT_HORSE_STAMINA`]             = { key = "horseStamina", value = nil },
        [`EFFECT_HORSE_STAMINA_OVERPOWERED`] = { key = "horseStamina", value = 11 },
        [`EFFECT_HORSE_HEALTH_CORE`]         = { key = "horseHealthCore", value = nil },
        [`EFFECT_HORSE_HEALTH_CORE_GOLD`]    = { key = "horseHealthCore", value = 12 },
        [`EFFECT_HORSE_STAMINA_CORE`]        = { key = "horseStaminaCore", value = nil },
        [`EFFECT_HORSE_STAMINA_CORE_GOLD`]   = { key = "horseStaminaCore", value = 12 },

        -- Weapon Base Stats
        [-266488916]                         = { key = "weaponDamage", value = nil },
        [1648497600]                         = { key = "weaponRange", value = nil },
        [-1856731002]                        = { key = "weaponFireRate", value = nil },
        [2038990430]                         = { key = "weaponReload", value = nil },
        [983649838]                          = { key = "weaponAccuracy", value = nil },

        -- Weapon Familiarity Bonuses
        [1465168878]                         = { key = "familiarityRange", value = nil },
        [-1103443887]                        = { key = "familiarityReload", value = nil },
        [-800430237]                         = { key = "familiarityAccuracy", value = nil },

        -- Component / Ammo Modifiers
        [1999781523]                         = { key = "statModifierDamage", value = nil },
        [1173003838]                         = { key = "statModifierAccuracy", value = nil },
        [-1657343230]                        = { key = "statModifierRange", value = nil },
    }

    for _, effect in ipairs(self._effects) do
        local definition = EFFECT_MAP[effect.type]
        if definition then
            local value = definition.value or tonumber(effect.value or 0)
            local duration = DURATIONS[effect.durationCategory] or 0

            stats[definition.key] = {
                Value = value,
                Duration = duration
            }
        end
    end

    return stats
end

function ItemDatabase:GetUiRpgStats()
    local stats = self:GetStats()

    return {
        Health = stats.health,
        Stamina = stats.stamina,
        Deadeye = stats.deadeye,
        HealthCore = stats.healthCore,
        StaminaCore = stats.staminaCore,
        DeadeyeCore = stats.deadeyeCore,
        HealthHorse = stats.horseHealth,
        StaminaHorse = stats.horseStamina,
        HealthCoreHorse = stats.horseHealthCore,
        StaminaCoreHorse = stats.horseStaminaCore,
    }
end
