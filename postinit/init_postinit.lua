local _G = GLOBAL

local INIT_POSTINIT_MISC =
{
    "messagebottletreasures",
}

local INIT_POSTINIT_COMPONENTS =
{
    "drownable",
    "lootdropper",
    "temperature",
}

local INIT_POSTINIT_PREFABS =
{
    "bee",
    "beebox",
    "daywalker",
    "hats",
    "pigskin",
    "prime_mate",
    "shark",
}

local INIT_POSTINIT_WIDGETS =
{
    "itemtile",
}

for _, v in pairs(INIT_POSTINIT_MISC) do
    modimport("postinit/apo_"..v)
end

for _, v in pairs(INIT_POSTINIT_COMPONENTS) do
    modimport("postinit/components/"..v)
end

for _, v in pairs(INIT_POSTINIT_PREFABS) do
    modimport("postinit/prefabs/"..v)
end

for _, v in pairs(INIT_POSTINIT_WIDGETS) do
    modimport("postinit/widgets/"..v)
end