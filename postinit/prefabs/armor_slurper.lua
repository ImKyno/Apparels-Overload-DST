local _G = GLOBAL

local function OnApplyStatus(inst, bonus)
    if inst.armorslurper_bonushunger then
        return false
    end

    inst.armorslurper_bonushunger = bonus

    if inst.components.hunger ~= nil then
        local current_hunger = inst.hunger_percent or inst.components.hunger:GetPercent()
        inst.hunger_percent = nil

        inst.components.hunger:SetMax(inst.components.hunger.max + bonus)
        inst.components.hunger:SetPercent(current_hunger)
    end

    return true
end

local function OnRemoveStatus(inst)
    if not inst.armorslurper_bonushunger then
        return
    end

    if inst.components.hunger ~= nil then
        local current_hunger = inst.hunger_percent or inst.components.hunger:GetPercent()
        inst.hunger_percent = nil

        inst.components.hunger:SetMax(inst.components.hunger.max - inst.armorslurper_bonushunger)
        inst.components.hunger:SetPercent(current_hunger)
    end

    inst.armorslurper_bonushunger = nil
end

local function ArmorSlurperPostInit(inst)
    _G.APOAddEquipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            local modifier = TUNING.APO_ARMORS.SLURPER.HUNGER_MODIFIER

            OnApplyStatus(owner, TUNING.APO_ARMORS.SLURPER.BONUS)

            if owner.components.hunger ~= nil then
                owner.components.hunger.burnratemodifiers:SetModifier(inst, modifier, "armorslurper")
            end
        end
    end)

    _G.APOAddUnequipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            OnRemoveStatus(owner)

            if owner.components.hunger ~= nil then
                owner.components.hunger.burnratemodifiers:RemoveModifier(inst, "armorslurper")
            end
        end
    end)
end

if TUNING.APO_TWEAK_ARMORSLURPER then
    AddPrefabPostInit("armorslurper", ArmorSlurperPostInit)
end