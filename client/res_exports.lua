-- My plan is to make these exports more concrete in the future, but for now,
-- you should be able to access just about everything via these exports since
-- they return the underlying modules/objects themselves. For example:

-- local ShopNavigator = exports["native-shop"]:GetShopNavigator()
-- local currentMenu = ShopNavigator:getCurrentMenu()

-- ===================================================================
-- Shop event exports: Interact with native event loop
-- ===================================================================

exports("GetShopEventFlags", ShopEvents.GetShopEventFlags)
exports("GetShopEventFlag", ShopEvents.GetShopEventFlag)
exports("SetShopEventFlag", ShopEvents.SetShopEventFlag)
exports("ClearShopEventFlag", ShopEvents.ClearShopEventFlag)
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
