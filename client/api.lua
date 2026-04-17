-- ==========================================================
-- Navigator Client API
-- Handles function serialization and cross-resource registry
-- ==========================================================

ShopApi = {}

local CORE_RESOURCE <const> = "native-shop"
local CURRENT_RESOURCE <const> = GetCurrentResourceName()
local _registry = {}
local _counter = 0

-- ----------------------------------------------------------
-- Internal Helpers
-- ----------------------------------------------------------

local function _registerCallback(func)
    _counter = _counter + 1
    local id = "cb_" .. _counter
    _registry[id] = func
    return id
end

local function _registerTableCallbacks(input)
    if type(input) ~= "table" then
        return input
    end
    local safe = {}
    for k, v in pairs(input) do
        if type(v) == "function" then
            _registerCallback(v)
            safe[k] = _registerCallback(v)
        elseif type(v) == "table" then
            safe[k] = _registerTableCallbacks(v)
        else
            safe[k] = v
        end
    end
    return safe
end

-- ----------------------------------------------------------
-- Event Dispatcher
-- Handles callbacks, generators, and data sources
-- ----------------------------------------------------------

RegisterNetEvent(CURRENT_RESOURCE .. ":internal:dispatch")
AddEventHandler(CURRENT_RESOURCE .. ":internal:dispatch", function(cbId, reqId, ...)
    local ref = _registry[cbId]
    if not ref then
        return
    end

    -- pcall wrapper to prevent user-script crashes from breaking the menu
    local status, result = pcall(ref, ...)

    if reqId then
        if not status then
            print("[NativeShop] Resource: " .. CURRENT_RESOURCE)
            print("  " .. tostring(result))

            return TriggerEvent(CORE_RESOURCE .. ":internal:receiveResponse", reqId, nil)
        end

        local safeResult = (type(result) == "table") and _registerTableCallbacks(result) or result
        TriggerEvent(CORE_RESOURCE .. ":internal:receiveResponse", reqId, safeResult)
    end
end)

-- ----------------------------------------------------------
-- Public API Methods
-- ----------------------------------------------------------

function ShopApi.Register(menuData, dataSources)
    local safeMenu = _registerTableCallbacks(menuData)
    local safeSources = _registerTableCallbacks(dataSources)
    return exports[CORE_RESOURCE]:Register(safeMenu, safeSources, CURRENT_RESOURCE)
end

function ShopApi.RegisterDynamic(rootId, generator, dataSources)
    local safeGenerator = _registerCallback(generator)
    local safeSources = _registerTableCallbacks(dataSources)
    return exports[CORE_RESOURCE]:RegisterDynamic(rootId, safeGenerator, safeSources, CURRENT_RESOURCE)
end

function ShopApi.OverrideMenuItems(objectId, newItems)
    return exports[CORE_RESOURCE]:OverrideMenuItems(objectId, _registerTableCallbacks(newItems))
end

-- ----------------------------------------------------------
-- Passthrough Methods
-- ----------------------------------------------------------

function ShopApi.Unregister(...) return exports[CORE_RESOURCE]:Unregister(...) end
function ShopApi.ClearMenuOverride(...) return exports[CORE_RESOURCE]:ClearMenuOverride(...) end
function ShopApi.SetMenuVisibility(...) return exports[CORE_RESOURCE]:SetMenuVisibility(...) end
function ShopApi.GetInitialRootId(...) return exports[CORE_RESOURCE]:GetInitialRootId(...) end
function ShopApi.Restore(...) return exports[CORE_RESOURCE]:Restore(...) end
function ShopApi.NavigateInto(...) return exports[CORE_RESOURCE]:NavigateInto(...) end
function ShopApi.NavigateBack(...) return exports[CORE_RESOURCE]:NavigateBack(...) end
function ShopApi.NavigateRoot(...) return exports[CORE_RESOURCE]:NavigateRoot(...) end
function ShopApi.NavigateTabs(...) return exports[CORE_RESOURCE]:NavigateTabs(...) end
function ShopApi.GetTabInfo(...) return exports[CORE_RESOURCE]:GetTabInfo(...) end
function ShopApi.GetItemCount(...) return exports[CORE_RESOURCE]:GetItemCount(...) end
function ShopApi.GetCurrentItems(...) return exports[CORE_RESOURCE]:GetCurrentItems(...) end
function ShopApi.GetItemByIndex(...) return exports[CORE_RESOURCE]:GetItemByIndex(...) end
function ShopApi.GetItemById(...) return exports[CORE_RESOURCE]:GetItemById(...) end
function ShopApi.GetCurrentMenu(...) return exports[CORE_RESOURCE]:GetCurrentMenu(...) end
function ShopApi.GetCurrentMenuId(...) return exports[CORE_RESOURCE]:GetCurrentMenuId(...) end
function ShopApi.GetRootMenu(...) return exports[CORE_RESOURCE]:GetRootMenu(...) end
function ShopApi.GetRootMenuId(...) return exports[CORE_RESOURCE]:GetRootMenuId(...) end
function ShopApi.GetRootIdForMenu(...) return exports[CORE_RESOURCE]:GetRootIdForMenu(...) end
function ShopApi.GetParentIdForMenu(...) return exports[CORE_RESOURCE]:GetParentIdForMenu(...) end
function ShopApi.GetLinkedFromMenuId(...) return exports[CORE_RESOURCE]:GetLinkedFromMenuId(...) end
function ShopApi.GetCurrentTitleEntry(...) return exports[CORE_RESOURCE]:GetCurrentTitleEntry(...) end
function ShopApi.GetCurrentSubtitleEntry(...) return exports[CORE_RESOURCE]:GetCurrentSubtitleEntry(...) end

function ShopApi.Open(...) return exports[CORE_RESOURCE]:Open(...) end
function ShopApi.Hide(...) return exports[CORE_RESOURCE]:Hide(...) end
function ShopApi.Close(...) return exports[CORE_RESOURCE]:Close(...) end
function ShopApi.DisableItem(...) return exports[CORE_RESOURCE]:DisableItem(...) end
function ShopApi.EnableItem(...) return exports[CORE_RESOURCE]:EnableItem(...) end
function ShopApi.RefreshMenu(...) return exports[CORE_RESOURCE]:RefreshMenu(...) end
function ShopApi.RefreshRoot(...) return exports[CORE_RESOURCE]:RefreshRoot(...) end
function ShopApi.RefreshData(...) return exports[CORE_RESOURCE]:RefreshData(...) end
function ShopApi.SetMenuFooter(...) return exports[CORE_RESOURCE]:SetMenuFooter(...) end
function ShopApi.ClearMenuFooter(...) return exports[CORE_RESOURCE]:ClearMenuFooter(...) end
function ShopApi.SetItemFooter(...) return exports[CORE_RESOURCE]:SetItemFooter(...) end
function ShopApi.ClearItemFooter(...) return exports[CORE_RESOURCE]:ClearItemFooter(...) end

-- ----------------------------------------------------------
-- Cleanup
-- ----------------------------------------------------------

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= CURRENT_RESOURCE then return end
    exports[CORE_RESOURCE]:Unregister(resourceName)
end)
