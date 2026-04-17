local function getStablesMenu()
    local menuItems = {}

    for _, class in ipairs(HORSES) do
        local breedOrder = {}
        local breedGroups = {}

        for _, horse in ipairs(class.Items) do
            local breedId = horse.BreedShort

            if not breedGroups[breedId] then
                breedGroups[breedId] = {}
                table.insert(breedOrder, breedId)
            end

            table.insert(breedGroups[breedId], {
                Id = horse.Model,
                Label = GetStringFromHashKey(horse.Coat),
                Prompts = {
                    Select = "Purchase"
                },
                Action = function(selected)
                    PostFeedTicker(string.format("Selected %s", horse.Model))
                end
            })
        end

        local breedsList = {}
        for _, id in ipairs(breedOrder) do
            table.insert(breedsList, {
                Id = id,
                Label = GetStringFromHashKey(id),
                Items = breedGroups[id],
            })
        end

        table.insert(menuItems, {
            Id = class.Class,
            Label = GetStringFromHashKey(class.Class),
            Items = breedsList,
        })
    end

    return {
        Title = "STABLES",
        Subtitle = "Browse Horses",
        AllowWalking = true,
        RepositionCamera = true,
        Items = menuItems,
    }
end

ShopApi.RegisterDynamic("DEMO_STABLES_BROWSE", getStablesMenu)
