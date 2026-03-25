ShopData = {}

ShopData.state = {
    eventFlags = 0,
    shuttingDown = false,
    hiddenMenu = nil,
    orbitCameraData = nil,
    hasUiInitialized = false,
    hasEnteredFirstScene = false,
    entryFocusIndex = 1,
    -- pedForHorseStats = nil,
    onTickRunning = false,
    onTickTimestamp = 0,
    rootMenuId = nil,
    rootMenu = nil,
    currentMenuId = nil,
    currentMenu = nil,
}

function ShopData.GetEventFlag(flag)
    return ShopData.state.eventFlags & flag ~= 0
end

function ShopData.MaintainEvents()
    if not ShopData.state.hasUiInitialized then
        ShopUI.Initialize()

        -- Instead of creating a new data view every frame, do it once
        local struct = DataView.ArrayBuffer(128)
        struct:SetString(0, "mp@spinning_orbit_cam")
        struct:SetString(64, "SPINNING_ORBIT_REQUEST")

        ShopData.state.orbitCameraData = struct:Buffer()
        ShopData.state.hasUiInitialized = true
        return
    end

    -- Instead of creating new menu objects every frame, update only when changes are detected
    local rootMenuId = ShopNavigator:getRootMenuId()
    if rootMenuId ~= ShopData.state.rootMenuId then
        ShopData.state.rootMenuId = rootMenuId
        ShopData.state.rootMenu = ShopNavigator:getRootMenu()
    end

    local currentMenuId = ShopNavigator:getCurrentMenuId()
    if currentMenuId ~= ShopData.state.currentMenuId then
        ShopData.state.currentMenuId = currentMenuId
        ShopData.state.currentMenu = ShopNavigator:getCurrentMenu()
    end

    -- Reassign to local variables for easier access and to avoid repeated table lookups
    local rootMenu = ShopData.state.rootMenu
    local currentMenu = ShopData.state.currentMenu
    if not rootMenu or not currentMenu then return end

    -- Allow moving around even though the game enforces the shop menu context
    if rootMenu.AllowWalking and not ShopData.state.shuttingDown then
        -- Simulates the player menu context
        SetControlContext(9, "OnlinePlayerMenu")
        SetControlContext(10, 0)

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

    if not ShopData.state.shuttingDown then
        -- Disables miscellaneous prompts
        UiPromptEnablePromptTypeThisFrame(0)

        -- Disable certain controls that would interfere with the shop UI but wouldn't with player menu
        DisableControlAction(0, "INPUT_MAP", true)
        DisableControlAction(0, "INPUT_SELECT_ITEM_WHEEL", true)
        DisableControlAction(0, "INPUT_FRONTEND_PAUSE", true)
        DisableControlAction(0, "INPUT_FRONTEND_PAUSE_ALTERNATE", true)
        DisableControlAction(0, "INPUT_INTERACT_LOCKON", false)

        -- Prevent attacking while in the shop UI
        DisableControlAction(0, "INPUT_AIM", false)
        DisableControlAction(0, "INPUT_ATTACK", false)
    end

    -- Use orbit camera (focuses the camera properly) when in the shop UI
    if rootMenu.RepositionCamera and not ShopData.state.shuttingDown then
        Citizen.InvokeNative(0xC3742F1FDF0A6824)

        local data = ShopData.state.orbitCameraData
        if data and IsCameraAvailable(data) ~= 1 then
            if IsCamDataDictLoaded(data) ~= 1 then
                LoadCameraDataDict(data)
            end

            if IsCameraAvailable(data) ~= 1 then
                CamCreate(data)
            end
        end
    end

    -- Trigger the menu's tick function if it has one
    if currentMenu.Tick and not ShopData.state.shuttingDown then
        local waitMs = currentMenu.TickMs or 1000
        if waitMs < 0 then waitMs = 0 end

        local currentTime = GetGameTimer()
        if (currentTime - ShopData.state.onTickTimestamp) >= waitMs then
            CreateThread(function()
                if IsUiappTransitioningByHash("shop_menu") == 1 then return end

                ShopData.state.onTickRunning = true

                local success, error = pcall(currentMenu.Tick)
                if not success then
                    print("[NativeShop] Error in Tick function: " .. tostring(error))
                end

                ShopData.state.onTickRunning = false
            end)

            ShopData.state.onTickTimestamp = currentTime
        end
    end

    -- Update horse stats if a ped is available
    -- if ShopData.state.pedForHorseStats and not ShopData.state.shuttingDown then
    --     if DoesEntityExist(ShopData.state.pedForHorseStats) == 1 then
    --         -- This is certainly one part of it, but not the whole thing, still todo
    --         Citizen.InvokeNative(0x3FE4FB41EF7D2196, ShopData.state.pedForHorseStats)
    --     else
    --         ShopData.state.pedForHorseStats = nil
    --     end
    -- end

    -- Pop the event flags for this frame so we can react to them
    -- This prevents race conditions by flags getting cleared before we can react to them
    ShopData.state.eventFlags = ShopEvents.PopEventFlags()

    -- Early return if we don't have anything to do to prevent unnecessary flag checks
    if not ShopData.GetEventFlag(ShopEvents.FLAG_STATE_CHANGED) then
        return
    end

    -- Happens when navigating to a new scene/menu
    if ShopData.GetEventFlag(ShopEvents.FLAG_NEXT_SCENE) or ShopData.GetEventFlag(ShopEvents.FLAG_PREV_SCENE) then
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
    end

    -- Happens when navigating to a new page/tab within the current scene
    if ShopData.GetEventFlag(ShopEvents.FLAG_NEXT_PAGE) or ShopData.GetEventFlag(ShopEvents.FLAG_FILTER_CHANGED) then
        local collectionId = ShopEvents.state.collectionId
        local index = DatabindingReadDataIntFromParent(ShopUI.bindings.dscMain, "PageFilterCurrentPageIndex")
        local result = ShopNavigator:navigateTabs(index + 1)

        if result then
            ShopUI.UpdateSubheader()

            if VirtualCollectionExists(collectionId) then
                VirtualCollectionReset(collectionId)
            else
                print("[NativeShop] Collection does not exist: " .. tostring(collectionId))
            end

            ShopData.state.entryFocusIndex = 1
            ShopUI.state.currentItemEntriesByIndex = {}
            ShopUI.state.currentItemIndecesById = {}
        else
            print("[NativeShop] Selected tab index '" .. index .. "' is invalid.")
        end
    end

    -- Happens when an item is selected/activated
    if ShopData.GetEventFlag(ShopEvents.FLAG_ITEM_SELECTED) then
        if ShopData.GetEventFlag(ShopEvents.FLAG_EXIT) then
            local result = ShopNavigator:navigateBack()

            if type(result) == "number" then
                ShopUI.PrevScene()
                ShopData.state.entryFocusIndex = result
                ShopUI.state.currentItemEntriesByIndex = {}
                ShopUI.state.currentItemIndecesById = {}
            else
                ShopUI.Exit()
            end
        end

        local action = ShopEvents.state.lastAction
        local actionParameter = ShopEvents.state.lastActionParameter
        ShopUI.Events.HandleItemSelect(action, actionParameter)
    end

    -- Happens when an item is unfocused/unhighlighted
    if ShopData.GetEventFlag(ShopEvents.FLAG_UNFOCUSED) then
        ShopUI.Events.HandleItemUnfocus()
    end

    -- Happens when an item is focused/highlighted
    if ShopData.GetEventFlag(ShopEvents.FLAG_FOCUSED) then
        ShopUI.Events.HandleItemFocus()
    end

    -- Happens when the stepper value for an item has changed
    if ShopData.GetEventFlag(ShopEvents.FLAG_STEPPER_DELTA_CHANGE) then
        ShopUI.Events.HandleStepperChange()
    end

    -- Happens when a new collection has been set, usually when navigating to a new tab/page
    if ShopData.GetEventFlag(ShopEvents.FLAG_NEW_COLLECTION) then
        local collectionId = ShopEvents.state.collectionId

        if VirtualCollectionExists(collectionId) then
            local count = #ShopNavigator:getCurrentItems()
            VirtualCollectionSetSize(collectionId, count)
        else
            print("[NativeShop] Collection does not exist: " .. tostring(collectionId))
        end

        local entry = ShopData.state.entryFocusIndex
        ShopUI.SetIndex(entry - 1)
    end

    -- Happens when the UI requests more items to be added to the current collection
    if ShopData.GetEventFlag(ShopEvents.FLAG_COLLECTION_REQUEST) then
        ShopUI.CreateItemListBinding()

        local result = ShopUI.Builder.AddItemsToSceneWithinRange(
            ShopEvents.state.collectionStartIndex,
            ShopEvents.state.collectionRequestParameter
        )

        if type(result) == "number" and result <= 0 then
            print("[NativeShop] Failed to add items to collection:")
            print("  Start Index: " .. tostring(ShopEvents.state.collectionStartIndex))
            print("  Request Parameter: " .. tostring(ShopEvents.state.collectionRequestParameter))
        end
    end
end
