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
    "health",
    "lootdropper",
    "playeractionpicker",
    "playervision",
    "temperature",
    "walkableplatformplayer",
}

local INIT_POSTINIT_PREFABS =
{
    "armor_marble",
    "bee",
    "beebox",
    "beequeen",
    "daywalker",
    "gears",
    "hats",
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
    "craftingmenu_hud",
    "craftingmenu_ingredients",
    "craftingmenu_widget",
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