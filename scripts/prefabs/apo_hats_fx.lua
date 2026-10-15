local assets =
{
    Asset("ANIM", "anim/hat_propeller_fan.zip"),
}

-- Propeller Hat FXs.
local function OnAlignToTarget(inst, target)
    inst.Transform:SetRotation(target.Transform:GetRotation())
end

local function OnToggleSpin(inst, spin)
    if spin then
        if not inst.toggle_spin then
            inst.toggle_spin = true
            inst.AnimState:PushAnimation("idle_on", true)

            inst.SoundEmitter:PlaySound("dontstarve/common/fan_twirl_LP", "twirl")
        end
    elseif inst.toggle_spin then
        inst.toggle_spin = false
        inst.AnimState:PushAnimation("idle_off", true)

        inst.SoundEmitter:KillSound("twirl")
    end
end

local function CreateFanWheelFX(proxy)
    local parent = proxy.entity:GetParent()

    if parent == nil then
        return
    end

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddFollower()

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("hat_propeller_fan")
    inst.AnimState:SetBuild("hat_propeller_fan")
    inst.AnimState:PlayAnimation("idle_off", true)
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("FX")

    inst.persists = false

    inst.entity:SetParent(parent.entity)
    inst.Follower:FollowSymbol(parent.GUID, "swap_hat", 0, -80, 0, true)

    inst:DoPeriodicTask(0, OnAlignToTarget, nil, parent)

    OnAlignToTarget(inst, parent)

    inst.toggle_spin = false

    inst:ListenForEvent("isspinningdirty", function()
        OnToggleSpin(inst, proxy.isspinning:value())
    end, proxy)

    OnToggleSpin(inst, proxy.isspinning:value())

    inst:ListenForEvent("onremove", function()
        inst:Remove()
    end, proxy)
end

local function OnSetSpinning(inst, isspinning)
    inst.isspinning:set(isspinning)
end

local function OnTransferToStateMem(inst, sg)
    if sg.statemem.followfx == nil then
        sg.statemem.followfx = { inst }
    else
        table.insert(sg.statemem.followfx, inst)
    end
end

local function OnDelayRemove(inst)
    inst.timeout = inst:DoTaskInTime(0, inst.Remove)
end

local function OnStartUnequipping(inst, item)
    local parent = inst.entity:GetParent()

    if parent == nil or item.components.inventoryitem == nil or item.components.inventoryitem.owner ~= parent then
        inst:Remove()

        return
    end

    inst:ListenForEvent("ondropped", function()
        inst:Remove()
    end, item)

    if parent.sg then
        if parent.sg.currentstate.name ~= "item_in" then
            inst.timeout = inst:DoTaskInTime(0, OnDelayRemove)

            inst:ListenForEvent("newstate", function(parent, data)
                if data.statename ~= "item_in" then
                    inst:Remove()
                else
                    inst.timeout:Cancel()

                    OnTransferToStateMem(inst, parent.sg)
                end
            end, parent)
        else
            OnTransferToStateMem(inst, parent.sg)
        end
    else
        inst.timeout = inst:DoTaskInTime(0, OnDelayRemove)
    end
end

local function propellerhat_fanfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, CreateFanWheelFX)
    end

    inst:AddTag("FX")

    inst.isspinning = net_bool(inst.GUID, "propellerhat_fan.isspinning", "isspinningdirty")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnSetSpinning = OnSetSpinning
    inst.OnStartUnequipping = OnStartUnequipping

    inst.persists = false

    return inst
end

-- Thunder Hat FXs.
local function thunderhat_lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(.75)
    inst.Light:SetIntensity(.9)
    inst.Light:SetColour(235/255, 121/255, 12/255)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

-- Chilled Volcano FXs.
local function volcanocoldhat_lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(.75)
    inst.Light:SetIntensity(.9)
    inst.Light:SetColour(100/255, 190/255, 255/255)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

-- Mini Volcano FXs.
local function volcanohat_lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(.75)
    inst.Light:SetIntensity(.9)
    inst.Light:SetColour(232/255, 141/255, 67/255)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("propellerhat_fan", propellerhat_fanfn, assets),
Prefab("thunderhat_light", thunderhat_lightfn),
Prefab("volcanocoldhat_light", volcanocoldhat_lightfn),
Prefab("volcanohat_light", volcanohat_lightfn)