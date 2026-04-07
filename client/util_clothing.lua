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

local NONE_ITEM_METAPED_TAGS <const> = {
    -- Confirmed
    [`CLOTHING_ITEM_BEARD_NONE`] = { 0xF8016BCA },
    [`CLOTHING_ITEM_EYES_NONE`] = { `EYES` },
    [`CLOTHING_ITEM_GLOVES_NONE`] = { `GLOVES` },
    [`CLOTHING_ITEM_HAIR_NONE`] = { `HAIR` },
    [`CLOTHING_ITEM_HAT_NONE`] = { `HATS`, `MASKS`, 0x8E84A2AA },
    [`CLOTHING_ITEM_HEAD_NONE`] = { `HEADS` },
    [`CLOTHING_ITEM_LOADOUT_2_NONE`] = { `GUNBELTS` },
    [`CLOTHING_ITEM_NECKWEAR_NONE`] = { 0x45572D15, `NECKTIES`, `NECKWEAR` },
    [`CLOTHING_ITEM_SATCHEL_NONE`] = { `SATCHELS` },
    [`CLOTHING_ITEM_TEETH_NONE`] = { `TEETH` },
    [0x11BC2A7C] = { `ACCESSORIES` },
    [0x15068D1B] = { `ARMOR` },
    [0x2539E609] = { 0xE18F5D41 },
    [0x28A63FAB] = { `BOOTS` },
    [0x28D30297] = { `BELTS` },
    [0x2A96F34B] = { `JEWELRY_RINGS_RIGHT` },
    [0x2BDEB9C7] = { `VESTS` },
    [0x2CBC64A6] = { `PANTS`, 0x3F7DB302, `SKIRTS`, `DRESSES` },
    [0x3852637C] = { `COATS`, `PONCHOS`, `COATS_CLOSED` },
    [0x5343542E] = { `JEWELRY_RINGS_LEFT` },
    [0x71F04251] = { `BODIES_UPPER` },
    [0x86A86CB8] = { `BELT_BUCKLES` },
    [0x948D2AB0] = { 0xF1542D11 },
    [0x9A40003F] = { `BOOT_ACCESSORIES` },
    [0xC3E79012] = { `JEWELRY_BRACELETS` },
    [0xC4B2D2C8] = { `EYEWEAR` },
    [0xCBA12E40] = { `BODIES_LOWER` },
    [0xCD07E4E3] = { `SUSPENDERS` },
    [0xD5B5E5B6] = { `LOADOUTS` },
    [0xD6B0C5D6] = { `SHIRTS_FULL`, 0xE18F5D41 },
    [0xDD5F46E6] = { `CHAPS`, `SPATS` },
    [0xE240CAC4] = { `GAUNTLETS` },
    [0xE7326485] = { `HOLSTERS_LEFT` },
    [0xF78886EB] = { `CLOAKS` },

    -- Guessed
    [`CLOTHING_ITEM_ACCESSORY_NONE`] = { `ACCESSORIES` },
    [`CLOTHING_ITEM_APRON_NONE`] = { `APRONS` },
    [`CLOTHING_ITEM_BADGE_NONE`] = { `BADGES` },
    [`CLOTHING_ITEM_BANDANA_NONE`] = { `NECKWEAR` },
    [`CLOTHING_ITEM_BELT_NONE`] = { `BELTS` },
    [`CLOTHING_ITEM_BLOUSE_NONE`] = { `BLOUSES` },
    [`CLOTHING_ITEM_BOOTS_NONE`] = { `BOOTS` },
    [`CLOTHING_ITEM_CHAPS_NONE`] = { `CHAPS`, `SPATS` },
    [`CLOTHING_ITEM_COAT_NONE`] = { `COATS`, `COATS_HEAVY`, `COATS_CLOSED` },
    [`CLOTHING_ITEM_CORSET_NONE`] = { `CORSETS` },
    [`CLOTHING_ITEM_DRESS_NONE`] = { `DRESSES`, `SKIRTS` },
    [`CLOTHING_ITEM_GLASSES_NONE`] = { `EYEWEAR` },
    [`CLOTHING_ITEM_GUNBELT_NONE`] = { `GUNBELTS` },
    [`CLOTHING_ITEM_HAIR_ACCESSORY_NONE`] = { `HAIR_ACCESSORIES` },
    [`CLOTHING_ITEM_LOADOUT_NONE`] = { `LOADOUTS` },
    [`CLOTHING_ITEM_NECKLACE_NONE`] = { `JEWELRY_NECKLACES` },
    [`CLOTHING_ITEM_OVERALLS_NONE`] = { `PANTS`, `OVERALLS_FULL`, `OVERALLS_MODULAR_UPPERS`, `OVERALLS_MODULAR_LOWERS` },
    [`CLOTHING_ITEM_PANTS_NONE`] = { `PANTS` },
    [`CLOTHING_ITEM_RINGS_NONE`] = { `JEWELRY_RINGS` },
    [`CLOTHING_ITEM_SCARF_NONE`] = { `SCARVES` },
    [`CLOTHING_ITEM_SHAWL_NONE`] = { `SHAWLS` },
    [`CLOTHING_ITEM_SHIRT_NONE`] = { 0x2B388A05, 0x4A8A0B53, `SHIRTS_FULL`, `SHIRTS_FULL_OVERPANTS` },
    [`CLOTHING_ITEM_SKIRT_NONE`] = { `SKIRTS` },
    [`CLOTHING_ITEM_STOCKINGS_NONE`] = { `STOCKINGS` },
    [`CLOTHING_ITEM_SUSPENDERS_NONE`] = { `SUSPENDERS` },
    [`CLOTHING_ITEM_UNDERGARMENT_NONE`] = { `CHEMISES` },
    [`CLOTHING_ITEM_VEST_NONE`] = { `VESTS` },
    [0x0FBF1697] = { `BELT_BUCKLES` },
    [0x17B7E55C] = { `PONCHOS` },
    [0x1C74AAF0] = { `SPATS` },
    [0x1D4B64C1] = { `HATS`, `HEADWEAR` },
    [0x2C8C3C9B] = { `GLOVES` },
    [0x5ED2BAE5] = { `MASKS` },
    [0x76039754] = { `HATS`, `HEADWEAR` },
    [0x7AF807E2] = { `MASKS` },
    [0x8F0F86D6] = { `CORSETS`, `VESTS` },
    [0x907BFCE7] = { `MASKS_LARGE` },
    [0xCF5A515E] = { `DRESSES`, `SKIRTS` },

    -- Unknown or unused
    -- [`CLOTHING_ITEM_BODY_NONE`] = { `BODIES_LOWER`, `BODIES_UPPER` },
    -- [`CLOTHING_ITEM_BRACELET_NONE`] = { `TALISMAN_WRIST`, `JEWELRY_BRACELETS` },
    -- [`CLOTHING_ITEM_NECKWEAR_2_NONE`] = { `MISSING` },
    -- [0x0B74107F] = { `BOOTS` },
    -- [0x4E8D3420] = { `MISSING` },
    -- [0x52300742] = nil, -- YLDB: No Outfit
    -- [0x929E5057] = { `DRESSES` },
}

local METAPED_DATA <const> = {
    {
        Id = `MP_COMPONENT_TYPE_HEAD`,
        SlotId = `SLOTID_WARDROBE_HEAD`,
        MetapedTags = { `HEADS` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL_HEAD`, `MPC_SYSTEM_TAG_INFO_HEAD_FEATURES`, `MPC_SYSTEM_TAG_INFO_BODY` }
    },
    {
        Id = `MP_COMPONENT_TYPE_EYES`,
        SlotId = `SLOTID_WARDROBE_EYES`,
        MetapedTags = { `EYES` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL_HEAD`, `MPC_SYSTEM_TAG_INFO_HEAD_FEATURES`, `MPC_SYSTEM_TAG_INFO_HEAD_OVERLAY` }
    },
    {
        Id = `MP_COMPONENT_TYPE_TEETH`,
        SlotId = `SLOTID_WARDROBE_TEETH`,
        MetapedTags = { `TEETH` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL_HEAD`, `MPC_SYSTEM_TAG_INFO_HEAD_FEATURES` }
    },
    {
        Id = `MP_COMPONENT_TYPE_BEARD`,
        SlotId = `SLOTID_WARDROBE_BEARD`,
        MetapedTags = { 0xF8016BCA },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL_HEAD`, `MPC_SYSTEM_TAG_INFO_HAIR`, `MPC_SYSTEM_TAG_INFO_FACIAL_HAIR` }
    },
    {
        Id = `MP_COMPONENT_TYPE_UPPER_BODY`,
        SlotId = `SLOTID_WARDROBE_UPPER_BODY`,
        MetapedTags = { `BODIES_UPPER` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_BODY`, `MPC_SYSTEM_TAG_INFO_UPPER_BODY` }
    },
    {
        Id = `MP_COMPONENT_TYPE_LOWER_BODY`,
        SlotId = `SLOTID_WARDROBE_LOWER_BODY`,
        MetapedTags = { `BODIES_LOWER` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_BODY`, `MPC_SYSTEM_TAG_INFO_LOWER_BODY` }
    },
    {
        Id = `MP_COMPONENT_TYPE_EYEWEAR`,
        SlotId = `SLOTID_WARDROBE_EYEWEAR`,
        MetapedTags = { `EYEWEAR` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_APPAREL`, `MPC_SYSTEM_TAG_INFO_HEAD_APPAREL`, `MPC_SYSTEM_TAG_INFO_ROLE_OUTFIT_AGNOSTIC` }
    },
    {
        Id = `MP_COMPONENT_TYPE_NECKWEAR_1`,
        SlotId = `SLOTID_WARDROBE_NECKWEAR_1`,
        MetapedTags = { 0x45572D15, `NECKTIES`, `NECKWEAR` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_NECKWEAR`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_HAIR`,
        SlotId = `SLOTID_WARDROBE_HAIR`,
        MetapedTags = { `HAIR` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL_HEAD`, `MPC_SYSTEM_TAG_INFO_HAIR` }
    },
    {
        Id = `MP_COMPONENT_TYPE_HEADWEAR`,
        SlotId = 0xABEADE1F,
        MetapedTags = { `HATS`, `MASKS`, 0x8E84A2AA },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_APPAREL`, `MPC_SYSTEM_TAG_INFO_HEAD_APPAREL`, `MPC_SYSTEM_TAG_INFO_ROLE_OUTFIT_AGNOSTIC` }
    },
    {
        Id = `MP_COMPONENT_TYPE_UPPER_LAYER_1`,
        SlotId = 0xC256068C,
        MetapedTags = { 0xE18F5D41 },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_UPPER_LAYER_2`,
        SlotId = 0xB2ED679B,
        MetapedTags = { `SHIRTS_FULL`, 0xE18F5D41 },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_UPPER_LAYER_3`,
        SlotId = 0xA4334A27,
        MetapedTags = { `SUSPENDERS` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_UPPER_LAYER_4`,
        SlotId = 0x9681AEC4,
        MetapedTags = { `VESTS` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_UPPER_LAYER_6`,
        SlotId = 0xBE11FDFC,
        MetapedTags = { `COATS`, `PONCHOS`, `COATS_CLOSED` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_UPPER_LAYER_6`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_UPPER_LAYER_8`,
        SlotId = 0x82FA07CD,
        MetapedTags = { `CLOAKS` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_LOADOUT_6`,
        SlotId = `SLOTID_WARDROBE_LOADOUT_6`,
        MetapedTags = { `JEWELRY_RINGS_LEFT` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_HAND_APPAREL`, `MPC_SYSTEM_TAG_INFO_APPAREL`, `MPC_SYSTEM_TAG_INFO_ROLE_OUTFIT_AGNOSTIC` }
    },
    {
        Id = `MP_COMPONENT_TYPE_LOADOUT_7`,
        SlotId = `SLOTID_WARDROBE_LOADOUT_7`,
        MetapedTags = { `JEWELRY_RINGS_RIGHT` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_HAND_APPAREL`, `MPC_SYSTEM_TAG_INFO_APPAREL`, `MPC_SYSTEM_TAG_INFO_ROLE_OUTFIT_AGNOSTIC` }
    },
    {
        Id = `MP_COMPONENT_TYPE_UPPER_LAYER_7`,
        SlotId = 0x905AA28E,
        MetapedTags = { `GAUNTLETS` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL`, `MPC_SYSTEM_TAG_INFO_HAND_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_HAND_ATTIRE`,
        SlotId = `SLOTID_WARDROBE_GLOVES`,
        MetapedTags = { `GLOVES` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_APPAREL`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_HAND_APPAREL`, `MPC_SYSTEM_TAG_INFO_ROLE_OUTFIT_AGNOSTIC` }
    },
    {
        Id = `MP_COMPONENT_TYPE_WRIST_ATTIRE`,
        SlotId = 0x09436ACB,
        MetapedTags = { `JEWELRY_BRACELETS` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_SATCHEL`,
        SlotId = `SLOTID_WARDROBE_SATCHEL`,
        MetapedTags = { `SATCHELS` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_EQUIPMENT`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_LOADOUT_1`,
        SlotId = `SLOTID_WARDROBE_LOADOUT_1`,
        MetapedTags = { `LOADOUTS` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_EQUIPMENT`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_LOADOUT_2`,
        SlotId = `SLOTID_WARDROBE_LOADOUT_2`,
        MetapedTags = { `GUNBELTS` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_APPAREL`, `MPC_SYSTEM_TAG_INFO_EQUIPMENT`, `MPC_SYSTEM_TAG_INFO_BASE_GUNBELT` }
    },
    {
        Id = `MP_COMPONENT_TYPE_LOADOUT_3`,
        SlotId = `SLOTID_WARDROBE_LOADOUT_3`,
        MetapedTags = { `BELT_BUCKLES` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_APPAREL`, `MPC_SYSTEM_TAG_INFO_EQUIPMENT`, `MPC_SYSTEM_TAG_INFO_BASE_GUNBELT` }
    },
    {
        Id = `MP_COMPONENT_TYPE_LOADOUT_4`,
        SlotId = `SLOTID_WARDROBE_LOADOUT_4`,
        MetapedTags = { `HOLSTERS_LEFT` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_APPAREL`, `MPC_SYSTEM_TAG_INFO_EQUIPMENT`, `MPC_SYSTEM_TAG_INFO_SECONDARY_HOLSTER` }
    },
    {
        Id = `MP_COMPONENT_TYPE_LOADOUT_8`,
        SlotId = `SLOTID_WARDROBE_LOADOUT_8`,
        MetapedTags = { 0xF1542D11 },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_BASE_GUNBELT`, `MPC_SYSTEM_TAG_INFO_EQUIPMENT`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_LOADOUT_5`,
        SlotId = `SLOTID_WARDROBE_LOADOUT_5`,
        MetapedTags = { `BELTS` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_TORSO_APPAREL`, `MPC_SYSTEM_TAG_INFO_EQUIPMENT`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_LOWER_LAYER_1`,
        SlotId = 0xAD7761D8,
        MetapedTags = { `PANTS`, 0x3F7DB302, `SKIRTS`, `DRESSES` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_LEG_APPAREL`, `MPC_SYSTEM_TAG_INFO_LOWER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_FOOTWEAR_1`,
        SlotId = 0x23F31672,
        MetapedTags = { `BOOTS` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_LEG_APPAREL`, `MPC_SYSTEM_TAG_INFO_LOWER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_LOWER_LAYER_2`,
        SlotId = 0x8732954F,
        MetapedTags = { `CHAPS`, `SPATS` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_LEG_APPAREL`, `MPC_SYSTEM_TAG_INFO_LOWER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_FOOTWEAR_2`,
        SlotId = 0xFE33CAF0,
        MetapedTags = { `BOOT_ACCESSORIES` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_LEG_APPAREL`, `MPC_SYSTEM_TAG_INFO_LOWER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_UPPER_LAYER_5`,
        SlotId = 0x89CC955A,
        MetapedTags = { `ARMOR` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_CHEST_APPAREL`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    },
    {
        Id = `MP_COMPONENT_TYPE_LOADOUT_9`,
        SlotId = `SLOTID_WARDROBE_LOADOUT_9`,
        MetapedTags = { `ACCESSORIES` },
        SystemTags = { `MPC_SYSTEM_TAG_INFO_ALL`, `MPC_SYSTEM_TAG_INFO_ALL_BODY`, `MPC_SYSTEM_TAG_INFO_EQUIPMENT`, `MPC_SYSTEM_TAG_INFO_UPPER_GARB`, `MPC_SYSTEM_TAG_INFO_APPAREL` }
    }
}

ItemData = {
    NONE_ITEM_METAPED_TAGS = NONE_ITEM_METAPED_TAGS,
    METAPED_DATA = METAPED_DATA,
    OUTFITS_MALE = {},
    OUTFITS_FEMALE = {},
}

local function LoadData()
    CreateThread(function()
        while not RequestResourceFileSet('outfits') do
            Wait(0)
        end

        -- Load outfit data
        local OUTFIT_FILES = {
            { name = "data/outfits_male.json",   target = "OUTFITS_MALE" },
            { name = "data/outfits_female.json", target = "OUTFITS_FEMALE" },
        }

        for _, resourceFile in ipairs(OUTFIT_FILES) do
            local fileData = LoadResourceFile(GetCurrentResourceName(), resourceFile.name)
            if fileData then
                local success, jsonData = pcall(json.decode, fileData)
                if success and jsonData then
                    local results = {}
                    for key, value in pairs(jsonData) do
                        local mainHash = _resolveHash(key)
                        if mainHash then
                            results[mainHash] = Outfit.new(value)
                        end
                    end
                    ItemData[resourceFile.target] = results
                end
            end
        end
    end)
end

LoadData()
