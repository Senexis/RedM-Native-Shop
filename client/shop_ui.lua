local validSceneTypes = {
    "BOUNTY_MANAGEMENT",
    "CLOTHING_MODIFY",
    "CLOTHING_STAT_INFO_BOX",
    "HORSE_MANAGEMENT",
    "HORSE_STAT_INFO_BOX",
    "ITEM_GRID",
    "ITEM_LIST",
    "ITEM_LIST_COLOUR_PALETTE",
    "ITEM_LIST_DESCRIPTION",
    "ITEM_LIST_HORSE_STATS",
    "ITEM_LIST_RECIPES",
    "ITEM_LIST_RPG_STATS",
    "ITEM_LIST_SLIDER",
    "ITEM_LIST_TEXTURE_DESCRIPTION",
    "ITEM_LIST_VEHICLE_STATS",
    "ITEM_LIST_WEAPON_STATS",
    "ITEM_SELL_LIST_HORSE_STATS",
    "MENU_LIST",
    "MENU_LIST_HORSE_STATS",
    "MENU_LIST_WEAPON_STATS",
    "MENU_STYLE_SELECTOR",
    "SADDLE_MANAGEMENT",
    "VEHICLE_MANAGEMENT",
    "WEAPON_MANAGEMENT",
}

local validItemTypes = {
    "BUSINESS",
    "COUPON",
    "HAIR",
    "INVENTORY",
    "PALETTE",
    "STABLE",
    "STEPPER",
    "TEXT",
}

local promptTypes = {
    "Select",
    "Option",
    "Toggle",
    "Info",
    "Adjust",
    "Modify",
    "Back",
}

local function applyDefaults(target, defaults)
    for key, value in pairs(defaults) do
        if type(value) == "table" then
            if target[key] == nil then
                target[key] = {}
            end

            if type(target[key]) == "table" then
                applyDefaults(target[key], value)
            end
        else
            if target[key] == nil then
                target[key] = value
            end
        end
    end
    return target
end

ShopUI = {
    Builder = {},
    Events = {},
    Prompts = {},
    PriceDetails = {},
    Scene = {},
    Virtuals = {},
}

ShopUI.bindings = {
    dscEffects = 0,
    dscInfoBox = 0,
    dscItemListEntries = 0,
    dscMain = 0,
    dscPaletteItemListEntries = 0,
    dscPriceDetails = 0,
    dscPrompts = 0,
    dscScene = 0,
    dscSceneBusiness = 0,
    dscSceneItemDescription = 0,
    dscSceneItemInfo1 = 0,
    dscSceneItemInfo2 = 0,
    dscSceneItemWeather = 0,
    dscSceneOutfitWeather = 0,
    dshSubheader = 0,
    dshTitle = 0,
    dsiCurrentPageIndex = 0,
    dsuItemList = 0,
    dsuItemRecipeImageList = 0,
    dsuItemRecipeTextList = 0,
    dsuPaletteItemList = 0,
    dsuSceneSaddleStats = 0,
    dsuSceneStirrupStats = 0,
}

ShopUI.state = {
    suppressFocusEvent = false,
    suppressUnfocusEvent = false,
    currentItemEntriesByIndex = {},
    currentItemIndecesById = {},
    disabledOverrides = {},
    footerMenuOverrides = {},
    footerItemOverrides = {},
}

function ShopUI.Initialize()
    local main = DatabindingAddDataContainerFromPath("", "GenericShop")

    -- Main
    ShopUI.bindings.dshTitle = DatabindingAddDataHash(main, "Title", 0)
    DatabindingAddDataInt(main, "DefaultCategoryIndex", 0)
    DatabindingAddDataInt(main, "CategoryCount", 1)
    DatabindingAddDataInt(main, "ItemListEntryIndex", 0)
    DatabindingAddDataBool(main, "ShavingSplitterVisible", false) -- Probably unused
    ShopUI.bindings.dsiCurrentPageIndex = DatabindingAddDataInt(main, "PageFilterCurrentPageIndex", 0)
    ShopUI.bindings.dshSubheader = DatabindingAddDataHash(main, "PageFilterCurrentPageLabel", 0)
    ShopUI.bindings.dsuItemList = DatabindingAddUiItemList(main, "ItemList")
    ShopUI.bindings.dscItemListEntries = DatabindingAddDataContainer(main, "ItemListEntries")

    -- Palettes
    DatabindingAddDataBool(main, "uiPaletteVisible", false)
    DatabindingAddDataHash(main, "ItemPaletteItemName", -1)
    DatabindingAddDataInt(main, "currentPaletteIndex", 0)
    DatabindingAddDataInt(main, "paletteItemCount", 0)
    ShopUI.bindings.dsuPaletteItemList = DatabindingAddUiItemList(main, "ItemPaletteList")
    ShopUI.bindings.dscPaletteItemListEntries = DatabindingAddDataContainer(main, "PaletteItemListEntries")

    -- Prompts
    ShopUI.bindings.dscPrompts = DatabindingAddDataContainer(main, "Prompts")

    -- Scene bindings in main
    ShopUI.bindings.dscEffects = DatabindingAddDataContainer(main, "Effects")
    ShopUI.bindings.dsuItemRecipeImageList = DatabindingAddUiItemList(main, "ItemRecipeImageList")
    ShopUI.bindings.dsuItemRecipeTextList = DatabindingAddUiItemList(main, "ItemRecipeTextList")

    -- Scene bindings in scene
    local scene = DatabindingAddDataContainer(main, "Scene")
    ShopUI.bindings.dscSceneItemDescription = DatabindingAddDataContainer(scene, "ItemDescription")
    ShopUI.bindings.dscSceneItemInfo1 = DatabindingAddDataContainer(scene, "ItemInfo1")
    ShopUI.bindings.dscSceneItemInfo2 = DatabindingAddDataContainer(scene, "ItemInfo2")
    ShopUI.bindings.dscSceneItemWeather = DatabindingAddDataContainer(scene, "ItemWeather")
    ShopUI.bindings.dscSceneOutfitWeather = DatabindingAddDataContainer(scene, "OutfitWeather")
    ShopUI.bindings.dscPriceDetails = DatabindingAddDataContainer(scene, "price_details")
    ShopUI.bindings.dsuSceneSaddleStats = DatabindingAddUiItemList(scene, "SaddleStats")
    ShopUI.bindings.dsuSceneStirrupStats = DatabindingAddUiItemList(scene, "StirrupStats")
    DatabindingAddDataBool(scene, "SliderLeftArrowEnabled", false)
    DatabindingAddDataBool(scene, "SliderRightArrowEnabled", false)

    -- Business bindings in scene
    local sceneBusiness = DatabindingAddDataContainer(scene, "Business")
    ShopUI.bindings.dscSceneBusinessPrice = DatabindingAddDataContainer(sceneBusiness, "Price")

    -- Info box
    ShopUI.bindings.dscInfoBox = DatabindingAddDataContainerFromPath("", "InfoBox")
    DatabindingAddDataBool(main, "InfoBoxVisible", true)
    DatabindingAddDataHash(main, "InfoBoxName", 0)

    -- Write locals to bindings
    ShopUI.bindings.dscMain = main
    ShopUI.bindings.dscScene = scene
    ShopUI.bindings.dscSceneBusiness = sceneBusiness
end

function ShopUI.CreateTextEntry(type, id, text, alwaysCreate)
    local key = string.format(
        "%s_%s_%s",
        ShopNavigator:getRootMenuId() or "NSUI",
        tostring(type):upper(),
        tostring(id):upper()
    )

    if DoesTextLabelExist(key) ~= 1 or alwaysCreate then
        AddTextEntry(key, text)
    end

    return key
end

function ShopUI.CreateSwatchForItem(item, index)
    if item.Type ~= "SWATCH" then return item end

    if type(item.Auto) ~= "string" and item.Auto ~= true then
        return item
    end

    local itemKey = type(item.Auto) == "string" and item.Auto or item.Id
    local itemData = ItemDatabase.new(itemKey)
    if not itemData then
        error(string.format("Invalid item ID %s", itemKey))
    end

    if index < 0 then index = 39 end
    if index >= 39 then index = 0 end

    local swatchTxd, swatchTxn = itemData:GetSwatchTexture(index)

    return applyDefaults(item, {
        Data = {
            TextureDictionary = swatchTxd,
            Texture = swatchTxn,
        }
    })
end

function ShopUI.ProcessAutoItem(item)
    if type(item.Auto) ~= "string" and item.Auto ~= true then
        return item
    end

    local itemKey = type(item.Auto) == "string" and item.Auto or item.Id
    local itemData = ItemDatabase.new(itemKey)
    if not itemData then
        error(string.format("Invalid item ID %s", itemKey))
    end

    local defaults = {
        Data = {
            RpgEffects = nil,
            Weather = nil
        }
    }

    if itemData:GetLabelHash(true) ~= 0 then
        defaults.Label = itemData:GetLabel(true)
    end

    if itemData:GetDescriptionHash(true) ~= 0 then
        defaults.Data.ItemDescription = itemData:GetDescription(true)
    end

    defaults.Data.RpgEffects = itemData:GetUiRpgStats()

    if not itemData:IsOutfit() and itemData:GetWarmth() then
        defaults.Data.Weather = {
            Visible = true,
            Enabled = true,
            Opacity = 1,
            Warmth = itemData:GetWarmth(),
        }
    end

    return applyDefaults(item, defaults)
end

function ShopUI.UpdateTitle()
    local entry = ShopNavigator:getCurrentTitleEntry()
    local hash = ""

    if entry and entry.Text then
        hash = ShopUI.CreateTextEntry(entry.Type, entry.Id, entry.Text, entry.Dynamic)
    end

    if DatabindingIsEntryValid(ShopUI.bindings.dshTitle) == 1 then
        DatabindingWriteDataHashString(ShopUI.bindings.dshTitle, hash)
    else
        ShopUI.bindings.dshTitle = DatabindingAddDataHash(ShopUI.bindings.dscMain, "Title", hash)
    end
end

function ShopUI.UpdateSubheader()
    local entry = ShopNavigator:getCurrentSubtitleEntry()
    local hash = ""

    if entry and entry.Text then
        hash = ShopUI.CreateTextEntry(entry.Type, entry.Id, entry.Text, entry.Dynamic)
    end

    if DatabindingIsEntryValid(ShopUI.bindings.dshSubheader) == 1 then
        DatabindingWriteDataHashString(ShopUI.bindings.dshSubheader, hash)
    else
        ShopUI.bindings.dshSubheader = DatabindingAddDataHash(ShopUI.bindings.dscMain, "PageFilterCurrentPageLabel", hash)
    end
end

function ShopUI.CreateItemListBinding()
    if DatabindingIsEntryValid(ShopUI.bindings.dsuItemList) ~= 1 then
        ShopUI.bindings.dsuItemList = DatabindingAddUiItemList(ShopUI.bindings.dscMain, "ItemList")
    else
        DatabindingClearBindingArray(ShopUI.bindings.dsuItemList)
    end

    if DatabindingIsEntryValid(ShopUI.bindings.dscItemListEntries) == 1 then
        DatabindingRemoveDataEntry(ShopUI.bindings.dscItemListEntries)
    end

    ShopUI.bindings.dscItemListEntries = DatabindingAddDataContainer(ShopUI.bindings.dscMain, "ItemListEntries")
end

function ShopUI.CreatePaletteItemListBinding()
    if DatabindingIsEntryValid(ShopUI.bindings.dsuPaletteItemList) ~= 1 then
        ShopUI.bindings.dsuPaletteItemList = DatabindingAddUiItemList(ShopUI.bindings.dscMain, "ItemPaletteList")
    else
        DatabindingClearBindingArray(ShopUI.bindings.dsuPaletteItemList)
    end

    if DatabindingIsEntryValid(ShopUI.bindings.dscPaletteItemListEntries) == 1 then
        DatabindingRemoveDataEntry(ShopUI.bindings.dscPaletteItemListEntries)
    end

    ShopUI.bindings.dscPaletteItemListEntries = DatabindingAddDataContainer(ShopUI.bindings.dscMain, "ItemPaletteEntries")
end

function ShopUI.CreateRecipeItemListBinding()
    if DatabindingIsEntryValid(ShopUI.bindings.dsuItemRecipeTextList) ~= 1 then
        ShopUI.bindings.dsuItemRecipeTextList = DatabindingAddUiItemList(ShopUI.bindings.dscMain, "ItemRecipeTextList")
    else
        DatabindingClearBindingArray(ShopUI.bindings.dsuItemRecipeTextList)
    end

    if DatabindingIsEntryValid(ShopUI.bindings.dsuItemRecipeImageList) ~= 1 then
        ShopUI.bindings.dsuItemRecipeImageList = DatabindingAddUiItemList(ShopUI.bindings.dscMain, "ItemRecipeImageList")
    else
        DatabindingClearBindingArray(ShopUI.bindings.dsuItemRecipeImageList)
    end
end

function ShopUI.CreateSaddleStatListBinding()
    if DatabindingIsEntryValid(ShopUI.bindings.dsuSceneSaddleStats) ~= 1 then
        ShopUI.bindings.dsuSceneSaddleStats = DatabindingAddUiItemList(ShopUI.bindings.dscScene, "SaddleStats")
    else
        DatabindingClearBindingArray(ShopUI.bindings.dsuSceneSaddleStats)
    end
end

function ShopUI.CreateStirrupStatListBinding()
    if DatabindingIsEntryValid(ShopUI.bindings.dsuSceneStirrupStats) ~= 1 then
        ShopUI.bindings.dsuSceneStirrupStats = DatabindingAddUiItemList(ShopUI.bindings.dscScene, "StirrupStats")
    else
        DatabindingClearBindingArray(ShopUI.bindings.dsuSceneStirrupStats)
    end
end

function ShopUI.ResetScene()
    ShopUI.Prompts.ClearAllPrompts()
    ShopUI.Scene.FullClear()
end

function ShopUI.SetIndex(index)
    local collectionId = ShopEvents.state.collectionId

    if VirtualCollectionExists(collectionId) then
        VirtualCollectionSetInterestIndex(collectionId, index)
    else
        print("[NativeShop] Collection does not exist: " .. tostring(collectionId))
    end

    DatabindingAddDataInt(ShopUI.bindings.dscMain, "ItemListEntryIndex", index)
end

function ShopUI.EnterScene(type)
    return RequestUiappTransitionByHash("shop_menu", type)
end

function ShopUI.NextScene()
    return RequestUiappTransitionByHash("shop_menu", "next_scene")
end

function ShopUI.PrevScene()
    return RequestUiappTransitionByHash("shop_menu", "prev_scene")
end

function ShopUI.Open(id)
    if IsUiappRunning("shop_menu") == 1 then
        print("[NativeShop] UI is already open. Please close the current menu before opening a new one.")
        return
    end

    ShopData.state.shuttingDown = false

    if ShopData.state.hiddenMenu == id then
        local result = ShopNavigator:restore()
        if not result then
            print("[NativeShop] Failed to restore menu: " .. tostring(id))
            return
        end

        TriggerEvent("native_shop:showing", id)
    else
        local result = ShopNavigator:open(id)
        if not result then
            print("[NativeShop] Failed to open menu: " .. tostring(id))
            return
        end

        TriggerEvent("native_shop:opening", id)
    end

    ShopData.state.hiddenMenu = nil
    ShopUI.OnOpen()
end

function ShopUI.OnOpen()
    local swatchLoaded = false
    while swatchLoaded ~= 1 do
        swatchLoaded = CreateSwatchTextureDict(40)
        Wait(0)
    end

    local TEXT_BLOCKS <const> = {
        "shop",
        "satch",
        "ward",
    }

    for _, block in pairs(TEXT_BLOCKS) do
        TextBlockRequest(block)
        while TextBlockIsLoaded(block) ~= 1 do
            Wait(0)
        end
    end

    local TEXTURE_DICTS <const> = {
        "swatches_gunsmith_mp",
        "swatches_stable_mp",
    }

    for _, dict in pairs(TEXTURE_DICTS) do
        RequestStreamedTxd(dict, false)
        while HasStreamedTxdLoaded(dict) ~= 1 do
            Wait(0)
        end
    end

    LaunchUiappWithEntry("shop_menu", "generic_shop")

    CreateThread(function()
        -- Only hook into the always-running event handler while the UI is open
        while IsUiappRunning("shop_menu") == 1 do
            Wait(0)

            local success, error = pcall(ShopData.MaintainEvents)

            -- If something went wrong, close the UI to prevent the user from getting stuck
            if not success then
                print("[NativeShop] An error occurred while processing shop events: ")
                print("  " .. tostring(error))

                CloseUiappImmediate("shop_menu")
            end
        end
    end)
end

function ShopUI.Hide()
    ShopData.state.hiddenMenu = ShopNavigator:getInitialRootId()
    ShopData.state.entryFocusIndex = ShopEvents.state.focusedIndex + 1

    TriggerEvent("native_shop:hiding", ShopNavigator:getCurrentMenuId())
    ShopUI.OnShutdown()
end

function ShopUI.Exit()
    ShopData.state.hiddenMenu = nil
    ShopData.state.entryFocusIndex = 1

    TriggerEvent("native_shop:closing", ShopNavigator:getCurrentMenuId())
    ShopUI.OnShutdown()
end

function ShopUI.OnShutdown()
    local rootMenu = ShopNavigator:getRootMenu()
    if not rootMenu then return end

    -- Stop running maintain tasks
    ShopData.state.shuttingDown = true

    -- Reset control context if walking is allowed
    if rootMenu.AllowWalking then
        SetControlContext(9, 0)
        SetControlContext(10, 0)
    end

    -- Get rid of the orbit camera if it was used
    if rootMenu.RepositionCamera then
        local struct = DataView.ArrayBuffer(128)
        struct:SetString(0, "mp@spinning_orbit_cam")
        struct:SetString(64, "SPINNING_ORBIT_REQUEST")

        if IsCameraAvailable(struct:Buffer()) == 1 then
            CamDestroy(struct:Buffer())
        end

        if IsCamDataDictLoaded("spinning_orbit_cam") == 1 then
            UnloadCameraDataDict("spinning_orbit_cam")
        end
    end

    -- Get rid of menu state only if we are not hiding the menu
    if not ShopData.state.hiddenMenu then
        ShopNavigator:close()
    end

    -- Close the UI app
    CloseUiapp("shop_menu")

    -- Refresh the menu on the next open
    ShopData.state.rootMenuId = nil
    ShopData.state.currentMenuId = nil

    -- Clear the swatch texture dictionary
    DestroySwatchTextureDict()
end

function ShopUI.DisableItem(id)
    ShopUI.state.disabledOverrides[id] = true
    ShopUI.UpdateItemState(id)
end

function ShopUI.EnableItem(id)
    ShopUI.state.disabledOverrides[id] = nil
    ShopUI.UpdateItemState(id)
end

function ShopUI.UpdateItemState(id)
    if IsUiappTransitioningByHash("shop_menu") == 1 then return end

    local currentItem = ShopNavigator:getItemById(id)
    if not currentItem then return end

    local currentMenu = ShopNavigator:getCurrentMenu()
    if not currentMenu then return end

    if currentItem.MenuId ~= currentMenu.Id then return end
    ShopUI.RefreshMenu(currentItem.MenuId)
end

function ShopUI.RefreshMenu(id)
    if IsUiappTransitioningByHash("shop_menu") == 1 then return end

    local currentMenu = ShopNavigator:getCurrentMenu()
    if not currentMenu then return end

    -- Exit if the current menu does not match the requested menu
    if id and currentMenu.Id ~= id then return end

    -- Makes the navigator aware we should refresh the current items
    ShopNavigator:refreshCurrentPage()

    -- Rebuilds all menu entries that currently are added to the menu
    ShopUI.RefreshAllItems()

    -- Refocuses the current item to update the scene UI
    ShopUI.state.suppressUnfocusEvent = true
    ShopEvents.SetEventFlag(ShopEvents.FLAG_UNFOCUSED)

    ShopUI.state.suppressFocusEvent = true
    ShopEvents.SetEventFlag(ShopEvents.FLAG_FOCUSED)

    -- Trigger a state changed event so we can update the scene UI
    ShopEvents.SetEventFlag(ShopEvents.FLAG_STATE_CHANGED)
end

function ShopUI.RefreshRoot(root)
    if IsUiappTransitioningByHash("shop_menu") == 1 then return end

    ShopNavigator:refreshRoot(root)
    ShopUI.RefreshMenu(root)
end

function ShopUI.RefreshData(root, source)
    if IsUiappTransitioningByHash("shop_menu") == 1 then return end

    ShopNavigator:refreshDataSource(root, source)
    ShopUI.RefreshMenu(root)
end

function ShopUI.RefreshAllItems()
    if IsUiappTransitioningByHash("shop_menu") == 1 then return end

    local currentItems = ShopNavigator:getCurrentItems()

    for index = 1, #currentItems do
        ShopUI.RefreshItem(index)
    end
end

function ShopUI.RefreshItem(idOrIndex)
    local entry, index = nil, nil
    if type(idOrIndex) == "string" then
        local entryIndex = ShopUI.state.currentItemIndecesById[idOrIndex]
        if not entryIndex then return end

        entry = ShopUI.state.currentItemEntriesByIndex[entryIndex]
        index = entryIndex
    else
        entry = ShopUI.state.currentItemEntriesByIndex[idOrIndex]
        index = idOrIndex
    end

    if not entry or DatabindingIsEntryValid(entry) ~= 1 then return end

    local item = ShopNavigator:getItemByIndex(index)
    if not item then return end

    local itemType = item.Type or "TEXT"
    local entryType = ShopEvents.GetItemType(entry)
    if itemType ~= entryType then
        local collectionId = ShopEvents.state.collectionId
        if VirtualCollectionExists(collectionId) then
            ShopData.state.entryFocusIndex = index
            VirtualCollectionReset(collectionId)
        else
            print("[NativeShop] Collection does not exist: " .. tostring(collectionId))
        end
        return
    end

    local result = ShopUI.Builder.FillItem(entry, item)
    if result == false then
        print("[NativeShop] Error: Failed to refresh item: " .. tostring(item.Id))
    end
end

function ShopUI.SetFooterOverride(menu, item, footer)
    if not menu and not item then
        print("[NativeShop] Please specify at least a menu or item to set a footer override for.")
        return
    end

    if item then
        ShopUI.state.footerItemOverrides[item] = footer
    elseif menu then
        ShopUI.state.footerMenuOverrides[menu] = footer
    end

    local currentMenu = ShopNavigator:getCurrentMenu()
    if not currentMenu then return end
    if menu ~= "_ALL" and currentMenu.Id ~= menu then return end

    local currentItem = ShopNavigator:getItemById(item)
    if not currentItem then return end
    if item ~= "_ALL" and currentItem.Id ~= item then return end

    if not currentItem.MenuId then return end
    ShopUI.RefreshMenu(currentItem.MenuId)
end

function ShopUI.ClearFooterOverride(menu, item)
    if not menu and not item then
        print("[NativeShop] Please specify at least a menu or item to clear a footer override for.")
        return
    end

    if item then
        ShopUI.state.footerItemOverrides[item] = nil
    elseif menu then
        ShopUI.state.footerMenuOverrides[menu] = nil
    end

    local currentMenu = ShopNavigator:getCurrentMenu()
    if not currentMenu then return end
    if menu ~= "_ALL" and currentMenu.Id ~= menu then return end

    local currentItem = ShopNavigator:getItemById(item)
    if not currentItem then return end
    if item ~= "_ALL" and currentItem.Id ~= item then return end

    if not currentItem.MenuId then return end
    ShopUI.RefreshMenu(currentItem.MenuId)
end

function ShopUI.IsSceneTypeValid(type)
    for _, validType in pairs(validSceneTypes) do
        if validType == type then
            return true
        end
    end

    return false
end

function ShopUI.IsItemTypeValid(type)
    for _, validType in pairs(validItemTypes) do
        if validType == type then
            return true
        end
    end

    return false
end

function ShopUI.IsItemDisabled(item)
    local overriden = ShopUI.state.disabledOverrides[item.Id] or false
    return overriden or item.Disabled == true
end

function ShopUI.GetItemValue(item)
    local data = item.Data or {}
    if data.SliderInfo and data.SliderInfo.Value then
        return data.SliderInfo.Value
    elseif data.Palette and data.Palette.Value then
        return data.Palette.Value
    elseif data.StepperValue then
        return data.StepperValue
    end
    return nil
end

function ShopUI.Events.HandleItemSelect(event, eventParameter)
    local EVENT_MAP <const> = {
        GENERIC_SHOP_UI_SELECT           = { key = "select", prompt = "Select" },
        GENERIC_SHOP_UI_SECONDARY_SELECT = { key = "select", prompt = "Select" },
        GENERIC_SHOP_UI_EXIT             = { key = "back", prompt = "Back" },
        GENERIC_SHOP_UI_SELECT_OPTION    = { key = "option", prompt = "Option" },
        GENERIC_SHOP_UI_SELECT_TOGGLE    = { key = "toggle", prompt = "Toggle" },
        GENERIC_SHOP_UI_SELECT_INFO      = { key = "info", prompt = "Info" },
        GENERIC_SHOP_UI_SELECT_MODIFY    = { key = "modify", prompt = "Modify" },
        DATA_ADJUSTABLE_CHANGED          = { key = "adjust", prompt = "Adjust" },
    }

    local config = EVENT_MAP[event]
    if not config then return end

    local index = ShopEvents.state.selectedIndex + 1
    local item = ShopNavigator:getItemByIndex(index)
    if not item then return end

    local itemType = ShopEvents.GetSelectedItemType()
    local itemTarget = ShopEvents.GetSelectedTargetMenu()
    local actionKey = config.key
    local isSubMenuNav = (actionKey == "select" and itemTarget > 0)

    if actionKey == "select" and isSubMenuNav then
        TriggerEvent("native_shop:menu_selected", {
            ID = item.Id, Type = itemType, Index = index, Item = item
        })
    elseif actionKey == "select" then
        TriggerEvent("native_shop:item_selected", {
            ID = item.Id, Type = itemType, Index = index, Item = item
        })
    end

    TriggerEvent("native_shop:item_action", {
        ID = item.Id,
        Type = itemType,
        Index = index,
        Item = item,
        Action = actionKey,
        ActionParameter = eventParameter,
    })

    local function applyNavigation(targetIndex)
        if type(targetIndex) == "number" and targetIndex > 0 then
            ShopUI.NextScene()
            ShopData.state.entryFocusIndex = targetIndex
        end
    end

    if isSubMenuNav then
        local result = ShopNavigator:navigateInto(itemTarget)
        if type(result) ~= "number" or result <= 0 then
            print("[NativeShop] Failed to navigate into menu: " .. tostring(itemTarget))
            return
        end

        applyNavigation(result)
        return
    end

    local prompts = item.Prompts or {}
    local promptData = prompts[config.prompt] or {}

    local action = promptData.Action
    if config.prompt == "Select" and not action then
        action = item.Action
    end

    if not action then return end
    local actionResult = nil

    if action == "CLOSE" then
        ShopUI.Exit()
        return
    elseif action == "HIDE" then
        ShopUI.Hide()
        return
    elseif action == "BACK" then
        actionResult = ShopNavigator:navigateBack() or 1
    elseif action == "ROOT" then
        actionResult = ShopNavigator:navigateRoot() or 1
    elseif type(action) == "function" then
        local value = ShopUI.GetItemValue(item) or eventParameter
        local ok, result = pcall(action, item, value, actionKey)
        if not ok then
            print(string.format("[NativeShop] Error executing action for item %s: %s", tostring(item.Id), tostring(result)))
            return
        end
        actionResult = result
    else
        print("[NativeShop] Item '" .. tostring(item.Id) .. "' has an invalid Action type.")
        return
    end

    applyNavigation(actionResult)
end

function ShopUI.Events.HandleItemFocus()
    local type = ShopEvents.GetFocusedItemType()
    local index = ShopEvents.state.focusedIndex + 1
    local item = ShopNavigator:getItemByIndex(index)
    if not item then return end

    ShopUI.Prompts.ClearAllPrompts()
    ShopUI.Scene.FullClear()
    ShopUI.Prompts.UpdateBackPrompt()

    ShopUI.Scene.SetFooterFromItem(item)
    ShopUI.Prompts.UpdatePromptsFromItem(item)
    ShopUI.Events.HandleItemSceneFocus(item)

    if not ShopUI.state.suppressFocusEvent then
        TriggerEvent("native_shop:item_focused", {
            ID = item.Id,
            Type = type,
            Index = index,
            Item = item,
        })
    else
        ShopUI.state.suppressFocusEvent = false
    end
end

function ShopUI.Events.HandleItemSceneFocus(item)
    if not item then return false end

    local rootMenu = ShopNavigator:getRootMenu()
    local currentMenu = ShopNavigator:getCurrentMenu()
    if not rootMenu or not currentMenu then return false end

    local scene = currentMenu.Scene or rootMenu.Scene or "MENU_LIST"
    if not scene then return false end

    local callbacks = {
        BOUNTY_MANAGEMENT = ShopUI.Events.HandleBountyManagementFocus,
        CLOTHING_MODIFY = ShopUI.Events.HandleClothingModifyFocus,
        CLOTHING_STAT_INFO_BOX = ShopUI.Events.HandleClothingItemInfoBoxFocus,
        HORSE_MANAGEMENT = ShopUI.Events.HandleHorseManagementFocus,
        HORSE_STAT_INFO_BOX = ShopUI.Events.HandleHorseStatInfoBoxFocus,
        ITEM_GRID = ShopUI.Events.HandleItemGridFocus,
        ITEM_LIST = ShopUI.Events.HandleItemListFocus,
        ITEM_LIST_COLOUR_PALETTE = ShopUI.Events.HandleItemListColourPaletteFocus,
        ITEM_LIST_DESCRIPTION = ShopUI.Events.HandleItemListDescriptionFocus,
        ITEM_LIST_HORSE_STATS = ShopUI.Events.HandleItemListHorseStatsFocus,
        ITEM_LIST_RECIPES = ShopUI.Events.HandleItemListRecipesFocus,
        ITEM_LIST_RPG_STATS = ShopUI.Events.HandleItemListRpgStatsFocus,
        ITEM_LIST_SLIDER = ShopUI.Events.HandleItemListSliderFocus,
        ITEM_LIST_TEXTURE_DESCRIPTION = ShopUI.Events.HandleItemListTextureDescriptionFocus,
        ITEM_LIST_VEHICLE_STATS = ShopUI.Events.HandleItemListVehicleStatsFocus,
        ITEM_LIST_WEAPON_STATS = ShopUI.Events.HandleItemListWeaponStatsFocus,
        ITEM_SELL_LIST_HORSE_STATS = ShopUI.Events.HandleItemSellListHorseStatsFocus,
        MENU_LIST = ShopUI.Events.HandleMenuListFocus,
        MENU_LIST_HORSE_STATS = ShopUI.Events.HandleMenuListHorseStatsFocus,
        MENU_LIST_WEAPON_STATS = ShopUI.Events.HandleMenuListWeaponStatsFocus,
        MENU_STYLE_SELECTOR = ShopUI.Events.HandleMenuStyleSelectorFocus,
        SADDLE_MANAGEMENT = ShopUI.Events.HandleSaddleManagementFocus,
        VEHICLE_MANAGEMENT = ShopUI.Events.HandleVehicleManagementFocus,
        WEAPON_MANAGEMENT = ShopUI.Events.HandleWeaponManagementFocus,
    }

    local callback = callbacks[scene]
    if callback then return callback(item) end

    return true
end

function ShopUI.Events.HandleBountyManagementFocus(item)
    ShopUI.Scene.SetItemDescriptionFromItem(item)
end

function ShopUI.Events.HandleClothingModifyFocus(item)
    local showSceneFooter = false

    if ShopUI.Scene.SetItemDescriptionFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo1FromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetOutfitWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo2FromItem(item) then
        showSceneFooter = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
end

function ShopUI.Events.HandleClothingItemInfoBoxFocus(item)
    ShopUI.Scene.SetInfoBoxNameFromItem(item)
    ShopUI.Scene.SetOutfitWeatherFromItem(item)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleHorseManagementFocus(item)
    local showSceneFooter = false
    local showSceneStats = false

    if ShopUI.Scene.SetHorseStatsFromItem(item) then
        showSceneFooter = true
        showSceneStats = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetStatsVisible(showSceneStats)
end

function ShopUI.Events.HandleHorseStatInfoBoxFocus(item)
    local showSceneStats = false

    if ShopUI.Scene.SetHorseStatsFromItem(item) then
        showSceneStats = true
    end

    ShopUI.Scene.SetStatsVisible(showSceneStats)
    ShopUI.Scene.SetInfoBoxNameFromItem(item)
    ShopUI.Scene.SetHorseInfoBoxFromItem(item)
    ShopUI.Scene.SetHorseStatsFromItem(item)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleItemGridFocus(item)
    local showSceneFooter = false
    local itemPriceVisible = false

    if ShopUI.Scene.SetItemDescriptionFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo1FromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetOutfitWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo2FromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetPriceDetailsFromItem(item) then
        itemPriceVisible = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetItemPriceFooterVisible(itemPriceVisible)
end

function ShopUI.Events.HandleItemListFocus(item)
    local showSceneFooter = false

    if ShopUI.Scene.SetSaddleStatsFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetStirrupStatsFromItem(item) then
        showSceneFooter = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleItemListColourPaletteFocus(item)
    local showSceneFooter = false
    local showPalette = false

    if ShopUI.Scene.SetSaddleStatsFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetStirrupStatsFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetPaletteFromItem(item) then
        showPalette = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetPaletteVisible(showPalette)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleItemListDescriptionFocus(item)
    local showSceneFooter = false

    if ShopUI.Scene.SetItemDescriptionFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo1FromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetOutfitWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo2FromItem(item) then
        showSceneFooter = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleItemListHorseStatsFocus(item)
    local showSceneFooter = false
    local showSceneStats = false

    if ShopUI.Scene.SetHorseStatsFromItem(item) then
        showSceneFooter = true
        showSceneStats = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetStatsVisible(showSceneStats)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleItemListRecipesFocus(item)
    local showSceneFooter = false

    if ShopUI.Scene.SetItemDescriptionFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo1FromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetOutfitWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo2FromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetRecipeFooterFromItem(item) then
        showSceneFooter = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
end

function ShopUI.Events.HandleItemListRpgStatsFocus(item)
    local showSceneFooter = false

    if ShopUI.Scene.SetItemDescriptionFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo1FromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetOutfitWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo2FromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetRpgEffectsFromItem(item) then
        showSceneFooter = false
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleItemListSliderFocus(item)
    ShopUI.Scene.SetSliderInfoFromItem(item)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleItemListTextureDescriptionFocus(item)
    local showSceneFooter = false

    if ShopUI.Scene.SetItemDescriptionFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo1FromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetOutfitWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo2FromItem(item) then
        showSceneFooter = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
end

function ShopUI.Events.HandleItemListVehicleStatsFocus(item)
    local showSceneFooter = false
    local showSceneStats = false

    if ShopUI.Scene.SetVehicleStatsFromItem(item) then
        showSceneFooter = true
        showSceneStats = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetStatsVisible(showSceneStats)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleItemListWeaponStatsFocus(item)
    local showSceneFooter = false
    local showSceneStats = false

    if ShopUI.Scene.SetItemDescriptionFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo1FromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetOutfitWeatherFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetItemInfo2FromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetWeaponStatsFromItem(item) then
        showSceneStats = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetWeaponStatsVisible(showSceneStats)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleItemSellListHorseStatsFocus(item)
    local showSceneFooter = false
    local showSceneStats = false

    if ShopUI.Scene.SetHorseStatsFromItem(item) then
        showSceneFooter = true
        showSceneStats = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetStatsVisible(showSceneStats)

    if ShopUI.Scene.SetPriceDetailsFromItem(item) and showSceneStats then
        print("[NativeShop] Warning: While supported, enabling pricing on sell list horse stats may cause graphical issues.")
    end
end

function ShopUI.Events.HandleMenuListFocus(item)
    local showSceneFooter = false

    if ShopUI.Scene.SetItemDescriptionFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetBusinessInfoFromItem(item) then
        showSceneFooter = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
end

function ShopUI.Events.HandleMenuListHorseStatsFocus(item)
    local showSceneFooter = false
    local showSceneStats = false

    if ShopUI.Scene.SetHorseStatsFromItem(item) then
        showSceneFooter = true
        showSceneStats = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetStatsVisible(showSceneStats)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleMenuListWeaponStatsFocus(item)
    ShopUI.Scene.SetWeaponStatsFromItem(item)
end

function ShopUI.Events.HandleMenuStyleSelectorFocus(item)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleSaddleManagementFocus(item)
    local showSceneFooter = false

    if ShopUI.Scene.SetItemInfo2FromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetSaddleStatsFromItem(item) then
        showSceneFooter = true
    end

    if ShopUI.Scene.SetStirrupStatsFromItem(item) then
        showSceneFooter = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleVehicleManagementFocus(item)
    local showSceneFooter = false
    local showSceneStats = false

    if ShopUI.Scene.SetVehicleStatsFromItem(item) then
        showSceneFooter = true
        showSceneStats = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
    ShopUI.Scene.SetStatsVisible(showSceneStats)
    ShopUI.Scene.SetPriceDetailsFromItem(item)
end

function ShopUI.Events.HandleWeaponManagementFocus(item)
    local showSceneFooter = false

    if ShopUI.Scene.SetWeaponStatsFromItem(item) then
        showSceneFooter = true
    end

    ShopUI.Scene.SetSceneFooterVisible(showSceneFooter)
end

function ShopUI.Events.HandleItemUnfocus()
    local type = ShopEvents.GetUnfocusedItemType()
    local index = ShopEvents.state.unfocusedIndex + 1
    local item = ShopNavigator:getItemByIndex(index)
    if not item then return true end

    if not ShopUI.state.suppressUnfocusEvent then
        TriggerEvent("native_shop:item_unfocused", {
            ID = item.Id,
            Type = type,
            Index = index,
            Item = item,
        })
    else
        ShopUI.state.suppressUnfocusEvent = false
    end

    return true
end

function ShopUI.Events.HandleStepperChange()
    local datastore = ShopEvents.state.focusedDatastore
    if not datastore then return true end

    local focusIndex = ShopEvents.state.focusedIndex + 1
    local item = ShopNavigator:getItemByIndex(focusIndex)
    if not item then return true end

    local id = item.Id
    local data = item.Data or {}
    if not id then return true end

    local main = ShopUI.bindings.dscMain
    local scene = ShopUI.bindings.dscScene
    local change = ShopEvents.state.adjustableIndex

    if DatabindingReadDataBoolFromParent(scene, "SliderVisible") == 1 then
        local index = DatabindingReadDataIntFromParent(scene, "SliderCurrent")
        local max = DatabindingReadDataIntFromParent(scene, "SliderInputMax")

        -- Calculate the new index
        index = (index + change)

        -- Clamp the index within bounds
        if (index > max) then
            index = max
        elseif (index < 1) then
            index = 1
        end

        -- Update the item's value
        if type(data.SliderInfo) == "table" and type(data.SliderInfo.Value) == "number" then
            data.SliderInfo.Value = index
        else
            print("[NativeShop] Warning: Could not update palette value for: " .. tostring(id))
        end

        -- Update the data value
        DatabindingWriteDataIntFromParent(scene, "SliderCurrent", index)
        DatabindingWriteDataBoolFromParent(scene, "SliderLeftArrowEnabled", index > 1)
        DatabindingWriteDataBoolFromParent(scene, "SliderRightArrowEnabled", index < max)

        -- Refresh the item in case it depends on the value
        ShopUI.RefreshItem(id)

        -- Notify listeners about the change
        TriggerEvent("native_shop:adjustable_changed", {
            ID = id,
            Index = focusIndex,
            Item = item,
            Value = index,
            Type = "SLIDER",
        })
    elseif DatabindingReadDataBoolFromParent(main, "uiPaletteVisible") == 1 then
        local index = DatabindingReadDataIntFromParent(main, "currentPaletteIndex")
        local max = DatabindingReadDataIntFromParent(main, "paletteItemCount")

        -- Calculate the new index
        index = (index + change)

        -- Clamp the index within bounds
        if (index >= max) then
            index = 0
        elseif (index < 0) then
            index = (max - 1)
        end

        -- Update the item's value
        if type(data.Palette) == "table" and type(data.Palette.Value) == "number" then
            data.Palette.Value = index + 1
        else
            print("[NativeShop] Warning: Could not update palette value for: " .. tostring(id))
        end

        -- Update the data value
        DatabindingWriteDataIntFromParent(main, "currentPaletteIndex", index)
        DatabindingWriteDataBoolFromParent(scene, "SliderLeftArrowEnabled", index > 1)
        DatabindingWriteDataBoolFromParent(scene, "SliderRightArrowEnabled", index < max)
        DatabindingAddDataHash(main, "ItemPaletteItemName", string.format("NSUI_%s_%s", id, index + 1))

        -- Refresh the item in case it depends on the value
        ShopUI.RefreshItem(id)

        -- Notify listeners about the change
        TriggerEvent("native_shop:adjustable_changed", {
            ID = id,
            Index = focusIndex,
            Item = item,
            Value = index + 1,
            Type = "PALETTE",
        })
    elseif DatabindingReadDataBoolFromParent(datastore, "uiItemStepperVisible") == 1 then
        local index = DatabindingReadDataIntFromParent(datastore, "uiItemStepperValue")
        local max = DatabindingReadDataIntFromParent(datastore, "uiItemStepperMax")

        -- Calculate the new index
        index = (index + change)

        -- Wrap the index within bounds
        if (index >= max) then
            index = 0
        elseif (index < 0) then
            index = (max - 1)
        end

        -- Update the item's value
        if type(data.StepperValue) == "number" then
            data.StepperValue = index + 1
        else
            print("[NativeShop] Warning: Could not update stepper value for: " .. tostring(id))
        end

        -- Refresh the item in case it depends on the value
        ShopUI.RefreshItem(id)

        -- Notify listeners about the change
        TriggerEvent("native_shop:adjustable_changed", {
            ID = id,
            Index = focusIndex,
            Item = item,
            Value = index + 1,
            Type = "STEPPER",
        })
    end

    ShopUI.Events.HandleItemSelect("DATA_ADJUSTABLE_CHANGED", change)

    return true
end

function ShopUI.Builder.BuildScene(scene, menu)
    if not ShopUI.IsSceneTypeValid(scene) then
        print("[NativeShop] Error: Invalid scene type build requested: ", scene)
        return false
    end

    if not menu then
        print("[NativeShop] Error: No menu provided for scene build: ", scene)
        return false
    end

    local callbacks = {
        BOUNTY_MANAGEMENT = ShopUI.Builder.BuildBountyManagementScene,
        CLOTHING_MODIFY = ShopUI.Builder.BuildClothingModifyScene,
        CLOTHING_STAT_INFO_BOX = ShopUI.Builder.BuildClothingItemInfoBoxScene,
        HORSE_MANAGEMENT = ShopUI.Builder.BuildHorseManagementScene,
        HORSE_STAT_INFO_BOX = ShopUI.Builder.BuildHorseStatInfoBoxScene,
        ITEM_GRID = ShopUI.Builder.BuildItemGridScene,
        ITEM_LIST = ShopUI.Builder.BuildItemListScene,
        ITEM_LIST_COLOUR_PALETTE = ShopUI.Builder.BuildItemListColourPaletteScene,
        ITEM_LIST_DESCRIPTION = ShopUI.Builder.BuildItemListDescriptionScene,
        ITEM_LIST_HORSE_STATS = ShopUI.Builder.BuildItemListHorseStatsScene,
        ITEM_LIST_RECIPES = ShopUI.Builder.BuildItemListRecipesScene,
        ITEM_LIST_RPG_STATS = ShopUI.Builder.BuildItemListRpgStatsScene,
        ITEM_LIST_SLIDER = ShopUI.Builder.BuildItemListSliderScene,
        ITEM_LIST_TEXTURE_DESCRIPTION = ShopUI.Builder.BuildItemListTextureDescriptionScene,
        ITEM_LIST_VEHICLE_STATS = ShopUI.Builder.BuildItemListVehicleStatsScene,
        ITEM_LIST_WEAPON_STATS = ShopUI.Builder.BuildItemListWeaponStatsScene,
        ITEM_SELL_LIST_HORSE_STATS = ShopUI.Builder.BuildItemSellListHorseStatsScene,
        MENU_LIST = ShopUI.Builder.BuildMenuListScene,
        MENU_LIST_HORSE_STATS = ShopUI.Builder.BuildMenuListHorseStatsScene,
        MENU_LIST_WEAPON_STATS = ShopUI.Builder.BuildMenuListWeaponStatsScene,
        MENU_STYLE_SELECTOR = ShopUI.Builder.BuildMenuStyleSelectorScene,
        SADDLE_MANAGEMENT = ShopUI.Builder.BuildSaddleManagementScene,
        VEHICLE_MANAGEMENT = ShopUI.Builder.BuildVehicleManagementScene,
        WEAPON_MANAGEMENT = ShopUI.Builder.BuildWeaponManagementScene,
    }

    ShopUI.Prompts.ClearAllPrompts()
    ShopUI.Scene.FullClear()
    ShopUI.Prompts.UpdateBackPrompt()

    ShopUI.UpdateTitle()
    ShopUI.UpdateSubheader()
    ShopUI.Scene.SetFooter()

    local callback = callbacks[scene]
    if callback then return callback(menu) end

    return true
end

function ShopUI.Builder.BuildBountyManagementScene(menu)
    ShopUI.Events.HandleBountyManagementFocus(menu)

    return true
end

function ShopUI.Builder.BuildClothingModifyScene(menu)
    ShopUI.Events.HandleClothingModifyFocus(menu)

    return true
end

function ShopUI.Builder.BuildClothingItemInfoBoxScene(menu)
    ShopUI.Events.HandleClothingItemInfoBoxFocus(menu)

    ShopEvents.SetEventFlag(ShopEvents.FLAG_FOCUSED)
    ShopEvents.SetEventFlag(ShopEvents.FLAG_STATE_CHANGED)

    return true
end

function ShopUI.Builder.BuildHorseManagementScene(menu)
    ShopUI.Events.HandleHorseManagementFocus(menu)

    return true
end

function ShopUI.Builder.BuildHorseStatInfoBoxScene(menu)
    ShopUI.Events.HandleHorseStatInfoBoxFocus(menu)

    ShopEvents.SetEventFlag(ShopEvents.FLAG_FOCUSED)
    ShopEvents.SetEventFlag(ShopEvents.FLAG_STATE_CHANGED)

    return true
end

function ShopUI.Builder.BuildItemGridScene(menu)
    ShopUI.Scene.BuildPageFilter()
    ShopUI.Events.HandleItemGridFocus(menu)

    return true
end

function ShopUI.Builder.BuildItemListScene(menu)
    ShopUI.Scene.BuildPageFilter()
    ShopUI.Events.HandleItemListFocus(menu)

    return true
end

function ShopUI.Builder.BuildItemListColourPaletteScene(menu)
    ShopUI.CreatePaletteItemListBinding()
    ShopUI.Events.HandleItemListColourPaletteFocus(menu)

    return true
end

function ShopUI.Builder.BuildItemListDescriptionScene(menu)
    ShopUI.Scene.BuildPageFilter()
    ShopUI.Events.HandleItemListDescriptionFocus(menu)

    return true
end

function ShopUI.Builder.BuildItemListHorseStatsScene(menu)
    ShopUI.Scene.BuildPageFilter()
    ShopUI.Events.HandleItemListHorseStatsFocus(menu)

    return true
end

function ShopUI.Builder.BuildItemListRecipesScene(menu)
    ShopUI.Scene.BuildPageFilter()
    ShopUI.Events.HandleItemListRecipesFocus(menu)

    return true
end

function ShopUI.Builder.BuildItemListRpgStatsScene(menu)
    ShopUI.Scene.BuildPageFilter()
    ShopUI.Events.HandleItemListRpgStatsFocus(menu)

    return true
end

function ShopUI.Builder.BuildItemListSliderScene(menu)
    ShopUI.Scene.BuildPageFilter()
    ShopUI.Events.HandleItemListSliderFocus(menu)

    return true
end

function ShopUI.Builder.BuildItemListTextureDescriptionScene(menu)
    ShopUI.Scene.BuildPageFilter()
    ShopUI.Events.HandleItemListTextureDescriptionFocus(menu)

    return true
end

function ShopUI.Builder.BuildItemListVehicleStatsScene(menu)
    ShopUI.Scene.BuildPageFilter()
    ShopUI.Events.HandleItemListVehicleStatsFocus(menu)

    return true
end

function ShopUI.Builder.BuildItemListWeaponStatsScene(menu)
    ShopUI.Scene.BuildPageFilter()
    ShopUI.Events.HandleItemListWeaponStatsFocus(menu)

    return true
end

function ShopUI.Builder.BuildItemSellListHorseStatsScene(menu)
    ShopUI.Events.HandleItemSellListHorseStatsFocus(menu)

    return true
end

function ShopUI.Builder.BuildMenuListScene(menu)
    ShopUI.Events.HandleMenuListFocus(menu)

    return true
end

function ShopUI.Builder.BuildMenuListHorseStatsScene(menu)
    ShopUI.Events.HandleMenuListHorseStatsFocus(menu)

    return true
end

function ShopUI.Builder.BuildMenuListWeaponStatsScene(menu)
    ShopUI.Events.HandleMenuListWeaponStatsFocus(menu)

    return true
end

function ShopUI.Builder.BuildMenuStyleSelectorScene(menu)
    ShopUI.Scene.BuildPageFilter()
    ShopUI.Events.HandleMenuStyleSelectorFocus(menu)

    return true
end

function ShopUI.Builder.BuildSaddleManagementScene(menu)
    ShopUI.Events.HandleSaddleManagementFocus(menu)

    return true
end

function ShopUI.Builder.BuildVehicleManagementScene(menu)
    ShopUI.Events.HandleVehicleManagementFocus(menu)

    return true
end

function ShopUI.Builder.BuildWeaponManagementScene(menu)
    ShopUI.Events.HandleWeaponManagementFocus(menu)

    return true
end

function ShopUI.Builder.AddItemsToSceneWithinRange(start, range)
    local items = ShopNavigator:getCurrentItems()
    if #items == 0 then return false end

    -- Normalize negative start positions (e.g., -1 = last item)
    local normalizedStart = start
    if start < 0 then
        normalizedStart = #items + start
    end

    return ShopUI.Builder.AddItemsToScene(normalizedStart, range, #items)
end

function ShopUI.Builder.AddItemsToScene(start, range, total)
    local index = start
    local added = 0

    -- Try to fill the page up to its capacity
    -- Note: The loop iteration and index are separated to allow for wraparound
    for _ = 1, total do
        -- Prevent overwriting already added items
        if added >= range + 1 then
            break
        end

        -- Check if current item is within our desired range (with wraparound)
        if ShopUI.Builder.IsIndexInRange(index, start, range, total) then
            -- Try to add the item to the current slot
            if ShopUI.Builder.TryAddItemToSlot(index) then
                added = added + 1
                index = index + 1
            end
        else
            -- Move to next item if current one isn't in range
            index = index + 1
        end

        -- Wrap around if we've gone past the end
        if index >= total then
            index = 0
        end
    end

    return added > 0
end

function ShopUI.Builder.TryAddItemToSlot(index)
    local items = ShopNavigator:getCurrentItems()
    local item = items[index + 1]
    if not item then return false end

    local entry = ShopUI.Builder.BuildItem(index, item)

    if entry and DatabindingIsEntryValid(entry) == 1 then
        local type = DatabindingReadDataHashStringFromParent(entry, "uiItemGsui")

        if type ~= 0 then
            DatabindingInsertUiItemToListFromContextHashAlias(ShopUI.bindings.dsuItemList, index, type, entry)
            VirtualCollectionItemAdd(ShopEvents.state.collectionId, index, type, entry)
            ShopUI.state.currentItemEntriesByIndex[index + 1] = entry
            ShopUI.state.currentItemIndecesById[item.Id] = index + 1

            return true
        else
            print("[NativeShop] Error: Built item at index ", index, " is missing GSUI type")
        end
    else
        print("[NativeShop] Error: Failed to build item at index ", index)
    end

    return false
end

function ShopUI.Builder.IsIndexInRange(index, start, range, total)
    local adjustedIndex = index

    -- Handle wraparound case: if range extends past end of list
    -- and index is before start, treat it as wrapped around
    if (start + range) >= total and index < start then
        adjustedIndex = index + total
    end

    -- Check if (possibly adjusted) index is within the range
    return adjustedIndex >= start and adjustedIndex <= (start + range)
end

function ShopUI.Builder.BuildItem(index, item)
    if not item.Id then
        print("[NativeShop] Error: Item at index ", index, " is missing an Id")
        return false
    end

    local ok, swatchResult = pcall(ShopUI.CreateSwatchForItem, item, index)
    if ok then
        item = swatchResult
    else
        print("[NativeShop] Failed to create swatch for item ", item.Id, " with error: ", swatchResult)
    end

    local entry = DatabindingAddDataContainer(ShopUI.bindings.dscItemListEntries, item.Id)
    DatabindingAddDataInt(entry, "ItemIndex", index + 1)
    local result = ShopUI.Builder.FillItem(entry, item)

    -- Log an error if the item failed to build
    if result == false then
        print("[NativeShop] Error: Failed to build item of type ", item.Type, " at index ", index)
        return false
    end

    return result
end

function ShopUI.Builder.FillItem(entry, item)
    local ok, processResult = pcall(ShopUI.ProcessAutoItem, item)
    if ok then
        item = processResult
    else
        print("[NativeShop] Failed to process auto item for item ", item.Id, " with error: ", processResult)
    end

    local itemIndex = DatabindingReadDataIntFromParent(entry, "ItemIndex")
    if item.HasNavigation and itemIndex > 0 then
        DatabindingAddDataInt(entry, "MenuIndex", itemIndex)
    end

    local callbacks = {
        BUSINESS = ShopUI.Builder.FillBusinessItem,
        COUPON = ShopUI.Builder.FillCouponItem,
        HAIR = ShopUI.Builder.FillHairItem,
        INVENTORY = ShopUI.Builder.FillInventoryItem,
        PALETTE = ShopUI.Builder.FillPaletteItem,
        STABLE = ShopUI.Builder.FillStableItem,
        STEPPER = ShopUI.Builder.FillStepperItem,
        TEXT = ShopUI.Builder.FillTextItem,
    }

    local callback = callbacks[item.Type]
    local result = false

    local menu = ShopNavigator:getCurrentMenu()
    local scene = menu and menu.Scene or nil

    if scene == "ITEM_GRID" then
        if item.Type and item.Type ~= "SWATCH" then
            print("[NativeShop] Warning: ITEM_GRID scene only supports SWATCH item types.")
        end

        -- Build the grid-exclusive swatch item, menu supports nothing else
        result = ShopUI.Builder.FillSwatchItem(entry, item)
    elseif callback then
        -- Otherwise use the specific item builder if it exists
        result = callback(entry, item)
    else
        if item.Type == "SWATCH" then
            print("[NativeShop] Warning: SWATCH item type is only supported in ITEM_GRID scene.")
        elseif item.Type and item.Type ~= "" then
            print("[NativeShop] Warning: Invalid item type " .. item.Type .. ", using TEXT as fallback.")
        end

        -- Otherwise use the generic text item builder
        result = ShopUI.Builder.FillTextItem(entry, item)
    end

    return result
end

function ShopUI.Builder.FillBusinessItem(entry, item)
    local data = item.Data or {}

    DatabindingAddDataString(entry, "uiItemID", item.Id)
    DatabindingAddDataString(entry, "uiItemType", "BUSINESS")
    DatabindingAddDataHash(entry, "uiItemGsui", "GSUI_BUSINESS_LIST_ITEM")
    DatabindingAddDataHash(entry, "uiItemLabel", 0)
    DatabindingAddDataString(entry, "uiItemRawText", item.Label or "")
    DatabindingAddDataBool(entry, "itemEnabled", not ShopUI.IsItemDisabled(item))

    DatabindingAddDataHash(entry, "itemDescription", 0)
    DatabindingAddDataString(entry, "itemDescriptionRaw", data.Description or "")
    DatabindingAddDataFloat(entry, "Progress", data.Progress or 1.0)
    DatabindingAddDataHash(entry, "textColor", data.TextColor or "COLOR_WHITE")
    DatabindingAddDataHash(entry, "texture", data.Texture or 0)
    DatabindingAddDataHash(entry, "textureDictionary", data.TextureDictionary or 0)
    DatabindingAddDataBool(entry, "timeIconVisible", data.TimeIconVisible or false)
    DatabindingAddDataBool(entry, "uiItemNew", data.IsNew or false)

    return entry
end

function ShopUI.Builder.FillCouponItem(entry, item)
    local data = item.Data or {}

    DatabindingAddDataString(entry, "uiItemID", item.Id)
    DatabindingAddDataString(entry, "uiItemType", "COUPON")
    DatabindingAddDataHash(entry, "uiItemGsui", "GSUI_COUPON_LIST_ITEM")
    DatabindingAddDataHash(entry, "uiItemLabel", 0)
    DatabindingAddDataString(entry, "uiItemRawText", item.Label or "")
    DatabindingAddDataBool(entry, "itemEnabled", not ShopUI.IsItemDisabled(item))

    DatabindingAddDataHash(entry, "itemDescription", 0)
    DatabindingAddDataString(entry, "itemDescriptionRaw", data.Description or "")
    DatabindingAddDataBool(entry, "maxCount", data.IsMaxCount or false)
    DatabindingAddDataInt(entry, "not_script_data_int_3", data.Quantity or 0)
    DatabindingAddDataHash(entry, "textColor", data.TextColor or "COLOR_WHITE")
    DatabindingAddDataHash(entry, "texture", data.Texture or 0)
    DatabindingAddDataHash(entry, "textureDictionary", data.TextureDictionary or 0)
    DatabindingAddDataBool(entry, "timeIconVisible", data.TimeIconVisible or false)
    DatabindingAddDataBool(entry, "uiItemNew", data.IsNew or false)

    return entry
end

function ShopUI.Builder.FillHairItem(entry, item)
    local data = item.Data or {}

    DatabindingAddDataString(entry, "uiItemID", item.Id)
    DatabindingAddDataString(entry, "uiItemType", "HAIR")
    DatabindingAddDataHash(entry, "uiItemGsui", "GSUI_HAIR_LIST_ITEM")
    DatabindingAddDataHash(entry, "uiItemLabel", 0)
    DatabindingAddDataString(entry, "uiItemRawText", item.Label or "")
    DatabindingAddDataBool(entry, "itemEnabled", not ShopUI.IsItemDisabled(item))

    DatabindingAddDataHash(entry, "itemDescription", 0)
    DatabindingAddDataString(entry, "itemDescriptionRaw", data.Description or "")
    DatabindingAddDataBool(entry, "maxCount", data.IsMaxCount or false)
    DatabindingAddDataInt(entry, "not_script_data_int_3", data.Quantity or 0)
    DatabindingAddDataHash(entry, "texture", data.Texture or 0)
    DatabindingAddDataHash(entry, "textureDictionary", data.TextureDictionary or 0)
    DatabindingAddDataBool(entry, "tickVisible", data.TickVisible or false)
    DatabindingAddDataBool(entry, "uiItemNew", data.IsNew or false)

    return entry
end

function ShopUI.Builder.FillInventoryItem(entry, item)
    local data = item.Data or {}

    DatabindingAddDataString(entry, "uiItemID", item.Id)
    DatabindingAddDataString(entry, "uiItemType", "INVENTORY")
    DatabindingAddDataHash(entry, "uiItemGsui", "GSUI_INVENTORY_LIST_ITEM")
    DatabindingAddDataHash(entry, "uiItemLabel", 0)
    DatabindingAddDataString(entry, "uiItemRawText", item.Label or "")
    DatabindingAddDataBool(entry, "itemEnabled", not ShopUI.IsItemDisabled(item))

    DatabindingAddDataBool(entry, "equipped", data.Equipped or false)
    DatabindingAddDataString(entry, "equippedTexture", data.EquippedTexture or "")
    DatabindingAddDataString(entry, "equippedTXD", data.EquippedTextureDictionary or "")
    DatabindingAddDataBool(entry, "forSale", data.ForSale or false)
    DatabindingAddDataHash(entry, "frontSlotTexture", data.FrontSlotTexture or 0)
    DatabindingAddDataHash(entry, "frontSlotTextureColour", data.FrontSlotTextureColour or "COLOR_WHITE")
    DatabindingAddDataHash(entry, "frontSlotTextureDict", data.FrontSlotTextureDictionary or 0)
    DatabindingAddDataBool(entry, "frontSlotTextureVisible", data.FrontSlotTextureVisible or data.FrontSlotTexture ~= nil)
    DatabindingAddDataBool(entry, "locked", data.Locked or false)
    DatabindingAddDataBool(entry, "owned", data.Owned or false)
    DatabindingAddDataInt(entry, "price", data.Price or 0)
    DatabindingAddDataInt(entry, "rank", data.Rank or 0)
    DatabindingAddDataHash(entry, "rankTexture", data.RankTexture or 0)
    DatabindingAddDataBool(entry, "rankLocked", data.RankLocked or false)
    DatabindingAddDataBool(entry, "uiItemNew", data.IsNew or false)
    DatabindingAddDataBool(entry, "uiItemSale", data.IsOnSale or false)
    DatabindingAddDataBool(entry, "useGoldPrice", data.UseGoldPrice or false)

    return entry
end

function ShopUI.Builder.FillPaletteItem(entry, item)
    local data = item.Data or {}

    local id = item.Id
    local label = item.LabelHash
    if not label or label == 0 then
        label = ShopUI.CreateTextEntry("PALETTE", id, item.Label or id)
    end

    DatabindingAddDataString(entry, "uiItemID", id)
    DatabindingAddDataString(entry, "uiItemType", "PALETTE")
    DatabindingAddDataHash(entry, "uiItemGsui", "GSUI_PALETTE_LIST_ITEM")
    DatabindingAddDataHash(entry, "uiItemLabel", label)
    DatabindingAddDataBool(entry, "itemEnabled", not ShopUI.IsItemDisabled(item))

    DatabindingAddDataBool(entry, "equipped", data.Equipped or false)
    DatabindingAddDataBool(entry, "iconVisible", data.IconVisible or data.IconTexture ~= nil)
    DatabindingAddDataBool(entry, "uiItemNew", data.IsNew or false)
    DatabindingAddDataBool(entry, "uiItemSale", data.IsOnSale or false)

    if type(data.Palette) == "table" then
        if data.IconTexture or data.IconTextureDictionary then
            print("[NativeShop] Warning: Palette item '" .. tostring(id) .. "' has icon defined but will be overridden by palette selection.")
        end

        local value = data.Palette.Value or 1
        local palette = data.Palette.Items or {}
        local option = palette[value] or {}

        DatabindingAddDataString(entry, "iconTexture", option.Texture or "")
        DatabindingAddDataString(entry, "iconTextureDict", option.TextureDictionary or "")
    else
        DatabindingAddDataString(entry, "iconTexture", data.IconTexture or "")
        DatabindingAddDataString(entry, "iconTextureDict", data.IconTextureDictionary or "")
    end

    return entry
end

function ShopUI.Builder.FillStableItem(entry, item)
    local data = item.Data or {}

    DatabindingAddDataString(entry, "uiItemID", item.Id)
    DatabindingAddDataString(entry, "uiItemType", "STABLE")
    DatabindingAddDataHash(entry, "uiItemGsui", "GSUI_STABLE_LIST_ITEM")
    DatabindingAddDataHash(entry, "uiItemLabel", 0)
    DatabindingAddDataString(entry, "uiItemRawText", item.Label or "")
    DatabindingAddDataBool(entry, "itemEnabled", not ShopUI.IsItemDisabled(item))

    DatabindingAddDataHash(entry, "backTexture", data.BackTexture or 0)
    DatabindingAddDataHash(entry, "backTextureColour", data.BackTextureColour or "COLOR_WHITE")
    DatabindingAddDataHash(entry, "backTextureDict", data.BackTextureDictionary or 0)
    DatabindingAddDataBool(entry, "backTextureVisible", data.BackTextureVisible or data.BackTexture ~= nil)
    DatabindingAddDataHash(entry, "frontAddSlotTexture", data.FrontAddSlotTexture or 0)
    DatabindingAddDataHash(entry, "frontAddSlotTextureColour", data.FrontAddSlotTextureColour or "COLOR_WHITE")
    DatabindingAddDataHash(entry, "frontAddSlotTextureDict", data.FrontAddSlotTextureDictionary or 0)
    DatabindingAddDataBool(entry, "frontAddSlotTextureVisible", data.FrontAddSlotTextureVisible or data.FrontAddSlotTexture ~= nil)
    DatabindingAddDataHash(entry, "frontSlotTexture", data.FrontSlotTexture or 0)
    DatabindingAddDataHash(entry, "frontSlotTextureColour", data.FrontSlotTextureColour or "COLOR_WHITE")
    DatabindingAddDataHash(entry, "frontSlotTextureDict", data.FrontSlotTextureDictionary or 0)
    DatabindingAddDataBool(entry, "frontSlotTextureVisible", data.FrontSlotTextureVisible or data.FrontSlotTexture ~= nil)
    DatabindingAddDataBool(entry, "uiItemNew", data.IsNew or false)
    DatabindingAddDataBool(entry, "uiItemSale", data.IsOnSale or false)

    return entry
end

function ShopUI.Builder.FillStepperItem(entry, item)
    local data = item.Data or {}
    local id = item.Id

    DatabindingAddDataString(entry, "uiItemID", id)
    DatabindingAddDataString(entry, "uiItemType", "STEPPER")
    DatabindingAddDataHash(entry, "uiItemGsui", "GSUI_STEPPER_LIST_ITEM")
    DatabindingAddDataHash(entry, "uiItemLabel", 0)
    DatabindingAddDataString(entry, "uiItemRawText", item.Label or "")
    DatabindingAddDataBool(entry, "itemEnabled", not ShopUI.IsItemDisabled(item))

    DatabindingAddDataString(entry, "iconTexture", data.IconTexture or "")
    DatabindingAddDataString(entry, "iconTextureDict", data.IconTextureDict or "")
    DatabindingAddDataBool(entry, "iconVisible", data.IconVisible or data.IconTexture ~= nil)
    DatabindingAddDataBool(entry, "uiItemNew", data.IsNew or false)
    DatabindingAddDataBool(entry, "uiItemSale", data.IsOnSale or false)

    -- Stepper setup
    local options = data.StepperOptions or {}
    local value = data.StepperValue or 1

    for optionIndex, optionText in ipairs(options) do
        local optionKey = string.format("NSUI_%s_%s", id, optionIndex)
        if DoesTextLabelExist(optionKey) ~= 1 then
            AddTextEntry(optionKey, optionText)
        end
    end

    DatabindingAddDataInt(entry, "uiItemStepperMax", #options)
    DatabindingAddDataInt(entry, "uiItemStepperValue", value - 1)
    DatabindingAddDataBool(entry, "uiItemStepperVisible", data.StepperVisible or #options > 0)
    DatabindingAddDataBool(entry, "uiItemStepperEnabled", not ShopUI.IsItemDisabled(item))
    DatabindingAddDataString(entry, "uiItemStepperText", string.format("NSUI_%s_%s", id, value))
    DatabindingAddDataBool(entry, "uiItemTextureStepperVisible", data.StepperTextureVisible or data.StepperTexture ~= nil)
    DatabindingAddDataHash(entry, "uiItemTextureStepperTexture", data.StepperTexture or 0)
    DatabindingAddDataHash(entry, "uiItemTextureStepperTextureDictionary", data.StepperTextureDict or 0)

    return entry
end

function ShopUI.Builder.FillTextItem(entry, item)
    local data = item.Data or {}

    DatabindingAddDataString(entry, "uiItemID", item.Id)
    DatabindingAddDataString(entry, "uiItemType", "TEXT")
    DatabindingAddDataHash(entry, "uiItemGsui", "GSUI_TEXT_LIST_ITEM")
    DatabindingAddDataHash(entry, "uiItemLabel", 0)
    DatabindingAddDataString(entry, "uiItemRawText", item.Label or "")
    DatabindingAddDataBool(entry, "itemEnabled", not ShopUI.IsItemDisabled(item))

    DatabindingAddDataString(entry, "addIconTexture", data.AddIconTexture or "")
    DatabindingAddDataString(entry, "addIconTextureDict", data.AddIconTextureDict or "")
    DatabindingAddDataBool(entry, "addIconVisible", data.AddIconVisible or data.AddIconTexture ~= nil)
    DatabindingAddDataBool(entry, "equipped", data.Equipped or false)
    DatabindingAddDataBool(entry, "onHorse", data.OnHorse or false)
    DatabindingAddDataHash(entry, "rightlabel", 0)
    DatabindingAddDataString(entry, "rightRawText", data.RightText or "")
    DatabindingAddDataBool(entry, "rightLabelVisible", data.RightLabelVisible or data.RightText ~= nil)
    DatabindingAddDataBool(entry, "uiItemNew", data.IsNew or false)
    DatabindingAddDataBool(entry, "uiItemSale", data.IsOnSale or false)

    return entry
end

function ShopUI.Builder.FillSwatchItem(entry, item)
    local data = item.Data or {}

    DatabindingAddDataString(entry, "uiItemID", item.Id)
    DatabindingAddDataString(entry, "uiItemType", "SWATCH")
    DatabindingAddDataHash(entry, "uiItemGsui", "GSUI_SWATCH_LIST_ITEM")

    DatabindingAddDataBool(entry, "visible", not ShopUI.IsItemDisabled(item))
    DatabindingAddDataString(entry, "textureDictionary", data.TextureDictionary or "")
    DatabindingAddDataString(entry, "texture", data.Texture or "")
    DatabindingAddDataBool(entry, "leftImageVisible", data.LeftImageVisible or data.LeftImageTexture ~= nil)
    DatabindingAddDataString(entry, "leftImageDictionary", data.LeftImageDictionary or "")
    DatabindingAddDataString(entry, "leftImageTexture", data.LeftImageTexture or "")
    DatabindingAddDataBool(entry, "rightImageVisible", data.RightImageVisible or data.RightImageTexture ~= nil)
    DatabindingAddDataString(entry, "rightImageDictionary", data.RightImageDictionary or "")
    DatabindingAddDataString(entry, "rightImageTexture", data.RightImageTexture or "")

    DatabindingAddDataBool(entry, "rankLocked", data.RankLocked or false)
    DatabindingAddDataHash(entry, "rankTexture", data.RankTexture or 0)
    DatabindingAddDataBool(entry, "locked", data.Locked or false)
    DatabindingAddDataBool(entry, "equipped", data.Equipped or false)
    DatabindingAddDataBool(entry, "onHorse", data.OnHorse or false)
    DatabindingAddDataBool(entry, "uiItemNew", data.IsNew or false)

    return entry
end

function ShopUI.Prompts.ClearPrompt(type)
    local prompt = promptTypes[type]
    if not prompt then return end

    ShopUI.Prompts.SetPromptLabel(type, "")
    ShopUI.Prompts.SetPromptEnabled(type, false)
    ShopUI.Prompts.SetPromptVisible(type, false)
    ShopUI.Prompts.SetPromptHeld(type, false)
end

function ShopUI.Prompts.ClearAllPrompts()
    for type, _ in ipairs(promptTypes) do
        ShopUI.Prompts.ClearPrompt(type)
    end
end

function ShopUI.Prompts.UpdatePromptsFromItem(item)
    local menu = ShopNavigator:getCurrentMenu()
    if not menu then return end

    local isItemDisabled = ShopUI.IsItemDisabled(item)

    local sceneData = menu.Data or {}
    local sceneSlider = sceneData.SliderInfo or {}

    local itemType = item.Type
    local itemData = item.Data or {}
    local slider = itemData.SliderInfo or {}
    local palette = itemData.Palette or {}

    local prompts = item.Prompts or {}
    local selectData = prompts.Select or {}
    local optionData = prompts.Option or {}
    local toggleData = prompts.Toggle or {}
    local infoData = prompts.Info or {}
    local adjustData = prompts.Adjust or {}
    local modifyData = prompts.Modify or {}

    local hasSelectAction = item.HasNavigation or item.Action or type(selectData) == "table" and selectData.Action or false
    local hasOptionAction = type(optionData) == "table" and optionData.Action or false
    local hasToggleAction = type(toggleData) == "table" and toggleData.Action or false
    local hasInfoAction = type(infoData) == "table" and infoData.Action or false
    local hasAdjustAction = type(adjustData) == "table" and adjustData.Action or false
    local hasModifyAction = type(modifyData) == "table" and modifyData.Action or false

    local isSelectVisible = hasSelectAction or type(selectData) == "string" or type(selectData.Label) == "string" or selectData.Visible == true
    local isOptionVisible = hasOptionAction or type(optionData) == "string" or type(optionData.Label) == "string" or optionData.Visible == true
    local isToggleVisible = hasToggleAction or type(toggleData) == "string" or type(toggleData.Label) == "string" or toggleData.Visible == true
    local isInfoVisible = hasInfoAction or type(infoData) == "string" or type(infoData.Label) == "string" or infoData.Visible == true
    local isAdjustVisible = hasAdjustAction or type(adjustData) == "string" or type(adjustData.Label) == "string" or adjustData.Visible == true
    local isModifyVisible = hasModifyAction or type(modifyData) == "string" or type(modifyData.Label) == "string" or modifyData.Visible == true

    -- Enter | A
    -- Select is always visible for submenu/context items
    if hasSelectAction or isSelectVisible then
        local label, disabled, held = nil, nil, nil

        if type(selectData) == "string" then
            label = selectData
            disabled = false
            held = false
        else
            label = selectData.Label or GetStringFromHashKey("IB_SELECT")
            disabled = selectData.Disabled == true
            held = selectData.Held == true
        end

        ShopUI.Prompts.SetPromptLabel(1, label)
        ShopUI.Prompts.SetPromptEnabled(1, not isItemDisabled and not disabled)
        ShopUI.Prompts.SetPromptVisible(1, true)
        ShopUI.Prompts.SetPromptHeld(1, held)
    else
        ShopUI.Prompts.ClearPrompt(1)
    end

    -- Space | X
    if hasOptionAction or isOptionVisible then
        local label, disabled, held = nil, nil, nil

        if type(optionData) == "string" then
            label = optionData
            disabled = false
            held = false
        else
            label = optionData.Label or "Option"
            disabled = optionData.Disabled == true
            held = optionData.Held == true
        end

        ShopUI.Prompts.SetPromptLabel(2, label)
        ShopUI.Prompts.SetPromptEnabled(2, not isItemDisabled and not disabled)
        ShopUI.Prompts.SetPromptVisible(2, true)
        ShopUI.Prompts.SetPromptHeld(2, held)
    else
        ShopUI.Prompts.ClearPrompt(2)
    end

    -- F | Y
    if hasToggleAction or isToggleVisible then
        local label, disabled, held = nil, nil, nil

        if type(toggleData) == "string" then
            label = toggleData
            disabled = false
            held = false
        else
            label = toggleData.Label or "Toggle"
            disabled = toggleData.Disabled == true
            held = toggleData.Held == true
        end

        ShopUI.Prompts.SetPromptLabel(3, label)
        ShopUI.Prompts.SetPromptEnabled(3, not isItemDisabled and not disabled)
        ShopUI.Prompts.SetPromptVisible(3, true)
        ShopUI.Prompts.SetPromptHeld(3, held)
    else
        ShopUI.Prompts.ClearPrompt(3)
    end

    -- Tab | RS
    if hasInfoAction or isInfoVisible then
        local label, disabled, held = nil, nil, nil

        if type(infoData) == "string" then
            label = infoData
            disabled = false
            held = false
        else
            label = infoData.Label or "Info"
            disabled = infoData.Disabled == true
            held = infoData.Held == true
        end

        if held == true then
            print("[NativeShop] Warning: Info prompt cannot be held. Ignoring 'Held' property.")
        end

        ShopUI.Prompts.SetPromptLabel(4, label)
        ShopUI.Prompts.SetPromptEnabled(4, not isItemDisabled and not disabled)
        ShopUI.Prompts.SetPromptVisible(4, true)
        ShopUI.Prompts.SetPromptHeld(4, false)
    else
        ShopUI.Prompts.ClearPrompt(4)
    end

    -- Q/E | LB/RB
    if hasModifyAction or isModifyVisible then
        local label, disabled, held = nil, nil, nil

        if type(modifyData) == "string" then
            label = modifyData
            disabled = false
            held = false
        else
            label = modifyData.Label or "Modify"
            disabled = modifyData.Disabled == true
            held = modifyData.Held == true
        end

        if held == true then
            print("[NativeShop] Warning: Modify prompt cannot be held. Ignoring 'Held' property.")
        end

        ShopUI.Prompts.SetPromptLabel(6, label)
        ShopUI.Prompts.SetPromptEnabled(6, not isItemDisabled and not disabled)
        ShopUI.Prompts.SetPromptVisible(6, true)
        ShopUI.Prompts.SetPromptHeld(6, false)
    else
        ShopUI.Prompts.ClearPrompt(6)
    end

    -- Arrow left/right | D-Pad left/right
    -- Adjust may be enabled or visible through the menu instead of the item
    -- Adjust is always visible in press mode when using a stepper item
    -- Even when the item is a stepper item, the label can be customized
    local adjustDisabledOverride = false
    local adjustVisibleOverride = false

    if menu.Scene == "ITEM_LIST_SLIDER" then
        adjustDisabledOverride = slider.Disabled == true or sceneSlider.Disabled == true
        adjustVisibleOverride = slider.Visible or sceneSlider.Visible or false
    elseif menu.Scene == "ITEM_LIST_COLOUR_PALETTE" then
        adjustDisabledOverride = not palette.Items or #palette.Items < 1
        adjustVisibleOverride = not adjustDisabledOverride
    elseif itemType == "STEPPER" and itemData.StepperVisible then
        adjustDisabledOverride = not itemData.StepperVisible
        adjustVisibleOverride = not adjustDisabledOverride
    end

    if hasAdjustAction or isAdjustVisible or adjustVisibleOverride then
        local label, disabled, held = nil, nil, nil

        if type(adjustData) == "string" then
            label = adjustData
            disabled = adjustDisabledOverride == true
            held = false
        else
            label = adjustData.Label or "Adjust"
            disabled = adjustDisabledOverride == true or adjustData.Disabled == true
            held = adjustData.Held == true
        end

        if held == true then
            print("[NativeShop] Warning: Adjust prompt cannot be held. Ignoring 'Held' property.")
        end

        ShopUI.Prompts.SetPromptLabel(5, label)
        ShopUI.Prompts.SetPromptEnabled(5, not isItemDisabled and not disabled)
        ShopUI.Prompts.SetPromptVisible(5, true)
        ShopUI.Prompts.SetPromptHeld(5, false)
    else
        ShopUI.Prompts.ClearPrompt(5)
    end
end

function ShopUI.Prompts.UpdateBackPrompt()
    local menu = ShopNavigator:getCurrentMenu()
    if not menu then return end

    local prompts = menu.Prompts or {}
    local backData = prompts.Back or nil

    if not backData then
        local hasParent = ShopNavigator:getParentIdForMenu() ~= nil
        local hasLinkedFromMenu = ShopNavigator:getLinkedFromMenuId() ~= nil
        local backLabel = (hasParent or hasLinkedFromMenu) and "IB_BACK" or "IB_EXIT"

        ShopUI.Prompts.SetPromptLabel(7, GetStringFromHashKey(backLabel))
        ShopUI.Prompts.SetPromptEnabled(7, true)
        ShopUI.Prompts.SetPromptVisible(7, true)
        ShopUI.Prompts.SetPromptHeld(7, false)
    elseif type(backData) == "string" or backData.Visible == true then
        local label, disabled, held = nil, nil, nil

        if type(backData) == "string" then
            label = backData
            disabled = false
            held = false
        elseif type(backData) == "table" then
            label = backData.Label or "Missing Back Label"
            disabled = backData.Disabled == true
            held = backData.Held == true
        end

        ShopUI.Prompts.SetPromptLabel(7, label)
        ShopUI.Prompts.SetPromptEnabled(7, not disabled)
        ShopUI.Prompts.SetPromptVisible(7, true)
        ShopUI.Prompts.SetPromptHeld(7, held)
    else
        ShopUI.Prompts.ClearPrompt(7)
    end
end

function ShopUI.Prompts.SetPromptLabel(type, label)
    local prompt = promptTypes[type]
    if not prompt then return end

    DatabindingAddDataString(ShopUI.bindings.dscPrompts, prompt .. "Label", label)
end

function ShopUI.Prompts.SetPromptEnabled(type, enabled)
    local prompt = promptTypes[type]
    if not prompt then return end

    if DatabindingReadDataBoolFromParent(ShopUI.bindings.dscPrompts, prompt .. "Held") == 1 then
        DatabindingAddDataBool(ShopUI.bindings.dscPrompts, prompt .. "HeldEnabled", enabled)
    else
        DatabindingAddDataBool(ShopUI.bindings.dscPrompts, prompt .. "Enabled", enabled)
    end
end

function ShopUI.Prompts.SetPromptVisible(type, visible)
    local prompt = promptTypes[type]
    if not prompt then return end

    if DatabindingReadDataBoolFromParent(ShopUI.bindings.dscPrompts, prompt .. "Held") == 1 then
        DatabindingAddDataBool(ShopUI.bindings.dscPrompts, prompt .. "HeldVisible", visible)
    else
        DatabindingAddDataBool(ShopUI.bindings.dscPrompts, prompt .. "Visible", visible)
    end
end

function ShopUI.Prompts.SetPromptHeld(type, held)
    local prompt = promptTypes[type]
    if not prompt then return end

    local currentEnabled = DatabindingReadDataBoolFromParent(ShopUI.bindings.dscPrompts, prompt .. "Enabled")
    local currentVisible = DatabindingReadDataBoolFromParent(ShopUI.bindings.dscPrompts, prompt .. "Visible")

    DatabindingAddDataBool(ShopUI.bindings.dscPrompts, prompt .. "Held", held)
    DatabindingAddDataBool(ShopUI.bindings.dscPrompts, prompt .. "HeldEnabled", held and currentEnabled == 1)
    DatabindingAddDataBool(ShopUI.bindings.dscPrompts, prompt .. "HeldVisible", held and currentVisible == 1)

    DatabindingAddDataBool(ShopUI.bindings.dscPrompts, prompt .. "Enabled", not held and currentEnabled == 1)
    DatabindingAddDataBool(ShopUI.bindings.dscPrompts, prompt .. "Visible", not held and currentVisible == 1)
end

function ShopUI.Scene.BuildPageFilter()
    local tabs = ShopNavigator:getTabInfo()

    if tabs and #tabs.Tabs > 0 then
        DatabindingAddDataInt(ShopUI.bindings.dscMain, "CategoryCount", #tabs.Tabs or 1)
        DatabindingAddDataInt(ShopUI.bindings.dscMain, "DefaultCategoryIndex", tabs.CurrentIndex - 1)
        DatabindingAddDataInt(ShopUI.bindings.dscMain, "PageFilterCurrentPageIndex", tabs.CurrentIndex - 1)
    else
        DatabindingAddDataInt(ShopUI.bindings.dscMain, "CategoryCount", 1)
        DatabindingAddDataInt(ShopUI.bindings.dscMain, "DefaultCategoryIndex", 0)
        DatabindingAddDataInt(ShopUI.bindings.dscMain, "PageFilterCurrentPageIndex", 0)
    end
end

function ShopUI.Scene.SetFooter(string)
    DatabindingAddDataString(ShopUI.bindings.dscScene, "ItemTooltip", string or "")
end

function ShopUI.Scene.SetFooterFromItem(item)
    local currentMenu = ShopNavigator:getCurrentMenu()
    if not currentMenu then return false end

    for overrideItemId, overrideItemFooter in pairs(ShopUI.state.footerItemOverrides) do
        if overrideItemId == item.Id then
            ShopUI.Scene.SetFooter(overrideItemFooter)
            return true
        end
    end

    for overrideMenuId, overrideMenuFooter in pairs(ShopUI.state.footerMenuOverrides) do
        if overrideMenuId == currentMenu.Id then
            ShopUI.Scene.SetFooter(overrideMenuFooter)
            return true
        end
    end

    local footer = item.Footer or ""
    local itemData = item.Data or {}

    if ShopUI.IsItemDisabled(item) then
        footer = itemData.DisabledFooter or footer
    end

    if footer and type(footer) == "string" and footer ~= "" then
        ShopUI.Scene.SetFooter(footer)
        return true
    end

    ShopUI.Scene.ClearFooter()
    return false
end

function ShopUI.Scene.SetSceneFooterVisible(visible)
    DatabindingAddDataBool(ShopUI.bindings.dscScene, "FooterVisible", visible == true)
end

function ShopUI.Scene.SetItemPriceFooterVisible(visible)
    DatabindingAddDataBool(ShopUI.bindings.dscMain, "ItemPriceFooterVisible", visible == true)
end

function ShopUI.Scene.SetStatsVisible(visible)
    DatabindingAddDataBool(ShopUI.bindings.dscScene, "StatsVisible", visible == true)
end

function ShopUI.Scene.SetWeaponStatsVisible(visible)
    DatabindingAddDataBool(ShopUI.bindings.dscScene, "WeaponStatsVisible", visible == true)
end

function ShopUI.Scene.SetInfoBoxVisible(visible)
    DatabindingAddDataBool(ShopUI.bindings.dscMain, "InfoBoxVisible", visible == true)
end

function ShopUI.Scene.SetPaletteVisible(visible)
    DatabindingAddDataBool(ShopUI.bindings.dscMain, "uiPaletteVisible", visible == true)
end

function ShopUI.Scene.SetItemDescription(visible, enabled, text)
    local datastore = ShopUI.bindings.dscSceneItemDescription

    DatabindingAddDataBool(datastore, "Visible", visible == true)
    DatabindingAddDataBool(datastore, "Enabled", enabled == true)
    DatabindingAddDataString(datastore, "Text", text or "")
end

function ShopUI.Scene.SetItemDescriptionFromItem(item)
    local itemData = item.Data or {}

    local hash = itemData.ItemDescriptionHash
    if hash and hash ~= 0 then
        local enabled = not ShopUI.IsItemDisabled(item)

        ShopUI.Scene.SetItemDescription(true, enabled, hash)
        return true
    end

    local text = itemData.ItemDescription
    if text and type(text) == "string" and text ~= "" then
        local enabled = not ShopUI.IsItemDisabled(item)
        local descriptionKey = ShopUI.CreateTextEntry("ITEM_DESC", item.Id, text)

        ShopUI.Scene.SetItemDescription(true, enabled, descriptionKey)
        return true
    end

    ShopUI.Scene.ClearItemDescription()
    return false
end

function ShopUI.Scene.SetInfoBoxName(label)
    DatabindingAddDataHash(ShopUI.bindings.dscMain, "InfoBoxName", label or 0)
end

function ShopUI.Scene.SetInfoBoxNameFromItem(item)
    local itemData = item.Data or {}

    local hash = itemData.InfoBoxNameHash
    if hash and hash ~= 0 then
        ShopUI.Scene.SetInfoBoxName(hash)
        return true
    end

    local text = itemData.InfoBoxName or ""
    if text and type(text) == "string" and text ~= "" then
        local labelKey = ShopUI.CreateTextEntry("BOX_NAME", item.Id, text)

        ShopUI.Scene.SetInfoBoxName(labelKey)
        return true
    end

    ShopUI.Scene.ClearInfoBoxName()
    return false
end

function ShopUI.Scene.SetItemInfo1(visible, text, centered, iconVisible, iconTextureDict, iconTexture, iconColor)
    local datastore = ShopUI.bindings.dscSceneItemInfo1

    DatabindingAddDataBool(datastore, "Visible", visible == true)
    DatabindingAddDataHash(datastore, "Text", 0)
    DatabindingAddDataString(datastore, "RawText", text or "")

    if centered == false then
        DatabindingAddDataHash(datastore, "Style", "MENU_TEXT_BODY_LEFT")
    else
        DatabindingAddDataHash(datastore, "Style", "MENU_TEXT_BODY_CENTER")
    end

    DatabindingAddDataBool(datastore, "IconVisible", iconVisible == true)

    if iconVisible == true then
        DatabindingAddDataString(datastore, "TextureDictionary", iconTextureDict or "")
        DatabindingAddDataString(datastore, "Texture", iconTexture or "")
        DatabindingAddDataHash(datastore, "Color", iconColor or "COLOR_WHITE")
    end
end

function ShopUI.Scene.SetItemInfo1FromItem(item)
    local itemData = item.Data or {}
    local data = itemData.ItemInfo1

    if data and type(data) == "table" then
        ShopUI.Scene.SetItemInfo1(
            data.Visible == true,
            data.Text or "",
            data.Centered ~= false,
            data.IconVisible == true,
            data.IconTextureDictionary or "",
            data.IconTexture or "",
            data.IconColor or "COLOR_WHITE"
        )

        return true
    end

    ShopUI.Scene.ClearItemInfo1()
    return false
end

function ShopUI.Scene.SetItemWeather(visible, enabled, opacity, warmth)
    local datastore = ShopUI.bindings.dscSceneItemWeather

    DatabindingAddDataBool(datastore, "Visible", visible == true)
    DatabindingAddDataBool(datastore, "Enabled", enabled == true)

    -- 0 (40%) or 1 (100%)
    DatabindingAddDataInt(datastore, "Opacity", opacity or 0)

    -- 0 = CLOTHING_WARMTH_0 (A lightweight item)
    -- 1 = CLOTHING_WARMTH_1 (Slightly warm)
    -- 2 = CLOTHING_WARMTH_2 (Reasonably warm)
    -- 3 = CLOTHING_WARMTH_3 (Warm)
    -- 4 = CLOTHING_WARMTH_4 (Very warm)
    DatabindingAddDataInt(datastore, "Warmth", warmth or 0)
end

function ShopUI.Scene.SetItemWeatherFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.Weather

    if data and type(data) == "table" then
        ShopUI.Scene.SetItemWeather(
            data.Visible == true,
            data.Enabled == true,
            data.Opacity,
            data.Warmth
        )

        return true
    end

    ShopUI.Scene.ClearItemWeather()
    return false
end

function ShopUI.Scene.SetOutfitWeather(visible, enabled, opacity, effectiveness)
    local datastore = ShopUI.bindings.dscSceneOutfitWeather

    DatabindingAddDataBool(datastore, "Visible", visible == true)
    DatabindingAddDataBool(datastore, "Enabled", enabled == true)

    -- 0 (40%) or 1 (100%)
    DatabindingAddDataInt(datastore, "Opacity", opacity or 0)

    -- 0 = OUTFIT_HOT_WEATHER (Hot temperatures)
    -- 1 = OUTFIT_NO_EXTREME_WEATHER (Average temperatures)
    -- 2 = OUTFIT_COLD_WEATHER (Cold temperatures)
    -- 3 = OUTFIT_IMMUNE_WEATHER (All temperatures)
    DatabindingAddDataInt(datastore, "Effectiveness", effectiveness or 0)
end

function ShopUI.Scene.SetOutfitWeatherFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.OutfitWeather

    if data and type(data) == "table" then
        ShopUI.Scene.SetOutfitWeather(
            data.Visible == true,
            data.Enabled == true,
            data.Opacity,
            data.Effectiveness
        )

        return true
    end

    ShopUI.Scene.ClearOutfitWeather()
    return false
end

function ShopUI.Scene.SetItemInfo2(visible, text, centered, iconVisible, iconTextureDict, iconTexture)
    local datastore = ShopUI.bindings.dscSceneItemInfo2

    DatabindingAddDataBool(datastore, "Visible", visible == true)

    DatabindingAddDataHash(datastore, "Text", 0)
    DatabindingAddDataString(datastore, "RawText", text or "")

    if centered == false then
        DatabindingAddDataHash(datastore, "Style", "MENU_TEXT_BODY_LEFT")
    else
        DatabindingAddDataHash(datastore, "Style", "MENU_TEXT_BODY_CENTER")
    end

    DatabindingAddDataBool(datastore, "IconVisible", iconVisible == true)

    if iconVisible == true then
        DatabindingAddDataString(datastore, "TextureDictionary", iconTextureDict or "")
        DatabindingAddDataString(datastore, "Texture", iconTexture or "")
    end
end

function ShopUI.Scene.SetItemInfo2FromItem(item)
    local itemData = item.Data or {}
    local data = itemData.ItemInfo2

    if data and type(data) == "table" then
        ShopUI.Scene.SetItemInfo2(
            data.Visible == true,
            data.Text or "",
            data.Centered ~= false,
            data.IconVisible == true,
            data.IconTextureDictionary or "",
            data.IconTexture or ""
        )

        return true
    end

    ShopUI.Scene.ClearItemInfo2()
    return false
end

function ShopUI.Scene.SetPriceDetails(visible, price, tokens, salePrice, gold, affordable, leftText, rightText, locked, rank)
    local datastore = ShopUI.bindings.dscPriceDetails

    DatabindingAddDataBool(datastore, "visible", visible == true)

    DatabindingAddDataInt(datastore, "purchasePrice", price or 0)
    DatabindingAddDataInt(datastore, "tokenPrice", tokens or 0)

    local onSale = salePrice ~= nil and price ~= salePrice
    DatabindingAddDataBool(datastore, "isGoldPrice", gold == true)
    DatabindingAddDataBool(datastore, "modifiedPriceVisible", gold ~= true and onSale)
    DatabindingAddDataBool(datastore, "modifiedPriceGold", gold == true and onSale)
    DatabindingAddDataInt(datastore, "purchaseModifiedPrice", salePrice)
    DatabindingAddDataBool(datastore, "isAffordable", affordable == true)

    DatabindingAddDataString(datastore, "purchaseLabel", leftText or "")

    local hasRightText = rightText ~= nil and rightText ~= ""
    DatabindingAddDataBool(datastore, "rightPriceTextVisible", hasRightText)

    if hasRightText then
        DatabindingAddDataHash(datastore, "rightPriceText", 0)
        DatabindingAddDataString(datastore, "rightPriceRawText", rightText or "")
    end

    if locked == true then
        DatabindingAddDataBool(datastore, "locked", true)
        DatabindingAddDataBool(datastore, "itemPriceRankLocked", false)
    elseif rank ~= nil then
        DatabindingAddDataBool(datastore, "locked", false)
        DatabindingAddDataBool(datastore, "itemPriceRankLocked", true)
        DatabindingAddDataInt(datastore, "itemPriceRank", rank or 0)
    else
        DatabindingAddDataBool(datastore, "locked", false)
        DatabindingAddDataBool(datastore, "itemPriceRankLocked", false)
    end
end

function ShopUI.Scene.SetPriceDetailsFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.Pricing

    if data and type(data) == "table" then
        ShopUI.Scene.SetPriceDetails(
            true,
            data.Price or 0,
            data.Tokens or 0,
            data.SalePrice,
            data.UseGoldPrice == true,
            data.Affordable == true,
            data.LeftText or "",
            data.RightText or "",
            data.Locked == true,
            data.Rank
        )

        return true
    end

    ShopUI.Scene.ClearPriceDetails()
    return false
end

function ShopUI.Scene.SetHorseStats(primary, speed, acceleration, handlingText, typeText, breedText, coatText, genderText)
    if type(speed) ~= "table" then speed = {} end
    if type(acceleration) ~= "table" then acceleration = {} end

    local datastore = ShopUI.bindings.dscScene

    DatabindingAddDataBool(datastore, "AltHorseStats", primary ~= true)

    if primary == true then
        DatabindingAddDataInt(datastore, "HorseSpeedValue", speed.Value or 0)
        DatabindingAddDataInt(datastore, "HorseSpeedMinValue", speed.MinValue or 0)
        DatabindingAddDataInt(datastore, "HorseSpeedMaxValue", speed.MaxValue or 0)

        DatabindingAddDataInt(datastore, "HorseSpeedCapacityValue", speed.CapacityValue or 0)
        DatabindingAddDataInt(datastore, "HorseSpeedCapacityMinValue", speed.CapacityMinValue or 0)
        DatabindingAddDataInt(datastore, "HorseSpeedCapacityMaxValue", speed.CapacityMaxValue or 0)

        DatabindingAddDataInt(datastore, "HorseSpeedEquipmentValue", speed.EquipmentValue or 0)
        DatabindingAddDataInt(datastore, "HorseSpeedEquipmentMinValue", speed.EquipmentMinValue or 0)
        DatabindingAddDataInt(datastore, "HorseSpeedEquipmentMaxValue", speed.EquipmentMaxValue or 0)

        DatabindingAddDataInt(datastore, "HorseAccValue", acceleration.Value or 0)
        DatabindingAddDataInt(datastore, "HorseAccMinValue", acceleration.MinValue or 0)
        DatabindingAddDataInt(datastore, "HorseAccMaxValue", acceleration.MaxValue or 0)

        DatabindingAddDataInt(datastore, "HorseAccCapacityValue", acceleration.CapacityValue or 0)
        DatabindingAddDataInt(datastore, "HorseAccCapacityMinValue", acceleration.CapacityMinValue or 0)
        DatabindingAddDataInt(datastore, "HorseAccCapacityMaxValue", acceleration.CapacityMaxValue or 0)

        DatabindingAddDataInt(datastore, "HorseAccEquipmentValue", acceleration.EquipmentValue or 0)
        DatabindingAddDataInt(datastore, "HorseAccEquipmentMinValue", acceleration.EquipmentMinValue or 0)
        DatabindingAddDataInt(datastore, "HorseAccEquipmentMaxValue", acceleration.EquipmentMaxValue or 0)

        DatabindingAddDataHash(datastore, "HorseHandling", handlingText or 0)
    else
        DatabindingAddDataHash(datastore, "HorseType", typeText or 0)
        DatabindingAddDataHash(datastore, "HorseBreed", breedText or 0)
        DatabindingAddDataHash(datastore, "HorseCoat", coatText or 0)
        DatabindingAddDataHash(datastore, "HorseGender", genderText or 0)
    end
end

function ShopUI.Scene.SetHorseStatsFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.HorseStats

    if data and type(data) == "table" then
        local handlingKey = data.HandlingTextHash or ShopUI.CreateTextEntry("HORSE_HANDLING", item.Id, data.HandlingText or "")
        local typeKey = data.TypeTextHash or ShopUI.CreateTextEntry("HORSE_TYPE", item.Id, data.TypeText or "")
        local breedKey = data.BreedTextHash or ShopUI.CreateTextEntry("HORSE_BREED", item.Id, data.BreedText or "")
        local coatKey = data.CoatTextHash or ShopUI.CreateTextEntry("HORSE_COAT", item.Id, data.CoatText or "")
        local genderKey = data.GenderTextHash or ShopUI.CreateTextEntry("HORSE_GENDER", item.Id, data.GenderText or "")

        ShopUI.Scene.SetHorseStats(
            data.Primary == true,
            data.Speed or {},
            data.Acceleration or {},
            handlingKey,
            typeKey,
            breedKey,
            coatKey,
            genderKey
        )

        return true
    end

    ShopUI.Scene.ClearHorseStats()
    return false
end

function ShopUI.Scene.SetHorseInfoBox(visible, stats, text, description, tipText)
    local datastore = ShopUI.bindings.dscInfoBox

    DatabindingAddDataBool(datastore, "isVisible", visible == true)
    DatabindingAddDataBool(datastore, "showHorseStats", stats == true)
    DatabindingAddDataHash(datastore, "itemLabel", text or 0)
    DatabindingAddDataString(datastore, "itemDescription", description or "")
    DatabindingAddDataHash(datastore, "itemTipText", 0)
    DatabindingAddDataString(datastore, "itemRawTipText", tipText or "")
end

function ShopUI.Scene.SetHorseInfoBoxFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.HorseInfoBox

    if data and type(data) == "table" then
        local labelKey = data.TextHash or ShopUI.CreateTextEntry("HORSE_INFOBOX_LABEL", item.Id, data.Text or "")
        local tipKey = data.TipTextHash or ShopUI.CreateTextEntry("HORSE_INFOBOX_TIP", item.Id, data.TipText or "")

        ShopUI.Scene.SetHorseInfoBox({
            data.Visible == true,
            data.Stats == true,
            labelKey,
            data.Description or "",
            tipKey
        })
        return true
    end

    ShopUI.Scene.ClearHorseInfoBox()
    return false
end

function ShopUI.Scene.SetSaddleStats(visible, items)
    if type(items) ~= "table" then items = {} end

    local datastore = ShopUI.bindings.dscScene

    DatabindingAddDataBool(datastore, "SaddleStatsVisible", visible == true)

    -- Refresh the saddle stats UI lists
    ShopUI.CreateSaddleStatListBinding()

    for index, value in ipairs(items) do
        local entry = DatabindingAddDataContainer(ShopUI.bindings.dsuSceneSaddleStats, string.format("stat_attribute_item_%d", index))
        DatabindingAddDataBool(entry, "isRowActive", value.Enabled ~= true)
        DatabindingAddDataBool(entry, "isIconVisible", value.IconVisible == true)
        DatabindingAddDataString(entry, "iconTXD", value.IconTextureDictionary or "")
        DatabindingAddDataString(entry, "iconTexture", value.IconTexture or "")
        DatabindingAddDataString(entry, "label", value.Text or "")
        DatabindingAddDataString(entry, "value", value.Value or "")
        DatabindingAddDataBool(entry, "isEndIconVisible", value.EndIconVisible == true)
        DatabindingAddDataString(entry, "endIconTXD", value.EndIconTextureDictionary or "")
        DatabindingAddDataString(entry, "endIconTexture", value.EndIconTexture or "")
        DatabindingInsertUiItemToListFromContextStringAlias(ShopUI.bindings.dsuSceneSaddleStats, -1, "stat_attribute_item", entry)
    end
end

function ShopUI.Scene.SetSaddleStatsFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.SaddleStats

    if data and type(data) == "table" then
        ShopUI.Scene.SetSaddleStats(
            data.Visible == true,
            data.Items or {}
        )
        return true
    end

    ShopUI.Scene.ClearSaddleStats()
    return false
end

function ShopUI.Scene.SetStirrupStats(visible, speed, acceleration, items)
    if type(speed) ~= "table" then speed = {} end
    if type(acceleration) ~= "table" then acceleration = {} end
    if type(items) ~= "table" then items = {} end

    local datastore = ShopUI.bindings.dscScene

    DatabindingAddDataBool(datastore, "StirrupStatsVisible", visible == true)

    DatabindingAddDataInt(datastore, "HorseSpeedValue", speed.Value or 0)
    DatabindingAddDataInt(datastore, "HorseSpeedMinValue", speed.MinValue or 0)
    DatabindingAddDataInt(datastore, "HorseSpeedMaxValue", speed.MaxValue or 0)

    DatabindingAddDataInt(datastore, "HorseSpeedCapacityValue", speed.CapacityValue or 0)
    DatabindingAddDataInt(datastore, "HorseSpeedCapacityMinValue", speed.CapacityMinValue or 0)
    DatabindingAddDataInt(datastore, "HorseSpeedCapacityMaxValue", speed.CapacityMaxValue or 0)

    DatabindingAddDataInt(datastore, "HorseSpeedEquipmentValue", speed.EquipmentValue or 0)
    DatabindingAddDataInt(datastore, "HorseSpeedEquipmentMinValue", speed.EquipmentMinValue or 0)
    DatabindingAddDataInt(datastore, "HorseSpeedEquipmentMaxValue", speed.EquipmentMaxValue or 0)

    DatabindingAddDataInt(datastore, "HorseAccValue", acceleration.Value or 0)
    DatabindingAddDataInt(datastore, "HorseAccMinValue", acceleration.MinValue or 0)
    DatabindingAddDataInt(datastore, "HorseAccMaxValue", acceleration.MaxValue or 0)

    DatabindingAddDataInt(datastore, "HorseAccCapacityValue", acceleration.CapacityValue or 0)
    DatabindingAddDataInt(datastore, "HorseAccCapacityMinValue", acceleration.CapacityMinValue or 0)
    DatabindingAddDataInt(datastore, "HorseAccCapacityMaxValue", acceleration.CapacityMaxValue or 0)

    DatabindingAddDataInt(datastore, "HorseAccEquipmentValue", acceleration.EquipmentValue or 0)
    DatabindingAddDataInt(datastore, "HorseAccEquipmentMinValue", acceleration.EquipmentMinValue or 0)
    DatabindingAddDataInt(datastore, "HorseAccEquipmentMaxValue", acceleration.EquipmentMaxValue or 0)

    -- Refresh the stirrup stats UI lists
    ShopUI.CreateStirrupStatListBinding()

    for index, value in ipairs(items) do
        local entry = DatabindingAddDataContainer(ShopUI.bindings.dsuSceneStirrupStats, string.format("stat_attribute_item_%d", index))
        DatabindingAddDataBool(entry, "isRowActive", value.Enabled ~= true)
        DatabindingAddDataBool(entry, "isIconVisible", value.IconVisible == true)
        DatabindingAddDataString(entry, "iconTXD", value.IconTextureDictionary or "")
        DatabindingAddDataString(entry, "iconTexture", value.IconTexture or "")
        DatabindingAddDataString(entry, "label", value.Text or "")
        DatabindingAddDataString(entry, "value", value.Value or "")
        DatabindingAddDataBool(entry, "isEndIconVisible", value.EndIconVisible == true)
        DatabindingAddDataString(entry, "endIconTXD", value.EndIconTextureDictionary or "")
        DatabindingAddDataString(entry, "endIconTexture", value.EndIconTexture or "")
        DatabindingInsertUiItemToListFromContextStringAlias(ShopUI.bindings.dsuSceneStirrupStats, -1, "stat_attribute_item", entry)
    end
end

function ShopUI.Scene.SetStirrupStatsFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.StirrupStats

    if data and type(data) == "table" then
        ShopUI.Scene.SetStirrupStats(
            data.Visible == true,
            data.Speed or {},
            data.Acceleration or {},
            data.Items or {}
        )
        return true
    end

    ShopUI.Scene.ClearStirrupStats()
    return false
end

function ShopUI.Scene.SetVehicleStats(primary, maxSpeedText, accelerationText, steeringText, descriptionText)
    local datastore = ShopUI.bindings.dscScene

    DatabindingAddDataBool(datastore, "AltVehicleStats", primary ~= true)

    if primary == true then
        DatabindingAddDataHash(datastore, "VehicleMaxSpeed", maxSpeedText or 0)
        DatabindingAddDataHash(datastore, "VehicleAcceleration", accelerationText or 0)
        DatabindingAddDataHash(datastore, "VehicleSteering", steeringText or 0)
    else
        DatabindingAddDataHash(datastore, "VehicleDescription", descriptionText or 0)
    end
end

function ShopUI.Scene.SetVehicleStatsFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.VehicleStats

    if data and type(data) == "table" then
        local maxSpeedKey = data.MaxSpeedHash or ShopUI.CreateTextEntry("VEHICLE_SPEED", item.Id, data.MaxSpeed or "")
        local accelerationKey = data.AccelerationHash or ShopUI.CreateTextEntry("VEHICLE_ACCELERATION", item.Id, data.Acceleration or "")
        local steeringKey = data.SteeringHash or ShopUI.CreateTextEntry("VEHICLE_STEERING", item.Id, data.Steering or "")
        local descriptionKey = data.DescriptionHash or ShopUI.CreateTextEntry("VEHICLE_DESCRIPTION", item.Id, data.Description or "")

        ShopUI.Scene.SetVehicleStats(
            data.Primary == true,
            maxSpeedKey,
            accelerationKey,
            steeringKey,
            descriptionKey
        )

        return true
    end

    ShopUI.Scene.ClearVehicleStats()
    return false
end

function ShopUI.Scene.SetWeaponStats(power, range, accuracy, fireRate, reload)
    if type(power) ~= "table" then power = {} end
    if type(range) ~= "table" then range = {} end
    if type(accuracy) ~= "table" then accuracy = {} end
    if type(fireRate) ~= "table" then fireRate = {} end
    if type(reload) ~= "table" then reload = {} end

    local datastore = ShopUI.bindings.dscScene

    DatabindingAddDataInt(datastore, "WeaponPowerValue", power.Value or 0)
    DatabindingAddDataInt(datastore, "WeaponPowerDiff", power.Diff or 0)
    DatabindingAddDataInt(datastore, "WeaponPowerNew", power.New or 0)

    DatabindingAddDataInt(datastore, "WeaponRangeValue", range.Value or 0)
    DatabindingAddDataInt(datastore, "WeaponRangeDiff", range.Diff or 0)
    DatabindingAddDataInt(datastore, "WeaponRangeNew", range.New or 0)

    DatabindingAddDataInt(datastore, "WeaponAccuracyValue", accuracy.Value or 0)
    DatabindingAddDataInt(datastore, "WeaponAccuracyDiff", accuracy.Diff or 0)
    DatabindingAddDataInt(datastore, "WeaponAccuracyNew", accuracy.New or 0)

    DatabindingAddDataInt(datastore, "WeaponFireRateValue", fireRate.Value or 0)
    DatabindingAddDataInt(datastore, "WeaponFireRateDiff", fireRate.Diff or 0)
    DatabindingAddDataInt(datastore, "WeaponFireRateNew", fireRate.New or 0)

    DatabindingAddDataInt(datastore, "WeaponReloadValue", reload.Value or 0)
    DatabindingAddDataInt(datastore, "WeaponReloadDiff", reload.Diff or 0)
    DatabindingAddDataInt(datastore, "WeaponReloadNew", reload.New or 0)
end

function ShopUI.Scene.SetWeaponStatsFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.WeaponStats

    if data and type(data) == "table" then
        ShopUI.Scene.SetWeaponStats(
            data.Power or {},
            data.Range or {},
            data.Accuracy or {},
            data.FireRate or {},
            data.Reload or {}
        )

        return true
    end

    ShopUI.Scene.ClearWeaponStats()
    return false
end

function ShopUI.Scene.SetRecipeFooter(visible, titleType, items)
    if type(items) ~= "table" then items = {} end

    local datastore = ShopUI.bindings.dscScene

    DatabindingAddDataBool(datastore, "RecipeFooterVisible", visible == true)
    DatabindingAddDataBool(datastore, "RecipeInfoVisible", visible == true)

    -- 0 = SHOP_INGREDIENTS_TITLE, 1 = SHOP_INFO, 2 = SHOP_BUYER_TITLE
    DatabindingAddDataInt(datastore, "RecipeTitle", titleType or 0)

    -- Refresh the image and text lists
    ShopUI.CreateRecipeItemListBinding()

    for index, value in ipairs(items) do
        local count = value.Count or 0

        local textEntry = DatabindingAddDataContainer(ShopUI.bindings.dsuItemRecipeTextList, string.format("recipeListItem_%d", index))
        DatabindingAddDataString(textEntry, "itemName", value.Name or "")
        DatabindingAddDataBool(textEntry, "enabled", value.Enabled == true)
        DatabindingInsertUiItemToListFromContextStringAlias(ShopUI.bindings.dsuItemRecipeTextList, -1, "recipeListItem", textEntry)

        local imageEntry = DatabindingAddDataContainer(ShopUI.bindings.dsuItemRecipeImageList, string.format("recipeImageItem_%d", index))
        DatabindingAddDataHash(imageEntry, "textureDictionary", value.TextureDictionary or 0)
        DatabindingAddDataHash(imageEntry, "texture", value.Texture or 0)
        DatabindingAddDataInt(imageEntry, "count", count)
        DatabindingAddDataBool(imageEntry, "visible", count > 1)
        DatabindingAddDataBool(imageEntry, "enabled", value.Enabled == true)
        DatabindingInsertUiItemToListFromContextStringAlias(ShopUI.bindings.dsuItemRecipeImageList, -1, "recipeImageItem", imageEntry)
    end
end

function ShopUI.Scene.SetRecipeFooterFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.RecipeFooter

    if data and type(data) == "table" then
        ShopUI.Scene.SetRecipeFooter(
            data.Visible == true,
            data.TitleType or 0,
            data.Items or {}
        )
        return true
    end

    ShopUI.Scene.ClearRecipeFooter()
    return false
end

function ShopUI.Scene.SetRpgEffects(effects)
    if type(effects) ~= "table" then effects = {} end
    if type(effects.Health) ~= "table" then effects.Health = {} end
    if type(effects.Stamina) ~= "table" then effects.Stamina = {} end
    if type(effects.Deadeye) ~= "table" then effects.Deadeye = {} end
    if type(effects.HealthCore) ~= "table" then effects.HealthCore = {} end
    if type(effects.StaminaCore) ~= "table" then effects.StaminaCore = {} end
    if type(effects.DeadeyeCore) ~= "table" then effects.DeadeyeCore = {} end
    if type(effects.HealthHorse) ~= "table" then effects.HealthHorse = {} end
    if type(effects.StaminaHorse) ~= "table" then effects.StaminaHorse = {} end
    if type(effects.HealthCoreHorse) ~= "table" then effects.HealthCoreHorse = {} end
    if type(effects.StaminaCoreHorse) ~= "table" then effects.StaminaCoreHorse = {} end

    local effectKeyToValue = {
        Health = "health",
        Stamina = "stamina",
        Deadeye = "deadeye",
        HealthCore = "healthCore",
        StaminaCore = "staminaCore",
        DeadeyeCore = "deadeyeCore",
        HealthHorse = "healthHorse",
        StaminaHorse = "staminaHorse",
        HealthCoreHorse = "healthCoreHorse",
        StaminaCoreHorse = "staminaCoreHorse",
    }

    local durationIntToHash = {
        [0] = 0,
        [1] = 0xB65F115D,
        [2] = 0xEC9E7DDB,
        [3] = 0x22E96A70,
        [4] = 0xC912B6C4,
    }

    local datastore = ShopUI.bindings.dscEffects

    for key, value in pairs(effects) do
        local dataKey = effectKeyToValue[key]

        if dataKey then
            DatabindingAddDataInt(datastore, dataKey, value.Value or 0)
            DatabindingAddDataHash(datastore, dataKey .. "DurationCategory", durationIntToHash[value.Duration] or 0)
        end
    end
end

function ShopUI.Scene.SetRpgEffectsFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.RpgEffects

    if data and type(data) == "table" then
        ShopUI.Scene.SetRpgEffects(data)
        return true
    end

    ShopUI.Scene.ClearRpgEffects()
    return false
end

function ShopUI.Scene.SetSliderInfo(visible, enabled, value, maxValue, totalTanks, activeTanks)
    if not value then value = 1 end
    if value < 1 then value = 1 end

    if not totalTanks then totalTanks = 10 end
    if totalTanks > 10 then totalTanks = 10 end

    if not maxValue then maxValue = 1 end
    if maxValue < 1 then maxValue = 1 end
    if maxValue > totalTanks then maxValue = totalTanks end

    if not activeTanks then activeTanks = 0 end
    if activeTanks < 0 then activeTanks = 0 end
    if activeTanks > totalTanks then activeTanks = totalTanks end

    local datastore = ShopUI.bindings.dscScene

    DatabindingAddDataBool(datastore, "SliderVisible", visible == true)
    DatabindingAddDataBool(datastore, "SliderEnabled", enabled == true)

    DatabindingAddDataBool(datastore, "SliderLeftArrowEnabled", value > 1)
    DatabindingAddDataBool(datastore, "SliderRightArrowEnabled", value < maxValue)

    DatabindingAddDataInt(datastore, "SliderCurrent", value)
    DatabindingAddDataInt(datastore, "SliderInputMax", maxValue)
    DatabindingAddDataInt(datastore, "SliderMax", totalTanks or 0)
    DatabindingAddDataInt(datastore, "SliderInputRange", activeTanks or 0)
end

function ShopUI.Scene.SetSliderInfoFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.SliderInfo

    if data and type(data) == "table" then
        ShopUI.Scene.SetSliderInfo(
            data.Visible == true,
            data.Enabled == true,
            data.Value,
            data.MaxValue,
            data.TotalTanks,
            data.ActiveTanks
        )

        return true
    end

    ShopUI.Scene.ClearSliderInfo()
    return false
end

function ShopUI.Scene.SetBusinessInfo(visible, description, materialsIconDict, materialsIcon, productionIconDict, productionIcon, goodsIconDict, goodsIcon)
    local businessDatastore = ShopUI.bindings.dscSceneBusiness

    DatabindingAddDataBool(businessDatastore, "FooterVisible", visible == true)
    DatabindingAddDataHash(businessDatastore, "MaterialsTextureDictionary", materialsIconDict or 0)
    DatabindingAddDataHash(businessDatastore, "MaterialsTexture", materialsIcon or 0)
    DatabindingAddDataHash(businessDatastore, "ProductionTextureDictionary", productionIconDict or 0)
    DatabindingAddDataHash(businessDatastore, "ProductionTexture", productionIcon or 0)
    DatabindingAddDataHash(businessDatastore, "GoodsTextureDictionary", goodsIconDict or 0)
    DatabindingAddDataHash(businessDatastore, "GoodsTexture", goodsIcon or 0)
    DatabindingAddDataString(businessDatastore, "Description", description or "")

    -- No matter what I try, I cannot get these to show up when they should
    -- I'm pretty sure these were cut from the generic_shop UI entirely and moved to trader UI
    DatabindingAddDataBool(businessDatastore, "ShowDeliveryStats", false)
    DatabindingAddDataString(businessDatastore, "TotalGoods", "")
    DatabindingAddDataString(businessDatastore, "WagonSize", "")
    DatabindingAddDataString(businessDatastore, "WagonCapacity", "")
    DatabindingAddDataString(businessDatastore, "DeliveryAmount", "")
end

function ShopUI.Scene.SetBusinessInfoFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.BusinessInfo

    if data and type(data) == "table" then
        local hash = data.DescriptionHash
        if not hash or hash == 0 then
            hash = ShopUI.CreateTextEntry("BUSINESS_DESC", item.Id, data.Description or "")
        end

        ShopUI.Scene.SetBusinessInfo(
            data.Visible == true,
            hash,
            data.MaterialsIconDictionary or "",
            data.MaterialsIcon or "",
            data.ProductionIconDictionary or "",
            data.ProductionIcon or "",
            data.GoodsIconDictionary or "",
            data.GoodsIcon or ""
        )

        -- Note: Price seems to be cut from this menu similar to delivery stats
        -- It seems they were moved to the trader UI partially and never cleaned from this menu

        return true
    end

    ShopUI.Scene.ClearBusinessInfo()
    return false
end

function ShopUI.Scene.SetPalette(id, value, items)
    if not id then id = "default" end
    if not value then value = 1 end
    if type(items) ~= "table" then items = {} end

    local datastore = ShopUI.bindings.dscMain
    DatabindingAddDataInt(datastore, "currentPaletteIndex", value - 1)
    DatabindingAddDataInt(datastore, "paletteItemCount", #items)
    DatabindingAddDataHash(datastore, "ItemPaletteItemName", string.format("NSUI_%s_%s", id, value))

    local scene = ShopUI.bindings.dscScene
    DatabindingAddDataBool(scene, "SliderLeftArrowEnabled", value > 1)
    DatabindingAddDataBool(scene, "SliderRightArrowEnabled", value < #items)

    -- Refresh the palette UI lists
    ShopUI.CreatePaletteItemListBinding()

    for index, item in ipairs(items) do
        local key = string.format("NSUI_%s_%s", id, index)
        if DoesTextLabelExist(key) ~= 1 then
            AddTextEntry(key, item.Text or "")
        end

        local entry = DatabindingAddDataContainer(ShopUI.bindings.dscPaletteItemListEntries, string.format("paletteEntry_%d", index))
        DatabindingAddDataBool(entry, "visible", item.Visible == true)
        DatabindingAddDataString(entry, "textureDictionary", item.TextureDictionary or "")
        DatabindingAddDataString(entry, "texture", item.Texture or "")
        DatabindingAddDataBool(entry, "uiItemNew", item.New == true)
        DatabindingAddDataBool(entry, "owned", item.Owned == true)
        DatabindingAddDataBool(entry, "equipped", item.Equipped == true)
        DatabindingAddDataBool(entry, "locked", item.Locked == true)
        DatabindingAddDataBool(entry, "itemEnabled", item.Visible == true)
        DatabindingAddDataHash(entry, "itemName", key)

        DatabindingInsertUiItemToListFromContextStringAlias(ShopUI.bindings.dsuPaletteItemList, -1, "GSUI_PALETTE_SWATCH_ITEM", entry)
    end
end

function ShopUI.Scene.SetPaletteFromItem(item)
    local itemData = item.Data or {}
    local data = itemData.Palette

    if data and type(data) == "table" then
        ShopUI.Scene.SetPalette(
            item.Id,
            data.Value or 1,
            data.Items or {}
        )
        return true
    end

    ShopUI.Scene.ClearPalette()
    return false
end

function ShopUI.Scene.ClearFooter()
    ShopUI.Scene.SetFooter("")
end

function ShopUI.Scene.ClearInfoBoxName()
    ShopUI.Scene.SetInfoBoxName(0)
end

function ShopUI.Scene.ClearItemDescription()
    ShopUI.Scene.SetItemDescription(
        false, -- visible
        false, -- enabled
        ""     -- text
    )
end

function ShopUI.Scene.ClearItemInfo1()
    ShopUI.Scene.SetItemInfo1(
        false, -- visible
        "",    -- text
        false, -- centered
        false, -- iconVisible
        "",    -- iconTextureDict
        "",    -- iconTexture
        0      -- iconColor
    )
end

function ShopUI.Scene.ClearItemWeather()
    ShopUI.Scene.SetItemWeather(
        false, -- visible
        false, -- enabled
        0,     -- opacity
        0      -- effectiveness
    )
end

function ShopUI.Scene.ClearOutfitWeather()
    ShopUI.Scene.SetOutfitWeather(
        false, -- visible
        false, -- enabled
        0,     -- opacity
        0      -- effectiveness
    )
end

function ShopUI.Scene.ClearItemInfo2()
    ShopUI.Scene.SetItemInfo2(
        false, -- visible
        "",    -- text
        false, -- centered
        false, -- iconVisible
        "",    -- iconTextureDict
        ""     -- iconTexture
    )
end

function ShopUI.Scene.ClearPriceDetails()
    ShopUI.Scene.SetPriceDetails(
        false, -- visible
        0,     -- price
        0,     -- tokens
        0,     -- salePrice
        false, -- gold
        false, -- affordable
        "",    -- leftText
        "",    -- rightText
        false, -- locked
        0      -- rank
    )
end

function ShopUI.Scene.ClearHorseStats()
    ShopUI.Scene.SetStatsVisible(false)
    ShopUI.Scene.SetHorseStats(
        true, -- primary
        {     -- speed
            Value = 0,
            MinValue = 0,
            MaxValue = 0,
            CapacityValue = 0,
            CapacityMinValue = 0,
            CapacityMaxValue = 0,
            EquipmentValue = 0,
            EquipmentMinValue = 0,
            EquipmentMaxValue = 0,
        },
        { -- acceleration
            Value = 0,
            MinValue = 0,
            MaxValue = 0,
            CapacityValue = 0,
            CapacityMinValue = 0,
            CapacityMaxValue = 0,
            EquipmentValue = 0,
            EquipmentMinValue = 0,
            EquipmentMaxValue = 0,
        },
        0, -- handlingText
        0, -- typeText
        0, -- breedText
        0, -- coatText
        0  -- genderText
    )
end

function ShopUI.Scene.ClearHorseInfoBox()
    ShopUI.Scene.SetHorseInfoBox({
        false, -- visible
        false, -- stats
        0,     -- text
        "",    -- description
        ""     -- tipText
    })
end

function ShopUI.Scene.ClearSaddleStats()
    ShopUI.Scene.SetSaddleStats(
        false, -- visible
        {}     -- items
    )
end

function ShopUI.Scene.ClearStirrupStats()
    ShopUI.Scene.SetStirrupStats(
        false, -- visible
        {},    -- speed
        {},    -- acceleration
        {}     -- items
    )
end

function ShopUI.Scene.ClearVehicleStats()
    ShopUI.Scene.SetStatsVisible(false)
    ShopUI.Scene.SetVehicleStats(
        true, -- primary
        0,    -- maxSpeedText
        0,    -- accelerationText
        0,    -- steeringText
        0     -- descriptionText
    )
end

function ShopUI.Scene.ClearWeaponStats()
    ShopUI.Scene.SetWeaponStats(
        { Value = 0, Diff = 0, New = 0 }, -- power
        { Value = 0, Diff = 0, New = 0 }, -- range
        { Value = 0, Diff = 0, New = 0 }, -- accuracy
        { Value = 0, Diff = 0, New = 0 }, -- fireRate
        { Value = 0, Diff = 0, New = 0 }  -- reload
    )
end

function ShopUI.Scene.ClearRecipeFooter()
    ShopUI.Scene.SetRecipeFooter(
        false, -- visible
        0,     -- titleType
        {}     -- items
    )
end

function ShopUI.Scene.ClearRpgEffects()
    ShopUI.Scene.SetRpgEffects({
        Health = { Value = 0, Duration = 0 },
        Stamina = { Value = 0, Duration = 0 },
        Deadeye = { Value = 0, Duration = 0 },
        HealthCore = { Value = 0, Duration = 0 },
        StaminaCore = { Value = 0, Duration = 0 },
        DeadeyeCore = { Value = 0, Duration = 0 },
        HealthHorse = { Value = 0, Duration = 0 },
        StaminaHorse = { Value = 0, Duration = 0 },
        HealthCoreHorse = { Value = 0, Duration = 0 },
        StaminaCoreHorse = { Value = 0, Duration = 0 },
    })
end

function ShopUI.Scene.ClearSliderInfo()
    ShopUI.Scene.SetSliderInfo(
        false, -- visible
        false, -- enabled
        0,     -- value
        0,     -- maxValue
        0,     -- totalTanks
        0      -- activeTanks
    )
end

function ShopUI.Scene.ClearBusinessInfo()
    ShopUI.Scene.SetBusinessInfo(
        false, -- visible
        "",    -- description
        0,     -- materialsIconDict
        0,     -- materialsIcon
        0,     -- productionIconDict
        0,     -- productionIcon
        0,     -- goodsIconDict
        0      -- goodsIcon
    )
end

function ShopUI.Scene.ClearPalette()
    ShopUI.Scene.SetPalette(
        "", -- id
        1,  -- value
        {}  -- items
    )
end

function ShopUI.Scene.FullClear()
    ShopUI.Scene.SetSceneFooterVisible(false)
    ShopUI.Scene.SetItemPriceFooterVisible(false)
    ShopUI.Scene.SetStatsVisible(false)
    ShopUI.Scene.SetWeaponStatsVisible(false)
    ShopUI.Scene.SetPaletteVisible(false)

    ShopUI.Scene.ClearInfoBoxName()
    ShopUI.Scene.ClearItemDescription()
    ShopUI.Scene.ClearItemInfo1()
    ShopUI.Scene.ClearItemWeather()
    ShopUI.Scene.ClearOutfitWeather()
    ShopUI.Scene.ClearItemInfo2()
    ShopUI.Scene.ClearPriceDetails()
    ShopUI.Scene.ClearHorseStats()
    ShopUI.Scene.ClearHorseInfoBox()
    ShopUI.Scene.ClearSaddleStats()
    ShopUI.Scene.ClearStirrupStats()
    ShopUI.Scene.ClearVehicleStats()
    ShopUI.Scene.ClearWeaponStats()
    ShopUI.Scene.ClearRecipeFooter()
    ShopUI.Scene.ClearRpgEffects()
    ShopUI.Scene.ClearSliderInfo()
    ShopUI.Scene.ClearBusinessInfo()
    ShopUI.Scene.ClearPalette()
end
