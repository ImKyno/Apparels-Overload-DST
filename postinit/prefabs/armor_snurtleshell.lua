local _G = GLOBAL

local function ArmorSnurtleShellPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("damagetyperesist")
    inst.components.damagetyperesist:AddResist("explosive", inst, TUNING.APO_ARMORS.SNURTLE.DAMAGETYPE_RESIST)
end

if TUNING.APO_TWEAK_ARMORSNURTLE then
    AddPrefabPostInit("armorsnurtleshell", ArmorSnurtleShellPostInit)
end