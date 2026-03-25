local MENU_ID <const> = "DEMO_STABLES_HORSE_OPTIONS"

local function getHorseName(title, description, default, maxLength)
    DisplayOnscreenKeyboard(4, title, description, default, "", "", "", maxLength)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        return result
    end

    return nil
end

local function getItems(items)
    local itemList = {}

    for _, item in ipairs(items) do
        if type(item) == "table" then
            table.insert(itemList, {
                Id = item.Id,
                Label = GetStringFromHashKey(item.Id),
                Items = getItems(item.Items),
                Data = {
                    AddIconVisible = true,
                    AddIconTextureDict = "itemtype_textures",
                    AddIconTexture = "itemtype_upgrades",
                }
            })
        else
            if HORSE_EQUIPMENT_STYLES[item] then
                table.insert(itemList, {
                    Id = item,
                    Label = GetStringFromHashKey(item),
                    LinkMenuId = "DEMO_STABLES_EQUIPMENT_STYLES",
                    LinkPageId = item,
                    Data = {
                        AddIconVisible = true,
                        AddIconTextureDict = "itemtype_textures",
                        AddIconTexture = "itemtype_upgrades",
                    }
                })
            else
                table.insert(itemList, {
                    Id = item,
                    Type = "TEXT",
                    Auto = true,
                    Prompts = {
                        Select = "Equip"
                    },
                    Action = function(selected)
                        PostFeedTicker(string.format("Selected %s", selected.Id))
                    end
                })
            end
        end
    end

    return itemList
end

local function getStablesMenu(data)
    local horse = nil

    if type(data) == "table" then
        horse = data
    else
        for _, item in ipairs(INVENTORY_DEMO) do
            if item.Active then
                horse = item
                break
            end
        end
    end

    if not horse or horse.Horse == nil then
        return {
            Title = "STABLES",
            Subtitle = "Manage Your Horse",
            AllowWalking = true,
            RepositionCamera = true,
        }
    end

    local nickname = horse.Nickname or "No Nickname"

    return {
        Title = "STABLES",
        Subtitle = function ()
            return string.format("Manage %s", nickname)
        end,
        AllowWalking = true,
        RepositionCamera = true,
        Items = {
            {
                Id = "RENAME",
                Label = "Rename",
                Footer = string.format("Give %s a new nickname.", nickname),
                Data = {
                    RightLabelVisible = true,
                    RightText = nickname,
                },
                Prompts = {
                    Select = "Rename",
                },
                Action = function()
                    local newName = getHorseName("STABLE_RENAME_MOUNT_PROMPT", "STABLE_RENAME_MOUNT_DESC", nickname, 24)

                    if type(newName) == "string" and newName ~= "" then
                        horse.Nickname = newName
                    end

                    TriggerEvent("native_shop:refresh_root", MENU_ID)
                    TriggerEvent("native_shop:refresh_root", "DEMO_STABLES")
                    TriggerEvent("native_shop:refresh_menu", MENU_ID)
                end
            },
            {
                Id = "TACK",
                Label = "Tack",
                Footer = string.format("Equip %s with tack and accessories.", nickname),
                Items = {
                    {
                        Id = "SADDLES",
                        Label = "Saddle",
                        Footer = string.format("Equip %s with a saddle.", nickname),
                        Items = getItems(HORSE_EQUIPMENT.SADDLES)
                    },
                    {
                        Id = "SADDLEBAG",
                        Label = "Saddle Bags",
                        Footer = string.format("Equip %s with a saddle bag.", nickname),
                        Items = getItems(HORSE_EQUIPMENT.SADDLEBAGS)
                    },
                    {
                        Id = "STIRRUPS",
                        Label = "Stirrups",
                        Footer = string.format("Equip %s with a pair of stirrups.", nickname),
                        Items = getItems(HORSE_EQUIPMENT.STIRRUPS)
                    },
                    {
                        Id = "HORNS",
                        Label = "Horns",
                        Footer = string.format("Equip %s with a saddle horn.", nickname),
                        Items = getItems(HORSE_EQUIPMENT.HORNS)
                    },
                    {
                        Id = "BLANKET",
                        Label = "Blankets",
                        Footer = string.format("Equip %s with a blanket.", nickname),
                        Items = getItems(HORSE_EQUIPMENT.BLANKETS)
                    },
                    {
                        Id = "BEDROLL",
                        Label = "Bedrolls",
                        Footer = string.format("Equip %s with a bedroll.", nickname),
                        Items = getItems(HORSE_EQUIPMENT.BEDROLLS)
                    },
                    {
                        Id = "LANTERN",
                        Label = "Lanterns",
                        Footer = string.format("Equip %s with a lantern.", nickname),
                        Items = getItems(HORSE_EQUIPMENT.LANTERNS)
                    },
                    {
                        Id = "MASK",
                        Label = "Masks",
                        Footer = string.format("Equip %s with a mask.", nickname),
                        Items = getItems(HORSE_EQUIPMENT.MASKS)
                    }
                }
            },
            {
                Id = "APPEARANCE",
                Label = "Appearance",
                Footer = string.format("Edit %s's appearance.", nickname),
                Items = {
                    {
                        Id = "MANE",
                        Label = "Mane",
                        Footer = string.format("Edit %s's mane.", nickname),
                        Items = getItems(HORSE_EQUIPMENT.MANES)
                    },
                    {
                        Id = "TAIL",
                        Label = "Tail",
                        Footer = string.format("Edit %s's tail.", nickname),
                        Items = getItems(HORSE_EQUIPMENT.TAILS)
                    },
                    {
                        Id = "MUSTACHE",
                        Label = "Mustache",
                        Footer = string.format("Edit %s's mustache.", nickname),
                        Items = getItems(HORSE_EQUIPMENT.MUSTACHES)
                    }
                }
            },
            {
                Id = "SELL",
                Label = "Sell",
                Footer = string.format("Sell %s to this stable.", nickname),
                Prompts = {
                    Select = { Visible = true, Label = "Sell", Held = true }
                }
            },
        },
    }
end

ShopNavigator:registerDynamic(MENU_ID, getStablesMenu)
