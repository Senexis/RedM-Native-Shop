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
            Id = "TEST_MENUS",
            Scene = "MENU_LIST",
            Label = "Menu Types",
            LinkMenuId = "FEATURE_MENU_TYPES",
            LinkPageId = nil,
            Data = {
                ItemDescription = "A preview of the different menus. Not all options are supported in every menu. Pricing is included in all items, but can be omitted if desired.",
            }
        },
        {
            Id = "TEST_ITEMS",
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
            Data = {
                ItemDescription = "A demo menu showcasing all available prompt types with custom labels, held prompts, and disabled prompts.",
            },
            Items = {
                {
                    Id = "PROMPTS_ACTION",
                    Type = "TEXT",
                    Label = "Prompts",
                    Footer = "This is the default footer",
                    Prompts = {
                        Select = "Custom Select",
                        Option = "Custom Option",
                        Toggle = "Custom Toggle",
                        Info = "Custom Info",
                        Adjust = "Custom Adjust",
                        Modify = "Custom Modify",
                    },
                    Data = {
                        ItemDescription = "Showcases an example of custom prompt labels for all available prompts.",
                        DisabledFooter = "~e~Disabled footer overrides default footer",
                    }
                },
                {
                    Id = "HELD_PROMPTS_ACTION",
                    Type = "TEXT",
                    Label = "Held Prompts",
                    Footer = "This is the default footer",
                    Prompts = {
                        Select = { Visible = true, Label = "Held Select", Held = true },
                        Option = { Visible = true, Label = "Held Option", Held = true },
                        Toggle = { Visible = true, Label = "Held Toggle", Held = true },
                        Info = { Visible = true, Label = "Info (not supported)", Held = false },
                        Adjust = { Visible = true, Label = "Adjust (not supported)", Held = false },
                        Modify = { Visible = true, Label = "Modify (not supported)", Held = false },
                    },
                    Data = {
                        ItemDescription = "Showcases an example of held prompts for all available prompts.",
                        DisabledFooter = "~e~Disabled footer overrides default footer",
                    }
                },
                {
                    Id = "DISABLED_PROMPTS_ACTION",
                    Type = "TEXT",
                    Label = "Disabled Prompts",
                    Disabled = true,
                    Footer = "This is the default footer",
                    Prompts = {
                        Select = "Disabled Select",
                        Option = "Disabled Option",
                        Toggle = "Disabled Toggle",
                        Info = "Disabled Info",
                        Adjust = "Disabled Adjust",
                        Modify = "Disabled Modify",
                    },
                    Data = {
                        ItemDescription = "Showcases what happens when an item is disabled with custom prompts and a footer. Also has effects on scene UI.",
                        DisabledFooter = "~e~Disabled footer overrides default footer",
                    }
                },
            },
        },
        {
            Id = "ACTIONS_MENU",
            Label = "Actions",
            Data = {
                ItemDescription = "Showcases examples of common menu actions such as closing the menu, going back a page, or linking to another menu.",
            },
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
    }
}

ShopNavigator:register(data)

AddEventHandler("native_shop:item_action", function(event)
    if ShopNavigator:getRootMenuId() ~= MENU_ID then
        return
    end

    if event.ID == "PROMPTS_ACTION" or event.ID == "HELD_PROMPTS_ACTION" then
        if event.ActionParameter then
            PostFeedTicker(string.format("Action: '%s' with parameter '%s'", event.Action, event.ActionParameter))
        else
            PostFeedTicker(string.format("Action: '%s'", event.Action))
        end
    end
end)
