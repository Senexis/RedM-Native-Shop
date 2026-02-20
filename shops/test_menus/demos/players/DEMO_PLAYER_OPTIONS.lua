local function getPlayerOptionsMenu(player)
    local name = player and player.Name or "Unknown"
    local online = player and player.IsOnline or false

    return {
        Title = "PLAYERS",
        Subtitle = name,
        Items = {
            {
                Id = "OPT_INVITE",
                Label = "Invite to Posse",
                Disabled = not online,
                Action = function()
                    PostFeedTicker(string.format("Inviting %s to your posse", name))
                end
            },
            {
                Id = "OPT_MESSAGE",
                Label = "Send Message",
                Action = function()
                    PostFeedTicker(string.format("Messaging %s", name))
                end
            },
            {
                Id = "OPT_PROFILE",
                Label = "View Profile",
                Action = function()
                    PostFeedTicker(string.format("Viewing %s's profile", name))
                end
            }
        }
    }
end

ShopNavigator:registerDynamic("DEMO_PLAYER_OPTIONS", getPlayerOptionsMenu)
