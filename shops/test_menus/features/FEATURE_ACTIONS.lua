local data = {
    Id = "FEATURE_ACTIONS",
    Title = "FEATURES",
    Subtitle = "Actions",
    Scene = "MENU_LIST",
    AllowWalking = true,
    RepositionCamera = true,
    Items = {
        {
            Id = "ACTION_FUNCTION",
            Type = "TEXT",
            Label = "Function",
            Data = {
                ItemDescription = "Showcases an example of a custom function action. Selecting this item will execute the provided function.",
            },
            Action = function(item)
                PostFeedTicker(string.format("Custom function %s executed", item.Id))
            end
        },
        {
            Id = "ACTION_BACK",
            Type = "TEXT",
            Label = "Go Back",
            Action = "BACK",
            Data = {
                ItemDescription = "Showcases an example of an item that goes back a page when selected.",
            }
        },
        {
            Id = "ACTION_ROOT",
            Type = "TEXT",
            Label = "Go to Root",
            Action = "ROOT",
            Data = {
                ItemDescription = "Showcases an example of an item that goes to the root page when selected.",
            }
        },
        {
            Id = "ACTION_LINK_ONLY",
            Type = "TEXT",
            Label = "Link to Menu",
            LinkMenuId = "FEATURE_SUB_MENUS",
            LinkPageId = nil,
            Data = {
                ItemDescription = "Showcases an example of a menu link. Selecting this item will take you to another menu.",
            }
        },
        {
            Id = "ACTION_LINK_WITH_PAGE_PARENT",
            Type = "TEXT",
            Label = "Link to Page (Type 1)",
            LinkMenuId = "FEATURE_SUB_MENUS",
            LinkPageId = "TEST_PAGE_LINK",
            LinkBackToParent = true,
            Data = {
                ItemDescription = "Showcases an example of a menu link with a specific page. Selecting this item will take you to the specified page in the sub-menu. When navigating back, it will return you to the parent page.",
            }
        },
        {
            Id = "ACTION_LINK_WITH_PAGE_NO_PARENT",
            Type = "TEXT",
            Label = "Link to Page (Type 2)",
            LinkMenuId = "FEATURE_SUB_MENUS",
            LinkPageId = "TEST_PAGE_LINK",
            LinkBackToParent = false,
            Data = {
                ItemDescription = "Showcases an example of a menu link with a specific page. Selecting this item will take you to the specified page in the sub-menu. When navigating back, it will return you back here instead of the parent page.",
            }
        },
        {
            Id = "ACTION_HIDE_MENU",
            Type = "TEXT",
            Label = "Hide Menu",
            Action = "HIDE",
            Data = {
                ItemDescription = "Showcases an example of an item that hides the menu when selected. The next time this menu is opened, it will appear in the same state as before assuming no other menu has been opened in the meantime.",
            }
        },
        {
            Id = "ACTION_CLOSE_MENU",
            Type = "TEXT",
            Label = "Close Menu",
            Action = "CLOSE",
            Data = {
                ItemDescription = "Showcases an example of an item that closes the menu when selected.",
            }
        }
    },
}

ShopApi.Register(data)
