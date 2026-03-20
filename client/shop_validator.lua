ShopValidator = {}

local SCHEMAS <const> = {
    Menu = {
        Id = { type = { "string", "number" }, optional = true },
        Title = { type = { "string", "function" }, optional = true },
        TitleDynamic = { type = "boolean", optional = true },
        Subtitle = { type = { "string", "function" }, optional = true },
        SubtitleDynamic = { type = "boolean", optional = true },
        Scene = { type = "string", optional = true },
        Validate = { type = "boolean", optional = true },
        AllowWalking = { type = "boolean", optional = true },
        RepositionCamera = { type = "boolean", optional = true },
        Prompts = {
            type = "table",
            optional = true,
            schema = "Prompts"
        },
        Data = {
            type = "table",
            optional = true,
            schema = "Data"
        },
        Tabs = {
            type = "table",
            optional = true,
            items = { type = "table", schema = "Tab" }
        },
        ItemSource = { type = "string", optional = true },
        Items = {
            type = "table",
            optional = true,
            items = { type = "table", schema = "Item" }
        },
        TickMs = { type = "number", optional = true },
        Tick = { type = "function", optional = true },

        validate = function(data, label)
            if not data.ItemSource and not data.Items then
                error(string.format("[%s] Either 'ItemSource' or 'Items' must be provided", label), 3)
            end
        end,
    },
    Tab = {
        Id = { type = { "string", "number" } },
        Label = { type = "string" },
        All = { type = "boolean", optional = true },
    },
    Item = {
        Id = { type = { "string", "number" } },
        Scene = { type = "string", optional = true },
        Title = { type = { "string", "function" }, optional = true },
        Subtitle = { type = { "string", "function" }, optional = true },
        Type = { type = "string", optional = true },
        Tab = { type = { "string", "number", "table" }, optional = true, items = { type = { "string", "number" } } },
        Disabled = { type = "boolean", optional = true },
        Auto = { type = { "string", "boolean" }, optional = true },
        Label = { type = "string", optional = true },
        Footer = { type = "string", optional = true },
        Action = { type = { "string", "function" }, optional = true },
        LinkMenuId = { type = { "string", "number" }, optional = true },
        LinkPageId = { type = { "string", "number" }, optional = true },
        LinkData = { optional = true },
        LinkBackToParent = { type = "boolean", optional = true },
        Prompts = {
            type = "table",
            optional = true,
            schema = "Prompts"
        },
        Data = {
            type = "table",
            optional = true,
            schema = "Data"
        },
        Tabs = {
            type = "table",
            optional = true,
            items = { type = "table", schema = "Tab" }
        },
        ItemSource = { type = "string", optional = true },
        Items = {
            type = "table",
            optional = true,
            items = { type = "table", schema = "Item" }
        },
        TickMs = { type = "number", optional = true },
        Tick = { type = "function", optional = true },
    },
    Prompts = {
        Select = {
            type = { "table", "string" },
            optional = true,
            schema = "Prompt",
        },
        Back = {
            type = { "table", "string" },
            optional = true,
            schema = "Prompt",
        },
        Modify = {
            type = { "table", "string" },
            optional = true,
            schema = "Prompt",
        },
        Option = {
            type = { "table", "string" },
            optional = true,
            schema = "Prompt",
        },
        Adjust = {
            type = { "table", "string" },
            optional = true,
            schema = "Prompt",
        },
        Toggle = {
            type = { "table", "string" },
            optional = true,
            schema = "Prompt",
        },
        Info = {
            type = { "table", "string" },
            optional = true,
            schema = "Prompt",
        },
    },
    Prompt = {
        Visible = { type = "boolean", optional = true },
        Held = { type = "boolean", optional = true },
        Label = { type = "string", optional = true },
        Action = { type = { "string", "function" }, optional = true },
    },
    Data = {
        -- Item
        Description = { type = "string", optional = true },
        Progress = { type = "number", optional = true },
        TextColor = { type = "string", optional = true },
        TextureDictionary = { type = "string", optional = true },
        Texture = { type = "string", optional = true },
        TimeIconVisible = { type = "boolean", optional = true },
        IsNew = { type = "boolean", optional = true },
        IsMaxCount = { type = "boolean", optional = true },
        Quantity = { type = "number", optional = true },
        TickVisible = { type = "boolean", optional = true },
        Equipped = { type = "boolean", optional = true },
        EquippedTexture = { type = "string", optional = true },
        EquippedTextureDictionary = { type = "string", optional = true },
        ForSale = { type = "boolean", optional = true },
        FrontSlotTexture = { type = "string", optional = true },
        FrontSlotTextureColour = { type = "string", optional = true },
        FrontSlotTextureDictionary = { type = "string", optional = true },
        FrontSlotTextureVisible = { type = "boolean", optional = true },
        Locked = { type = "boolean", optional = true },
        Owned = { type = "boolean", optional = true },
        Price = { type = "number", optional = true },
        Rank = { type = "number", optional = true },
        RankTexture = { type = "string", optional = true },
        RankLocked = { type = "boolean", optional = true },
        IsOnSale = { type = "boolean", optional = true },
        UseGoldPrice = { type = "boolean", optional = true },
        IconVisible = { type = "boolean", optional = true },
        IconTexture = { type = "string", optional = true },
        IconTextureDictionary = { type = "string", optional = true },
        BackTextureVisible = { type = "boolean", optional = true },
        BackTextureColour = { type = "string", optional = true },
        BackTexture = { type = "string", optional = true },
        BackTextureDictionary = { type = "string", optional = true },
        FrontAddSlotTextureVisible = { type = "boolean", optional = true },
        FrontAddSlotTextureColour = { type = "string", optional = true },
        FrontAddSlotTexture = { type = "string", optional = true },
        FrontAddSlotTextureDictionary = { type = "string", optional = true },
        IconTextureDict = { type = "string", optional = true },
        StepperVisible = { type = "boolean", optional = true },
        StepperValue = { type = "number", optional = true },
        StepperOptions = { type = "table", optional = true, items = { type = "string" } },
        StepperTextureVisible = { type = "boolean", optional = true },
        StepperTexture = { type = { "string" }, optional = true },
        StepperTextureDict = { type = { "string" }, optional = true },
        AddIconVisible = { type = "boolean", optional = true },
        AddIconTexture = { type = "string", optional = true },
        AddIconTextureDict = { type = "string", optional = true },
        OnHorse = { type = "boolean", optional = true },
        RightLabelVisible = { type = "boolean", optional = true },
        RightText = { type = "string", optional = true },
        LeftImageVisible = { type = "boolean", optional = true },
        LeftImageTexture = { type = "string", optional = true },
        LeftImageDictionary = { type = "string", optional = true },
        RightImageVisible = { type = "boolean", optional = true },
        RightImageTexture = { type = "string", optional = true },
        RightImageDictionary = { type = "string", optional = true },

        -- Scene
        DisabledFooter = { type = "string", optional = true },
        ItemDescription = { type = "string", optional = true },
        ItemDescriptionHash = { type = { "string", "number" }, optional = true },
        InfoBoxName = { type = "string", optional = true },
        InfoBoxNameHash = { type = { "string", "number" }, optional = true },
        ItemInfo1 = { type = "table", optional = true, schema = "ItemInfo1" },
        ItemInfo2 = { type = "table", optional = true, schema = "ItemInfo2" },
        Weather = { type = "table", optional = true, schema = "Weather" },
        OutfitWeather = { type = "table", optional = true, schema = "OutfitWeather" },
        Pricing = { type = "table", optional = true, schema = "Pricing" },
        HorseStats = { type = "table", optional = true, schema = "HorseStats" },
        HorseInfoBox = { type = "table", optional = true, schema = "HorseInfoBox" },
        SaddleStats = { type = "table", optional = true, schema = "SaddleStats" },
        StirrupStats = { type = "table", optional = true, schema = "StirrupStats" },
        VehicleStats = { type = "table", optional = true, schema = "VehicleStats" },
        WeaponStats = { type = "table", optional = true, schema = "WeaponStats" },
        RecipeFooter = { type = "table", optional = true, schema = "RecipeFooter" },
        RpgEffects = { type = "table", optional = true, schema = "RpgEffects" },
        SliderInfo = { type = "table", optional = true, schema = "SliderInfo" },
        BusinessInfo = { type = "table", optional = true, schema = "BusinessInfo" },
        Palette = { type = "table", optional = true, schema = "Palette" },
    },
    ItemInfo1 = {
        Visible = { type = "boolean", optional = true },
        Text = { type = "string", optional = true },
        Centered = { type = "boolean", optional = true },
        IconVisible = { type = "boolean", optional = true },
        IconTextureDictionary = { type = "string", optional = true },
        IconTexture = { type = "string", optional = true },
        IconColor = { type = "string", optional = true },
    },
    ItemInfo2 = {
        Visible = { type = "boolean", optional = true },
        Text = { type = "string", optional = true },
        Centered = { type = "boolean", optional = true },
        IconVisible = { type = "boolean", optional = true },
        IconTextureDictionary = { type = "string", optional = true },
        IconTexture = { type = "string", optional = true },
    },
    Weather = {
        Visible = { type = "boolean", optional = true },
        Enabled = { type = "boolean", optional = true },
        Opacity = { type = "number", optional = true },
        Warmth = { type = "number", optional = true },
    },
    OutfitWeather = {
        Visible = { type = "boolean", optional = true },
        Enabled = { type = "boolean", optional = true },
        Opacity = { type = "number", optional = true },
        Effectiveness = { type = "number", optional = true },
    },
    Pricing = {
        Price = { type = "number", optional = true },
        Tokens = { type = "number", optional = true },
        SalePrice = { type = "number", optional = true },
        UseGoldPrice = { type = "boolean", optional = true },
        Affordable = { type = "boolean", optional = true },
        LeftText = { type = "string", optional = true },
        RightText = { type = "string", optional = true },
        Locked = { type = "boolean", optional = true },
        Rank = { type = "number", optional = true },
    },
    HorseStats = {
        Primary = { type = "boolean", optional = true },
        Speed = { type = "table", optional = true, schema = "HorseStat" },
        Acceleration = { type = "table", optional = true, schema = "HorseStat" },
        HandlingText = { type = "string", optional = true },
        HandlingTextHash = { type = { "string", "number" }, optional = true },
        TypeText = { type = "string", optional = true },
        TypeTextHash = { type = { "string", "number" }, optional = true },
        BreedText = { type = "string", optional = true },
        BreedTextHash = { type = { "string", "number" }, optional = true },
        CoatText = { type = "string", optional = true },
        CoatTextHash = { type = { "string", "number" }, optional = true },
        GenderText = { type = "string", optional = true },
        GenderTextHash = { type = { "string", "number" }, optional = true },
    },
    HorseStat = {
        Value = { type = "number", optional = true },
        MinValue = { type = "number", optional = true },
        MaxValue = { type = "number", optional = true },
        CapacityValue = { type = "number", optional = true },
        CapacityMinValue = { type = "number", optional = true },
        CapacityMaxValue = { type = "number", optional = true },
        EquipmentValue = { type = "number", optional = true },
        EquipmentMinValue = { type = "number", optional = true },
        EquipmentMaxValue = { type = "number", optional = true },
    },
    HorseInfoBox = {
        Visible = { type = "boolean", optional = true },
        Stats = { type = "boolean", optional = true },
        Text = { type = "string", optional = true },
        TextHash = { type = { "string", "number" }, optional = true },
        Description = { type = "string", optional = true },
        TipText = { type = "string", optional = true },
        TipTextHash = { type = { "string", "number" }, optional = true },
    },
    SaddleStats = {
        Visible = { type = "boolean", optional = true },
        Items = {
            type = "table",
            optional = true,
            items = { type = "table", schema = "EquipmentStat" }
        },
    },
    EquipmentStat = {
        Enabled = { type = "boolean", optional = true },
        IconVisible = { type = "boolean", optional = true },
        IconTextureDictionary = { type = "string", optional = true },
        IconTexture = { type = "string", optional = true },
        Text = { type = "string", optional = true },
        Value = { type = "string", optional = true },
        EndIconVisible = { type = "boolean", optional = true },
        EndIconTextureDictionary = { type = "string", optional = true },
        EndIconTexture = { type = "string", optional = true },
    },
    StirrupStats = {
        Visible = { type = "boolean", optional = true },
        Speed = { type = "table", optional = true, schema = "HorseStat" },
        Acceleration = { type = "table", optional = true, schema = "HorseStat" },
        Items = {
            type = "table",
            optional = true,
            items = { type = "table", schema = "EquipmentStat" }
        },
    },
    VehicleStats = {
        Primary = { type = "boolean", optional = true },
        MaxSpeed = { type = "string", optional = true },
        MaxSpeedHash = { type = { "string", "number" }, optional = true },
        Acceleration = { type = "string", optional = true },
        AccelerationHash = { type = { "string", "number" }, optional = true },
        Steering = { type = "string", optional = true },
        SteeringHash = { type = { "string", "number" }, optional = true },
        Description = { type = "string", optional = true },
        DescriptionHash = { type = { "string", "number" }, optional = true },
    },
    WeaponStats = {
        Power = { type = "table", optional = true, schema = "WeaponStat" },
        Range = { type = "table", optional = true, schema = "WeaponStat" },
        Accuracy = { type = "table", optional = true, schema = "WeaponStat" },
        FireRate = { type = "table", optional = true, schema = "WeaponStat" },
        Reload = { type = "table", optional = true, schema = "WeaponStat" },
    },
    WeaponStat = {
        Value = { type = "number", optional = true },
        Diff = { type = "number", optional = true },
        New = { type = "number", optional = true },
    },
    RecipeFooter = {
        Visible = { type = "boolean", optional = true },
        TitleType = { type = "number", optional = true },
        Items = {
            type = "table",
            optional = true,
            items = { type = "table", schema = "RecipeItem" }
        },
    },
    RecipeItem = {
        Name = { type = "string", optional = true },
        Enabled = { type = "boolean", optional = true },
        Count = { type = "number", optional = true },
        TextureDictionary = { type = "string", optional = true },
        Texture = { type = "string", optional = true },
    },
    RpgEffects = {
        Health = { type = "table", optional = true, schema = "RpgEffect" },
        Stamina = { type = "table", optional = true, schema = "RpgEffect" },
        Deadeye = { type = "table", optional = true, schema = "RpgEffect" },
        HealthCore = { type = "table", optional = true, schema = "RpgEffect" },
        StaminaCore = { type = "table", optional = true, schema = "RpgEffect" },
        DeadeyeCore = { type = "table", optional = true, schema = "RpgEffect" },
        HealthHorse = { type = "table", optional = true, schema = "RpgEffect" },
        StaminaHorse = { type = "table", optional = true, schema = "RpgEffect" },
        HealthCoreHorse = { type = "table", optional = true, schema = "RpgEffect" },
        StaminaCoreHorse = { type = "table", optional = true, schema = "RpgEffect" },
    },
    RpgEffect = {
        Value = { type = "number", optional = true },
        Duration = { type = "number", optional = true },
    },
    SliderInfo = {
        Visible = { type = "boolean", optional = true },
        Enabled = { type = "boolean", optional = true },
        Value = { type = "number", optional = true },
        MaxValue = { type = "number", optional = true },
        TotalTanks = { type = "number", optional = true },
        ActiveTanks = { type = "number", optional = true },
    },
    BusinessInfo = {
        Visible = { type = "boolean", optional = true },
        Description = { type = "string", optional = true },
        DescriptionHash = { type = { "string", "number" }, optional = true },
        MaterialsIconDictionary = { type = "string", optional = true },
        MaterialsIcon = { type = "string", optional = true },
        ProductionIconDictionary = { type = "string", optional = true },
        ProductionIcon = { type = "string", optional = true },
        GoodsIconDictionary = { type = "string", optional = true },
        GoodsIcon = { type = "string", optional = true },
    },
    Palette = {
        Value = { type = "number", optional = true },
        Items = {
            type = "table",
            optional = true,
            items = { type = "table", schema = "PaletteItem" }
        },
    },
    PaletteItem = {
        Visible = { type = "boolean", optional = true },
        Text = { type = "string", optional = true },
        TextureDictionary = { type = "string", optional = true },
        Texture = { type = "string", optional = true },
        New = { type = "boolean", optional = true },
        Owned = { type = "boolean", optional = true },
        Equipped = { type = "boolean", optional = true },
        Locked = { type = "boolean", optional = true },
    },
}

local function wrap(schema, data, label)
    if type(schema) == "string" then
        local resolved = SCHEMAS[schema]
        if not resolved then
            error(string.format("[System] Schema '%s' not found", schema), 2)
        end
        schema = resolved
    elseif type(schema) == "function" then
        schema = schema()
    end

    if type(schema) ~= "table" then
        error(string.format("[System] Invalid schema for '%s'", label), 2)
    end

    if Config.EnforceMetadata then
        schema.Metadata = { type = "table", optional = true }
    end

    local proxy = {}

    local function verify(key, rule, value)
        if value == nil then
            if not rule.optional then
                error(string.format("[%s] Field '%s' is required", label, key), 3)
            end
            return nil
        end

        if rule.type then
            local value_type = type(value)
            local type_match = false

            if type(rule.type) == "table" then
                for _, t in ipairs(rule.type) do
                    if value_type == t then
                        type_match = true
                        break
                    end
                end
            else
                type_match = (value_type == rule.type)
            end

            if not type_match then
                local expected = type(rule.type) == "table" and
                    table.concat(rule.type, "|") or rule.type
                error(
                    string.format(
                        "[%s] Field '%s' must be %s (got %s)",
                        label,
                        key,
                        expected,
                        value_type
                    ),
                    3
                )
            end
        end

        if rule.type == "table" and rule.items then
            for i, item in ipairs(value) do
                verify(string.format("%s[%d]", key, i), rule.items, item)
            end
        end

        if rule.type == "table" and rule.schema then
            return wrap(rule.schema, value, label .. "." .. key)
        end

        return value
    end

    local function run_cross_checks()
        if schema.validate then
            schema.validate(data, label)
        end
    end

    for k, _ in pairs(data) do
        if Config.EnforceMetadata and not schema[k] then
            error(string.format("[%s] Field '%s' is not valid. If you need extra data, use 'Metadata'", label, k), 2)
        end
    end

    for k, rule in pairs(schema) do
        if k ~= "validate" then
            data[k] = verify(k, rule, data[k])
        end
    end

    run_cross_checks()

    local mt = {
        __index = data,
        __newindex = function(_, k, v)
            local rule = schema[k]
            if Config.EnforceMetadata and not rule then
                error(string.format("[%s] Field '%s' is not valid. If you need extra data, use 'Metadata'", label, k), 2)
            end

            local old_val = data[k]
            data[k] = verify(k, rule, v)

            local status, err = pcall(run_cross_checks)
            if not status then
                data[k] = old_val
                error(err, 2)
            end
        end,
        __len = function()
            return #data
        end,
        __pairs = function()
            return next, data, nil
        end,
        __tostring = function()
            return string.format("<Validated %s>", label)
        end,
        __metatable = "Modify schema to change this",
    }

    return setmetatable(proxy, mt)
end

--- Creates a new Validated Menu object
--- @param data table The initial data table
--- @param id string|nil An optional identifier for error messages, defaults to "Menu"
function ShopValidator.Menu(data, id)
    if not Config.Validate then
        return data
    end
    if type(data) ~= "table" then
        error("Expected table, got " .. type(data), 2)
    end
    return wrap(SCHEMAS.Menu, data or {}, id or "Menu")
end

--- Creates a new Validated Item object
--- @param data table The initial data table
--- @param id string|nil An optional identifier for error messages, defaults to "Item"
function ShopValidator.Item(data, id)
    if not Config.Validate then
        return data
    end
    if type(data) ~= "table" then
        error("Expected table, got " .. type(data), 2)
    end
    return wrap(SCHEMAS.Item, data or {}, id or "Item")
end
