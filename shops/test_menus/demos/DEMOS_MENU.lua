local MENU_ID <const> = "DEMOS_MENU"
local COOLDOWN_ID <const> = "DEMO_COOLDOWN"
local COOLDOWN_SECONDS <const> = 5

local actionCooldownSeconds = -1
local function getActionCooldownFooter(secondsLeft)
    local minutes = math.floor((secondsLeft % 3600) / 60)
    local seconds = secondsLeft % 60

    return string.format("~e~You can use this again in %02d:%02d", minutes, seconds)
end

local data = {
    Id = MENU_ID,
    Title = "DEMOS",
    Subtitle = "Index",
    Scene = "MENU_LIST",
    AllowWalking = true,
    RepositionCamera = true,
    Items = {
        {
            Id = COOLDOWN_ID,
            Type = "TEXT",
            Label = "Cooldown",
            Prompts = {
                Select = "Select"
            },
            Data = {
                ItemDescription = "Showcases an example of disabling an item with a cooldown timer displayed in the footer.",
            },
            Action = function()
                actionCooldownSeconds = COOLDOWN_SECONDS

                TriggerEvent("native_shop:disable_item", COOLDOWN_ID)
                TriggerEvent("native_shop:set_item_footer", COOLDOWN_ID, getActionCooldownFooter(actionCooldownSeconds))

                PostFeedTicker(string.format("Cooling down action for %d seconds", actionCooldownSeconds))

                CreateThread(function()
                    while actionCooldownSeconds > 0 do
                        Wait(1000)

                        actionCooldownSeconds = actionCooldownSeconds - 1

                        if actionCooldownSeconds > 0 then
                            TriggerEvent("native_shop:set_item_footer", COOLDOWN_ID, getActionCooldownFooter(actionCooldownSeconds))
                        else
                            TriggerEvent("native_shop:enable_item", COOLDOWN_ID)
                            TriggerEvent("native_shop:clear_item_footer", COOLDOWN_ID)
                        end

                        TriggerEvent("native_shop:refresh_menu", MENU_ID)
                    end
                end)
            end
        },
        {
            Id = "DEMO_SHOPS",
            Label = "Shops",
            Data = {
                ItemDescription = "A demo shop menu showcasing item categories, submenus, and a purchase flow.",
            },
            Items = {
                {
                    Id = "DEMO_BASIC_SHOP",
                    Label = "Basic Shop",
                    LinkMenuId = "DEMO_BASIC_SHOP",
                    LinkPageId = nil,
                    Data = {
                        ItemDescription = "A basic shop menu showcasing quantity selection, pricing, and stock management.",
                    }
                },
                {
                    Id = "DEMO_GUNSMITH",
                    Label = "Gunsmith",
                    LinkMenuId = "DEMO_GUNSMITH",
                    LinkPageId = nil,
                    Data = {
                        ItemDescription = "A gunsmith menu showcasing an example gunsmith setup.",
                    }
                },
                {
                    Id = "DEMO_CLOTHING",
                    Type = "STEPPER",
                    Label = "Wardrobe",
                    LinkMenuId = "DEMO_CLOTHING",
                    LinkPageId = nil,
                    LinkData = function(_, value)
                        return { Gender = value or 1 }
                    end,
                    Data = {
                        ItemDescription = "A demo clothing menu showcasing dynamic generation of items based on the selected gender.",
                        StepperOptions = { "Male", "Female" },
                        StepperValue = 1,
                        StepperVisible = true,
                        StepperTextureVisible = false,
                    }
                },
                {
                    Id = "DEMO_STABLES",
                    Label = "Stables",
                    LinkMenuId = "DEMO_STABLES",
                    LinkPageId = nil,
                    Data = {
                        ItemDescription = "A demo stables menu showcasing an example stables setup.",
                    }
                },
                {
                    Id = "DEMO_MOONSHINE",
                    Label = "Moonshine",
                    LinkMenuId = "DEMO_MOONSHINE",
                    LinkPageId = nil,
                    Data = {
                        ItemDescription = "A demo moonshine business menu aiming to recreate the moonshine production menus.",
                    }
                }
            }
        },
        {
            Id = "DEMO_FAST_TRAVEL",
            Label = "Fast Travel",
            LinkMenuId = "DEMO_FAST_TRAVEL",
            LinkPageId = nil,
            Data = {
                ItemDescription = "A demo fast travel menu showcasing dynamic items and filtering. Move to see the distances update in real time.",
            }
        },
        {
            Id = "DEMO_PLAYERS",
            Label = "Players",
            LinkMenuId = "DEMO_PLAYERS",
            LinkPageId = nil,
            Data = {
                ItemDescription = "A demo player list menu showcasing dynamic items based on nearby players, with a dynamic context menu for player interactions.",
            }
        },
        {
            Id = "DEMO_MANUAL_BACK",
            Type = "TEXT",
            Label = "Manual Back",
            Prompts = {
                Back = { Visible = false }
            },
            Data = {
                ItemDescription = "Showcases an example of manually managing the back prompt. In this case, the back prompt is hidden and a specific menu item is used to go back.",
            },
            Items = {
                {
                    Id = "ACTION_BACK",
                    Type = "TEXT",
                    Label = "Go Back",
                    Action = "BACK",
                    Data = {
                        ItemDescription = "This is the only way to go back.",
                    }
                },
            }
        },
        {
            Id = "DEMO_LONG_MENU",
            Scene = "MENU_LIST",
            Label = "Long Menu",
            Footer = "~e~Caution: This may cause a slight stutter to occur",
            LinkMenuId = "DEMO_LONG_MENU",
            LinkPageId = nil,
            Data = {
                ItemDescription = "Showcases a menu with a large number of items to test scrolling behavior.",
            }
        }
    },
}

ShopNavigator:register(data)
