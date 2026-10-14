local _G           = GLOBAL
local TECH         = _G.TECH
local Ingredient   = _G.Ingredient
local TechTree     = require("techtree")
local RecipeFilter = require("recipes_filter")

local ABCEnabled   = _G.APORecipeAlreadyExists("cork_bat",       "corkchest")
local IASEnabled   = _G.APORecipeAlreadyExists("chiminea",       "limestone")
local HOFEnabled   = _G.APORecipeAlreadyExists("kyno_woodenkeg", "kyno_preservesjar")

local function APOAddRecipe(condition, ...)
    if not condition then
        AddRecipe2(...)
    end
end

local function APOAddCharacterRecipe(condition, ...)
    if not condition then
        AddCharacterRecipe(...)
    end
end

-- Clothing.
APOAddRecipe(ABCEnabled or IASEnabled, "armor_ant",
    {
        Ingredient("silk", 3),
        Ingredient("stinger", 3),
        Ingredient("armorwood", 1),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "armor_blubber",
    {
        Ingredient("fishmeat", 4),
        Ingredient("glommerfuel", 1),
        Ingredient("armorwood", 1),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN", "SUMMER" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "armor_cactus",
    {
        Ingredient("cactus_meat", 4),
        Ingredient("stinger", 4),
        Ingredient("livinglog", 2),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR" }
)

AddRecipe2("armor_flowers",
    {
        Ingredient("armorgrass", 1),
        Ingredient("petals", 12),
    },

    TECH.NONE, {}, { "ARMOUR" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "armor_lifejacket",
    {
        Ingredient("silk", 1),
        Ingredient("mosquitosack", 1),
        Ingredient("rope", 1),
    },

    TECH.SEAFARING_ONE, {}, { "RAIN", "SEAFARING", "SUMMER" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "armor_limestone",
    {
        Ingredient("marble", 6),
        Ingredient("cutreeds", 4),
        Ingredient("rope", 2),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "armor_metalplate",
    {
        Ingredient("cutstone", 3),
        Ingredient("rope", 2),
        Ingredient("hammer", 0),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "armor_obsidian",
    {
        Ingredient("armordragonfly", 1),
        Ingredient("mitegland", 2),
        Ingredient("redgem", 2),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "WINTER" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "armor_seashell",
    {
        Ingredient("slurtle_shellpieces", 10),
        Ingredient("kelp", 2),
        Ingredient("rope", 2),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "armor_snakeskin",
    {
        Ingredient("pigskin_dried", 2),
        Ingredient("rope", 2),
        Ingredient("boneshard", 2),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING", "RAIN", "WINTER" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "armor_tar",
    {
        Ingredient("gelblob_bottle", 3),
        Ingredient("armorwood", 1),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "armor_vortex",
    {
        Ingredient("horrorfuel", 12),
        Ingredient("voidcloth", 6),
        Ingredient("armorskeleton", 1),
    },

    TECH.LOST, {}, { "ARMOUR", "CONTAINERS", "MAGIC" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "armor_weevole",
    {
        Ingredient("mosquito", 4),
        Ingredient("pigskin_dried", 2),
        Ingredient("rope", 2),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN", "RESTORATION" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "armor_windbreaker",
    {
        Ingredient("pigskin_dried", 3),
        Ingredient("rope", 1),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING", "RAIN" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "bandithat",
    {
        Ingredient("slurper_pelt", 6),
        Ingredient("rope", 2),
        Ingredient("feather_crow", 1),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING", "RAIN" }
)

-- Hats.
APOAddRecipe(ABCEnabled or IASEnabled, "aerodynamichat",
    HOFEnabled and
    {
        Ingredient("kyno_shark_fin", 1),
        Ingredient("kyno_kokonut", 1),
        Ingredient("twigs", 3),
    }
    or
    {
        Ingredient("shark_fin", 1),
        Ingredient("log", 2),
        Ingredient("twigs", 3),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "antmaskhat",
    {
        Ingredient("silk", 3),
        Ingredient("stinger", 3),
        Ingredient("footballhat", 1),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "bathat",
    {
        Ingredient("pigskin", 2),
        Ingredient("batwing", 1),
        Ingredient("compass", 1),
    },

    TECH.SCIENCE_TWO, {}, { "LIGHT" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "brainjellyhat",
    HOFEnabled and
    {
        Ingredient("kyno_brainrock_coral", 1),
        Ingredient("kyno_jellyfish", 1),
        Ingredient("rope", 2),
    }
    or
    {
        Ingredient("barnacle", 6),
        Ingredient("kelp", 3),
        Ingredient("rope", 2),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING" }
)

AddRecipe2("buckethat",
    {
        Ingredient("log", 4),
        Ingredient("boneshard", 2),
        Ingredient("rope", 2),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "candlehat",
    {
        Ingredient("torch", 1),
        Ingredient("log", 3),
        Ingredient("rocks", 3),
    },

    TECH.SCIENCE_TWO, {}, { "LIGHT", "RAIN" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "captainhat",
    {
        Ingredient("silk", 4),
        Ingredient("kelp", 2),
        Ingredient("strawhat", 1),
    },

    TECH.SEAFARING_ONE, {}, { "SEAFARING", "CLOTHING" }
)

AddRecipe2("carnival_hosthat",
    {
        Ingredient("carnival_prizeticket", 144),
    },

    TECH.CARNIVAL_PRIZESHOP_ONE, { nounlock = true }, { "CRAFTING_STATION" }
)

APOAddCharacterRecipe(ABCEnabled or IASEnabled, "disguisehat",
    {
        Ingredient("pigskin", 1),
        Ingredient("beardhair", 1),
        Ingredient("twigs", 2),
    },

    TECH.NONE, { builder_tag = "spiderwhisperer" }, { "CHARACTER", "CLOTHING" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "double_umbrellahat",
    {
        Ingredient("eyebrellahat", 1),
        Ingredient("pigskin_dried", 3),
        Ingredient("rope", 2),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING", "RAIN", "SUMMER" }
)

AddRecipe2("extraheavyhat",
    {
        Ingredient("marble", 6),
        Ingredient("rope", 2),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "gashat",
    HOFEnabled and
    {
        Ingredient("kyno_messagebottle_empty", 1),
        Ingredient("barnacle", 3),
        Ingredient("kyno_jellyfish", 1),
    }
    or
    {
        Ingredient("messagebottleempty", 1),
        Ingredient("barnacle", 3),
        Ingredient("kelp", 1),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING", "RAIN" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "gasmaskhat",
    {
        Ingredient("goose_feather", 4),
        Ingredient("pigskin_dried", 2),
        Ingredient("moonglass", 2),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING", "RAIN" }
)

AddRecipe2("jiaolianhat",
    {
        Ingredient("driftwood_log", 4),
        Ingredient("nightmarefuel", 2),
        Ingredient("rope", 1),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "metalplatehat",
    {
        Ingredient("cutstone", 2),
        Ingredient("rope", 1),
        Ingredient("hammer", 0),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "oxhat",
    {
        Ingredient("horn", 1),
        Ingredient("footballhat", 1),
        Ingredient("slurtle_shellpieces", 1),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN" }
)

AddRecipe2("peagawkfeatherhat",
    {
        Ingredient("feather_crow", 3),
        Ingredient("feather_robin", 2),
        Ingredient("tentaclespots", 2),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "piratehat",
    {
        Ingredient("boneshard", 2),
        Ingredient("pigskin_dried", 2),
        Ingredient("rope", 1),
    },

    TECH.SEAFARING_ONE, {}, { "CLOTHING", "SEAFARING" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "pithhat",
    {
        Ingredient("pigskin_dried", 2),
        Ingredient("twigs", 3),
        Ingredient("rope", 1),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING" }
)

AddRecipe2("propellerhat",
    {
        Ingredient("minifan", 1),
        Ingredient("gears", 3),
        Ingredient("transistor", 2),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING", "SUMMER" }
)

AddRecipe2("pumpkinheadhat",
    {
        Ingredient("pumpkin", 1),
        Ingredient("axe", 0),
    },

    TECH.SCIENCE_ONE, {}, { "CLOTHING" }
)

APOAddRecipe(ABCEnabled or IASEnabled, "shark_teethhat",
    {
        Ingredient("houndstooth", 9),
        Ingredient("goldnugget", 1),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING" }
)

-- Everything else.
APOAddRecipe(ABCEnabled or IASEnabled, "thatchsack",
    {
        Ingredient("cutreeds", 4),
        Ingredient("twigs", 2),
        Ingredient("rope", 1),
    },

    TECH.SCIENCE_ONE, {}, { "CONTAINERS" }
)