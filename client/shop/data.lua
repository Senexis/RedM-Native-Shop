local CURRENT_RESOURCE <const> = GetCurrentResourceName()
local DISABLED_CONTROLS <const> = {
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

ShopData = {
    flags = 0,
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
    return self.flags & flag ~= 0
end

function ShopData:Maintain()
    if not self.hasUiInitialized then
        self:InitializeUi()
        return
    end

    self:UpdateActiveMenu()
    if not self.rootMenu or not self.currentMenu then
        return
    end

    self:MaintainControls()
    self:MaintainCamera()

    self:ProcessMenuTick()
    self:ProcessHoldToExit()
    self:ProcessEventFlags()
end

function ShopData:InitializeUi()
    ShopUI.Initialize()

    -- Instead of creating a new data view every frame, do it once
    local struct = DataView.ArrayBuffer(128)
    struct:SetString(0, "mp@spinning_orbit_cam")
    struct:SetString(64, "SPINNING_ORBIT_REQUEST")

    self.orbitCameraData = struct:Buffer()
    self.hasUiInitialized = true
end

function ShopData:UpdateActiveMenu()
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
end

function ShopData:MaintainControls()
    if self.shuttingDown or not self.rootMenu or not self.currentMenu then
        return
    end

    if self.rootMenu.AllowWalking then
        SetControlContext(9, "OnlinePlayerMenu")
        SetControlContext(10, 0)
    end

    -- Disable controls that would interfere with the shop UI
    for _, control in ipairs(DISABLED_CONTROLS) do
        DisableControlAction(0, control, true)
    end

    -- Unequip any current weapons (PLAYER::_SET_PLAYER_AIM_WEAPON)
    local playerId = PlayerId()
    Citizen.InvokeNative(0xCFFC3ECCD7A5CCEB, playerId, `WEAPON_UNARMED`, 0)
    Citizen.InvokeNative(0xCFFC3ECCD7A5CCEB, playerId, `WEAPON_UNARMED`, 1)

    -- Disables miscellaneous prompts
    UiPromptEnablePromptTypeThisFrame(0)
end

function ShopData:MaintainCamera()
    if self.shuttingDown or not self.rootMenu or not self.currentMenu then
        return
    end

    if not self.rootMenu.RepositionCamera then
        return
    end

    -- Use orbit camera (focuses the camera properly) when in the shop UI
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

function ShopData:ProcessMenuTick()
    if self.shuttingDown or not self.rootMenu or not self.currentMenu then
        return
    end

    if not self.currentMenu.Tick then
        return
    end

    local waitMs = self.currentMenu.TickMs or 1000
    if waitMs < 0 then waitMs = 0 end

    local currentTime = GetGameTimer()
    if (currentTime - self.onTickTimestamp) >= waitMs then
        CreateThread(function()
            if IsUiappTransitioningByHash("shop_menu") == 1 then return end

            self.onTickRunning = true

            local resourceName = ShopNavigator:getCurrentResourceName()
            self:SafeInvoke(resourceName, self.currentMenu.Tick)

            self.onTickRunning = false
        end)

        self.onTickTimestamp = currentTime
    end
end

function ShopData:ProcessHoldToExit()
    if self.shuttingDown or not self.rootMenu or not self.currentMenu then
        return
    end

    if not Config.HoldToExit then
        return
    end

    if self.rootMenu.PreventHoldToExit or self.currentMenu.PreventHoldToExit then
        return
    end

    if IsUiappTransitioningByHash("shop_menu") == 1 then
        self.holdToExitStart = nil
        self.holdToExitPromptShown = false
        return
    end

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
    elseif not backHeld and self.holdToExitStart then
        self.holdToExitStart = nil
        self.holdToExitPromptShown = false
        ShopUI.Prompts.UpdateBackPrompt()
    end
end

function ShopData:ProcessEventFlags()
    -- Get the flags and clear the event handler's flags for the next frame
    self.flags = ShopEvents:PopEventFlags()

    if not self:IsFlagSet(FLAG.STATE_CHANGED) then
        return
    end

    if self:IsFlagSet(FLAG.NEXT_SCENE) or self:IsFlagSet(FLAG.PREV_SCENE) then
        local ok, error = pcall(self.OnNavigateScene, self)
        if not ok then
            print("[NativeShop] Error navigating to new scene: " .. tostring(error))
            CloseUiappByHash("shop_menu")
        end
    end

    if self:IsFlagSet(FLAG.NEXT_PAGE) or self:IsFlagSet(FLAG.FILTER_CHANGED) then
        local ok, error = pcall(self.OnNavigateTab, self)
        if not ok then
            print("[NativeShop] Error navigating to new tab: " .. tostring(error))
            CloseUiappByHash("shop_menu")
        end
    end

    if self:IsFlagSet(FLAG.ITEM_SELECTED) then
        local ok, error = pcall(self.OnItemSelected, self)
        if not ok then
            print("[NativeShop] Error selecting item: " .. tostring(error))
            CloseUiappByHash("shop_menu")
        end
    end

    if self:IsFlagSet(FLAG.UNFOCUSED) then
        local ok, error = pcall(self.OnItemUnfocused, self)
        if not ok then
            print("[NativeShop] Error unfocusing item: " .. tostring(error))
            CloseUiappByHash("shop_menu")
        end
    end

    if self:IsFlagSet(FLAG.FOCUSED) then
        local ok, error = pcall(self.OnItemFocused, self)
        if not ok then
            print("[NativeShop] Error focusing item: " .. tostring(error))
            CloseUiappByHash("shop_menu")
        end
    end

    if self:IsFlagSet(FLAG.STEPPER_DELTA_CHANGE) then
        local ok, error = pcall(self.OnStepperDeltaChange, self)
        if not ok then
            print("[NativeShop] Error changing stepper delta: " .. tostring(error))
            CloseUiappByHash("shop_menu")
        end
    end

    if self:IsFlagSet(FLAG.STEPPER_ABSOLUTE_CHANGE) then
        local ok, error = pcall(self.OnStepperAbsoluteChange, self)
        if not ok then
            print("[NativeShop] Error changing stepper absolute: " .. tostring(error))
            CloseUiappByHash("shop_menu")
        end
    end

    if self:IsFlagSet(FLAG.NEW_COLLECTION) then
        local ok, error = pcall(self.OnNewCollection, self)
        if not ok then
            print("[NativeShop] Error handling new collection: " .. tostring(error))
            CloseUiappByHash("shop_menu")
        end
    end

    if self:IsFlagSet(FLAG.COLLECTION_REQUEST) then
        local ok, error = pcall(self.OnCollectionRequest, self)
        if not ok then
            print("[NativeShop] Error handling collection request: " .. tostring(error))
            CloseUiappByHash("shop_menu")
        end
    end

    if self:IsFlagSet(FLAG.TOAST_INTERACTION) then
        local ok, error = pcall(self.OnToastInteraction, self)
        if not ok then
            print("[NativeShop] Error handling toast interaction: " .. tostring(error))
            CloseUiappByHash("shop_menu")
        end
    end
end

function ShopData:OnNavigateScene()
    ShopUI.ResetScene()

    local activeMenu = self.currentMenu or self.rootMenu
    if not activeMenu then
        return
    end

    local scene = activeMenu.Scene or "MENU_LIST"

    local result = ShopUI.Builder.BuildScene(scene, activeMenu)
    if not result then
        print("[NativeShop] Failed to build scene: " .. tostring(scene))
        ShopUI.Exit()
        return
    end

    ShopUI.EnterScene(scene)

    if not self.hasEnteredFirstScene then
        self.hasEnteredFirstScene = true
    end
end

function ShopData:OnNavigateTab()
    local collectionId = ShopEvents.collectionId
    if VirtualCollectionExists(collectionId) ~= 1 then
        return
    end

    local index = DatabindingReadDataIntFromParent(ShopUI.bindings.dscMain, "PageFilterCurrentPageIndex")

    local result = ShopNavigator:navigateTabs(index + 1)
    if not result then
        print("[NativeShop] Failed to navigate to tab index: " .. tostring(index))
        return
    end

    ShopUI.UpdateSubheader()
    VirtualCollectionReset(collectionId)

    self.entryFocusIndex = 1
    ShopUI.state.currentItemEntriesByIndex = {}
    ShopUI.state.currentItemIndecesById = {}
end

function ShopData:OnItemSelected()
    local activeMenu = self.currentMenu or self.rootMenu
    if not activeMenu then
        return
    end

    local action = ShopEvents.lastAction
    local actionParameter = ShopEvents.lastActionParameter
    local selectedIndex = ShopEvents.selectedIndex

    if not self:IsFlagSet(FLAG.EXIT) then
        ShopUI.Events.HandleItemSelect(selectedIndex, action, actionParameter)
        return
    end

    if
        not activeMenu.Prompts or
        not activeMenu.Prompts.Back or
        (activeMenu.Prompts.Back.Visible ~= false and activeMenu.Prompts.Back.Enabled ~= false)
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
end

function ShopData:OnItemUnfocused()
    ShopUI.Events.HandleItemUnfocus()
end

function ShopData:OnItemFocused()
    ShopUI.Events.HandleItemFocus()
end

function ShopData:OnStepperDeltaChange()
    ShopUI.Events.HandleStepperDeltaChange()
end

function ShopData:OnStepperAbsoluteChange()
    ShopUI.Events.HandleStepperAbsoluteChange()
end

function ShopData:OnNewCollection()
    local collectionId = ShopEvents.collectionId
    if VirtualCollectionExists(collectionId) ~= 1 then
        return
    end

    local count = #ShopNavigator:getCurrentItems()
    VirtualCollectionSetSize(collectionId, count)

    local entry = self.entryFocusIndex
    ShopUI.SetIndex(entry - 1)
end

function ShopData:OnCollectionRequest()
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

function ShopData:OnToastInteraction()
    ShopUI.Events.HandleToastInteraction(
        ShopEvents.toastParameter1,
        ShopEvents.toastParameter2
    )
end
