local data = {
    Id = "DEMO_GUNSMITH",
    Title = "GUNSMITH",
    Scene = "ITEM_LIST_WEAPON_STATS",
    AllowWalking = true,
    RepositionCamera = true,
    Tabs = {
        { Id = "WT_ALL",      Label = "All",       All = true },
        { Id = "WT_BOW",      Label = "Bows", },
        { Id = "WT_REVOLVER", Label = "Revolvers", },
        { Id = "WT_PISTOL",   Label = "Pistols", },
        { Id = "WT_REPEATER", Label = "Repeaters", },
        { Id = "WT_RIFLE",    Label = "Rifles", },
        { Id = "WT_SHOTGUN",  Label = "Shotguns", },
        { Id = "WT_MELEE",    Label = "Melee", },
    },
    ItemSource = "WeaponItems",
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
                        TriggerEvent("native_shop:refresh_menu", "DEMO_GUNSMITH")
                    end,
                })
            end
        end
    end

    return items
end

ShopApi.Register(data, { WeaponItems = getWeaponItems })
