local _G = GLOBAL

local function HiveHatPostInit(inst)
    inst:AddTag("beefriendly")
end

AddPrefabPostInit("hivehat", HiveHatPostInit)