local assets =
{
    Asset("ANIM", "anim/armor_metalplate.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

local KEY = "metalplate_setbonus"
local THRESHOLD = TUNING.APO_ARMORS.METALPLATE.THRESHOLD
local MODIFIER = TUNING.APO_ARMORS.METALPLATE.MODIFIER

local function OnBlocked(owner)
    if owner ~= nil then
        owner.SoundEmitter:PlaySound("apo_sounds/common/armor_metalplate/hit")
    end
end

-- Fancy Suit Set Bonus:
-- Increases damage dealt by 10%, decreases damage taken by 10%.
local function OnEnabledSetBonus(inst)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

    if owner ~= nil then
        if owner.components.combat ~= nil then
            owner.components.combat.externaldamagemultipliers:SetModifier(owner, MODIFIER, KEY)
        end

        if owner.components.health ~= nil then
            owner.components.health.externalabsorbmodifiers:SetModifier(owner, MODIFIER, KEY)
        end
    end
end

local function OnDisabledSetBonus(inst)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

    if owner ~= nil then
        if owner.components.combat ~= nil then
            owner.components.combat.externaldamagemultipliers:RemoveModifier(owner, KEY)
        end

        if owner.components.health ~= nil then
            owner.components.health.externalabsorbmodifiers:RemoveModifier(owner, KEY)
        end
    end
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_metalplate")
        else
            owner.AnimState:OverrideSymbol("swap_body", "armor_metalplate", "swap_body")
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

    inst.AnimState:SetBank("armor_metalplate")
    inst.AnimState:SetBuild("armor_metalplate")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("heavyarmor")
    inst:AddTag("hardarmor")

    inst.foleysound = "apo_sounds/movement/armor_metalplate/foley"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.APO_ARMORS.METALPLATE.CONDITION, TUNING.APO_ARMORS.METALPLATE.ABSORPTION)

    inst:AddComponent("setbonus")
    inst.components.setbonus:SetSetName(EQUIPMENTSETNAMES.METALPLATE)
    inst.components.setbonus:SetOnEnabledFn(OnEnabledSetBonus)
    inst.components.setbonus:SetOnDisabledFn(OnDisabledSetBonus)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.walkspeedmult = TUNING.APO_ARMORS.METALPLATE.WALKSPEEDMULT

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("armor_metalplate", fn, assets)