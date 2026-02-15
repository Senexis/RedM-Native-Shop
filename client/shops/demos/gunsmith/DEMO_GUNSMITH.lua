local data = {
    Id = "DEMO_GUNSMITH",
    Title = "GUNSMITH",
    Scene = "ITEM_LIST_DESCRIPTION",
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
    local items = {}
    for _, item in ipairs(MODIFIABLE_WEAPONS) do
        if not filter or item.Type == filter then
            local name = GetStringFromHashKey(item.Id)

            table.insert(items, {
                Id = item.Id,
                Label = name,
                LinkMenuId = "DEMO_WEAPON_OPTIONS",
                LinkPageId = nil,
                LinkData = item,
            })
        end
    end

    return items
end

-- In your script, you may want to load these elsewhere
-- Perhaps you could move this to a thread that runs during game load
while HasStreamedTxdLoaded("swatches_gunsmith_mp") ~= 1 do
    RequestStreamedTxd("swatches_gunsmith_mp", false)
    Wait(0)
end

while HasStreamedTxdLoaded("swatches_gunsmith") ~= 1 do
    RequestStreamedTxd("swatches_gunsmith", false)
    Wait(0)
end

ShopNavigator:register(data, { WeaponItems = getWeaponItems })
