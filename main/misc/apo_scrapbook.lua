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

-- Tweaks to Vanilla content.
if TUNING.APO_VANILLA_CHANGES then
    ScrapbookData.armormarble.specialinfo = "ARMOR_MARBLE"
    ScrapbookData.beehat.specialinfo = "BEEHAT"
    ScrapbookData.hivehat.specialinfo = "HIVEHAT"
end

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    ScrapbookData.bluegem.fueltype  = "BLUEGEM"
    ScrapbookData.bluegem.fuelvalue = TUNING.HUGE_FUEL

    ScrapbookData.gears.fueltype  = "GEARS"
    ScrapbookData.gears.fuelvalue = TUNING.HUGE_FUEL

    ScrapbookData.redgem.fueltype  = "REDGEM"
    ScrapbookData.redgem.fuelvalue = TUNING.HUGE_FUEL
end

AddScrapbookDeps(ScrapbookData, { "dragonfly", "daywalker" }, { "blueprint" })

-- Register the entries in the Scrapbook.
local function AddExtraScrapBookItem(sbdata, sbprefab, sbtable)
    for k, v in pairs(sbtable) do
        if v.condition == nil or v.condition then
            sbprefab[k] = true
            sbdata[k] = v
        end
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
        armor               = TUNING.APO_ARMORS.ANT.CONDITION,
        absorb_percent      = TUNING.APO_ARMORS.ANT.ABSORPTION,
        fueledmax           = TUNING.APO_ARMORS.ANT.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        fuelvalue           = TUNING.LARGE_FUEL,
        sewable             = true,
        burnable            = true,
        bank                = "armor_ant",
        build               = "armor_ant",
        anim                = "anim",
        deps                = { "silk", "stinger", "armorwood", "bee", "killerbee", "researchlab2" },
        specialinfo         = "ARMOR_ANT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    armor_blubber =
    {
        name                = "armor_blubber",
        prefab              = "armor_blubber",
        tex                 = "armor_blubber.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMORS.BLUBBER.CONDITION,
        absorb_percent      = TUNING.APO_ARMORS.BLUBBER.ABSORPTION,
        waterproofer        = TUNING.WATERPROOFNESS_ABSOLUTE,
        insulator           = TUNING.INSULATION_MED,
        insulator           = "SUMMER",
        fueltype            = "BURNABLE",
        fuelvalue           = TUNING.LARGE_FUEL,
        burnable            = true,
        bank                = "armor_blubber",
        build               = "armor_blubber",
        anim                = "anim",
        animoffsetx         = 5,
        animoffsety         = 10,
        animoffsetbgy       = -20,
        deps                = { "fishmeat", "glommerfuel", "armorwood", "researchlab2" },
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    armor_cactus =
    {
        name                = "armor_cactus",
        prefab              = "armor_cactus",
        tex                 = "armor_cactus.tex",
        type                = "item",
        subcat              = "armor",
        perishable          = TUNING.PERISH_MED,
        damage              = TUNING.ARMORBRAMBLE_DMG,
        armor               = TUNING.APO_ARMORS.CACTUS.CONDITION,
        absorb_percent      = TUNING.APO_ARMORS.CACTUS.ABSORPTION,
        fueltype            = "BURNABLE",
        fuelvalue           = TUNING.LARGE_FUEL,
        burnable            = true,
        bank                = "armor_cactus",
        build               = "armor_cactus",
        anim                = "anim",
        animoffsetbgy       = 30,
        deps                = { "cactus_meat", "stinger", "livinglog", "researchlab2" },
        specialinfo         = "ARMOR_CACTUS",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    armor_flowers =
    {
        name                = "armor_flowers",
        prefab              = "armor_flowers",
        tex                 = "armor_flowers.tex",
        type                = "item",
        subcat              = "armor",
        perishable          = TUNING.PERISH_FAST,
        armor               = TUNING.APO_ARMORS.FLOWERS.CONDITION,
        absorb_percent      = TUNING.APO_ARMORS.FLOWERS.ABSORPTION,
        dapperness          = TUNING.DAPPERNESS_TINY,
        fueltype            = "BURNABLE",
        fuelvalue           = TUNING.LARGE_FUEL,
        burnable            = true,
        bank                = "armor_flowers",
        build               = "armor_flowers",
        anim                = "anim",
        deps                = { "armorgrass", "petals", "butterfly", "bee", "killerbee" },
        specialinfo         = "ARMOR_FLOWERS",
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
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    armor_limestone =
    {
        name                = "armor_limestone",
        prefab              = "armor_limestone",
        tex                 = "armor_limestone.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMORS.LIMESTONE.CONDITION,
        absorb_percent      = TUNING.APO_ARMORS.LIMESTONE.ABSORPTION,
        waterproofer        = TUNING.WATERPROOFNESS_MED,
        dapperness          = TUNING.DAPPERNESS_SMALL,
        bank                = "armor_limestone",
        build               = "armor_limestone",
        anim                = "anim",
        animoffsety         = 10,
        animoffsetbgy       = -20,
        deps                = { "marble", "cutreeds", "rope", "researchlab2" },
        specialinfo         = "ARMOR_LIMESTONE",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    armor_metalplate =
    {
        name                = "armor_metalplate",
        prefab              = "armor_metalplate",
        tex                 = "armor_metalplate.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMORS.METALPLATE.CONDITION,
        absorb_percent      = TUNING.APO_ARMORS.METALPLATE.ABSORPTION,
        bank                = "armor_metalplate",
        build               = "armor_metalplate",
        anim                = "anim",
        animoffsety         = 10,
        animoffsetbgy       = -20,
        deps                = { "cutstone", "rope", "hammer", "metalplatehat", "researchlab2" },
        specialinfo         = "ARMOR_METALPLATE",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    armor_obsidian =
    {
        name                = "armor_obsidian",
        prefab              = "armor_obsidian",
        tex                 = "armor_obsidian.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMORS.OBSIDIAN.CONDITION,
        absorb_percent      = TUNING.APO_ARMORS.OBSIDIAN.ABSORPTION,
        dapperness          = TUNING.DAPPERNESS_MED,
        bank                = "armor_obsidian",
        build               = "armor_obsidian",
        anim                = "anim",
        animoffsety         = 25,
        animoffsetbgy       = -60,
        deps                = { "armordragonfly", "mitegland", "redgem", "researchlab2" },
        specialinfo         = "ARMOR_OBSIDIAN",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    armor_seashell =
    {
        name                = "armor_seashell",
        prefab              = "armor_seashell",
        tex                 = "armor_seashell.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMORS.SEASHELL.CONDITION,
        absorb_percent      = TUNING.APO_ARMORS.SEASHELL.ABSORPTION,
        waterproofer        = TUNING.WATERPROOFNESS_SMALL,
        bank                = "armor_seashell",
        build               = "armor_seashell",
        anim                = "anim",
        animoffsety         = 10,
        animoffsetbgy       = -10,
        deps                = { "slurtle_shellpieces", "kelp", "rope", "researchlab2" },
        specialinfo         = "ARMOR_SEASHELL",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    armor_snakeskin =
    {
        name                = "armor_snakeskin",
        prefab              = "armor_snakeskin",
        tex                 = "armor_snakeskin.tex",
        type                = "item",
        subcat              = "clothing",
        fueledmax           = TUNING.APO_ARMORS.SNAKESKIN.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        waterproofer        = TUNING.WATERPROOFNESS_LARGE,
        insulator           = TUNING.INSULATION_SMALL,
        sewable             = true,
        burnable            = true,
        bank                = "armor_snakeskin",
        build               = "armor_snakeskin",
        anim                = "anim",
        animoffsetx         = 3,
        animoffsety         = 10,
        deps                = { "pigskin_dried", "rope", "boneshard", "researchlab2" },
        specialinfo         = "ARMOR_SNAKESKIN",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    armor_tar =
    {
        name                = "armor_tar",
        prefab              = "armor_tar",
        tex                 = "armor_tar.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMORS.TAR.CONDITION,
        armor_planardefense = TUNING.APO_ARMORS.TAR.PLANAR_ABSORPTION,
        absorb_percent      = TUNING.APO_ARMORS.TAR.ABSORPTION,
        waterproofer        = TUNING.WATERPROOFNESS_ABSOLUTE,
        bank                = "armor_tar",
        build               = "armor_tar",
        anim                = "anim",
        animoffsetx         = 5,
        animoffsety         = 15,
        animoffsetbgy       = -25,
        deps                = { "gelblob_bottle", "armorwood", "researchlab2" },
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    armor_vortex =
    {
        name                = "armor_vortex",
        prefab              = "armor_vortex",
        tex                 = "armor_vortex.tex",
        type                = "item",
        subcat              = "backpack",
        waterproofer        = TUNING.WATERPROOFNESS_ABSOLUTE,
        fueledmax           = TUNING.APO_ARMORS.VORTEX.FUEL,
        fueledrate          = TUNING.APO_ARMORS.VORTEX.FUEL_RATE,
        fueltype1           = "NIGHTMARE",
        fueleduses          = true,
        bank                = "armor_vortex",
        build               = "armor_vortex",
        anim                = "anim",
        deps                = { "daywalker", "horrorfuel", "voidcloth", "armorskeleton" },
        specialinfo         = "ARMOR_VORTEX",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    armor_weevole =
    {
        name                = "armor_weevole",
        prefab              = "armor_weevole",
        tex                 = "armor_weevole.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_ARMORS.WEEVOLE.CONDITION,
        absorb_percent      = TUNING.APO_ARMORS.WEEVOLE.ABSORPTION,
        waterproofer        = TUNING.WATERPROOFNESS_MED,
        fueltype            = "BURNABLE",
        fuelvalue           = TUNING.LARGE_FUEL,
        burnable            = true,
        bank                = "armor_weevole",
        build               = "armor_weevole",
        anim                = "anim",
        animoffsetx         = 3,
        animoffsety         = 3,
        deps                = { "mosquitosack", "pigskin_dried", "rope", "researchlab2" },
        specialinfo         = "ARMOR_WEEVOLE",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    armor_windbreaker =
    {
        name                = "armor_windbreaker",
        prefab              = "armor_windbreaker",
        tex                 = "armor_windbreaker.tex",
        type                = "item",
        subcat              = "clothing",
        fueledmax           = TUNING.APO_ARMORS.WINDBREAKER.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        waterproofer        = TUNING.WATERPROOFNESS_MED,
        sewable             = true,
        burnable            = true,
        bank                = "armor_windbreaker",
        build               = "armor_windbreaker",
        anim                = "anim",
        animoffsetx         = 3,
        animoffsety         = 15,
        animoffsetbgy       = -20,
        deps                = { "pigskin_dried", "rope", "researchlab2" },
        specialinfo         = "ARMOR_WINDBREAKER",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    piratepack =
    {
        name                = "piratepack",
        prefab              = "piratepack",
        tex                 = "piratepack.tex",
        type                = "item",
        subcat              = "backpack",
        burnable            = true,
        bank                = "piratepack",
        build               = "piratepack",
        anim                = "idle",
        animoffsetx         = 5,
        deps                = { "sunkenchest", "prime_mate" },
        specialinfo         = "PIRATEPACK",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },
}

local APO_SCRAPBOOK_HANDS =
{

}

local APO_SCRAPBOOK_HEAD =
{
    aerodynamichat =
    {
        name                = "aerodynamichat",
        prefab              = "aerodynamichat",
        tex                 = "aerodynamichat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.AERODYNAMIC.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        dapperness          = TUNING.DAPPERNESS_SMALL,
        sewable             = true,
        snowmandecor        = true,
        bank                = "aerodynamichat",
        build               = "hat_aerodynamic",
        anim                = "anim",
        animoffsety         = 10,
        animoffsetbgy       = -30,
        deps                = TUNING.APO_IS_HOF_ENABLED and { "kyno_shark_fin", "kyno_kokonut", "twigs", "researchlab2" }
        or { "shark_fin", "log", "twigs", "researchlab2" },
        specialinfo         = "AERODYNAMICHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    antmaskhat =
    {
        name                = "antmaskhat",
        prefab              = "antmaskhat",
        tex                 = "antmaskhat.tex",
        type                = "item",
        subcat              = "hat",
        armor               = TUNING.APO_HATS.ANTMASK.CONDITION,
        absorb_percent      = TUNING.APO_HATS.ANTMASK.ABSORPTION,
        fueledmax           = TUNING.APO_HATS.ANTMASK.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        waterproofer        = TUNING.WATERPROOFNESS_SMALL,
        sewable             = true,
        burnable            = true,
        snowmandecor        = true,
        bank                = "antmaskhat",
        build               = "hat_antmask",
        anim                = "anim",
        deps                = { "silk", "stinger", "footballhat", "bee", "killerbee", "researchlab2" },
        specialinfo         = "ANTMASKHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    bandithat =
    {
        name                = "bandithat",
        prefab              = "bandithat",
        tex                 = "bandithat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.BANDIT.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        dapperness          = TUNING.DAPPERNESS_SMALL,
        waterproofer        = TUNING.WATERPROOFNESS_SMALL,
        sewable             = true,
        snowmandecor        = true,
        bank                = "bandithat",
        build               = "hat_bandit",
        anim                = "anim",
        deps                = { "slurper_pelt", "rope", "feather_crow", "researchlab2" },
        specialinfo         = "BANDITHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    bathat =
    {
        name                = "bathat",
        prefab              = "bathat",
        tex                 = "bathat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.BAT.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        snowmandecor        = true,
        bank                = "bathat",
        build               = "hat_bat",
        anim                = "anim",
        deps                = { "pigskin", "batwing", "compass", "researchlab2" },
        specialinfo         = "BATHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    brainjellyhat =
    {
        name                = "brainjellyhat",
        prefab              = "brainjellyhat",
        tex                 = "brainjellyhat.tex",
        type                = "item",
        subcat              = "hat",
        finiteuses          = TUNING.APO_HATS.BRAINJELLY.USES,
        snowmandecor        = true,
        bank                = "brainjellyhat",
        build               = "hat_brainjelly",
        anim                = "anim",
        animoffsetbgy       = 30,
        deps                = TUNING.APO_IS_HOF_ENABLED and { "kyno_brainrock_coral", "kyno_jellyfish", "rope", "researchlab2" }
        or { "barnacle", "kelp", "rope", "researchlab2" },
        specialinfo         = "BRAINJELLYHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    buckethat =
    {
        name                = "buckethat",
        prefab              = "buckethat",
        tex                 = "buckethat.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_HATS.BUCKET.CONDITION,
        absorb_percent      = TUNING.APO_HATS.BUCKET.ABSORPTION,
        fueltype            = "BURNABLE",
        fuelvalue           = TUNING.LARGE_FUEL,
        burnable            = true,
        snowmandecor        = true,
        bank                = "buckethat",
        build               = "hat_bucket",
        anim                = "anim",
        deps                = { "log", "boneshard", "rope", "researchlab2" },
        specialinfo         = "BUCKETHAT",
    },

    candlehat =
    {
        name                = "candlehat",
        prefab              = "candlehat",
        tex                 = "candlehat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.CANDLE.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "BURNABLE",
        waterproofer        = TUNING.WATERPROOFNESS_SMALL,
        burnable            = true,
        snowmandecor        = true,
        bank                = "candlehat",
        build               = "hat_candle",
        anim                = "anim",
        animoffsetx         = 3,
        deps                = { "torch", "log", "rocks", "researchlab" },
        specialinfo         = "CANDLEHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    captainhat =
    {
        name                = "captainhat",
        prefab              = "captainhat",
        tex                 = "captainhat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.CAPTAIN.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        dapperness          = TUNING.DAPPERNESS_LARGE,
        insulator           = TUNING.INSULATION_MED,
        insulator_type      = "summer",
        sewable             = true,
        snowmandecor        = true,
        bank                = "captainhat",
        build               = "hat_captain",
        anim                = "anim",
        deps                = { "silk", "kelp", "strawhat", "seafaring_prototyper" },
        specialinfo         = "CAPTAINHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    carnival_hosthat =
    {
        name                = "carnival_hosthat",
        prefab              = "carnival_hosthat",
        tex                 = "carnival_hosthat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.CARNIVAL_HOST.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        dapperness          = TUNING.DAPPERNESS_LARGE,
        waterproofer        = TUNING.WATERPROOFNESS_SMALL,
        sewable             = true,
        snowmandecor        = true,
        bank                = "carnival_hosthat",
        build               = "hat_carnival_host",
        anim                = "anim",
        animoffsetbgy       = 25,
        specialinfo         = "CARNIVAL_HOSTHAT",
    },

    disguisehat =
    {
        name                = "disguisehat",
        prefab              = "disguisehat",
        tex                 = "disguisehat.tex",
        type                = "item",
        subcat              = "hat",
        craftingprefab      = "webber",
        snowmandecor        = true,
        bank                = "disguisehat",
        build               = "hat_disguise",
        anim                = "anim",
        deps                = { "pigskin", "beardhair", "twigs" },
        specialinfo         = "DISGUISEHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    double_umbrellahat =
    {
        name                = "double_umbrellahat",
        prefab              = "double_umbrellahat",
        tex                 = "double_umbrellahat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.DOUBLE_UMBRELLA.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        insulator           = TUNING.INSULATION_LARGE,
        insulator_type      = "summer",
        waterproofer        = TUNING.WATERPROOFNESS_ABSOLUTE,
        sewable             = true,
        snowmandecor        = true,
        bank                = "double_umbrellahat",
        build               = "hat_double_umbrella",
        anim                = "anim",
        deps                = { "eyebrellahat", "pigskin_dried", "rope", "researchlab2" },
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    extraheavyhat =
    {
        name                = "extraheavyhat",
        prefab              = "extraheavyhat",
        tex                 = "extraheavyhat.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_HATS.EXTRAHEAVY.CONDITION,
        absorb_percent      = TUNING.APO_HATS.EXTRAHEAVY.ABSORPTION,
        snowmandecor        = true,
        bank                = "extraheavyhat",
        build               = "hat_extraheavy",
        anim                = "anim",
        animoffsetx         = -5,
        animoffsety         = 10,
        animoffsetbgy       = -20,
        deps                = { "marble", "rope", "armormarble", "researchlab2" },
        specialinfo         = "EXTRAHEAVYHAT",
    },

    foodbaskethat =
    {
        name                = "foodbaskethat",
        prefab              = "foodbaskethat",
        tex                 = "foodbaskethat.tex",
        type                = "item",
        subcat              = "hat",
        perishable          = TUNING.PERISH_MED,
        dapperness          = TUNING.DAPPERNESS_MED,
        burnable            = true,
        snowmandecor        = true,
        bank                = "foodbaskethat",
        build               = "hat_foodbasket",
        anim                = "anim",
        deps                = { "petals", "carrot", "cave_banana", "berries", "silk", "researchlab2" },
        specialinfo         = "FOODBASKETHAT",
    },

    gashat =
    {
        name                = "gashat",
        prefab              = "gashat",
        tex                 = "gashat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.GAS.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        dapperness          = TUNING.DAPPERNESS_TINY,
        sewable             = true,
        snowmandecor        = true,
        bank                = "gashat",
        build               = "hat_gas",
        anim                = "anim",
        deps                = TUNING.APO_IS_HOF_ENABLED and { "kyno_messagebottle_empty", "barnacle", "kyno_jellyfish",
        "researchlab2" } or { "messagebottleempty", "barnacle", "kelp", "researchlab2" },
        specialinfo         = "GASHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    gasmaskhat =
    {
        name                = "gasmaskhat",
        prefab              = "gasmaskhat",
        tex                 = "gasmaskhat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.GASMASK.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        dapperness          = TUNING.CRAZINESS_SMALL,
        waterproofer        = TUNING.WATERPROOFNESS_SMALL,
        sewable             = true,
        snowmandecor        = true,
        bank                = "gasmaskhat",
        build               = "hat_gasmask",
        anim                = "anim",
        deps                = { "goose_feather", "pigskin_dried", "moonglass", "researchlab2" },
        specialinfo         = "GASMASKHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    jiaolianhat =
    {
        name                = "jiaolianhat",
        prefab              = "jiaolianhat",
        tex                 = "jiaolianhat.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_HATS.JIAOLIAN.CONDITION,
        absorb_percent      = TUNING.APO_HATS.JIAOLIAN.ABSORPTION,
        burnable            = true,
        snowmandecor        = true,
        bank                = "jiaolianhat",
        build               = "hat_jiaolian",
        anim                = "anim",
        deps                = { "driftwood_log", "nightmarefuel", "rope", "researchlab2" },
        specialinfo         = "JIAOLIANHAT",
    },

    metalplatehat =
    {
        name                = "metalplatehat",
        prefab              = "metalplatehat",
        tex                 = "metalplatehat.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_HATS.METALPLATE.CONDITION,
        absorb_percent      = TUNING.APO_HATS.METALPLATE.ABSORPTION,
        snowmandecor        = true,
        bank                = "metalplatehat",
        build               = "hat_metalplate",
        anim                = "anim",
        deps                = { "cutstone", "rope", "hammer", "armor_metalplate", "researchlab2" },
        specialinfo         = "METALPLATEHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    oxhat =
    {
        name                = "oxhat",
        prefab              = "oxhat",
        tex                 = "oxhat.tex",
        type                = "item",
        subcat              = "armor",
        armor               = TUNING.APO_HATS.OX.CONDITION,
        absorb_percent      = TUNING.APO_HATS.OX.ABSORPTION,
        waterproofer        = TUNING.WATERPROOFNESS_SMALL,
        snowmandecor        = true,
        bank                = "oxhat",
        build               = "hat_ox",
        anim                = "anim",
        deps                = { "horn", "footballhat", "slurtle_shellpieces", "beefalo", "researchlab2" },
        specialinfo         = "OXHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    peagawkfeatherhat =
    {
        name                = "peagawkfeatherhat",
        prefab              = "peagawkfeatherhat",
        tex                 = "peagawkfeatherhat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.PEAGAWKFEATHER.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        dapperness          = TUNING.DAPPERNESS_SMALL,
        sewable             = true,
        snowmandecor        = true,
        bank                = "peagawkfeatherhat",
        build               = "hat_peagawkfeather",
        anim                = "anim",
        deps                = { "feather_crow", "feather_robin", "tentaclespots", "researchlab2" },
        specialinfo         = "PEAGAWKFEATHERHAT",
    },

    pigcrownhat =
    {
        name                = "pigcrownhat",
        prefab              = "pigcrownhat",
        tex                 = "pigcrownhat.tex",
        type                = "item",
        subcat              = "hat",
        dapperness          = TUNING.DAPPERNESS_MED_LARGE,
        waterproofer        = TUNING.WATERPROOFNESS_MED,
        snowmandecor        = true,
        bank                = "pigcrownhat",
        build               = "hat_pigcrown",
        anim                = "anim",
        animoffsetx         = -2,
        deps                = { "beequeen", "pigking" },
        specialinfo         = "PIGCROWNHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    piratehat =
    {
        name                = "piratehat",
        prefab              = "piratehat",
        tex                 = "piratehat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.PIRATE.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        dapperness          = TUNING.DAPPERNESS_SMALL,
        waterproofer        = TUNING.WATERPROOFNESS_SMALL,
        sewable             = true,
        burnable            = true,
        snowmandecor        = true,
        bank                = "piratehat",
        build               = "hat_pirate",
        anim                = "anim",
        animoffsetbgy       = 25,
        deps                = { "boneshard", "pigskin_dried", "rope", "seafaring_prototyper" },
        specialinfo         = "PIRATEHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    pithhat =
    {
        name                = "pithhat",
        prefab              = "pithhat",
        tex                 = "pithhat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.PITH.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        dapperness          = TUNING.DAPPERNESS_SMALL,
        waterproofer        = TUNING.WATERPROOFNESS_SMALL,
        sewable             = true,
        burnable            = true,
        snowmandecor        = true,
        bank                = "pithhat",
        build               = "hat_pith",
        anim                = "anim",
        animoffsetbgy       = 25,
        deps                = { "pigskin_dried", "twigs", "rope", "researchlab2" },
        specialinfo         = "PITHHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    propellerhat =
    {
        name                = "propellerhat",
        prefab              = "propellerhat",
        tex                 = "propellerhat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.PROPELLER.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "GEARS",
        insulator           = TUNING.INSULATION_MED,
        insulator_type      = "summer",
        snowmandecor        = true,
        bank                = "propellerhat",
        build               = "hat_propeller",
        anim                = "anim",
        animoffsety         = 10,
        animoffsetbgy       = -20,
        deps                = { "minifan", "gears", "transistor", "researchlab2" },
        specialinfo         = "PROPELLERHAT",
    },

    pumpkinheadhat =
    {
        name                = "pumpkinheadhat",
        prefab              = "pumpkinheadhat",
        tex                 = "pumpkinheadhat.tex",
        type                = "item",
        subcat              = "hat",
        perishable          = TUNING.PERISH_FAST,
        dapperness          = TUNING.CRAZINESS_SMALL,
        burnable            = true,
        waxable             = true,
        snowmandecor        = true,
        bank                = "pumpkinheadhat",
        build               = "hat_pumpkinhead",
        anim                = "anim",
        deps                = { "pumpkin", "researchlab" },
        specialinfo         = "PUMPKINHEADHAT",
    },

    shark_teethhat =
    {
        name                = "shark_teethhat",
        prefab              = "shark_teethhat",
        tex                 = "shark_teethhat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.SHARK_TEETH.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        dapperness          = TUNING.DAPPERNESS_MED_LARGE,
        sewable             = true,
        snowmandecor        = true,
        bank                = "shark_teethhat",
        build               = "hat_shark_teeth",
        anim                = "anim",
        animoffsetbgy       = 25,
        deps                = { "houndstooth", "goldnugget", "researchlab2" },
        specialinfo         = "SHARK_TEETHHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    snakeskinhat =
    {
        name                = "snakeskinhat",
        prefab              = "snakeskinhat",
        tex                 = "snakeskinhat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.SNAKESKIN.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        waterproofer        = TUNING.WATERPROOFNESS_LARGE,
        sewable             = true,
        snowmandecor        = true,
        bank                = "snakeskinhat",
        build               = "hat_snakeskin",
        anim                = "anim",
        deps                = { "pigskin_dried", "boneshard", "strawhat", "armor_snakeskin", "researchlab2" },
        specialinfo         = "SNAKESKINHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    thunderhat =
    {
        name                = "thunderhat",
        prefab              = "thunderhat",
        tex                 = "thunderhat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.THUNDER.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "USAGE",
        dapperness          = TUNING.DAPPERNESS_SMALL,
        waterproofer        = TUNING.WATERPROOFNESS_MED,
        snowmandecor        = true,
        bank                = "thunderhat",
        build               = "hat_thunder",
        anim                = "anim",
        animoffsetx         = 5,
        animoffsety         = 10,
        animoffsetbgy       = -30,
        deps                = { "feather_canary", "steelwool", "rope", "researchlab2" },
        specialinfo         = "THUNDERHAT",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },

    volcanocoldhat =
    {
        name                = "volcanocoldhat",
        prefab              = "volcanocoldhat",
        tex                 = "volcanocoldhat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.VOLCANOCOLD.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "BLUEGEM",
        insulator           = TUNING.INSULATION_LARGE,
        insulator_type      = "summer",
        waterproofer        = TUNING.WATERPROOFNESS_LARGE,
        snowmandecor        = true,
        bank                = "volcanocoldhat",
        build               = "hat_volcanocold",
        anim                = "anim_off",
        deps                = { "dragonfly", "heatrock", "bluegem", "strawhat" },
        specialinfo         = "VOLCANOCOLDHAT",
    },

    volcanohat =
    {
        name                = "volcanohat",
        prefab              = "volcanohat",
        tex                 = "volcanohat.tex",
        type                = "item",
        subcat              = "hat",
        fueledmax           = TUNING.APO_HATS.VOLCANO.PERISHTIME,
        fueledrate          = 1,
        fueledtype1         = "REDGEM",
        insulator           = TUNING.INSULATION_LARGE,
        waterproofer        = TUNING.WATERPROOFNESS_LARGE,
        snowmandecor        = true,
        bank                = "volcanohat",
        build               = "hat_volcano",
        anim                = "anim_off",
        deps                = { "dragonfly", "heatrock", "redgem", "strawhat" },
        specialinfo         = "VOLCANOHAT",
    },
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

    shark_fin =
    {
        name                = "shark_fin",
        prefab              = "shark_fin",
        tex                 = "shark_fin.tex",
        type                = "food",
        stacksize           = TUNING.STACK_SIZE_MEDITEM,
        perishable          = TUNING.PERISH_FAST,
        healthvalue         = TUNING.APO_MISC.SHARK_FIN.HEALTH,
        hungervalue         = TUNING.APO_MISC.SHARK_FIN.HUNGER,
        sanityvalue         = TUNING.APO_MISC.SHARK_FIN.SANITY,
        foodtype            = "MEAT",
        burnable            = true,
        bank                = "shark_fin",
        build               = "shark_fin",
        anim                = "idle",
        animoffsetx         = -3,
        animoffsety         = 20,
        animoffsetbgy       = -50,
        deps                = { "shark" },
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED or TUNING.APO_IS_HOF_ENABLED,
    },

    thatchsack =
    {
        name                = "thatchsack",
        prefab              = "thatchsack",
        tex                 = "thatchsack.tex",
        type                = "item",
        burnable            = true,
        bank                = "thatchsack",
        build               = "thatchsack",
        anim                = "idle",
        deps                = { "cutreeds", "twigs", "rope", "researchlab" },
        specialinfo         = "THATCHSACK",
        condition           = not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED,
    },
}

-- Add our entries to the Scrapbook.
AddExtraScrapBookItem(ScrapbookData, ScrapbookPrefabs, APO_SCRAPBOOK_BODY)
-- AddExtraScrapBookItem(ScrapbookData, ScrapbookPrefabs, APO_SCRAPBOOK_HANDS)
AddExtraScrapBookItem(ScrapbookData, ScrapbookPrefabs, APO_SCRAPBOOK_HEAD)
AddExtraScrapBookItem(ScrapbookData, ScrapbookPrefabs, APO_SCRAPBOOK_ITEMS)