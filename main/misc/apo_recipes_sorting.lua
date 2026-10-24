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

SortAfter("armor_weevole",             "armorwood",                 "ARMOUR")
SortAfter("armor_ant",                 "armor_weevole",             "ARMOUR")
SortAfter("antmaskhat",                "armor_ant",                 "ARMOUR")
SortAfter("armor_blubber",             "antmaskhat",                "ARMOUR")
SortAfter("armor_cactus",              "armor_bramble",             "ARMOUR")
SortAfter("armor_flowers",             "armorgrass",                "ARMOUR")
SortAfter("armor_vortex",              "armor_sanity",              "ARMOUR")
SortAfter("armor_seashell",            "armor_vortex",              "ARMOUR")
SortAfter("armor_limestone",           "armor_seashell",            "ARMOUR")
SortAfter("armor_metalplate",          "armor_limestone",           "ARMOUR")
SortAfter("metalplatehat",             "armor_metalplate",          "ARMOUR")
SortAfter("wagstaff_goggles_armorhat", "metalplatehat",             "ARMOUR")
SortAfter("armor_obsidian",            "armordragonfly",            "ARMOUR")
SortAfter("armor_tar",                 "armor_blubber",             "ARMOUR")
SortAfter("buckethat",                 "footballhat",               "ARMOUR")
SortAfter("jiaolianhat",               "buckethat",                 "ARMOUR")
SortAfter("oxhat",                     "jiaolianhat",               "ARMOUR")
SortAfter("extraheavyhat",             "armormarble",               "ARMOUR")
SortAfter("sanitydamagehat",           "extraheavyhat",             "ARMOUR")

SortAfter("disguisehat",               "spidereggsack",             "CHARACTER")
SortAfter("wagstaff_goggleshat",       "winona_teleport_pad_item",  "CHARACTER")
SortAfter("inspectacleshat",           "wagstaff_goggleshat",       "CHARACTER")
SortAfter("wagstaff_goggles_armorhat", "inspectacleshat",           "CHARACTER")
SortAfter("wagstaff_goggles_heathat",  "wagstaff_goggles_armorhat", "CHARACTER")
SortAfter("wagstaff_goggles_shoothat", "wagstaff_goggles_heathat",  "CHARACTER")

SortAfter("wagstaff_goggleshat",       "goggleshat",                "CLOTHING")
SortAfter("willowoldhat",              "strawhat",                  "CLOTHING")
SortAfter("disguisehat",               "featherfan",                "CLOTHING")
SortAfter("aerodynamichat",            "bushhat",                   "CLOTHING")
SortAfter("shark_teethhat",            "aerodynamichat",            "CLOTHING")
SortAfter("captainhat",                "shark_teethhat",            "CLOTHING")
SortAfter("piratehat",                 "captainhat",                "CLOTHING")
SortAfter("luckytreasurehat",          "piratehat",                 "CLOTHING")
SortAfter("brainjellyhat",             "luckytreasurehat",          "CLOTHING")
SortAfter("bandithat",                 "brainjellyhat",             "CLOTHING")
SortAfter("pithhat",                   "bandithat",                 "CLOTHING")
SortAfter("thunderhat",                "pithhat",                   "CLOTHING")
SortAfter("propellerhat",              "thunderhat",                "CLOTHING")
SortAfter("armor_snakeskin",           "raincoat",                  "CLOTHING")
SortAfter("snakeskinhat",              "armor_snakeskin",           "CLOTHING")
SortAfter("armor_windbreaker",         "snakeskinhat",              "CLOTHING")
SortAfter("double_umbrellahat",        "eyebrellahat",              "CLOTHING")
SortAfter("gashat",                    "beefalohat",                "CLOTHING")
SortAfter("gasmaskhat",                "gashat",                    "CLOTHING")
SortAfter("peagawkfeatherhat",         "featherhat",                "CLOTHING")
SortAfter("pumpkinheadhat",            "pumpkinhat",                "CLOTHING")
SortAfter("foodbaskethat",             "pumpkinheadhat",            "CLOTHING")
SortAfter("foodbonushat",              "flowerhat",                 "CLOTHING")
SortAfter("healingbonushat",           "foodbonushat",              "CLOTHING")

SortAfter("thatchsack",                "giftwrap",                  "CONTAINERS")
SortAfter("armor_vortex",              "candybag",                  "CONTAINERS")

SortAfter("carnival_hosthat",          "carnival_vest_c",           "CRAFTING_STATION")
SortBefore("foodbonushat",             "moon_mushroomhat",          "CRAFTING_STATION")
SortAfter("healingbonushat",           "foodbonushat",              "CRAFTING_STATION")
SortAfter("sanitydamagehat",           "healingbonushat",           "CRAFTING_STATION")
SortAfter("lifestealhat",              "eyeturret_item",            "CRAFTING_STATION")
SortAfter("minotaurcrownhat",          "lifestealhat",              "CRAFTING_STATION")

SortAfter("candlehat",                 "pumpkin_lantern",           "LIGHT")
SortAfter("bathat",                    "minerhat",                  "LIGHT")
SortAfter("wagstaff_goggles_heathat",  "molehat",                   "LIGHT")
SortAfter("wagstaff_goggles_shoothat", "wagstaff_goggles_heathat",  "LIGHT")
SortAfter("volcanohat",                "molehat",                   "LIGHT")
SortAfter("volcanocoldhat",            "volcanohat",                "LIGHT")
SortAfter("lanternbottle",             "lantern",                   "LIGHT")

SortAfter("armor_vortex",              "nightlight",                "MAGIC")

SortAfter("antmaskhat",                "tophat",                    "RAIN")
SortAfter("bandithat",                 "antmaskhat",                "RAIN")
SortAfter("gashat",                    "bandithat",                 "RAIN")
SortAfter("gasmaskhat",                "gashat",                    "RAIN")
SortAfter("pithhat",                   "gasmaskhat",                "RAIN")
SortAfter("propellerhat",              "pithhat",                   "RAIN")
SortAfter("candlehat",                 "propellerhat",              "RAIN")
SortAfter("armor_lifejacket",          "umbrella",                  "RAIN")
SortAfter("armor_weevole",             "raincoat",                  "RAIN")
SortAfter("armor_snakeskin",           "armor_weevole",             "RAIN")
SortAfter("snakeskinhat",              "armor_snakeskin",           "RAIN")
SortAfter("armor_windbreaker",         "snakeskinhat",              "RAIN")
SortAfter("armor_seashell",            "armor_windbreaker",         "RAIN")
SortAfter("armor_limestone",           "armor_seashell",            "RAIN")
SortAfter("armor_blubber",             "armor_limestone",           "RAIN")
SortAfter("armor_tar",                 "armor_blubber",             "RAIN")
SortAfter("double_umbrellahat",        "eyebrellahat",              "RAIN")
SortAfter("oxhat",                     "rainhat",                   "RAIN")
SortAfter("thunderhat",                "oxhat",                     "RAIN")

SortAfter("armor_weevole",             "lifeinjector",              "RESTORATION")
SortAfter("healingbonushat",           "armor_weevole",             "RESTORATION")

SortAfter("armor_lifejacket",          "flotationcushion",          "SEAFARING")
SortAfter("captainhat",                "armor_lifejacket",          "SEAFARING")
SortAfter("piratehat",                 "captainhat",                "SEAFARING")
SortAfter("luckytreasurehat",          "piratehat",                 "SEAFARING")

SortAfter("armor_blubber",             "hawaiianshirt",             "SUMMER")
SortAfter("armor_lifejacket",          "reflectivevest",            "SUMMER")
SortAfter("double_umbrellahat",        "eyebrellahat",              "SUMMER")
SortAfter("propellerhat",              "double_umbrellahat",        "SUMMER")
SortAfter("volcanocoldhat",            "propellerhat",              "SUMMER")

SortAfter("wagstaff_goggles_shoothat", "gunpowder",                 "WEAPONS")

SortAfter("armor_obsidian",            "beargervest",               "WINTER")
SortAfter("armor_snakeskin",           "raincoat",                  "WINTER")
SortAfter("volcanohat",                "beefalohat",                "WINTER")