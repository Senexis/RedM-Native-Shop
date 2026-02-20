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
            Label = "Bounty management",
            Items = getTestMenusItems("BOUNTY_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in postal offices to let you pay off bounties.",
            }
        },
        {
            Id = "CLOTHING_MODIFY_MENU",
            Scene = "CLOTHING_MODIFY",
            Label = "Clothing modify",
            Items = getTestMenusItems("CLOTHING_MODIFY"),
            Data = {
                ItemDescription = "Used in tailors to let you modify outfits.",
            }
        },
        {
            Id = "HORSE_MANAGEMENT_MENU",
            Scene = "HORSE_MANAGEMENT",
            Label = "Horse management",
            Items = getTestMenusItems("HORSE_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in stables to let you manage your stabled horses.",
            }
        },
        {
            Id = "ITEM_GRID_MENU",
            Scene = "ITEM_GRID",
            Label = "Item grid",
            Items = getTestMenusItems("ITEM_GRID", true),
            Data = {
                ItemDescription = "Used in tailors to let you select colors for clothing items.",
            }
        },
        {
            Id = "ITEM_LIST_MENU",
            Scene = "ITEM_LIST",
            Label = "Item list",
            Items = getTestMenusItems("ITEM_LIST"),
            Data = {
                ItemDescription = "Used in the game to display a list of items with support for buy, saddle stats, and more.",
            }
        },
        {
            Id = "ITEM_LIST_COLOUR_PALETTE_MENU",
            Scene = "ITEM_LIST_COLOUR_PALETTE",
            Label = "Item list color palette",
            Items = getTestMenusItems("ITEM_LIST_COLOUR_PALETTE"),
            Data = {
                ItemDescription = "Used in the game to display a list of items with optional color palettes.",
            }
        },
        {
            Id = "ITEM_LIST_DESCRIPTION_MENU",
            Scene = "ITEM_LIST_DESCRIPTION",
            Label = "Item list description",
            Items = getTestMenusItems("ITEM_LIST_DESCRIPTION"),
            Data = {
                ItemDescription = "Similar to item list but with support for different descriptions.",
            }
        },
        {
            Id = "ITEM_LIST_HORSE_STATS_MENU",
            Scene = "ITEM_LIST_HORSE_STATS",
            Label = "Item list horse stats",
            Items = getTestMenusItems("ITEM_LIST_HORSE_STATS"),
            Data = {
                ItemDescription = "Used in stables to display a list of horses with their stats.",
            }
        },
        {
            Id = "ITEM_LIST_RECIPES_MENU",
            Scene = "ITEM_LIST_RECIPES",
            Label = "Item list recipes",
            Items = getTestMenusItems("ITEM_LIST_RECIPES"),
            Data = {
                ItemDescription = "Used at trappers and moonshine businesses to display craftable items with their recipes.",
            }
        },
        {
            Id = "ITEM_LIST_RPG_STATS_MENU",
            Scene = "ITEM_LIST_RPG_STATS",
            Label = "Item list rpg stats",
            Items = getTestMenusItems("ITEM_LIST_RPG_STATS"),
            Data = {
                ItemDescription = "Used in the game to display a list of items with RPG effects.",
            }
        },
        {
            Id = "ITEM_LIST_SLIDER_MENU",
            Scene = "ITEM_LIST_SLIDER",
            Label = "Item list slider",
            Items = getTestMenusItems("ITEM_LIST_SLIDER"),
            Data = {
                ItemDescription = "Used at barbers to display a list of hairstyles with a hair length slider.",
            }
        },
        {
            Id = "ITEM_LIST_TEXTURE_DESCRIPTION_MENU",
            Scene = "ITEM_LIST_TEXTURE_DESCRIPTION",
            Label = "Item list texture description",
            Items = getTestMenusItems("ITEM_LIST_TEXTURE_DESCRIPTION"),
            Data = {
                ItemDescription = "Used in the game to display a list of items with a texture as well as a description.",
            }
        },
        {
            Id = "ITEM_LIST_VEHICLE_STATS_MENU",
            Scene = "ITEM_LIST_VEHICLE_STATS",
            Label = "Item list vehicle stats",
            Items = getTestMenusItems("ITEM_LIST_VEHICLE_STATS"),
            Data = {
                ItemDescription = "Used in stables to display a list of vehicles with their stats.",
            }
        },
        {
            Id = "ITEM_LIST_WEAPON_STATS_MENU",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Label = "Item list weapon stats",
            Items = getTestMenusItems("ITEM_LIST_WEAPON_STATS"),
            Data = {
                ItemDescription = "Used in gunsmiths to display a list of weapons with their stats.",
            }
        },
        {
            Id = "ITEM_SELL_LIST_HORSE_STATS_MENU",
            Scene = "ITEM_SELL_LIST_HORSE_STATS",
            Label = "Item sell list horse stats",
            Items = getTestMenusItems("ITEM_SELL_LIST_HORSE_STATS"),
            Data = {
                ItemDescription = "Used in stables to display a list of horses to sell with their stats.",
            }
        },
        {
            Id = "MENU_LIST_MENU",
            Scene = "MENU_LIST",
            Label = "Menu list",
            Items = getTestMenusItems("MENU_LIST"),
            Data = {
                ItemDescription = "A generic menu list with business support used in various shops throughout the game.",
            }
        },
        {
            Id = "MENU_LIST_HORSE_STATS_MENU",
            Scene = "MENU_LIST_HORSE_STATS",
            Label = "Menu list horse stats",
            Items = getTestMenusItems("MENU_LIST_HORSE_STATS"),
            Data = {
                ItemDescription = "Menu list specialized for displaying horse stats.",
            }
        },
        {
            Id = "MENU_LIST_WEAPON_STATS_MENU",
            Scene = "MENU_LIST_WEAPON_STATS",
            Label = "Menu list weapon stats",
            Items = getTestMenusItems("MENU_LIST_WEAPON_STATS"),
            Data = {
                ItemDescription = "Menu list specialized for displaying weapon stats.",
            }
        },
        {
            Id = "MENU_STYLE_SELECTOR_MENU",
            Scene = "MENU_STYLE_SELECTOR",
            Label = "Menu style selector",
            Items = getTestMenusItems("MENU_STYLE_SELECTOR"),
            Data = {
                ItemDescription = "Used in tailors to let you select styles for clothing items.",
            }
        },
        {
            Id = "SADDLE_MANAGEMENT_MENU",
            Scene = "SADDLE_MANAGEMENT",
            Label = "Saddle management",
            Items = getTestMenusItems("SADDLE_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in stables to let you manage your saddles and horse equipment.",
            }
        },
        {
            Id = "VEHICLE_MANAGEMENT_MENU",
            Scene = "VEHICLE_MANAGEMENT",
            Label = "Vehicle management",
            Items = getTestMenusItems("VEHICLE_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in stables to let you manage your stabled vehicles.",
            }
        },
        {
            Id = "WEAPON_MANAGEMENT_MENU",
            Scene = "WEAPON_MANAGEMENT",
            Label = "Weapon management",
            Items = getTestMenusItems("WEAPON_MANAGEMENT"),
            Data = {
                ItemDescription = "Used in gunsmiths to let you manage your stored weapons.",
            }
        },
        {
            Id = "CLOTHING_STAT_INFO_BOX",
            Scene = "CLOTHING_STAT_INFO_BOX",
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
    Id = "FEATURE_MENU_TYPES",
    Scene = "MENU_LIST",
    Title = "FEATURES",
    Subtitle = "Menu Types",
    Items = getTestMenusMenus()
}

ShopNavigator:register(data)
