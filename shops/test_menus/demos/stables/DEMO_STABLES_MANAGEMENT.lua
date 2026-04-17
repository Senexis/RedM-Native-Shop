local MENU_ID <const> = "DEMO_STABLES_MANAGEMENT"

local data = {
    Id = MENU_ID,
    Title = "STABLES",
    Subtitle = "Owned Horses",
    AllowWalking = true,
    RepositionCamera = true,
    ItemSource = "HorseSlots",
    Items = {}
}

local function getHorseSlots()
    local items = {}
    for _, item in ipairs(INVENTORY_DEMO) do
        local owned = item.Horse ~= nil
        local active = owned and item.Active == true
        local nickname = owned and item.Nickname or "No Nickname"
        local slotLabel = owned and nickname or string.format("Empty Stall %d", item.Id)
        -- local auto = owned and item.Horse or false
        local linkMenu = owned and "DEMO_STABLES_HORSE_OPTIONS" or "DEMO_STABLES_BROWSE"
        local selectPromptLabel = owned and "Upgrade" or "Purchase"
        local togglePromptVisible = owned
        local togglePromptLabel = active and "Stable" or "Make Active"
        local texture = active and "BLIP_HORSE_OWNED_ACTIVE" or "BLIP_HORSE_OWNED"

        local footer = nil
        if active then
            footer = string.format("%s is your active horse.", nickname)
        elseif owned then
            footer = string.format("%s is stabled.", nickname)
        else
            footer = "Purchase a horse for this stall."
        end

        table.insert(items, {
            Id = "HORSE_SLOT_" .. item.Id,
            Type = "STABLE",
            Label = slotLabel,
            Footer = footer,
            -- Auto = auto,
            LinkMenuId = linkMenu,
            LinkPageId = nil,
            LinkData = item.Id,
            Data = {
                FrontSlotTextureVisible = owned,
                FrontSlotTextureDictionary = owned and "BLIPS" or nil,
                FrontSlotTexture = owned and texture or nil,
            },
            Prompts = {
                Select = selectPromptLabel,
                Toggle = { Visible = togglePromptVisible, Label = togglePromptLabel }
            },
            Metadata = {
                Slot = item.Id,
                Owned = owned,
            }
        })
    end

    return items
end

ShopApi.Register(data, { HorseSlots = getHorseSlots })

AddEventHandler("native_shop:item_action", function(event)
    if ShopNavigator:getCurrentMenuId() ~= MENU_ID then
        return
    end

    if not tostring(event.ID):find("HORSE_SLOT_") then
        return
    end

    if event.Action == "toggle" then
        for _, item in ipairs(INVENTORY_DEMO) do
            local label = event.Item and event.Item.Label
            local metadata = event.Item and event.Item.Metadata or {}
            if not metadata.Owned then return end
            local slot = metadata.Slot or event.Index
            if item.Id == slot then
                if item.Active then
                    item.Active = false
                    PostFeedTicker(string.format("%s is now stabled.", label))
                else
                    item.Active = true
                    PostFeedTicker(string.format("%s is now your active horse.", label))
                end
            else
                item.Active = false
            end
        end
        TriggerEvent("native_shop:refresh_menu", MENU_ID)
        TriggerEvent("native_shop:refresh_root", "DEMO_STABLES")
        TriggerEvent("native_shop:refresh_root", "DEMO_STABLES_HORSE_OPTIONS")
    end
end)
