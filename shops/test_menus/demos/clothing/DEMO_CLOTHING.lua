local function getClothingMenu(data)
    if not data then data = {} end

    local gender = data.Gender or 1
    local catalog = gender == 1 and WARDROBE_MALE or WARDROBE_FEMALE

    local menu = {}
    for _, category in ipairs(catalog) do
        local categoryId = category.Id
        local categoryItems = {}
        for _, item in ipairs(category.Items) do
            local itemData = ItemDatabase.new(item)
            if not itemData then
                print("[NativeShop] Invalid item in catalog:", item)
                goto continue
            end

            if itemData:HasTag(`CI_TAG_ITEM_CLOTHING_NONE`) then
                table.insert(categoryItems, {
                    Id = item,
                    Type = "INVENTORY",
                    Footer = "Remove this item",
                    Auto = true,
                    Prompts = {
                        Select = "Remove"
                    },
                    Action = function(selected)
                        RemoveClothing(selected.Id)
                        PostFeedTicker(string.format("Selected %s", selected.Id))
                    end
                })
            elseif
                itemData:HasTag(`CI_TAG_ITEM_CLOTHING_STYLE`) or
                -- Fix cut clothing styles that aren't set as a style properly
                itemData:HasTag(`CI_TAG_CLOTHING_STYLE_M_OUTLAW1`) or
                itemData:HasTag(`CI_TAG_CLOTHING_STYLE_M_OUTLAW2`) or
                itemData:HasTag(`CI_TAG_CLOTHING_STYLE_F_OUTLAW1`) or
                itemData:HasTag(`CI_TAG_CLOTHING_STYLE_F_OUTLAW2`)
            then
                table.insert(categoryItems, {
                    Id = item,
                    Type = "TEXT",
                    Footer = string.format("View styles for %s", itemData:GetLabel(true)),
                    Auto = true,
                    LinkMenuId = "DEMO_CLOTHING_STYLES",
                    LinkPageId = item,
                    LinkData = data,
                    Data = {
                        AddIconVisible = true,
                        AddIconTextureDict = "itemtype_textures",
                        AddIconTexture = "itemtype_upgrades",
                    }
                })
            else
                table.insert(categoryItems, {
                    Id = item,
                    Type = "INVENTORY",
                    Auto = true,
                    Prompts = {
                        Select = "Equip"
                    },
                    Action = function(selected)
                        ApplyClothing(selected.Id)
                        PostFeedTicker(string.format("Selected %s", selected.Id))
                    end
                })
            end

            ::continue::
        end

        table.insert(menu, {
            Id = categoryId,
            Scene = "ITEM_LIST_RPG_STATS",
            Label = GetStringFromHashKey(category.Label),
            Items = categoryItems
        })
    end

    return {
        Title = "WARDROBE",
        Subtitle = "Index",
        Scene = "ITEM_LIST_RPG_STATS",
        AllowWalking = true,
        RepositionCamera = true,
        Items = menu,
    }
end

-- Provide basic text entries for cut outfits and categories

local function safeAddTextEntry(key, value)
    if type(key) == "string" then
        AddTextEntry(key, value)
    else
        AddTextEntry(string.format("0x%X", key), value)
    end
end

-- Wardrobe outfit categories
safeAddTextEntry("NSUI_WARDROBE_RUGGED", "Rugged Outfits")
safeAddTextEntry("NSUI_WARDROBE_CITY", "Big City Outfits")
safeAddTextEntry("NSUI_WARDROBE_ARMOR", "Armor Outfits")

-- Cut male outfits
safeAddTextEntry(0xAC68B897, "The Outdoorsman")
safeAddTextEntry(0x1E4EEEB3, "The Kingping")

-- Posse outfits
local ruggedMale = WARDROBE_MALE[3].Items
for index, value in ipairs(ruggedMale) do
    local label = string.format("Rugged Outfit %d", index)
    safeAddTextEntry(value, label)
end

local ruggedFemale = WARDROBE_FEMALE[3].Items
for index, value in ipairs(ruggedFemale) do
    local label = string.format("Rugged Outfit %d", index)
    safeAddTextEntry(value, label)
end

local cityMale = WARDROBE_MALE[4].Items
for index, value in ipairs(cityMale) do
    local label = string.format("Big City Outfit %d", index)
    safeAddTextEntry(value, label)
end

local cityFemale = WARDROBE_FEMALE[4].Items
for index, value in ipairs(cityFemale) do
    local label = string.format("Big City Outfit %d", index)
    safeAddTextEntry(value, label)
end

-- Ned Kelly outfits
local armorMale = WARDROBE_MALE[5].Items
for index, value in ipairs(armorMale) do
    local label = string.format("Armor Outfit %d", index)
    safeAddTextEntry(value, label)
end

local armorFemale = WARDROBE_FEMALE[5].Items
for index, value in ipairs(armorFemale) do
    local label = string.format("Armor Outfit %d", index)
    safeAddTextEntry(value, label)
end

ShopNavigator:registerDynamic("DEMO_CLOTHING", getClothingMenu)
