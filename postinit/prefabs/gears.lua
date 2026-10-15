local _G = GLOBAL

local function GearsPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.fuel == nil then
        inst:AddComponent("fuel")
    end

    if inst.components.fuel then
        if inst.components.fuel.secondaryfueltype == nil then
            inst.components.fuel.secondaryfueltype = _G.FUELTYPE.GEARS
        end

        inst.components.fuel.fuelvalue = TUNING.HUGE_FUEL
    end
end

AddPrefabPostInit("gears", GearsPostInit)