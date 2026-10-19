local _G = GLOBAL

local function OnRepaired(inst, doer, repair_item)
    if doer ~= nil then
        doer:PushEvent("repair")
    end
end

local function HawaiianShirtPostInit(inst)
    inst:AddTag("absorbsoverheat")

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.overheat_damage = TUNING.APO_ARMORS.HAWAIIANSHIRT.OVERHEAT_DAMAGE
    inst.perish_damage = TUNING.APO_ARMORS.HAWAIIANSHIRT.PERISH_DAMAGE

    if inst.components.repairable == nil then
        inst:AddComponent("repairable")
        inst.components.repairable.repairmaterial = _G.MATERIALS.CACTUS_FLOWER
        inst.components.repairable.onrepaired = OnRepaired
        inst.components.repairable.noannounce = true
    end
end

if TUNING.APO_TWEAK_HAWAIIANSHIRT then
    AddPrefabPostInit("hawaiianshirt", HawaiianShirtPostInit)
end