local data = {
    Id = "FEATURE_TABS",
    Title = "FEATURES",
    Subtitle = "Tabs",
    Scene = "ITEM_LIST",
    AllowWalking = true,
    RepositionCamera = true,
    Tabs = {
        { Id = "TAB_ALL", Label = "All",  All = true },
        { Id = "TAB_1",   Label = "Tab 1" },
        { Id = "TAB_2",   Label = "Tab 2" },
        { Id = "TAB_3",   Label = "Tab 3" },
        { Id = "TAB_4",   Label = "Tab 4" },
    },
    Items = {
        {
            Id = "TEST_ITEM_1",
            Type = "TEXT",
            Label = "Visible on All"
        },
        {
            Id = "TEST_ITEM_2",
            Type = "TEXT",
            Label = "Visible on All and Tab 1",
            Tab = "TAB_1"
        },
        {
            Id = "TEST_ITEM_3",
            Type = "TEXT",
            Label = "Visible on All and Tab 2",
            Tab = "TAB_2"
        },
        {
            Id = "TEST_ITEM_4",
            Type = "TEXT",
            Label = "Visible on All and Tab 3",
            Tab = "TAB_3"
        },
        {
            Id = "TEST_ITEM_5",
            Type = "TEXT",
            Label = "Visible on All and Tab 4",
            Tab = "TAB_4"
        },
    }
}

ShopApi.Register(data)
