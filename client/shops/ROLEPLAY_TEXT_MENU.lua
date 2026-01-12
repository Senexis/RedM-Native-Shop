local data = {
    Id = "ROLEPLAY_TEXT_MENU",
    Title = "ROLEPLAY TEXT",
    Subtitle = "Customize",
    Scene = "MENU_LIST",
    AllowWalking = true,
    RepositionCamera = true,
    Items = {
        {
            Id = "WORLD_SCENES_MENU",
            Label = "World Scenes",
            Footer = "Create or manage scenes",
            Prompts = {
                Option = { Visible = true, Label = "Create Scene" },
            },
            Items = {
                {
                    Id = "CREATE_SCENES_MENU",
                    Label = "Create Scene",
                    Footer = "Create a new scene",
                    Items = {
                        { Id = "OPTION_TEXT",     Type = "TEXT",    Label = "Text",     Footer = "Define the text for the scene",                    Data = { RightText = "Not set" } },
                        { Id = "OPTION_LOCATION", Type = "TEXT",    Label = "Location", Footer = "Specify the location for the scene",               Data = { RightText = "Not set" } },
                        { Id = "OPTION_TYPE",     Type = "STEPPER", Label = "Type",     Footer = "Select the type of the scene",                     Data = { StepperVisible = true, StepperValue = 1, StepperOptions = { "General", "Clue" } } },
                        { Id = "OPTION_COLOR",    Type = "STEPPER", Label = "Color",    Footer = "Choose the color for the scene text",              Data = { StepperVisible = true, StepperValue = 1, StepperOptions = { "Red", "Green", "Blue" } } },
                        { Id = "OPTION_SAVE",     Type = "TEXT",    Label = "Create",   Footer = "Create the new scene with the specified settings", Disabled = true },
                    },
                },
                {
                    Id = "CREATED_SCENES_MENU",
                    Label = "My Scenes",
                    Footer = "View and manage your created scenes",
                    Scene = "ITEM_LIST_TEXTURE_DESCRIPTION",
                    Tabs = {
                        { Id = "ALL_SCENES_PAGE",     Label = "All",     Source = { Name = "Scenes", Filter = nil } },
                        { Id = "GENERAL_SCENES_PAGE", Label = "General", Source = { Name = "Scenes", Filter = "TYPE_GENERAL" } },
                        { Id = "CLUE_SCENES_PAGE",    Label = "Clues",   Source = { Name = "Scenes", Filter = "TYPE_CLUE" } },
                    }
                },
            },
        },
        {
            Id = "PLAYER_STATUS_MENU",
            Label = "Player Status",
            Footer = "Set your character status",
            Prompts = {
                Option = { Visible = true, Label = "Set Status" },
            },
            Items = {
                { Id = "SET_STATUS",   Type = "TEXT", Label = "Set Status",   Footer = "Set your current status",   Data = { RightText = "Not set" } },
                { Id = "CLEAR_STATUS", Type = "TEXT", Label = "Clear Status", Footer = "Clear your current status", Disabled = true },
            },
        },
        {
            Id = "PLAYER_INJURY_MENU",
            Label = "Player Injury",
            Footer = "Manage your character injuries",
            Items = {
                { Id = "HEAD_INJURY",      Type = "TEXT", Label = "Head",           Footer = "Manage head injury",      Data = { RightText = "Not set" } },
                { Id = "LEFT_ARM_INJURY",  Type = "TEXT", Label = "Left Arm",       Footer = "Manage left arm injury",  Data = { RightText = "Injured" } },
                { Id = "RIGHT_ARM_INJURY", Type = "TEXT", Label = "Right Arm",      Footer = "Manage right arm injury", Data = { RightText = "Not set" } },
                { Id = "TORSO_INJURY",     Type = "TEXT", Label = "Torso",          Footer = "Manage torso injury",     Data = { RightText = "Not set" } },
                { Id = "LEFT_LEG_INJURY",  Type = "TEXT", Label = "Left Leg",       Footer = "Manage left leg injury",  Data = { RightText = "Not set" } },
                { Id = "RIGHT_LEG_INJURY", Type = "TEXT", Label = "Right Leg",      Footer = "Manage right leg injury", Data = { RightText = "Not set" } },
                { Id = "CLEAR_INJURY",     Type = "TEXT", Label = "Clear Injuries", Footer = "Clear all injuries" },
            },
        },
        {
            Id = "SETTINGS_MENU",
            Label = "Options",
            Footer = "Adjust roleplay text options",
            Scene = "ITEM_LIST_TEXTURE_DESCRIPTION",
            Prompts = {
                Option = { Visible = true, Disabled = true, Label = "Reveal All" },
            },
            Items = {
                {
                    Id = "SCENE_VISIBILITY",
                    Type = "STEPPER",
                    Label = "Scene Visibility",
                    Data = {
                        ItemDescription = "Adjust whether scenes are visible to you in the world.",
                        StepperVisible = true,
                        StepperValue = 1,
                        StepperOptions = { "Visible", "Hidden" }
                    }
                },
                {
                    Id = "STATUS_VISIBILITY",
                    Type = "STEPPER",
                    Label = "Status Visibility",
                    Data = {
                        ItemDescription = "Adjust whether player statuses are visible to you.",
                        StepperVisible = true,
                        StepperValue = 1,
                        StepperOptions = { "Visible", "Hidden" }
                    }
                },
                {
                    Id = "TEXT_SCALE",
                    Type = "STEPPER",
                    Label = "Text Scale",
                    Data = {
                        ItemDescription = "Change the scale of roleplay text displayed in the world.",
                        StepperVisible = true,
                        StepperValue = 3,
                        StepperOptions = { "50%", "75%", "Normal", "125%", "150%" }
                    }
                },
                {
                    Id = "TEXT_COLOR",
                    Type = "STEPPER",
                    Label = "Text Color",
                    Data = {
                        ItemDescription = "Override the color of roleplay text displayed in the world.",
                        StepperVisible = true,
                        StepperValue = 1,
                        StepperOptions = { "Default", "Red", "Green", "Blue" }
                    }
                },
                {
                    Id = "TEMPORARILY_REVEAL",
                    Type = "TEXT",
                    Label = "Reveal All",
                    Prompts = {
                        Select = { Visible = true, Label = "Select" }
                    },
                    Data = {
                        ItemDescription = "Temporarily reveals all scenes and player statuses for 60 seconds.",
                        DisabledFooter = "~e~You cannot use this option right now"
                    }
                },
            },
        },
    },
}

-- Mock database of scenes for demonstration purposes.
local scenes = {
    { Id = "SCENE_1", Text = "A faint smell of gunpowder lingers",   Type = "TYPE_GENERAL", Distance = 150, Color = 1 },
    { Id = "SCENE_2", Text = "A single, muddy bootprint is visible", Type = "TYPE_CLUE",    Distance = 75,  Color = 2 },
    { Id = "SCENE_3", Text = "The air is cold here",                 Type = "TYPE_CLUE",    Distance = 200, Color = 2 },
}

--- (Dynamic Getter) Fetches scenes from the database and returns them as item tables.
---@param filter string|nil "TYPE_GENERAL", "TYPE_CLUE", or nil for all.
---@return table An array of dynamically generated item objects.
local function getSceneItems(filter)
    local items = {}
    for _, scene in ipairs(scenes) do
        if not filter or scene.Type == filter then
            table.insert(items, {
                Id = scene.Id,
                Type = "TEXT",
                Label = string.sub(scene.Text, 1, 21) .. (string.len(scene.Text) > 21 and "..." or ""),
                Context = "ManageScene",
                ContextItem = scene,
                Data = {
                    RightText = scene.Distance .. "m",
                    ItemDescription = scene.Text,
                },
            })
        end
    end
    return items
end

--- (Dynamic Action) Generates the context menu for a single scene.
---@param item table The selected scene item from the page.
---@return table A new dynamic menu context with actions for the scene.
local function createSceneContextMenu(item)
    local typeToInt = {
        TYPE_GENERAL = 1,
        TYPE_CLUE    = 2,
    }

    return {
        Id = "MANAGE_" .. item.Id,
        Label = item.Label,
        Footer = "Select an action to perform on this scene",
        Items = {
            { Id = "CHANGE_OPTION_TEXT_" .. item.Id,     Type = "TEXT",    Label = "Text",         Footer = "Modify the scene's text",        Data = { RightText = "Modify" } },
            { Id = "CHANGE_OPTION_LOCATION_" .. item.Id, Type = "TEXT",    Label = "Location",     Footer = "Modify where the scene appears", Data = { RightText = (item.ContextItem.Distance or 0) .. "m" } },
            { Id = "CHANGE_OPTION_TYPE_" .. item.Id,     Type = "STEPPER", Label = "Type",         Footer = "Modify the scene's type",        Data = { StepperVisible = true, StepperValue = typeToInt[item.ContextItem.Type or 1], StepperOptions = { "General", "Clue" } } },
            { Id = "CHANGE_OPTION_COLOR_" .. item.Id,    Type = "STEPPER", Label = "Color",        Footer = "Modify the scene's text color",  Data = { StepperVisible = true, StepperValue = item.ContextItem.Color or 1, StepperOptions = { "Red", "Green", "Blue" } } },
            { Id = "CHANGE_OPTION_SAVE_" .. item.Id,     Type = "TEXT",    Label = "Save Changes", Footer = "Save changes to this scene" },
            { Id = "CHANGE_OPTION_DELETE_" .. item.Id,   Type = "TEXT",    Label = "Delete Scene", Footer = "Permanently delete this scene" },
        },
    }
end

ShopNavigator:register(
    data,
    { Scenes = getSceneItems },
    { ManageScene = createSceneContextMenu }
)

local function getRevealCooldownFooter(secondsLeft)
    local minutes = math.floor((secondsLeft % 3600) / 60)
    local seconds = secondsLeft % 60

    return string.format("~e~You can use this again in %02d:%02d", minutes, seconds)
end

local revealCooldownSeconds = -1

AddEventHandler("native_shop:item_selected", function(event)
    if event.ID ~= "TEMPORARILY_REVEAL" then return end

    revealCooldownSeconds = 30

    local footer = getRevealCooldownFooter(revealCooldownSeconds)
    TriggerEvent("shop:disable_item", "TEMPORARILY_REVEAL")
    TriggerEvent("shop:set_item_footer", "TEMPORARILY_REVEAL", footer)

    PostFeedTicker("Revealing all scenes and statuses for 60 seconds")
end)

Citizen.CreateThread(function()
    while true do
        -- For performance reasons, only trigger events when the roleplay text menu is open
        if ShopNavigator:getRootMenuId() == "ROLEPLAY_TEXT_MENU" then
            if revealCooldownSeconds == 0 then
                revealCooldownSeconds = -1

                TriggerEvent("shop:enable_item", "TEMPORARILY_REVEAL")
                TriggerEvent("shop:clear_item_footer", "TEMPORARILY_REVEAL")
            elseif revealCooldownSeconds > 0 then
                revealCooldownSeconds = revealCooldownSeconds - 1

                local footer = getRevealCooldownFooter(revealCooldownSeconds)

                TriggerEvent("shop:disable_item", "TEMPORARILY_REVEAL")
                TriggerEvent("shop:set_item_footer", "TEMPORARILY_REVEAL", footer)
            end
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(0, "INPUT_QUICK_USE_ITEM") and IsUiappRunningByHash(joaat("shop_menu")) ~= 1 then
            local prompt = 0

            -- Create prompt
            if prompt == 0 then
                prompt = UiPromptRegisterBegin()
                UiPromptSetControlAction(prompt, GetHashKey("INPUT_QUICK_USE_ITEM"))
                UiPromptSetText(prompt, VarString(10, "LITERAL_STRING", "Roleplay Text"))
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
                        TriggerEvent("shop:open", "ROLEPLAY_TEXT_MENU")
                    end

                    UiPromptDelete(prompt)
                    prompt = 0
                end)
            end
        end
    end
end)