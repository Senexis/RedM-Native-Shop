local function getTestItemsItems(type)
    local types = {
        BUSINESS = {
            Description = "Business item description",
            Progress = 0.33,
            TextColor = "COLOR_GOLD",
            Texture = "MENU_ICON_TICK",
            TextureDictionary = "MENU_TEXTURES",
            TimeIconVisible = true,
            IsNew = true,
        },
        COUPON = {
            Description = "Coupon item description",
            IsMaxCount = true,
            Quantity = 3,
            TextColor = "COLOR_GOLD",
            Texture = "MENU_ICON_TICK",
            TextureDictionary = "MENU_TEXTURES",
            TimeIconVisible = true,
            IsNew = true,
        },
        HAIR = {
            Description = "Hair item description",
            IsMaxCount = true,
            Quantity = 3,
            Texture = "MENU_ICON_TICK",
            TextureDictionary = "MENU_TEXTURES",
            TickVisible = true,
            IsNew = true,
        },
        INVENTORY = {
            Equipped = true,
            EquippedTexture = "MENU_ICON_TICK",
            EquippedTextureDictionary = "MENU_TEXTURES",
            ForSale = true,
            FrontSlotTexture = "MENU_ICON_TICK",
            FrontSlotTextureColour = "COLOR_GOLD",
            FrontSlotTextureDictionary = "MENU_TEXTURES",
            FrontSlotTextureVisible = true,
            Locked = false,
            Owned = true,
            Price = 500,
            Rank = 25,
            RankTexture = "MENU_ICON_TICK",
            RankLocked = false,
            IsNew = true,
            IsOnSale = true,
            UseGoldPrice = false,
        },
        PALETTE = {
            Equipped = true,
            IconVisible = true,
            IsNew = true,
            IsOnSale = true,
            IconTexture = "MENU_ICON_TICK",
            IconTextureDictionary = "MENU_TEXTURES",
        },
        SADDLE = {
            BackTexture = "MENU_ICON_TICK",
            BackTextureColour = "COLOR_GOLD",
            BackTextureDictionary = "MENU_TEXTURES",
            BackTextureVisible = true,
            FrontSlotTextureColour = "COLOR_GOLD",
            FrontSlotTextureVisible = true,
            FrontSlotTexture = "MENU_ICON_TICK",
        },
        STABLE = {
            BackTexture = "MENU_ICON_TICK",
            BackTextureColour = "COLOR_GOLD",
            BackTextureDictionary = "MENU_TEXTURES",
            BackTextureVisible = true,
            FrontAddSlotTexture = "MENU_ICON_TICK",
            FrontAddSlotTextureColour = "COLOR_GOLD",
            FrontAddSlotTextureDictionary = "MENU_TEXTURES",
            FrontAddSlotTextureVisible = true,
            FrontSlotTexture = "MENU_ICON_TICK",
            FrontSlotTextureColour = "COLOR_GOLD",
            FrontSlotTextureDictionary = "MENU_TEXTURES",
            FrontSlotTextureVisible = true,
            IsNew = true,
            IsOnSale = true,
        },
        STEPPER = {
            IconTexture = "MENU_ICON_TICK",
            IconTextureDict = "MENU_TEXTURES",
            IconVisible = true,
            IsNew = true,
            IsOnSale = true,
            StepperOptions = { "Visible", "Hidden" },
            StepperValue = 1,
            StepperVisible = true,
            StepperTextureVisible = false,
            StepperTexture = 0,
            StepperTextureDict = 0,
        },
        TEXT = {
            AddIconTexture = "MENU_ICON_TICK",
            AddIconTextureDict = "MENU_TEXTURES",
            AddIconVisible = true,
            Equipped = true,
            OnHorse = true,
            RightLabelVisible = true,
            RightText = "Right text",
            IsNew = true,
            IsOnSale = true,
        },
    }

    return types[type]
end

local function getTestItemsMenus()
    local menuTypes = {
        BUSINESS = { Label = "Business Item", Description = "Business items are primarily used in the moonshine shack." },
        COUPON = { Label = "Coupon Item", Description = "Coupon items are used to display coupons providing discounts on purchases." },
        HAIR = { Label = "Hair Item", Description = "Hair items are used at barbers to display hairstyles and facial hair." },
        INVENTORY = { Label = "Inventory Item", Description = "Inventory items are used throughout the game for various purposes." },
        PALETTE = { Label = "Palette Item", Description = "Palette items are used to display chosen colors for clothing and other items." },
        SADDLE = { Label = "Saddle Item", Description = "Saddle items are used in stables to display saddles." },
        STABLE = { Label = "Stable Item", Description = "Stable items are used to display horse-related items." },
        STEPPER = { Label = "Stepper Item", Description = "Stepper items are used to select options from a list." },
        TEXT = { Label = "Text Item", Description = "Text items are used throughout the game to display various text elements." },
    }

    local menus = {}

    for type, item in pairs(menuTypes) do
        local items = {}

        for i = 1, 10 do
            table.insert(items, {
                Id = "TEST_ITEMS_" .. type .. "_ITEM_" .. i,
                Type = type,
                Label = item.Label .. " " .. i,
                Data = getTestItemsItems(type)
            })
        end

        table.insert(menus, {
            Id = "TEST_ITEMS_" .. type .. "_MENU",
            Scene = "MENU_LIST",
            Label = item.Label .. "s",
            Items = items,
            Data = {
                ItemDescription = item.Description,
            }
        })
    end

    return menus
end

local data = {
    Id = "FEATURE_ITEM_TYPES",
    Scene = "MENU_LIST",
    Title = "FEATURES",
    Subtitle = "Item Types",
    Items = getTestItemsMenus()
}

ShopNavigator:register(data)
