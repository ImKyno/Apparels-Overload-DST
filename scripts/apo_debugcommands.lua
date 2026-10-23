local BuriedTreasureChestLoot = require("apo_buriedtreasurechestloot")

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