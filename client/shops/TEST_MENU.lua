local MENU_ID <const> = "TEST_MENU"

local data = {
    Id = MENU_ID,
    Title = "NATIVE SHOP",
    Subtitle = "Crafted by Senexis",
    Scene = "MENU_LIST",
    AllowWalking = true,
    RepositionCamera = true,
    Items = {
        {
            Id = "FEATURES_MENU",
            Label = "Features",
            LinkMenuId = "DEMO_FEATURES",
            LinkPageId = nil,
            Data = {
                ItemDescription = "A showcase of all the different menu features in one place. Check out the code for details on each feature.",
            }
        },
        {
            Id = "DEMO_MENU",
            Scene = "MENU_LIST",
            Label = "Demos",
            Footer = "senexis.dev/r/RedM-Native-Shop",
            Data = {
                ItemDescription = "A showcase of various menu features in practice. Have a cool idea for a demo? Report it on the GitHub page!",
            },
            Items = {
                {
                    Id = "DEMO_COOLDOWN",
                    Type = "TEXT",
                    Label = "Cooldown",
                    Prompts = {
                        Select = { Visible = true, Label = "Select" }
                    },
                    Data = {
                        ItemDescription = "Showcases an example of disabling an item with a cooldown timer displayed in the footer.",
                    }
                },
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
                    Id = "DEMO_FAST_TRAVEL",
                    Label = "Fast Travel",
                    LinkMenuId = "DEMO_FAST_TRAVEL",
                    LinkPageId = nil,
                    Data = {
                        ItemDescription = "A demo fast travel menu showcasing dynamic items and filtering. Move to see the distances update in real time.",
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
        },
        {
            Id = "SENEXIS_MENU",
            Scene = "MENU_LIST",
            Label = "Support me!",
            Data = {
                ItemDescription = "If you like my work and would like to support me, check out these links! Thank you for your support!"
            },
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
            }
        }
    },
}

local actionCooldownSeconds = -1

local function getActionCooldownFooter(secondsLeft)
    local minutes = math.floor((secondsLeft % 3600) / 60)
    local seconds = secondsLeft % 60

    return string.format("~e~You can use this again in %02d:%02d", minutes, seconds)
end

AddEventHandler("native_shop:item_selected", function(event)
    if ShopNavigator:getRootMenuId() ~= MENU_ID then
        return
    end

    if event.ID == "DEMO_COOLDOWN" then
        actionCooldownSeconds = 5

        local footer = getActionCooldownFooter(actionCooldownSeconds)
        TriggerEvent("shop:disable_item", "DEMO_COOLDOWN")
        TriggerEvent("shop:set_item_footer", "DEMO_COOLDOWN", footer)

        PostFeedTicker(string.format("Cooling down action for %d seconds", actionCooldownSeconds))
    end
end)

AddEventHandler("native_shop:item_action", function(event)
    if ShopNavigator:getRootMenuId() ~= MENU_ID then
        return
    end

    if event.ID == "PROMPTS_ACTION" or event.ID == "HELD_PROMPTS_ACTION" then
        if event.ActionParameter then
            PostFeedTicker(string.format("Action: '%s' with parameter '%s'", event.Action, event.ActionParameter))
        else
            PostFeedTicker(string.format("Action: '%s'", event.Action))
        end
    end
end)

ShopNavigator:register(data)

Citizen.CreateThread(function()
    while true do
        -- For performance reasons, only trigger events when the roleplay text menu is open
        if ShopNavigator:getRootMenuId() == MENU_ID then
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
                        TriggerEvent("shop:open", MENU_ID)
                    end

                    UiPromptDelete(prompt)
                    prompt = 0
                end)
            end
        end
    end
end)
