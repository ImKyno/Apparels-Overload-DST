local _G = GLOBAL

local INIT_POSTINIT_MISC =
{
    "messagebottletreasures",
    "sim",
}

local INIT_POSTINIT_BRAINS =
{
    "beebrain",
    "butterflybrain",
}

local INIT_POSTINIT_COMPONENTS =
{
    "builder",
    "builder_replica",
    "combat",
    "drownable",
    "fuel",
    "fueled",
    "health",
    "lootdropper",
    "playeractionpicker",
    "playervision",
    "temperature",
    "walkableplatformplayer",
    "wisecracker",
}

local INIT_POSTINIT_PREFABS =
{
    "any", -- Applied to all prefabs.
    "world",

    "armor_marble",
    "bee",
    "beebox",
    "beequeen",
    "bernie_active",
    "crabking",
    "daywalker",
    "dragonfly",
    "gears",
    "gems",
    "hats",
    "lordfruitfly",
    "pigskin",
    "player",
    "player_classified",
    "prime_mate",
    "shark",
    "sleepcloud",
    "sporecloud",
}

local INIT_POSTINIT_SCREENS =
{
    "playerhud",
}

local INIT_POSTINIT_WIDGETS =
{
    "controls",
    "craftingmenu_hud",
    "craftingmenu_ingredients",
    "craftingmenu_widget",
    "gogglesover",
    "healthbadge",
    "itemtile",
}

for _, v in pairs(INIT_POSTINIT_MISC) do
    modimport("postinit/apo_"..v)
end

for _, v in pairs(INIT_POSTINIT_BRAINS) do
    modimport("postinit/brains/"..v)
end

for _, v in pairs(INIT_POSTINIT_COMPONENTS) do
    modimport("postinit/components/"..v)
end

for _, v in pairs(INIT_POSTINIT_PREFABS) do
    modimport("postinit/prefabs/"..v)
end

for _, v in pairs(INIT_POSTINIT_SCREENS) do
    modimport("postinit/screens/"..v)
end

for _, v in pairs(INIT_POSTINIT_WIDGETS) do
    modimport("postinit/widgets/"..v)
end