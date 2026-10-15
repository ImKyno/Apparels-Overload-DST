local _G = GLOBAL

local HATS_BEE =
{
    "beehat",
    "hivehat",
}

local function HatsBeePostInit(inst)
    inst:AddTag("beefriend")
end

if TUNING.APO_VANILLA_CHANGES then
    for k, v in pairs(HATS_BEE) do
        AddPrefabPostInit(v, HatsBeePostInit)
    end
end