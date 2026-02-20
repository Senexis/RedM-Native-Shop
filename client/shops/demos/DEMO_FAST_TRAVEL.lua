local MENU_ID <const> = "DEMO_FAST_TRAVEL"

local data = {
    Id = MENU_ID,
    Title = "FAST TRAVEL",
    Scene = "ITEM_LIST_DESCRIPTION",
    AllowWalking = true,
    RepositionCamera = true,
    Tabs = {
        { Id = "REG_ALL",            Label = "All",            Source = { Name = "FastTravelItems", Filter = nil } },
        { Id = "REG_AMBARINO",       Label = "Ambarino",       Source = { Name = "FastTravelItems", Filter = "REG_AMBARINO" } },
        { Id = "REG_NEW_HANOVER",    Label = "New Hanover",    Source = { Name = "FastTravelItems", Filter = "REG_NEW_HANOVER" } },
        { Id = "REG_LEMOYNE",        Label = "Lemoyne",        Source = { Name = "FastTravelItems", Filter = "REG_LEMOYNE" } },
        { Id = "REG_WEST_ELIZABETH", Label = "West Elizabeth", Source = { Name = "FastTravelItems", Filter = "REG_WEST_ELIZABETH" } },
        { Id = "REG_NEW_AUSTIN",     Label = "New Austin",     Source = { Name = "FastTravelItems", Filter = "REG_NEW_AUSTIN" } },
    }
}

local function getFastTravelItems(filter)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)

    local places = {
        { Id = "ANNESBERG",   Name = "STATION_ANNESBERG",   Description = "NFT_ANNESBERG_DESC",   Type = "REG_NEW_HANOVER",    Position = vector3(2934.167, 1273.326, 44.653) },
        { Id = "ARMADILLO",   Name = "STATION_ARMADILLO",   Description = "NFT_ARMADILLO_DESC",   Type = "REG_NEW_AUSTIN",     Position = vector3(-3734.225, -2602.259, -12.917) },
        { Id = "BLACKWATER",  Name = "STATION_BLACKWATER",  Description = "NFT_BLACKWATER_DESC",  Type = "REG_NEW_AUSTIN",     Position = vector3(-738.595, -1252.058, 44.734) },
        { Id = "COLTER",      Name = "STATION_COLTER",      Description = "NFT_COLTER_DESC",      Type = "REG_AMBARINO",       Position = vector3(-1294.828, 2416.529, 305.952) },
        { Id = "EMERALD",     Name = "STATION_EMERALD",     Description = "NFT_EMERALD_DESC",     Type = "REG_NEW_HANOVER",    Position = vector3(1519.545, 431.535, 90.681) },
        { Id = "LAGRAS",      Name = "STATION_LAGRAS",      Description = "NFT_LAGRAS_DESC",      Type = "REG_LEMOYNE",        Position = vector3(2108.463, -584.866, 41.675) },
        { Id = "MACFARLANES", Name = "STATION_MACFARLANES", Description = "NFT_MACFARLANES_DESC", Type = "REG_NEW_AUSTIN",     Position = vector3(-2490.510, -2438.064, 60.583) },
        { Id = "MANZANITA",   Name = "STATION_MANZANITA",   Description = "NFT_MANZANITA_DESC",   Type = "REG_WEST_ELIZABETH", Position = vector3(-1995.512, -1610.602, 118.119) },
        { Id = "RHODES",      Name = "STATION_RHODES",      Description = "NFT_RHODES_DESC",      Type = "REG_LEMOYNE",        Position = vector3(1269.275, -1297.568, 76.957) },
        { Id = "SAINT_DENIS", Name = "STATION_SAINT_DENIS", Description = "NFT_SAINT_DENIS_DESC", Type = "REG_LEMOYNE",        Position = vector3(2695.005, -1446.752, 46.266) },
        { Id = "STRAWBERRY",  Name = "STATION_STRAWBERRY",  Description = "NFT_STRAWBERRY_DESC",  Type = "REG_WEST_ELIZABETH", Position = vector3(-1783.893, -430.469, 156.470) },
        { Id = "TUMBLEWEED",  Name = "STATION_TUMBLEWEED",  Description = "NFT_TUMBLEWEED_DESC",  Type = "REG_NEW_AUSTIN",     Position = vector3(-5425.016, -2919.998, 0.940) },
        { Id = "VALENTINE",   Name = "STATION_VALENTINE",   Description = "NFT_VALENTINE_DESC",   Type = "REG_NEW_HANOVER",    Position = vector3(-175.067, 640.543, 114.133) },
        { Id = "VAN_HORN",    Name = "STATION_VAN_HORN",    Description = "NFT_VAN_HORN_DESC",    Type = "REG_NEW_HANOVER",    Position = vector3(2892.003, 619.931, 57.734) },
        { Id = "WAPITI",      Name = "STATION_WAPITI",      Description = "NFT_WAPITI_DESC",      Type = "REG_AMBARINO",       Position = vector3(486.875, 2209.392, 246.876) },
    }

    local items = {}
    for _, place in ipairs(places) do
        if not filter or place.Type == filter then
            local distance = #(playerPos - place.Position)
            local name = GetStringFromHashKey(place.Name)
            local description = GetStringFromHashKey(place.Description)

            table.insert(items, {
                _DISTANCE = distance,
                Id = "FAST_TRAVEL_" .. place.Id,
                Type = "TEXT",
                Label = name,
                Footer = string.format("%s is %.1f meters away", name, distance),
                Prompts = {
                    Select = "Travel"
                },
                Data = {
                    RightText = string.format("%.1fm", distance),
                    ItemDescription = description,
                },
                Action = function(item)
                    PostFeedTicker(string.format("Fast travelling to %s...", item.Label))
                end
            })
        end
    end

    table.sort(items, function(a, b)
        return a._DISTANCE < b._DISTANCE
    end)

    return items
end

ShopNavigator:register(data, { FastTravelItems = getFastTravelItems })

Citizen.CreateThread(function()
    while true do
        if ShopNavigator:getRootMenuId() == MENU_ID then
            TriggerEvent("shop:refresh_menu", MENU_ID)
        end

        Citizen.Wait(1000)
    end
end)
