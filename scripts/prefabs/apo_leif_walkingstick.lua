local assets =
{
    Asset("ANIM", "anim/leif_walkingstick.zip"),
    Asset("ANIM", "anim/swap_leif_walkingstick.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),
}

local function OnEquip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_leif_walkingstick", inst.GUID, "swap_leif_walkingstick")
        else
            owner.AnimState:OverrideSymbol("swap_object", "swap_leif_walkingstick", "swap_leif_walkingstick")
        end

        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

        if inst.leif_walkingstick_owner ~= nil then
            inst:RemoveEventCallback("locomote", inst.leif_walkingstick_onlocomote, inst.leif_walkingstick_owner)
        end

        inst.leif_walkingstick_owner = owner

        inst:ListenForEvent("locomote", inst.leif_walkingstick_onlocomote, owner)
    end
end

local function OnUnequip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("unequipskinneditem", inst:GetSkinName())
        end

        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")

        if inst.leif_walkingstick_owner ~= nil then
            inst:RemoveEventCallback("locomote", inst.leif_walkingstick_onlocomote, inst.leif_walkingstick_owner)
        end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end
    end

    inst.leif_walkingstick_owner = nil
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

    local FLOATER_DATA = { sym_build = "swap_leif_walkingstick" }
    MakeInventoryFloatable(inst, "med", 0.05, { 0.85, 0.45, 0.85 }, true, 1, FLOATER_DATA)

    inst.AnimState:SetBank("leif_walkingstick")
    inst.AnimState:SetBuild("leif_walkingstick")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("weapon")
    inst:AddTag("weaponlowpriority")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.APO_LEIF_WALKINGSTICK.DAMAGE)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.APO_LEIF_WALKINGSTICK.PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
    inst.components.equippable.walkspeedmult = TUNING.APO_LEIF_WALKINGSTICK.WALKSPEEDMULT

    inst.leif_walkingstick_onlocomote = function(owner)
        if owner.components.rider ~= nil and owner.components.rider:IsRiding() then
            return -- No durability waste when mounted.
        end

        if inst.components.fueled ~= nil and owner.components.locomotor ~= nil then
            if owner.components.locomotor.wantstomoveforward then
                if not inst.components.fueled.consuming then
                    inst.components.fueled:StartConsuming()
                end
            elseif inst.components.fueled.consuming then
                inst.components.fueled:StopConsuming()
            end
        end
    end

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("leif_walkingstick", fn, assets)