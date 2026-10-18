local _G = GLOBAL

local LEIFS =
{
    "leif",
    "leif_sparse",
}

local function LeifPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:AddChanceLoot("leif_stalk", 1.00)
    end
end

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    for k, v in pairs(LEIFS) do
        AddPrefabPostInit(v, LeifPostInit)
    end
end