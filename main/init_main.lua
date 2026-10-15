local _G = GLOBAL

local INIT_MAIN_MISC =
{
    "assets",
    "constants",
    "simutil",
    "actions",
    "prefabs",
    "containers",
    "recipes",
    "recipes_sorting",
    "skins",
}

for _, v in pairs(INIT_MAIN_MISC) do
    modimport("main/misc/apo_"..v)
end

if TUNING.APO_SCRAPBOOK then
    modimport("main/misc/apo_scrapbook")
    modimport("main/misc/apo_scrapbook_extras")
end