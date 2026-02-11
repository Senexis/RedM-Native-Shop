local function getTestMenusItems(id, shouldUseSwatch)
    if not shouldUseSwatch then
        shouldUseSwatch = false
    end

    local pricing = {
        Price = 1000,
        Tokens = 1,
        SalePrice = 990,
        UseGoldPrice = false,
        Affordable = true,
        LeftText = "Price Text",
        RightText = "Amount Text",
        Locked = false,
        Rank = 25
    }

    local itemDescription = "A test item description for the item being displayed in the shop menu."

    local itemInfo1 = {
        Visible = true,
        Text = "Item Info 1 Text",
        Centered = true,
        IconVisible = true,
        IconTextureDictionary = "MENU_TEXTURES",
        IconTexture = "MENU_ICON_TICK",
    }

    local itemInfo2 = {
        Visible = true,
        Text = "Item Info 2 Text",
        Centered = false,
        IconVisible = true,
        IconTextureDictionary = "MENU_TEXTURES",
        IconTexture = "MENU_ICON_TICK",
    }

    local weather = {
        Visible = true,
        Enabled = true,
        Opacity = 1,
        Warmth = 4
    }

    local outfitWeather = {
        Visible = true,
        Enabled = true,
        Opacity = 1,
        Effectiveness = 2
    }

    local horseStats = {
        Primary = true,
        Speed = {
            Value = 5,
            MinValue = 0,
            MaxValue = 10,
            CapacityValue = 7,
            CapacityMinValue = 0,
            CapacityMaxValue = 10,
            EquipmentValue = 6,
            EquipmentMinValue = 0,
            EquipmentMaxValue = 10,
        },
        Acceleration = {
            Value = 5,
            MinValue = 0,
            MaxValue = 10,
            CapacityValue = 7,
            CapacityMinValue = 0,
            CapacityMaxValue = 10,
            EquipmentValue = 6,
            EquipmentMinValue = 0,
            EquipmentMaxValue = 10,
        },
        HandlingText = "Test Handling",
        TypeText = "Test Type",
        BreedText = "Test Breed",
        CoatText = "Test Coat",
        GenderText = "Test Gender",
    }

    local vehicleStats = {
        Primary = true,
        MaxSpeed = "Test MaxSpeed",
        Acceleration = "Test Acceleration",
        Steering = "Test Steering",
        ItemDescription = "Test Description",
    }

    local weaponStats = {
        Power = { Value = 50, Diff = 75, New = 25 },
        Range = { Value = 50, Diff = 75, New = 25 },
        Accuracy = { Value = 50, Diff = 75, New = 25 },
        FireRate = { Value = 50, Diff = 75, New = 25 },
        Reload = { Value = 50, Diff = 75, New = 25 },
    }

    local rpgEffects = {
        Health = { Value = 4, Duration = 0 },
        Stamina = { Value = 4, Duration = 0 },
        Deadeye = { Value = 4, Duration = 0 },
        HealthCore = { Value = 4, Duration = 0 },
        StaminaCore = { Value = 4, Duration = 0 },
        DeadeyeCore = { Value = 4, Duration = 0 },
        HealthHorse = { Value = 4, Duration = 0 },
        StaminaHorse = { Value = 4, Duration = 0 },
        HealthCoreHorse = { Value = 4, Duration = 0 },
        StaminaCoreHorse = { Value = 4, Duration = 0 },
    }

    local sliderInfo = {
        Visible = true,
        Enabled = true,
        Value = 1,
        MaxValue = 6,
        TotalTanks = 10,
        ActiveTanks = 5,
    }

    local businessInfo = {
        Visible = true,
        Description = "Icons will change alpha value depending on position in the menu (1, 2, 3). 60% for inactive, 100% for active.",
        MaterialsIconDictionary = "MENU_TEXTURES",
        MaterialsIcon = "MENU_ICON_TICK",
        ProductionIconDictionary = "MENU_TEXTURES",
        ProductionIcon = "MENU_ICON_TICK",
        GoodsIconDictionary = "MENU_TEXTURES",
        GoodsIcon = "MENU_ICON_TICK",
    }

    local recipeFooter = {
        Visible = true,
        TitleType = 0,
        Items = {
            { Enabled = true,  Name = "Test Item 1", Count = 1, TextureDictionary = "MENU_TEXTURES", Texture = "MENU_ICON_TICK" },
            { Enabled = true,  Name = "Test Item 2", Count = 2, TextureDictionary = "MENU_TEXTURES", Texture = "MENU_ICON_TICK" },
            { Enabled = false, Name = "Test Item 3", Count = 3, TextureDictionary = "MENU_TEXTURES", Texture = "MENU_ICON_TICK" },
        }
    }

    local saddleStats = {
        Visible = true,
        Items = {
            {
                Enabled = true,
                IconVisible = true,
                IconTextureDictionary = "MENU_TEXTURES",
                IconTexture = "MENU_ICON_TICK",
                Text = "Saddle Stat 1",
                Value = "Value 1",
                EndIconVisible = true,
                EndIconTextureDictionary = "MENU_TEXTURES",
                EndIconTexture = "MENU_ICON_TICK",
            },
            {
                Enabled = true,
                IconVisible = false,
                IconTextureDictionary = "MENU_TEXTURES",
                IconTexture = "MENU_ICON_TICK",
                Text = "Saddle Stat 2",
                Value = "Value 2",
                EndIconVisible = true,
                EndIconTextureDictionary = "MENU_TEXTURES",
                EndIconTexture = "MENU_ICON_TICK",
            },
            {
                Enabled = true,
                IconVisible = true,
                IconTextureDictionary = "MENU_TEXTURES",
                IconTexture = "MENU_ICON_TICK",
                Text = "Saddle Stat 3",
                Value = "Value 3",
                EndIconVisible = false,
                EndIconTextureDictionary = "MENU_TEXTURES",
                EndIconTexture = "MENU_ICON_TICK",
            },
            {
                Enabled = false,
                IconVisible = true,
                IconTextureDictionary = "MENU_TEXTURES",
                IconTexture = "MENU_ICON_TICK",
                Text = "Saddle Stat 4",
                Value = "Value 4",
                EndIconVisible = true,
                EndIconTextureDictionary = "MENU_TEXTURES",
                EndIconTexture = "MENU_ICON_TICK",
            }
        }
    }

    local stirrupStats = {
        Visible = true,
        Speed = {
            Value = 5,
            MinValue = 0,
            MaxValue = 10,
            CapacityValue = 7,
            CapacityMinValue = 0,
            CapacityMaxValue = 10,
            EquipmentValue = 6,
            EquipmentMinValue = 0,
            EquipmentMaxValue = 10,
        },
        Acceleration = {
            Value = 5,
            MinValue = 0,
            MaxValue = 10,
            CapacityValue = 7,
            CapacityMinValue = 0,
            CapacityMaxValue = 10,
            EquipmentValue = 6,
            EquipmentMinValue = 0,
            EquipmentMaxValue = 10,
        },
        Items = {
            {
                Enabled = true,
                IconVisible = true,
                IconTextureDictionary = "MENU_TEXTURES",
                IconTexture = "MENU_ICON_TICK",
                Text = "Stirrup Stat 1",
                Value = "Value 1",
                EndIconVisible = true,
                EndIconTextureDictionary = "MENU_TEXTURES",
                EndIconTexture = "MENU_ICON_TICK",
            },
            {
                Enabled = true,
                IconVisible = false,
                IconTextureDictionary = "MENU_TEXTURES",
                IconTexture = "MENU_ICON_TICK",
                Text = "Stirrup Stat 2",
                Value = "Value 2",
                EndIconVisible = true,
                EndIconTextureDictionary = "MENU_TEXTURES",
                EndIconTexture = "MENU_ICON_TICK",
            },
            {
                Enabled = true,
                IconVisible = true,
                IconTextureDictionary = "MENU_TEXTURES",
                IconTexture = "MENU_ICON_TICK",
                Text = "Stirrup Stat 3",
                Value = "Value 3",
                EndIconVisible = false,
                EndIconTextureDictionary = "MENU_TEXTURES",
                EndIconTexture = "MENU_ICON_TICK",
            },
            {
                Enabled = false,
                IconVisible = true,
                IconTextureDictionary = "MENU_TEXTURES",
                IconTexture = "MENU_ICON_TICK",
                Text = "Stirrup Stat 4",
                Value = "Value 4",
                EndIconVisible = true,
                EndIconTextureDictionary = "MENU_TEXTURES",
                EndIconTexture = "MENU_ICON_TICK",
            }
        }
    }

    local palette = {
        Value = 1,
        Items = {
            { Visible = true, Text = "Palette item 1", TextureDictionary = "MENU_TEXTURES", Texture = "CLUB",    New = true,  Owned = true,  Equipped = false, Locked = false },
            { Visible = true, Text = "Palette item 2", TextureDictionary = "MENU_TEXTURES", Texture = "DIAMOND", New = false, Owned = false, Equipped = false, Locked = true },
            { Visible = true, Text = "Palette item 3", TextureDictionary = "MENU_TEXTURES", Texture = "CROSS",   New = false, Owned = false, Equipped = false, Locked = false },
        }
    }

    return {
        {
            Id = id .. "_SET_ITEM_DESCRIPTION",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Item description",
            Footer = shouldUseSwatch and "Item description" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_1",
                ItemDescription = itemDescription,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_BUSINESS_INFO",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Business info",
            Footer = shouldUseSwatch and "Business info" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_2",
                BusinessInfo = businessInfo,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_ITEM_INFO1",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Item info 1",
            Footer = shouldUseSwatch and "Item info 1" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_3",
                ItemInfo1 = itemInfo1,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_ITEM_WEATHER",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Item weather",
            Footer = shouldUseSwatch and "Item weather" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_4",
                Weather = weather,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_OUTFIT_WEATHER",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Outfit weather",
            Footer = shouldUseSwatch and "Outfit weather" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_5",
                OutfitWeather = outfitWeather,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_ITEM_INFO2",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Item info 2",
            Footer = shouldUseSwatch and "Item info 2" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_6",
                ItemInfo2 = itemInfo2,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_HORSE_STATS",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Horse stats",
            Footer = shouldUseSwatch and "Horse stats" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_7",
                HorseStats = horseStats,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_VEHICLE_STATS",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Vehicle stats",
            Footer = shouldUseSwatch and "Vehicle stats" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_8",
                VehicleStats = vehicleStats,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_WEAPON_STATS",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Weapon stats",
            Footer = shouldUseSwatch and "Weapon stats" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_9",
                WeaponStats = weaponStats,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_RPG_EFFECTS",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "RPG effects",
            Footer = shouldUseSwatch and "RPG effects" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_10",
                RpgEffects = rpgEffects,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_SLIDER_INFO",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Slider info",
            Footer = shouldUseSwatch and "Slider info" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_11",
                SliderInfo = sliderInfo,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_RECIPE_FOOTER",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Recipe footer",
            Footer = shouldUseSwatch and "Recipe footer" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_12",
                RecipeFooter = recipeFooter,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_SADDLE_STATS",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Saddle stats",
            Footer = shouldUseSwatch and "Saddle stats" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_13",
                SaddleStats = saddleStats,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_SET_STIRRUP_STATS",
            Type = shouldUseSwatch and "SWATCH" or "TEXT",
            Label = "Stirrup stats",
            Footer = shouldUseSwatch and "Stirrup stats" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_14",
                StirrupStats = stirrupStats,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_PALETTE",
            Type = shouldUseSwatch and "SWATCH" or "PALETTE",
            Label = "Palette",
            Footer = shouldUseSwatch and "Palette" or "",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_15",
                IconVisible = true,
                Palette = palette,
                Pricing = pricing
            }
        },
        {
            Id = id .. "_EVERYTHING",
            Type = shouldUseSwatch and "SWATCH" or "PALETTE",
            Label = "Everything",
            Footer = "For illustration purposes, causes issues",
            Data = {
                TextureDictionary = "overhead",
                Texture = "overhead_kill_16",
                BusinessInfo = businessInfo,
                HorseStats = horseStats,
                IconVisible = true,
                ItemDescription = itemDescription,
                ItemInfo1 = itemInfo1,
                ItemInfo2 = itemInfo2,
                OutfitWeather = outfitWeather,
                Palette = palette,
                Pricing = pricing,
                RecipeFooter = recipeFooter,
                RpgEffects = rpgEffects,
                SaddleStats = saddleStats,
                SliderInfo = sliderInfo,
                StirrupStats = stirrupStats,
                VehicleStats = vehicleStats,
                WeaponStats = weaponStats,
                Weather = weather,
            }
        }
    }
end

local function getTestMenusMenus()
    return {
        {
            Id = "BOUNTY_MANAGEMENT_MENU",
            Scene = "BOUNTY_MANAGEMENT",
            Title = "TEST MENUS",
            Label = "Bounty management",
            Items = getTestMenusItems("BOUNTY_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in postal offices to let you pay off bounties.",
            }
        },
        {
            Id = "CLOTHING_MODIFY_MENU",
            Scene = "CLOTHING_MODIFY",
            Title = "TEST MENUS",
            Label = "Clothing modify",
            Items = getTestMenusItems("CLOTHING_MODIFY"),
            Data = {
                ItemDescription = "Used in tailors to let you modify outfits.",
            }
        },
        {
            Id = "HORSE_MANAGEMENT_MENU",
            Scene = "HORSE_MANAGEMENT",
            Title = "TEST MENUS",
            Label = "Horse management",
            Items = getTestMenusItems("HORSE_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in stables to let you manage your stabled horses.",
            }
        },
        {
            Id = "ITEM_GRID_MENU",
            Scene = "ITEM_GRID",
            Title = "TEST MENUS",
            Label = "Item grid",
            Items = getTestMenusItems("ITEM_GRID", true),
            Data = {
                ItemDescription = "Used in tailors to let you select colors for clothing items.",
            }
        },
        {
            Id = "ITEM_LIST_MENU",
            Scene = "ITEM_LIST",
            Title = "TEST MENUS",
            Label = "Item list",
            Items = getTestMenusItems("ITEM_LIST"),
            Data = {
                ItemDescription = "Used in the game to display a list of items with support for buy, saddle stats, and more.",
            }
        },
        {
            Id = "ITEM_LIST_COLOUR_PALETTE_MENU",
            Scene = "ITEM_LIST_COLOUR_PALETTE",
            Title = "TEST MENUS",
            Label = "Item list color palette",
            Items = getTestMenusItems("ITEM_LIST_COLOUR_PALETTE"),
            Data = {
                ItemDescription = "Used in the game to display a list of items with optional color palettes.",
            }
        },
        {
            Id = "ITEM_LIST_DESCRIPTION_MENU",
            Scene = "ITEM_LIST_DESCRIPTION",
            Title = "TEST MENUS",
            Label = "Item list description",
            Items = getTestMenusItems("ITEM_LIST_DESCRIPTION"),
            Data = {
                ItemDescription = "Similar to item list but with support for different descriptions.",
            }
        },
        {
            Id = "ITEM_LIST_HORSE_STATS_MENU",
            Scene = "ITEM_LIST_HORSE_STATS",
            Title = "TEST MENUS",
            Label = "Item list horse stats",
            Items = getTestMenusItems("ITEM_LIST_HORSE_STATS"),
            Data = {
                ItemDescription = "Used in stables to display a list of horses with their stats.",
            }
        },
        {
            Id = "ITEM_LIST_RECIPES_MENU",
            Scene = "ITEM_LIST_RECIPES",
            Title = "TEST MENUS",
            Label = "Item list recipes",
            Items = getTestMenusItems("ITEM_LIST_RECIPES"),
            Data = {
                ItemDescription = "Used at trappers and moonshine businesses to display craftable items with their recipes.",
            }
        },
        {
            Id = "ITEM_LIST_RPG_STATS_MENU",
            Scene = "ITEM_LIST_RPG_STATS",
            Title = "TEST MENUS",
            Label = "Item list rpg stats",
            Items = getTestMenusItems("ITEM_LIST_RPG_STATS"),
            Data = {
                ItemDescription = "Used in the game to display a list of items with RPG effects.",
            }
        },
        {
            Id = "ITEM_LIST_SLIDER_MENU",
            Scene = "ITEM_LIST_SLIDER",
            Title = "TEST MENUS",
            Label = "Item list slider",
            Items = getTestMenusItems("ITEM_LIST_SLIDER"),
            Data = {
                ItemDescription = "Used at barbers to display a list of hairstyles with a hair length slider.",
            }
        },
        {
            Id = "ITEM_LIST_TEXTURE_DESCRIPTION_MENU",
            Scene = "ITEM_LIST_TEXTURE_DESCRIPTION",
            Title = "TEST MENUS",
            Label = "Item list texture description",
            Items = getTestMenusItems("ITEM_LIST_TEXTURE_DESCRIPTION"),
            Data = {
                ItemDescription = "Used in the game to display a list of items with a texture as well as a description.",
            }
        },
        {
            Id = "ITEM_LIST_VEHICLE_STATS_MENU",
            Scene = "ITEM_LIST_VEHICLE_STATS",
            Title = "TEST MENUS",
            Label = "Item list vehicle stats",
            Items = getTestMenusItems("ITEM_LIST_VEHICLE_STATS"),
            Data = {
                ItemDescription = "Used in stables to display a list of vehicles with their stats.",
            }
        },
        {
            Id = "ITEM_LIST_WEAPON_STATS_MENU",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Title = "TEST MENUS",
            Label = "Item list weapon stats",
            Items = getTestMenusItems("ITEM_LIST_WEAPON_STATS"),
            Data = {
                ItemDescription = "Used in gunsmiths to display a list of weapons with their stats.",
            }
        },
        {
            Id = "ITEM_SELL_LIST_HORSE_STATS_MENU",
            Scene = "ITEM_SELL_LIST_HORSE_STATS",
            Title = "TEST MENUS",
            Label = "Item sell list horse stats",
            Items = getTestMenusItems("ITEM_SELL_LIST_HORSE_STATS"),
            Data = {
                ItemDescription = "Used in stables to display a list of horses to sell with their stats.",
            }
        },
        {
            Id = "MENU_LIST_MENU",
            Scene = "MENU_LIST",
            Title = "TEST MENUS",
            Label = "Menu list",
            Items = getTestMenusItems("MENU_LIST"),
            Data = {
                ItemDescription = "A generic menu list with business support used in various shops throughout the game.",
            }
        },
        {
            Id = "MENU_LIST_HORSE_STATS_MENU",
            Scene = "MENU_LIST_HORSE_STATS",
            Title = "TEST MENUS",
            Label = "Menu list horse stats",
            Items = getTestMenusItems("MENU_LIST_HORSE_STATS"),
            Data = {
                ItemDescription = "Menu list specialized for displaying horse stats.",
            }
        },
        {
            Id = "MENU_LIST_WEAPON_STATS_MENU",
            Scene = "MENU_LIST_WEAPON_STATS",
            Title = "TEST MENUS",
            Label = "Menu list weapon stats",
            Items = getTestMenusItems("MENU_LIST_WEAPON_STATS"),
            Data = {
                ItemDescription = "Menu list specialized for displaying weapon stats.",
            }
        },
        {
            Id = "MENU_STYLE_SELECTOR_MENU",
            Scene = "MENU_STYLE_SELECTOR",
            Title = "TEST MENUS",
            Label = "Menu style selector",
            Items = getTestMenusItems("MENU_STYLE_SELECTOR"),
            Data = {
                ItemDescription = "Used in tailors to let you select styles for clothing items.",
            }
        },
        {
            Id = "SADDLE_MANAGEMENT_MENU",
            Scene = "SADDLE_MANAGEMENT",
            Title = "TEST MENUS",
            Label = "Saddle management",
            Items = getTestMenusItems("SADDLE_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in stables to let you manage your saddles and horse equipment.",
            }
        },
        {
            Id = "VEHICLE_MANAGEMENT_MENU",
            Scene = "VEHICLE_MANAGEMENT",
            Title = "TEST MENUS",
            Label = "Vehicle management",
            Items = getTestMenusItems("VEHICLE_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in stables to let you manage your stabled vehicles.",
            }
        },
        {
            Id = "WEAPON_MANAGEMENT_MENU",
            Scene = "WEAPON_MANAGEMENT",
            Title = "TEST MENUS",
            Label = "Weapon management",
            Items = getTestMenusItems("WEAPON_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in gunsmiths to let you manage your stored weapons.",
            }
        },
        {
            Id = "CLOTHING_STAT_INFO_BOX",
            Scene = "CLOTHING_STAT_INFO_BOX",
            Title = "TEST MENUS",
            Label = "Clothing stats infobox",
            Items = {
                { Id = "CLOTHING_STAT_INFO_BOX_ITEM" }
            },
            Data = {
                ItemDescription = "Used in tailors to display clothing stats in an infobox.",
                InfoBoxName = "Clothing stats infobox",
                OutfitWeather = {
                    Visible = true,
                    Enabled = true,
                    Opacity = 1,
                    Effectiveness = 2
                },
                Pricing = {
                    Price = 1000,
                    Tokens = 1,
                    SalePrice = 990,
                    UseGoldPrice = false,
                    Affordable = true,
                    LeftText = "Test Left",
                    RightText = "Test Right",
                    Locked = false,
                    Rank = 25
                }
            }
        },
        {
            Id = "HORSE_STAT_INFO_BOX",
            Scene = "HORSE_STAT_INFO_BOX",
            Title = "TEST MENUS",
            Label = "Horse stats infobox",
            Items = {
                { Id = "HORSE_STAT_INFO_BOX_ITEM" }
            },
            Data = {
                ItemDescription = "Used in stables to display horse stats in an infobox.",
                InfoBoxName = "Horse stats infobox",
                HorseInfoBox = {
                    Visible = true,
                    Stats = false,
                    Text = "Horse stats infobox item",
                    ItemDescription = "This is a test description for the horse stats info box.",
                    TipText = "Horse stats infobox tip"
                },
                HorseStats = {
                    Primary = false,
                    Speed = {
                        Value = 5,
                        MinValue = 0,
                        MaxValue = 10,
                        CapacityValue = 7,
                        CapacityMinValue = 0,
                        CapacityMaxValue = 10,
                        EquipmentValue = 6,
                        EquipmentMinValue = 0,
                        EquipmentMaxValue = 10,
                    },
                    Acceleration = {
                        Value = 5,
                        MinValue = 0,
                        MaxValue = 10,
                        CapacityValue = 7,
                        CapacityMinValue = 0,
                        CapacityMaxValue = 10,
                        EquipmentValue = 6,
                        EquipmentMinValue = 0,
                        EquipmentMaxValue = 10,
                    },
                    HandlingText = "Test Handling",
                    TypeText = "Test Type",
                    BreedText = "Test Breed",
                    CoatText = "Test Coat",
                    GenderText = "Test Gender",
                }
            },
        },
    }
end

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
            StepperValue = 0,
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
            Title = "TEST ITEMS",
            Label = item.Label .. "s",
            Items = items,
            Data = {
                ItemDescription = item.Description,
            }
        })
    end

    return menus
end

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
    Id = "TEST_MENU",
    Title = "NATIVE SHOP",
    Subtitle = "Crafted by Senexis",
    Scene = "MENU_LIST",
    AllowWalking = true,
    RepositionCamera = true,
    Items = {
        {
            Id = "FEATURES_MENU",
            Scene = "MENU_LIST",
            Label = "Features",
            Items = {
                {
                    Id = "TEST_MENUS",
                    Scene = "MENU_LIST",
                    Title = "MENU TYPES",
                    Subtitle = "Select a test menu",
                    Label = "Menu Types",
                    Items = getTestMenusMenus(),
                    Data = {
                        ItemDescription = "A preview of the different menus. Not all options are supported in every menu. Pricing is included in all items, but can be omitted if desired.",
                    }
                },
                {
                    Id = "TEST_ITEMS",
                    Scene = "MENU_LIST",
                    Title = "ITEM TYPES",
                    Subtitle = "Select a test item",
                    Label = "Item Types",
                    Items = getTestItemsMenus(),
                    Data = {
                        ItemDescription = "A preview of the different menu items. Used within various menus to showcase different item data options.",
                    }
                },
                {
                    Id = "PROMPTS_MENU",
                    Scene = "MENU_LIST",
                    Label = "Prompts",
                    Items = {
                        {
                            Id = "PROMPTS_ACTION",
                            Type = "TEXT",
                            Label = "Prompts",
                            Footer = "This is the default footer",
                            Prompts = {
                                Select = { Visible = true, Label = "Custom Select" },
                                Option = { Visible = true, Label = "Custom Option" },
                                Toggle = { Visible = true, Label = "Custom Toggle" },
                                Info = { Visible = true, Label = "Custom Info" },
                                Adjust = { Visible = true, Label = "Custom Adjust" },
                                Modify = { Visible = true, Label = "Custom Modify" },
                            },
                            Data = {
                                ItemDescription = "Showcases an example of custom prompt labels for all available prompts.",
                                DisabledFooter = "~e~Disabled footer overrides default footer",
                            }
                        },
                        {
                            Id = "HELD_PROMPTS_ACTION",
                            Type = "TEXT",
                            Label = "Held Prompts",
                            Footer = "This is the default footer",
                            Prompts = {
                                Select = { Visible = true, Label = "Held Select", Held = true },
                                Option = { Visible = true, Label = "Held Option", Held = true },
                                Toggle = { Visible = true, Label = "Held Toggle", Held = true },
                                Info = { Visible = true, Label = "Info (not supported)", Held = false },
                                Adjust = { Visible = true, Label = "Adjust (not supported)", Held = false },
                                Modify = { Visible = true, Label = "Modify (not supported)", Held = false },
                            },
                            Data = {
                                ItemDescription = "Showcases an example of held prompts for all available prompts.",
                                DisabledFooter = "~e~Disabled footer overrides default footer",
                            }
                        },
                        {
                            Id = "DISABLED_PROMPTS_ACTION",
                            Type = "TEXT",
                            Label = "Disabled Prompts",
                            Disabled = true,
                            Footer = "This is the default footer",
                            Prompts = {
                                Select = { Visible = true, Label = "Disabled Select" },
                                Option = { Visible = true, Label = "Disabled Option" },
                                Toggle = { Visible = true, Label = "Disabled Toggle" },
                                Info = { Visible = true, Label = "Disabled Info" },
                                Adjust = { Visible = true, Label = "Disabled Adjust" },
                                Modify = { Visible = true, Label = "Disabled Modify" },
                            },
                            Data = {
                                ItemDescription = "Showcases what happens when an item is disabled with custom prompts and a footer. Also has effects on scene UI.",
                                DisabledFooter = "~e~Disabled footer overrides default footer",
                            }
                        },
                    },
                    Data = {
                        ItemDescription = "A demo menu showcasing all available prompt types with custom labels, held prompts, and disabled prompts.",
                    }
                },
                {
                    Id = "ACTIONS_MENU",
                    Type = "MENU_LIST",
                    Label = "Actions",
                    Items = {
                        {
                            Id = "ACTION_BACK",
                            Type = "TEXT",
                            Label = "Go Back",
                            Action = "BACK",
                            Data = {
                                ItemDescription = "Showcases an example of an item that goes back a page when selected.",
                            }
                        },
                        {
                            Id = "ACTION_ROOT",
                            Type = "TEXT",
                            Label = "Go to Root",
                            Action = "ROOT",
                            Data = {
                                ItemDescription = "Showcases an example of an item that goes to the root page when selected.",
                            }
                        },
                        {
                            Id = "ACTION_LINK_ONLY",
                            Type = "TEXT",
                            Label = "Link to Menu",
                            LinkMenuId = "TEST_SUB_MENU",
                            LinkPageId = nil,
                            Data = {
                                ItemDescription = "Showcases an example of a menu link. Selecting this item will take you to another menu.",
                            }
                        },
                        {
                            Id = "ACTION_LINK_WITH_PAGE_PARENT",
                            Type = "TEXT",
                            Label = "Link to Page (Type 1)",
                            LinkMenuId = "TEST_SUB_MENU",
                            LinkPageId = "TEST_PAGE_LINK",
                            LinkBackToParent = true,
                            Data = {
                                ItemDescription = "Showcases an example of a menu link with a specific page. Selecting this item will take you to the specified page in the sub-menu. When navigating back, it will return you to the parent page.",
                            }
                        },
                        {
                            Id = "ACTION_LINK_WITH_PAGE_NO_PARENT",
                            Type = "TEXT",
                            Label = "Link to Page (Type 2)",
                            LinkMenuId = "TEST_SUB_MENU",
                            LinkPageId = "TEST_PAGE_LINK",
                            LinkBackToParent = false,
                            Data = {
                                ItemDescription = "Showcases an example of a menu link with a specific page. Selecting this item will take you to the specified page in the sub-menu. When navigating back, it will return you back here instead of the parent page.",
                            }
                        },
                        {
                            Id = "ACTION_CLOSE_MENU",
                            Type = "TEXT",
                            Label = "Close Menu",
                            Action = "CLOSE",
                            Data = {
                                ItemDescription = "Showcases an example of an item that closes the menu when selected.",
                            }
                        }
                    },
                    Data = {
                        ItemDescription = "Showcases examples of common menu actions such as closing the menu, going back a page, or linking to another menu.",
                    }
                },
                {
                    Id = "LONG_MENU",
                    Scene = "MENU_LIST",
                    Label = "Long Menu",
                    Items = getLongMenu(),
                    Footer = "~e~Caution: This may cause a slight stutter to occur",
                    Data = {
                        ItemDescription = "A menu with a large number of items to test scrolling behavior.",
                    }
                }
            },
            Data = {
                ItemDescription = "A showcase of all the different menu features in one place. Check out the code for details on each feature.",
            }
        },
        {
            Id = "DEMO_MENU",
            Scene = "MENU_LIST",
            Label = "Demos",
            Footer = "senexis.dev/r/RedM-Native-Shop",
            Items = {
                {
                    Id = "DEMO_FAST_TRAVEL",
                    Scene = "ITEM_LIST_DESCRIPTION",
                    Title = "FAST TRAVEL",
                    Subtitle = "Overriden by tab",
                    Label = "Fast Travel",
                    Tabs = {
                        { Id = "TAB_ALL",        Label = "All",            Source = { Name = "DynamicFilterMenu", Filter = nil } },
                        { Id = "AMBARINO",       Label = "Ambarino",       Source = { Name = "DynamicFilterMenu", Filter = "REG_AMBARINO" } },
                        { Id = "NEW_HANOVER",    Label = "New Hanover",    Source = { Name = "DynamicFilterMenu", Filter = "REG_NEW_HANOVER" } },
                        { Id = "LEMOYNE",        Label = "Lemoyne",        Source = { Name = "DynamicFilterMenu", Filter = "REG_LEMOYNE" } },
                        { Id = "WEST_ELIZABETH", Label = "West Elizabeth", Source = { Name = "DynamicFilterMenu", Filter = "REG_WEST_ELIZABETH" } },
                        { Id = "NEW_AUSTIN",     Label = "New Austin",     Source = { Name = "DynamicFilterMenu", Filter = "REG_NEW_AUSTIN" } },
                    },
                    Data = {
                        ItemDescription = "A demo fast travel menu showcasing dynamic items and filtering. Move to see the distances update in real time.",
                    }
                },
                {
                    Id = "DEMO_MOONSHINE",
                    Scene = "MENU_LIST",
                    Title = "Moonshiner Business",
                    Subtitle = "Moonshine Production",
                    Label = "Moonshine",
                    Items = {
                        {
                            Id = "MOONSHINE_STILL",
                            Scene = "ITEM_LIST_DESCRIPTION",
                            Title = "Moonshiner Business",
                            Type = "BUSINESS",
                            Label = "Moonshine Still",
                            Footer = "Mash required to start production",
                            Data = {
                                Description = "Mash Required",
                                Progress = 0,
                                TextColor = "COLOR_WHITE",
                                Texture = "moonshiner_workbench_still_empty",
                                TextureDictionary = "toast_mp_roles",
                                TimeIconVisible = false,
                                IsNew = false,
                                BusinessInfo = {
                                    Visible = true,
                                    Description = "Mash is required to start the production process. The Moonshine strength selected will determine completion time.",
                                    MaterialsIconDictionary = "toast_mp_roles",
                                    MaterialsIcon = "moonshiner_workbench_still_empty",
                                    ProductionIconDictionary = "toast_mp_roles",
                                    ProductionIcon = "moonshiner_workbench_flavoring",
                                    GoodsIconDictionary = "toast_mp_roles",
                                    GoodsIcon = "moonshiner_workbench_moonshine",
                                }
                            },
                            Items = {
                                {
                                    Id = "MOONSHINE_STRENGTH_WEAK",
                                    Type = "COUPON",
                                    Label = "Weak Moonshine",
                                    Footer = "Mash required to start production",
                                    Data = {
                                        Description = "24 mins to produce",
                                        Progress = 100,
                                        TextColor = "COLOR_WHITE",
                                        Texture = "moonshiner_workbench_still_weak",
                                        TextureDictionary = "toast_mp_roles",
                                        TimeIconVisible = false,
                                        IsNew = false,
                                        Pricing = {
                                            Price = 5000,
                                            Tokens = 0,
                                            SalePrice = nil,
                                            UseGoldPrice = false,
                                            Affordable = true,
                                            LeftText = "Mash Price",
                                            RightText = nil,
                                            Locked = false,
                                            Rank = nil
                                        }
                                    }
                                },
                                {
                                    Id = "MOONSHINE_STRENGTH_AVERAGE",
                                    Type = "COUPON",
                                    Label = "Average Moonshine",
                                    Footer = "Mash required to start production",
                                    Data = {
                                        Description = "36 mins to produce",
                                        Progress = 0,
                                        TextColor = "COLOR_WHITE",
                                        Texture = "moonshiner_workbench_still_average",
                                        TextureDictionary = "toast_mp_roles",
                                        TimeIconVisible = false,
                                        IsNew = false,
                                        Pricing = {
                                            Price = 5000,
                                            Tokens = 0,
                                            SalePrice = nil,
                                            UseGoldPrice = false,
                                            Affordable = true,
                                            LeftText = "Mash Price",
                                            RightText = nil,
                                            Locked = false,
                                            Rank = nil
                                        }
                                    }
                                },
                                {
                                    Id = "MOONSHINE_STRENGTH_STRONG",
                                    Type = "COUPON",
                                    Label = "Strong Moonshine",
                                    Footer = "Mash required to start production",
                                    Data = {
                                        Description = "48 mins to produce",
                                        Progress = 0,
                                        TextColor = "COLOR_WHITE",
                                        Texture = "moonshiner_workbench_still_strong",
                                        TextureDictionary = "toast_mp_roles",
                                        TimeIconVisible = false,
                                        IsNew = false,
                                        Pricing = {
                                            Price = 5000,
                                            Tokens = 0,
                                            SalePrice = nil,
                                            UseGoldPrice = false,
                                            Affordable = true,
                                            LeftText = "Mash Price",
                                            RightText = nil,
                                            Locked = false,
                                            Rank = nil
                                        }
                                    }
                                }
                            }
                        },
                        {
                            Id = "MOONSHINE_FLAVOR",
                            Scene = "ITEM_LIST_RECIPES",
                            Title = "Moonshiner Business",
                            Type = "BUSINESS",
                            Label = "Flavoring",
                            Footer = "Mash required to start production",
                            Data = {
                                Description = "Unflavored",
                                Progress = 0,
                                TextColor = "COLOR_WHITE",
                                Texture = "moonshiner_workbench_flavoring",
                                TextureDictionary = "toast_mp_roles",
                                TimeIconVisible = false,
                                IsNew = true,
                                BusinessInfo = {
                                    Visible = true,
                                    Description = "View a selection of recipes to add flavor to your moonshine. Flavors are requested from certain buyers.",
                                    MaterialsIconDictionary = "toast_mp_roles",
                                    MaterialsIcon = "moonshiner_workbench_still_empty",
                                    ProductionIconDictionary = "toast_mp_roles",
                                    ProductionIcon = "moonshiner_workbench_flavoring",
                                    GoodsIconDictionary = "toast_mp_roles",
                                    GoodsIcon = "moonshiner_workbench_moonshine",
                                }
                            },
                            Items = {
                                {
                                    Id = "RECIPE_COBBLER_MOONSHINE",
                                    Type = "COUPON",
                                    Label = "Wild Creek Moonshine",
                                    Footer = "Buyers reset: 24hrs 0mins 0sec",
                                    Data = {
                                        Description = "$247.50 Value",
                                        TextColor = "COLOR_WHITE",
                                        Texture = "moonshiner_workbench_flavoring_quality_02",
                                        TextureDictionary = "toast_mp_roles",
                                        TimeIconVisible = false,
                                        IsNew = false,
                                        RecipeFooter = {
                                            Visible = true,
                                            TitleType = 0,
                                            Items = {
                                                { Enabled = true, Name = "1 x Wild Mint",      Count = 13, TextureDictionary = "inventory_items",    Texture = "consumable_herb_wild_mint" },
                                                { Enabled = true, Name = "1 x Vanilla Flower", Count = 3,  TextureDictionary = "inventory_items",    Texture = "consumable_herb_vanilla_flower" },
                                                { Enabled = true, Name = "1 x Creek Plum",     Count = 6,  TextureDictionary = "inventory_items_mp", Texture = "provision_wldflwr_creek_plum" },
                                            }
                                        }
                                    }
                                },
                                {
                                    Id = "RECIPE_TROPICAL_MOONSHINE",
                                    Type = "COUPON",
                                    Label = "Tropical Punch Moonshine",
                                    Footer = "Buyers reset: 24hrs 0mins 0sec",
                                    Disabled = true,
                                    Data = {
                                        Description = "$206.25 Value",
                                        TextColor = "COLOR_WHITE",
                                        Texture = "moonshiner_workbench_flavoring_quality_01",
                                        TextureDictionary = "toast_mp_roles",
                                        TimeIconVisible = false,
                                        IsNew = true,
                                        RecipeFooter = {
                                            Visible = true,
                                            TitleType = 0,
                                            Items = {
                                                { Enabled = false, Name = "1 x Canned Pineapples", Count = 0, TextureDictionary = "inventory_items", Texture = "consumable_pineapples_can" },
                                                { Enabled = true,  Name = "1 x Pear",              Count = 6, TextureDictionary = "inventory_items", Texture = "consumable_pear" },
                                                { Enabled = true,  Name = "1 x Vanilla Flower",    Count = 9, TextureDictionary = "inventory_items", Texture = "consumable_herb_vanilla_flower" },
                                            }
                                        }
                                    }
                                }
                            }
                        },
                        {
                            Id = "MOONSHINE_BOTTLES",
                            Scene = "ITEM_LIST_DESCRIPTION",
                            Type = "BUSINESS",
                            Title = "Moonshiner Business",
                            Subtitle = "Moonshine Production",
                            Label = "Moonshine",
                            Footer = "Mash required to start production",
                            Data = {
                                Description = "18/20 Bottles",
                                Progress = 18 / 20,
                                TextColor = "COLOR_WHITE",
                                Texture = "moonshiner_workbench_moonshine",
                                TextureDictionary = "toast_mp_roles",
                                TimeIconVisible = false,
                                IsNew = false,
                                BusinessInfo = {
                                    Visible = true,
                                    Description = "Select from a list of potential buyers who requested your moonshine flavor. Buyers will refresh every 2 days.",
                                    MaterialsIconDictionary = "toast_mp_roles",
                                    MaterialsIcon = "moonshiner_workbench_still_empty",
                                    ProductionIconDictionary = "toast_mp_roles",
                                    ProductionIcon = "moonshiner_workbench_flavoring",
                                    GoodsIconDictionary = "toast_mp_roles",
                                    GoodsIcon = "moonshiner_workbench_moonshine",
                                }
                            },
                            Items = {
                                {
                                    Id = "BUYER_BERT",
                                    Type = "COUPON",
                                    Label = "Bert Higgins",
                                    Footer = "Buyers reset: 24hrs 0mins 0sec",
                                    Data = {
                                        ItemDescription = "This buyer pays lower prices, but will accept all flavored or unflavored moonshine.",
                                        Description = "All Flavors",
                                        TextColor = "COLOR_WHITE",
                                        Texture = "mp_u_m_m_buyer_default_01",
                                        TextureDictionary = "moonshiner_requests",
                                        TimeIconVisible = false,
                                        IsNew = false,
                                        Pricing = {
                                            Price = 28875,
                                            Tokens = 0,
                                            SalePrice = nil,
                                            UseGoldPrice = false,
                                            Affordable = true,
                                            LeftText = "Buyer Offer",
                                            RightText = nil,
                                            Locked = false,
                                            Rank = nil
                                        }
                                    }
                                },
                                {
                                    Id = "BUYER_NATE",
                                    Type = "COUPON",
                                    Label = "Nate Abney",
                                    Footer = "Buyers reset: 24hrs 0mins 0sec",
                                    Disabled = true,
                                    Data = {
                                        ItemDescription = "This buyer pays higher prices, but will only accept a certain flavor or unflavored moonshine.",
                                        Description = "Berry Mint Moonshine",
                                        TextColor = "COLOR_WHITE",
                                        Texture = "mp_u_m_m_buyer_regular_01",
                                        TextureDictionary = "moonshiner_requests",
                                        TimeIconVisible = false,
                                        IsNew = false,
                                        Pricing = {
                                            Price = 49500,
                                            Tokens = 0,
                                            SalePrice = nil,
                                            UseGoldPrice = false,
                                            Affordable = true,
                                            LeftText = "Buyer Offer",
                                            RightText = nil,
                                            Locked = false,
                                            Rank = nil
                                        }
                                    }
                                }
                            }
                        }
                    },
                    Data = {
                        ItemDescription = "A demo moonshine business menu aiming to recreate the moonshine production menus.",
                    }
                },
                {
                    Id = "DEMO_COOLDOWN",
                    Type = "TEXT",
                    Label = "Cooldown",
                    Prompts = {
                        Select = { Visible = true, Label = "Select" }
                    },
                    Data = {
                        ItemDescription = "Showcases an example of disabling an item with a cooldown timer displayed in the footer.",
                        DisabledFooter = "~e~This is the default disabled fallback text"
                    }
                },
            },
            Data = {
                ItemDescription = "A showcase of various menu features in practice. Have a cool idea for a demo? Report it on the GitHub page!",
            }
        },
        {
            Id = "SENEXIS_MENU",
            Scene = "MENU_LIST",
            Label = "Support me!",
            Items = {
                {
                    Id = "ITEM_GITHUB",
                    Label = "Github",
                    Footer = "senexis.dev",
                    Data = {
                        ItemDescription = "Check out my projects on GitHub! If you choose to support me, much appreciated!"
                    }
                },
                {
                    Id = "ITEM_RDO_GG",
                    Label = "RDO.GG",
                    Footer = "rdo.gg",
                    Data = {
                        ItemDescription = "Check out my RDO Compendium project! If you need a Red Dead Discord bot, this is the one to get."
                    }
                },
                {
                    Id = "ITEM_PATREON",
                    Label = "Patreon",
                    Footer = "rdo.gg/patreon",
                    Data = {
                        ItemDescription = "Support my work on Patreon! These projects will always remain free of charge."
                    }
                }
            },
            Data = {
                ItemDescription = "If you like my work and would like to support me, check out these links! Thank you for your support!"
            }
        }
    },
}

if not HasStreamedTxdLoaded("moonshiner_requests") then
    RequestStreamedTxd("moonshiner_requests", false)
end

local function getDynamicFilterMenu(filter)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)

    local places = {
        { Id = "ANNESBERG",   Name = "STATION_ANNESBERG",   Description = "NFT_ANNESBERG_DESC",   Type = "REG_NEW_HANOVER",    Position = vector3(2934.167, 1273.326, 44.653) },
        { Id = "ARMADILLO",   Name = "STATION_ARMADILLO",   Description = "NFT_ARMADILLO_DESC",   Type = "REG_NEW_AUSTIN",     Position = vector3(-3734.225, -2602.259, -12.917) },
        { Id = "BLACKWATER",  Name = "STATION_BLACKWATER",  Description = "NFT_BLACKWATER_DESC",  Type = "REG_NEW_AUSTIN",     Position = vector3(-738.595, -1252.058, 44.734) },
        { Id = "COLTER",      Name = "STATION_COLTER",      Description = "NFT_COLTER_DESC",      Type = "REG_AMBARINO",       Position = vector3(-1294.828, 2416.529, 305.952) },
        { Id = "EMERALD",     Name = "STATION_EMERALD",     Description = "NFT_EMERALD_DESC",     Type = "REG_NEW_HANOVER",    Position = vector3(1519.545, 431.535, 90.681) },
        { Id = "LAGRAS",      Name = "STATION_LAGRAS",      Description = "NFT_LAGRAS_DESC",      Type = "REG_LEMOYNE",        Position = vector3(2108.463, -584.866, 41.675) },
        { Id = "MACFARLANES", Name = "STATION_MACFARLANES", Description = "NFT_MACFARLANES_DESC", Type = "REG_NEW_AUSTIN",     Position = vector3(-2490.510, -2438.064, 60.583) },
        { Id = "MANZANITA",   Name = "STATION_MANZANITA",   Description = "NFT_MANZANITA_DESC",   Type = "REG_WEST_ELIZABETH", Position = vector3(-1995.512, -1610.602, 118.119) },
        { Id = "RHODES",      Name = "STATION_RHODES",      Description = "NFT_RHODES_DESC",      Type = "REG_LEMOYNE",        Position = vector3(1269.275, -1297.568, 76.957) },
        { Id = "SAINT_DENIS", Name = "STATION_SAINT_DENIS", Description = "NFT_SAINT_DENIS_DESC", Type = "REG_LEMOYNE",        Position = vector3(2695.005, -1446.752, 46.266) },
        { Id = "STRAWBERRY",  Name = "STATION_STRAWBERRY",  Description = "NFT_STRAWBERRY_DESC",  Type = "REG_WEST_ELIZABETH", Position = vector3(-1783.893, -430.469, 156.470) },
        { Id = "TUMBLEWEED",  Name = "STATION_TUMBLEWEED",  Description = "NFT_TUMBLEWEED_DESC",  Type = "REG_NEW_AUSTIN",     Position = vector3(-5425.016, -2919.998, 0.940) },
        { Id = "VALENTINE",   Name = "STATION_VALENTINE",   Description = "NFT_VALENTINE_DESC",   Type = "REG_NEW_HANOVER",    Position = vector3(-175.067, 640.543, 114.133) },
        { Id = "VAN_HORN",    Name = "STATION_VAN_HORN",    Description = "NFT_VAN_HORN_DESC",    Type = "REG_NEW_HANOVER",    Position = vector3(2892.003, 619.931, 57.734) },
        { Id = "WAPITI",      Name = "STATION_WAPITI",      Description = "NFT_WAPITI_DESC",      Type = "REG_AMBARINO",       Position = vector3(486.875, 2209.392, 246.876) },
    }

    local items = {}
    for _, place in ipairs(places) do
        if not filter or place.Type == filter then
            local distance = #(playerPos - place.Position)
            local name = GetStringFromHashKey(place.Name)
            local description = GetStringFromHashKey(place.Description)

            table.insert(items, {
                _DISTANCE = distance,
                Id = "FAST_TRAVEL_" .. place.Id,
                Type = "TEXT",
                Label = name,
                Footer = string.format("%s is %.1f meters away", name, distance),
                Prompts = {
                    Select = { Visible = true, Label = "Travel" }
                },
                Data = {
                    RightText = string.format("%.1fm", distance),
                    ItemDescription = description,
                },
            })
        end
    end

    table.sort(items, function(a, b)
        return a._DISTANCE < b._DISTANCE
    end)

    return items
end

local actionCooldownSeconds = -1

local function getActionCooldownFooter(secondsLeft)
    local minutes = math.floor((secondsLeft % 3600) / 60)
    local seconds = secondsLeft % 60

    return string.format("~e~You can use this again in %02d:%02d", minutes, seconds)
end

AddEventHandler("native_shop:item_selected", function(event)
    if event.ID == "DEMO_COOLDOWN" then
        actionCooldownSeconds = 5

        local footer = getActionCooldownFooter(actionCooldownSeconds)
        TriggerEvent("shop:disable_item", "DEMO_COOLDOWN")
        TriggerEvent("shop:set_item_footer", "DEMO_COOLDOWN", footer)

        PostFeedTicker(string.format("Cooling down action for %d seconds", actionCooldownSeconds))
    elseif tostring(event.ID):find("FAST_TRAVEL_") then
        PostFeedTicker(string.format("Selected: '%s'", event.ID))
    end
end)

AddEventHandler("native_shop:item_action", function(event)
    if event.ID == "PROMPTS_ACTION" or event.ID == "HELD_PROMPTS_ACTION" then
        if event.ActionParameter then
            PostFeedTicker(string.format("Action: '%s' with parameter '%s'", event.Action, event.ActionParameter))
        else
            PostFeedTicker(string.format("Action: '%s'", event.Action))
        end
    end
end)

ShopNavigator:register(
    data,
    { DynamicFilterMenu = getDynamicFilterMenu },
    {}
)

Citizen.CreateThread(function()
    while true do
        -- For performance reasons, only trigger events when the roleplay text menu is open
        if ShopNavigator:getRootMenuId() == "TEST_MENU" then
            -- Update dynamic filter menu
            TriggerEvent("shop:refresh_menu", "DEMO_FAST_TRAVEL")

            -- Update cooldown action
            if actionCooldownSeconds == 0 then
                actionCooldownSeconds = -1

                TriggerEvent("shop:enable_item", "DEMO_COOLDOWN")
                TriggerEvent("shop:clear_item_footer", "DEMO_COOLDOWN")
            elseif actionCooldownSeconds > 0 then
                actionCooldownSeconds = actionCooldownSeconds - 1

                local footer = getActionCooldownFooter(actionCooldownSeconds)

                TriggerEvent("shop:disable_item", "DEMO_COOLDOWN")
                TriggerEvent("shop:set_item_footer", "DEMO_COOLDOWN", footer)
            end
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(0, "INPUT_PHOTO_MODE") and IsUiappRunning("shop_menu") ~= 1 then
            local prompt = 0

            -- Create prompt
            if prompt == 0 then
                prompt = UiPromptRegisterBegin()
                UiPromptSetControlAction(prompt, GetHashKey("INPUT_PHOTO_MODE"))
                UiPromptSetText(prompt, VarString(10, "LITERAL_STRING", "Test Menu"))
                UiPromptSetHoldMode(prompt, 250)
                UiPromptSetAttribute(prompt, 2, true)
                UiPromptSetAttribute(prompt, 4, true)
                UiPromptSetAttribute(prompt, 9, true)
                UiPromptSetAttribute(prompt, 10, true) -- kPromptAttrib_NoButtonReleaseCheck. Immediately becomes pressed
                UiPromptSetAttribute(prompt, 17, true) -- kPromptAttrib_NoGroupCheck. Allows to appear in any active group
                UiPromptRegisterEnd(prompt)

                Citizen.CreateThread(function()
                    Citizen.Wait(100)

                    while UiPromptGetProgress(prompt) ~= 0.0 and UiPromptGetProgress(prompt) ~= 1.0 do
                        Citizen.Wait(0)
                    end

                    if UiPromptGetProgress(prompt) == 1.0 then
                        TriggerEvent("shop:open", "TEST_MENU")
                    end

                    UiPromptDelete(prompt)
                    prompt = 0
                end)
            end
        end
    end
end)
