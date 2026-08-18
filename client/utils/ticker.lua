---Posts a ticker message to the UI feed
---@param tipMessage string The message text to display
---@param duration number|nil Optional duration in milliseconds (defaults to 3000)
function PostFeedTicker(tipMessage, duration)
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, duration or 3000)

    local structData = DataView.ArrayBuffer(8 * 3)
    structData:SetInt64(8 * 1, VarString(10, "LITERAL_STRING", tipMessage))

    -- _UI_FEED_POST_FEED_TICKER
    Citizen.InvokeNative(0xB2920B9760F0F36B, structConfig:Buffer(), structData:Buffer(), 1)
end
