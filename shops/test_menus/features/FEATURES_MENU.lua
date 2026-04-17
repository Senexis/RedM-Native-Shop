local MENU_ID <const> = "FEATURES_MENU"

local data = {
    Id = MENU_ID,
    Title = "FEATURES",
    Subtitle = "Index",
    Scene = "MENU_LIST",
    AllowWalking = true,
    RepositionCamera = true,
    Items = {
        {
            Id = "MENU_TYPES_MENU",
            Scene = "MENU_LIST",
            Label = "Menu Types",
            LinkMenuId = "FEATURE_MENU_TYPES",
            LinkPageId = nil,
            Data = {
                ItemDescription = "A preview of the different menus. Not all options are supported in every menu. Pricing is included in all items, but can be omitted if desired.",
            }
        },
        {
            Id = "ITEM_TYPES_MENU",
            Scene = "MENU_LIST",
            Label = "Item Types",
            LinkMenuId = "FEATURE_ITEM_TYPES",
            LinkPageId = nil,
            Data = {
                ItemDescription = "A preview of the different menu items. Used within various menus to showcase different item data options.",
            }
        },
        {
            Id = "PROMPTS_MENU",
            Scene = "MENU_LIST",
            Label = "Prompts",
            LinkMenuId = "FEATURE_PROMPTS",
            LinkPageId = nil,
            Data = {
                ItemDescription = "A demo menu showcasing all available prompt types with custom labels, held prompts, and disabled prompts.",
            },
        },
        {
            Id = "ACTIONS_MENU",
            Label = "Actions",
            LinkMenuId = "FEATURE_ACTIONS",
            LinkPageId = nil,
            Data = {
                ItemDescription = "Showcases examples of common menu actions such as closing the menu, going back a page, or linking to another menu.",
            },
        },
        {
            Id = "TABS_MENU",
            Label = "Tabs",
            LinkMenuId = "FEATURE_TABS",
            LinkPageId = nil,
            Data = {
                ItemDescription = "A demonstration of how to use tabs within the native shop UI. Tabs can be used to categorize items and make navigation easier.",
            },
        }
    }
}

ShopApi.Register(data)
