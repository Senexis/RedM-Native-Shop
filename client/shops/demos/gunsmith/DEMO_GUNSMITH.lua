local data = {
    Id = "DEMO_GUNSMITH",
    Title = "GUNSMITH",
    Scene = "ITEM_LIST_WEAPON_STATS",
    AllowWalking = true,
    RepositionCamera = true,
    Tabs = {
        { Id = "WEAPON_ALL",      Label = "All",       Source = { Name = "WeaponItems", Filter = nil } },
        { Id = "WEAPON_BOW",      Label = "Bows",      Source = { Name = "WeaponItems", Filter = "BOW" } },
        { Id = "WEAPON_REVOLVER", Label = "Revolvers", Source = { Name = "WeaponItems", Filter = "REVOLVER" } },
        { Id = "WEAPON_PISTOL",   Label = "Pistols",   Source = { Name = "WeaponItems", Filter = "PISTOL" } },
        { Id = "WEAPON_REPEATER", Label = "Repeaters", Source = { Name = "WeaponItems", Filter = "REPEATER" } },
        { Id = "WEAPON_RIFLE",    Label = "Rifles",    Source = { Name = "WeaponItems", Filter = "RIFLE" } },
        { Id = "WEAPON_SHOTGUN",  Label = "Shotguns",  Source = { Name = "WeaponItems", Filter = "SHOTGUN" } },
        { Id = "WEAPON_MELEE",    Label = "Melee",     Source = { Name = "WeaponItems", Filter = "MELEE" } },
    }
}

local function getWeaponItems(filter)
    -- Get text for the footers
    local customizeTooltip = GetStringFromHashKey(525827058)
    local dontOwnTooltip = GetStringFromHashKey("SHOP_TOOLTIP_DONT_OWN_ITEM")

    local items = {}
    for _, item in ipairs(MODIFIABLE_WEAPONS) do
        if not filter or item.Type == filter then
            local name = GetStringFromHashKey(item.Id)
            local stats = GetWeaponStats(item.Id)

            -- You'll want to improve these, just for demo purposes
            local owned = HasPedGotWeapon(PlayerPedId(), item.Id, false) == 1
            local secondary = owned and (IsWeaponOneHanded(item.Id) == 1)

            if owned then
                table.insert(items, {
                    Id = item.Id,
                    Label = name,
                    Footer = customizeTooltip,
                    Prompts = {
                        Select = "Customize",
                        Option = { Visible = secondary, Label = "Buy Secondary" }
                    },
                    Data = { WeaponStats = stats },
                    LinkMenuId = "DEMO_WEAPON_OPTIONS",
                    LinkPageId = nil,
                    LinkData = item,
                })
            else
                table.insert(items, {
                    Id = item.Id,
                    Label = name,
                    Footer = dontOwnTooltip,
                    Prompts = {
                        Select = "Buy"
                    },
                    Data = { WeaponStats = stats },
                    Action = function(selected)
                        GiveWeaponToPed(PlayerPedId(), selected.Id, 9999, true, true, 0, false, 0.5, 1.0, `ADD_REASON_DEFAULT`, true, 0, false)
                        PostFeedTicker(string.format("Purchased %s", selected.Label))
                        TriggerEvent("shop:refresh_menu", "DEMO_GUNSMITH")
                    end,
                })
            end
        end
    end

    return items
end

ShopNavigator:register(data, { WeaponItems = getWeaponItems })
