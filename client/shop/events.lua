ShopEvents = {
    eventFlags = 0,
    lastAction = nil,
    lastActionParameter = nil,
    flagUiBypass = false,
    flagUiEntry = false,
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
    paletteIndex = 0,
    collectionId = -1,
    collectionStartIndex = 0,
    collectionRequestParameter = 0,
    toastParameter1 = 0,
    toastParameter2 = 0,
}

function ShopEvents:PopEventFlags()
    local flags = self.eventFlags
    self.eventFlags = 0
    return flags
end

function ShopEvents:IsFlagSet(flag)
    return self.eventFlags & flag ~= 0
end

function ShopEvents:SetFlag(flag)
    self.eventFlags = self.eventFlags | flag
    return self.eventFlags
end

---Ensures that the focused item datastore is valid and accessible.
---Resolves a bug that occurs when filtering pages where the focused item datastore becomes incorrect.
---Attempts to recalculate the correct datastore from the item list using index normalization.
---@return boolean True if the focused item datastore is valid/resolved, false otherwise
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
    if IsUiappRunning("shop_menu") ~= 1 then
        Wait(250)
        return
    end

    -- Check condition for processing events
    local shouldSkipProcessing = self:IsFlagSet(FLAG.STATE_CHANGED) or (self:IsFlagSet(FLAG.NEXT_PAGE) and self:IsFlagSet(FLAG.FILTER_CHANGED))

    -- Handle all pending UI events in a loop, ensuring we process all events that occurred since the last check
    while not shouldSkipProcessing and EventsUiIsPending(`generic_shop_ui_events`) do
        local msg = DataView.ArrayBuffer(8 * 4)
        msg:SetInt32(0, 0)
        msg:SetInt32(8, 0)
        msg:SetInt32(16, 0)
        msg:SetInt32(24, 0)

        if Citizen.InvokeNative(0x90237103F27F7937, `generic_shop_ui_events`, msg:Buffer()) ~= 0 then -- EVENTS_UI_PEEK_MESSAGE
            local eventHash = msg:GetInt32(0)
            local intParameter = msg:GetInt32(8)
            local hashParameter = msg:GetInt32(16)
            local datastoreId = msg:GetInt32(24)

            local eventType = UI_EVENT:GetIdFromHash(eventHash)
            local eventParameter = UI_EVENT_PARAM:GetIdFromHash(hashParameter)

            if eventType == UI_EVENT.TAB_PAGE_DECREMENT or eventType == UI_EVENT.TAB_PAGE_INCREMENT then
                self:SetFlag(FLAG.FILTER_CHANGED)
                self:SetFlag(FLAG.STATE_CHANGED)
            elseif eventType == UI_EVENT.DATA_ADJUSTABLE_CHANGED or eventType == UI_EVENT.DATA_ADJUSTABLE_CHANGED_ABSOLUTE then
                self.adjustableIndex = intParameter
                self.adjustableParameter = hashParameter

                if DatabindingIsEntryValid(datastoreId) == 1 then
                    self.focusedDatastore = datastoreId
                end

                if eventType == UI_EVENT.DATA_ADJUSTABLE_CHANGED then
                    self:SetFlag(FLAG.STEPPER_DELTA_CHANGE)
                else
                    self:SetFlag(FLAG.STEPPER_ABSOLUTE_CHANGE)
                end
                self:SetFlag(FLAG.STATE_CHANGED)
            elseif eventType == UI_EVENT.ITEM_FOCUSED then
                self.focusedDatastore = datastoreId
                self.focusedIndex = intParameter
                self.focusedItem = self:GetFocusedItemId()

                -- When pages are changed, the focused datastore ID is the previous (incorrect) store
                -- To prevent the affecting our events, we check if it is valid or restore from index
                if self:EnsureFocusedItemDatastore() then
                    if eventParameter == UI_EVENT_PARAM.NEXT_PAGE then
                        self:SetFlag(FLAG.NEXT_PAGE)
                    else
                        self:SetFlag(FLAG.FOCUSED)
                    end

                    self:SetFlag(FLAG.STATE_CHANGED)
                else
                    print("[NativeShop] Focused item datastore could not be resolved:")
                    print("  Datastore ID: " .. tostring(datastoreId))
                    print("  Index: " .. tostring(self.focusedIndex))
                    print("  Item ID: " .. tostring(self.focusedItem))
                end
            elseif eventType == UI_EVENT.ITEM_UNFOCUSED then
                self.unfocusedDatastore = datastoreId
                self.unfocusedIndex = intParameter
                self.unfocusedItem = self:GetUnfocusedItemId()

                self:SetFlag(FLAG.UNFOCUSED)
                self:SetFlag(FLAG.STATE_CHANGED)
            elseif eventType == UI_EVENT.ITEM_SELECTED then
                self.selectedDatastore = datastoreId
                self.selectedIndex = intParameter
                self.selectedItem = self:GetSelectedItemId()

                if eventParameter == UI_EVENT_PARAM.EXIT then
                    self:SetFlag(FLAG.EXIT)
                end

                local actionParameter = nil
                if eventParameter == UI_EVENT_PARAM.SELECT_MODIFY then
                    if IsControlJustPressed(0, "INPUT_GAME_MENU_TAB_LEFT") then
                        actionParameter = -1
                    elseif IsControlJustPressed(0, "INPUT_GAME_MENU_TAB_RIGHT") then
                        actionParameter = 1
                    end
                end

                self.lastAction = eventParameter
                self.lastActionParameter = actionParameter

                self:SetFlag(FLAG.ITEM_SELECTED)
                self:SetFlag(FLAG.STATE_CHANGED)
            elseif eventType == UI_EVENT.NEW_PAGE then
                if eventParameter == UI_EVENT_PARAM.NEXT_SCENE then
                    self:SetFlag(FLAG.NEXT_SCENE)
                elseif eventParameter == UI_EVENT_PARAM.PREV_SCENE then
                    self:SetFlag(FLAG.PREV_SCENE)
                elseif eventParameter == UI_EVENT_PARAM.NEXT_PAGE then
                    self:SetFlag(FLAG.NEXT_SCENE)
                end
                self:SetFlag(FLAG.STATE_CHANGED)
            elseif eventType == UI_EVENT.NEW_ACTIVITY then
                if eventParameter == UI_EVENT_PARAM.ENTRY then
                    self.flagUiEntry = true
                elseif eventParameter == UI_EVENT_PARAM.BYPASS then
                    if self.flagUiEntry then
                        self.flagUiEntry = false
                        self.flagUiBypass = false
                    else
                        self.flagUiBypass = true
                    end
                end
            elseif eventType == UI_EVENT.PAGED_COLLECTION_RESET then
                self.collectionId = hashParameter
                self:SetFlag(FLAG.NEW_COLLECTION)
                self:SetFlag(FLAG.STATE_CHANGED)
            elseif eventType == UI_EVENT.PAGED_COLLECTION_INITIALIZED then
                self.collectionId = hashParameter
                self:SetFlag(FLAG.NEW_COLLECTION)
                self:SetFlag(FLAG.STATE_CHANGED)
            elseif eventType == UI_EVENT.PAGED_COLLECTION_REQUEST then
                self.collectionRequestParameter = hashParameter
                self.collectionStartIndex = intParameter
                self:SetFlag(FLAG.COLLECTION_REQUEST)
                self:SetFlag(FLAG.STATE_CHANGED)
            elseif eventType == UI_EVENT.FEED_MESSAGE_INTERACTED then
                -- Certain toast setups will spam interaction events, ignore subsequent events
                if self:IsFlagSet(FLAG.TOAST_INTERACTION) then
                    goto skip
                end

                -- Entry point needs to be set before opening the menu, so make an exception and set it here
                if intParameter == `SET_ENTRY` then
                    ShopData.entryFocusIndex = datastoreId or 1
                end

                -- Toast interactions should always open a menu, so open one through the hash param
                ShopUI.Open(hashParameter, true)

                self.toastParameter1 = intParameter
                self.toastParameter2 = datastoreId
                self:SetFlag(FLAG.TOAST_INTERACTION)
                self:SetFlag(FLAG.STATE_CHANGED)
            else
                print("[NativeShop] Received unhandled event type:")
                print("  Event ID: " .. tostring(eventHash))
                print("  Event Type: " .. tostring(eventType))
                print("  Hash Parameter: " .. tostring(hashParameter))
                print("  Hash Parameter Type: " .. tostring(eventParameter))
                print("  Int Parameter: " .. tostring(intParameter))
                print("  Datastore ID: " .. tostring(datastoreId))
            end
        end

        ::skip::
        EventsUiPopMessage(`generic_shop_ui_events`)
    end

    -- Process the events and maintain the shop state, handling any errors that may occur
    -- To save resources, we only process events while the shop UI is open or transitioning
    if IsUiappRunning("shop_menu") == 1 or IsUiappTransitioningByHash("shop_menu") == 1 then
        local success, error = pcall(ShopData.MaintainEvents, ShopData)

        -- If something went wrong, close the UI to prevent the user from getting stuck
        if not success then
            print("[NativeShop] An error occurred while processing shop events: ")
            print("  " .. tostring(error))

            CloseUiappImmediate("shop_menu")
        end
    end
end

CreateThread(function()
    while true do
        ShopEvents:Maintain()
        Wait(0)
    end
end)
