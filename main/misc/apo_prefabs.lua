local _G = GLOBAL

PrefabFiles =
{
    "apo_armor_flowers",
    "apo_hats_unique",
    "apo_pigskin_dried",

    -- Modded Skins.
    "apo_skins",
}

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    local PREFABS =
    {
        "apo_armor_ant",
        "apo_armor_blubber",
        "apo_armor_cactus",
        "apo_armor_lifejacket",
        "apo_armor_limestone",
        "apo_armor_metalplate",
        "apo_armor_obsidian",
        "apo_armor_seashell",
        "apo_armor_snakeskin",
        "apo_armor_tar",
        "apo_armor_vortex",
        "apo_armor_weevole",
        "apo_armor_windbreaker",
        "apo_hats",
        "apo_piratepack",
        "apo_thatchsack",
    }

    for k, v in pairs(PREFABS) do
        table.insert(PrefabFiles, v)
    end
end

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED or TUNING.APO_IS_HOF_ENABLED then
    table.insert(PrefabFiles, "apo_shark_fin")
end