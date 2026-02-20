local function getClothingStylesMenu(data)
    if not data then data = {} end

    local gender = data.Gender or 1
    local catalog = gender == 1 and STYLES_MALE or STYLES_FEMALE

    local menu = {}
    for category, styles in pairs(catalog) do
        local categoryItems = {}

        for style, items in pairs(styles) do
            local styleItems = {}

            local styleData = ItemDatabase.new(style)
            if not styleData then
                print("[NativeShop] Invalid style in catalog:", style)
                goto continue
            end

            for _, item in ipairs(items) do
                table.insert(styleItems, {
                    Id = item,
                    Type = "SWATCH",
                    Auto = true,
                    Prompts = {
                        Select = "Equip"
                    },
                    Action = function(selected)
                        PostFeedTicker(string.format("Selected %s", selected.Id))
                    end
                })
            end

            table.insert(categoryItems, {
                Id = style,
                Scene = "ITEM_GRID",
                Subtitle = styleData:GetLabel(true),
                Type = "TEXT",
                Auto = true,
                Items = styleItems,
            })

            ::continue::
        end

        table.insert(menu, {
            Id = category,
            Scene = "ITEM_LIST_RPG_STATS",
            Label = tostring(category):gsub("_", " "):upper(),
            Items = categoryItems
        })
    end

    return {
        Title = "WARDROBE",
        Scene = "MENU_LIST",
        AllowWalking = true,
        RepositionCamera = true,
        Items = menu,
    }
end

ShopNavigator:registerDynamic("DEMO_CLOTHING_STYLES", getClothingStylesMenu)
