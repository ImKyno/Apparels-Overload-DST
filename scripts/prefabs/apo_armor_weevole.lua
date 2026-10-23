local assets =
{
    Asset("ANIM", "anim/armor_weevole.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

local HEALTH_MIN = TUNING.APO_ARMORS.WEEVOLE.HEALTH.MIN
local HEALTH_MAX = TUNING.APO_ARMORS.WEEVOLE.HEALTH.MAX

local function IsLifeDrainable(target)
    return target ~= nil and (not target:HasAnyTag(NON_LIFEFORM_TARGET_TAGS) or target:HasTag("lifedrainable"))
end

local function OnBlocked(owner)
    if owner ~= nil then
        owner.SoundEmitter:PlaySound("apo_sounds/common/armor_ant/hit")
    end
end

local function OnUpdate(inst)
    if inst.components.armor ~= nil then
        inst.components.armor:SetPercent(inst.components.fueled:GetPercent())
    end
end

local function OnTakeDamage(inst, damage_amount, absorbed, leftover)
    if inst.components.armor ~= nil and inst.components.fueled ~= nil then
        local absorbed = damage_amount * TUNING.APO_ARMORS.WEEVOLE.ABSORPTION
        local absorbed_dmg = absorbed / inst.components.armor.maxcondition

        local percent = inst.components.fueled:GetPercent()
        local newpercent = percent - absorbed_dmg

        inst.components.fueled:SetPercent(newpercent)
    end
end

local function OnKilled(owner, data)
    if owner ~= nil and data ~= nil then
        local victim = data.victim

        if victim == nil or not IsLifeDrainable(victim) then
            return
        end

        local armor = owner.components.inventory ~= nil
        and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil

        if armor ~= nil and armor:HasTag("mosquitoarmor") then
            if owner.components.health ~= nil then
                owner.components.health:DoDelta(math.random(HEALTH_MIN, HEALTH_MAX), false, "armor_weevole")
            end
        end
    end
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_weevole")
        else
            owner.AnimState:OverrideSymbol("swap_body", "armor_weevole", "swap_body")
        end

        inst:ListenForEvent("blocked", OnBlocked, owner)

        owner:ListenForEvent("killed", OnKilled)

        if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
    end
end

local function OnUnequip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("unequipskinneditem", inst:GetSkinName())
        end

        owner.AnimState:ClearOverrideSymbol("swap_body")

        inst:RemoveEventCallback("blocked", OnBlocked, owner)

        owner:RemoveEventCallback("killed", OnKilled)

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end
    end
end

local function OnEquipToModel(inst, owner, from_ground)
    if owner ~= nil then
        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.AnimState:SetBank("armor_weevole")
    inst.AnimState:SetBuild("armor_weevole")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("waterproofer")
    inst:AddTag("mosquitoarmor")

    inst.foleysound = "apo_sounds/movement/armor_ant/foley"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_MED)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.APO_ARMORS.WEEVOLE.CONDITION, TUNING.APO_ARMORS.WEEVOLE.ABSORPTION)
    inst.components.armor.ontakedamage = OnTakeDamage

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.APO_ARMORS.WEEVOLE.PERISHTIME)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled:SetUpdateFn(OnUpdate)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("armor_weevole", fn, assets)