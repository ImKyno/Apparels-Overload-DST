local _G = GLOBAL

local function OnApplySleepingBagBonus(owner)
    local SLEEP_HEALTH_MULT = TUNING.APO_ARMORS.BEARGERVEST.SLEEPINGBAG.HEALTH
    local SLEEP_HUNGER_MULT = TUNING.APO_ARMORS.BEARGERVEST.SLEEPINGBAG.HUNGER
    local SLEEP_SANITY_MULT = TUNING.APO_ARMORS.BEARGERVEST.SLEEPINGBAG.SANITY

    if owner ~= nil then
        if owner.components.sleepingbaguser ~= nil then
            if owner._sleepingbag_bonus == nil then
                owner._sleepingbag_bonus =
                {
                    health = owner.components.sleepingbaguser.health_bonus_mult,
                    hunger = owner.components.sleepingbaguser.hunger_bonus_mult,
                    sanity = owner.components.sleepingbaguser.sanity_bonus_mult,
                }
            end

            owner._sleepingbag_bonus_count = (owner._sleepingbag_bonus_count or 0) + 1

            owner.components.sleepingbaguser:SetHealthBonusMult(owner._sleepingbag_bonus.health * SLEEP_HEALTH_MULT)
            owner.components.sleepingbaguser:SetHungerBonusMult(owner._sleepingbag_bonus.hunger * SLEEP_HUNGER_MULT)
            owner.components.sleepingbaguser:SetSanityBonusMult(owner._sleepingbag_bonus.sanity * SLEEP_SANITY_MULT)
        end
    end
end

local function OnRemoveSleepingBagBonus(owner)
    if owner ~= nil then
        if owner.components.sleepingbaguser ~= nil then
            if owner._sleepingbag_bonus_count == nil then
                return
            end

            owner._sleepingbag_bonus_count = math.max(0, owner._sleepingbag_bonus_count - 1)

            if owner._sleepingbag_bonus_count <= 0 then
                owner._sleepingbag_bonus_count = nil

                if owner._sleepingbag_bonus ~= nil then
                    owner.components.sleepingbaguser:SetHealthBonusMult(owner._sleepingbag_bonus.health)
                    owner.components.sleepingbaguser:SetHungerBonusMult(owner._sleepingbag_bonus.hunger)
                    owner.components.sleepingbaguser:SetSanityBonusMult(owner._sleepingbag_bonus.sanity)

                    owner._sleepingbag_bonus = nil
                end
            end
        end
    end
end

local function OnApplyStatus(inst, bonus)
    if inst.beargervest_bonussanity then
        return false
    end

    inst.beargervest_bonussanity = bonus

    if inst.components.sanity ~= nil then
        local current_sanity = inst.sanity_percent or inst.components.sanity:GetPercent()
        inst.sanity_percent = nil

        inst.components.sanity:SetMax(inst.components.sanity.max + bonus)
        inst.components.sanity:SetPercent(current_sanity)
    end

    return true
end

local function OnRemoveStatus(inst)
    if not inst.beargervest_bonussanity then
        return
    end

    if inst.components.sanity ~= nil then
        local current_sanity = inst.sanity_percent or inst.components.sanity:GetPercent()
        inst.sanity_percent = nil

        inst.components.sanity:SetMax(inst.components.sanity.max - inst.beargervest_bonussanity)
        inst.components.sanity:SetPercent(current_sanity)
    end

    inst.beargervest_bonussanity = nil
end

local function BeargerVestPostInit(inst)
    inst:AddTag("absorbsfreezing")

    _G.APOAddEquipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            OnApplySleepingBagBonus(owner)
            OnApplyStatus(owner, TUNING.APO_ARMORS.BEARGERVEST.BONUS)
        end
    end)

    _G.APOAddUnequipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            OnRemoveSleepingBagBonus(owner)
            OnRemoveStatus(owner)
        end
    end)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.freezing_damage = TUNING.APO_ARMORS.BEARGERVEST.FREEZING_DAMAGE
end

if TUNING.APO_TWEAK_BEARGERVEST then
    AddPrefabPostInit("beargervest", BeargerVestPostInit)
end