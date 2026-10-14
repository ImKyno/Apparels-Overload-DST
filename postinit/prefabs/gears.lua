local _G = GLOBAL

local function GearsPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.fuel == nil then
        inst:AddComponent("fuel")
        inst.components.fuel.fueltype = _G.FUELTYPE.GEARS
        inst.components.fuel.fuelvalue = TUNING.HUGE_FUEL
    end
end

AddPrefabPostInit("gears", GearsPostInit)