local _G        = GLOBAL
local THRESHOLD = TUNING.APO_ARMORS.MARBLE.THRESHOLD
local DURATION  = TUNING.APO_ARMORS.MARBLE.DURATION
local INTERVAL  = TUNING.APO_ARMORS.MARBLE.INTERVAL

-- Marble Suit Set Bonus:
-- Below 50% Health, incoming damage becomes overtime damage instead.
local function OnUpdateMarbleSetBonus(inst, owner)
    if owner ~= nil and owner.components.health ~= nil and not owner.components.health:IsDead() then
        owner.components.health:SetDamageOvertimeSource("marble_setbonus", 
        owner.components.health:GetPercent() <= THRESHOLD, DURATION, INTERVAL)
    end
end

local function OnHealthDelta(owner, data)
    local armor = owner._armormarble_setbonus

    if armor ~= nil then
        OnUpdateMarbleSetBonus(armor, owner)
    end
end

local function OnEnabledSetBonus(inst)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

    if owner ~= nil then
        inst._armormarble_setbonus_owner = owner
        owner._armormarble_setbonus = inst

        owner:ListenForEvent("healthdelta", OnHealthDelta)

        OnUpdateMarbleSetBonus(inst, owner)
    end
end

local function OnDisabledSetBonus(inst)
    local owner = inst._armormarble_setbonus_owner

    if owner ~= nil then
        owner:RemoveEventCallback("healthdelta", OnHealthDelta)

        if owner.components.health ~= nil then
            owner.components.health:SetDamageOvertimeSource("marble_setbonus", false)
        end

        owner._armormarble_setbonus = nil
    end

    inst._armormarble_setbonus_owner = nil
end

local function ArmorMarblePostInit(inst)
    if not _G.TheWorld.ismastersim then
        return
    end

    if inst.components.setbonus == nil then
        inst:AddComponent("setbonus")
        inst.components.setbonus:SetSetName(_G.EQUIPMENTSETNAMES.MARBLE)
        inst.components.setbonus:SetOnEnabledFn(OnEnabledSetBonus)
        inst.components.setbonus:SetOnDisabledFn(OnDisabledSetBonus)
    end
end

AddPrefabPostInit("armormarble", ArmorMarblePostInit)