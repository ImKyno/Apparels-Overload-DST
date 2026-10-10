local assets =
{
    Asset("ANIM", "anim/armor_obsidian.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

local prefabs =
{
    "heatrocklight",
}

local function OnBlocked(owner, data)
    if owner ~= nil then
        owner.SoundEmitter:PlaySound("apo_sounds/common/armor_obsidian/hit")
    end

    if data.attacker ~= nil and not (data.attacker.components.health ~= nil and data.attacker.components.health:IsDead())
    and (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil)
    and data.weapon.components.projectile == nil)) and data.attacker.components.burnable ~= nil and not data.redirected
    and not data.attacker:HasTag("thorny") then
        data.attacker.components.burnable:Ignite(true, owner)
    end
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_obsidian")
        else
            owner.AnimState:OverrideSymbol("swap_body", "armor_obsidian", "swap_body")
        end

        owner.AnimState:SetSymbolLightOverride("swap_body", TUNING.APO_ARMOR_OBSIDIAN.LIGHT_OVERRIDE)

        inst:ListenForEvent("attacked", OnBlocked, owner)
        inst:ListenForEvent("blocked", OnBlocked, owner)

        if inst.components.heater ~= nil then
            inst.components.heater:SetThermics(true, false)
        end

        if owner.components.health ~= nil then
            owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 1 - TUNING.APO_ARMOR_OBSIDIAN.FIRERESIST)
        end

        inst._light = SpawnPrefab("heatrocklight")

        if inst._light ~= nil then
            inst._light.Light:Enable(true)
            inst._light.entity:SetParent(owner.entity)
        end
    end
end

local function OnUnequip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("unequipskinneditem", inst:GetSkinName())
        end

        owner.AnimState:SetSymbolLightOverride("swap_object", 0)
        owner.AnimState:ClearOverrideSymbol("swap_body")

        if inst.components.heater ~= nil then
            inst.components.heater:SetThermics(false, false)
        end

        if owner.components.health ~= nil then
            owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
        end

        inst:RemoveEventCallback("attacked", OnBlocked, owner)
        inst:RemoveEventCallback("blocked", OnBlocked, owner)
    end

    if inst._light ~= nil then
        inst._light:Remove()
        inst._light = nil
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(0.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(232/255, 141/255, 67/255)
    inst.Light:Enable(true)

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.AnimState:SetBank("armor_obsidian")
    inst.AnimState:SetBuild("armor_obsidian")
    inst.AnimState:PlayAnimation("anim")

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(TUNING.APO_ARMOR_OBSIDIAN.LIGHT_OVERRIDE)

    inst:AddTag("HASHEATER")
    inst:AddTag("heavyarmor")
    inst:AddTag("hardarmor")
    inst:AddTag("absorbsoverheat")

    inst.foleysound = "apo_sounds/common/armor_obsidian/foley"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.overheat_damage = TUNING.APO_ARMOR_OBSIDIAN.OVERHEAT_DAMAGE

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("heater")
    inst.components.heater.equippedheat = TUNING.APO_ARMOR_OBSIDIAN.HEAT

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.APO_ARMOR_OBSIDIAN.CONDITION, TUNING.APO_ARMOR_OBSIDIAN.ABSORPTION)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
    inst.components.equippable.walkspeedmult = TUNING.APO_ARMOR_OBSIDIAN.WALKSPEEDMULT

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("armor_obsidian", fn, assets, prefabs)