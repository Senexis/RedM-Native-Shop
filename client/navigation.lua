---@class ShopNavigator
---@field allData table A map of { [rootId] = menuData } to store all registered trees.
---@field generators table A map of { [rootId] = generatorFunction } for dynamic root menus.
---@field generatorData table A map of { [rootId] = lastLinkData } to track context for persistence.
---@field dataSources table A map of { [rootId] = { [sourceName] = getterFunction } }
---@field contextProviders table A map of { [rootId] = { [providerName] = providerFunction } }
---@field menuMap table A map of { [menuId] = menuObject } for fast static menu access.
---@field parentMap table A map of { [childId] = parentId } for back-navigation context.
---@field itemOverrides table A map of { [menuId] = itemArray } for runtime overrides.
---@field visibilityOverrides table A map of { [menuId] = boolean } for toggling visibility.
---@field history table A stack of state objects for robust back-navigation within the current tree.
---@field rootStack table A stack of state objects for cross-menu linking/back-navigation.
---@field focusMemory table A map of { [menuId] = focusIndex } to remember focus in static menus.
---@field onError function A callback for handling runtime errors gracefully.
---@field currentMenuId string|nil The ID of the currently active static menu.
---@field currentRootId string|nil The ID of the root of the currently active menu tree.
---@field currentPageIndex number The 1-based index for the active tab on a menu.
---@field currentItems table The unified list of items to be displayed by the UI.
ShopNavigator = {}

-- ===================================================================
-- Singleton State Initialization
-- ===================================================================

ShopNavigator.allData = {}
ShopNavigator.generators = {}
ShopNavigator.generatorData = {}
ShopNavigator.dataSources = {}
ShopNavigator.contextProviders = {}
ShopNavigator.menuMap = {}
ShopNavigator.parentMap = {}
ShopNavigator.itemOverrides = {}
ShopNavigator.visibilityOverrides = {}
ShopNavigator.history = {}
ShopNavigator.focusMemory = {}
ShopNavigator.rootStack = {}
ShopNavigator.currentMenuId = nil
ShopNavigator.currentRootId = nil
ShopNavigator.currentPageIndex = 1
ShopNavigator.currentItems = {}
ShopNavigator.onError = function(message)
    print("[NativeShop] " .. tostring(message))
end

-- ===================================================================
-- Private Helper Methods
-- ===================================================================

local function shallowCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        copy[k] = v
    end
    return copy
end

--- (Private) centralized logic to extract a unique identifier from a context object.
---@param context any The context data (table or primitive).
---@return string|number|nil The extracted ID or the context itself if primitive.
function ShopNavigator:_extractContextId(context)
    if type(context) == "table" then
        return context.Id or context.ID or context.id or context.uid
    end
    return context
end

--- (Private) Checks if two context objects represent the same entity.
--- Uses object equality first, then checks for matching extracted IDs.
---@param a any First context.
---@param b any Second context.
---@return boolean True if contexts are effectively the same.
function ShopNavigator:_isSameContext(a, b)
    if a == b then return true end

    local idA = self:_extractContextId(a)
    local idB = self:_extractContextId(b)

    -- Only return true if both IDs are valid (not nil) and equal
    return idA ~= nil and idB ~= nil and idA == idB
end

--- (Private) Generates a unique ID for a menu item based on the current dynamic context.
--- Appends the context ID (if available) to the base ID to ensure unique translation keys.
---@param baseId string The static ID of the menu or tab.
---@return string The unique ID string.
function ShopNavigator:_getUniqueId(baseId)
    if not baseId then return "" end

    local rootId = self.currentRootId
    local context = self.generatorData[rootId]

    if context then
        local suffix = self:_extractContextId(context)
        if suffix then
            return string.format("%s_%s", baseId, tostring(suffix))
        end
    end

    return baseId
end

--- (Private) Recursively scans the static menuData to populate lookup maps.
---@param menu table The menu definition to process.
---@param parentId string|nil The ID of the parent menu.
---@param rootId string The ID of the root menu for this tree.
function ShopNavigator:_buildLookups(menu, parentId, rootId)
    if not menu or not menu.Id or not rootId then return end

    self.menuMap[rootId] = self.menuMap[rootId] or {}
    self.parentMap[rootId] = self.parentMap[rootId] or {}

    self.menuMap[rootId][menu.Id] = menu
    self.parentMap[rootId][menu.Id] = parentId

    if menu.Items then
        for _, item in ipairs(menu.Items) do
            if item.Items or item.Tabs then
                self:_buildLookups(item, menu.Id, rootId)
            end
        end
    end
    if menu.Tabs then
        for _, tab in ipairs(menu.Tabs) do
            if tab.Items or tab.Tabs then
                self:_buildLookups(tab, menu.Id, rootId)
            end
        end
    end
end

--- (Private) Determines if a menu item should be visible.
---@param item table The item or menu object to check.
---@return boolean True if the item should be visible.
function ShopNavigator:_isItemVisible(item)
    if self.visibilityOverrides[item.Id] ~= nil then
        return self.visibilityOverrides[item.Id]
    end
    return not item.Hidden
end

--- (Private) Retrieves all items for a given menu or page object.
--- Handles static items, runtime overrides, and dynamic DataSources.
---@param menuOrPage table The menu or page object.
---@return table An array of all potential item objects.
function ShopNavigator:_getAllItemsForObject(menuOrPage)
    if not menuOrPage then return {} end
    if self.itemOverrides[menuOrPage.Id] then
        return self.itemOverrides[menuOrPage.Id]
    end

    if menuOrPage.Source then
        local rootId = self.currentRootId
        if not rootId then return {} end

        local sourceGroup = self.dataSources[rootId] or {}
        local getter = sourceGroup[menuOrPage.Source.Name]

        if getter then
            local ok, dynamicItems = pcall(getter, menuOrPage.Source.Filter)
            if ok then
                return dynamicItems or {}
            else
                self.onError("DataSource '" .. menuOrPage.Source.Name .. "' failed: " .. tostring(dynamicItems))
            end
        else
            print("[NativeShop] DataSource '" .. menuOrPage.Source.Name .. "' not found.")
        end
        return {}
    end

    return menuOrPage.Items or {}
end

--- (Private) Gets the raw menu definition object for the current state.
---@return table|nil The raw menu object.
function ShopNavigator:_getRawCurrentMenu()
    if self.currentRootId and self.currentMenuId then
        local menuTree = self.menuMap[self.currentRootId]
        if menuTree then return menuTree[self.currentMenuId] end
    end
    return nil
end

--- (Private) Processes a single item to determine navigation flags, visibility, and conflict resolution.
---@param itemData table The raw item data.
---@param menuId string The ID of the current container menu.
---@return table|nil The processed item, or nil if invisible.
function ShopNavigator:_processItem(itemData, menuId)
    if not self:_isItemVisible(itemData) then
        return nil
    end

    local processedItem = shallowCopy(itemData)
    processedItem.MenuId = menuId

    -- Warning: Check for conflict: LinkMenuId AND Items/Tabs/Source
    if processedItem.LinkMenuId and (processedItem.Items or processedItem.Tabs or processedItem.Source) then
        print("[NativeShop] Warning: Item '" .. tostring(processedItem.Id) .. "' has both LinkMenuId and Items/Tabs/Source. Ignoring items and using Link.")
        processedItem.Items = nil
        processedItem.Tabs = nil
        processedItem.Source = nil
    end

    -- Determine if this item should be treated as a navigation item
    if processedItem.Items or processedItem.Tabs or processedItem.Source then
        processedItem.HasNavigation = true
        -- Disable if empty (and not hidden logic excluded)
        if self:getItemCount(itemData.Id, self.currentRootId, { IncludeHidden = false }) == 0 then
            processedItem.Disabled = true
        end
    elseif processedItem.LinkMenuId then
        processedItem.HasNavigation = true
    elseif processedItem.Action then
        processedItem.HasNavigation = true
    end

    return processedItem
end

--- (Private) Rebuilds the `currentItems` list for the current view.
--- This combines items from the menu's `Items` list and the active `Tab`.
function ShopNavigator:_rebuildCurrentItems()
    local menu = self:_getRawCurrentMenu()
    if not menu then
        self.currentItems = {}
        return
    end

    local combinedItems = {}

    -- 1. Process the standard Items list
    local standardItems = self:_getAllItemsForObject(menu)
    for _, itemData in ipairs(standardItems) do
        local processed = self:_processItem(itemData, menu.Id)
        if processed then
            table.insert(combinedItems, processed)
        end
    end

    -- 2. Process the active Tab's items
    if menu.Tabs and #menu.Tabs > 0 then
        local activeTab = menu.Tabs[self.currentPageIndex]
        if activeTab then
            local tabItems = self:_getAllItemsForObject(activeTab)
            for _, itemData in ipairs(tabItems) do
                local processed = self:_processItem(itemData, menu.Id)
                if processed then
                    table.insert(combinedItems, processed)
                end
            end
        end
    end

    self.currentItems = combinedItems

    TriggerEvent("native_shop:page_refreshed", {
        RootId = self.currentRootId,
        Menu = self:getCurrentMenu(),
        Items = self.currentItems,
    })
end

--- (Private) Sets the navigator to a specific static menu state.
--- Handles dynamic generation if the root is a registered generator.
---@param menuId string The ID of the static menu to switch to.
---@param rootId string The root ID of the tree this menu belongs to.
---@param linkData any|nil Optional data passed if this navigation was triggered by a link.
---@return number The suggested focus index for the UI.
function ShopNavigator:_setMenuState(menuId, rootId, linkData)
    -- Handle Dynamic Generation
    if self.generators[rootId] then
        -- 1. Check if the context has changed
        -- If linkData is provided, compare it against the cached context.
        if linkData ~= nil then
            local lastData = self.generatorData[rootId]

            if not self:_isSameContext(linkData, lastData) then
                self.focusMemory[rootId] = nil -- Context switched: Reset focus
                self.generatorData[rootId] = linkData -- Update context
            end
        end

        -- 2. Execute Generator
        local contextToUse = linkData or self.generatorData[rootId]
        local success, newMenuData = pcall(self.generators[rootId], contextToUse)

        if not success or not newMenuData then
            self.onError("Generator for root '" .. rootId .. "' failed or returned nil: " .. tostring(newMenuData))
            return 1
        end

        newMenuData.Id = rootId

        -- 3. Update Lookups
        self.menuMap[rootId] = {}
        self.parentMap[rootId] = {}
        self.allData[rootId] = newMenuData
        self:_buildLookups(newMenuData, nil, rootId)
    end

    if not self.menuMap[rootId] or not self.menuMap[rootId][menuId] then
        print("[NativeShop] Attempted to set state to an invalid menu ID: " .. menuId)
        return 1
    end

    self.currentRootId = rootId
    self.currentMenuId = menuId
    self:_rebuildCurrentItems()

    return self.focusMemory[menuId] or 1
end

--- (Private) Pushes the current view's state onto the history stack.
---@param focusIndex number The UI's current focus index to save.
function ShopNavigator:_saveStateToHistory(focusIndex)
    table.insert(self.history, {
        Type = "static",
        MenuId = self.currentMenuId,
        PageIndex = self.currentPageIndex,
        FocusIndex = focusIndex
    })
end

--- (Private) Builds a history stack from a target item back to its root.
--- Used when deep-linking into a menu to simulate user navigation.
---@param targetMenuId string The ID we are jumping to.
---@param rootId string The root of the tree.
function ShopNavigator:_simulateHistoryPath(targetMenuId, rootId)
    ---@type string|nil
    local currentId = targetMenuId
    local path = {}

    -- 1. Trace parents upwards until we hit the root or nil
    while currentId do
        local parentId = self.parentMap[rootId][currentId]
        if parentId then
            table.insert(path, parentId)
            currentId = parentId
        else
            currentId = nil -- We reached the root (or orphan)
        end
    end

    -- 2. Reverse the path to push into history in correct order (Root -> Child -> TargetParent)
    for i = #path, 1, -1 do
        local ancestorId = path[i]
        table.insert(self.history, {
            Type = "static",
            MenuId = ancestorId,
            PageIndex = 1,
            FocusIndex = 1
        })
    end
end

-- ===================================================================
-- Public API
-- ===================================================================

--- Registers a static shop table.
---@param menuData table The root menu configuration object. Must have an Id.
---@param dataSources table|nil A map of { [sourceName] = getterFunction }.
---@param contextProviders table|nil A map of { [providerName] = providerFunction }.
function ShopNavigator:register(menuData, dataSources, contextProviders)
    if not menuData or not menuData.Id then
        print("[NativeShop] Registration failed. Provided menuData is invalid or has no root Id.")
        return
    end
    local rootId = menuData.Id
    if self.allData[rootId] or self.generators[rootId] then
        print("[NativeShop] A menu with root ID '" .. rootId .. "' has already been registered. Skipping.")
        return
    end
    self.allData[rootId] = menuData
    self.dataSources[rootId] = dataSources or {}
    self.contextProviders[rootId] = contextProviders or {}
    self:_buildLookups(menuData, nil, rootId)
end

--- Registers a dynamic shop generator.
---@param rootId string The ID for this dynamic menu root.
---@param generator function A function(context) returning a menu table.
---@param dataSources table|nil A map of { [sourceName] = getterFunction }.
---@param contextProviders table|nil A map of { [providerName] = providerFunction }.
function ShopNavigator:registerDynamic(rootId, generator, dataSources, contextProviders)
    if not rootId or type(generator) ~= "function" then
        print("[NativeShop] Dynamic registration failed. Invalid ID or generator.")
        return
    end
    if self.allData[rootId] or self.generators[rootId] then
        print("[NativeShop] A menu with root ID '" .. rootId .. "' has already been registered. Skipping.")
        return
    end

    self.generators[rootId] = generator
    self.dataSources[rootId] = dataSources or {}
    self.contextProviders[rootId] = contextProviders or {}
end

--- Overrides the item list for a specific menu or page at runtime.
---@param objectId string The ID of the menu or page whose items should be replaced.
---@param newItems table An array of item objects to display.
function ShopNavigator:overrideMenuItems(objectId, newItems)
    local rootId = self:getRootIdForMenu(objectId)
    if not rootId then
        print("[NativeShop] overrideMenuItems failed. Object ID '" .. objectId .. "' not found.")
        return
    end
    local menuObj = self.menuMap[rootId][objectId]
    if menuObj and menuObj.Source then
        print("[NativeShop] Cannot override menu '" .. objectId .. "' because it uses a dynamic DataSource.")
        return
    end
    self.itemOverrides[objectId] = newItems
    if self.currentMenuId == objectId then self:_rebuildCurrentItems() end
end

--- Clears a runtime override for a specific menu or page.
---@param objectId string The ID of the menu/page whose override should be cleared.
function ShopNavigator:clearMenuOverride(objectId)
    if not self.itemOverrides[objectId] then return end
    self.itemOverrides[objectId] = nil
    if self.currentMenuId == objectId then self:_rebuildCurrentItems() end
end

--- Sets the runtime visibility of a specific menu or item.
---@param menuId string The ID of the menu/item to toggle.
---@param isVisible boolean|nil `true` to show, `false` to hide, `nil` to reset.
function ShopNavigator:setMenuVisibility(menuId, isVisible)
    self.visibilityOverrides[menuId] = isVisible
    local parentId = self:getParentIdForMenu(menuId)
    if self.currentMenuId == parentId then self:_rebuildCurrentItems() end
end

--- Forces the current page to refresh its item list.
function ShopNavigator:refreshCurrentPage()
    self:_rebuildCurrentItems()
end

--- Jumps to a menu by its ID, clearing all navigation history.
---@param menuId string The ID of the menu to jump to.
---@param linkData any|nil Optional data to pass to the menu (if it is a generator root).
---@return number|nil The suggested focus index for the UI or nil if invalid.
function ShopNavigator:jumpToMenu(menuId, linkData)
    local targetRootId = self:getRootIdForMenu(menuId)

    -- Fallback: Check if the menuId itself is a registered generator root that hasn't been mapped yet
    if not targetRootId and self.generators[menuId] then
        targetRootId = menuId
    end

    if not targetRootId then
        print("[NativeShop] jumpToMenu called with invalid menu ID: " .. menuId)
        return nil
    end

    self.history = {}
    self.rootStack = {}
    self.focusMemory = {}
    self.generatorData = {}
    self.itemOverrides = {}
    self.visibilityOverrides = {}

    return self:_setMenuState(menuId, targetRootId, linkData)
end

function ShopNavigator:close()
    self.history = {}
    self.rootStack = {}
    self.currentMenuId = nil
    self.currentRootId = nil
    self.currentPageIndex = 1
    self.currentItems = {}
end

--- Handles a "select" action for forward navigation.
---@param index number The 1-based index of the item to act on.
---@return number|boolean|nil A new focus index, `false` on error, or nil.
function ShopNavigator:navigateInto(index)
    local item = self:getItemByIndex(index)
    if not item or item.Disabled then return nil end
    if self.currentMenuId then self.focusMemory[self.currentMenuId] = index end

    -- Handle LinkMenuId navigation (Jumping to another menu tree)
    if item.LinkMenuId then
        local targetRoot = self:getRootIdForMenu(item.LinkMenuId)

        -- If not found in static maps, check if it's a generator root directly
        if not targetRoot and self.generators[item.LinkMenuId] then
            targetRoot = item.LinkMenuId
        end

        if not targetRoot then
            print("[NativeShop] LinkMenuId '" .. item.LinkMenuId .. "' could not be resolved to a registered root.")
            return nil
        end

        -- Save the entire state of the current "Application" (Root) to the root stack
        table.insert(self.rootStack, {
            RootId = self.currentRootId,
            MenuId = self.currentMenuId,
            PageIndex = self.currentPageIndex,
            History = self.history,
            FocusIndex = index
        })

        -- Reset local state for the new menu tree
        self.history = {}
        self.currentPageIndex = 1

        -- Determine Target Menu
        local targetMenuId = item.LinkMenuId
        if item.LinkPageId then
            if self.menuMap[targetRoot] and self.menuMap[targetRoot][item.LinkPageId] then
                targetMenuId = item.LinkPageId
            else
                if not self.generators[targetRoot] then
                    print("[NativeShop] Warning: LinkPageId '" .. item.LinkPageId .. "' not found. Defaulting to '" .. targetMenuId .. "'.")
                end
            end
        end

        -- Handle History Simulation (LinkBackToParent)
        if item.LinkBackToParent and targetMenuId ~= targetRoot then
            self:_simulateHistoryPath(targetMenuId, targetRoot)
        end

        -- Pass item.LinkData to _setMenuState for dynamic generators
        local result = self:_setMenuState(targetMenuId, targetRoot, item.LinkData)
        TriggerEvent("native_shop:menu_navigated", {
            RootId = self.currentRootId,
            Menu = self:getCurrentMenu(),
            Index = result,
            Direction = "forward"
        })
        return result
    end

    if item.Action then
        if item.Action == "CLOSE" then
            TriggerEvent("shop:close")
            return nil
        elseif item.Action == "HIDE" then
            TriggerEvent("shop:hide")
            return nil
        elseif item.Action == "BACK" then
            return self:navigateBack() or 1
        elseif item.Action == "ROOT" then
            local rootMenu = self:getRootMenu()
            if not rootMenu then
                self.onError("No root menu found for current context. Cannot navigate to ROOT.")
                return false
            end
            local result = self:jumpToMenu(rootMenu.Id)
            TriggerEvent("native_shop:menu_navigated", {
                RootId = self.currentRootId,
                Menu = self:getCurrentMenu(),
                Index = result,
                Direction = "forward"
            })
            return result
        elseif type(item.Action) == "function" then
            local ok, result = pcall(item.Action, item)
            if not ok then
                self.onError("Action for item '" .. tostring(item.Id) .. "' failed: " .. tostring(result))
                return false
            end
            return result
        else
            print("[NativeShop] Item '" .. tostring(item.Id) .. "' has an invalid Action type.")
            return nil
        end
    end

    if item.HasNavigation then
        self:_saveStateToHistory(index)
        local result = self:_setMenuState(item.Id, self.currentRootId)
        TriggerEvent("native_shop:menu_navigated", {
            RootId = self.currentRootId,
            Menu = self:getCurrentMenu(),
            Index = result,
            Direction = "forward"
        })
        return result
    end

    return nil
end

--- Navigates back by popping the last state from the history stack.
--- Checks local history first, then checks the rootStack for previous menu trees.
---@return number|nil The focus index to restore, or nil if at the root.
function ShopNavigator:navigateBack()
    -- 1. Try to go back within the current menu tree
    if #self.history > 0 then
        local previousState = table.remove(self.history)
        self.currentMenuId = previousState.MenuId
        self.currentPageIndex = previousState.PageIndex or 1
        self:_rebuildCurrentItems()

        TriggerEvent("native_shop:menu_navigated", {
            RootId = self.currentRootId,
            Menu = self:getCurrentMenu(),
            Index = previousState.FocusIndex,
            Direction = "back"
        })
        return previousState.FocusIndex
    end

    -- 2. If local history is empty, check if we linked here from another menu tree
    if #self.rootStack > 0 then
        local rootState = table.remove(self.rootStack)

        self.currentRootId = rootState.RootId
        self.currentMenuId = rootState.MenuId
        self.currentPageIndex = rootState.PageIndex
        self.history = rootState.History

        self:_rebuildCurrentItems()
        TriggerEvent("native_shop:menu_navigated", {
            RootId = self.currentRootId,
            Menu = self:getCurrentMenu(),
            Index = rootState.FocusIndex,
            Direction = "back"
        })
        return rootState.FocusIndex
    end

    -- 3. No history left, we are at the top level
    return nil
end

--- Jumps to a specific tab by its 1-based index.
---@param newPageIndex number The 1-based index of the tab to switch to.
---@return boolean True if the tab change was successful.
function ShopNavigator:navigateTabs(newPageIndex)
    local menu = self:_getRawCurrentMenu()
    if not menu or not menu.Tabs or #menu.Tabs < 1 then
        return false
    end
    if newPageIndex < 1 or newPageIndex > #menu.Tabs or newPageIndex == self.currentPageIndex then
        return false
    end
    self.currentPageIndex = newPageIndex
    self:_rebuildCurrentItems()
    TriggerEvent("native_shop:page_navigated", {
        RootId = self.currentRootId,
        Menu = menu,
        NewIndex = self.currentPageIndex
    })
    return true
end

--- Gets all information required to render a tab bar for the current menu.
---@return table|nil A table like `{ CurrentIndex, CurrentTab, Tabs }`, or nil.
function ShopNavigator:getTabInfo()
    local menu = self:_getRawCurrentMenu()

    if menu and menu.Tabs and #menu.Tabs > 0 then
        return {
            CurrentIndex = self.currentPageIndex,
            CurrentTab = menu.Tabs[self.currentPageIndex],
            Tabs = menu.Tabs
        }
    end

    return nil
end

--- Gets the count of items in a menu, with options to filter.
---@param menuId string|nil The ID of the menu. Defaults to current menu.
---@param rootId string|nil The root ID of the tree to search in. Defaults to the current root.
---@param options table|nil Options table: { IncludeHidden = false }.
---@return number The number of items matching the criteria.
function ShopNavigator:getItemCount(menuId, rootId, options)
    menuId = menuId or self.currentMenuId
    if not menuId then return 0 end

    -- Use the provided rootId, or fallback to the currently active one.
    rootId = rootId or self.currentRootId
    if not rootId then return 0 end

    options = options or {}

    -- Directly access the menu using the provided, correct rootId
    local menu = self.menuMap[rootId] and self.menuMap[rootId][menuId]
    if not menu then return 0 end

    local count = 0
    local itemsToCheck = self:_getAllItemsForObject(menu)
    if menu.Tabs then
        for _, tab in ipairs(menu.Tabs) do
            local tabItems = self:_getAllItemsForObject(tab)
            for _, tItem in ipairs(tabItems) do table.insert(itemsToCheck, tItem) end
        end
    end

    for _, item in ipairs(itemsToCheck) do
        if options.IncludeHidden or self:_isItemVisible(item) then
            count = count + 1
        end
    end
    return count
end

--- Gets the currently displayed items for the UI to render.
---@return table An array of item objects.
function ShopNavigator:getCurrentItems()
    return self.currentItems
end

--- Gets a single item's data by its 1-based index from the current item list.
---@param index number The index of the item to retrieve.
---@return table|nil The item object, or nil if out of bounds.
function ShopNavigator:getItemByIndex(index)
    if self.currentItems and index and index >= 1 and index <= #self.currentItems then
        return self.currentItems[index]
    end
    return nil
end

--- Gets a single item's data by its unique ID from the current item list.
---@param id string The ID of the item to retrieve.
---@return table|nil The item object, or nil if not found.
function ShopNavigator:getItemById(id)
    for index, item in ipairs(self.currentItems) do
        if item.Id == id then
            item.Index = index
            return item
        end
    end
    return nil
end

--- Gets the current menu object, including a calculated `Disabled` state.
---@return table|nil The current menu object.
function ShopNavigator:getCurrentMenu()
    local menu = self:_getRawCurrentMenu()
    if menu then
        local processedMenu = shallowCopy(menu)
        if #self.currentItems == 0 then
            processedMenu.Disabled = true
        end
        return processedMenu
    end
    return nil
end

--- Gets the root menu object for the currently active menu tree.
---@return table|nil The root menu object.
function ShopNavigator:getRootMenu()
    if self.currentRootId then
        local menuTree = self.menuMap[self.currentRootId]
        if menuTree then return menuTree[self.currentRootId] end
    end
    return nil
end

--- Gets the current root menu ID.
--- @return string|nil The current root menu ID, or nil if none is active.
function ShopNavigator:getRootMenuId()
    return self.currentRootId
end

--- (Utility) Finds the Root ID for any given Menu ID.
---@param menuId string|nil The menu ID to find the root for.
---@return string|nil The Root ID, or nil if not found.
function ShopNavigator:getRootIdForMenu(menuId)
    if not menuId then
        menuId = self.currentMenuId
    end
    for rootId, menuTree in pairs(self.menuMap) do
        if menuTree[menuId] then return rootId end
    end
    -- Fallback: Check if the menuId IS the root ID of a generator (not yet mapped)
    if self.generators[menuId] then
        return menuId
    end
    return nil
end

--- (Utility) Finds the Parent ID for any given Menu ID.
---@param menuId string|nil The menu ID to find the parent for.
---@return string|nil The Parent ID, or nil if not found.
function ShopNavigator:getParentIdForMenu(menuId)
    if not menuId then
        menuId = self.currentMenuId
    end
    local rootId = self:getRootIdForMenu(menuId)
    if rootId and self.parentMap[rootId] then
        return self.parentMap[rootId][menuId]
    end
    return nil
end

--- (Utility) Gets the ID of the menu that linked to the current menu tree via a LinkMenuId item.
---@return string|nil The Menu ID that initiated the link, or nil if the current menu was not reached via a link.
function ShopNavigator:getLinkedFromMenuId()
    if #self.rootStack > 0 then
        local previousState = self.rootStack[#self.rootStack]
        return previousState.MenuId
    end
    return nil
end

--- Gets the unique entry data for the current view's title.
---@return table|nil Table containing { Id, Text, Type }, or nil.
function ShopNavigator:getCurrentTitleEntry()
    local root = self:getRootMenu()
    if not root then return nil end

    local menu = self:_getRawCurrentMenu()
    if not menu then return nil end

    local text = menu.Title or root.Title
    local baseId = menu.Id
    local type = "MENU_TITLE"

    -- Check tabs
    if menu.Tabs and #menu.Tabs > 0 then
        local activeTab = menu.Tabs[self.currentPageIndex]
        if activeTab then
            text = activeTab.Title or text -- Use tab title, fallback to menu title
            baseId = activeTab.Id
            type = "PAGE_TITLE"
        end
    end

    return {
        Id = self:_getUniqueId(baseId),
        Text = text,
        Type = type
    }
end

--- Gets the unique entry data for the current view's subtitle.
---@return table|nil Table containing { Id, Text, Type }, or nil.
function ShopNavigator:getCurrentSubtitleEntry()
    local root = self:getRootMenu()
    if not root then return nil end

    local menu = self:_getRawCurrentMenu()
    if not menu then return nil end

    -- Priority: Tab Subtitle -> Tab Label -> Menu Subtitle -> Menu Label -> Root Subtitle -> Root Label
    local text = menu.Subtitle or menu.Label or root.Subtitle or root.Label
    local baseId = menu.Id
    local type = "MENU_SUBTITLE"

    -- Check tabs
    if menu.Tabs and #menu.Tabs > 0 then
        local activeTab = menu.Tabs[self.currentPageIndex]
        if activeTab then
            text = activeTab.Subtitle or activeTab.Label or text
            baseId = activeTab.Id
            type = "PAGE_SUBTITLE"
        end
    end

    return {
        Id = self:_getUniqueId(baseId),
        Text = text,
        Type = type
    }
end

_G.ShopNavigator = ShopNavigator
