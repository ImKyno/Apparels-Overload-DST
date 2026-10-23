local _G       = GLOBAL
local require  = _G.require
local ACTIONS  = _G.ACTIONS

-- Mod Tunings.
TUNING.APO_DEBUG_MODE = true -- Turn off on releases.
TUNING.APO_DEFAULT_FLOATER = { "med", nil, 0.65 }

TUNING.APO_SCRAPBOOK             = GetModConfigData("MOD_SCRAPBOOK")

TUNING.APO_TWEAK_ANTLIONHAT      = GetModConfigData("TWEAK_ANTLIONHAT")
TUNING.APO_TWEAK_ARMORMARBLE     = GetModConfigData("TWEAK_ARMORMARBLE")
TUNING.APO_TWEAK_ARMORSLURPER    = GetModConfigData("TWEAK_ARMORSLURPER")
TUNING.APO_TWEAK_ARMORSNURTLE    = GetModConfigData("TWEAK_ARMORSNURTLE")
TUNING.APO_TWEAK_ARMORRUINS      = GetModConfigData("TWEAK_ARMORRUINS")
TUNING.APO_TWEAK_BEARGERVEST     = GetModConfigData("TWEAK_BEARGERVEST")
TUNING.APO_TWEAK_BEEHAT          = GetModConfigData("TWEAK_BEEHAT")
TUNING.APO_TWEAK_CATCOONHAT      = GetModConfigData("TWEAK_CATCOONHAT")
TUNING.APO_TWEAK_COOKIECUTTERHAT = GetModConfigData("TWEAK_COOKIECUTTERHAT")
TUNING.APO_TWEAK_EARMUFFSHAT     = GetModConfigData("TWEAK_EARMUFFSHAT")
TUNING.APO_TWEAK_HAWAIIANSHIRT   = GetModConfigData("TWEAK_HAWAIIANSHIRT")
TUNING.APO_TWEAK_INSPECTACLESHAT = GetModConfigData("TWEAK_INSPECTACLESHAT")
TUNING.APO_TWEAK_MERMHAT         = GetModConfigData("TWEAK_MERMHAT")
TUNING.APO_TWEAK_MUSHROOMHAT     = GetModConfigData("TWEAK_MUSHROOMHAT")
TUNING.APO_TWEAK_RAINHAT         = GetModConfigData("TWEAK_RAINHAT")
TUNING.APO_TWEAK_REFLECTIVEVEST  = GetModConfigData("TWEAK_REFLECTIVEVEST")
TUNING.APO_TWEAK_SLURTLEHAT      = GetModConfigData("TWEAK_SLURTLEHAT")
TUNING.APO_TWEAK_SPIDERHAT       = GetModConfigData("TWEAK_SPIDERHAT")
TUNING.APO_TWEAK_SWEATERVEST     = GetModConfigData("TWEAK_SWEATERVEST")
TUNING.APO_TWEAK_TRUNKVEST_S     = GetModConfigData("TWEAK_TRUNKVEST_S")
TUNING.APO_TWEAK_TRUNKVEST_W     = GetModConfigData("TWEAK_TRUNKVEST_W")
TUNING.APO_TWEAK_WATERMELONHAT   = GetModConfigData("TWEAK_WATERMELONHAT")
TUNING.APO_TWEAK_WINTERHAT       = GetModConfigData("TWEAK_WINTERHAT")

TUNING.APO_TWEAK_FOLLOWER        = GetModConfigData("TWEAK_FOLLOWER")
TUNING.APO_TWEAK_MANNEQUIN       = GetModConfigData("TWEAK_MANNEQUIN")

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
            CREATURE = 0.33,
            NORMAL = 0.66,
            PIRATE = 1,
        },
    },

    CACTUS_FLOWER =
    {
        REPAIR_VALUE = 0.50,
    },

    DAMAGEOVERTIME =
    {
        DURATION = 4,
        INTERVAL = 0.5,
    },

    DRAGONFLY =
    {
        LOOT =
        {
            VOLCANO = 0.30,
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

    HEATVISION =
    {
        CC_TABLE =
        {
            day       = _G.resolvefilepath("images/colour_cubes/heatvision_cc.tex"),
            dusk      = _G.resolvefilepath("images/colour_cubes/heatvision_cc.tex"),
            night     = _G.resolvefilepath("images/colour_cubes/heatvision_cc.tex"),
            full_moon = _G.resolvefilepath("images/colour_cubes/heatvision_cc.tex"),
        },

        COLORS =
        {
            HOT =
            {
                BLOOM = true,
                DESATURATION = 1.0,
                MULT_COLOUR = { 0.0, 1.0, 0.5, 1.0 },
                ADD_COLOUR = { 1.0, 0.1, 0.3, 1.0 },
            },

            COLD =
            {
                BLOOM = false,
                DESATURATION = 0.7,
                MULT_COLOUR = { 0.0, 0.0, 0.3, 1.0 },
                ADD_COLOUR = { 0.1, 0.1, 0.5, 1.0 },
            },

            GROUND =
            {
                MULT_COLOUR = { 0.0, 0.1, 0.3, 1.0 },
                ADD_COLOUR  = { 0.1, 0.1, 0.5, 1.0 },
            },

            WAVES =
            {
                MULT_COLOUR = { 0.0, 0.0, 0.3, 1.0 },
                ADD_COLOUR  = { 0.1, 0.1, 0.6, 1.0 },
            },

            BLUR =
            {
                ENABLED = true,
                START_RADIUS = -5.0,
                STRENGTH = 0.16,
            },
        },
    },

    MUSHROOM_TO_HATS =
    {
        GROUND =
        {
            blue_mushroom  = { hat = "blue_mushroomhat",  amount = 2 },
            green_mushroom = { hat = "green_mushroomhat", amount = 2 },
            red_mushroom   = { hat = "red_mushroomhat",   amount = 2 },
        },

        PLANTER =
        {
            blue_cap  = { hat = "blue_mushroomhat",  amount = 2 },
            green_cap = { hat = "green_mushroomhat", amount = 2 },
            red_cap   = { hat = "red_mushroomhat",   amount = 2 },
            moon_cap  = { hat = "moon_mushroomhat",  amount = 2 },
        },
    },

    SHARK_FIN =
    {
        HEALTH = 20,
        HUNGER = 25,
        SANITY = -15,
    },

    SHOOTVISION =
    {
        CC_TABLE =
        {
            day       = _G.resolvefilepath("images/colour_cubes/shootvision_cc.tex"),
            dusk      = _G.resolvefilepath("images/colour_cubes/shootvision_cc.tex"),
            night     = _G.resolvefilepath("images/colour_cubes/shootvision_cc.tex"),
            full_moon = _G.resolvefilepath("images/colour_cubes/shootvision_cc.tex"),
        },
    },

    STATEGRAPH_ATTACKS_WHITELIST = -- States that can be speedup by attack speed modifiers.
    {
        "attack",
        "slingshot_shoot",
        "wx_spin",
        "wx_spin_start",
        "blowdart",
        "throw",
        "attack_pillow_pre",
        "attack_prop_pre",
        "multithrust_pre",
        "helmsplitter_pre",
    },

    TOWNPORTALTALISMAN =
    {
        REPAIR_VALUE = 100, -- 100 Uses.
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

    BEARGERVEST =
    {
        BONUS = 50,

        SLEEPINGBAG =
        {
            HEALTH = 1.25,
            HUNGER = 0.25,
            SANITY = 1.25, 
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

    HAWAIIANSHIRT =
    {
        OVERHEAT_DAMAGE = 5,
        PERISH_DAMAGE = 0.03,
    },

    LIMESTONE =
    {
        CONDITION = 735,
        ABSORPTION = 0.95,
        WALKSPEEDMULT = 0.70,
    },

    MARBLE = -- This is for the Set Bonus.
    {
        THRESHOLD = 0.50,
        DURATION = 4,
        INTERVAL = 0.5,
    },

    METALPLATE =
    {
        CONDITION = 550,
        ABSORPTION = 0.85,
        WALKSPEEDMULT = 0.85,
        MODIFIER = 1.10,
    },

    OBSIDIAN =
    {
        CONDITION = 1050,
        ABSORPTION = 0.95,
        WALKSPEEDMULT = 0.70,
        FIRERESIST = 1,
        FREEZING_DAMAGE = 5,
        LIGHT_OVERRIDE = 0.35,
        HEAT = 15,
    },

    REFLECTIVEVEST =
    {
        BONUS = 15,
    },

    SEASHELL =
    {
        CONDITION = 625,
        ABSORPTION = 0.70,
        DAMAGETYPE_RESIST = 0.20,
    },

    SLURPER =
    {
        BONUS = 100,
        HUNGER_MODIFIER = 0.50,
    },

    SNAKESKIN =
    {
        PERISHTIME = 480 * 8,

        SET_BONUS =
        {
            PERIOD = 5,

            AMOUNT =
            {
                MIN = 1,
                MAX = 3,
            },
        },
    },

    SNURTLE =
    {
        DAMAGETYPE_RESIST = 0.10,
    },

    SWEATERVEST =
    {
        BONUS = 50,
    },

    TAR =
    {
        CONDITION = 525,
        ABSORPTION = 0.80,
        PLANAR_ABSORPTION = 5,
        DAMAGETYPE_RESIST = 0.95,
        SHADOWLEVEL = 2,
    },

    THULECITE =
    {
        COOLDOWN = 15,
        MODIFIER = 1.25,
    },

    TRUNKVEST =
    {
        WALKSPEEDMULT = 1.15,
        HUNGER_MODIFIER = 0.85,
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
        CONDITION = 315,
        ABSORPTION = 0.65,
        PERISHTIME = 480 * 3,

        HEALTH =
        {
            MIN = 1,
            MAX = 3,
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

    ANTLION =
    {
        USES = 1000,
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
        SANITY_COST = 0.30, -- 30% Sanity each craft.
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
        HUNGER_MODIFIER = 0.75,
    },

    CARNIVAL_HOST =
    {
        PERISHTIME = 480 * 5,
        WALKSPEEDMULT = 1.20,
        LUCK = 2,
    },

    CATCOON =
    {
        HUNGER_MODIFIER = 0.85,
    },

    DOUBLE_UMBRELLA =
    {
        PERISHTIME = 480 * 12,
    },

    EXTRAHEAVY =
    {
        CONDITION = 735,
        ABSORPTION = 0.95,
        WALKSPEEDMULT = 0.70,
    },

    FOODBASKET =
    {
        BONUS = 50,
        HUNGER_MODIFIER = 0.75,
    },

    FOODBONUS =
    {
        BONUS = 0.20,
    },

    HEALINGBONUS =
    {
        BONUS = 25,

        REGEN =
        {
            AMOUNT = 2,
            PERIOD = 1.5,
            THRESHOLD = 0.65,
        },
    },

    GAS =
    {
        PERISHTIME = 480 * 10,
    },

    GASMASK =
    {
        PERISHTIME = 480 * 3,
    },

    HIVE =
    {
        SANITY = 2,
    },

    JIAOLIAN =
    {
        CONDITION = 450,
        ABSORPTION = 0.80,

        TAGS =
        {
            "ghost",
            "hallowed_merm",
            "herald_frog",
            "merm",
            "pig",
            "shadowcreature",
            "shadow_aligned",
        },
    },

    LIFESTEAL =
    {
        USES = 250,
        WALKSPEEDMULT = 1.10,
        SHADOWLEVEL = 2,

        LIFESTEAL =
        {
            AMOUNT = 2.5,
            LOSS = 1.5,
        },
    },

    LUCKYTREASURE =
    {
        PERISHTIME = 480 * 10,
        SECTIONS = 6,
        LUCK = 3,
    },

    METALPLATE =
    {
        CONDITION = 550,
        ABSORPTION = 0.85,
        WALKSPEEDMULT = 0.85,
    },

    MINOTAURCROWN =
    {
        CONDITION = 1260,
        ABSORPTION = 0.95,
        WALKSPEEDMULT = 1.10,
        SHADOWLEVEL = 2,
        MODIFIER = 1.25,
        MIN_ATTACK_PERIOD_MULT = 0.75, -- 25% Attack Speed.
    },

    PEAGAWKFEATHER =
    {
        PERISHTIME = 480 * 8,
        BIRD_SPAWN_MAXDELTA = 3,

        BIRD_SPAWN_DELAYDELTA =
        {
            MIN = -3,
            MAX = -5,
        },
    },

    OX =
    {
        CONDITION = 500,
        ABSORPTION = 0.80,
        DAMAGETYPE_RESIST = 0.60,
    },

    PIGCROWN =
    {
        GOLDVALUE = 100,

        MODIFIERS =
        {
            DAMAGE = 1.25,
            HEALTH = 1.25,
        },
    },

    PIRATE =
    {
        PERISHTIME = 480 * 3,
        MODIFIER = 1.25,
    },

    PITH =
    {
        PERISHTIME = 480 * 6,
        SLOWMULTIPLIER = 0.25,
    },

    PROPELLER =
    {
        PERISHTIME = 480 * 4,
        FUEL_BONUS_MULT = 4,
        WALKSPEEDMULT = 1.10,
        HEAT = -15,
    },

    SHARK_TEETH =
    {
        PERISHTIME = 480 * 6,
        LUCK = 2.0,
    },

    SLURTLE =
    {
        DAMAGETYPE_RESIST = 0.10,
    },

    SNAKESKIN =
    {
        PERISHTIME = 480 * 8,
    },

    SPIDER =
    {
        PERISHTIME = 360,

        MODIFIERS =
        {
            DAMAGE = 1.25,
        },
    },

    THUNDER =
    {
        PERISHTIME = 480 * 8,
        CONSUPTION = 200, -- About 5% each hit.

        CHARGE =
        {
            DAMAGE =
            {
                PICKUP = 10,
                EXPLOSION = 30,
            },

            DURATION = 480 / 2,
            MAX_DURATION = 480 * 10,
        },

        LIGHT =
        {
            RADIUS = 3,
            LIGHT_OVERRIDE = 0.35,
        },
    },

    SANITYDAMAGE =
    {
        CONDITION = 315,
        ABSORPTION = 0.40,
        DAMAGETYPE_RESIST = 0.50,
    },

    VOLCANOCOLD =
    {
        PERISHTIME = 480 * 6,
        FUEL_BONUS_MULT = 4,
        HEAT = -50,

        LIGHT =
        {
            RADIUS = 3,
            LIGHT_OVERRIDE = 0.35,
        },
    },

    VOLCANO =
    {
        PERISHTIME = 480 * 6,
        FUEL_BONUS_MULT = 4,
        HEAT = 50,

        LIGHT =
        {
            RADIUS = 3,
            LIGHT_OVERRIDE = 0.35,
        },
    },

    WAGSTAFF_GOGGLES =
    {
        PERISHTIME = 480 * 12,

        DANGER =
        {
            CANT_TAGS =
            {
                "FX",
                "DECOR",
                "INLIMBO",
            },

            MUST_TAGS =
            {
                "invisible",
            },

            ONEOF_TAGS =
            {
                "tentacle",
                "hidden_danger",
            },
        },
    },

    WAGSTAFF_GOGGLES_ARMOR =
    {
        CONDITION = 600,
        ABSORPTION = 0.85,
        PLANAR_ABSORPTION = 5,
        WALKSPEEDMULT = 0.90,
    },

    WAGSTAFF_GOGGLES_HEAT =
    {
        PERISHTIME = 480 * 2,
        FUEL_BONUS_MULT = 4,
    },

    WAGSTAFF_GOGGLES_SHOOT =
    {
        PERISHTIME = 480 * 2,
        FUEL_BONUS_MULT = 4,
        CONSUPTION = 100, -- About 10% each shot.
        MOISTURE_THRESHOLD = 25,
        DAMAGE = 60,
        DAMAGE_MOISTURE = 10, -- Damage to self when using it while wetness is high enough.
        RANGE = 10,
    },

    WILLOWOLD =
    {
        PERISHTIME = 480 * 4,

        MODIFIERS =
        {
            DAMAGE = 1.25,
            HEALTH = 1.25,
        },
    },

    WINTER =
    {
        BONUS = 15,
    },
}

TUNING.APO_LANTERNBOTTLE =
{
    PERISHTIME = 480 * 1.5,
    FUEL_BONUS_MULT = 1.7,
}

TUNING.APO_LEIF_STALK =
{
    HEALTH = 0,
    HUNGER = 12.5,
    SANITY = -10,
}

TUNING.APO_LEIF_WALKINGSTICK =
{
    PERISHTIME = 480 * 3,
    WALKSPEEDMULT = 1.30,
    DAMAGE = 20.4,
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
            "feather_canary",
            "feather_robin_winter",
            "livinglog",
            "redgem",
            "stash_map",
            "thulecite_pieces",
        },

        ULTRA_RARE =
        {
            "greengem",
            "malbatross_feather",
            "nightmarefuel",
            "orangegem",
            "purplegem",
            "thulecite",
            "yellowgem",
        },
    },
}