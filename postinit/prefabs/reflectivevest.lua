local _G = GLOBAL

local function OnApplyStatus(inst, bonus)
    if inst.reflectivevest_bonusstats then
        return false
    end

    inst.reflectivevest_bonusstats = bonus

    if inst.components.health ~= nil then
        local current_health = inst.health_percent or inst.components.health:GetPercent()
        inst.health_percent = nil

        inst.components.health:SetMaxHealth(inst.components.health.maxhealth + bonus)
        inst.components.health:SetPercent(current_health)
    end

    if inst.components.hunger ~= nil then
        local current_hunger = inst.hunger_percent or inst.components.hunger:GetPercent()
        inst.hunger_percent = nil

        inst.components.hunger:SetMax(inst.components.hunger.max + bonus)
        inst.components.hunger:SetPercent(current_hunger)
    end

    if inst.components.sanity ~= nil then
        local current_sanity = inst.sanity_percent or inst.components.sanity:GetPercent()
        inst.sanity_percent = nil

        inst.components.sanity:SetMax(inst.components.sanity.max + bonus)
        inst.components.sanity:SetPercent(current_sanity)
    end

    return true
end

local function OnRemoveStatus(inst)
    if not inst.reflectivevest_bonusstats then
        return
    end

    if inst.components.health ~= nil then
        local current_health = inst.health_percent or inst.components.health:GetPercent()
        inst.health_percent = nil

        inst.components.health:SetMaxHealth(inst.components.health.maxhealth - inst.reflectivevest_bonusstats)
        inst.components.health:SetPercent(current_health)
    end

    if inst.components.hunger ~= nil then
        local current_hunger = inst.hunger_percent or inst.components.hunger:GetPercent()
        inst.hunger_percent = nil

        inst.components.hunger:SetMax(inst.components.hunger.max - inst.reflectivevest_bonusstats)
        inst.components.hunger:SetPercent(current_hunger)
    end

    if inst.components.sanity ~= nil then
        local current_sanity = inst.sanity_percent or inst.components.sanity:GetPercent()
        inst.sanity_percent = nil

        inst.components.sanity:SetMax(inst.components.sanity.max - inst.reflectivevest_bonusstats)
        inst.components.sanity:SetPercent(current_sanity)
    end

    inst.reflectivevest_bonusstats = nil
end

local function OnUpdateStatus(owner, season)
    if season == "summer" then
        OnApplyStatus(owner, TUNING.APO_ARMORS.REFLECTIVEVEST.BONUS)
    else
        OnRemoveStatus(owner)
    end
end

local function ReflectiveVestPostInit(inst)
    _G.APOAddEquipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            owner:WatchWorldState("season", OnUpdateStatus)

            OnUpdateStatus(owner, _G.TheWorld.state.season)
        end
    end)

    _G.APOAddUnequipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            owner:StopWatchingWorldState("season", OnUpdateStatus)

            OnRemoveStatus(owner)
        end
    end)
end

if TUNING.APO_TWEAK_REFLECTIVEVEST then
    AddPrefabPostInit("reflectivevest", ReflectiveVestPostInit)
end