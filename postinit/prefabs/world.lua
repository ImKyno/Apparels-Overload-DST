local _G = GLOBAL

local function WorldPostInit(inst)
    inst:AddComponent("globalcolormodifier")
end

AddPrefabPostInit("world", WorldPostInit)