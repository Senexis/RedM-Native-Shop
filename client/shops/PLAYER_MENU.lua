local data = {
    Id = "PLAYER_MENU",
    Title = "PLAYER MENU",
    Subtitle = "Joy of Painting",
    Scene = "MENU_LIST",
    AllowWalking = true,
    RepositionCamera = true,
    Items = {
        {
            Id = "POSSE_MENU",
            Label = "Posse",
            Footer = "Manage your posse",
            Items = {
                {
                    Id = "POSSE_MEMBERS",
                    Label = "Posse Members",
                    Footer = "Manage your posse members",
                    Scene = "ITEM_LIST",
                    Tabs = {
                        { Id = "ALL_MEMBERS_PAGE",     Label = "All",      Source = { Name = "PosseMembers", Filter = nil } },
                        { Id = "OFFICER_MEMBERS_PAGE", Label = "Officers", Source = { Name = "PosseMembers", Filter = "TYPE_OFFICER" } },
                        { Id = "GRUNT_MEMBERS_PAGE",   Label = "Grunts",   Source = { Name = "PosseMembers", Filter = "TYPE_GRUNT" } },
                    },
                },
                {
                    Id = "INVITE_NEARBY",
                    Label = "Invite Nearby",
                    Footer = "Invite nearby players to your posse",
                    Scene = "ITEM_LIST",
                    Tabs = {
                        { Id = "ALL_NEARBY_PAGE", Label = "Invite Nearby", Source = { Name = "NearbyPlayers", Filter = nil } },
                    },
                },
                {
                    Id = "MANAGE_POSSE",
                    Label = "Manage Posse",
                    Footer = "Manage posse settings",
                    Items = {
                        {
                            Id = "POSSE_SETTINGS",
                            Label = "Posse Settings",
                            Footer = "Adjust your posse settings",
                            Scene = "ITEM_LIST",
                            Items = {},
                        },
                        {
                            Id = "POSSE_ROLES",
                            Label = "Posse Roles",
                            Footer = "Manage posse roles",
                            Scene = "ITEM_LIST",
                            Items = {},
                        },
                    },
                },
            },
        },
        {
            Id = "PROGRESSION_MENU",
            Label = "Progression",
            Footer = "View your progression",
            Items = {},
        },
        {
            Id = "CAMP_MENU",
            Label = "Camp & Properties",
            Footer = "Manage your camp and properties",
            Items = {},
        },
        {
            Id = "EMOTES_MENU",
            Label = "Emotes",
            Footer = "Manage or use your emotes",
            Scene = "ITEM_LIST",
            Tabs = {
                { Id = "ALL_EMOTES_PAGE",      Label = "All",       Source = { Name = "Emotes", Filter = nil } },
                { Id = "ACTION_EMOTES_PAGE",   Label = "Actions",   Source = { Name = "Emotes", Filter = "TYPE_ACTION" } },
                { Id = "DANCE_EMOTES_PAGE",    Label = "Dances",    Source = { Name = "Emotes", Filter = "TYPE_DANCE" } },
                { Id = "GREET_EMOTES_PAGE",    Label = "Greetings", Source = { Name = "Emotes", Filter = "TYPE_GREET" } },
                { Id = "REACTION_EMOTES_PAGE", Label = "Reactions", Source = { Name = "Emotes", Filter = "TYPE_REACTION" } },
                { Id = "TAUNT_EMOTES_PAGE",    Label = "Taunts",    Source = { Name = "Emotes", Filter = "TYPE_TAUNT" } },
            },
        },
        {
            Id = "DAILY_CHALLENGES_MENU",
            Label = "Daily Challenges",
            Footer = "Daily challenges reset in 0 hrs 0 mins",
            Items = {
                {
                    Id = "DAILY_CHALLENGE_1",
                    Type = "BUSINESS",
                    Label = "",
                    Footer = "This challenge is not yet completed",
                    Data = {
                        Description = "2/5 Chain Pickerel caught",
                        Progress = 2 / 5,
                        TextureDictionary = "satchel_textures",
                        Texture = "satchel_nav_fish_sack",
                    }
                },
                {
                    Id = "DAILY_CHALLENGE_2",
                    Type = "BUSINESS",
                    Label = "",
                    Footer = "This challenge is not yet completed",
                    Data = {
                        Description = "1/3 Collectibles collected",
                        Progress = 1 / 3,
                        TextureDictionary = "satchel_textures",
                        Texture = "satchel_nav_herbs",
                    }
                },
                {
                    Id = "DAILY_CHALLENGE_3",
                    Type = "BUSINESS",
                    Label = "",
                    Footer = "This challenge is completed",
                    Data = {
                        Description = "1/1 Visited Cotorra springs",
                        Progress = 1 / 1,
                        TextureDictionary = "satchel_textures",
                        Texture = "satchel_nav_horse_items",
                    }
                },
                {
                    Id = "DAILY_CHALLENGE_4",
                    Type = "BUSINESS",
                    Label = "",
                    Footer = "This challenge is not yet completed",
                    Data = {
                        Description = "0/1 Resupply missions completed",
                        Progress = 0 / 1,
                        TextureDictionary = "satchel_textures",
                        Texture = "satchel_nav_loot",
                    }
                },
                {
                    Id = "DAILY_CHALLENGE_5",
                    Type = "BUSINESS",
                    Label = "",
                    Footer = "This challenge is not yet completed",
                    Data = {
                        Description = "0/1 Whole animal carcasses sold",
                        Progress = 0 / 1,
                        TextureDictionary = "satchel_textures",
                        Texture = "satchel_nav_sell",
                    }
                },
            },
        },
        {
            Id = "JOBS_MENU",
            Label = "Jobs & Tasks",
            Footer = "View available jobs and tasks",
            Scene = "ITEM_LIST",
            Tabs = {
                { Id = "ALL_TASKS_PAGE",    Label = "All",          Source = { Name = "Tasks", Filter = nil } },
                { Id = "CULTIVATION_PAGE",  Label = "Cultivation",  Source = { Name = "Tasks", Filter = "TYPE_CULTIVATION" } },
                { Id = "HERBALISM_PAGE",    Label = "Herbalism",    Source = { Name = "Tasks", Filter = "TYPE_HERB" } },
                { Id = "HUNTING_PAGE",      Label = "Hunting",      Source = { Name = "Tasks", Filter = "TYPE_HUNTING" } },
                { Id = "PLAYER_TASKS_PAGE", Label = "Player Tasks", Source = { Name = "Tasks", Filter = "TYPE_PLAYER" } },
            },
        },
        {
            Id = "SETTINGS_MENU",
            Label = "Settings",
            Footer = "Adjust your game settings",
            Items = {},
        },
        {
            Id = "INVITES_MENU",
            Label = "Invites",
            Footer = "Manage received invites",
            Scene = "ITEM_LIST",
            Tabs = {
                { Id = "ALL_INVITES_PAGE",   Label = "All",           Source = { Name = "Invites", Filter = nil } },
                { Id = "POSSE_INVITES_PAGE", Label = "Posse Invites", Source = { Name = "Invites", Filter = "TYPE_POSSE" } },
                { Id = "JOB_INVITES_PAGE",   Label = "Job Invites",   Source = { Name = "Invites", Filter = "TYPE_JOB" } },
            },
        },
    },
}

local function getPosseMembers(filter)
    local members = {
        { Id = "POSSE_MEMBER_1", Name = "PlayerOne",   Role = "TYPE_OFFICER", Online = true,  Distance = 100 },
        { Id = "POSSE_MEMBER_2", Name = "PlayerTwo",   Role = "TYPE_GRUNT",   Online = true,  Distance = 100 },
        { Id = "POSSE_MEMBER_3", Name = "PlayerThree", Role = "TYPE_GRUNT",   Online = false, Distance = nil },
        { Id = "POSSE_MEMBER_4", Name = "PlayerFour",  Role = "TYPE_OFFICER", Online = false, Distance = nil },
        { Id = "POSSE_MEMBER_5", Name = "PlayerFive",  Role = "TYPE_GRUNT",   Online = false, Distance = nil },
    }

    local items = {}
    for _, member in ipairs(members) do
        if not filter or member.Role == filter then
            table.insert(items, {
                Id = member.Id,
                Type = "TEXT",
                Label = member.Name,
                Footer = member.Name .. (member.Online and " is online" or " is offline"),
                Context = "ManagePosseMember",
                ContextItem = member,
                Data = { RightText = member.Online and (member.Distance .. "m") or "Offline" },
            })
        end
    end

    return items
end

local function getNearbyPlayers(_)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)

    local players = {
        { Id = "NEARBY_PLAYER_1", Name = "Blackwater",       Position = vector3(-687.3, -1242.249, 43.1) },
        { Id = "NEARBY_PLAYER_2", Name = "Rhodes",           Position = vector3(1227.77, -1304.7, 76.95) },
        { Id = "NEARBY_PLAYER_3", Name = "Emeral Ranch",     Position = vector3(1526.07, 444.58, 90.73) },
        { Id = "NEARBY_PLAYER_4", Name = "Valentine",        Position = vector3(-174.3, 621.18, 114.08) },
        { Id = "NEARBY_PLAYER_5", Name = "Flatneck Station", Position = vector3(-330.5, -350.76, 88.09) },
    }

    local items = {}
    for _, player in ipairs(players) do
        local distance = #(playerPos - player.Position)

        table.insert(items, {
            Id = player.Id,
            Type = "TEXT",
            Label = player.Name,
            Footer = "Invite " .. player.Name .. " to your posse",
            Context = "InviteToPosse",
            ContextItem = player,
            Data = { RightText = string.format("%.1fm", distance) },
        })
    end

    return items
end

local function getEmotes(filter)
    local emotes = {
        { Id = "EMOTE_1", Name = "Wave",      Type = "TYPE_GREET" },
        { Id = "EMOTE_2", Name = "Dance",     Type = "TYPE_DANCE" },
        { Id = "EMOTE_3", Name = "Laugh",     Type = "TYPE_REACTION" },
        { Id = "EMOTE_4", Name = "Salute",    Type = "TYPE_GREET" },
        { Id = "EMOTE_5", Name = "Thumbs Up", Type = "TYPE_REACTION" },
        { Id = "EMOTE_6", Name = "Cheer",     Type = "TYPE_TAUNT" },
        { Id = "EMOTE_7", Name = "Sit Down",  Type = "TYPE_ACTION" },
        { Id = "EMOTE_8", Name = "Clap",      Type = "TYPE_REACTION" },
    }

    local items = {}
    for _, emote in ipairs(emotes) do
        if not filter or emote.Type == filter then
            table.insert(items, {
                Id = emote.Id,
                Type = "TEXT",
                Label = emote.Name,
                Footer = "Perform the " .. emote.Name .. " emote",
                Context = "PerformEmote",
                ContextItem = emote,
            })
        end
    end

    return items
end

local function getTasks(filter)
    local tasks = {
        { Id = "TASK_1", Name = "Collect Herbs",      Type = "TYPE_HERB" },
        { Id = "TASK_2", Name = "Hunt Deer",          Type = "TYPE_HUNTING" },
        { Id = "TASK_3", Name = "Cultivate Crops",    Type = "TYPE_CULTIVATION" },
        { Id = "TASK_4", Name = "Help Player Bob",    Type = "TYPE_PLAYER" },
        { Id = "TASK_5", Name = "Gather Wild Plants", Type = "TYPE_HERB" },
    }

    local items = {}
    for _, task in ipairs(tasks) do
        if not filter or task.Type == filter then
            table.insert(items, {
                Id = task.Id,
                Type = "TEXT",
                Label = task.Name,
                Footer = "View details for the task: " .. task.Name,
                Context = "ViewTaskDetails",
                ContextItem = task,
            })
        end
    end

    return items
end

local function getInvites(filter)
    local invites = {
        { Id = "INVITE_1", Type = "TYPE_POSSE", From = "PlayerOne" },
        { Id = "INVITE_2", Type = "TYPE_JOB",   From = "PlayerTwo" },
        { Id = "INVITE_3", Type = "TYPE_POSSE", From = "PlayerThree" },
    }

    local items = {}
    for _, invite in ipairs(invites) do
        local labelFromType = {
            TYPE_POSSE = "Posse",
            TYPE_JOB = "Job",
        }

        if not filter or invite.Type == filter then
            table.insert(items, {
                Id = invite.Id,
                Type = "TEXT",
                Label = labelFromType[invite.Type] .. " invite from " .. invite.From,
                Footer = "You have been invited by " .. invite.From,
                Context = "ManageInvite",
                ContextItem = invite,
            })
        end
    end

    return items
end

ShopNavigator:register(
    data,
    {
        PosseMembers = getPosseMembers,
        NearbyPlayers = getNearbyPlayers,
        Emotes = getEmotes,
        Tasks = getTasks,
        Invites = getInvites,
    },
    {}
)

Citizen.CreateThread(function()
    while true do
        -- For performance reasons, only trigger events when the player menu is open
        if ShopNavigator:getRootMenuId() == "PLAYER_MENU" then
            TriggerEvent("shop:refresh_menu", "INVITE_NEARBY")
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(0, "INPUT_PLAYER_MENU") and IsUiappRunningByHash(joaat("shop_menu")) ~= 1 then
            local prompt = 0

            -- Create prompt
            if prompt == 0 then
                prompt = UiPromptRegisterBegin()
                UiPromptSetControlAction(prompt, GetHashKey("INPUT_PLAYER_MENU"))
                UiPromptSetText(prompt, VarString(10, "LITERAL_STRING", "Player Menu"))
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
                        TriggerEvent("shop:open", "PLAYER_MENU")
                    end

                    UiPromptDelete(prompt)
                    prompt = 0
                end)
            end
        end
    end
end)