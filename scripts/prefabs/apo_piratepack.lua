local assets =
{
    Asset("ANIM", "anim/piratepack.zip"),
    Asset("ANIM", "anim/ui_piggyback_2x6.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("IMAGE", "images/minimapimages/apo_minimapimages.tex"),
    Asset("ATLAS", "images/minimapimages/apo_minimapimages.xml"),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

local prefabs = {}

for _, loot in pairs(TUNING.PIRATEPACK.LOOT) do
    for _, prefab in ipairs(loot) do
        table.insert(prefabs, prefab)
    end
end

local function OnSpawnReward(inst)
    local owner = inst._reward_owner

    if owner == nil then
        return
    end

    if owner ~= nil and owner.components.inventory ~= nil then
        local weights = TUNING.PIRATEPACK.LOOT_WEIGHTS
        local rarity = weighted_random_choice(weights)
        local loot = TUNING.PIRATEPACK.LOOT[rarity]

        if loot == nil or #loot == 0 then
            return
        end

        local prefab = loot[math.random(#loot)]
        local reward = SpawnPrefab(prefab)

        if reward ~= nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            reward.Transform:SetPosition(x, y + 1, z)

            if reward.Physics ~= nil then
                local angle = owner.Transform:GetRotation() * (PI / 180)
                local speed = (math.random() + 1) * -1

                reward.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, -speed * math.sin(angle))
            end
        end
    end
end

local function OnStartRewardTask(inst, owner)
    if inst._reward_task ~= nil then
        inst._reward_task:Cancel()
        inst._reward_task = nil
    end

    inst._reward_owner = owner

    inst._reward_task = inst:DoPeriodicTask(TUNING.PIRATEPACK.COOLDOWN, OnSpawnReward, TUNING.PIRATEPACK.COOLDOWN)
end

local function OnStopRewardTask(inst)
    if inst._reward_task ~= nil then
        inst._reward_task:Cancel()
        inst._reward_task = nil
    end

    inst._reward_owner = nil
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        owner.AnimState:OverrideSymbol("swap_body", "piratepack", "backpack")
        owner.AnimState:OverrideSymbol("swap_body", "piratepack", "swap_body")

        if inst.components.container ~= nil then
            inst.components.container:Open(owner)
        end

        OnStartRewardTask(inst, owner)
    end
end

local function OnUnequip(inst, owner)
    if owner ~= nil then
        owner.AnimState:ClearOverrideSymbol("swap_body")
        owner.AnimState:ClearOverrideSymbol("backpack")

        if inst.components.container ~= nil then
            inst.components.container:Close(owner)
        end

        OnStopRewardTask(inst)
    end
end

local function OnEquipToModel(inst, owner)
    if owner ~= nil then
        if inst.components.container ~= nil then
            inst.components.container:Close(owner)
        end

        OnStopRewardTask(inst)
    end
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
    minimap:SetIcon("piratepack.tex")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small", 0.1, 0.85)

    inst.AnimState:SetBank("piratepack")
    inst.AnimState:SetBuild("piratepack")
    inst.AnimState:PlayAnimation("idle")

    inst.foleysound = "apo_sounds/movement/piratepack/foley"

    inst:AddTag("backpack")
    inst:AddTag("waterproofer")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("piggyback")
        end

        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("piggyback")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

    MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    inst.components.burnable:SetOnBurntFn(OnBurnt)
    inst.components.burnable:SetOnIgniteFn(OnIgnite)
    inst.components.burnable:SetOnExtinguishFn(OnExtinguish)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("piratepack", fn, assets, prefabs)