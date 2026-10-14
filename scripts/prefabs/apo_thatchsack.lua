local assets =
{
    Asset("ANIM", "anim/thatchsack.zip"),
    Asset("ANIM", "anim/ui_chest_1x2.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("IMAGE", "images/minimapimages/apo_minimapimages.tex"),
    Asset("ATLAS", "images/minimapimages/apo_minimapimages.xml"),
}

local prefabs =
{
    "ash",
}

local function OnOpen(inst)
    local SoundEmitter = (inst.components.inventoryitem:GetGrandOwner() or inst).SoundEmitter

    if SoundEmitter then
        SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
    end

    inst.AnimState:PlayAnimation("use")
    inst.AnimState:PushAnimation("idle", true)
end

local function OnClose(inst)
    local SoundEmitter = (inst.components.inventoryitem:GetGrandOwner() or inst).SoundEmitter

    if SoundEmitter then
        SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
    end

    inst.AnimState:PlayAnimation("use")
    inst.AnimState:PushAnimation("idle", true)
end

local function OnPutInInventory(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end

    inst.AnimState:PushAnimation("idle", true)
end

local function OnDropped(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end

    inst.AnimState:PushAnimation("idle", true)
end

local function OnBurnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end

    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:Remove()
end

local function OnIgnite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end

local function OnExtinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("thatchsack.tex")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("thatchsack")
    inst.AnimState:SetBuild("thatchsack")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("portablestorage")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("thatchsack")
        end

        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("thatchsack")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true
    inst.components.container.droponopen = true

    MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    inst.components.burnable:SetOnBurntFn(OnBurnt)
    inst.components.burnable:SetOnIgniteFn(OnIgnite)
    inst.components.burnable:SetOnExtinguishFn(OnExtinguish)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("thatchsack", fn, assets, prefabs)