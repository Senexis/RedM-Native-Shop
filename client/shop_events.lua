ShopEvents = {
    FLAG_FOCUSED = 1 << 1,
    FLAG_PALETTE_CHANGED = 1 << 2,
    FLAG_ITEM_SELECTED = 1 << 3,
    -- FLAG_NEXT_ACTIVITY is unused
    FLAG_NEXT_PAGE = 1 << 5,
    FLAG_FILTER_CHANGED = 1 << 6,
    FLAG_NEXT_SCENE = 1 << 7,
    FLAG_PREV_SCENE = 1 << 8,
    FLAG_EXIT = 1 << 9,
    FLAG_STATE_CHANGED = 1 << 10,
    FLAG_NEW_COLLECTION = 1 << 12,
    FLAG_COLLECTION_REQUEST = 1 << 13,
    FLAG_STEPPER_DELTA_CHANGE = 1 << 14,
    FLAG_UNFOCUSED = 1 << 15,
}

ShopEvents.state = {
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
    collectionRequestParameter = 0
}

function ShopEvents.PopEventFlags()
    local flags = ShopEvents.state.eventFlags
    ShopEvents.state.eventFlags = 0
    return flags
end

function ShopEvents.GetEventFlag(flag)
    return ShopEvents.state.eventFlags & flag ~= 0
end

function ShopEvents.SetEventFlag(flag)
    ShopEvents.state.eventFlags = ShopEvents.state.eventFlags | flag
    return ShopEvents.state.eventFlags
end

function ShopEvents.GetUiEventType(id)
    local types = {
        [`NEW_PAGE`]                     = "NEW_PAGE",
        [`ITEM_FOCUSED`]                 = "ITEM_FOCUSED",
        [`ITEM_HOLD_ACTION_CANCELLED`]   = "ITEM_HOLD_ACTION_CANCELLED",
        [`FEED_MESSAGE_INTERACTED`]      = "FEED_MESSAGE_INTERACTED",
        [`ITEM_SELECTED`]                = "ITEM_SELECTED",
        [`DATA_ADJUSTABLE_CHANGED`]      = "DATA_ADJUSTABLE_CHANGED",
        [`TAB_PAGE_DECREMENT`]           = "TAB_PAGE_DECREMENT",
        [`ITEM_UNFOCUSED`]               = "ITEM_UNFOCUSED",
        [`PAGED_COLLECTION_INITIALIZED`] = "PAGED_COLLECTION_INITIALIZED",
        [`PAGED_COLLECTION_RESET`]       = "PAGED_COLLECTION_RESET",
        [`PAGED_COLLECTION_REQUEST`]     = "PAGED_COLLECTION_REQUEST",
        [`TAB_PAGE_INCREMENT`]           = "TAB_PAGE_INCREMENT",
        [`NEW_ACTIVITY`]                 = "NEW_ACTIVITY",
    }

    return types[id]
end

function ShopEvents.GetHashParameterType(id)
    local types = {
        [`GENERIC_SHOP_UI_BYPASS`]            = "GENERIC_SHOP_UI_BYPASS",
        [`GENERIC_SHOP_UI_ENTRY`]             = "GENERIC_SHOP_UI_ENTRY",
        [`GENERIC_SHOP_UI_EXIT`]              = "GENERIC_SHOP_UI_EXIT",
        [`GENERIC_SHOP_UI_HAIR_STEPPER`]      = "GENERIC_SHOP_UI_HAIR_STEPPER",
        [`GENERIC_SHOP_UI_NEXT_PAGE`]         = "GENERIC_SHOP_UI_NEXT_PAGE",
        [`GENERIC_SHOP_UI_NEXT_SCENE`]        = "GENERIC_SHOP_UI_NEXT_SCENE",
        [`GENERIC_SHOP_UI_PALETTE_FOCUS`]     = "GENERIC_SHOP_UI_PALETTE_FOCUS",
        [`GENERIC_SHOP_UI_PALETTE_FOCUSLESS`] = "GENERIC_SHOP_UI_PALETTE_FOCUSLESS",
        [`GENERIC_SHOP_UI_PREV_SCENE`]        = "GENERIC_SHOP_UI_PREV_SCENE",
        [`GENERIC_SHOP_UI_SECONDARY_SELECT`]  = "GENERIC_SHOP_UI_SECONDARY_SELECT",
        [`GENERIC_SHOP_UI_SELECT`]            = "GENERIC_SHOP_UI_SELECT",
        [`GENERIC_SHOP_UI_SELECT_INFO`]       = "GENERIC_SHOP_UI_SELECT_INFO",
        [`GENERIC_SHOP_UI_SELECT_MODIFY`]     = "GENERIC_SHOP_UI_SELECT_MODIFY",
        [`GENERIC_SHOP_UI_SELECT_OPTION`]     = "GENERIC_SHOP_UI_SELECT_OPTION",
        [`GENERIC_SHOP_UI_SELECT_TOGGLE`]     = "GENERIC_SHOP_UI_SELECT_TOGGLE",
        [`GENERIC_SHOP_UI_STEPPER`]           = "GENERIC_SHOP_UI_STEPPER",
    }

    return types[id]
end

---Ensures that the focused item datastore is valid and accessible.
---Resolves a bug that occurs when filtering pages where the focused item datastore becomes incorrect.
---Attempts to recalculate the correct datastore from the item list using index normalization.
---@return boolean True if the focused item datastore is valid/resolved, false otherwise
function ShopEvents.EnsureFocusedItemDatastore()
    if DatabindingIsEntryValid(ShopEvents.state.focusedDatastore) == 1 then
        return true
    end

    if DatabindingIsEntryValid(ShopUI.bindings.dsuItemList) ~= 1 then
        print("[NativeShop] Item list datastore is invalid, cannot resolve focused item datastore.")
        return false
    end

    -- Get the current focused item index and collection start position
    local focusedIndex = ShopEvents.state.focusedIndex
    local collectionStart = ShopEvents.state.collectionStartIndex
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

    ShopEvents.state.focusedDatastore = datastore
    return true
end

function ShopEvents.ReadDataString(datastore, key)
    -- _DATABINDING_READ_DATA_STRING_FROM_PARENT: Helper for this native doesn't return string
    return Citizen.InvokeNative(0x6323AD277C4A2AFB, datastore, key, Citizen.ResultAsString())
end

function ShopEvents.GetItemId(entry)
    return ShopEvents.ReadDataString(entry, "uiItemID")
end

function ShopEvents.GetItemType(entry)
    return ShopEvents.ReadDataString(entry, "uiItemType")
end

function ShopEvents.GetFocusedItemId()
    return ShopEvents.GetItemId(ShopEvents.state.focusedDatastore)
end

function ShopEvents.GetFocusedItemType()
    return ShopEvents.GetItemType(ShopEvents.state.focusedDatastore)
end

function ShopEvents.GetUnfocusedItemId()
    return ShopEvents.GetItemId(ShopEvents.state.unfocusedDatastore)
end

function ShopEvents.GetUnfocusedItemType()
    return ShopEvents.GetItemType(ShopEvents.state.unfocusedDatastore)
end

function ShopEvents.GetSelectedItemId()
    return ShopEvents.GetItemId(ShopEvents.state.selectedDatastore)
end

function ShopEvents.GetSelectedItemType()
    return ShopEvents.GetItemType(ShopEvents.state.selectedDatastore)
end

function ShopEvents.GetSelectedTargetMenu()
    return DatabindingReadDataIntFromParent(ShopEvents.state.selectedDatastore, "MenuIndex")
end

CreateThread(function()
    while true do
        if IsUiappRunning("shop_menu") ~= 1 then
            Wait(25)
            goto continue
        end

        -- Check condition for processing events
        local shouldSkipProcessing = ShopEvents.GetEventFlag(ShopEvents.FLAG_STATE_CHANGED) or (ShopEvents.GetEventFlag(ShopEvents.FLAG_NEXT_PAGE) and ShopEvents.GetEventFlag(ShopEvents.FLAG_FILTER_CHANGED))

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

                local eventType = ShopEvents.GetUiEventType(eventHash)
                local hashParameterType = ShopEvents.GetHashParameterType(hashParameter)

                if eventType == "TAB_PAGE_DECREMENT" or eventType == "TAB_PAGE_INCREMENT" then
                    ShopEvents.SetEventFlag(ShopEvents.FLAG_FILTER_CHANGED)
                    ShopEvents.SetEventFlag(ShopEvents.FLAG_STATE_CHANGED)
                elseif eventType == "DATA_ADJUSTABLE_CHANGED" then
                    ShopEvents.state.adjustableIndex = intParameter
                    ShopEvents.state.adjustableParameter = hashParameter

                    if DatabindingIsEntryValid(datastoreId) == 1 then
                        ShopEvents.state.focusedDatastore = datastoreId
                    end

                    ShopEvents.SetEventFlag(ShopEvents.FLAG_STEPPER_DELTA_CHANGE)
                    ShopEvents.SetEventFlag(ShopEvents.FLAG_STATE_CHANGED)
                elseif eventType == "ITEM_FOCUSED" then
                    ShopEvents.state.focusedDatastore = datastoreId
                    ShopEvents.state.focusedIndex = intParameter
                    ShopEvents.state.focusedItem = ShopEvents.GetFocusedItemId()

                    -- When pages are changed, the focused datastore ID is the previous (incorrect) store
                    -- To prevent the affecting our events, we check if it is valid or restore from index
                    if ShopEvents.EnsureFocusedItemDatastore() then
                        if hashParameterType == "GENERIC_SHOP_UI_NEXT_PAGE" then
                            ShopEvents.SetEventFlag(ShopEvents.FLAG_NEXT_PAGE)
                        else
                            ShopEvents.SetEventFlag(ShopEvents.FLAG_FOCUSED)
                        end

                        ShopEvents.SetEventFlag(ShopEvents.FLAG_STATE_CHANGED)
                    else
                        print("[NativeShop] Focused item datastore could not be resolved:")
                        print("  Datastore ID: " .. tostring(datastoreId))
                        print("  Index: " .. tostring(ShopEvents.state.focusedIndex))
                        print("  Item ID: " .. tostring(ShopEvents.state.focusedItem))
                    end
                elseif eventType == "ITEM_UNFOCUSED" then
                    ShopEvents.state.unfocusedDatastore = datastoreId
                    ShopEvents.state.unfocusedIndex = intParameter
                    ShopEvents.state.unfocusedItem = ShopEvents.GetUnfocusedItemId()

                    ShopEvents.SetEventFlag(ShopEvents.FLAG_UNFOCUSED)
                    ShopEvents.SetEventFlag(ShopEvents.FLAG_STATE_CHANGED)
                elseif eventType == "ITEM_SELECTED" then
                    ShopEvents.state.selectedDatastore = datastoreId
                    ShopEvents.state.selectedIndex = intParameter
                    ShopEvents.state.selectedItem = ShopEvents.GetSelectedItemId()

                    if hashParameterType == "GENERIC_SHOP_UI_EXIT" then
                        ShopEvents.SetEventFlag(ShopEvents.FLAG_EXIT)
                    end

                    local actionParameter = nil
                    if hashParameterType == "GENERIC_SHOP_UI_SELECT_MODIFY" then
                        if IsControlJustPressed(0, "INPUT_GAME_MENU_TAB_LEFT") then
                            actionParameter = -1
                        elseif IsControlJustPressed(0, "INPUT_GAME_MENU_TAB_RIGHT") then
                            actionParameter = 1
                        end
                    end

                    ShopEvents.state.lastAction = hashParameterType
                    ShopEvents.state.lastActionParameter = actionParameter

                    ShopEvents.SetEventFlag(ShopEvents.FLAG_ITEM_SELECTED)
                    ShopEvents.SetEventFlag(ShopEvents.FLAG_STATE_CHANGED)
                elseif eventType == "NEW_PAGE" then
                    if hashParameterType == "GENERIC_SHOP_UI_NEXT_SCENE" then
                        ShopEvents.SetEventFlag(ShopEvents.FLAG_NEXT_SCENE)
                    elseif hashParameterType == "GENERIC_SHOP_UI_PREV_SCENE" then
                        ShopEvents.SetEventFlag(ShopEvents.FLAG_PREV_SCENE)
                    elseif hashParameterType == "GENERIC_SHOP_UI_NEXT_PAGE" then
                        ShopEvents.SetEventFlag(ShopEvents.FLAG_NEXT_SCENE)
                    end
                    ShopEvents.SetEventFlag(ShopEvents.FLAG_STATE_CHANGED)
                elseif eventType == "NEW_ACTIVITY" then
                    if hashParameterType == "GENERIC_SHOP_UI_ENTRY" then
                        ShopEvents.state.flagUiEntry = true
                    elseif hashParameterType == "GENERIC_SHOP_UI_BYPASS" then
                        if ShopEvents.state.flagUiEntry then
                            ShopEvents.state.flagUiEntry = false
                            ShopEvents.state.flagUiBypass = false
                        else
                            ShopEvents.state.flagUiBypass = true
                        end
                    end
                elseif eventType == "PAGED_COLLECTION_RESET" then
                    ShopEvents.state.collectionId = hashParameter
                    ShopEvents.SetEventFlag(ShopEvents.FLAG_NEW_COLLECTION)
                    ShopEvents.SetEventFlag(ShopEvents.FLAG_STATE_CHANGED)
                elseif eventType == "PAGED_COLLECTION_INITIALIZED" then
                    ShopEvents.state.collectionId = hashParameter
                    ShopEvents.SetEventFlag(ShopEvents.FLAG_NEW_COLLECTION)
                    ShopEvents.SetEventFlag(ShopEvents.FLAG_STATE_CHANGED)
                elseif eventType == "PAGED_COLLECTION_REQUEST" then
                    ShopEvents.state.collectionRequestParameter = hashParameter
                    ShopEvents.state.collectionStartIndex = intParameter
                    ShopEvents.SetEventFlag(ShopEvents.FLAG_COLLECTION_REQUEST)
                    ShopEvents.SetEventFlag(ShopEvents.FLAG_STATE_CHANGED)
                else
                    print("[NativeShop] Received unhandled event type:")
                    print("  Event ID: " .. tostring(eventHash))
                    print("  Event Type: " .. tostring(eventType))
                    print("  Hash Parameter: " .. tostring(hashParameter))
                    print("  Hash Parameter Type: " .. tostring(hashParameterType))
                    print("  Int Parameter: " .. tostring(intParameter))
                    print("  Datastore ID: " .. tostring(datastoreId))
                end
            end

            EventsUiPopMessage(`generic_shop_ui_events`)
        end

        Wait(0)
        ::continue::
    end
end)
