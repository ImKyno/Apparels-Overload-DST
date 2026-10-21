local assets =
{
    Asset("ANIM", "anim/armor_ant.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

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
        local absorbed = damage_amount * TUNING.APO_ARMORS.ANT.ABSORPTION
        local absorbed_dmg = absorbed / inst.components.armor.maxcondition

        local percent = inst.components.fueled:GetPercent()
        local newpercent = percent - absorbed_dmg

        inst.components.fueled:SetPercent(newpercent)
    end
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_ant")
        else
            owner.AnimState:OverrideSymbol("swap_body", "armor_ant", "swap_body")
        end

        inst:ListenForEvent("blocked", OnBlocked, owner)

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

    inst.AnimState:SetBank("armor_ant")
    inst.AnimState:SetBuild("armor_ant")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("beefriend")

    inst.foleysound = "apo_sounds/movement/armor_ant/foley"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.APO_ARMORS.ANT.CONDITION, TUNING.APO_ARMORS.ANT.ABSORPTION)
    inst.components.armor:SetTags(TUNING.APO_ARMORS.ANT.TAGS)
    inst.components.armor.ontakedamage = OnTakeDamage

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.APO_ARMORS.ANT.PERISHTIME)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled:SetUpdateFn(OnUpdate)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("armor_ant", fn, assets)