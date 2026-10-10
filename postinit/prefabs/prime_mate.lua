local _G = GLOBAL

local function PrimeMatePostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:AddChanceLoot("piratepack", 0.10)
    end
end

AddPrefabPostInit("prime_mate", PrimeMatePostInit)