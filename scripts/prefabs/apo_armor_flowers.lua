local assets =
{
    Asset("ANIM", "anim/armor_flowers.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),
}

local function OnBlocked(owner)
    if owner ~= nil then
        if owner.SoundEmitter ~= nil then
            owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
        end
    end
end

local function OnArmorDamaged(inst, damage)
    if inst.components.perishable ~= nil and damage ~= nil and damage > 0 then
        local perishable = inst.components.perishable
        local reduction = damage / TUNING.APO_ARMORS.FLOWERS.CONDITION

        if perishable:GetPercent() <= reduction then
            perishable:SetPercent(0)
            perishable:Perish()
        else
            perishable:ReducePercent(reduction)
        end
    end
end

local function OnFinished(inst)
    if inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner ~= nil then
        inst.components.inventoryitem.owner:PushEvent("armorbroke", { armor = inst })
    end

    inst:Remove()
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_flowers")
        else
            owner.AnimState:OverrideSymbol("swap_body", "armor_flowers", "swap_body")
        end

        inst:ListenForEvent("blocked", OnBlocked, owner)
        inst:ListenForEvent("armordamaged", OnArmorDamaged)
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
        inst:RemoveEventCallback("armordamaged", OnArmorDamaged)
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

    inst.AnimState:SetBank("armor_flowers")
    inst.AnimState:SetBuild("armor_flowers")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("grass")
    inst:AddTag("flowered")
    inst:AddTag("beebeacon")
    inst:AddTag("show_spoilage")
    inst:AddTag("hide_percentage")

    inst.foleysound = "dontstarve/movement/foley/grassarmour"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("forcecompostable")
    inst.components.forcecompostable.green = true

    inst:AddComponent("armor")
    inst.components.armor:InitIndestructible(TUNING.APO_ARMORS.FLOWERS.ABSORPTION)
    inst.components.armor:AddWeakness("beaver", TUNING.BEAVER_WOOD_DAMAGE)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:SetOnPerishFn(OnFinished)
    inst.components.perishable:StartPerishing()

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_TINY
    inst.components.equippable.flipdapperonmerms = true

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("armor_flowers", fn, assets)