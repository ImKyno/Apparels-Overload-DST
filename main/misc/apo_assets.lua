local _G              = GLOBAL
local resolvefilepath = _G.resolvefilepath

Assets =
{
    Asset( "ANIM", "anim/player_wagstaff_goggles.zip" ),
    Asset( "ANIM", "anim/player_mount_wagstaff_goggles.zip"),

    Asset("IMAGE", "images/colour_cubes/batvision_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/heatvision_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/shootvision_cc.tex"),

    Asset("IMAGE", "images/hudimages/batvision_over.tex"),
    Asset("ATLAS", "images/hudimages/batvision_over.xml"),

    Asset("IMAGE", "images/hudimages/visor_over.tex"),
    Asset("ATLAS", "images/hudimages/visor_over.xml"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("IMAGE", "images/minimapimages/apo_minimapimages.tex"),
    Asset("ATLAS", "images/minimapimages/apo_minimapimages.xml"),

    Asset("IMAGE", "images/scrapbookimages/apo_scrapbookimages.tex"),
    Asset("ATLAS", "images/scrapbookimages/apo_scrapbookimages.xml"),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

AddMinimapAtlas("images/minimapimages/apo_minimapimages.xml")

-- Mod Icons.
local APO_ICONS =
{
    "armor_flowers",
    "buckethat",
    "carnival_hosthat",
    "extraheavyhat",
    "foodbaskethat",
    "foodbonushat",
    "healingbonushat",
    "jiaolianhat",
    "lifestealhat",
    "minotaurcrownhat",
    "peagawkfeatherhat",
    "pigskin_dried",
    "propellerhat",
    "pumpkinheadhat",
    "sanitydamagehat",
    "volcanocoldhat",
    "volcanocoldhat_off",
    "volcanohat",
    "volcanohat_off",
    "willowoldhat",

    -- Modded Skins.
    "ms_aerodynamichat_tropical",
    "ms_armor_cactus_tropical",
    "ms_armor_snakeskin_scaly",
    "ms_armor_windbreaker_tropical",
    "ms_double_umbrellahat_black",
    "ms_double_umbrellahat_cyan",
    "ms_double_umbrellahat_red",
    "ms_foodbonushat_lavaarena",
    "ms_gasmaskhat_hazard",
    "ms_healingbonushat_lavaarena",
    "ms_lanternbottle_green",
    "ms_lanternbottle_green_lit",
    "ms_lanternbottle_orange",
    "ms_lanternbottle_orange_lit",
    "ms_lanternbottle_pink",
    "ms_lanternbottle_pink_lit",
    "ms_lanternbottle_purple",
    "ms_lanternbottle_purple_lit",
    "ms_lanternbottle_red",
    "ms_lanternbottle_red_lit",
    "ms_lanternbottle_turquoise",
    "ms_lanternbottle_turquoise_lit",
    "ms_lanternbottle_yellow",
    "ms_lanternbottle_yellow_lit",
    "ms_lifestealhat_lavaarena",
    "ms_minotaurcrownhat_lavaarena",
    "ms_sanitydamagehat_lavaarena",
    "ms_snakeskinhat_scaly",
}

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    local ICONS =
    {
        "aerodynamichat",
        "antmaskhat",
        "armor_ant",
        "armor_blubber",
        "armor_cactus",
        "armor_lifejacket",
        "armor_limestone",
        "armor_metalplate",
        "armor_obsidian",
        "armor_seashell",
        "armor_snakeskin",
        "armor_tar",
        "armor_vortex",
        "armor_weevole",
        "armor_windbreaker",
        "bandithat",
        "bathat",
        "brainjellyhat",
        "candlehat",
        "captainhat",
        "disguisehat",
        "double_umbrellahat",
        "gashat",
        "gasmaskhat",
        "lanternbottle",
        "lanternbottle_lit",
        "leif_stalk",
        "leif_walkingstick",
        "luckytreasurehat",
        "metalplatehat",
        "oxhat",
        "pigcrownhat",
        "piratehat",
        "piratepack",
        "pithhat",
        "shark_fin",
        "shark_teethhat",
        "snakeskinhat",
        "thatchsack",
        "thunderhat",
        "wagstaff_goggleshat",
        "wagstaff_goggles_armorhat",
        "wagstaff_goggles_heathat",
        "wagstaff_goggles_shoothat",
    }

    for k, v in pairs(ICONS) do
        table.insert(APO_ICONS, v)
    end
end

local APO_SCRAPBOOK_ICONS =
{
    "icon_fuel_bluegem",
    "icon_fuel_gears",
    "icon_fuel_moonbutterfly",
    "icon_fuel_redgem",
}

for k, v in pairs(APO_ICONS) do
    RegisterInventoryItemAtlas(resolvefilepath("images/inventoryimages/apo_inventoryimages.xml"), v..".tex")
    RegisterInventoryItemAtlas(resolvefilepath("images/inventoryimages/apo_inventoryimages.xml"), _G.hash(v..".tex"))
end

for k, v in ipairs(APO_SCRAPBOOK_ICONS) do
    RegisterScrapbookIconAtlas("images/scrapbookimages/apo_scrapbookimages.xml", v..".tex")
end