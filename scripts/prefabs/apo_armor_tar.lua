local assets =
{
    Asset("ANIM", "anim/armor_tar.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

local function OnBlocked(owner)
    if owner ~= nil then
        owner.SoundEmitter:PlaySound("apo_sounds/common/armor_blubber/hit")
    end
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_tar")
        else
            owner.AnimState:OverrideSymbol("swap_body", "armor_tar", "swap_body")
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

local function OnRepaired(inst, doer, repair_item)
    if doer ~= nil then
        doer:PushEvent("repair")
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

    inst.AnimState:SetBank("armor_tar")
    inst.AnimState:SetBuild("armor_tar")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("shadow_item")
    inst:AddTag("shadowlevel")
    inst:AddTag("waterproofer")

    inst.foleysound = "apo_sounds/movement/armor_blubber/foley"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)

    inst:AddComponent("shadowlevel")
    inst.components.shadowlevel:SetDefaultLevel(TUNING.APO_ARMORS.TAR.SHADOWLEVEL)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.APO_ARMORS.TAR.CONDITION, TUNING.APO_ARMORS.TAR.ABSORPTION)

    inst:AddComponent("planardefense")
    inst.components.planardefense:SetBaseDefense(TUNING.APO_ARMORS.TAR.PLANAR_ABSORPTION)

    inst:AddComponent("damagetyperesist")
    inst.components.damagetyperesist:AddResist("shadow_aligned", inst, TUNING.APO_ARMORS.TAR.DAMAGETYPE_RESIST)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    MakeHauntableLaunch(inst)
    MakeCraftingMaterialRecycler(inst, { gelblob_bottle = "messagebottleempty" })

    return inst
end

return Prefab("armor_tar", fn, assets)