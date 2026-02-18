local MENU_ID <const> = "DEMO_BASIC_SHOP"

local shop_inventory = {
    { ID = "CONSUMABLE_APRICOTS_CAN",     Category = "CANNED_GOODS", Stock = 1,  Price = 75,  SalePrice = math.floor(75 * 0.9) },
    { ID = "CONSUMABLE_BAKED_BEANS_CAN",  Category = "CANNED_GOODS", Stock = 5,  Price = 120, SalePrice = math.floor(120 * 0.9) },
    { ID = "CONSUMABLE_CORNEDBEEF_CAN",   Category = "CANNED_GOODS", Stock = 2,  Price = 175, SalePrice = math.floor(175 * 0.9) },
    { ID = "CONSUMABLE_KIDNEYBEANS_CAN",  Category = "CANNED_GOODS", Stock = 2,  Price = 150, SalePrice = math.floor(150 * 0.9) },
    { ID = "CONSUMABLE_OFFAL",            Category = "CANNED_GOODS", Stock = 4,  Price = 135, SalePrice = math.floor(135 * 0.9) },
    { ID = "CONSUMABLE_PEACHES_CAN",      Category = "CANNED_GOODS", Stock = 10, Price = 100, SalePrice = math.floor(100 * 0.9) },
    { ID = "CONSUMABLE_PEAS_CAN",         Category = "CANNED_GOODS", Stock = 0,  Price = 75,  SalePrice = math.floor(75 * 0.9) },
    { ID = "CONSUMABLE_PINEAPPLES_CAN",   Category = "CANNED_GOODS", Stock = 0,  Price = 150, SalePrice = math.floor(150 * 0.9) },
    { ID = "CONSUMABLE_SALMON_CAN",       Category = "CANNED_GOODS", Stock = 4,  Price = 200, SalePrice = math.floor(200 * 0.9) },
    { ID = "CONSUMABLE_STRAWBERRIES_CAN", Category = "CANNED_GOODS", Stock = 0,  Price = 120, SalePrice = math.floor(120 * 0.9) },
    { ID = "CONSUMABLE_SWEET_CORN_CAN",   Category = "CANNED_GOODS", Stock = 7,  Price = 100, SalePrice = math.floor(100 * 0.9) },

    { ID = "CONSUMABLE_APPLE",            Category = "FRESH_GOODS",  Stock = 9,  Price = 40 },
    { ID = "CONSUMABLE_CARROT",           Category = "FRESH_GOODS",  Stock = 4,  Price = 50 },
    { ID = "CONSUMABLE_CHEESE_WEDGE",     Category = "FRESH_GOODS",  Stock = 6,  Price = 190 },
    { ID = "CONSUMABLE_CORN",             Category = "FRESH_GOODS",  Stock = 6,  Price = 40 },
    { ID = "CONSUMABLE_JERKY",            Category = "FRESH_GOODS",  Stock = 4,  Price = 150 },
    { ID = "CONSUMABLE_PEACH",            Category = "FRESH_GOODS",  Stock = 10, Price = 50 },
    { ID = "CONSUMABLE_PEAR",             Category = "FRESH_GOODS",  Stock = 3,  Price = 65 },
    { ID = "PROVISION_MATURE_VENISON",    Category = "FRESH_GOODS",  Stock = 7,  Price = 550 },
    { ID = "PROVISION_PRIME_BEEF",        Category = "FRESH_GOODS",  Stock = 4,  Price = 550 },
    { ID = "PROVISION_TENDER_PORK",       Category = "FRESH_GOODS",  Stock = 2,  Price = 550 },

    { ID = "CONSUMABLE_BISCUIT_BOX",      Category = "DRY_GOODS",    Stock = 8,  Price = 200 },
    { ID = "CONSUMABLE_BREAD_ROLL",       Category = "DRY_GOODS",    Stock = 0,  Price = 40 },
    { ID = "CONSUMABLE_CANDY_BAG",        Category = "DRY_GOODS",    Stock = 8,  Price = 300 },
    { ID = "CONSUMABLE_CHOCOLATE_BAR",    Category = "DRY_GOODS",    Stock = 4,  Price = 200 },
    { ID = "CONSUMABLE_COFFEE_GNDS_REG",  Category = "DRY_GOODS",    Stock = 1,  Price = 100 },
    { ID = "CONSUMABLE_CRACKERS",         Category = "DRY_GOODS",    Stock = 3,  Price = 100 },
    { ID = "CONSUMABLE_OAT_CAKES",        Category = "DRY_GOODS",    Stock = 10, Price = 400 },

    { ID = "CONSUMABLE_GIN",              Category = "LIQUOR",       Stock = 8,  Price = 210 },
    { ID = "CONSUMABLE_RUM",              Category = "LIQUOR",       Stock = 8,  Price = 250 },
    { ID = "CONSUMABLE_WHISKEY",          Category = "LIQUOR",       Stock = 6,  Price = 375 },
    { ID = "CONSUMABLE_BRANDY",           Category = "LIQUOR",       Stock = 1,  Price = 300 },
}

local player_inventory = {
    CONSUMABLE_APRICOTS_CAN = 0,
    CONSUMABLE_BAKED_BEANS_CAN = 1,
    CONSUMABLE_CORNEDBEEF_CAN = 4,
    CONSUMABLE_KIDNEYBEANS_CAN = 4,
    CONSUMABLE_OFFAL = 4,
    CONSUMABLE_PEACHES_CAN = 4,
    CONSUMABLE_PEAS_CAN = 1,
    CONSUMABLE_PINEAPPLES_CAN = 3,
    CONSUMABLE_SALMON_CAN = 3,
    CONSUMABLE_STRAWBERRIES_CAN = 1,
    CONSUMABLE_SWEET_CORN_CAN = 2,
    CONSUMABLE_APPLE = 4,
    CONSUMABLE_CARROT = 1,
    CONSUMABLE_CHEESE_WEDGE = 0,
    CONSUMABLE_CORN = 5,
    CONSUMABLE_JERKY = 2,
    CONSUMABLE_PEACH = 1,
    CONSUMABLE_PEAR = 1,
    PROVISION_MATURE_VENISON = 5,
    PROVISION_PRIME_BEEF = 3,
    PROVISION_TENDER_PORK = 1,
    CONSUMABLE_BISCUIT_BOX = 2,
    CONSUMABLE_BREAD_ROLL = 5,
    CONSUMABLE_CANDY_BAG = 4,
    CONSUMABLE_CHOCOLATE_BAR = 1,
    CONSUMABLE_COFFEE_GNDS_REG = 1,
    CONSUMABLE_CRACKERS = 5,
    CONSUMABLE_OAT_CAKES = 1,
    CONSUMABLE_GIN = 0,
    CONSUMABLE_RUM = 3,
    CONSUMABLE_WHISKEY = 1,
    CONSUMABLE_BRANDY = 2,
}

local data = {
    Id = MENU_ID,
    Title = "GENERAL STORE",
    Scene = "ITEM_LIST_RPG_STATS",
    AllowWalking = true,
    RepositionCamera = true,
    Tabs = {
        { Id = "ALL_GOODS",    Label = "All",          Source = { Name = "BasicShopItems", Filter = nil } },
        { Id = "CANNED_GOODS", Label = "Canned Goods", Source = { Name = "BasicShopItems", Filter = "CANNED_GOODS" } },
        { Id = "FRESH_GOODS",  Label = "Fresh Goods",  Source = { Name = "BasicShopItems", Filter = "FRESH_GOODS" } },
        { Id = "DRY_GOODS",    Label = "Dry Goods",    Source = { Name = "BasicShopItems", Filter = "DRY_GOODS" } },
        { Id = "LIQUOR",       Label = "Liquor",       Source = { Name = "BasicShopItems", Filter = "LIQUOR" } },
    }
}

local function getBasicShopItems(filter)
    local items = {}
    for _, item in ipairs(shop_inventory) do
        if not filter or item.Category == filter then
            local player_quantity = player_inventory[item.ID] or 0
            local purchase_quantity = item.__purchase_quantity or 1
            local current_price = (item.SalePrice or item.Price) * purchase_quantity

            local footer = string.format("In stock: %d ~m~|~s~ Owned: %d", item.Stock, player_quantity)

            if item.Stock < 3 then
                footer = string.format("In stock: ~o~%d~s~ ~m~|~s~ Owned: %d", item.Stock, player_quantity)
            end

            table.insert(items, {
                Id = "SHOP_ITEM_" .. item.ID,
                Type = "INVENTORY",
                Auto = item.ID,
                Footer = footer,
                Disabled = item.Stock <= 0,
                Prompts = {
                    Select = {
                        Visible = true,
                        Held = current_price >= 2000,
                        Label = purchase_quantity > 1 and string.format("Buy %dx", purchase_quantity) or "Buy"
                    },
                    Adjust = {
                        Visible = item.Stock > 1,
                        Label = "Quantity"
                    }
                },
                Data = {
                    DisabledFooter = "~e~Out of stock~s~ ~m~|~s~ Owned: " .. (player_quantity),
                    IsOnSale = item.SalePrice ~= nil,
                    ForSale = true,
                    Price = current_price,
                    Pricing = {
                        Price = current_price,
                        SalePrice = item.SalePrice and (item.Price * purchase_quantity) or nil,
                        Affordable = true,
                        LeftText = "Price",
                    }
                }
            })
        end
    end

    return items
end

AddEventHandler("native_shop:item_action", function(event)
    if ShopNavigator:getRootMenuId() ~= MENU_ID then
        return
    end

    if event.Action == "adjust" and tostring(event.ID):find("SHOP_ITEM_") then
        local delta = event.ActionParameter or 0
        local itemId = tostring(event.ID):gsub("SHOP_ITEM_", "")

        for _, item in ipairs(shop_inventory) do
            if item.ID == itemId then
                local quantity = item.__purchase_quantity or 1

                if item.Stock <= 1 then
                    quantity = 1
                else
                    quantity = math.max(1, quantity + delta)
                    quantity = math.min(quantity, item.Stock)
                end

                item.__purchase_quantity = quantity
                TriggerEvent("shop:refresh_menu", MENU_ID)
                return
            end
        end
    end
end)

AddEventHandler("native_shop:item_selected", function(event)
    if ShopNavigator:getRootMenuId() ~= MENU_ID then
        return
    end

    if tostring(event.ID):find("SHOP_ITEM_") then
        local itemId = tostring(event.ID):gsub("SHOP_ITEM_", "")

        for _, item in ipairs(shop_inventory) do
            if item.ID == itemId then
                local quantity = item.__purchase_quantity or 1

                item.Stock = item.Stock - quantity
                player_inventory[item.ID] = (player_inventory[item.ID] or 0) + quantity

                item.__purchase_quantity = nil
                TriggerEvent("shop:refresh_menu", MENU_ID)
                return
            end
        end
    end
end)

ShopNavigator:register(data, { BasicShopItems = getBasicShopItems })
