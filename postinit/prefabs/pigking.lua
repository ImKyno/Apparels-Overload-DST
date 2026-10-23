local _G = GLOBAL

local function PigKingPostInit(inst)
    inst:AddTag("hotblood")
end

AddPrefabPostInit("pigking", PigKingPostInit)