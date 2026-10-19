local _G       = GLOBAL
local COOLDOWN = TUNING.APO_ARMORS.THULECITE.COOLDOWN
local MODIFIER = TUNING.APO_ARMORS.THULECITE.MODIFIER

local function OnRechargeChange(inst)
    if inst.components.multithruster ~= nil and inst.components.rechargeable ~= nil then
        inst.components.multithruster.ready = inst.components.rechargeable:IsCharged()

        if not inst.components.multithruster.ready then
            inst:RemoveTag("multithruster")
        end
    end
end

local function OnUpdateSpecialAttack(inst, enable)
    if enable then
        if inst.components.rechargeable ~= nil then
            inst.components.rechargeable:SetChargeTime(COOLDOWN)
            inst.components.rechargeable:Discharge(COOLDOWN)
        end

        inst:RemoveEventCallback("rechargechange", OnRechargeChange)
        inst:ListenForEvent("rechargechange", OnRechargeChange)

        if inst.components.multithruster ~= nil then
            inst.components.multithruster:SetEnabled(true)
        end
    else
        inst:RemoveEventCallback("rechargechange", OnRechargeChange)

        if inst.components.rechargeable ~= nil then
            inst.components.rechargeable:Discharge(0)
        end

        if inst.components.multithruster ~= nil then
            inst.components.multithruster:SetEnabled(false)
        end
    end
end

local function OnUpdateSetBonus(inst)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

    local isequipped = inst.components.equippable ~= nil and inst.components.equippable:IsEquipped()
    local has_setbonus = isequipped and owner ~= nil and owner._armorruins_setbonus ~= nil

    if has_setbonus then
        if not inst._armorruins_setbonus_active then
            inst._armorruins_setbonus_active = true
            inst.ruins_bat_specialattack = true

            if inst.components.weapon ~= nil then
                inst._armorruins_setbonus_weapon_damage = inst.components.weapon.damage

                inst.components.weapon:SetDamage(inst._armorruins_setbonus_weapon_damage * MODIFIER)
            end

            OnUpdateSpecialAttack(inst, true)
        end
    elseif inst._armorruins_setbonus_active then
        inst._armorruins_setbonus_active = nil
        inst.ruins_bat_specialattack = nil

        if inst.components.weapon ~= nil and inst._armorruins_setbonus_weapon_damage ~= nil then
            inst.components.weapon:SetDamage(inst._armorruins_setbonus_weapon_damage)
        end

        inst._armorruins_setbonus_weapon_damage = nil

        OnUpdateSpecialAttack(inst, false)
    end
end

local function OnEquip(inst)
    inst:OnUpdateSetBonus()
end

local function OnUnequip(inst)
    inst:OnUpdateSetBonus()
end

local function RuinsBatPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.OnUpdateSetBonus = OnUpdateSetBonus

    inst:AddComponent("multithruster")
    inst.components.multithruster:SetCooldown(COOLDOWN)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(COOLDOWN)
    inst.components.rechargeable:Discharge(0)

    inst:ListenForEvent("equipped", OnEquip)
    inst:ListenForEvent("unequipped", OnUnequip)
end

if TUNING.APO_TWEAK_ARMORRUINS then
    AddPrefabPostInit("ruins_bat", RuinsBatPostInit)
end