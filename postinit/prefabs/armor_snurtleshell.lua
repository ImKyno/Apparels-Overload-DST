local _G        = GLOBAL
local THRESHOLD = TUNING.APO_ARMORS.SNURTLE.THRESHOLD
local INTERVAL  = TUNING.APO_ARMORS.SNURTLE.INTERVAL
local AMOUNT    = TUNING.APO_ARMORS.SNURTLE.AMOUNT

local function OnStopSnurtleRegen(inst, owner)
    if inst._armorsnurtle_regen ~= nil then
        inst._armorsnurtle_regen:Cancel()
        inst._armorsnurtle_regen = nil
    end

    if owner ~= nil then
        owner:PushEvent("healthregenactive", { active = false })
    end
end

local function OnUpdateSnurtleSetBonus(inst, owner)
    if owner ~= nil and owner.components.health ~= nil and owner.components.health:IsDead() then
        OnStopSnurtleRegen(inst, owner)

        return
    end

    if owner.sg ~= nil and owner.sg:HasStateTag("shell") and owner.components.health:GetPercent() < THRESHOLD then
        if inst._armorsnurtle_regen == nil then
            inst._armorsnurtle_regen = inst:DoPeriodicTask(INTERVAL, function()
                if owner.sg ~= nil and owner.components.health ~= nil then
                    if not owner.sg:HasStateTag("shell") or owner.components.health:GetPercent() >= THRESHOLD then
                        OnStopSnurtleRegen(inst, owner)

                        return
                    end

                    owner.components.health:DoDelta(AMOUNT, nil, "armorsnurtleshell")
                end
            end)

            owner:PushEvent("healthregenactive", { active = true })
        end
    else
        OnStopSnurtleRegen(inst, owner)
    end
end

local function OnHealthDelta(owner, data)
    local armor = owner._armorsnurtle_setbonus

    if armor ~= nil then
        OnUpdateSnurtleSetBonus(armor, owner)
    end
end

local function OnEnabledSetBonus(inst)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

    if owner ~= nil then
        inst._armorsnurtle_setbonus_owner = owner
        owner._armorsnurtle_setbonus = inst

        owner:ListenForEvent("healthdelta", OnHealthDelta)
        owner:ListenForEvent("attacked", OnHealthDelta)
        owner:ListenForEvent("newstate", OnHealthDelta)

        OnUpdateSnurtleSetBonus(inst, owner)
    end
end

local function OnDisabledSetBonus(inst)
    local owner = inst._armorsnurtle_setbonus_owner

    if owner ~= nil then
        owner:RemoveEventCallback("healthdelta", OnHealthDelta)
        owner:RemoveEventCallback("attacked", OnHealthDelta)
        owner:RemoveEventCallback("newstate", OnHealthDelta)

        OnStopSnurtleRegen(inst, owner)

        owner._armorsnurtle_setbonus = nil
    end

    inst._armorsnurtle_setbonus_owner = nil
end

local function ArmorSnurtleShellPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("damagetyperesist")
    inst.components.damagetyperesist:AddResist("explosive", inst, TUNING.APO_ARMORS.SNURTLE.DAMAGETYPE_RESIST)

    if inst.components.setbonus == nil then
        inst:AddComponent("setbonus")
        inst.components.setbonus:SetSetName(_G.EQUIPMENTSETNAMES.SNURTLE)
        inst.components.setbonus:SetOnEnabledFn(OnEnabledSetBonus)
        inst.components.setbonus:SetOnDisabledFn(OnDisabledSetBonus)
    end
end

if TUNING.APO_TWEAK_ARMORSNURTLE then
    AddPrefabPostInit("armorsnurtleshell", ArmorSnurtleShellPostInit)
end