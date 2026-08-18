local CURRENT_RESOURCE <const> = GetCurrentResourceName()

ShopData = {
    eventFlags = 0,
    shuttingDown = false,
    hiddenMenu = nil,
    orbitCameraData = nil,
    hasUiInitialized = false,
    hasEnteredFirstScene = false,
    entryFocusIndex = 1,
    onTickRunning = false,
    onTickTimestamp = 0,
    rootMenuId = nil,
    rootMenu = nil,
    currentMenuId = nil,
    currentMenu = nil,
    holdToExitStart = nil,
    holdToExitPromptShown = false,
    pendingRequests = {},
}

RegisterNetEvent(CURRENT_RESOURCE .. ":internal:receiveResponse")
AddEventHandler(
    CURRENT_RESOURCE .. ":internal:receiveResponse",
    function(reqId, data)
        if ShopData.pendingRequests[reqId] then
            ShopData.pendingRequests[reqId](data)
            ShopData.pendingRequests[reqId] = nil
        end
    end
)

function ShopData:SafeInvoke(ownerRes, cbId, ...)
    if not ownerRes then
        print("[NativeShop] Attempted to invoke a callback with no owner resource specified.")
        return
    elseif not cbId or type(cbId) ~= "string" then
        print("[NativeShop] Attempted to invoke a callback with missing callback ID: " .. tostring(cbId))
        return
    elseif string.sub(cbId, 1, 3) ~= "cb_" then
        print("[NativeShop] Attempted to invoke a callback with an invalid callback ID: " .. tostring(cbId))
        return
    end

    local p = promise.new()
    local reqId = math.random(10000, 99999)

    self.pendingRequests[reqId] = function(data)
        p:resolve(data)
    end

    -- Trigger the user resource's dispatcher
    TriggerEvent(ownerRes .. ":internal:dispatch", cbId, reqId, ...)

    -- Wait for the response
    return Citizen.Await(p)
end

function ShopData:IsFlagSet(flag)
    return self.eventFlags & flag ~= 0
end

function ShopData:MaintainEvents()
    if not self.hasUiInitialized then
        ShopUI.Initialize()

        -- Instead of creating a new data view every frame, do it once
        local struct = DataView.ArrayBuffer(128)
        struct:SetString(0, "mp@spinning_orbit_cam")
        struct:SetString(64, "SPINNING_ORBIT_REQUEST")

        self.orbitCameraData = struct:Buffer()
        self.hasUiInitialized = true
        return
    end

    -- Instead of creating new menu objects every frame, update only when changes are detected
    local rootMenuId = ShopNavigator:getRootMenuId()
    if rootMenuId ~= self.rootMenuId then
        self.rootMenuId = rootMenuId
        self.rootMenu = ShopNavigator:getRootMenu()
    end

    local currentMenuId = ShopNavigator:getCurrentMenuId()
    if currentMenuId ~= self.currentMenuId then
        self.currentMenuId = currentMenuId
        self.currentMenu = ShopNavigator:getCurrentMenu()
    end

    -- Reassign to local variables for easier access and to avoid repeated table lookups
    local rootMenu = self.rootMenu
    local currentMenu = self.currentMenu
    if not rootMenu or not currentMenu then return end

    -- Allow moving around even though the game enforces the shop menu context
    if rootMenu.AllowWalking and not self.shuttingDown then
        SetControlContext(9, "OnlinePlayerMenu")
        SetControlContext(10, 0)
    end

    if not self.shuttingDown then
        self:DisableControls()

        -- Unequip any current weapons (PLAYER::_SET_PLAYER_AIM_WEAPON)
        local playerId = PlayerId()
        Citizen.InvokeNative(0xCFFC3ECCD7A5CCEB, playerId, "WEAPON_UNARMED", 0)
        Citizen.InvokeNative(0xCFFC3ECCD7A5CCEB, playerId, "WEAPON_UNARMED", 1)

        -- Disables miscellaneous prompts
        UiPromptEnablePromptTypeThisFrame(0)
    end

    -- Use orbit camera (focuses the camera properly) when in the shop UI
    if rootMenu.RepositionCamera and not self.shuttingDown then
        Citizen.InvokeNative(0xC3742F1FDF0A6824)

        local data = self.orbitCameraData
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
    if currentMenu.Tick and not self.shuttingDown then
        local waitMs = currentMenu.TickMs or 1000
        if waitMs < 0 then waitMs = 0 end

        local currentTime = GetGameTimer()
        if (currentTime - self.onTickTimestamp) >= waitMs then
            CreateThread(function()
                if IsUiappTransitioningByHash("shop_menu") == 1 then return end

                self.onTickRunning = true

                local resourceName = ShopNavigator:getCurrentResourceName()
                self:SafeInvoke(resourceName, currentMenu.Tick)

                self.onTickRunning = false
            end)

            self.onTickTimestamp = currentTime
        end
    end

    -- Implement the back button hold-to-exit behavior
    if
        Config.HoldToExit and
        not rootMenu.PreventHoldToExit and
        not currentMenu.PreventHoldToExit and
        not self.shuttingDown
    then
        if IsUiappTransitioningByHash("shop_menu") == 1 then
            self.holdToExitStart = nil
            self.holdToExitPromptShown = false
        else
            local backHeld = IsControlPressed(0, "INPUT_GAME_MENU_CANCEL")
            if backHeld and not self.holdToExitStart then
                self.holdToExitStart = GetGameTimer()
            elseif backHeld and self.holdToExitStart then
                local heldDuration = GetGameTimer() - self.holdToExitStart

                if heldDuration >= Config.HoldToExitPromptMs and not self.holdToExitPromptShown then
                    ShopUI.Prompts.SetHoldToExitPrompt()
                    self.holdToExitPromptShown = true
                elseif heldDuration >= Config.HoldToExitCloseMs then
                    ShopUI.Exit()
                end
            elseif not backHeld then
                self.holdToExitStart = nil
                self.holdToExitPromptShown = false
                ShopUI.Prompts.UpdateBackPrompt()
            end
        end
    end

    -- Pop the event flags for this frame so we can react to them
    -- This prevents race conditions by flags getting cleared before we can react to them
    self.eventFlags = ShopEvents:PopEventFlags()

    -- Early return if we don't have anything to do to prevent unnecessary flag checks
    if not self:IsFlagSet(FLAG.STATE_CHANGED) then
        return
    end

    -- Happens when navigating to a new scene/menu
    if self:IsFlagSet(FLAG.NEXT_SCENE) or self:IsFlagSet(FLAG.PREV_SCENE) then
        ShopUI.ResetScene()

        local activeMenu = currentMenu or rootMenu
        local scene = activeMenu.Scene or "MENU_LIST"
        local result = ShopUI.Builder.BuildScene(scene, activeMenu)

        if result then
            ShopUI.EnterScene(scene)

            if not self.hasEnteredFirstScene then
                self.hasEnteredFirstScene = true
            end
        else
            print("[NativeShop] Failed to build scene: " .. tostring(scene))
            ShopUI.Exit()
        end
    end

    -- Happens when navigating to a new page/tab within the current scene
    if self:IsFlagSet(FLAG.NEXT_PAGE) or self:IsFlagSet(FLAG.FILTER_CHANGED) then
        local collectionId = ShopEvents.collectionId
        local index = DatabindingReadDataIntFromParent(ShopUI.bindings.dscMain, "PageFilterCurrentPageIndex")
        local result = ShopNavigator:navigateTabs(index + 1)

        if result then
            ShopUI.UpdateSubheader()

            if VirtualCollectionExists(collectionId) then
                VirtualCollectionReset(collectionId)
            else
                print("[NativeShop] Collection does not exist: " .. tostring(collectionId))
            end

            self.entryFocusIndex = 1
            ShopUI.state.currentItemEntriesByIndex = {}
            ShopUI.state.currentItemIndecesById = {}
        else
            print("[NativeShop] Selected tab index '" .. index .. "' is invalid.")
        end
    end

    -- Happens when an item is selected/activated
    if self:IsFlagSet(FLAG.ITEM_SELECTED) then
        local action = ShopEvents.lastAction
        local actionParameter = ShopEvents.lastActionParameter
        local selectedIndex = ShopEvents.selectedIndex

        if self:IsFlagSet(FLAG.EXIT) then
            if
                not currentMenu.Prompts or
                not currentMenu.Prompts.Back or
                (currentMenu.Prompts.Back.Visible ~= false and currentMenu.Prompts.Back.Enabled ~= false)
            then
                ShopUI.state.currentItemEntriesByIndex = {}
                ShopUI.state.currentItemIndecesById = {}

                local result = ShopNavigator:navigateBack()
                if type(result) == "number" then
                    ShopUI.PrevScene()
                    self.entryFocusIndex = result
                    ShopUI.Events.HandleItemSelect(selectedIndex, action, actionParameter)
                else
                    ShopUI.Exit()
                end
            end
        else
            ShopUI.Events.HandleItemSelect(selectedIndex, action, actionParameter)
        end
    end

    -- Happens when an item is unfocused/unhighlighted
    if self:IsFlagSet(FLAG.UNFOCUSED) then
        ShopUI.Events.HandleItemUnfocus()
    end

    -- Happens when an item is focused/highlighted
    if self:IsFlagSet(FLAG.FOCUSED) then
        ShopUI.Events.HandleItemFocus()
    end

    -- Happens when the stepper value for an item has changed
    if self:IsFlagSet(FLAG.STEPPER_DELTA_CHANGE) then
        ShopUI.Events.HandleStepperDeltaChange()
    end

    -- Happens when the user clicks on a specific palette item
    if self:IsFlagSet(FLAG.STEPPER_ABSOLUTE_CHANGE) then
        ShopUI.Events.HandleStepperAbsoluteChange()
    end

    -- Happens when a new collection has been set, usually when navigating to a new tab/page
    if self:IsFlagSet(FLAG.NEW_COLLECTION) then
        local collectionId = ShopEvents.collectionId

        if VirtualCollectionExists(collectionId) then
            local count = #ShopNavigator:getCurrentItems()
            VirtualCollectionSetSize(collectionId, count)
        else
            print("[NativeShop] Collection does not exist: " .. tostring(collectionId))
        end

        local entry = self.entryFocusIndex
        ShopUI.SetIndex(entry - 1)
    end

    -- Happens when the UI requests more items to be added to the current collection
    if self:IsFlagSet(FLAG.COLLECTION_REQUEST) then
        ShopUI.CreateItemListBinding()

        local result = ShopUI.Builder.AddItemsToSceneWithinRange(
            ShopEvents.collectionStartIndex,
            ShopEvents.collectionRequestParameter
        )

        if type(result) == "number" and result <= 0 then
            print("[NativeShop] Failed to add items to collection:")
            print("  Start Index: " .. tostring(ShopEvents.collectionStartIndex))
            print("  Request Parameter: " .. tostring(ShopEvents.collectionRequestParameter))
        end
    end

    if self:IsFlagSet(FLAG.TOAST_INTERACTION) then
        ShopUI.Events.HandleToastInteraction(
            ShopEvents.toastParameter1,
            ShopEvents.toastParameter2
        )
    end
end

function ShopData:DisableControls()
    local CONTROLS <const> = {
        "INPUT_AIM",
        "INPUT_ATTACK",
        "INPUT_ATTACK2",
        "INPUT_COVER",
        "INPUT_ENTER",
        "INPUT_FRONTEND_PAUSE",
        "INPUT_FRONTEND_PAUSE_ALTERNATE",
        "INPUT_HORSE_AIM",
        "INPUT_HORSE_ATTACK",
        "INPUT_HORSE_JUMP",
        "INPUT_HORSE_SPRINT",
        "INPUT_INTERACT_LOCKON",
        "INPUT_JUMP",
        "INPUT_LOOT",
        "INPUT_MAP",
        "INPUT_MELEE_ATTACK",
        "INPUT_MELEE_GRAPPLE",
        "INPUT_NEXT_CAMERA",
        "INPUT_OPEN_JOURNAL",
        "INPUT_OPEN_SATCHEL_MENU",
        "INPUT_OPEN_WHEEL_MENU",
        "INPUT_PHONE",
        "INPUT_PICKUP",
        "INPUT_PICKUP_CARRIABLE",
        "INPUT_PICKUP_CARRIABLE2",
        "INPUT_PLAYER_MENU",
        "INPUT_QUICK_SHORTCUT_ABILITIES_MENU",
        "INPUT_RADIAL_MENU_SLOT_NAV_NEXT",
        "INPUT_RADIAL_MENU_SLOT_NAV_PREV",
        "INPUT_REVEAL_HUD",
        "INPUT_SELECT_ITEM_WHEEL",
        "INPUT_SELECT_NEXT_WEAPON",
        "INPUT_SELECT_PREV_WEAPON",
        "INPUT_SELECT_RADAR_MODE",
        "INPUT_SELECT_WEAPON_MELEE",
        "INPUT_SPECIAL_ABILITY",
        "INPUT_SPECIAL_ABILITY_ACTION",
        "INPUT_SPECIAL_ABILITY_SECONDARY",
        "INPUT_SECONDARY_SPECIAL_ABILITY_SECONDARY",
        "INPUT_SPRINT",
        "INPUT_TOGGLE_HOLSTER",
    }

    for _, control in ipairs(CONTROLS) do
        DisableControlAction(0, control, true)
    end
end
