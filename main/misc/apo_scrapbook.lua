-- Scrapbook code done by LeWasp: https://steamcommunity.com/id/mpinheiro19
local _G               = GLOBAL
local require          = _G.require
local ScrapbookPrefabs = require("scrapbook_prefabs")
local ScrapbookData    = require("screens/redux/scrapbookdata")

-- Perishable References.
--[[
    TUNING.PERISH_SUPERFAST  = 1440  - 3  DAYS
    TUNING.PERISH_FAST       = 2880  - 6  DAYS
    TUNING.PERISH_FASTISH    = 3840  - 8  DAYS
    TUNING.PERISH_MED        = 4800  - 10 DAYS
    TUNING.PERISH_SLOW       = 7200  - 15 DAYS
    TUNING.PERISH_PRESERVED  = 9600  - 20 DAYS
    TUNING.PERISH_SUPERSLOW  = 19200 - 40 DAYS
    TUNING.RABBIT_PERISHTIME = 2400  - 5  DAYS
]]--

-- Fuel References.
--[[
    TUNING.TINY_FUEL      = 7.5
    TUNING.SMALL_FUEL     = 15
    TUNING.MED_FUEL       = 45
    TUNING.MED_LARGE_FUEL = 90
    TUNING.LARGE_FUEL     = 180
    TUNING.HUGE_FUEL      = 270
]]--

local function AddScrapbookDeps(data, prefabs, deps)
    for _, prefab in ipairs(prefabs) do
        if data[prefab] ~= nil then
            data[prefab].deps = data[prefab].deps or {}

            for _, dep in ipairs(deps) do
                table.insert(data[prefab].deps, dep)
            end
        end
    end
end

local function RemoveScrapbookDeps(data, prefabs, deps)
    for _, prefab in ipairs(prefabs) do
        if data[prefab] ~= nil and data[prefab].deps ~= nil then
            for i = #data[prefab].deps, 1, -1 do
                for _, dep in ipairs(deps) do
                    if data[prefab].deps[i] == dep then
                        table.remove(data[prefab].deps, i)
                        break
                    end
                end
            end
        end
    end
end

-- Register the entries in the Scrapbook.
local function AddExtraScrapBookItem(sbdata, sbprefab, sbtable)
    for k, v in pairs(sbtable) do
        sbprefab[k] = true
        sbdata[k] = v
    end
end

local APO_SCRAPBOOK_BODY =
{
    armor_ant =
    {
        name                = "armor_ant",
        prefab              = "armor_ant",
        tex                 = "armor_ant.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMOR_ANT.CONDITION,
        absorb_percent      = TUNING.APO_ARMOR_ANT.ABSORPTION,
        fueltype            = "BURNABLE",
        fuelvalue           = TUNING.LARGE_FUEL,
        burnable            = true,
        bank                = "armor_ant",
        build               = "armor_ant",
        anim                = "anim",
        deps                = { "silk", "stinger", "armorwood", "bee", "killerbee", "researchlab2" },
        specialinfo         = "ARMOR_ANT",
    },

    armor_blubber =
    {
        name                = "armor_blubber",
        prefab              = "armor_blubber",
        tex                 = "armor_blubber.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMOR_BLUBBER.CONDITION,
        absorb_percent      = TUNING.APO_ARMOR_BLUBBER.ABSORPTION,
        waterproofer        = TUNING.WATERPROOFNESS_ABSOLUTE,
        insulator           = TUNING.INSULATION_MED,
        insulator           = "SUMMER",
        bank                = "armor_blubber",
        build               = "armor_blubber",
        anim                = "anim",
        animoffsetx         = 5,
        animoffsety         = 10,
        animoffsetbgy       = -20,
        deps                = { "fishmeat", "glommerfuel", "armorwood", "researchlab2" },
    },

    armor_cactus =
    {
        name                = "armor_cactus",
        prefab              = "armor_cactus",
        tex                 = "armor_cactus.tex",
        type                = "item",
        subcat              = "armor",
        perishable          = TUNING.PERISH_MED,
        absorb_percent      = TUNING.APO_ARMOR_CACTUS.ABSORPTION,
        bank                = "armor_cactus",
        build               = "armor_cactus",
        anim                = "anim",
        animoffsetbgy       = 30,
        deps                = { "cactus_meat", "stinger", "livinglog", "researchlab2" },
        specialinfo         = "ARMOR_CACTUS",
    },

    armor_lifejacket =
    {
        name                = "armor_lifejacket",
        prefab              = "armor_lifejacket",
        tex                 = "armor_lifejacket.tex",
        type                = "item",
        subcat              = "clothing",
        dapperness          = TUNING.DAPPERNESS_SMALL,
        waterproofer        = TUNING.WATERPROOFNESS_SMALL,
        insulator           = TUNING.INSULATION_SMALL,
        insulator_type      = "summer",
        bank                = "armor_lifejacket",
        build               = "armor_lifejacket",
        anim                = "anim",
        animoffsety         = 10,
        animoffsetbgy       = -20,
        deps                = { "silk", "mosquitosack", "rope", "seafaring_prototyper" },
        specialinfo         = "ARMOR_LIFEJACKET",
    },

    armor_limestone =
    {
        name                = "armor_limestone",
        prefab              = "armor_limestone",
        tex                 = "armor_limestone.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMOR_LIMESTONE.CONDITION,
        absorb_percent      = TUNING.APO_ARMOR_LIMESTONE.ABSORPTION,
        waterproofer        = TUNING.WATERPROOFNESS_SMALL,
        dapperness          = TUNING.DAPPERNESS_SMALL,
        bank                = "armor_limestone",
        build               = "armor_limestone",
        anim                = "anim",
        animoffsety         = 10,
        animoffsetbgy       = -20,
        deps                = { "marble", "cutreeds", "rope", "researchlab2" },
        specialinfo         = "ARMOR_LIMESTONE",
    },

    armor_metalplate =
    {
        name                = "armor_metalplate",
        prefab              = "armor_metalplate",
        tex                 = "armor_metalplate.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMOR_METALPLATE.CONDITION,
        absorb_percent      = TUNING.APO_ARMOR_METALPLATE.ABSORPTION,
        bank                = "armor_metalplate",
        build               = "armor_metalplate",
        anim                = "anim",
        animoffsety         = 10,
        animoffsetbgy       = -20,
        deps                = { "cutstone", "rope", "hammer", "researchlab2" },
        specialinfo         = "ARMOR_METALPLATE",
    },

    armor_obsidian =
    {
        name                = "armor_obsidian",
        prefab              = "armor_obsidian",
        tex                 = "armor_obsidian.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMOR_OBSIDIAN.CONDITION,
        absorb_percent      = TUNING.APO_ARMOR_OBSIDIAN.ABSORPTION,
        dapperness          = TUNING.DAPPERNESS_MED,
        bank                = "armor_obsidian",
        build               = "armor_obsidian",
        anim                = "anim",
        animoffsety         = 25,
        animoffsetbgy       = -60,
        deps                = { "armordragonfly", "mitegland", "redgem", "researchlab2" },
        specialinfo         = "ARMOR_OBSIDIAN",
    },

    armor_seashell =
    {
        name                = "armor_seashell",
        prefab              = "armor_seashell",
        tex                 = "armor_seashell.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMOR_SEASHELL.CONDITION,
        absorb_percent      = TUNING.APO_ARMOR_SEASHELL.ABSORPTION,
        waterproofer        = TUNING.WATERPROOFNESS_SMALL,
        bank                = "armor_seashell",
        build               = "armor_seashell",
        anim                = "anim",
        animoffsety         = 10,
        animoffsetbgy       = -10,
        deps                = { "slurtle_shellpieces", "kelp", "rope", "researchlab2" },
        specialinfo         = "ARMOR_SEASHELL",
    },

    armor_snakeskin =
    {
        name                = "armor_snakeskin",
        prefab              = "armor_snakeskin",
        tex                 = "armor_snakeskin.tex",
        type                = "item",
        subcat              = "clothing",
        fueledmax           = TUNING.APO_ARMOR_SNAKESKIN.PERISHTIME,
        waterproofer        = TUNING.WATERPROOFNESS_LARGE,
        insulator           = TUNING.INSULATION_SMALL,
        bank                = "armor_snakeskin",
        build               = "armor_snakeskin",
        anim                = "anim",
        animoffsetx         = 3,
        animoffsety         = 10,
        deps                = { "pigskin_dried", "rope", "boneshard", "researchlab2" },
    },

    armor_tar =
    {
        name                = "armor_tar",
        prefab              = "armor_tar",
        tex                 = "armor_tar.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMOR_TAR.CONDITION,
        armor_planardefense = TUNING.APO_ARMOR_TAR.PLANAR_ABSORPTION,
        absorb_percent      = TUNING.APO_ARMOR_TAR.ABSORPTION,
        waterproofer        = TUNING.WATERPROOFNESS_ABSOLUTE,
        bank                = "armor_tar",
        build               = "armor_tar",
        anim                = "anim",
        animoffsetx         = 5,
        animoffsety         = 15,
        animoffsetbgy       = -25,
        deps                = { "gelblob_bottle", "armorwood", "researchlab2" },
    },

    armor_vortex =
    {
        name                = "armor_vortex",
        prefab              = "armor_vortex",
        tex                 = "armor_vortex.tex",
        type                = "item",
        subcat              = "backpack",
        waterproofer        = TUNING.WATERPROOFNESS_ABSOLUTE,
        fueledmax           = TUNING.APO_ARMOR_VORTEX.FUEL,
        fueledrate          = TUNING.APO_ARMOR_VORTEX.FUEL_RATE,
        fueltype1           = "NIGHTMARE",
        fueleduses          = true,
        bank                = "armor_vortex",
        build               = "armor_vortex",
        anim                = "anim",
        deps                = { "daywalker", "horrorfuel", "voidcloth", "armorskeleton" },
        specialinfo         = "ARMOR_VORTEX",
    },

    armor_weevole =
    {
        name                = "armor_weevole",
        prefab              = "armor_weevole",
        tex                 = "armor_weevole.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMOR_WEEVOLE.CONDITION,
        absorb_percent      = TUNING.APO_ARMOR_WEEVOLE.ABSORPTION,
        waterproofer        = TUNING.WATERPROOFNESS_MED,
        bank                = "armor_weevole",
        build               = "armor_weevole",
        anim                = "anim",
        animoffsetx         = 3,
        animoffsety         = 3,
        deps                = { "mosquitosack", "pigskin_dried", "rope", "researchlab2" },
        specialinfo         = "ARMOR_WEEVOLE",
    },

    armor_windbreaker =
    {
        name                = "armor_windbreaker",
        prefab              = "armor_windbreaker",
        tex                 = "armor_windbreaker.tex",
        type                = "item",
        subcat              = "clothing",
        fueledmax           = TUNING.APO_ARMOR_WINDBREAKER.PERISHTIME,
        waterproofer        = TUNING.WATERPROOFNESS_MED,
        bank                = "armor_windbreaker",
        build               = "armor_windbreaker",
        anim                = "anim",
        animoffsetx         = 3,
        animoffsety         = 15,
        animoffsetbgy       = -20,
        deps                = { "pigskin_dried", "rope", "researchlab2" },
        specialinfo         = "ARMOR_WINDBREAKER",
    },
}

local APO_SCRAPBOOK_HANDS =
{

}

local APO_SCRAPBOOK_HEAD =
{

}

local APO_SCRAPBOOK_ITEMS =
{
    pigskin_dried =
    {
        name                = "pigskin_dried",
        prefab              = "pigskin_dried",
        tex                 = "pigskin_dried.tex",
        type                = "item",
        stacksize           = TUNING.STACK_SIZE_MEDITEM,
        burnable            = true,
        bank                = "pigskin_dried",
        build               = "pigskin_dried",
        anim                = "idle",
        deps                = { "pigskin" },
    },
}

-- Add our entries to the Scrapbook.
AddExtraScrapBookItem(ScrapbookData, ScrapbookPrefabs, APO_SCRAPBOOK_BODY)
-- AddExtraScrapBookItem(ScrapbookData, ScrapbookPrefabs, APO_SCRAPBOOK_HANDS)
-- AddExtraScrapBookItem(ScrapbookData, ScrapbookPrefabs, APO_SCRAPBOOK_HEAD)
AddExtraScrapBookItem(ScrapbookData, ScrapbookPrefabs, APO_SCRAPBOOK_ITEMS)