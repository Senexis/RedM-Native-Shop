local function getTestMenuItems(id, shouldUseSwatch)
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

local function getTestMenus()
    return {
        {
            Id = "BOUNTY_MANAGEMENT_MENU",
            Scene = "BOUNTY_MANAGEMENT",
            Title = "TEST MENUS",
            Label = "Bounty management",
            Items = getTestMenuItems("BOUNTY_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in postal offices to let you pay off bounties.",
            }
        },
        {
            Id = "CLOTHING_MODIFY_MENU",
            Scene = "CLOTHING_MODIFY",
            Title = "TEST MENUS",
            Label = "Clothing modify",
            Items = getTestMenuItems("CLOTHING_MODIFY"),
            Data = {
                ItemDescription = "Used in tailors to let you modify outfits.",
            }
        },
        {
            Id = "HORSE_MANAGEMENT_MENU",
            Scene = "HORSE_MANAGEMENT",
            Title = "TEST MENUS",
            Label = "Horse management",
            Items = getTestMenuItems("HORSE_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in stables to let you manage your stabled horses.",
            }
        },
        {
            Id = "ITEM_GRID_MENU",
            Scene = "ITEM_GRID",
            Title = "TEST MENUS",
            Label = "Item grid",
            Items = getTestMenuItems("ITEM_GRID", true),
            Data = {
                ItemDescription = "Used in tailors to let you select colors for clothing items.",
            }
        },
        {
            Id = "ITEM_LIST_MENU",
            Scene = "ITEM_LIST",
            Title = "TEST MENUS",
            Label = "Item list",
            Items = getTestMenuItems("ITEM_LIST"),
            Data = {
                ItemDescription = "Used in the game to display a list of items with support for buy, saddle stats, and more.",
            }
        },
        {
            Id = "ITEM_LIST_COLOUR_PALETTE_MENU",
            Scene = "ITEM_LIST_COLOUR_PALETTE",
            Title = "TEST MENUS",
            Label = "Item list color palette",
            Items = getTestMenuItems("ITEM_LIST_COLOUR_PALETTE"),
            Data = {
                ItemDescription = "Used in the game to display a list of items with optional color palettes.",
            }
        },
        {
            Id = "ITEM_LIST_DESCRIPTION_MENU",
            Scene = "ITEM_LIST_DESCRIPTION",
            Title = "TEST MENUS",
            Label = "Item list description",
            Items = getTestMenuItems("ITEM_LIST_DESCRIPTION"),
            Data = {
                ItemDescription = "Similar to item list but with support for different descriptions.",
            }
        },
        {
            Id = "ITEM_LIST_HORSE_STATS_MENU",
            Scene = "ITEM_LIST_HORSE_STATS",
            Title = "TEST MENUS",
            Label = "Item list horse stats",
            Items = getTestMenuItems("ITEM_LIST_HORSE_STATS"),
            Data = {
                ItemDescription = "Used in stables to display a list of horses with their stats.",
            }
        },
        {
            Id = "ITEM_LIST_RECIPES_MENU",
            Scene = "ITEM_LIST_RECIPES",
            Title = "TEST MENUS",
            Label = "Item list recipes",
            Items = getTestMenuItems("ITEM_LIST_RECIPES"),
            Data = {
                ItemDescription = "Used at trappers and moonshine businesses to display craftable items with their recipes.",
            }
        },
        {
            Id = "ITEM_LIST_RPG_STATS_MENU",
            Scene = "ITEM_LIST_RPG_STATS",
            Title = "TEST MENUS",
            Label = "Item list rpg stats",
            Items = getTestMenuItems("ITEM_LIST_RPG_STATS"),
            Data = {
                ItemDescription = "Used in the game to display a list of items with RPG effects.",
            }
        },
        {
            Id = "ITEM_LIST_SLIDER_MENU",
            Scene = "ITEM_LIST_SLIDER",
            Title = "TEST MENUS",
            Label = "Item list slider",
            Items = getTestMenuItems("ITEM_LIST_SLIDER"),
            Data = {
                ItemDescription = "Used at barbers to display a list of hairstyles with a hair length slider.",
            }
        },
        {
            Id = "ITEM_LIST_TEXTURE_DESCRIPTION_MENU",
            Scene = "ITEM_LIST_TEXTURE_DESCRIPTION",
            Title = "TEST MENUS",
            Label = "Item list texture description",
            Items = getTestMenuItems("ITEM_LIST_TEXTURE_DESCRIPTION"),
            Data = {
                ItemDescription = "Used in the game to display a list of items with a texture as well as a description.",
            }
        },
        {
            Id = "ITEM_LIST_VEHICLE_STATS_MENU",
            Scene = "ITEM_LIST_VEHICLE_STATS",
            Title = "TEST MENUS",
            Label = "Item list vehicle stats",
            Items = getTestMenuItems("ITEM_LIST_VEHICLE_STATS"),
            Data = {
                ItemDescription = "Used in stables to display a list of vehicles with their stats.",
            }
        },
        {
            Id = "ITEM_LIST_WEAPON_STATS_MENU",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Title = "TEST MENUS",
            Label = "Item list weapon stats",
            Items = getTestMenuItems("ITEM_LIST_WEAPON_STATS"),
            Data = {
                ItemDescription = "Used in gunsmiths to display a list of weapons with their stats.",
            }
        },
        {
            Id = "ITEM_SELL_LIST_HORSE_STATS_MENU",
            Scene = "ITEM_SELL_LIST_HORSE_STATS",
            Title = "TEST MENUS",
            Label = "Item sell list horse stats",
            Items = getTestMenuItems("ITEM_SELL_LIST_HORSE_STATS"),
            Data = {
                ItemDescription = "Used in stables to display a list of horses to sell with their stats.",
            }
        },
        {
            Id = "MENU_LIST_MENU",
            Scene = "MENU_LIST",
            Title = "TEST MENUS",
            Label = "Menu list",
            Items = getTestMenuItems("MENU_LIST"),
            Data = {
                ItemDescription = "A generic menu list with business support used in various shops throughout the game.",
            }
        },
        {
            Id = "MENU_LIST_HORSE_STATS_MENU",
            Scene = "MENU_LIST_HORSE_STATS",
            Title = "TEST MENUS",
            Label = "Menu list horse stats",
            Items = getTestMenuItems("MENU_LIST_HORSE_STATS"),
            Data = {
                ItemDescription = "Menu list specialized for displaying horse stats.",
            }
        },
        {
            Id = "MENU_LIST_WEAPON_STATS_MENU",
            Scene = "MENU_LIST_WEAPON_STATS",
            Title = "TEST MENUS",
            Label = "Menu list weapon stats",
            Items = getTestMenuItems("MENU_LIST_WEAPON_STATS"),
            Data = {
                ItemDescription = "Menu list specialized for displaying weapon stats.",
            }
        },
        {
            Id = "MENU_STYLE_SELECTOR_MENU",
            Scene = "MENU_STYLE_SELECTOR",
            Title = "TEST MENUS",
            Label = "Menu style selector",
            Items = getTestMenuItems("MENU_STYLE_SELECTOR"),
            Data = {
                ItemDescription = "Used in tailors to let you select styles for clothing items.",
            }
        },
        {
            Id = "SADDLE_MANAGEMENT_MENU",
            Scene = "SADDLE_MANAGEMENT",
            Title = "TEST MENUS",
            Label = "Saddle management",
            Items = getTestMenuItems("SADDLE_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in stables to let you manage your saddles and horse equipment.",
            }
        },
        {
            Id = "VEHICLE_MANAGEMENT_MENU",
            Scene = "VEHICLE_MANAGEMENT",
            Title = "TEST MENUS",
            Label = "Vehicle management",
            Items = getTestMenuItems("VEHICLE_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in stables to let you manage your stabled vehicles.",
            }
        },
        {
            Id = "WEAPON_MANAGEMENT_MENU",
            Scene = "WEAPON_MANAGEMENT",
            Title = "TEST MENUS",
            Label = "Weapon management",
            Items = getTestMenuItems("WEAPON_MANAGEMENT"),
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

local data = {
    Id = "TEST_MENU",
    Title = "NATIVE SHOP",
    Subtitle = "Crafted by Senexis",
    Scene = "MENU_LIST",
    AllowWalking = true,
    RepositionCamera = true,
    Items = {
        {
            Id = "TEST_MENUS",
            Scene = "MENU_LIST",
            Title = "TEST MENUS",
            Subtitle = "Select a test menu",
            Label = "Test Menus",
            Items = getTestMenus(),
            Data = {
                ItemDescription = "A preview of the different menus. Not all options are supported in every menu. Pricing is included in all items, but can be omitted if desired.",
            }
        },
        {
            Id = "DYNAMIC_FILTER_MENU",
            Scene = "ITEM_LIST_DESCRIPTION",
            Title = "FAST TRAVEL",
            Subtitle = "Overriden by tab",
            Label = "Fast Travel Demo",
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
            Id = "COOLDOWN_ACTION",
            Type = "TEXT",
            Label = "Cooldown Demo",
            Prompts = {
                Select = { Visible = true, Label = "Select" }
            },
            Data = {
                ItemDescription = "Showcases an example of disabling an item with a cooldown timer displayed in the footer.",
                DisabledFooter = "~e~This is the default disabled fallback text"
            }
        },
        {
            Id = "PROMPTS_ACTION",
            Type = "TEXT",
            Label = "Prompts",
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
            }
        },
        {
            Id = "HELD_PROMPTS_ACTION",
            Type = "TEXT",
            Label = "Held Prompts",
            Prompts = {
                Select = { Visible = true, Label = "Held Select", Held = true },
                Option = { Visible = true, Label = "Held Option", Held = true },
                Toggle = { Visible = true, Label = "Held Toggle", Held = true },
                Info = { Visible = true, Label = "Info doesn't support hold", Held = false },
                Adjust = { Visible = true, Label = "Adjust doesn't support hold", Held = false },
                Modify = { Visible = true, Label = "Modify doesn't support hold", Held = false },
            },
            Data = {
                ItemDescription = "Showcases an example of held prompts for all available prompts.",
            }
        },
        {
            Id = "DISABLED_PROMPTS_ACTION",
            Type = "TEXT",
            Label = "Disabled Prompts",
            Disabled = true,
            Footer = "This footer won't be shown",
            Prompts = {
                Select = { Visible = true, Label = "Disabled Select" },
                Option = { Visible = true, Label = "Disabled Option" },
                Toggle = { Visible = true, Label = "Disabled Toggle" },
                Info = { Visible = true, Label = "Disabled Info" },
                Adjust = { Visible = true, Label = "Disabled Adjust" },
                Modify = { Visible = true, Label = "Disabled Modify" },
            },
            Data = {
                ItemDescription = "Showcases what happens when an item is disabled with custom prompts and a footer.",
                DisabledFooter = "~e~Disabled footer overrides default footer",
            }
        }
    },
}

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
                    Select = { Visible = true, Label = "Fast Travel" }
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
    if event.ID == "COOLDOWN_ACTION" then
        actionCooldownSeconds = 5

        local footer = getActionCooldownFooter(actionCooldownSeconds)
        TriggerEvent("shop:disable_item", "COOLDOWN_ACTION")
        TriggerEvent("shop:set_item_footer", "COOLDOWN_ACTION", footer)

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
            TriggerEvent("shop:refresh_menu", "DYNAMIC_FILTER_MENU")

            -- Update cooldown action
            if actionCooldownSeconds == 0 then
                actionCooldownSeconds = -1

                TriggerEvent("shop:enable_item", "COOLDOWN_ACTION")
                TriggerEvent("shop:clear_item_footer", "COOLDOWN_ACTION")
            elseif actionCooldownSeconds > 0 then
                actionCooldownSeconds = actionCooldownSeconds - 1

                local footer = getActionCooldownFooter(actionCooldownSeconds)

                TriggerEvent("shop:disable_item", "COOLDOWN_ACTION")
                TriggerEvent("shop:set_item_footer", "COOLDOWN_ACTION", footer)
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
