local prefabs = {}

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    -- Tropical Sleek Hat Skin for the Sleek Hat.
    table.insert(prefabs, CreatePrefabSkin("ms_aerodynamichat_tropical",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_hat_aerodynamic_tropical.zip"),
        },

        base_prefab = "aerodynamichat",
        build_name_override = "ms_hat_aerodynamic_tropical",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "AERODYNAMICHAT" },
    }))

    -- Scaly Leather Jacket Skin for the Leather Jacket.
    table.insert(prefabs, CreatePrefabSkin("ms_armor_snakeskin_scaly",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_armor_snakeskin_scaly.zip"),
        },

        base_prefab = "armor_snakeskin",
        build_name_override = "ms_armor_snakeskin_scaly",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "ARMOR_SNAKESKIN" },
    }))

    -- Noir Dumbrella Skin for the Dumbrella.
    table.insert(prefabs, CreatePrefabSkin("ms_double_umbrellahat_black",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_hat_double_umbrella_black.zip"),
        },

        base_prefab = "double_umbrellahat",
        build_name_override = "ms_hat_double_umbrella_black",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "DOUBLE_UMBRELLAHAT" },
    }))

    -- Cerulean Dumbrella Skin for the Dumbrella.
    table.insert(prefabs, CreatePrefabSkin("ms_double_umbrellahat_cyan",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_hat_double_umbrella_cyan.zip"),
        },

        base_prefab = "double_umbrellahat",
        build_name_override = "ms_hat_double_umbrella_cyan",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "DOUBLE_UMBRELLAHAT" },
    }))

    -- Scarlet Dumbrella Skin for the Dumbrella.
    table.insert(prefabs, CreatePrefabSkin("ms_double_umbrellahat_red",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_hat_double_umbrella_red.zip"),
        },

        base_prefab = "double_umbrellahat",
        build_name_override = "ms_hat_double_umbrella_red",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "DOUBLE_UMBRELLAHAT" },
    }))

    -- Hazard Mask Skin for the Gas Mask.
    table.insert(prefabs, CreatePrefabSkin("ms_gasmaskhat_hazard",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_hat_gasmask_hazard.zip"),
        },

        base_prefab = "gasmaskhat",
        build_name_override = "ms_hat_gasmask_hazard",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "GASMASKHAT" },
    }))

    -- Scaly Leather Hat Skin for the Leather Hat.
    table.insert(prefabs, CreatePrefabSkin("ms_snakeskinhat_scaly",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_hat_snakeskin_scaly.zip"),
        },

        base_prefab = "snakeskinhat",
        build_name_override = "ms_hat_snakeskin_scaly",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "SNAKESKINHAT" },
    }))
end

return unpack(prefabs)