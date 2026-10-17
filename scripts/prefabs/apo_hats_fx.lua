local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/wx78_taser_blast_fx.zip"),

    Asset("ANIM", "anim/hat_propeller_fan.zip"),
    Asset("ANIM", "anim/hat_wagstaff_goggles_shoot_projectile.zip"),

    Asset("SOUND", "sound/chess.fsb"),
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

-- Fryfocals FXs.
local FX_SCALE = 1.25
local RADIUS = 2.5 - 0.5
local PADDING = 3
local HIT_DURATION = 18 * FRAMES

local AOE_MUST_TAGS = { "_combat" }
local AOE_NO_TAGS = { "INLIMBO", "FX", "DECOR", "notarget", "noattack", "invisible", "flight", "wall", "companion", "player" }
local AOE_NO_TAGS_PVP = { "INLIMBO", "FX", "DECOR", "notarget", "noattack", "invisible", "flight", "playerghost" }

local function ShowBase(inst)
    local fx = CreateEntity()

    fx.entity:AddTransform()
    fx.entity:AddAnimState()

    fx.AnimState:SetBank("wx78_taser_blast_fx")
    fx.AnimState:SetBuild("wx78_taser_blast_fx")
    fx.AnimState:PlayAnimation("crackle_projection")

    fx.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    fx.AnimState:SetLightOverride(1)
    fx.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    fx.AnimState:SetLayer(LAYER_BACKGROUND)
    fx.AnimState:SetSortOrder(3)
    fx.AnimState:SetScale(FX_SCALE, FX_SCALE)

    fx:AddTag("FX")
    fx:AddTag("NOCLICK")

    fx.persists = false

    fx.entity:SetParent(inst.entity)

    fx:ListenForEvent("animover", fx.Remove)

    return fx
end

local function Base_PostUpdate_Client(fx)
    local parent = fx.entity:GetParent()

    if parent ~= nil then
        fx.AnimState:SetFrame(parent.AnimState:GetCurrentAnimationFrame())
    end

    fx:RemoveComponent("updatelooper")
end

local function ShowBase_Client(inst)
    local fx = ShowBase(inst)

    fx:AddComponent("updatelooper")
    fx.components.updatelooper:AddPostUpdateFn(Base_PostUpdate_Client)
end

local function CanHitTarget(inst, target)
    if target == nil or not target:IsValid() or target == inst.caster then
        return false
    end

    local combat = inst.caster ~= nil and inst.caster:IsValid() and inst.caster.components.combat or inst.components.combat

    if combat == nil then
        return false
    end

    if not target.entity:IsVisible() then
        return false
    end

    if not combat:CanTarget(target) then
        return false
    end

    return true
end

local function FindAOETargetsAtXZ(inst, x, z, radius, fn)
    local caster = inst.caster

    if caster == nil or not caster:IsValid() then
        return
    end

    local combat = caster.components.combat

    if combat == nil then
        return
    end

    local AOE_TARGET = combat.target
    local CANT_TAGS = TheNet:GetPVPEnabled() and AOE_NO_TAGS_PVP or AOE_NO_TAGS

    for _, v in ipairs(TheSim:FindEntities(x, 0, z, radius, AOE_MUST_TAGS, CANT_TAGS)) do
        if v ~= caster and v ~= inst and v.entity:IsVisible() and combat:CanTarget(v)
        and (v == AOE_TARGET or (v.components.combat ~= nil and v.components.combat:TargetIs(caster))
        or not v.components.combat:IsAlly(caster, v)) then
            fn(v, caster)
        end
    end
end

local function DoHit(inst, target, combat)
    if not CanHitTarget(inst, target) then
        return
    end

    if inst.targets[target] then
        return
    end

    local x, _, z = inst.Transform:GetWorldPosition()
    local range = RADIUS + target:GetPhysicsRadius(0)

    if target:GetDistanceSqToPoint(x, 0, z) >= range * range then
        return
    end

    inst.targets[target] = true

    local damage = inst.wagstaff_goggles_shoot_damage or TUNING.APO_HATS.WAGSTAFF_GOGGLES_SHOOT.DAMAGE
    local stimuli = inst.wagstaff_goggles_shoot_stimuli or "electric"
    local caster = combat.inst

    local oldproc = caster.wagstaff_goggles_shoot_proc
    local olddamage = combat.defaultdamage

    caster.wagstaff_goggles_shoot_proc = true

    if IsEntityElectricImmune(target) then
        combat:SetDefaultDamage(damage * TUNING.BISHOP_INSULATED_DAMAGE_MULT)
    else
        combat:SetDefaultDamage(damage)
    end

    combat:DoAttack(target, nil, nil, stimuli)
    combat:SetDefaultDamage(olddamage)

    caster.wagstaff_goggles_shoot_proc = oldproc

    target:PushEventImmediate("electrocute", { attacker = caster, stimuli = stimuli, numforks = 0 })
end

local function OnUpdate(inst, dt)
    if not inst._soundplayed then
        inst._soundplayed = true

        inst.SoundEmitter:PlaySound("dontstarve/creatures/bishop/shotexplo")
    end

    if dt > 0 then
        inst.fadet = inst.fadet + dt
        inst.fadeflicker = (inst.fadeflicker + 1) % 4
    end

    local light = easing.inQuad(inst.fadet, 0.4, -0.4, HIT_DURATION)

    inst.Light:SetIntensity(inst.fadeflicker < 2 and light or light * 0.65)

    local caster = inst.caster

    if caster == nil or not caster:IsValid() then
        return
    end

    local combat = caster.components.combat

    if combat == nil then
        return
    end

    combat.ignorehitrange = true

    local x, _, z = inst.Transform:GetWorldPosition()

    FindAOETargetsAtXZ(inst, x, z, RADIUS + PADDING, function(v)
        DoHit(inst, v, combat)
    end)

    combat.ignorehitrange = false
end

local function DisableHits(inst)
    if inst.components.updatelooper ~= nil then
        inst.components.updatelooper:RemoveOnUpdateFn(OnUpdate)
    end

    inst.Light:Enable(false)

    inst.targets = nil
end

local function KeepTargetFn(inst)
    return false
end

local function SetupCaster(inst, caster)
    inst.caster = caster

    inst:SetPrefabNameOverride(caster.prefab)

    if not inst._soundplayed then
        inst._soundplayed = true

        inst.SoundEmitter:PlaySound("dontstarve/creatures/bishop/shotexplo")
    end

    if inst.targets ~= nil then
        OnUpdate(inst, 0)
    end
end

local function wagstaff_goggles_shoothat_chargefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Light:SetRadius(0.5)
    inst.Light:SetIntensity(0.4)
    inst.Light:SetFalloff(0.625)
    inst.Light:SetColour(255/255, 255/255, 236/255)

    inst.AnimState:SetBuild("wx78_taser_blast_fx")
    inst.AnimState:SetBank("wx78_taser_blast_fx")
    inst.AnimState:PlayAnimation("crackle_hit")

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetScale(FX_SCALE, FX_SCALE)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("notarget")

    inst:AddComponent("updatelooper")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.components.updatelooper:AddPostUpdateFn(ShowBase_Client)

        return inst
    end

    if not TheNet:IsDedicated() then
        ShowBase(inst)
    end

    inst.components.updatelooper:AddOnUpdateFn(OnUpdate)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.APO_HATS.WAGSTAFF_GOGGLES_SHOOT.DAMAGE)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat.ignorehitrange = true

    inst.targets = {}

    inst.fadet = 0
    inst.fadeflicker = 0

    inst.wagstaff_goggles_shoot_damage = TUNING.APO_HATS.WAGSTAFF_GOGGLES_SHOOT.DAMAGE
    inst.wagstaff_goggles_shoot_stimuli = "electric"

    inst.SetupCaster = SetupCaster

    inst:DoTaskInTime(HIT_DURATION, DisableHits)
    inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + 2 * FRAMES, inst.Remove)

    inst.persists = false

    return inst
end

local function OnHitWagstaffGogglesShoot(inst, owner, target)
    if inst.onhitprocessed then
        return
    end

    inst.onhitprocessed = true

    inst.AnimState:PlayAnimation("impact")

    if inst.Physics ~= nil then
        inst.Physics:Stop()
    end

    if target ~= nil and owner ~= nil and not owner.wagstaff_goggles_shoot_proc then
        local x, y, z = target.Transform:GetWorldPosition()
        local charge = SpawnPrefab("wagstaff_goggles_shoothat_charge")

        if charge ~= nil then
            charge.Transform:SetPosition(x, y, z)

            charge.wagstaff_goggles_shoot_damage = inst.wagstaff_goggles_shoot_damage
            charge.wagstaff_goggles_shoot_stimuli = inst.wagstaff_goggles_shoot_stimuli

            charge:SetupCaster(owner)
        end
    end

    inst:ListenForEvent("animover", inst.Remove)
end

local function wagstaff_goggles_shoothat_projectilefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("hat_wagstaff_goggles_shoot_projectile")
    inst.AnimState:SetBuild("hat_wagstaff_goggles_shoot_projectile")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("projectile")

    inst.persists = false

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("projectile")
    inst.components.projectile:SetHoming(true)
    inst.components.projectile:SetSpeed(35)
    inst.components.projectile:SetHitDist(1.2)
    inst.components.projectile:SetOnHitFn(OnHitWagstaffGogglesShoot)
    inst.components.projectile:SetOnMissFn(OnHitWagstaffGogglesShoot)
    inst.components.projectile:SetLaunchOffset({ x = 1, y = 1, z = 0 })

    return inst
end

return Prefab("propellerhat_fan", propellerhat_fanfn, assets),
Prefab("thunderhat_light", thunderhat_lightfn),
Prefab("volcanocoldhat_light", volcanocoldhat_lightfn),
Prefab("volcanohat_light", volcanohat_lightfn),
Prefab("wagstaff_goggles_shoothat_charge", wagstaff_goggles_shoothat_chargefn, assets),
Prefab("wagstaff_goggles_shoothat_projectile", wagstaff_goggles_shoothat_projectilefn, assets)