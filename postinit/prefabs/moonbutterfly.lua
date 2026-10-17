local _G = GLOBAL

local MOONBUTTERFLIES =
{
    "moonbutterfly",
    "moonbutterflywings",
}

local function MoonButterflyPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.fuel == nil then
        inst:AddComponent("fuel")
    end

    if inst.components.fuel then
        if inst.components.fuel.secondaryfueltype == nil then
            inst.components.fuel.secondaryfueltype = _G.FUELTYPE.MOONBUTTERFLY
        end

        inst.components.fuel.fuelvalue = TUNING.HUGE_FUEL * 3.33
    end
end

for k, v in pairs(MOONBUTTERFLIES) do
    AddPrefabPostInit(v, MoonButterflyPostInit)
end