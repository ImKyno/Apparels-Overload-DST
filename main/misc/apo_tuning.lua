local _G       = GLOBAL
local require  = _G.require
local ACTIONS  = _G.ACTIONS

-- Mod Tunings.
TUNING.APO_DEBUG_MODE = true -- Turn off on releases.
TUNING.APO_DEFAULT_FLOATER = { "med", nil, 0.65 }

TUNING.APO_SCRAPBOOK = GetModConfigData("MOD_SCRAPBOOK")

TUNING.APO_IS_ABC_ENABLED = _G.KnownModIndex:IsModEnabled("workshop-3322803908") -- Above the Clouds.
TUNING.APO_IS_HOF_ENABLED = _G.KnownModIndex:IsModEnabled("workshop-2334209327") or _G.KnownModIndex:IsModEnabled("Heap-of-Foods-Workshop-Main") -- Heap of Foods.
TUNING.APO_IS_OAE_ENABLED = _G.KnownModIndex:IsModEnabled("workshop-3815942726") or _G.KnownModIndex:IsModEnabled("Project-Everything-DST") -- Odds and Ends.
TUNING.APO_IS_IAS_ENABLED = _G.KnownModIndex:IsModEnabled("workshop-1467214795") or _G.KnownModIndex:IsModEnabled("workshop-3435352667") -- Island Adventures.

TUNING.APO_MISC =
{
    BATVISION =
    {
        VISION_RANGE_SQ = 36,
        CUT_OFF_RANGE = 0.7,

        CC_TABLE =
        {
            day       = _G.resolvefilepath("images/colour_cubes/batvision_cc.tex"),
            dusk      = _G.resolvefilepath("images/colour_cubes/batvision_cc.tex"),
            night     = _G.resolvefilepath("images/colour_cubes/batvision_cc.tex"),
            full_moon = _G.resolvefilepath("images/colour_cubes/batvision_cc.tex"),
        },
    },

    BURIEDTREASUREFINDER =
    {
        CHANCE =
        {
            NONE = -1,
            PIRATE = 1,
            NORMAL = 0.66,
        },
    },

    EXTRALOOTDROPPER =
    {
        TAGS_BLACKLIST =
        {
            "irreplaceable",
            "sketch", -- Uh, I don't think people would want extra sketches...?
        },

        PREFABS_BLACKLIST =
        {
            "klaussackkey",
            "security_pulse_cage",
            "security_pulse_cage_full",
        },
    },

    SHARK_FIN =
    {
        HEALTH = 20,
        HUNGER = 25,
        SANITY = -15,
    },
}

TUNING.APO_ARMORS =
{
    ANT =
    {
        CONDITION = 450,
        ABSORPTION = 0.80,
        CONSUPTION = 0.05, -- For Bee Box.
        PERISHTIME = 480 * 10,

        TAGS =
        {
            "bee",
        },
    },

    BLUBBER =
    {
        CONDITION = 450,
        ABSORPTION = 0.80,
    },

    CACTUS =
    {
        CONDITION = 450,
        ABSORPTION = 0.80,
    },

    FLOWERS =
    {
        CONDITION = 250,
        ABSORPTION = 0.60,
    },

    LIMESTONE =
    {
        CONDITION = 735,
        ABSORPTION = 0.95,
        WALKSPEEDMULT = 0.70,
    },

    METALPLATE =
    {
        CONDITION = 525,
        ABSORPTION = 0.70,
        WALKSPEEDMULT = 0.90,
    },

    OBSIDIAN =
    {
        CONDITION = 1050,
        ABSORPTION = 0.95,
        WALKSPEEDMULT = 0.70,
        FIRERESIST = 1,
        OVERHEAT_DAMAGE = 5,
        LIGHT_OVERRIDE = 0.35,
        HEAT = 15,
    },

    SEASHELL =
    {
        CONDITION = 625,
        ABSORPTION = 0.70,
        DAMAGETYPE_RESIST = 0.85,
    },

    SNAKESKIN =
    {
        PERISHTIME = 480 * 8,
    },

    TAR =
    {
        CONDITION = 525,
        ABSORPTION = 0.80,
        PLANAR_ABSORPTION = 5,
        DAMAGETYPE_RESIST = 0.80,
        SHADOWLEVEL = 1,
    },

    VORTEX =
    {
        FUEL = 720,
        FUEL_RATE = 45,
        SANITY = 0.20,
        SHADOWLEVEL = 3,

        COOLDOWN =
        {
            INITIAL = 1,
            NORMAL = 5,
        },
    },

    WEEVOLE =
    {
        CONDITION = 450,
        ABSORPTION = 0.60,

        HEALTH =
        {
            MIN = 1,
            MAX = 2,
        },
    },

    WINDBREAKER =
    {
        PERISHTIME = 480 * 10,
        MOISTURE_THRESHOLD = 50,

        WALKSPEEDMULT =
        {
            NORMAL = 1.25,
            RAIN = 1.50,
        },
    },
}

TUNING.APO_HATS =
{
    AERODYNAMIC =
    {
        PERISHTIME = 480 * 3,
        WALKSPEEDMULT = 1.25,
    },

    ANTMASK =
    {
        CONDITION = 450,
        ABSORPTION = 0.80,
        CONSUPTION = 0.05, -- For Bee Box.
        PERISHTIME = 480 * 10,

        TAGS =
        {
            "bee",
        },
    },

    BANDIT =
    {
        PERISHTIME = 480,
    },

    BAT =
    {
        PERISHTIME = 480 * 2,
    },

    BRAINJELLY =
    {
        USES = 4,
    },

    BUCKET =
    {
        CONDITION = 262.5,
        ABSORPTION = 0.70,
    },

    CANDLE =
    {
        PERISHTIME = 200,
    },

    CAPTAIN =
    {
        PERISHTIME = 480 * 3,
        HUNGER_MODIFIER = 0.70,
    },
}

TUNING.PIRATEPACK =
{
    COOLDOWN = 480 * 3,

    LOOT_WEIGHTS =
    {
        COMMON = 70,
        UNCOMMON = 20,
        RARE = 8,
        ULTRA_RARE = 2,
    },

    LOOT =
    {
        COMMON =
        {
            "boneshard",
            "cookiecuttershell",
            "driftwood_log",
            "goldnugget",
            "houndstooth",
            "slurtle_shellpieces",
            "spoiled_fish",
            "spoiled_fish_small",
            "stinger",
        },

        UNCOMMON =
        {
            "feather_crow",
            "feather_robin",
            "marble",
            "moonglass",
            "moonrocknugget",
            "saltrock",
        },

        RARE =
        {
            "bluegem",
            "feather_robin_winter",
            "livinglog",
            "malbatross_feather",
            "redgem",
            "stash_map",
            "thulecite_pieces",
        },

        ULTRA_RARE =
        {
            "feather_canary",
            "greengem",
            "nightmarefuel",
            "orangegem",
            "purplegem",
            "thulecite",
            "yellowgem",
        },
    },
}