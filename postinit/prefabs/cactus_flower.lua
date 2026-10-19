local _G = GLOBAL

local function CactusFlowerPostInit(inst)
    inst:AddTag("freshen_cactus_flower")

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.repairer == nil then
        inst:AddComponent("repairer")
        inst.components.repairer.repairmaterial = _G.MATERIALS.CACTUS_FLOWER
        inst.components.repairer.perishrepairpercent = TUNING.APO_MISC.CACTUS_FLOWER.REPAIR_VALUE
    end
end

if TUNING.APO_TWEAK_HAWAIIANSHIRT then
    AddPrefabPostInit("cactus_flower", CactusFlowerPostInit)
end