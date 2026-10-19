local _G = GLOBAL

local function OnCheckSpeed(owner)
    return _G.TheWorld.state.snowlevel ~= nil and _G.TheWorld.state.snowlevel > 0
end

local function OnUpdateSpeed(inst, owner)
    if owner ~= nil then
        if OnCheckSpeed(owner) then
            inst.components.equippable.walkspeedmult = TUNING.APO_ARMORS.TRUNKVEST.WALKSPEEDMULT
        else
            inst.components.equippable.walkspeedmult = 1
        end
    end
end

local function OnSnowChange(inst, snowlevel)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner

    if owner ~= nil then
        OnUpdateSpeed(inst, owner)
    end
end

local function TrunkVestPostInit(inst)
    _G.APOAddEquipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            local modifier = TUNING.APO_ARMORS.TRUNKVEST.HUNGER_MODIFIER

            if owner.components.hunger ~= nil then
                owner.components.hunger.burnratemodifiers:SetModifier(inst, modifier, "trunkvest")
            end

            inst:WatchWorldState("snowlevel", OnSnowChange)

            OnUpdateSpeed(inst, owner)
        end
    end)

    _G.APOAddUnequipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            if inst.components.equippable ~= nil then
                inst.components.equippable.walkspeedmult = 1
            end

            if owner.components.hunger ~= nil then
                owner.components.hunger.burnratemodifiers:RemoveModifier(inst, "trunkvest")
            end

            inst:StopWatchingWorldState("israining", OnSnowChange)
        end
    end)
end

if TUNING.APO_TWEAK_TRUNKVEST_S then
    AddPrefabPostInit("trunkvest_summer", TrunkVestPostInit)
end

if TUNING.APO_TWEAK_TRUNKVEST_W then
    AddPrefabPostInit("trunkvest_winter", TrunkVestPostInit)
end