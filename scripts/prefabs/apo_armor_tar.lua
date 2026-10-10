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

    inst.foleysound = "apo_sounds/common/armor_blubber/foley"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("waterproofer")
    inst.components.waterproofer.effectiveness = TUNING.WATERPROOFNESS_ABSOLUTE

    inst:AddComponent("shadowlevel")
    inst.components.shadowlevel:SetDefaultLevel(TUNING.APO_ARMOR_TAR.SHADOWLEVEL)

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.APO_ARMOR_TAR.CONDITION, TUNING.APO_ARMOR_TAR.ABSORPTION)

    inst:AddComponent("planardefense")
    inst.components.planardefense:SetBaseDefense(TUNING.APO_ARMOR_TAR.PLANAR_ABSORPTION)

    inst:AddComponent("damagetyperesist")
    inst.components.damagetyperesist:AddResist("shadow_aligned", inst, TUNING.APO_ARMOR_TAR.DAMAGETYPE_RESIST)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.insulated = true

    MakeHauntableLaunch(inst)
    MakeCraftingMaterialRecycler(inst, { gelblob_bottle = "messagebottleempty" })

    return inst
end

return Prefab("armor_tar", fn, assets)