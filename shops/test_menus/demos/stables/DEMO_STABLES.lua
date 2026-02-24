local function getStablesMenu()
    local hasActive = false
    for _, item in ipairs(INVENTORY_DEMO) do
        if item.Active == true then
            hasActive = true
            break
        end
    end

    return {
        Title = "STABLES",
        Subtitle = "Valentine Stables",
        AllowWalking = true,
        RepositionCamera = true,
        Items = {
            {
                Id = "MANAGEMENT",
                Label = "Manage Owned Horses",
                Footer = "Manage your owned horses.",
                LinkMenuId = "DEMO_STABLES_MANAGEMENT",
                LinkPageId = nil,
            },
            {
                Id = "BUY_HORSE",
                Label = "Buy Horses",
                Footer = "Browse horses that are in stock.",
                LinkMenuId = "DEMO_STABLES_BROWSE",
                LinkPageId = nil,
            },
            {
                Id = "UPGRADES",
                Label = "Tack and Services",
                Footer = "Horse appearance, upgrade and service options.",
                Disabled = not hasActive,
                LinkMenuId = "DEMO_STABLES_HORSE_OPTIONS",
                LinkPageId = nil,
                LinkData = "ACTIVE_HORSE",
                Data = {
                    DisabledFooter = "You don't have an active horse.",
                }
            },
            {
                Id = "BUY_ITEMS",
                Scene = "ITEM_LIST_RPG_STATS",
                Label = "Horse Provisions",
                Footer = "Buy items to care for your horse.",
                Tabs = {
                    { Id = "TAB_ALL",    Label = "All",       All = true },
                    { Id = "PROVISIONS", Label = "Provisions" },
                    { Id = "TONICS",     Label = "Tonics" },
                },
                Items = {
                    {
                        Id = "CONSUMABLE_APPLE",
                        Auto = true,
                        Tab = "PROVISIONS",
                    },
                    {
                        Id = "CONSUMABLE_BEETS",
                        Auto = true,
                        Tab = "PROVISIONS",
                    },
                    {
                        Id = "CONSUMABLE_CARROT",
                        Auto = true,
                        Tab = "PROVISIONS",
                    },
                    {
                        Id = "CONSUMABLE_HAYCUBE",
                        Auto = true,
                        Tab = "PROVISIONS",
                    },
                    {
                        Id = "CONSUMABLE_PEPPERMINT",
                        Auto = true,
                        Tab = "PROVISIONS",
                    },
                    {
                        Id = "CONSUMABLE_CELERY",
                        Auto = true,
                        Tab = "PROVISIONS",
                    },
                    {
                        Id = "CONSUMABLE_SUGARCUBE",
                        Auto = true,
                        Tab = "PROVISIONS",
                    },
                    {
                        Id = "CONSUMABLE_HORSE_STIMULANT",
                        Auto = true,
                        Tab = "TONICS",
                    },
                    {
                        Id = "CONSUMABLE_POTENT_HORSE_STIMULANT",
                        Auto = true,
                        Tab = "TONICS",
                    },
                    {
                        Id = "CONSUMABLE_HORSE_REVIVER",
                        Auto = true,
                        Tab = "TONICS",
                    },
                    {
                        Id = "CONSUMABLE_HORSE_MEDICINE",
                        Auto = true,
                        Tab = "TONICS",
                    },
                    {
                        Id = "CONSUMABLE_POTENT_HORSE_MEDICINE",
                        Auto = true,
                        Tab = "TONICS",
                    },
                }
            }
        },
    }
end

ShopNavigator:registerDynamic("DEMO_STABLES", getStablesMenu)
