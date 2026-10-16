local _G = GLOBAL

local function CrabKingPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:AddChanceLoot("luckytreasurehat_blueprint", 1.00)
    end
end

AddPrefabPostInit("crabking", CrabKingPostInit)