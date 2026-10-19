local _G = GLOBAL

local function OnApplyStatus(inst, bonus)
    if inst.sweatervest_bonussanity then
        return false
    end

    inst.sweatervest_bonussanity = bonus

    if inst.components.sanity ~= nil then
        local current_sanity = inst.sanity_percent or inst.components.sanity:GetPercent()
        inst.sanity_percent = nil

        inst.components.sanity:SetMax(inst.components.sanity.max + bonus)
        inst.components.sanity:SetPercent(current_sanity)
    end

    return true
end

local function OnRemoveStatus(inst)
    if not inst.sweatervest_bonussanity then
        return
    end

    if inst.components.sanity ~= nil then
        local current_sanity = inst.sanity_percent or inst.components.sanity:GetPercent()
        inst.sanity_percent = nil

        inst.components.sanity:SetMax(inst.components.sanity.max - inst.sweatervest_bonussanity)
        inst.components.sanity:SetPercent(current_sanity)
    end

    inst.sweatervest_bonussanity = nil
end

local function SweaterVestPostInit(inst)
    _G.APOAddEquipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            OnApplyStatus(owner, TUNING.APO_ARMORS.SWEATERVEST.BONUS)
        end
    end)

    _G.APOAddUnequipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            OnRemoveStatus(owner)
        end
    end)
end

if TUNING.APO_TWEAK_SWEATERVEST then
    AddPrefabPostInit("sweatervest", SweaterVestPostInit)
end