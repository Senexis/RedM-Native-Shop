ShopEvents = {
    flags = 0,

    lastAction = nil,
    lastActionParameter = nil,

    selectedIndex = 0,
    selectedItem = 0,
    selectedDatastore = 0,

    focusedIndex = 0,
    focusedItem = 0,
    focusedDatastore = 0,

    unfocusedIndex = 0,
    unfocusedItem = 0,
    unfocusedDatastore = 0,

    adjustableIndex = 0,
    adjustableParameter = 0,

    collectionId = -1,
    collectionStartIndex = 0,
    collectionRequestParameter = 0,

    toastParameter1 = 0,
    toastParameter2 = 0,
}

function ShopEvents:PopEventFlags()
    local flags = self.flags
    self.flags = 0
    return flags
end

function ShopEvents:IsFlagSet(flag)
    return (self.flags & flag) ~= 0
end

function ShopEvents:SetFlag(flag)
    self.flags = self.flags | flag
end

function ShopEvents:ClearFlag(flag)
    self.flags = self.flags & ~flag
end

---Ensures that the focused item datastore is valid and accessible.
---Resolves a bug that occurs when filtering pages where the focused item datastore becomes incorrect.
---Attempts to recalculate the correct datastore from the item list using index normalization.
---@return boolean datastoreValid Returns true if the focused item datastore is valid, false otherwise.
function ShopEvents:EnsureFocusedItemDatastore()
    if DatabindingIsEntryValid(self.focusedDatastore) == 1 then
        return true
    end

    if DatabindingIsEntryValid(ShopUI.bindings.dsuItemList) ~= 1 then
        print("[NativeShop] Item list datastore is invalid, cannot resolve focused item datastore.")
        return false
    end

    -- Get the current focused item index and collection start position
    local focusedIndex = self.focusedIndex
    local collectionStart = self.collectionStartIndex
    local normalizedIndex = focusedIndex - collectionStart

    -- Handle special case when collection has negative start index
    -- This can occur with UI pagination/scrolling where the collection
    -- represents a view window into a larger dataset
    if collectionStart < 0 then
        -- Calculate offset from the absolute start position
        local offsetFromAbsoluteStart = ((collectionStart * -1) - focusedIndex)

        -- Recalculate normalized index using the absolute positioning
        normalizedIndex = ((collectionStart * -1) - offsetFromAbsoluteStart)
    end

    local itemCount = DatabindingGetArrayCount(ShopUI.bindings.dsuItemList)

    if itemCount < 1 then
        print("[NativeShop] Item list is empty, cannot resolve focused item datastore.")
        return false
    end

    if normalizedIndex >= itemCount or normalizedIndex < 0 then
        print("[NativeShop] Focused item index is out of bounds, cannot resolve focused item datastore.")
        return false
    end

    local datastore = DatabindingGetItemContextByIndex(ShopUI.bindings.dsuItemList, normalizedIndex)

    if DatabindingIsEntryValid(datastore) ~= 1 then
        print("[NativeShop] Resolved focused item datastore is invalid.")
        return false
    end

    self.focusedDatastore = datastore
    return true
end

function ShopEvents:ReadDataString(datastore, key)
    -- _DATABINDING_READ_DATA_STRING_FROM_PARENT: Helper for this native doesn't return string
    return Citizen.InvokeNative(0x6323AD277C4A2AFB, datastore, key, Citizen.ResultAsString())
end

function ShopEvents:GetItemId(entry)
    return self:ReadDataString(entry, "uiItemID")
end

function ShopEvents:GetItemType(entry)
    return self:ReadDataString(entry, "uiItemType")
end

function ShopEvents:GetFocusedItemId()
    return self:GetItemId(self.focusedDatastore)
end

function ShopEvents:GetFocusedItemType()
    return self:GetItemType(self.focusedDatastore)
end

function ShopEvents:GetUnfocusedItemId()
    return self:GetItemId(self.unfocusedDatastore)
end

function ShopEvents:GetUnfocusedItemType()
    return self:GetItemType(self.unfocusedDatastore)
end

function ShopEvents:GetSelectedItemId()
    return self:GetItemId(self.selectedDatastore)
end

function ShopEvents:GetSelectedItemType()
    return self:GetItemType(self.selectedDatastore)
end

function ShopEvents:GetSelectedTargetMenu()
    return DatabindingReadDataIntFromParent(self.selectedDatastore, "MenuIndex")
end

function ShopEvents:Maintain()
    -- Check condition for processing events
    local shouldSkipProcessing = self:IsFlagSet(FLAG.STATE_CHANGED) or (self:IsFlagSet(FLAG.NEXT_PAGE) and self:IsFlagSet(FLAG.FILTER_CHANGED))

    -- Handle all pending UI events in a loop, ensuring we process all events that occurred since the last check
    while not shouldSkipProcessing and EventsUiIsPending(`generic_shop_ui_events`) do
        local data = DataView.ArrayBuffer(8 * 4)

        if Citizen.InvokeNative(0x90237103F27F7937, `generic_shop_ui_events`, data:Buffer()) ~= 0 then -- EVENTS_UI_PEEK_MESSAGE
            local event = data:GetInt32(0)
            local index = data:GetInt32(8)
            local parameter = data:GetInt32(16)
            local datastore = data:GetInt32(24)

            local ok, error = true, nil
            if event == `TAB_PAGE_DECREMENT` or event == `TAB_PAGE_INCREMENT` then
                ok, error = pcall(self.OnTabPageChange, self, parameter, index, datastore)
            elseif event == `DATA_ADJUSTABLE_CHANGED` then
                ok, error = pcall(self.OnAdjustableChanged, self, parameter, index, datastore)
            elseif event == `DATA_ADJUSTABLE_CHANGED_ABSOLUTE` then
                ok, error = pcall(self.OnAdjustableChangedAbsolute, self, parameter, index, datastore)
            elseif event == `ITEM_FOCUSED` then
                ok, error = pcall(self.OnItemFocused, self, parameter, index, datastore)
            elseif event == `ITEM_UNFOCUSED` then
                ok, error = pcall(self.OnItemUnfocused, self, parameter, index, datastore)
            elseif event == `ITEM_SELECTED` then
                ok, error = pcall(self.OnItemSelected, self, parameter, index, datastore)
            elseif event == `NEW_PAGE` then
                ok, error = pcall(self.OnNewPage, self, parameter, index, datastore)
            elseif event == `NEW_ACTIVITY` then
                ok, error = pcall(self.OnNewActivity, self, parameter, index, datastore)
            elseif event == `PAGED_COLLECTION_RESET` or event == `PAGED_COLLECTION_INITIALIZED` then
                ok, error = pcall(self.OnCollectionReset, self, parameter, index, datastore)
            elseif event == `PAGED_COLLECTION_REQUEST` then
                ok, error = pcall(self.OnCollectionRequest, self, parameter, index, datastore)
            elseif event == `FEED_MESSAGE_INTERACTED` then
                ok, error = pcall(self.OnToastInteracted, self, parameter, index, datastore)
            end

            if not ok then
                print("[NativeShop] An error occurred while processing a shop event:")
                print("  Event: " .. tostring(event))
                print("  index Parameter: " .. tostring(index))
                print("  Hash Parameter: " .. tostring(parameter))
                print("  Datastore ID: " .. tostring(datastore))
                print("  Error: " .. tostring(error))

                -- If something went wrong, close the UI to prevent the user from getting stuck
                CloseUiappImmediate("shop_menu")
            end
        end

        EventsUiPopMessage(`generic_shop_ui_events`)
    end
end

function ShopEvents:OnTabPageChange(parameter, index, datastore)
    self:SetFlag(FLAG.FILTER_CHANGED)
    self:SetFlag(FLAG.STATE_CHANGED)
end

function ShopEvents:OnAdjustableChanged(parameter, index, datastore)
    self.adjustableIndex = index
    self.adjustableParameter = parameter

    if DatabindingIsEntryValid(datastore) == 1 then
        self.focusedDatastore = datastore
    end

    self:SetFlag(FLAG.STEPPER_DELTA_CHANGE)
    self:SetFlag(FLAG.STATE_CHANGED)
end

function ShopEvents:OnAdjustableChangedAbsolute(parameter, index, datastore)
    self.adjustableIndex = index
    self.adjustableParameter = parameter

    if DatabindingIsEntryValid(datastore) == 1 then
        self.focusedDatastore = datastore
    end

    self:SetFlag(FLAG.STEPPER_ABSOLUTE_CHANGE)
    self:SetFlag(FLAG.STATE_CHANGED)
end

function ShopEvents:OnItemFocused(parameter, index, datastore)
    parameter = UI_EVENT_PARAM:GetIdFromHash(parameter) or parameter

    self.focusedDatastore = datastore
    self.focusedIndex = index
    self.focusedItem = self:GetFocusedItemId()

    -- When pages are changed, the focused datastore ID is the previous (incorrect) store
    -- To prevent the affecting our events, we check if it is valid or restore from index
    if not self:EnsureFocusedItemDatastore() then
        print("[NativeShop] Focused item datastore could not be resolved:")
        print("  Datastore ID: " .. tostring(datastore))
        print("  Index: " .. tostring(self.focusedIndex))
        print("  Item ID: " .. tostring(self.focusedItem))
        return
    end

    if parameter == UI_EVENT_PARAM.NEXT_PAGE then
        self:SetFlag(FLAG.NEXT_PAGE)
    else
        self:SetFlag(FLAG.FOCUSED)
    end

    self:SetFlag(FLAG.STATE_CHANGED)
end

function ShopEvents:OnItemUnfocused(parameter, index, datastore)
    self.unfocusedDatastore = datastore
    self.unfocusedIndex = index
    self.unfocusedItem = self:GetUnfocusedItemId()

    self:SetFlag(FLAG.UNFOCUSED)
    self:SetFlag(FLAG.STATE_CHANGED)
end

function ShopEvents:OnItemSelected(parameter, index, datastore)
    parameter = UI_EVENT_PARAM:GetIdFromHash(parameter) or parameter

    self.selectedDatastore = datastore
    self.selectedIndex = index
    self.selectedItem = self:GetSelectedItemId()

    if parameter == UI_EVENT_PARAM.EXIT then
        self:SetFlag(FLAG.EXIT)
    end

    local actionParameter = nil
    if parameter == UI_EVENT_PARAM.SELECT_MODIFY then
        if IsControlJustPressed(0, "INPUT_GAME_MENU_TAB_LEFT") then
            actionParameter = -1
        elseif IsControlJustPressed(0, "INPUT_GAME_MENU_TAB_RIGHT") then
            actionParameter = 1
        end
    end

    self.lastAction = parameter
    self.lastActionParameter = actionParameter

    self:SetFlag(FLAG.ITEM_SELECTED)
    self:SetFlag(FLAG.STATE_CHANGED)
end

function ShopEvents:OnNewPage(parameter, index, datastore)
    parameter = UI_EVENT_PARAM:GetIdFromHash(parameter) or parameter

    if parameter == UI_EVENT_PARAM.NEXT_SCENE then
        self:SetFlag(FLAG.NEXT_SCENE)
    elseif parameter == UI_EVENT_PARAM.PREV_SCENE then
        self:SetFlag(FLAG.PREV_SCENE)
    elseif parameter == UI_EVENT_PARAM.NEXT_PAGE then
        self:SetFlag(FLAG.NEXT_SCENE)
    end

    self:SetFlag(FLAG.STATE_CHANGED)
end

function ShopEvents:OnNewActivity(parameter, index, datastore)
    parameter = UI_EVENT_PARAM:GetIdFromHash(parameter) or parameter

    if parameter == UI_EVENT_PARAM.ENTRY then
        self:SetFlag(FLAG.UI_ENTRY)
    elseif parameter == UI_EVENT_PARAM.BYPASS then
        if self:IsFlagSet(FLAG.UI_ENTRY) then
            self:ClearFlag(FLAG.UI_ENTRY)
            self:ClearFlag(FLAG.UI_BYPASS)
        else
            self:SetFlag(FLAG.UI_BYPASS)
        end
    end

    self:SetFlag(FLAG.STATE_CHANGED)
end

function ShopEvents:OnCollectionReset(parameter, index, datastore)
    self.collectionId = parameter
    self:SetFlag(FLAG.NEW_COLLECTION)
    self:SetFlag(FLAG.STATE_CHANGED)
end

function ShopEvents:OnCollectionRequest(parameter, index, datastore)
    self.collectionRequestParameter = parameter
    self.collectionStartIndex = index
    self:SetFlag(FLAG.COLLECTION_REQUEST)
    self:SetFlag(FLAG.STATE_CHANGED)
end

function ShopEvents:OnToastInteracted(parameter, index, datastore)
    -- Certain toast setups will spam interaction events, ignore subsequent events
    if self:IsFlagSet(FLAG.TOAST_INTERACTION) then
        return
    end

    -- Entry point needs to be set before opening the menu, so make an exception and set it here
    if index == `SET_ENTRY` then
        ShopData.entryFocusIndex = datastore or 1
    end

    -- Toast interactions should always open a menu, so open one through the hash parameter
    ShopUI.Open(parameter, true)

    self.toastParameter1 = index
    self.toastParameter2 = datastore
    self:SetFlag(FLAG.TOAST_INTERACTION)
    self:SetFlag(FLAG.STATE_CHANGED)
end

CreateThread(function()
    while true do
        if IsUiappRunning("shop_menu") ~= 1 and IsUiappTransitioningByHash("shop_menu") ~= 1 then
            Wait(250)
            goto continue
        end

        ShopEvents:Maintain()
        ShopData:Maintain()

        Wait(0)
        ::continue::
    end
end)
