require("debugcommands")

local BuriedTreasureChestLoot = require("apo_buriedtreasurechestloot")

local function SpawnStandAndEquip(stand_prefab, item)
    if item == nil then
        return
    end

    local ix, iy, iz = item.Transform:GetWorldPosition()
    local stand = SpawnPrefab(stand_prefab or "sewing_mannequin")

    if stand ~= nil then
        stand.Transform:SetPosition(ix, iy, iz)
        stand.components.inventory:Equip(item)
    end
end

-- Spawns a random buried treasure near the player.
function c_generateburiedtreasure(player)
    local player = ConsoleCommandPlayer()

    if player ~= nil then
        if player.components.buriedtreasurefinder ~= nil then
            player.components.buriedtreasurefinder:GenerateTreasure()
        end
    end
end

-- Spawns a random buried treasure at the point.
function c_generateburiedtreasureatpoint(player)
    local player = ConsoleCommandPlayer()

    if player ~= nil then
        if player.components.buriedtreasurefinder ~= nil then
            player.components.buriedtreasurefinder:GenerateTreasureAtPoint()
        end
    end
end

-- Spawns a specific buried treasure.
function c_generatespecificburiedtreasurechest(name, player)
    local player = ConsoleCommandPlayer()

    if player ~= nil then
        local pos = ConsoleWorldPosition()
        local x, y, z = pos:Get()

        return BuriedTreasureChestLoot.SpawnChest(name, x, y, z)
    end
end

-- Spawns all buried treasures.
function c_generateallburiedtreasurechests(player)
    local player = ConsoleCommandPlayer()

    if player ~= nil then
        local names = BuriedTreasureChestLoot.GetChestNames()

        table.sort(names)

        local pos = ConsoleWorldPosition()
        local x, y, z = pos:Get()

        local columns = 6
        local spacing = 4

        for i, name in ipairs(names) do
            local column = (i - 1) % columns
            local row = math.floor((i - 1) / columns)

            BuriedTreasureChestLoot.SpawnChest(name, x + column * spacing, y, z + row * spacing)
        end
    end
end

-- Spawns all armors on Mannequin or Punching Bag.
function c_displayallarmorsonstand(stand_prefab)
    local ALL_ARMORS =
    {
        "armor_ant",
        "armor_blubber",
        "armor_cactus",
        "armor_flowers",
        "armor_lifejacket",
        "armor_limestone",
        "armor_metalplate",
        "armor_obsidian",
        "armor_seashell",
        "armor_snakeskin",
        "armor_tar",
        "armor_vortex",
        "armor_weevole",
        "armor_windbreaker",
    }

    return d_spawnlist(ALL_ARMORS, 3.5, function(item)
        SpawnStandAndEquip(stand_prefab, item)
    end)
end

-- Spawns all hats on Mannequin or Punching Bag.
function c_displayallhatssonstand(stand_prefab)
    local ALL_HATS =
    {
        "aerodynamichat",
        "bandithat",
        "bathat",
        "brainjellyhat",
        "buckethat",
        "candlehat",
        "carnival_hosthat",
        "disguisehat",
        "double_umbrellahat",
        "extraheavyhat",
        "foodbaskethat",
        "foodbonushat",
        "gashat",
        "gasmaskhat",
        "healingbonushat",
        "jiaolianhat",
        "lifestealhat",
        "luckytreasurehat",
        "metalplatehat",
        "minotaurcrownhat",
        "oxhat",
        "peagawkfeatherhat",
        "pigcrownhat",
        "piratehat",
        "pithhat",
        "propellerhat",
        "pumpkinheadhat",
        "sanitydamagehat",
        "shark_teethhat",
        "snakeskinhat",
        "thunderhat",
        "volcanocoldhat",
        "volcanohat",
        "wagstaff_goggleshat",
        "wagstaff_goggles_armorhat",
        "wagstaff_goggles_heathat",
        "wagstaff_goggles_shoothat",
        "willowoldhat",
    }

    return d_spawnlist(ALL_HATS, 3.5, function(item)
        SpawnStandAndEquip(stand_prefab, item)
    end)
end