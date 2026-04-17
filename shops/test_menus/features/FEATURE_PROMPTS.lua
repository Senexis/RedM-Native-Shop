local MENU_ID <const> = "FEATURE_PROMPTS"

local function promptAction(_, _, type)
    PostFeedTicker(string.format("Another action for the %s prompt", type))
end

local data = {
    Id = MENU_ID,
    Title = "FEATURES",
    Subtitle = "Prompts",
    Scene = "MENU_LIST",
    AllowWalking = true,
    RepositionCamera = true,
    Items = {
        {
            Id = "PROMPTS_BASIC",
            Type = "TEXT",
            Label = "Basic",
            Prompts = {
                Select = "Select",
                Option = "Option",
                Toggle = "Toggle",
                Info = "Info",
                Adjust = "Adjust",
                Modify = "Modify",
            },
            Data = {
                ItemDescription = "Showcases an example of all available prompts.",
            }
        },
        {
            Id = "PROMPTS_HELD",
            Type = "TEXT",
            Label = "Held",
            Prompts = {
                Select = { Label = "Held Select", Held = true },
                Option = { Label = "Held Option", Held = true },
                Toggle = { Label = "Held Toggle", Held = true },
                Info = { Label = "Info (not supported)", Held = false },
                Adjust = { Label = "Adjust (not supported)", Held = false },
                Modify = { Label = "Modify (not supported)", Held = false },
            },
            Data = {
                ItemDescription = "Showcases an example of held mode for all available prompts.",
            }
        },
        {
            Id = "PROMPTS_DISABLED_ITEM",
            Type = "TEXT",
            Label = "Disabled (Item)",
            Disabled = true,
            Prompts = {
                Select = "Disabled Select",
                Option = "Disabled Option",
                Toggle = "Disabled Toggle",
                Info = "Disabled Info",
                Adjust = "Disabled Adjust",
                Modify = "Disabled Modify",
            },
            Data = {
                ItemDescription = "Showcases an example of all available prompts when the item is disabled.",
            }
        },
        {
            Id = "PROMPTS_DISABLED_PROMPT",
            Type = "TEXT",
            Label = "Disabled (Prompts)",
            Prompts = {
                Select = { Label = "Disabled Select", Disabled = true },
                Option = { Label = "Disabled Option", Disabled = true },
                Toggle = { Label = "Disabled Toggle", Disabled = true },
                Info = { Label = "Disabled Info", Disabled = true },
                Adjust = { Label = "Disabled Adjust", Disabled = true },
                Modify = { Label = "Disabled Modify", Disabled = true },
            },
            Data = {
                ItemDescription = "Showcases an example of all available prompts when the prompts are disabled.",
            }
        },
        {
            Id = "PROMPTS_ACTION",
            Type = "TEXT",
            Label = "Actions",
            Prompts = {
                Select = { Action = promptAction },
                Option = { Action = promptAction },
                Toggle = { Action = promptAction },
                Info = { Action = promptAction },
                Adjust = { Action = promptAction },
                Modify = { Action = promptAction },
            },
            Data = {
                ItemDescription = "Showcases an example of actions for all available prompts.",
            }
        }
    }
}

ShopApi.Register(data)

AddEventHandler("native_shop:item_action", function(event)
    if ShopNavigator:getCurrentMenuId() ~= MENU_ID then
        return
    end

    if event.ID:sub(1, 8) ~= "PROMPTS_" then
        return
    end

    if not event.ActionParameter then
        PostFeedTicker(string.format("Prompt %s pressed", event.Action))
    else
        PostFeedTicker(string.format("Prompt %s pressed with parameter '%s'", event.Action, event.ActionParameter))
    end
end)
