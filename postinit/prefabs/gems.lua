local _G = GLOBAL

local GEMS =
{
    "bluegem",
    "redgem",
}

local function GemsPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.fuel == nil then
        inst:AddComponent("fuel")
    end

    if inst.components.fuel then
        if inst.components.fuel.secondaryfueltype == nil then
            inst.components.fuel.secondaryfueltype = _G.FUELTYPE[string.upper(inst.prefab)]
        end

        inst.components.fuel.fuelvalue = TUNING.HUGE_FUEL
    end
end

for k, v in pairs(GEMS) do
    AddPrefabPostInit(v, GemsPostInit)
end