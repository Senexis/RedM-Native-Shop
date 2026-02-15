-- Some things you would need to implement:
-- 1. Getting the weapon's degradation
-- 2. Getting the weapon's current stats with components applied
local function getWeaponStats(weapon, component)
    local weaponHash = weapon and joaat(weapon) or 0
    local componentHash = component and joaat(component) or 0

    -- Get the current weapon skill modifier (0-100)
    local weaponSkill = 100
    local struct = DataView.ArrayBuffer(16)
    struct:SetInt32(0, `skill`)
    struct:SetInt32(8, GetWeaponStatId(weaponHash))

    if Citizen.InvokeNative(0xC48FE1971C9743FF, struct:Buffer()) == 1 then
        weaponSkill = Citizen.InvokeNative(0xD7AE6C9C9C6AC54D, struct:Buffer(), Citizen.ResultAsFloat())
    end

    -- Implement actual degradation retrieval here
    local degradation = 0

    local potentialPower = 0
    local potentialRange = 0
    local potentialFireRate = 0
    local potentialReload = 0
    local potentialAccuracy = 0

    local weaponSkillRange = 0
    local weaponSkillReload = 0
    local weaponSkillAccuracy = 0

    -- Gets the stats of the weapon without components with weapon skill applied
    local weaponEffectIds = GetItemEffectIds(weaponHash)
    for _, weaponEffectId in ipairs(weaponEffectIds) do
        local weaponEffect = GetItemEffectData(weaponEffectId)

        -- Retrieves the base stats of the weapon from its effects
        if weaponEffect.type == -266488916 then
            potentialPower += weaponEffect.value
        elseif weaponEffect.type == 1648497600 then
            potentialRange += weaponEffect.value
        elseif weaponEffect.type == -1856731002 then
            potentialFireRate += weaponEffect.value
        elseif weaponEffect.type == 2038990430 then
            potentialReload += weaponEffect.value
        elseif weaponEffect.type == 983649838 then
            potentialAccuracy += weaponEffect.value
        end

        -- Applies a skill bonus based on the weapon skill percentage for certain stats
        if weaponEffect.type == 1465168878 then
            weaponSkillRange += math.floor(weaponEffect.value * (weaponSkill / 100))
        elseif weaponEffect.type == -1103443887 then
            weaponSkillReload += math.floor(weaponEffect.value * (weaponSkill / 100))
        elseif weaponEffect.type == -800430237 then
            weaponSkillAccuracy += math.floor(weaponEffect.value * (weaponSkill / 100))
        end
    end

    local componentPower = 0
    local componentRange = 0
    local componentAccuracy = 0

    -- Gets the stats of the component (optionally)
    -- This is simplified as compared to the base game, you may want to improve this
    if component then
        local componentEffectIds = GetItemEffectIds(componentHash)
        for _, componentEffectId in ipairs(componentEffectIds) do
            local componentEffect = GetItemEffectData(componentEffectId)

            if componentEffect.type == 1999781523 then
                componentPower += componentEffect.value
            elseif componentEffect.type == 1173003838 then
                componentAccuracy += componentEffect.value
            elseif componentEffect.type == -1657343230 then
                componentRange += componentEffect.value
            end
        end
    end

    local newPower = potentialPower
    local newRange = potentialRange + weaponSkillRange
    local newAccuracy = potentialAccuracy + weaponSkillAccuracy
    local newFireRate = potentialFireRate
    local newReload = potentialReload + weaponSkillReload

    return {
        Power = {
            Value = newPower + componentPower - degradation,
            Diff = newPower + componentPower,
            New = newPower - degradation
        },
        Range = {
            Value = newRange + componentRange,
            Diff = 0,
            New = newRange
        },
        Accuracy = {
            Value = newAccuracy + componentAccuracy,
            Diff = 0,
            New = newAccuracy
        },
        FireRate = {
            Value = newFireRate - degradation,
            Diff = newFireRate,
            New = newFireRate - degradation
        },
        Reload = {
            Value = newReload - degradation,
            Diff = newReload,
            New = newReload - degradation
        },
    }
end

local function getItems(id, components)
    local items = {}
    for i, component in ipairs(components) do
        local name = GetStringFromHashKey(component)

        table.insert(items, {
            Id = component,
            Type = "INVENTORY",
            Label = name,
            Data = {
                Owned = true,
                Equipped = i == 1,
                EquippedTextureDictionary = "menu_textures",
                EquippedTexture = "menu_icon_tick",
                WeaponStats = getWeaponStats(id, component),
            },
            Action = function(item)
                PostFeedTicker(string.format("Selected weapon component %s", item.Id))
            end,
        })
    end
    return items
end

local function getSwatches(components)
    local swatches = {}
    for i, component in ipairs(components) do
        local name = GetStringFromHashKey(component)
        local ui = GetItemUiData(joaat(component))
        local swatchTextureDict = ui.swatchTextureDict
        local swatchTextureId = ui.swatchTextureId

        if swatchTextureDict and swatchTextureId then
            table.insert(swatches, {
                Id = component,
                Visible = true,
                Text = name,
                TextureDictionary = swatchTextureDict,
                Texture = swatchTextureId,
                Owned = true,
                Equipped = i == 1,
            })
        end
    end
    return swatches
end

local function getSwatchAction(components)
    return function(item)
        local value = item.Data.Palette.Value or 1
        local swatches = getSwatches(components)

        local swatch = swatches[value]
        if not swatch then return end

        PostFeedTicker(string.format("Selected weapon component %s", swatch.Id))
    end
end

local function getWeaponOptionsMenu(weapon)
    local id = weapon and weapon.Id or "WEAPON_INVALID"
    local type = weapon and weapon.Type or "INVALID"

    local name = GetStringFromHashKey(id)
    local components = WEAPON_COMPONENTS[id] or {}
    local menu = {}

    local stats = getWeaponStats(id)

    if type ~= "BOW" and type ~= "MELEE" then
        table.insert(menu, {
            Id = id .. "_CLEAN",
            Label = "Clean Weapon",
            Data = { WeaponStats = stats },
            Action = function()
                PostFeedTicker(string.format("Cleaned %s", name))
            end,
        })
    end

    if components.VARIANT and #components.VARIANT > 0 then
        table.insert(menu, {
            Id = id .. "_VARIANTS",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Label = "Variants",
            Items = getItems(id, components.VARIANT),
            Data = { WeaponStats = stats },
        })
    end

    local menu_components = {}

    if components.GRIP and #components.GRIP > 0 then
        table.insert(menu_components, {
            Id = id .. "_GRIPS",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Label = "Grip",
            Items = getItems(id, components.GRIP),
            Data = { WeaponStats = stats },
        })
    end

    local menu_barrel_components = {}

    if components.BARREL and #components.BARREL > 0 then
        table.insert(menu_barrel_components, {
            Id = id .. "_BARREL_SIZE",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Label = "Size",
            Items = getItems(id, components.BARREL),
            Data = { WeaponStats = stats },
        })
    end

    if components.BARREL_RIFLING and #components.BARREL_RIFLING > 0 then
        table.insert(menu_barrel_components, {
            Id = id .. "_BARREL_RIFLING",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Label = "Rifling",
            Items = getItems(id, components.BARREL_RIFLING),
            Data = { WeaponStats = stats },
        })
    end

    if #menu_barrel_components > 0 then
        table.insert(menu_components, {
            Id = id .. "_BARRELS",
            Scene = "MENU_LIST_WEAPON_STATS",
            Label = "Barrel",
            Items = menu_barrel_components,
            Data = { WeaponStats = stats },
        })
    end

    if components.SIGHT and #components.SIGHT > 0 then
        table.insert(menu_components, {
            Id = id .. "_SIGHTS",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Label = "Iron Sights",
            Items = getItems(id, components.SIGHT),
            Data = { WeaponStats = stats },
        })
    end

    if components.SCOPE and #components.SCOPE > 0 then
        table.insert(menu_components, {
            Id = id .. "_SCOPES",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Label = "Scope",
            Items = getItems(id, components.SCOPE),
            Data = { WeaponStats = stats },
        })
    end

    if components.STOCK and #components.STOCK > 0 then
        table.insert(menu_components, {
            Id = id .. "_STOCKS",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Label = "Stock",
            Items = getItems(id, components.STOCK),
            Data = { WeaponStats = stats },
        })
    end

    local menu_wrap_components = {}

    if components.CLOTH_WRAP and #components.CLOTH_WRAP > 0 then
        table.insert(menu_wrap_components, {
            Id = id .. "_CLOTH_WRAPS",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Label = "Cloth",
            Items = getItems(id, components.CLOTH_WRAP),
            Data = { WeaponStats = stats },
        })
    end

    if components.LEATHER_WRAP and #components.LEATHER_WRAP > 0 then
        table.insert(menu_wrap_components, {
            Id = id .. "_LEATHER_WRAPS",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Label = "Leather",
            Items = getItems(id, components.LEATHER_WRAP),
            Data = { WeaponStats = stats },
        })
    end

    if #menu_wrap_components > 0 then
        table.insert(menu_components, {
            Id = id .. "_WRAPS",
            Scene = "MENU_LIST_WEAPON_STATS",
            Label = "Wrap",
            Items = menu_wrap_components,
            Data = { WeaponStats = stats },
        })
    end

    if #menu_components > 0 then
        table.insert(menu, {
            Id = id .. "_COMPONENTS",
            Scene = "MENU_LIST_WEAPON_STATS",
            Label = "Components",
            Items = menu_components,
            Data = { WeaponStats = stats },
        })
    end

    local menu_styles = {}
    local menu_metal_styles = {}

    if components.BLADE_MATERIAL and #components.BLADE_MATERIAL > 0 then
        table.insert(menu_metal_styles, {
            Id = id .. "_BLADE_MATERIALS",
            Type = "PALETTE",
            Label = "Blade",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.BLADE_MATERIAL),
                }
            },
            Action = getSwatchAction(components.BLADE_MATERIAL),
        })
    end

    if components.BARREL_MATERIAL and #components.BARREL_MATERIAL > 0 then
        table.insert(menu_metal_styles, {
            Id = id .. "_BARREL_MATERIALS",
            Type = "PALETTE",
            Label = "Barrel",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.BARREL_MATERIAL),
                }
            },
            Action = getSwatchAction(components.BARREL_MATERIAL),
        })
    end

    if components.CYLINDER_MATERIAL and #components.CYLINDER_MATERIAL > 0 then
        table.insert(menu_metal_styles, {
            Id = id .. "_CYLINDER_MATERIALS",
            Type = "PALETTE",
            Label = "Block",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.CYLINDER_MATERIAL),
                }
            },
            Action = getSwatchAction(components.CYLINDER_MATERIAL),
        })
    end

    if components.FRAME_MATERIAL and #components.FRAME_MATERIAL > 0 then
        table.insert(menu_metal_styles, {
            Id = id .. "_FRAME_MATERIALS",
            Type = "PALETTE",
            Label = "Frame",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.FRAME_MATERIAL),
                }
            },
            Action = getSwatchAction(components.FRAME_MATERIAL),
        })
    end

    if components.HAMMER_MATERIAL and #components.HAMMER_MATERIAL > 0 then
        table.insert(menu_metal_styles, {
            Id = id .. "_HAMMER_MATERIALS",
            Type = "PALETTE",
            Label = "Hammer",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.HAMMER_MATERIAL),
                }
            },
            Action = getSwatchAction(components.HAMMER_MATERIAL),
        })
    end

    if components.SIGHT_MATERIAL and #components.SIGHT_MATERIAL > 0 then
        table.insert(menu_metal_styles, {
            Id = id .. "_SIGHT_MATERIALS",
            Type = "PALETTE",
            Label = "Sight",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.SIGHT_MATERIAL),
                }
            },
            Action = getSwatchAction(components.SIGHT_MATERIAL),
        })
    end

    if components.TRIGGER_MATERIAL and #components.TRIGGER_MATERIAL > 0 then
        table.insert(menu_metal_styles, {
            Id = id .. "_TRIGGER_MATERIALS",
            Type = "PALETTE",
            Label = "Trigger",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.TRIGGER_MATERIAL),
                }
            },
            Action = getSwatchAction(components.TRIGGER_MATERIAL),
        })
    end

    if #menu_metal_styles > 0 then
        table.insert(menu_styles, {
            Id = id .. "_METALS",
            Scene = "ITEM_LIST_COLOUR_PALETTE",
            Label = "Metals",
            Items = menu_metal_styles,
            Data = { WeaponStats = stats },
        })
    end

    local menu_engraving_styles = {}

    if components.FULL_ENGRAVING and #components.FULL_ENGRAVING > 0 then
        table.insert(menu_engraving_styles, {
            Id = id .. "_FULL_ENGRAVINGS",
            Type = "PALETTE",
            Label = "Full Engravings",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.FULL_ENGRAVING),
                }
            },
            Action = getSwatchAction(components.FULL_ENGRAVING),
        })
    end

    if components.ENGRAVING_MATERIAL and #components.ENGRAVING_MATERIAL > 0 then
        table.insert(menu_engraving_styles, {
            Id = id .. "_ENGRAVING_MATERIALS",
            Type = "PALETTE",
            Label = "Inlay Metals",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.ENGRAVING_MATERIAL),
                }
            },
            Action = getSwatchAction(components.ENGRAVING_MATERIAL),
        })
    end

    if components.BARREL_ENGRAVING and #components.BARREL_ENGRAVING > 0 then
        table.insert(menu_engraving_styles, {
            Id = id .. "_BARREL_ENGRAVINGS",
            Type = "PALETTE",
            Label = "Barrel",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.BARREL_ENGRAVING),
                }
            },
            Action = getSwatchAction(components.BARREL_ENGRAVING),
        })
    end

    if components.BLADE_ENGRAVING and #components.BLADE_ENGRAVING > 0 then
        table.insert(menu_engraving_styles, {
            Id = id .. "_BLADE_ENGRAVINGS",
            Type = "PALETTE",
            Label = "Blade",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.BLADE_ENGRAVING),
                }
            },
            Action = getSwatchAction(components.BLADE_ENGRAVING),
        })
    end

    if components.CYLINDER_ENGRAVING and #components.CYLINDER_ENGRAVING > 0 then
        table.insert(menu_engraving_styles, {
            Id = id .. "_CYLINDER_ENGRAVINGS",
            Type = "PALETTE",
            Label = "Block",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.CYLINDER_ENGRAVING),
                }
            },
            Action = getSwatchAction(components.CYLINDER_ENGRAVING),
        })
    end

    if components.FRAME_ENGRAVING and #components.FRAME_ENGRAVING > 0 then
        table.insert(menu_engraving_styles, {
            Id = id .. "_FRAME_ENGRAVINGS",
            Type = "PALETTE",
            Label = "Frame",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.FRAME_ENGRAVING),
                }
            },
            Action = getSwatchAction(components.FRAME_ENGRAVING),
        })
    end

    if #menu_engraving_styles > 0 then
        table.insert(menu_styles, {
            Id = id .. "_ENGRAVINGS",
            Scene = "ITEM_LIST_COLOUR_PALETTE",
            Label = "Engravings",
            Items = menu_engraving_styles,
            Data = { WeaponStats = stats },
        })
    end

    local menu_carving_styles = {}

    if components.GRIPSTOCK_ENGRAVING and #components.GRIPSTOCK_ENGRAVING > 0 then
        table.insert(menu_carving_styles, {
            Id = id .. "_GRIP_ENGRAVINGS",
            Type = "PALETTE",
            Label = "Grip",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.GRIPSTOCK_ENGRAVING),
                }
            },
            Action = getSwatchAction(components.GRIPSTOCK_ENGRAVING),
        })
    end

    if #menu_carving_styles > 0 then
        table.insert(menu_styles, {
            Id = id .. "_CARVINGS",
            Scene = "ITEM_LIST_COLOUR_PALETTE",
            Label = "Carvings",
            Items = menu_carving_styles,
            Data = { WeaponStats = stats },
        })
    end

    local menu_wrap_tint_styles = {}

    if components.CLOTH_WRAP_TINT and #components.CLOTH_WRAP_TINT > 0 then
        table.insert(menu_wrap_tint_styles, {
            Id = id .. "_CLOTH_TINTS",
            Type = "PALETTE",
            Label = "Cloth",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.CLOTH_WRAP_TINT),
                }
            },
            Action = getSwatchAction(components.CLOTH_WRAP_TINT),
        })
    end

    if components.LEATHER_WRAP_TINT and #components.LEATHER_WRAP_TINT > 0 then
        table.insert(menu_wrap_tint_styles, {
            Id = id .. "_LEATHER_TINTS",
            Type = "PALETTE",
            Label = "Leather",
            Data = {
                IconVisible = true,
                Palette = {
                    Value = 1,
                    Items = getSwatches(components.LEATHER_WRAP_TINT),
                }
            },
            Action = getSwatchAction(components.LEATHER_WRAP_TINT),
        })
    end

    if #menu_wrap_tint_styles > 0 then
        table.insert(menu_styles, {
            Id = id .. "_WRAP_TINTS",
            Scene = "ITEM_LIST_COLOUR_PALETTE",
            Label = "Wrap",
            Items = menu_wrap_tint_styles,
            Data = { WeaponStats = stats },
        })
    end

    if id == "WEAPON_BOW_IMPROVED" then
        if components.TRIGGER_TINT and #components.TRIGGER_TINT > 0 then
            table.insert(menu_styles, {
                Id = id .. "_TRIGGER_TINTS",
                Type = "PALETTE",
                Label = "Bowstring",
                Data = {
                    IconVisible = true,
                    Palette = {
                        Value = 1,
                        Items = getSwatches(components.TRIGGER_TINT),
                    }
                },
                Action = getSwatchAction(components.TRIGGER_TINT),
            })
        end

        if components.GRIPSTOCK_TINT and #components.GRIPSTOCK_TINT > 0 then
            table.insert(menu_styles, {
                Id = id .. "_GRIPSTOCK_TINTS",
                Type = "PALETTE",
                Label = "Leather",
                Data = {
                    IconVisible = true,
                    Palette = {
                        Value = 1,
                        Items = getSwatches(components.GRIPSTOCK_TINT),
                    }
                },
                Action = getSwatchAction(components.GRIPSTOCK_TINT),
            })
        end

        if components.FRAME_TINT and #components.FRAME_TINT > 0 then
            table.insert(menu_styles, {
                Id = id .. "_FRAME_TINTS",
                Type = "PALETTE",
                Label = "Varnish",
                Data = {
                    IconVisible = true,
                    Palette = {
                        Value = 1,
                        Items = getSwatches(components.FRAME_TINT),
                    }
                },
                Action = getSwatchAction(components.FRAME_TINT),
            })
        end
    else
        if components.GRIPSTOCK_TINT and #components.GRIPSTOCK_TINT > 0 then
            table.insert(menu_styles, {
                Id = id .. "_VARNISH",
                Type = "PALETTE",
                Label = "Varnish",
                Data = {
                    IconVisible = true,
                    Palette = {
                        Value = 1,
                        Items = getSwatches(components.GRIPSTOCK_TINT),
                    }
                },
                Action = getSwatchAction(components.GRIPSTOCK_TINT),
            })
        end
    end

    if #menu_styles > 0 then
        table.insert(menu, {
            Id = id .. "_STYLES",
            Scene = "ITEM_LIST_COLOUR_PALETTE",
            Label = "Styles",
            Items = menu_styles,
            Data = { WeaponStats = stats },
        })
    end

    if components.AMMO and #components.AMMO > 0 then
        table.insert(menu, {
            Id = id .. "_AMMUNITION",
            Scene = "ITEM_LIST_WEAPON_STATS",
            Label = "Ammunition",
            Items = getItems(id, components.AMMO),
            Data = { WeaponStats = stats },
        })
    end

    return {
        Title = "GUNSMITH",
        Subtitle = name,
        Scene = "MENU_LIST_WEAPON_STATS",
        AllowWalking = true,
        RepositionCamera = true,
        Items = menu,
        Data = { WeaponStats = stats },
    }
end

ShopNavigator:registerDynamic("DEMO_WEAPON_OPTIONS", getWeaponOptionsMenu)
