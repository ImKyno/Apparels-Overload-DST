local _G = GLOBAL

local INIT_POSTINIT_COMPONENTS =
{
    "drownable",
    "temperature",
}

local INIT_POSTINIT_PREFABS =
{
    "bee",
    "beebox",
    "daywalker",
    "hats",
    "pigskin",
}

for _, v in pairs(INIT_POSTINIT_COMPONENTS) do
    modimport("postinit/components/"..v)
end

for _, v in pairs(INIT_POSTINIT_PREFABS) do
    modimport("postinit/prefabs/"..v)
end