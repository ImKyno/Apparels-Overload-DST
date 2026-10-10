local assets =
{
    Asset("ANIM", "anim/armor_cactus.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),
}

local prefabs =
{
    "bramblefx_armor",
}

local function OnCooldown(inst)
    inst._cdtask = nil
end

local function OnThorns(inst, owner)
    inst._cdtask = inst:DoTaskInTime(0.3, OnCooldown)

    if inst._hitcount then
        inst._hitcount = 0
    end

    SpawnPrefab("bramblefx_armor"):SetFXOwner(owner)

    if owner ~= nil then
        owner.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
    end
end

local function OnBlocked(owner, data, inst)
    if inst._cdtask == nil and data ~= nil and not data.redirected then
        OnThorns(inst, owner)
    end
end

local function OnAttackOther(owner, data, inst)
    if inst._cdtask == nil and owner.components.skilltreeupdater
    and owner.components.skilltreeupdater:IsActivated("wormwood_armor_bramble") then
        inst._hitcount = inst._hitcount + 1

        if inst._hitcount >= TUNING.WORMWOOD_ARMOR_BRAMBLE_RELEASE_SPIKES_HITCOUNT then
            DoThorns(inst, owner)
        end
    else
        inst._hitcount = 0
    end
end

local function OnArmorDamaged(inst, damage)
    if inst.components.perishable ~= nil and damage ~= nil and damage > 0 then
        local perishable = inst.components.perishable
        local reduction = damage / TUNING.APO_ARMOR_CACTUS.CONDITION

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
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_cactus")
        else
            owner.AnimState:OverrideSymbol("swap_body", "armor_cactus", "swap_body")
        end

        inst:ListenForEvent("armordamaged", OnArmorDamaged)
        inst:ListenForEvent("blocked", inst._onblocked, owner)
        inst:ListenForEvent("attacked", inst._onblocked, owner)

        if owner:HasTag("plantkin") then
            inst:ListenForEvent("onattackother", inst._onattackother, owner)
        end

        inst._hitcount = 0
    end
end

local function OnUnequip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("unequipskinneditem", inst:GetSkinName())
        end

        owner.AnimState:ClearOverrideSymbol("swap_body")

        inst:RemoveEventCallback("armordamaged", OnArmorDamaged)
        inst:RemoveEventCallback("blocked", inst._onblocked, owner)
        inst:RemoveEventCallback("attacked", inst._onblocked, owner)
        inst:RemoveEventCallback("onattackother", inst._onattackother, owner)
    end

    inst._hitcount = nil
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("armor_cactus")
    inst.AnimState:SetBuild("armor_cactus")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("show_spoilage")
    inst:AddTag("hide_percentage")
    inst:AddTag("bramble_resistant")

    inst.foleysound = "dontstarve/movement/foley/cactus_armor"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._hitcount = nil

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("armor")
    inst.components.armor:InitIndestructible(TUNING.APO_ARMOR_CACTUS.ABSORPTION)
    inst.components.armor:AddWeakness("beaver", TUNING.BEAVER_WOOD_DAMAGE)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:SetOnPerishFn(OnFinished)
    inst.components.perishable:StartPerishing()

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst._onblocked = function(owner, data)
        OnBlocked(owner, data, inst)
    end

    inst._onattackother = function(owner, data)
        OnAttackOther(owner, data, inst)
    end

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("armor_cactus", fn, assets, prefabs)