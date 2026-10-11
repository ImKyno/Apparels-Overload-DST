local assets =
{
    Asset("ANIM", "anim/shark_fin.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),
}

local prefabs =
{
    "spoiled_food",
}

local function OnLanded(inst)
    local x, y, z = inst.Transform:GetWorldPosition()

    if TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
        inst.AnimState:PlayAnimation("idle_water", true)
    else
        inst.AnimState:PlayAnimation("idle", true)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("shark_fin")
    inst.AnimState:SetBuild("shark_fin")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("meat")
    inst:AddTag("catfood")
    inst:AddTag("shark_fin")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.RAREMEAT

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = TUNING.APO_MISC.SHARK_FIN.HEALTH
    inst.components.edible.hungervalue = TUNING.APO_MISC.SHARK_FIN.HUNGER
    inst.components.edible.sanityvalue = TUNING.APO_MISC.SHARK_FIN.SANITY

    inst:ListenForEvent("on_landed", OnLanded)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("shark_fin", fn, assets, prefabs)