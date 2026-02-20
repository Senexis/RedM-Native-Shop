local data = {
    Id = "DEMO_PLAYERS",
    Title = "PLAYERS",
    Scene = "ITEM_LIST_DESCRIPTION",
    AllowWalking = true,
    RepositionCamera = true,
    Tabs = {
        { Id = "PLR_ALL",     Label = "All",     Source = { Name = "PlayerItems", Filter = nil } },
        { Id = "PLR_NEARBY",  Label = "Nearby",  Source = { Name = "PlayerItems", Filter = "PLR_NEARBY" } },
        { Id = "PLR_ONLINE",  Label = "Online",  Source = { Name = "PlayerItems", Filter = "PLR_ONLINE" } },
        { Id = "PLR_OFFLINE", Label = "Offline", Source = { Name = "PlayerItems", Filter = "PLR_OFFLINE" } },
    }
}

local function getPlayerItems(filter)
    local players = {
        { ID = 1, Name = "PlayerOne",   Distance = 5.0,  IsOnline = true },
        { ID = 2, Name = "PlayerTwo",   Distance = nil,  IsOnline = false },
        { ID = 3, Name = "PlayerThree", Distance = 25.0, IsOnline = true },
        { ID = 4, Name = "PlayerFour",  Distance = 35.0, IsOnline = true },
    }

    local filters = {
        PLR_NEARBY = function(player) return player.IsOnline and player.Distance <= 10.0 end,
        PLR_ONLINE = function(player) return player.IsOnline and player.Distance > 10.0 end,
        PLR_OFFLINE = function(player) return not player.IsOnline end,
    }

    local items = {}
    for _, item in ipairs(players) do
        if not filter or filters[filter](item) then
            local name = item.Name
            local footer = ""

            if item.IsOnline then
                footer = string.format("%s is %.1f meters away", name, item.Distance)
            else
                footer = string.format("%s is currently offline", name)
            end

            table.insert(items, {
                Id = "PLAYER_" .. item.ID,
                Type = "INVENTORY",
                Label = name,
                Footer = footer,
                LinkMenuId = "DEMO_PLAYER_OPTIONS",
                LinkPageId = nil,
                LinkData = item,
            })
        end
    end

    return items
end

ShopNavigator:register(data, { PlayerItems = getPlayerItems })
