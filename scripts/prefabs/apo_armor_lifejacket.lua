local assets =
{
    Asset("ANIM", "anim/armor_lifejacket.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

local function OnPreventDrowningDamage(inst, data)
    -- DO SOMETHING ???
end

local function OnSinkWashedAshore(inst, data)
    inst:DoTaskInTime(0.12, inst.Remove)
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_lifejacket")
        else
            owner.AnimState:OverrideSymbol("swap_body", "armor_lifejacket", "swap_body")
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

    inst.AnimState:SetBank("armor_lifejacket")
    inst.AnimState:SetBuild("armor_lifejacket")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("stronggrip")
    inst:AddTag("lifejacket")
    inst:AddTag("waterproofer")

    inst.foleysound = "apo_sounds/common/armor_lifejacket/foley"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("flotationdevice")
    inst.components.flotationdevice.onpreventdrowningdamagefn = OnPreventDrowningDamage

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
    inst.components.insulator:SetSummer()

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL

    inst:ListenForEvent("sink", OnPreventDrowningDamage)
    inst:ListenForEvent("sink_fast", OnPreventDrowningDamage)
    inst:ListenForEvent("sink_washed_ashore", OnSinkWashedAshore)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("armor_lifejacket", fn, assets)