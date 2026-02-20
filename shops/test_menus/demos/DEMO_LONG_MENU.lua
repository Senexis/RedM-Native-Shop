local function getLongMenu()
    local items = {}
    for i = 1, 10000 do
        table.insert(items, {
            Id = "LONG_MENU_ITEM_" .. i,
            Type = "TEXT",
            Label = "Menu Item " .. i,
            Footer = "This is menu item number " .. i,
        })
    end

    return items
end

local data = {
    Id = "DEMO_LONG_MENU",
    Scene = "MENU_LIST",
    Title = "DEMOS",
    Subtitle = "Long Menu",
    AllowWalking = true,
    RepositionCamera = true,
    Items = getLongMenu(),
}

ShopNavigator:register(data)
