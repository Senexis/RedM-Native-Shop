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
                WeaponStats = GetWeaponStats(id, component),
            },
            Action = function(item)
                PostFeedTicker(string.format("Selected %s", item.Id))
            end,
        })
    end
    return items
end

local function getSwatches(components)
    local swatches = {}
    for i, component in ipairs(components) do
        local componentItem = ItemDatabase.new(component)
        if not componentItem then
            print("[NativeShop] Invalid component in database:", component)
            goto continue
        end

        local name = componentItem:GetLabel()
        local txd, txn = componentItem:GetSwatchTexture()

        table.insert(swatches, {
            Id = component,
            Visible = true,
            Text = name,
            TextureDictionary = txd,
            Texture = txn,
            Owned = true,
            Equipped = i == 1,
        })

        ::continue::
    end
    return swatches
end

local function getSwatchAction(components)
    return function(item)
        local value = item.Data.Palette.Value or 1
        local swatches = getSwatches(components)

        local swatch = swatches[value]
        if not swatch then return end

        PostFeedTicker(string.format("Selected %s", swatch.Id))
    end
end

local function getWeaponOptionsMenu(weapon)
    local id = weapon and weapon.Id or "WEAPON_INVALID"
    local type = weapon and weapon.Type or "INVALID"

    local name = GetStringFromHashKey(id)
    local components = WEAPON_COMPONENTS[id] or {}
    local menu = {}

    local stats = GetWeaponStats(id)

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
