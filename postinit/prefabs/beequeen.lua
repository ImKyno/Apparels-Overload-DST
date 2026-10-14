local _G = GLOBAL

local function BeeQueenPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:AddChanceLoot("pigcrownhat", 0.30)
    end
end

AddPrefabPostInit("beequeen", BeeQueenPostInit)