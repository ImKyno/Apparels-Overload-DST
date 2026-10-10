local _G              = GLOBAL
local resolvefilepath = _G.resolvefilepath

Assets =
{
    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("IMAGE", "images/minimapimages/apo_minimapimages.tex"),
    Asset("ATLAS", "images/minimapimages/apo_minimapimages.xml"),

    -- Asset("IMAGE", "images/hudimages/apo_hudimages.tex"),
    -- Asset("ATLAS", "images/hudimages/apo_hudimages.xml"),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

AddMinimapAtlas("images/minimapimages/apo_minimapimages.xml")

-- Mod Icons.
local APO_ICONS =
{
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
    "pigskin_dried",

    -- Modded Skins.
    "ms_armor_snakeskin_scaly",
}

for k, v in pairs(APO_ICONS) do
    RegisterInventoryItemAtlas(resolvefilepath("images/inventoryimages/apo_inventoryimages.xml"), v..".tex")
    RegisterInventoryItemAtlas(resolvefilepath("images/inventoryimages/apo_inventoryimages.xml"), _G.hash(v..".tex"))
end