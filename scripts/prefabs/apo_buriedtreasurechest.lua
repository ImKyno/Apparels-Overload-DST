local BuriedTreasureChestLoot = require("apo_buriedtreasurechestloot")

local assets =
{
    Asset("ANIM", "anim/x_marks_spot.zip"),
}

local prefabs =
{
    "collapse_small",
    "treasurechest",
}

local function OnSpawnTreasureChest(inst)
    local chest = SpawnPrefab("treasurechest")

    if chest ~= nil then
        chest.Transform:SetPosition(inst.Transform:GetWorldPosition())
        BuriedTreasureChestLoot.GetRandomChestLoot(chest)
    end
end

local function OnDig(inst, worker)
    if worker ~= nil and inst.components.lootdropper ~= nil then
        local pt = Vector3(inst.Transform:GetWorldPosition())
        local hispos = Vector3(worker.Transform:GetWorldPosition())
        local he_right = ((hispos - pt):Dot(TheCamera:GetRightVec()) > 0)

        if he_right then
            inst.components.lootdropper:DropLoot(pt - (TheCamera:GetRightVec() * (math.random() + 1)))
        else
            inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec() * (math.random() + 1)))
        end

        local fx = SpawnPrefab("collapse_small")

        if fx ~= nil then
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end

        OnSpawnTreasureChest(inst)

        worker:PushEvent("buriedtreasurechestfound") -- This differs from "onburiedtreasurechestfound" event.

        inst:Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("pirate_stash.png")
    minimap:SetPriority(5)

    inst.AnimState:SetBank("x_marks_spot")
    inst.AnimState:SetBuild("x_marks_spot")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("buried")

    inst.scrapbook_proxy = "pirate_stash"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "boneshard" })

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(OnDig)
    inst.components.workable:SetWorkLeft(1)

    return inst
end

return Prefab("buriedtreasurechest", fn, assets, prefabs)