local _G = GLOBAL

local function LordFruitFlyPostInit()
    if _G.LootTables and _G.LootTables.lordfruitfly then
        table.insert(_G.LootTables.lordfruitfly, { "foodbaskethat_blueprint", 0.50 })
    end
end

AddSimPostInit(LordFruitFlyPostInit)