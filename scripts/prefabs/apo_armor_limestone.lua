local assets =
{
    Asset("ANIM", "anim/armor_limestone.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

local function OnBlocked(owner)
    if owner ~= nil then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_marble")
    end
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_limestone")
        else
            owner.AnimState:OverrideSymbol("swap_body", "armor_limestone", "swap_body")
        end

        inst:ListenForEvent("blocked", OnBlocked, owner)
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

    inst.AnimState:SetBank("armor_limestone")
    inst.AnimState:SetBuild("armor_limestone")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("heavyarmor")
    inst:AddTag("hardarmor")
    inst:AddTag("waterproofer")

    inst.foleysound = "apo_sounds/common/armor_limestone/foley"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_MED)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.APO_ARMORS.LIMESTONE.CONDITION, TUNING.APO_ARMORS.LIMESTONE.ABSORPTION)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    inst.components.equippable.walkspeedmult = TUNING.APO_ARMORS.LIMESTONE.WALKSPEEDMULT

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("armor_limestone", fn, assets)