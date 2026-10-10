local assets =
{
    Asset("ANIM", "anim/armor_vortex.zip"),
    Asset("ANIM", "anim/armor_vortex_fx.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("IMAGE", "images/minimapimages/apo_minimapimages.tex"),
    Asset("ATLAS", "images/minimapimages/apo_minimapimages.xml"),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

local prefabs =
{
    "armor_vortex_fx",
}

local SHIELD_DURATION = 10 * FRAMES
local SHIELD_VARIATIONS = 3
local MAIN_SHIELD_CD = 1.2

local RESISTANCES = { "_combat", "caveindebris", "darkness", "explosive", "quakedebris", "trapdamage" }

for j = 0, 3, 3 do
    for i = 1, SHIELD_VARIATIONS do
        table.insert(prefabs, "shadow_shield"..tostring(j + i))
    end
end

local function OnPickShield(inst)
    local t = GetTime()
    local flipoffset = math.random() < .5 and SHIELD_VARIATIONS or 0

    local dt = t - inst.lastmainshield

    if dt >= MAIN_SHIELD_CD then
        inst.lastmainshield = t
        return flipoffset + 3
    end

    local rnd = math.random()

    if rnd < dt / MAIN_SHIELD_CD then
        inst.lastmainshield = t
        return flipoffset + 3
    end

    return flipoffset + (rnd < dt / (MAIN_SHIELD_CD * 2) + .5 and 2 or 1)
end

local function OnShieldOver(inst, OnResistDamage)
    inst.task = nil

    for i, v in ipairs(RESISTANCES) do
        if inst.components.resistance ~= nil then
            inst.components.resistance:RemoveResistance(v)
        end
    end

    if inst.components.resistance ~= nil then
        inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
    end
end

local function OnResistDamage(inst, damage_amount, attacker)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem:GetGrandOwner() or inst

    local fx = SpawnPrefab("shadow_shield"..tostring(OnPickShield(inst)))
    fx.entity:SetParent(owner.entity)

    if inst.task ~= nil then
        inst.task:Cancel()
    end

    inst.task = inst:DoTaskInTime(SHIELD_DURATION, OnShieldOver, OnResistDamage)

    if inst.components.resistance ~= nil then
        inst.components.resistance:SetOnResistDamageFn(nil)
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:DoDelta(-TUNING.APO_ARMOR_VORTEX.FUEL_RATE)
    end

    if inst.components.cooldown.onchargedfn ~= nil then
        inst.components.cooldown:StartCharging()
    end

    if owner ~= nil and owner.components.sanity ~= nil and damage_amount ~= nil and damage_amount > 0 then
        owner.components.sanity:DoDelta(-damage_amount * TUNING.APO_ARMOR_VORTEX.SANITY)
    end
end

local function OnShouldResist(inst)
    if inst.components.equippable ~= nil and not inst.components.equippable:IsEquipped() then
        return false
    end

    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner
    return owner ~= nil and not (owner.components.inventory ~= nil and owner.components.inventory:EquipHasTag("forcefield"))
end

local function OnCharged(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil

        if inst.components.resistance ~= nil then
            inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
        end
    end

    for i, v in ipairs(RESISTANCES) do
        if inst.components.resistance ~= nil then
            inst.components.resistance:AddResistance(v)
        end
    end
end

local function OnDepleted(inst)
    if inst.components.cooldown ~= nil then
        inst.components.cooldown.onchargedfn = nil
        inst.components.cooldown:FinishCharging()
    end
end

local function CLIENT_PlayFuelSound(inst)
    local parent = inst.entity:GetParent()
    local container = parent ~= nil and (parent.replica.inventory or parent.replica.container) or nil

    if container ~= nil and container:IsOpenedBy(ThePlayer) then
        TheFocalPoint.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    end
end

local function SERVER_PlayFuelSound(inst)
    local owner = inst.components.inventoryitem.owner

    if owner == nil then
        inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    elseif inst.components.equippable ~=nil and inst.components.equippable:IsEquipped() and owner.SoundEmitter ~= nil then
        owner.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    else
        inst.playfuelsound:push()

        if not TheNet:IsDedicated() then
            CLIENT_PlayFuelSound(inst)
        end
    end
end

local function OnTakeFuel(inst)
    if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped()
    and inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty()
    and inst.components.cooldown ~= nil and inst.components.cooldown.onchargedfn == nil then
        inst.components.cooldown.onchargedfn = OnCharged
        inst.components.cooldown:StartCharging(TUNING.APO_ARMOR_VORTEX.COOLDOWN.INITIAL)
    end

    SERVER_PlayFuelSound(inst)
end

local function OnSetSoundParam(inst)
    local param = Remap(inst.components.armor.condition, 0, inst.components.armor.maxcondition, 0, 1)

    inst.SoundEmitter:SetParameter("vortex", "intensity", param)
end

local function OnSpawnWisp(inst, owner)
    local wisp = SpawnPrefab("armor_vortex_fx")

    wisp.entity:SetParent(owner.entity)
    wisp.Transform:SetPosition(math.random() * 0.5 - 0.25, 0, math.random() * 0.5 - 0.25)

    wisp._vortex = inst
    wisp._owner = owner

    return wisp
end

local function OnSpawnWisps(inst, owner)
    inst.wisps = {}

    for i = 1, 5 do
        local wisp = OnSpawnWisp(inst, owner)
        table.insert(inst.wisps, wisp)
    end
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        owner.AnimState:OverrideSymbol("swap_body", "armor_vortex", "swap_body")

        inst.lastmainshield = 0

        if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
            if inst.components.cooldown ~= nil then
                inst.components.cooldown.onchargedfn = OnCharged
                inst.components.cooldown:StartCharging(math.max(TUNING.APO_ARMOR_VORTEX.COOLDOWN.INITIAL,
                inst.components.cooldown:GetTimeToCharged()))
            end
        end

        if inst.components.container ~= nil then
            inst.components.container:Open(owner)
        end

        if owner:HasTag("player") then
            OnSpawnWisps(inst, owner)
        end

        inst.SoundEmitter:PlaySound("apo_sounds/common/armor_vortex/turn_on")
    end
end

local function OnUnequip(inst, owner)
    if owner ~= nil then
        owner.AnimState:ClearOverrideSymbol("swap_body")

        if inst.components.cooldown ~= nil then
            inst.components.cooldown.onchargedfn = nil
        end

        if inst.components.container ~= nil then
            inst.components.container:Close()
        end

        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil

            if inst.components.resistance ~= nil then
                inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
            end
        end

        for i, v in ipairs(RESISTANCES) do
            if inst.components.resistance ~= nil then
                inst.components.resistance:RemoveResistance(v)
            end
        end

        if inst.wisps ~= nil then
            for _, wisp in ipairs(inst.wisps) do
                if wisp ~= nil and wisp:IsValid() then
                    wisp:Remove()
                end
            end

            inst.wisps = nil
        end

        inst.SoundEmitter:PlaySound("apo_sounds/common/armor_vortex/turn_off")
    end
end

local function OnEquipToModel(inst, owner, from_ground)
    if inst.components.cooldown ~= nil then
        inst.components.cooldown.onchargedfn = nil
    end

    if inst.components.container ~= nil then
        inst.components.container:Close()
    end

    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil

        if inst.components.resistance ~= nil then
            inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
        end
    end

    if inst.wisps ~= nil then
        for _, wisp in ipairs(inst.wisps) do
            if wisp ~= nil and wisp:IsValid() then
                wisp:Remove()
            end
        end

        inst.wisps = nil
    end

    for i, v in ipairs(RESISTANCES) do
        if inst.components.resistance ~= nil then
            inst.components.resistance:RemoveResistance(v)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("armor_vortex.tex")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.AnimState:SetBank("armor_vortex")
    inst.AnimState:SetBuild("armor_vortex")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("backpack")
    inst:AddTag("shadowlevel")
    inst:AddTag("shadow_item")
    inst:AddTag("waterproofer")

    inst.foleysound = "dontstarve/movement/foley/shadowcloth_armour"

    inst.playfuelsound = net_event(inst.GUID, "armor_vortex.playfuelsound")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("krampus_sack")
        end

        inst:DoTaskInTime(0, inst.ListenForEvent, "armor_vortex.playfuelsound", CLIENT_PlayFuelSound)

        return inst
    end

    inst.task = nil
    inst.lastmainshield = 0

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    inst:AddComponent("resistance")
    inst.components.resistance:SetShouldResistFn(OnShouldResist)
    inst.components.resistance:SetOnResistDamageFn(OnResistDamage)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:InitializeFuelLevel(TUNING.APO_ARMOR_VORTEX.FUEL)
    inst.components.fueled:SetDepletedFn(OnDepleted)
    inst.components.fueled:SetTakeFuelFn(OnTakeFuel)
    inst.components.fueled.accepting = true

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("krampus_sack")

    inst:AddComponent("cooldown")
    inst.components.cooldown.cooldown_duration = TUNING.APO_ARMOR_VORTEX.COOLDOWN.NORMAL

    inst:AddComponent("shadowlevel")
    inst.components.shadowlevel:SetDefaultLevel(TUNING.APO_ARMOR_VORTEX.SHADOWLEVEL)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("armor_vortex_fx")
    inst.AnimState:SetBuild("armor_vortex_fx")
    inst.AnimState:PlayAnimation("idle", true)

    for i = 1, 14 do
        inst.AnimState:Hide("fx"..i)
    end

    inst.AnimState:Show("fx"..math.random(1, 14))

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", function(inst)
        local cloak = inst._vortex
        local owner = inst._owner

        if cloak ~= nil and cloak.wisps ~= nil then
            for i, wisp in ipairs(cloak.wisps) do
                if wisp == inst then
                    table.remove(cloak.wisps, i)
                    break
                end
            end
        end

        inst:Remove()

        if cloak ~= nil and cloak:IsValid() and owner ~= nil and owner:IsValid()
        and cloak.components.equippable ~= nil and cloak.components.equippable:IsEquipped() then
            local new_wisp = OnSpawnWisp(cloak, owner)
            table.insert(cloak.wisps, new_wisp)
        end
    end)

    return inst
end

return Prefab("armor_vortex", fn, assets, prefabs),
Prefab("armor_vortex_fx", fxfn, assets)