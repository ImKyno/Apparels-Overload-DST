local _G           = GLOBAL
local TECH         = _G.TECH
local Ingredient   = _G.Ingredient
local TechTree     = require("techtree")
local RecipeFilter = require("recipes_filter")

local ABCEnabled   = _G.APORecipeAlreadyExists("cork_bat",       "corkchest")
local IASEnabled   = _G.APORecipeAlreadyExists("chiminea",       "limestone")
local HOFEnabled   = _G.APORecipeAlreadyExists("kyno_woodenkeg", "kyno_preservesjar")

local function AddRecipeAPO(condition, ...)
    if not condition then
        AddRecipe2(...)
    end
end

-- Hats.
AddRecipeAPO(ABCEnabled or IASEnabled, "aerodynamichat",
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

AddRecipeAPO(ABCEnabled or IASEnabled, "antmaskhat",
    {
        Ingredient("silk", 3),
        Ingredient("stinger", 3),
        Ingredient("footballhat", 1),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN" }
)

-- Clothing.
AddRecipeAPO(ABCEnabled or IASEnabled, "armor_ant",
    {
        Ingredient("silk", 3),
        Ingredient("stinger", 3),
        Ingredient("armorwood", 1),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "armor_blubber",
    {
        Ingredient("fishmeat", 4),
        Ingredient("glommerfuel", 1),
        Ingredient("armorwood", 1),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN", "SUMMER" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "armor_cactus",
    {
        Ingredient("cactus_meat", 4),
        Ingredient("stinger", 4),
        Ingredient("livinglog", 2),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "armor_lifejacket",
    {
        Ingredient("silk", 1),
        Ingredient("mosquitosack", 1),
        Ingredient("rope", 1),
    },

    TECH.SEAFARING_ONE, {}, { "RAIN", "SEAFARING", "SUMMER" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "armor_limestone",
    {
        Ingredient("marble", 6),
        Ingredient("cutreeds", 2),
        Ingredient("rope", 2),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "armor_metalplate",
    {
        Ingredient("cutstone", 3),
        Ingredient("rope", 2),
        Ingredient("hammer", 0),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "armor_obsidian",
    {
        Ingredient("armordragonfly", 1),
        Ingredient("mitegland", 2),
        Ingredient("redgem", 2),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "WINTER" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "armor_seashell",
    {
        Ingredient("slurtle_shellpieces", 10),
        Ingredient("kelp", 2),
        Ingredient("rope", 2),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "armor_snakeskin",
    {
        Ingredient("pigskin_dried", 2),
        Ingredient("rope", 2),
        Ingredient("boneshard", 2),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING", "RAIN", "WINTER" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "armor_tar",
    {
        Ingredient("gelblob_bottle", 3),
        Ingredient("armorwood", 1),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "armor_vortex",
    {
        Ingredient("horrorfuel", 12),
        Ingredient("voidcloth", 6),
        Ingredient("armorskeleton", 1),
    },

    TECH.LOST, {}, { "ARMOUR", "CONTAINERS", "MAGIC" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "armor_weevole",
    {
        Ingredient("mosquito", 4),
        Ingredient("pigskin_dried", 2),
        Ingredient("rope", 2),
    },

    TECH.SCIENCE_TWO, {}, { "ARMOUR", "RAIN", "RESTORATION" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "armor_windbreaker",
    {
        Ingredient("pigskin_dried", 3),
        Ingredient("rope", 1),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING", "RAIN" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "bandithat",
    {
        Ingredient("slurper_pelt", 6),
        Ingredient("rope", 2),
        Ingredient("feather_crow", 1),
    },

    TECH.SCIENCE_TWO, {}, { "CLOTHING", "RAIN" }
)

AddRecipeAPO(ABCEnabled or IASEnabled, "thatchsack",
    {
        Ingredient("cutreeds", 4),
        Ingredient("twigs", 2),
        Ingredient("rope", 1),
    },

    TECH.SCIENCE_ONE, {}, { "CONTAINERS" }
)