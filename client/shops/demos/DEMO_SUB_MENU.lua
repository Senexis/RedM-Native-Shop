local data = {
    Id = "DEMO_SUB_MENU",
    Title = "SUB MENU DEMO",
    Subtitle = "This is the main menu",
    Scene = "MENU_LIST",
    AllowWalking = true,
    RepositionCamera = true,
    Items = {
        {
            Id = "TEST_SUB_MENU_ITEM",
            Type = "TEXT",
            Label = "You landed on the main menu!",
            Disabled = true,
        },
        {
            Id = "TEST_PAGE_LINK",
            Type = "TEXT",
            Label = "Sub-menu",
            Subtitle = "This is the sub-menu",
            Items = {
                {
                    Id = "TEST_PAGE_ITEM",
                    Type = "TEXT",
                    Label = "You landed on the page!",
                    Disabled = true,
                }
            }
        }
    }
}

ShopNavigator:register(data)
