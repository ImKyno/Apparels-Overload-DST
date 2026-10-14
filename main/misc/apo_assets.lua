local _G              = GLOBAL
local resolvefilepath = _G.resolvefilepath

Assets =
{
    Asset("IMAGE", "images/colour_cubes/batvision_cc.tex"),

    Asset("IMAGE", "images/hudimages/batvision_over.tex"),
    Asset("ATLAS", "images/hudimages/batvision_over.xml"),

    Asset("IMAGE", "images/hudimages/visor_over.tex"),
    Asset("ATLAS", "images/hudimages/visor_over.xml"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("IMAGE", "images/minimapimages/apo_minimapimages.tex"),
    Asset("ATLAS", "images/minimapimages/apo_minimapimages.xml"),

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
    "jiaolianhat",
    "peagawkfeatherhat",
    "pigskin_dried",
    "propellerhat",
    "pumpkinheadhat",

    -- Modded Skins.
    "ms_aerodynamichat_tropical",
    "ms_armor_snakeskin_scaly",
    "ms_double_umbrellahat_black",
    "ms_double_umbrellahat_cyan",
    "ms_double_umbrellahat_red",
    "ms_gasmaskhat_hazard",
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
        "metalplatehat",
        "oxhat",
        "pigcrownhat",
        "piratehat",
        "piratepack",
        "pithhat",
        "shark_fin",
        "shark_teethhat",
        "thatchsack",
    }

    for k, v in pairs(ICONS) do
        table.insert(APO_ICONS, v)
    end
end

for k, v in pairs(APO_ICONS) do
    RegisterInventoryItemAtlas(resolvefilepath("images/inventoryimages/apo_inventoryimages.xml"), v..".tex")
    RegisterInventoryItemAtlas(resolvefilepath("images/inventoryimages/apo_inventoryimages.xml"), _G.hash(v..".tex"))
end