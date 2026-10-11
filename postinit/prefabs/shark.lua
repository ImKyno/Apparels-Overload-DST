local _G = GLOBAL

local function SharkPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:AddChanceLoot("shark_fin", 1.00)
    end
end

if not TUNING.APO_IS_HOF_ENABLED then
    AddPrefabPostInit("shark", SharkPostInit)
end