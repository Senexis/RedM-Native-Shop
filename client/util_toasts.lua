function UiFeedPostToast(toastConfig, displayConfig)
    local soundSet = VarString(10, "LITERAL_STRING", toastConfig.soundSet);
    local soundName = VarString(10, "LITERAL_STRING", toastConfig.soundName);
    local interaction = VarString(10, "LITERAL_STRING", toastConfig.interactionText);

    local structData = DataView.ArrayBuffer(11 * 8)
    structData:SetInt32(0 * 8, toastConfig.duration)
    structData:SetInt64(1 * 8, BigInt(soundSet))
    structData:SetInt64(2 * 8, BigInt(soundName))
    structData:SetInt32(3 * 8, toastConfig.showImmediate == true and 1 or 0)
    structData:SetInt64(4 * 8, BigInt(GetHashKey(toastConfig.interactionAppId)))
    structData:SetInt64(5 * 8, BigInt(GetHashKey(toastConfig.interactionAppEntry)))
    structData:SetInt64(6 * 8, BigInt(interaction))
    structData:SetInt64(7 * 8, BigInt(GetHashKey(toastConfig.scriptEventChannelHash)))
    structData:SetInt64(8 * 8, toastConfig.scriptEventDatastoreId)
    structData:SetInt64(9 * 8, BigInt(GetHashKey(toastConfig.scriptEventHashParameter)))
    structData:SetInt32(10 * 8, toastConfig.scriptEventIntParameter)

    local title = VarString(10, "LITERAL_STRING", displayConfig.titleText);
    local body = VarString(10, "LITERAL_STRING", displayConfig.bodyText);

    local structDisplay = DataView.ArrayBuffer(8 * 8)
    structDisplay:SetInt64(1 * 8, BigInt(title))
    structDisplay:SetInt64(2 * 8, BigInt(body))
    structDisplay:SetInt64(3 * 8, 0)
    structDisplay:SetInt64(4 * 8, BigInt(GetHashKey(displayConfig.iconDictionaryHash)))
    structDisplay:SetInt64(5 * 8, BigInt(GetHashKey(displayConfig.iconTextureHash)))
    structDisplay:SetInt64(6 * 8, BigInt(GetHashKey(displayConfig.iconColorHash)))
    structDisplay:SetInt32(7 * 8, 1)

    Citizen.InvokeNative(0x26E87218390E6729, structData:Buffer(), structDisplay:Buffer(), 1, 1)
end

function UiFeedPostDualLayerToast(toastConfig, displayConfig)
    local soundSet = VarString(10, "LITERAL_STRING", toastConfig.soundSet);
    local soundName = VarString(10, "LITERAL_STRING", toastConfig.soundName);
    local interaction = VarString(10, "LITERAL_STRING", toastConfig.interactionText);

    local structData = DataView.ArrayBuffer(11 * 8)
    structData:SetInt32(0 * 8, toastConfig.duration)
    structData:SetInt64(1 * 8, BigInt(soundSet))
    structData:SetInt64(2 * 8, BigInt(soundName))
    structData:SetInt32(3 * 8, toastConfig.showImmediate == true and 1 or 0)
    structData:SetInt64(4 * 8, BigInt(GetHashKey(toastConfig.interactionAppId)))
    structData:SetInt64(5 * 8, BigInt(GetHashKey(toastConfig.interactionAppEntry)))
    structData:SetInt64(6 * 8, BigInt(interaction))
    structData:SetInt64(7 * 8, BigInt(GetHashKey(toastConfig.scriptEventChannelHash)))
    structData:SetInt64(8 * 8, toastConfig.scriptEventDatastoreId)
    structData:SetInt64(9 * 8, BigInt(GetHashKey(toastConfig.scriptEventHashParameter)))
    structData:SetInt32(10 * 8, toastConfig.scriptEventIntParameter)

    local title = VarString(10, "LITERAL_STRING", displayConfig.titleText);
    local subtitle = VarString(10, "LITERAL_STRING", displayConfig.bodyText);

    local structDisplay = DataView.ArrayBuffer(10 * 8)
    structDisplay:SetInt64(1 * 8, BigInt(title))
    structDisplay:SetInt64(2 * 8, BigInt(subtitle))
    structDisplay:SetInt64(3 * 8, 0)
    structDisplay:SetInt64(4 * 8, BigInt(GetHashKey(displayConfig.iconDictionaryHash)))
    structDisplay:SetInt64(5 * 8, BigInt(GetHashKey(displayConfig.iconTextureHash)))
    structDisplay:SetInt64(6 * 8, BigInt(GetHashKey(displayConfig.backgroundDictionaryHash)))
    structDisplay:SetInt64(7 * 8, BigInt(GetHashKey(displayConfig.backgroundTextureHash)))
    structDisplay:SetInt64(8 * 8, BigInt(GetHashKey(displayConfig.backgroundColorHash)))
    structDisplay:SetInt32(9 * 8, 1)

    Citizen.InvokeNative(0xC927890AA64E9661, structData:Buffer(), structDisplay:Buffer(), 1, 1)
end

function UiFeedPostRankupToast(toastConfig, displayConfig)
    local soundSet = VarString(10, "LITERAL_STRING", toastConfig.soundSet);
    local soundName = VarString(10, "LITERAL_STRING", toastConfig.soundName);
    local interaction = VarString(10, "LITERAL_STRING", toastConfig.interactionText);

    local structData = DataView.ArrayBuffer(11 * 8)
    structData:SetInt32(0 * 8, toastConfig.duration)
    structData:SetInt64(1 * 8, BigInt(soundSet))
    structData:SetInt64(2 * 8, BigInt(soundName))
    structData:SetInt32(3 * 8, toastConfig.showImmediate == true and 1 or 0)
    structData:SetInt64(4 * 8, BigInt(GetHashKey(toastConfig.interactionAppId)))
    structData:SetInt64(5 * 8, BigInt(GetHashKey(toastConfig.interactionAppEntry)))
    structData:SetInt64(6 * 8, BigInt(interaction))
    structData:SetInt64(7 * 8, BigInt(GetHashKey(toastConfig.scriptEventChannelHash)))
    structData:SetInt64(8 * 8, toastConfig.scriptEventDatastoreId)
    structData:SetInt64(9 * 8, BigInt(GetHashKey(toastConfig.scriptEventHashParameter)))
    structData:SetInt32(10 * 8, toastConfig.scriptEventIntParameter)

    local title = VarString(10, "LITERAL_STRING", displayConfig.titleText);
    local subtitle = VarString(10, "LITERAL_STRING", displayConfig.bodyText);
    local badge = VarString(10, "LITERAL_STRING", displayConfig.badgeText);

    local structDisplay = DataView.ArrayBuffer(8 * 8)
    structDisplay:SetInt64(1 * 8, BigInt(title))
    structDisplay:SetInt64(2 * 8, BigInt(subtitle))
    structDisplay:SetInt64(3 * 8, BigInt(badge))
    structDisplay:SetInt64(4 * 8, BigInt(GetHashKey(displayConfig.iconDictionaryHash)))
    structDisplay:SetInt64(5 * 8, BigInt(GetHashKey(displayConfig.iconTextureHash)))
    structDisplay:SetInt64(6 * 8, BigInt(GetHashKey(displayConfig.iconColorHash)))
    structDisplay:SetInt32(7 * 8, 1)

    Citizen.InvokeNative(0x3F9FDDBA79117C69, structData:Buffer(), structDisplay:Buffer(), 1, 1)
end
