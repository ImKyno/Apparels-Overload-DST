local assets =
{
    Asset("ANIM", "anim/armor_snakeskin.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

local KEY = "snakeskin_setbonus"
local PERIOD = TUNING.APO_ARMORS.SNAKESKIN.SET_BONUS.PERIOD
local AMOUNT_MIN = TUNING.APO_ARMORS.SNAKESKIN.SET_BONUS.AMOUNT.MIN
local AMOUNT_MAX = TUNING.APO_ARMORS.SNAKESKIN.SET_BONUS.AMOUNT.MAX

-- Leather Jacket Set Bonus:
-- Restores 1 sanity every 5 seconds when it's raining.
local function OnUpdateSetBonus(inst, owner)
    if inst.set_bonus_task == nil then
        inst.set_bonus_task = inst:DoPeriodicTask(PERIOD, function()
            if owner ~= nil and owner.components.sanity ~= nil and TheWorld.state.israining then
                owner.components.sanity:DoDelta(math.random(AMOUNT_MIN, AMOUNT_MAX), false, KEY)
            end
        end)
    end
end

local function OnIsRaining(owner, data)
    local armor = owner._armorsnakeskin_setbonus

    if armor == nil then
        return
    end

    if TheWorld.state.israining then
        OnUpdateSetBonus(armor, owner)
    elseif armor.set_bonus_task ~= nil then
        armor.set_bonus_task:Cancel()
        armor.set_bonus_task = nil
    end
end

local function OnEnabledSetBonus(inst)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

    if owner ~= nil then
        inst._armorsnakeskin_setbonus_owner = owner
        owner._armorsnakeskin_setbonus = inst

        inst:WatchWorldState("israining", OnIsRaining)

        if TheWorld.state.israining then
            OnUpdateSetBonus(inst, owner)
        end
    end
end

local function OnDisabledSetBonus(inst)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

    if owner ~= nil then
        inst:StopWatchingWorldState("israining", OnIsRaining)

        if owner._armorsnakeskin_setbonus == inst then
            owner._armorsnakeskin_setbonus = nil
        end
    end

    if inst.set_bonus_task ~= nil then
        inst.set_bonus_task:Cancel()
        inst.set_bonus_task = nil
    end

    inst._armorsnakeskin_setbonus_owner = nil
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_snakeskin")
        else
            owner.AnimState:OverrideSymbol("swap_body", "armor_snakeskin", "swap_body")
        end

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

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end
    end
end

local function OnEquipToModel(inst)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
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

    inst.AnimState:SetBank("armor_snakeskin")
    inst.AnimState:SetBuild("armor_snakeskin")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("waterproofer")

    inst.foleysound = "apo_sounds/common/armor_snakeskin/foley"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_LARGE)

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)

    inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(TUNING.APO_ARMORS.SNAKESKIN.PERISHTIME)
	inst.components.fueled:SetDepletedFn(inst.Remove)

    inst:AddComponent("setbonus")
    inst.components.setbonus:SetSetName(EQUIPMENTSETNAMES.SNAKESKIN)
    inst.components.setbonus:SetOnEnabledFn(OnEnabledSetBonus)
    inst.components.setbonus:SetOnDisabledFn(OnDisabledSetBonus)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
    inst.components.equippable.insulated = true

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("armor_snakeskin", fn, assets)