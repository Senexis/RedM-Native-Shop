local function getClothingMenu(data)
    if not data then data = {} end

    local gender = data.Gender or 1
    local catalog = gender == 1 and WARDROBE_MALE or WARDROBE_FEMALE

    -- Get text for the footers
    local styleSelectTooltip = GetStringFromHashKey("SHOP_ITEM_STYLE_SELECT_TOOLTIP")
    local removeYourTooltip = GetStringFromHashKey(-1779818913)

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
                    Footer = removeYourTooltip:gsub("~1p~", itemData:ClothingSingleItemName()),
                    Auto = true,
                    Prompts = {
                        Select = "Remove"
                    },
                    Action = function(selected)
                        PostFeedTicker(string.format("Removed %s", itemData:ClothingSingleItemName()))
                    end
                })
            elseif itemData:HasTag(`CI_TAG_ITEM_CLOTHING_STYLE`) then
                table.insert(categoryItems, {
                    Id = item,
                    Type = "TEXT",
                    Footer = styleSelectTooltip:gsub("~1p~", itemData:GetLabel(true)),
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

ShopNavigator:registerDynamic("DEMO_CLOTHING", getClothingMenu)
