local _G = GLOBAL

local function TownPortalTalismanPostInit(inst)
    inst:AddTag("finiteuses_townportaltalisman")

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.repairer == nil then
        inst:AddComponent("repairer")
        inst.components.repairer.repairmaterial = _G.MATERIALS.TOWNPORTALTALISMAN
        inst.components.repairer.finiteusesrepairvalue = TUNING.APO_MISC.TOWNPORTALTALISMAN.REPAIR_VALUE
    end
end

if TUNING.APO_TWEAK_ANTLIONHAT then
    AddPrefabPostInit("townportaltalisman", TownPortalTalismanPostInit)
end