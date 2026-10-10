local assets =
{
    Asset("ANIM", "anim/armor_windbreaker.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

local function OnCheckSpeed(owner)
    return TheWorld.state.israining
    or (owner ~= nil and owner.components.moisture ~= nil
    and owner.components.moisture:GetMoisture() >= TUNING.APO_ARMOR_WINDBREAKER.THRESHOLD)
end

local function OnUpdateSpeed(inst, owner)
    if owner ~= nil then
        if OnCheckSpeed(owner) then
            inst.components.equippable.walkspeedmult = TUNING.APO_ARMOR_WINDBREAKER.WALKSPEEDMULT.RAIN
        else
            inst.components.equippable.walkspeedmult = TUNING.APO_ARMOR_WINDBREAKER.WALKSPEEDMULT.NORMAL
        end
    end
end

local function OnMoistureDelta(owner, data)
    if owner ~= nil then
        if owner._windbreaker ~= nil then
            OnUpdateSpeed(owner._windbreaker, owner)
        end
    end
end

local function OnRainChange(inst, israining)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner

    if owner ~= nil then
        OnUpdateSpeed(inst, owner)
    end
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_wood")
        else
            owner.AnimState:OverrideSymbol("swap_body", "armor_windbreaker", "swap_body")
        end

        owner._windbreaker = inst
        inst._owner = owner

        if owner.components.moisture ~= nil then
            inst:ListenForEvent("moisturedelta", OnMoistureDelta, owner)
        end

        inst:WatchWorldState("israining", OnRainChange)

        OnUpdateSpeed(inst, owner)

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

        owner._windbreaker = nil

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end

        inst:RemoveEventCallback("moisturedelta", OnMoistureDelta, owner)
        inst:StopWatchingWorldState("israining", OnRainChange)
    end

    inst._owner = nil
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

    inst.AnimState:SetBank("armor_windbreaker")
    inst.AnimState:SetBuild("armor_windbreaker")
    inst.AnimState:PlayAnimation("anim")

    inst.foleysound = "apo_sounds/common/armor_windbreaker/foley"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("waterproofer")
    inst.components.waterproofer.effectiveness = TUNING.WATERPROOFNESS_MED

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.APO_ARMOR_WINDBREAKER.PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    inst.components.equippable.walkspeedmult = TUNING.APO_ARMOR_WINDBREAKER.WALKSPEEDMULT.NORMAL

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("armor_windbreaker", fn, assets)