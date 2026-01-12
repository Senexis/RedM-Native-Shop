local function getItems(id)
    return {
        {
            Id = id .. "_SET_ITEM_DESCRIPTION",
            Label = "Item description",
            Data = {
                ItemDescription = "This is a test item description for SetItemDescription.",
            }
        },
        {
            Id = id .. "_SET_ITEM_INFO1",
            Label = "Item info 1",
            Data = {
                ItemInfo1 = {
                    Visible = true,
                    Text = "Item Info 1 Text",
                    Centered = true,
                    IconVisible = true,
                    IconTextureDictionary = "MENU_TEXTURES",
                    IconTexture = "MENU_ICON_TICK",
                    IconColor = joaat("COLOR_GOLD"),
                }
            }
        },
        {
            Id = id .. "_SET_ITEM_WEATHER",
            Label = "Item weather",
            Data = {
                Weather = {
                    Visible = true,
                    Enabled = true,
                    Opacity = 1,
                    Warmth = 4
                }
            }
        },
        {
            Id = id .. "_SET_OUTFIT_WEATHER",
            Label = "Outfit weather",
            Data = {
                OutfitWeather = {
                    Visible = true,
                    Enabled = true,
                    Opacity = 1,
                    Effectiveness = 2
                }
            }
        },
        {
            Id = id .. "_SET_ITEM_INFO2",
            Label = "Item info 2",
            Data = {
                ItemInfo2 = {
                    Visible = true,
                    Text = "Item Info 2 Text",
                    Centered = false,
                    IconVisible = true,
                    IconTextureDictionary = "MENU_TEXTURES",
                    IconTexture = "MENU_ICON_TICK",
                }
            }
        },
        {
            Id = id .. "_SET_PRICE_DETAILS",
            Label = "Price details",
            Data = {
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
            Id = id .. "_SET_HORSE_STATS",
            Label = "Horse stats",
            Data = {
                HorseStats = {
                    Primary = true,
                    Meters = {
                        Bonding = 1,
                        Stamina = 7,
                        StaminaCore = 6,
                        Health = 8,
                        HealthCore = 4,
                    },
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
            }
        },
        {
            Id = id .. "_SET_VEHICLE_STATS",
            Label = "Vehicle stats",
            Data = {
                VehicleStats = {
                    Primary = true,
                    MaxSpeed = "Test MaxSpeed",
                    Acceleration = "Test Acceleration",
                    Steering = "Test Steering",
                    Description = "Test Description",
                }
            }
        },
        {
            Id = id .. "_SET_WEAPON_STATS",
            Label = "Weapon stats",
            Data = {
                WeaponStats = {
                    Power = { Value = 50, Diff = 75, New = 25 },
                    Range = { Value = 50, Diff = 75, New = 25 },
                    Accuracy = { Value = 50, Diff = 75, New = 25 },
                    FireRate = { Value = 50, Diff = 75, New = 25 },
                    Reload = { Value = 50, Diff = 75, New = 25 },
                }
            }
        },
        {
            Id = id .. "_SET_RPG_EFFECTS",
            Label = "RPG effects",
            Data = {
                RpgEffects = {
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
            }
        },
        {
            Id = id .. "_SET_SLIDER_INFO",
            Label = "Slider info",
            Data = {
                SliderInfo = {
                    Visible = true,
                    Enabled = true,
                    Value = 1,
                    MaxValue = 6,
                    TotalTanks = 10,
                    ActiveTanks = 5,
                }
            }
        },
        {
            Id = id .. "_SET_BUSINESS_INFO",
            Label = "Business info",
            Data = {
                BusinessInfo = {
                    Visible = true,
                    Description = "This is a test business description.",
                    Moonshine = {
                        MaterialsTextureDictionary = "MENU_TEXTURES",
                        MaterialsTexture = "MENU_ICON_TICK",
                        ProductionTextureDictionary = "MENU_TEXTURES",
                        ProductionTexture = "MENU_ICON_TICK",
                        GoodsTextureDictionary = "MENU_TEXTURES",
                        GoodsTexture = "MENU_ICON_TICK",
                    },
                    Trader = {
                        Delivery = false,
                        TotalGoods = "Test TotalGoods",
                        WagonSize = "Test WagonSize",
                        WagonCapacity = "Test WagonCapacity",
                        DeliveryAmount = "Test DeliveryAmount",
                    },
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
            Id = id .. "_SET_RECIPE_FOOTER",
            Label = "Recipe footer",
            Data = {
                RecipeFooter = {
                    Visible = true,
                    TitleType = 0,
                    Items = {
                        { Enabled = true,  Name = "Test Item 1", Count = 1, TextureDictionary = "MENU_TEXTURES", Texture = "MENU_ICON_TICK" },
                        { Enabled = true,  Name = "Test Item 2", Count = 2, TextureDictionary = "MENU_TEXTURES", Texture = "MENU_ICON_TICK" },
                        { Enabled = false, Name = "Test Item 3", Count = 3, TextureDictionary = "MENU_TEXTURES", Texture = "MENU_ICON_TICK" },
                    }
                }
            }
        },
        {
            Id = id .. "_SET_SADDLE_STATS",
            Label = "Saddle stats",
            Data = {
                SaddleStats = {
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
            }
        },
        {
            Id = id .. "_SET_STIRRUP_STATS",
            Label = "Stirrup stats",
            Data = {
                StirrupStats = {
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
            }
        }
    }
end

local function getMenu()
    return {
        {
            Id = "BOUNTY_MANAGEMENT_MENU",
            Scene = "BOUNTY_MANAGEMENT",
            Label = "Bounty management",
            Items = getItems("BOUNTY_MANAGEMENT"),
        },
        {
            Id = "CLOTHING_MODIFY_MENU",
            Scene = "CLOTHING_MODIFY",
            Label = "Clothing modify",
            Items = getItems("CLOTHING_MODIFY"),
        },
        {
            Id = "HORSE_MANAGEMENT_MENU",
            Scene = "HORSE_MANAGEMENT",
            Label = "Horse management",
            Items = getItems("HORSE_MANAGEMENT"),
        },
        {
            Id = "ITEM_GRID_MENU",
            Scene = "ITEM_GRID",
            Label = "Item grid",
            Items = getItems("ITEM_GRID"),
        },
        {
            Id = "ITEM_LIST_MENU",
            Scene = "ITEM_LIST",
            Label = "Item list",
            Items = getItems("ITEM_LIST"),
        },
        {
            Id = "ITEM_LIST_COLOUR_PALETTE_MENU",
            Scene = "ITEM_LIST_COLOUR_PALETTE",
            Label = "Item list colour palette",
            Items = getItems("ITEM_LIST_COLOUR_PALETTE"),
        },
        {
            Id = "ITEM_LIST_COLOUR_PALETTE_COMBO_MENU",
            Scene = "ITEM_LIST_COLOUR_PALETTE_COMBO",
            Label = "Item list colour palette combo",
            Items = getItems("ITEM_LIST_COLOUR_PALETTE_COMBO"),
        },
        {
            Id = "ITEM_LIST_DESCRIPTION_MENU",
            Scene = "ITEM_LIST_DESCRIPTION",
            Label = "Item list description",
            Items = getItems("ITEM_LIST_DESCRIPTION"),
        },
        {
            Id = "ITEM_LIST_HORSE_STATS_MENU",
            Scene = "ITEM_LIST_HORSE_STATS",
            Label = "Item list horse stats",
            Items = getItems("ITEM_LIST_HORSE_STATS"),
        },
        {
            Id = "ITEM_LIST_RECIPES_MENU",
            Scene = "ITEM_LIST_RECIPES",
            Label = "Item list recipes",
            Items = getItems("ITEM_LIST_RECIPES"),
        },
        {
            Id = "ITEM_LIST_RPG_STATS_MENU",
            Scene = "ITEM_LIST_RPG_STATS",
            Label = "Item list rpg stats",
            Items = getItems("ITEM_LIST_RPG_STATS"),
        },
        {
            Id = "ITEM_LIST_SLIDER_MENU",
            Scene = "ITEM_LIST_SLIDER",
            Label = "Item list slider",
            Items = getItems("ITEM_LIST_SLIDER"),
        },
        {
            Id = "ITEM_LIST_TEXTURE_DESCRIPTION_MENU",
            Scene = "ITEM_LIST_TEXTURE_DESCRIPTION",
            Label = "Item list texture description",
            Items = getItems("ITEM_LIST_TEXTURE_DESCRIPTION"),
        },
        {
            Id = "ITEM_LIST_VEHICLE_STATS_MENU",
            Scene = "ITEM_LIST_VEHICLE_STATS",
            Label = "Item list vehicle stats",
            Items = getItems("ITEM_LIST_VEHICLE_STATS"),
        },
        {
            Id = "ITEM_LIST_WEAPON_STATS_MENU",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Label = "Item list weapon stats",
            Items = getItems("ITEM_LIST_WEAPON_STATS"),
        },
        {
            Id = "ITEM_SELL_LIST_HORSE_STATS_MENU",
            Scene = "ITEM_SELL_LIST_HORSE_STATS",
            Label = "Item sell list horse stats",
            Items = getItems("ITEM_SELL_LIST_HORSE_STATS"),
        },
        {
            Id = "MENU_LIST_MENU",
            Scene = "MENU_LIST",
            Label = "Menu list",
            Items = getItems("MENU_LIST"),
        },
        {
            Id = "MENU_LIST_HORSE_STATS_MENU",
            Scene = "MENU_LIST_HORSE_STATS",
            Label = "Menu list horse stats",
            Items = getItems("MENU_LIST_HORSE_STATS"),
        },
        {
            Id = "MENU_LIST_WEAPON_STATS_MENU",
            Scene = "MENU_LIST_WEAPON_STATS",
            Label = "Menu list weapon stats",
            Items = getItems("MENU_LIST_WEAPON_STATS"),
        },
        {
            Id = "MENU_STYLE_SELECTOR_MENU",
            Scene = "MENU_STYLE_SELECTOR",
            Label = "Menu style selector",
            Items = getItems("MENU_STYLE_SELECTOR"),
        },
        {
            Id = "SADDLE_MANAGEMENT_MENU",
            Scene = "SADDLE_MANAGEMENT",
            Label = "Saddle management",
            Items = getItems("SADDLE_MANAGEMENT"),
        },
        {
            Id = "VEHICLE_MANAGEMENT_MENU",
            Scene = "VEHICLE_MANAGEMENT",
            Label = "Vehicle management",
            Items = getItems("VEHICLE_MANAGEMENT"),
        },
        {
            Id = "WEAPON_MANAGEMENT_MENU",
            Scene = "WEAPON_MANAGEMENT",
            Label = "Weapon management",
            Items = getItems("WEAPON_MANAGEMENT"),
        },
        {
            Id = "CLOTHING_STAT_INFO_BOX",
            Scene = "CLOTHING_STAT_INFO_BOX",
            Label = "Clothing stats infobox",
            Items = {
                { Id = "CLOTHING_STAT_INFO_BOX_ITEM" }
            },
            Data = {
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
                InfoBoxName = "Horse stats infobox",
                HorseInfoBox = {
                    Visible = true,
                    Stats = false,
                    Text = "Horse stats infobox item",
                    Description = "This is a test description for the horse stats info box.",
                    TipText = "Horse stats infobox tip"
                },
                HorseStats = {
                    Primary = false,
                    Meters = {
                        Bonding = 1,
                        Stamina = 7,
                        StaminaCore = 6,
                        Health = 8,
                        HealthCore = 4,
                    },
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
    Title = "TEST MENU",
    Subtitle = "Customize",
    Scene = "MENU_LIST",
    AllowWalking = true,
    RepositionCamera = true,
    Items = getMenu(),
}

ShopNavigator:register(
    data,
    {},
    {}
)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(0, "INPUT_PHOTO_MODE") and IsUiappRunningByHash(joaat("shop_menu")) ~= 1 then
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
