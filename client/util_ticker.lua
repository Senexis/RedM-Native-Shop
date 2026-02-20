-- Feed ticker utility functions for UI notifications
-- Based on work by VORPCORE: https://github.com/VORPCORE/vorp_core

---Posts a ticker message to the UI feed
---@param tipMessage string The message text to display
---@param duration number|nil Optional duration in milliseconds (defaults to 3000)
function PostFeedTicker(tipMessage, duration)
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

    local structData = DataView.ArrayBuffer(8 * 3)
    structData:SetInt64(8 * 1, StringToBigint(VarString(10, "LITERAL_STRING", tipMessage)))

    Citizen.InvokeNative(0xB2920B9760F0F36B, structConfig:Buffer(), structData:Buffer(), 1) -- _UI_FEED_POST_FEED_TICKER
end

---Converts a string to a bigint for native function compatibility
---@param text string The text string to convert
---@return number bigint The converted bigint value
function StringToBigint(text)
    local stringBuffer = DataView.ArrayBuffer(16)
    stringBuffer:SetInt64(0, text)
    return stringBuffer:GetInt64(0)
end
