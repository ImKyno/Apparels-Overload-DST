local _G = GLOBAL

PrefabFiles =
{
    "apo_pigskin_dried",

    -- Modded Skins.
    "apo_skins",
}

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    table.insert(PrefabFiles, "apo_armor_ant")
    table.insert(PrefabFiles, "apo_armor_blubber")
    table.insert(PrefabFiles, "apo_armor_cactus")
    table.insert(PrefabFiles, "apo_armor_lifejacket")
    table.insert(PrefabFiles, "apo_armor_limestone")
    table.insert(PrefabFiles, "apo_armor_metalplate")
    table.insert(PrefabFiles, "apo_armor_obsidian")
    table.insert(PrefabFiles, "apo_armor_seashell")
    table.insert(PrefabFiles, "apo_armor_snakeskin")
    table.insert(PrefabFiles, "apo_armor_tar")
    table.insert(PrefabFiles, "apo_armor_vortex")
    table.insert(PrefabFiles, "apo_armor_weevole")
    table.insert(PrefabFiles, "apo_armor_windbreaker")
end