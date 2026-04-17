local function getMenu()
    local menu = {}
    for category, styles in pairs(HORSE_EQUIPMENT_STYLES) do
        local styleItems = {}

        for _, item in ipairs(styles) do
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

        table.insert(menu, {
            Id = category,
            Scene = "ITEM_GRID",
            Label = GetStringFromHashKey(category),
            Items = styleItems,
        })
    end

    return {
        Title = "STABLES",
        AllowWalking = true,
        RepositionCamera = true,
        Items = menu,
    }
end

ShopApi.RegisterDynamic("DEMO_STABLES_EQUIPMENT_STYLES", getMenu)
