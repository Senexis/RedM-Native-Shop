-- My plan is to make these exports more concrete in the future, but for now,
-- you should be able to access just about everything via these exports since
-- they return the underlying modules/objects themselves. For example:

-- local ShopNavigator = exports["native-shop"]:GetShopNavigator()
-- local currentMenu = ShopNavigator:getCurrentMenu()

-- ===================================================================
-- Shop event exports: Interact with native event loop
-- ===================================================================

exports("GetFocusedItemId", ShopEvents.GetFocusedItemId)
exports("GetFocusedItemType", ShopEvents.GetFocusedItemType)
exports("GetUnfocusedItemId", ShopEvents.GetUnfocusedItemId)
exports("GetUnfocusedItemType", ShopEvents.GetUnfocusedItemType)
exports("GetSelectedItemId", ShopEvents.GetSelectedItemId)
exports("GetSelectedItemType", ShopEvents.GetSelectedItemType)
exports("GetSelectedTargetMenu", ShopEvents.GetSelectedTargetMenu)

-- ===================================================================
-- General exports: Control the shop's state and navigation
-- ===================================================================

exports("GetShopData", function() return ShopData end)
exports("GetShopEvents", function() return ShopEvents end)
exports("GetShopNavigator", function() return ShopNavigator end)
exports("GetShopUI", function() return ShopUI end)

-- ===================================================================
-- Item database utility exports: Easily work with native items
-- ===================================================================

exports("GetItemDatabase", ItemDatabase.new)

-- ===================================================================
-- Navigator exports: Control shop menus, navigation, and data sources
-- ===================================================================

exports("Register", function(...) return ShopNavigator:register(...) end)
exports("RegisterDynamic", function(...) return ShopNavigator:registerDynamic(...) end)
exports("OverrideMenuItems", function(...) return ShopNavigator:overrideMenuItems(...) end)

exports("Unregister", function(...) return ShopNavigator:unregisterResource(...) end)
exports("ClearMenuOverride", function(...) return ShopNavigator:clearMenuOverride(...) end)
exports("SetMenuVisibility", function(...) return ShopNavigator:setMenuVisibility(...) end)
exports("GetInitialRootId", function() return ShopNavigator:getInitialRootId() end)
exports("Restore", function() return ShopNavigator:restore() end)
exports("NavigateInto", function(...) return ShopNavigator:navigateInto(...) end)
exports("NavigateBack", function() return ShopNavigator:navigateBack() end)
exports("NavigateRoot", function() return ShopNavigator:navigateRoot() end)
exports("NavigateTabs", function(...) return ShopNavigator:navigateTabs(...) end)
exports("GetTabInfo", function() return ShopNavigator:getTabInfo() end)
exports("GetItemCount", function(...) return ShopNavigator:getItemCount(...) end)
exports("GetCurrentItems", function() return ShopNavigator:getCurrentItems() end)
exports("GetItemByIndex", function(...) return ShopNavigator:getItemByIndex(...) end)
exports("GetItemById", function(...) return ShopNavigator:getItemById(...) end)
exports("GetCurrentMenu", function() return ShopNavigator:getCurrentMenu() end)
exports("GetCurrentMenuId", function() return ShopNavigator:getCurrentMenuId() end)
exports("GetRootMenu", function() return ShopNavigator:getRootMenu() end)
exports("GetRootMenuId", function() return ShopNavigator:getRootMenuId() end)
exports("GetRootIdForMenu", function(...) return ShopNavigator:getRootIdForMenu(...) end)
exports("GetParentIdForMenu", function(...) return ShopNavigator:getParentIdForMenu(...) end)
exports("GetLinkedFromMenuId", function() return ShopNavigator:getLinkedFromMenuId() end)
exports("GetCurrentTitleEntry", function() return ShopNavigator:getCurrentTitleEntry() end)
exports("GetCurrentSubtitleEntry", function() return ShopNavigator:getCurrentSubtitleEntry() end)

exports("Open", function(...) return ShopUI.Open(...) end)
exports("Hide", function() return ShopUI.Hide() end)
exports("Close", function() return ShopUI.Exit() end)
exports("DisableItem", function(...) return ShopUI.DisableItem(...) end)
exports("EnableItem", function(...) return ShopUI.EnableItem(...) end)
exports("RefreshMenu", function(...) return ShopUI.RefreshMenu(...) end)
exports("RefreshRoot", function(...) return ShopUI.RefreshRoot(...) end)
exports("RefreshData", function(...) return ShopUI.RefreshData(...) end)
exports("SetMenuFooter", function(...) return ShopUI.SetFooterOverride(...) end)
exports("ClearMenuFooter", function(...) return ShopUI.ClearFooterOverride(...) end)
exports("SetItemFooter", function(...) return ShopUI.SetFooterOverride(...) end)
exports("ClearItemFooter", function(...) return ShopUI.ClearFooterOverride(...) end)
