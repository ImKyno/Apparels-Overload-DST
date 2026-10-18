local assets =
{
    Asset("ANIM", "anim/leif_stalk.zip"),
    Asset("ANIM", "anim/meat_rack_food_leif.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),
}

local prefabs =
{
    "leif_walkingstick",
    "spoiled_food",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("leif_stalk")
    inst.AnimState:SetBuild("leif_stalk")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("dryable")

    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("bait")
    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GENERIC
    inst.components.edible.healthvalue = TUNING.APO_LEIF_STALK.HEALTH
    inst.components.edible.hungervalue = TUNING.APO_LEIF_STALK.HUNGER
    inst.components.edible.sanityvalue = TUNING.APO_LEIF_STALK.SANITY

    inst:AddComponent("dryable")
    inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
    inst.components.dryable:SetProduct("leif_walkingstick")
    inst.components.dryable:SetBuildFile("meat_rack_food_leif")
    inst.components.dryable:SetDriedBuildFile("meat_rack_food_leif")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("leif_stalk", fn, assets, prefabs)