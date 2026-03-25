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
            LinkMenuId = "FEATURES_MENU",
            LinkPageId = nil,
            Data = {
                ItemDescription = "A showcase of all the different menu features in one place. Check out the code for details on each feature.",
            }
        },
        {
            Id = "DEMOS_MENU",
            Scene = "MENU_LIST",
            Label = "Demos",
            Footer = "senexis.dev/r/RedM-Native-Shop",
            LinkMenuId = "DEMOS_MENU",
            LinkPageId = nil,
            Data = {
                ItemDescription = "A showcase of various menu features in practice. Have a cool idea for a demo? Report it on the GitHub page!",
            },
        },
        {
            Id = "SUPPORT_MENU",
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

ShopNavigator:register(data)

CreateThread(function()
    while true do
        if IsUiappRunning("shop_menu") == 1 then
            Wait(250)
            goto continue
        end

        if IsControlJustPressed(0, "INPUT_PHOTO_MODE") and IsUiappRunning("shop_menu") ~= 1 then
            local prompt = 0

            -- Create prompt
            if prompt == 0 then
                prompt = UiPromptRegisterBegin()
                UiPromptSetControlAction(prompt, `INPUT_PHOTO_MODE`)
                UiPromptSetText(prompt, VarString(10, "LITERAL_STRING", "Test Menu"))
                UiPromptSetHoldMode(prompt, 250)
                UiPromptSetAttribute(prompt, 2, true)
                UiPromptSetAttribute(prompt, 4, true)
                UiPromptSetAttribute(prompt, 9, true)
                UiPromptSetAttribute(prompt, 10, true) -- kPromptAttrib_NoButtonReleaseCheck. Immediately becomes pressed
                UiPromptSetAttribute(prompt, 17, true) -- kPromptAttrib_NoGroupCheck. Allows to appear in any active group
                UiPromptRegisterEnd(prompt)

                CreateThread(function()
                    Wait(100)

                    while UiPromptGetProgress(prompt) ~= 0.0 and UiPromptGetProgress(prompt) ~= 1.0 do
                        Wait(0)
                    end

                    if UiPromptGetProgress(prompt) == 1.0 then
                        TriggerEvent("native_shop:open", MENU_ID)
                    end

                    UiPromptDelete(prompt)
                    prompt = 0
                end)
            end
        end

        Wait(0)
        ::continue::
    end
end)
