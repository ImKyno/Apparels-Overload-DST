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

    -- Elephant Husk Skin for the Cactus Husk.
    table.insert(prefabs, CreatePrefabSkin("ms_armor_cactus_tropical",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_armor_cactus_tropical.zip"),
        },

        base_prefab = "armor_cactus",
        build_name_override = "ms_armor_cactus_tropical",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "ARMOR_CACTUS" },
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

    -- Viridian Lantern Skin for the Bottle Lantern.
    table.insert(prefabs, CreatePrefabSkin("ms_lanternbottle_green",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_lanternbottle_green.zip"),
            Asset("ANIM", "anim/dynamic/ms_swap_lanternbottle_green.zip"),
        },

        base_prefab = "lanternbottle",
        build_name_override = "ms_lanternbottle_green",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "LANTERNBOTTLE" },
    }))

    -- Cinder Lantern Skin for the Bottle Lantern.
    table.insert(prefabs, CreatePrefabSkin("ms_lanternbottle_orange",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_lanternbottle_orange.zip"),
            Asset("ANIM", "anim/dynamic/ms_swap_lanternbottle_orange.zip"),
        },

        base_prefab = "lanternbottle",
        build_name_override = "ms_lanternbottle_orange",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "LANTERNBOTTLE" },
    }))

    -- Blossom Lantern Skin for the Bottle Lantern.
    table.insert(prefabs, CreatePrefabSkin("ms_lanternbottle_pink",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_lanternbottle_pink.zip"),
            Asset("ANIM", "anim/dynamic/ms_swap_lanternbottle_pink.zip"),
        },

        base_prefab = "lanternbottle",
        build_name_override = "ms_lanternbottle_pink",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "LANTERNBOTTLE" },
    }))

    -- Twilight Lantern Skin for the Bottle Lantern.
    table.insert(prefabs, CreatePrefabSkin("ms_lanternbottle_purple",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_lanternbottle_purple.zip"),
            Asset("ANIM", "anim/dynamic/ms_swap_lanternbottle_purple.zip"),
        },

        base_prefab = "lanternbottle",
        build_name_override = "ms_lanternbottle_purple",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "LANTERNBOTTLE" },
    }))

    -- Crimson Lantern Skin for the Bottle Lantern.
    table.insert(prefabs, CreatePrefabSkin("ms_lanternbottle_red",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_lanternbottle_red.zip"),
            Asset("ANIM", "anim/dynamic/ms_swap_lanternbottle_red.zip"),
        },

        base_prefab = "lanternbottle",
        build_name_override = "ms_lanternbottle_red",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "LANTERNBOTTLE" },
    }))

    -- Seabreeze Lantern Skin for the Bottle Lantern.
    table.insert(prefabs, CreatePrefabSkin("ms_lanternbottle_turquoise",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_lanternbottle_turquoise.zip"),
            Asset("ANIM", "anim/dynamic/ms_swap_lanternbottle_turquoise.zip"),
        },

        base_prefab = "lanternbottle",
        build_name_override = "ms_lanternbottle_turquoise",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "LANTERNBOTTLE" },
    }))

    -- Sunshine Lantern Skin for the Bottle Lantern.
    table.insert(prefabs, CreatePrefabSkin("ms_lanternbottle_yellow",
    {
        assets =
        {
            Asset("ANIM", "anim/dynamic/ms_lanternbottle_yellow.zip"),
            Asset("ANIM", "anim/dynamic/ms_swap_lanternbottle_yellow.zip"),
        },

        base_prefab = "lanternbottle",
        build_name_override = "ms_lanternbottle_yellow",

        type = "item",
        rarity = "ModMade",

        skin_tags = { "LANTERNBOTTLE" },
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