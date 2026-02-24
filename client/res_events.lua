AddEventHandler("native_shop:open", function(shop)
    ShopUI.Open(shop)
end)

AddEventHandler("native_shop:close", function()
    ShopUI.Exit()
end)

AddEventHandler("native_shop:hide", function()
    ShopUI.Hide()
end)

AddEventHandler("native_shop:disable_item", function(item)
    ShopUI.DisableItem(item)
end)

AddEventHandler("native_shop:enable_item", function(item)
    ShopUI.EnableItem(item)
end)

AddEventHandler("native_shop:refresh_menu", function(menu)
    ShopUI.RefreshMenu(menu)
end)

AddEventHandler("native_shop:refresh_root", function(root)
    ShopUI.RefreshRoot(root)
end)

AddEventHandler("native_shop:refresh_data", function(root, source)
    ShopUI.RefreshData(root, source)
end)

AddEventHandler("native_shop:set_menu_footer", function(menu, header)
    ShopUI.SetFooterOverride(menu, nil, header)
end)

AddEventHandler("native_shop:clear_menu_footer", function(menu)
    ShopUI.ClearFooterOverride(menu, nil)
end)

AddEventHandler("native_shop:set_item_footer", function(item, footer)
    ShopUI.SetFooterOverride(nil, item, footer)
end)

AddEventHandler("native_shop:clear_item_footer", function(item)
    ShopUI.ClearFooterOverride(nil, item)
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
