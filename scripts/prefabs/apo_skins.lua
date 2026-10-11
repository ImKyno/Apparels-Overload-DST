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
end

return unpack(prefabs)