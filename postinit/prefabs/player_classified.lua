local _G = GLOBAL

local function PlayerClassifiedPostInit(inst)
    inst.isbrainjellyhat = _G.net_bool(inst.GUID, "builder.brainjellyhat", "recipesdirty")
    inst.isbrainjellyhat:set(false)
end

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    AddPrefabPostInit("player_classified", PlayerClassifiedPostInit)
end