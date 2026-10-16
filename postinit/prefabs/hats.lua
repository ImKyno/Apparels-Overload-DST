local _G = GLOBAL

local HATS_BEE =
{
    "beehat",
    "hivehat",
}

local function HatsBeePostInit(inst)
    inst:AddTag("beefriend")
end

local function HatFootballPostInit(inst)
    inst.SCANNABLE_RECIPENAME = "wagstaff_goggles_armorhat"
end

local function HatGogglesPostInit(inst)
    inst.SCANNABLE_RECIPENAME = "wagstaff_goggleshat"
end

local function HatMolePostInit(inst)
    inst.SCANNABLE_RECIPENAME = "wagstaff_goggles_heathat"
end

if TUNING.APO_TWEAK_BEEHAT then
    for k, v in pairs(HATS_BEE) do
        AddPrefabPostInit(v, HatsBeePostInit)
    end
end

AddPrefabPostInit("footballhat", HatFootballPostInit)
AddPrefabPostInit("goggleshat",  HatGogglesPostInit)
AddPrefabPostInit("molehat",     HatMolePostInit)