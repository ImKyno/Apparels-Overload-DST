local _G = GLOBAL

local function PigSkinPostInit(inst)
    inst:AddTag("dryable")

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.dryable == nil then
        inst:AddComponent("dryable")
        inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
        inst.components.dryable:SetProduct("pigskin_dried")
        inst.components.dryable:SetBuildFile("meat_rack_food_pigskin")
        inst.components.dryable:SetDriedBuildFile("meat_rack_food_pigskin")
    end
end

AddPrefabPostInit("pigskin", PigSkinPostInit)