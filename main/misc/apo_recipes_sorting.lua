local _G = GLOBAL

-- For sorting recipe.
-- From Island Adventures: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795
local function SortRecipe(a, b, filter_name, offset)
    local filter = _G.CRAFTING_FILTERS[filter_name]

    if filter and filter.recipes then
        for sortvalue, product in ipairs(filter.recipes) do
            if product == a then
                table.remove(filter.recipes, sortvalue)
                break
            end
        end

        local target_position = #filter.recipes + 1

        for sortvalue, product in ipairs(filter.recipes) do
            if product == b then
                target_position = sortvalue + offset
                break
            end
        end

        table.insert(filter.recipes, target_position, a)
    end
end

local function SortBefore(a, b, filter_name)
    SortRecipe(a, b, filter_name, 0)
end

local function SortAfter(a, b, filter_name)
    SortRecipe(a, b, filter_name, 1)
end

SortAfter("armor_weevole",     "armorwood",         "ARMOUR")
SortAfter("armor_ant",         "armor_weevole",     "ARMOUR")
SortAfter("armor_blubber",     "armor_ant",         "ARMOUR")
SortAfter("armor_cactus",      "armor_bramble",     "ARMOUR")
SortAfter("armor_vortex",      "armor_sanity",      "ARMOUR")
SortAfter("armor_seashell",    "armor_vortex",      "ARMOUR")
SortAfter("armor_limestone",   "armor_seashell",    "ARMOUR")
SortAfter("armor_metalplate",  "armor_limestone",   "ARMOUR")
SortAfter("armor_obsidian",    "armordragonfly",    "ARMOUR")
SortAfter("armor_tar",         "armor_blubber",     "ARMOUR")

SortAfter("armor_snakeskin",   "raincoat",          "CLOTHING")
SortAfter("armor_windbreaker", "armor_snakeskin",   "CLOTHING")

SortAfter("thatchsack",        "giftwrap",          "CONTAINERS")
SortAfter("armor_vortex",      "candybag",          "CONTAINERS")

SortAfter("armor_vortex",      "nightlight",        "MAGIC")

SortAfter("armor_lifejacket",  "umbrella",          "RAIN")
SortAfter("armor_weevole",     "raincoat",          "RAIN")
SortAfter("armor_snakeskin",   "armor_weevole",     "RAIN")
SortAfter("armor_windbreaker", "armor_snakeskin",   "RAIN")
SortAfter("armor_seashell",    "armor_windbreaker", "RAIN")
SortAfter("armor_limestone",   "armor_seashell",    "RAIN")
SortAfter("armor_blubber",     "armor_limestone",   "RAIN")
SortAfter("armor_tar",         "armor_blubber",     "RAIN")

SortAfter("armor_weevole",     "lifeinjector",      "RESTORATION")

SortAfter("armor_lifejacket",  "flotationcushion",  "SEAFARING")

SortAfter("armor_blubber",     "hawaiianshirt",     "SUMMER")
SortAfter("armor_lifejacket",  "reflectivevest",    "SUMMER")

SortAfter("armor_obsidian",    "beargervest",       "WINTER")