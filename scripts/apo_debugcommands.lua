if not TUNING.APO_DEBUG_MODE then
    return
end

local BuriedTreasureChestLoot = require("apo_buriedtreasurechestloot")

function c_spawnburiedtreasurechest(name, player)
    local player = ConsoleCommandPlayer()

    if player ~= nil then
        local pos = ConsoleWorldPosition()
        local x, y, z = pos:Get()

        return BuriedTreasureChestLoot.SpawnChest(name, x, y, z)
    end
end

function c_spawnallburiedtreasurechests(player)
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