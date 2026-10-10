local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/apo_upvaluehacker")

local function DaywalkerPostInit(inst)
    local BONUS_PILLAR_LOOT = UpvalueHacker.GetUpvalue(_G.Prefabs.daywalker.fn, "LootSetupFn", "BONUS_PILLAR_LOOT")

    if BONUS_PILLAR_LOOT ~= nil then
        table.insert(BONUS_PILLAR_LOOT, "armor_vortex_blueprint")
    end
end

AddPrefabPostInit("daywalker", DaywalkerPostInit)