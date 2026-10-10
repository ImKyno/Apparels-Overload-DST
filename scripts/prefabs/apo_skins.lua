local prefabs = {}

-- Scaly Leather Jacket Skin for the Leather Jacket.
if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
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