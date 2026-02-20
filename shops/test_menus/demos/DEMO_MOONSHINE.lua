local data = {
    Id = "DEMO_MOONSHINE",
    Scene = "MENU_LIST",
    Title = "Moonshiner Business",
    Subtitle = "Moonshine Production",
    AllowWalking = true,
    RepositionCamera = true,
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
    }
}

-- In your script, you may want to load these elsewhere
-- Perhaps you could move this to a thread that runs during game load
while HasStreamedTxdLoaded("moonshiner_requests") ~= 1 do
    RequestStreamedTxd("moonshiner_requests", false)
    Wait(0)
end

ShopNavigator:register(data)
