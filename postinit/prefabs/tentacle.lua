local _G = GLOBAL

local TENTACLES =
{
    "bigshadowtentacle",
    "tentacle_pillar_arm",
}

local function TentaclesPostInit(inst)
    inst:AddTag("hidden_danger")
end

for k, v in pairs(TENTACLES) do
    AddPrefabPostInit(v, TentaclesPostInit)
end