-- Public API for creating or editing existing chests spawned by the Lucky Hat.
-- To use just add: local BuriedTreasureChestLoot = require("apo_buriedtreasurechestloot") at the top of your file!

local TRINKETS_BLACKLIST =
{
    "trinket_15",
    "trinket_16",
    "trinket_28",
    "trinket_29",
    "trinket_30",
    "trinket_31",
}

local TRINKETS_CHESS = {}

for _, trinket in ipairs(TRINKETS_BLACKLIST) do
    TRINKETS_CHESS[trinket] = true
end

local function GetRandomTrinket()
    local chessunlocks = TheWorld ~= nil and TheWorld.components ~= nil and TheWorld.components.chessunlocks or nil
    local hallowednights = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS)

    local available = {}

    for i = 1, NUM_TRINKETS do
        local trinket = "trinket_"..i
        local is_chess = TRINKETS_CHESS[trinket]

        local locked = is_chess and (chessunlocks == nil or chessunlocks:IsLocked(trinket))
        local seasonal = i >= HALLOWEDNIGHTS_TINKET_START and i <= HALLOWEDNIGHTS_TINKET_END

        -- Allow chesspieces trinkets if they are unlocked.
        -- Allow halloween trinkets during the event.
        if not locked and (not seasonal or hallowednights) then
            table.insert(available, trinket)
        end
    end

    return #available > 0 and available[math.random(#available)] or nil
end

local function FillChest(chest, loot)
    if chest == nil or loot == nil then
        return
    end

    for _, entry in ipairs(loot) do
        local item_prefab = type(entry.item) == "function" and entry.item() or entry.item

        if item_prefab ~= nil then
            local count = entry.count or 1

            for i = 1, count do
                local item = SpawnPrefab(item_prefab)

                if item ~= nil then
                    if item.components.stackable ~= nil then
                        item.components.stackable:SetStackSize(count - i + 1)

                        if chest.components.container ~= nil then
                            chest.components.container:GiveItem(item)
                        else
                            item:Remove()
                        end

                        break
                    elseif chest.components.container ~= nil then
                        chest.components.container:GiveItem(item)
                    else
                        item:Remove()
                    end
                end
            end
        end
    end
end

local CHEST_LOOTS = -- Do not modify this table directly.
{
    chest_ruins1 =
    {
        { item = "thulecite",  count = math.random(5, 10) },
        { item = "purplegem",  count = math.random(2, 5)  },
        { item = "armorruins"                             },
        { item = "ruinshat"                               },
        { item = "ruins_bat"                              },
    },

    chest_ruins2 =
    {
        { item = "thulecite",  count = math.random(2, 6) },
        { item = "redgem",     count = math.random(2, 5) },
        { item = "bluegem",    count = math.random(2, 5) },
        { item = "ruinshat"                              },
    },

    chest_ruins3 =
    {
        { item = "thulecite",  count = math.random(2, 6) },
        { item = "orangegem",  count = math.random(1, 3) },
        { item = "yellowgem",  count = math.random(1, 3) },
        { item = "greengem",   count = math.random(1, 3) },
        { item = "multitool_axe_pickaxe"                 },
    },

    chest_ruins4 =
    {
        { item = "thulecite",  count = math.random(2, 6) },
        { item = "orangegem",  count = math.random(1, 3) },
        { item = "orangestaff"                           },
        { item = "orangeamulet"                          },
    },

    chest_ruins5 =
    {
        { item = "thulecite",  count = math.random(2, 6) },
        { item = "yellowgem",  count = math.random(1, 3) },
        { item = "yellowtaff"                            },
        { item = "yellowamulet"                          },
    },

    chest_ruins6 =
    {
        { item = "thulecite",  count = math.random(2, 6) },
        { item = "greengem",   count = math.random(1, 3) },
        { item = "greentaff"                             },
        { item = "greenamulet"                           },
    },

    chest_gems1 =
    {
        { item = "goldnugget", count = 3                 },
        { item = "bluegem",    count = math.random(1, 3) },
        { item = "redgem",     count = math.random(1, 3) },
        { item = "purplegem",  count = math.random(1, 3) },
    },

    chest_gems2 =
    {
        { item = "goldnugget", count = 3                 },
        { item = "orangegem",  count = math.random(1, 3) },
        { item = "yellowgem",  count = math.random(1, 3) },
        { item = "greengem",   count = math.random(1, 3) },
    },

    chest_gems3 =
    {
        { item = "goldnugget", count = 6                 },
        { item = "bluegem",    count = math.random(1, 3) },
        { item = "redgem",     count = math.random(1, 3) },
        { item = "purplegem",  count = math.random(1, 3) },
        { item = "orangegem",  count = math.random(1, 3) },
        { item = "yellowgem",  count = math.random(1, 3) },
        { item = "greengem",   count = math.random(1, 3) },
    },

    chest_opalprecious =
    {
        { item = "goldnugget", count = 5 },
        { item = "opalpreciousgem"       },
    },

    chest_red =
    {
        { item = "goldnugget", count = 2 },
        { item = "firestaff"             },
        { item = "amulet"                },
    },

    chest_blue =
    {
        { item = "goldnugget", count = 2 },
        { item = "icestaff"              },
        { item = "blueamulet"            },
    },

    chest_purple =
    {
        { item = "goldnugget", count = 2 },
        { item = "telestaff"             },
        { item = "purpleamulet"          },
    },

    chest_tools =
    {
        { item = "goldnugget", count = 2 },
        { item = "goldenaxe"             },
        { item = "goldenpickaxe"         },
        { item = "goldenshovel"          },
        { item = "golden_farm_hoe"       },
    },

    chest_explorer =
    {
        { item = "goldnugget", count = 3 },
        { item = "boneshard",  count = 2 },
        { item = "compass"               },
        { item = "bedroll"               },
    },

    chest_miner =
    {
        { item = "goldnugget", count = 5 },
        { item = "minerhat"              },
        { item = "pickaxe"               },
    },

    chest_spelunker =
    {
        { item = "goldnugget", count = 2 },
        { item = "lightbulb",  count = 5 },
        { item = "spear"                 },
        { item = "lantern"               },
    },

    chest_spelunker2 =
    {
        { item = "goldnugget", count = 4 },
        { item = "lightbulb",  count = 5 },
        { item = "lantern"               },
        { item = "bedroll_furry"         },
    },

    chest_darkness =
    {
        { item = "goldnugget",    count = 2 },
        { item = "nightmarefuel", count = 5 },
        { item = "nightsword"               },
        { item = "armorsanity"              },
        { item = "amulet"                   },
    },

    chest_ranger =
    {
        { item = "goldnugget",    count = 2 },
        { item = "pigskin_dried", count = 3 },
        { item = "strawhat"                 },
        { item = "boomerang"                },
    },

    chest_explosives =
    {
        { item = "goldnugget", count = 3                 },
        { item = "armor_seashell"                        },
        { item = "gunpowder",  count = math.random(3, 6) },
        { item = "rope",       count = 2                 },
    },

    chest_dapper =
    {
        { item = "goldnugget", count = 5 },
        { item = "rope",       count = 2 },
        { item = "cane"                  },
        { item = "tophat"                },
    },

    chest_combat =
    {
        { item = "goldnugget", count = math.random(1, 3) },
        { item = "spear"                                 },
        { item = "armorwood"                             },
    },

    chest_farming1 =
    {
        { item = "fertilizer", count = 1                  },
        { item = "poop",       count = math.random(5, 10) },
        { item = "seeds",      count = math.random(6, 12) },
    },

    chest_farming2 =
    {
        { item = "goldnugget", count = 3                 },
        { item = "seeds",      count = math.random(4, 8) },
        { item = "farm_hoe"                              },
        { item = "wateringcan"                           },
    },

    chest_skin =
    {
        { item = "goldnugget", count = 5 },
        { item = "livinglog",  count = 3 },
        { item = "reskin_tool"           },
    },

    chest_rain =
    {
        { item = "goldnugget", count = 5 },
        { item = "rainhat"               },
        { item = "umbrella"              },
    },

    chest_mandrake =
    {
        { item = "goldnugget",    count = 4                 },
        { item = "nightmarefuel", count = 5                 },
        { item = "mandrake",      count = math.random(1, 3) },
    },

    chest_lunar1 =
    {
        { item = "goldnugget",     count = 4 },
        { item = "moonrocknugget", count = 5 },
        { item = "moonglass",      count = 5 },
    },

    chest_lunar2 =
    {
        { item = "goldnugget",     count = 5 },
        { item = "moonglassaxe"              },
        { item = "glasscutter"               },
    },

    chest_electrical =
    {
        { item = "goldnugget", count = 4 },
        { item = "gears",      count = 4 },
        { item = "transistor", count = 2 },
    },

    chest_seafaring =
    {
        { item = "goldnugget", count = 3 },
        { item = "boatpatch",  count = 5 },
        { item = "boat_item"             },
        { item = "steeringwheel_item"    },
        { item = "anchor_item"           },
        { item = "mast_item"             },
        { item = "oar"                   },
    },

    chest_winter =
    {
        { item = "goldnugget", count = 4 },
        { item = "winterhat",            },
        { item = "heatrock"              },
    },

    chest_summer =
    {
        { item = "goldnugget", count = 4 },
        { item = "icehat",               },
        { item = "heatrock"              },
    },

    chest_fisherman =
    {
        { item = "goldnugget",              count = 3 },
        { item = "oceanfishingbobber_ball", count = 3 },
        { item = "fishingrod"                         },
        { item = "oceanfishingrod"                    },
    },

    chest_showdown =
    {
        { item = "goldnugget", count = 3                 },
        { item = "torch"                                 },
        { item = "miniflare",  count = math.random(1, 3) },
        { item = "megaflare",  count = math.random(1, 3) },
    },

    chest_cooking =
    {
        { item = "goldnugget", count = 3 },
        { item = "bonestew",             },
        { item = "ratatouille"           },
        { item = "taffy"                 },
        { item = "cookbook"              },
    },

    chest_fur =
    {
        { item = "goldnugget",     count = 3                 },
        { item = "tentaclespots",  count = math.random(1, 5) },
        { item = "coontail",       count = math.random(1, 5) },
        { item = "manrabbit_tail", count = math.random(1, 5) },
        { item = "pigskin",        count = math.random(1, 5) },
        { item = "beefalowool",    count = math.random(1, 5) },
        { item = "silk",           count = math.random(1, 5) },
        { item = "steelwool",      count = math.random(1, 5) },
        { item = "slurper_pelt",   count = math.random(1, 5) },
    },

    chest_nightwalk =
    {
        { item = "goldnugget", count = 3 },
        { item = "nightstick"            },
        { item = "molehat"               },
        { item = "transistor", count = 2 },
    },

    chest_captain =
    {
        { item = "goldnugget", count = 3 },
        { item = "captainhat"            },
        { item = "armor_lifejacket"      },
    },

    chest_pirate =
    {
        { item = "goldnugget",    count = 5                 },
        { item = "messagebottle", count = math.random(2, 3) },
        { item = "piratehat"                                },
        { item = "piratepack"                               },
    },

    chest_marble =
    {
        { item = "goldnugget", count = 2                  },
        { item = "marble",     count = math.random(6, 12) },
        { item = "armormarble"                            },
        { item = "extraheavyhat"                          },
    },

    chest_musician =
    {
        { item = "goldnugget",    count = 5                  },
        { item = "nightmarefuel", count = math.random(5, 10) },
        { item = "panflute"                                  },
        { item = "onemanband"                                },
    },

    chest_bees =
    {
        { item = "goldnugget", count = 3                 },
        { item = "honeycomb",  count = math.random(2, 3) },
        { item = "stinger",    count = math.random(3, 6) },
        { item = "beehat",                               },
    },

    chest_feathers =
    {
        { item = "goldnugget",           count = 4                 },
        { item = "feather_crow",         count = math.random(2, 5) },
        { item = "feather_robin",        count = math.random(2, 5) },
        { item = "feather_robin_winter", count = math.random(2, 5) },
        { item = "feather_canary",       count = math.random(2, 5) },
    },

    chest_minerals =
    {
        { item = "rocks",    count = math.random(10, 20) },
        { item = "charcoal", count = math.random(10, 20) },
        { item = "nitre",    count = math.random(5, 10)  },
        { item = "saltrock", count = math.random(5, 10)  },
    },

    chest_trinkets =
    {
        { item = GetRandomTrinket, count = math.random(1, 3) },
        { item = GetRandomTrinket, count = math.random(1, 3) },
        { item = GetRandomTrinket, count = math.random(1, 3) },
        { item = GetRandomTrinket, count = math.random(1, 3) },
        { item = GetRandomTrinket, count = math.random(1, 3) },
    },
}

local BURIED_TREASURECHEST_LOOTS = {}

-- Overrides the loot of one existing chest.
local function SetChestLoot(name, loot)
    if CHEST_LOOTS[name] == nil or type(loot) ~= "table" then
        return false
    end

    CHEST_LOOTS[name] = loot

    return true
end

-- Adds a new chest to the loottable or overrides the loot of an existing one.
local function AddChest(name, loot)
    if type(name) ~= "string" or type(loot) ~= "table" then
        return false
    end

    CHEST_LOOTS[name] = loot

    return true
end

-- Removes a chest from the loottable.
local function RemoveChest(name)
    if CHEST_LOOTS[name] == nil then
        return false
    end

    CHEST_LOOTS[name] = nil

    return true
end

-- Add items to one of the existing chests.
local function AddItemToChest(name, item, count)
    local loot = CHEST_LOOTS[name]

    if loot == nil or type(item) ~= "string" then
        return false
    end

    local entry = { item = item }

    if count ~= nil then
        entry.count = count
    end

    table.insert(loot, entry)

    return true
end

-- Removes the first entry of an item from one chest.
local function RemoveItemFromChest(name, item)
    local loot = CHEST_LOOTS[name]

    if loot == nil then
        return false
    end

    for i, entry in ipairs(loot) do
        if entry.item == item then
            table.remove(loot, i)

            return true
        end
    end

    return false
end

-- Returns the loot of a specific chest.
local function GetChestLoot(name)
    return CHEST_LOOTS[name]
end

-- Returns the name of all chests.
local function GetChestNames()
    local names = {}

    for name in pairs(CHEST_LOOTS) do
        table.insert(names, name)
    end

    return names
end

-- Returns the loot of a random chest, use the parameter chest to generate loot.
local function GetRandomChestLoot(chest)
    local names = GetChestNames()

    if #names == 0 then
        return nil
    end

    local name = names[math.random(#names)]
    local loot = CHEST_LOOTS[name]

    if chest ~= nil then
        FillChest(chest, loot)
    end

    return loot, name
end

-- Spawns a chest with defined loot.
local function SpawnChest(name, x, y, z)
    local loot = CHEST_LOOTS[name]

    if loot == nil then
        return nil
    end

    local chest = SpawnPrefab("treasurechest")

    if chest == nil then
        return nil
    end

    chest.Transform:SetPosition(x, y, z)

    FillChest(chest, loot)

    return chest
end

return
{
    TRINKETS_BLACKLIST         = TRINKETS_BLACKLIST,
    CHEST_LOOTS                = CHEST_LOOTS,
    BURIED_TREASURECHEST_LOOTS = BURIED_TREASURECHEST_LOOTS,

    SetChestLoot               = SetChestLoot,
    AddChest                   = AddChest,
    RemoveChest                = RemoveChest,
    AddItemToChest             = AddItemToChest,
    RemoveItemFromChest        = RemoveItemFromChest,
    GetChestLoot               = GetChestLoot,
    GetChestNames              = GetChestNames,
    GetRandomChestLoot         = GetRandomChestLoot,
    SpawnChest                 = SpawnChest,
}