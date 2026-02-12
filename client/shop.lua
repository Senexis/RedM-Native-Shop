ShopData = {}

ShopData.state = {
    shuttingDown = false,
    hiddenMenu = nil,
    orbitCameraData = nil,
    hasUiInitialized = false,
    hasEnteredFirstScene = false,
    entryFocusIndex = 1,
    pedForHorseStats = nil,
}

function MaintainEvents()
    local rootMenu = ShopNavigator:getRootMenu()
    local currentMenu = ShopNavigator:getCurrentMenu()
    if not rootMenu or not currentMenu then return end

    if not ShopData.state.hasUiInitialized then
        ShopUI.Initialize()

        ShopData.state.hasUiInitialized = true
        return
    end

    -- Allow moving around even though the game enforces the shop menu context
    if rootMenu.AllowWalking and not ShopData.state.shuttingDown then
        -- Simulates the player menu context
        SetControlContext(9, "OnlinePlayerMenu")
        SetControlContext(10, 0)

        -- Disable certain controls that would interfere with the shop UI but wouldn't with player menu
        DisableControlAction(0, "INPUT_MAP", true)
        DisableControlAction(0, "INPUT_SELECT_ITEM_WHEEL", true)
        DisableControlAction(0, "INPUT_FRONTEND_PAUSE", true)
        DisableControlAction(0, "INPUT_FRONTEND_PAUSE_ALTERNATE", true)
        DisableControlAction(0, "INPUT_INTERACT_LOCKON", false)

        -- Prevent attacking while in the shop UI
        DisableControlAction(0, "INPUT_AIM", false)
        DisableControlAction(0, "INPUT_ATTACK", false)

        -- The player menu additionally disables these controls
        DisableControlAction(0, "INPUT_NEXT_CAMERA", false)
        DisableControlAction(0, "INPUT_HORSE_SPRINT", false)
        DisableControlAction(0, "INPUT_JUMP", false)
        DisableControlAction(0, "INPUT_SPRINT", false)
        DisableControlAction(0, "INPUT_ENTER", false)
        DisableControlAction(0, "INPUT_MELEE_ATTACK", false)
        DisableControlAction(0, "INPUT_PHONE", false)
        DisableControlAction(0, "INPUT_RADIAL_MENU_SLOT_NAV_NEXT", false)
        DisableControlAction(0, "INPUT_RADIAL_MENU_SLOT_NAV_PREV", false)
        DisableControlAction(0, "INPUT_COVER", false)
        DisableControlAction(0, "INPUT_OPEN_WHEEL_MENU", false)
    end

    -- Use orbit camera (focuses the camera properly) when in the shop UI
    if rootMenu.RepositionCamera and not ShopData.state.shuttingDown then
        Citizen.InvokeNative(0xC3742F1FDF0A6824)

        local struct = DataView.ArrayBuffer(128)
        struct:SetString(0, "mp@spinning_orbit_cam")
        struct:SetString(64, "SPINNING_ORBIT_REQUEST")

        if IsCameraAvailable(struct:Buffer()) ~= 1 then
            if IsCamDataDictLoaded(struct:Buffer()) ~= 1 then
                LoadCameraDataDict(struct:Buffer())
            end

            if IsCameraAvailable(struct:Buffer()) ~= 1 then
                CamCreate(struct:Buffer())
            end
        end
    end

    -- Update horse stats if a ped is available
    if ShopData.state.pedForHorseStats and not ShopData.state.shuttingDown then
        if DoesEntityExist(ShopData.state.pedForHorseStats) == 1 then
            -- This is certainly one part of it, but not the whole thing, still todo
            Citizen.InvokeNative(0x3FE4FB41EF7D2196, ShopData.state.pedForHorseStats)
        else
            ShopData.state.pedForHorseStats = nil
        end
    end

    -- Happens when navigating to a new scene/menu
    if ShopEvents.GetShopEventFlag(ShopEvents.FLAG_NEXT_SCENE) or ShopEvents.GetShopEventFlag(ShopEvents.FLAG_PREV_SCENE) then
        ShopUI.ResetScene()

        local activeMenu = currentMenu or rootMenu
        local scene = activeMenu.Scene or "MENU_LIST"
        local result = ShopUI.Builder.BuildScene(scene, activeMenu)

        if result then
            ShopUI.EnterScene(scene)

            if not ShopData.state.hasEnteredFirstScene then
                ShopData.state.hasEnteredFirstScene = true
            end
        else
            print("[NativeShop] Failed to build scene: " .. tostring(scene))
            ShopUI.Exit()
        end

        ShopEvents.ClearShopEventFlag(ShopEvents.FLAG_NEXT_SCENE)
        ShopEvents.ClearShopEventFlag(ShopEvents.FLAG_PREV_SCENE)
    end

    -- Happens when navigating to a new page/tab within the current scene
    if ShopEvents.GetShopEventFlag(ShopEvents.FLAG_NEXT_PAGE) or ShopEvents.GetShopEventFlag(ShopEvents.FLAG_FILTER_CHANGED) then
        local index = DatabindingReadDataIntFromParent(ShopUI.bindings.dscMain, "PageFilterCurrentPageIndex")
        local result = ShopNavigator:navigateTabs(index + 1)

        if result then
            ShopUI.UpdateSubheader()
            ShopUI.Virtuals.ResetCollection()
            ShopData.state.entryFocusIndex = 1
            ShopUI.state.currentItemEntries = {}
        else
            print("[NativeShop] Selected tab index '" .. index .. "' is invalid.")
        end

        ShopEvents.ClearShopEventFlag(ShopEvents.FLAG_NEXT_PAGE)
        ShopEvents.ClearShopEventFlag(ShopEvents.FLAG_FILTER_CHANGED)
    end

    -- Happens when an item is selected/activated
    if ShopEvents.GetShopEventFlag(ShopEvents.FLAG_ITEM_SELECTED) then
        if ShopEvents.GetShopEventFlag(ShopEvents.FLAG_EXIT) then
            local result = ShopNavigator:navigateBack()

            if type(result) == "number" then
                ShopUI.PrevScene()
                ShopData.state.entryFocusIndex = result
                ShopUI.state.currentItemEntries = {}
            else
                ShopUI.Exit()
            end
        end

        local action = ShopEvents.state.lastAction
        if action == "GENERIC_SHOP_UI_SELECT" then
            ShopUI.Events.HandleItemSelect()
        else
            ShopUI.Events.HandleItemAction(action)
        end

        ShopEvents.ClearShopEventFlag(ShopEvents.FLAG_ITEM_SELECTED)
        ShopEvents.ClearShopEventFlag(ShopEvents.FLAG_EXIT)
    end

    -- Happens when an item is unfocused/unhighlighted
    if ShopEvents.GetShopEventFlag(ShopEvents.FLAG_UNFOCUSED) then
        ShopUI.Events.HandleItemUnfocus()
        ShopEvents.ClearShopEventFlag(ShopEvents.FLAG_UNFOCUSED)
    end

    -- Happens when an item is focused/highlighted
    if ShopEvents.GetShopEventFlag(ShopEvents.FLAG_FOCUSED) then
        ShopUI.Events.HandleItemFocus()
        ShopEvents.ClearShopEventFlag(ShopEvents.FLAG_FOCUSED)
    end

    -- Happens when the stepper value for an item has changed
    if ShopEvents.GetShopEventFlag(ShopEvents.FLAG_STEPPER_DELTA_CHANGE) then
        ShopUI.Events.HandleStepperChange()
        ShopEvents.ClearShopEventFlag(ShopEvents.FLAG_STEPPER_DELTA_CHANGE)
    end

    -- Happens when a new collection has been set, usually when navigating to a new tab/page
    if ShopEvents.GetShopEventFlag(ShopEvents.FLAG_NEW_COLLECTION) then
        local collectionId = ShopEvents.state.collectionId

        if VirtualCollectionExists(collectionId) then
            local count = #ShopNavigator:getCurrentItems()
            VirtualCollectionSetSize(collectionId, count)
        else
            print("[NativeShop] Collection does not exist: " .. tostring(collectionId))
        end

        local entry = ShopData.state.entryFocusIndex
        ShopUI.SetIndex(entry - 1)

        ShopEvents.ClearShopEventFlag(ShopEvents.FLAG_NEW_COLLECTION)
    end

    -- Happens when the UI requests more items to be added to the current collection
    if ShopEvents.GetShopEventFlag(ShopEvents.FLAG_COLLECTION_REQUEST) then
        ShopUI.CreateItemListBinding()

        local result = ShopUI.Builder.AddItemsToSceneWithinRange(
            ShopEvents.state.collectionStartIndex,
            ShopEvents.state.collectionRequestParameter
        )

        if not result then
            print("[NativeShop] Failed to add items to collection:")
            print("  Start Index: " .. tostring(ShopEvents.state.collectionStartIndex))
            print("  Request Parameter: " .. tostring(ShopEvents.state.collectionRequestParameter))
        end

        ShopEvents.ClearShopEventFlag(ShopEvents.FLAG_COLLECTION_REQUEST)
    end

    if ShopEvents.GetShopEventFlag(ShopEvents.FLAG_STATE_CHANGED) then
        -- We could handle specific state changes here if needed in the future
        ShopEvents.ClearShopEventFlag(ShopEvents.FLAG_STATE_CHANGED)
    end
end

AddEventHandler("shop:open", function(shop)
    ShopUI.Open(shop)
end)

AddEventHandler("shop:close", function()
    ShopUI.Exit()
end)

AddEventHandler("shop:hide", function()
    ShopUI.Hide()
end)

AddEventHandler("shop:disable_item", function(item)
    ShopUI.DisableItem(item)
end)

AddEventHandler("shop:enable_item", function(item)
    ShopUI.EnableItem(item)
end)

AddEventHandler("shop:refresh_menu", function(menu)
    ShopUI.RefreshMenu(menu)
end)

AddEventHandler("shop:set_menu_footer", function(menu, header)
    ShopUI.SetFooterOverride(menu, nil, header)
end)

AddEventHandler("shop:clear_menu_footer", function(menu)
    ShopUI.ClearFooterOverride(menu, nil)
end)

AddEventHandler("shop:set_item_footer", function(item, footer)
    ShopUI.SetFooterOverride(nil, item, footer)
end)

AddEventHandler("shop:clear_item_footer", function(item)
    ShopUI.ClearFooterOverride(nil, item)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Only hook into the always-running event handler while the UI is open
        if IsUiappRunning("shop_menu") == 1 then
            local success, error = pcall(MaintainEvents)

            -- If something went wrong, close the UI to prevent the user from getting stuck
            if not success then
                print("[NativeShop] An error occurred while processing shop events: ")
                print("  " .. tostring(error))

                CloseUiappImmediate("shop_menu")
            end
        end
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local success, error = pcall(ShopUI.Exit)

    -- If something went wrong, close the UI to prevent the user from getting stuck
    if not success then
        print("[NativeShop] An error occurred while exiting the shop UI on resource stop: ")
        print("  " .. tostring(error))

        CloseUiappImmediate("shop_menu")
    end
end)

_G.ShopData = ShopData
