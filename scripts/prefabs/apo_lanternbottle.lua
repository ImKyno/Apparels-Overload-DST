local assets =
{
    Asset("ANIM", "anim/lanternbottle.zip"),
    Asset("ANIM", "anim/swap_lanternbottle.zip"),

    Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),

    Asset("SOUNDPACKAGE", "sound/apo_sounds.fev"),
    Asset("SOUND", "sound/apo_sfx.fsb"),
}

local prefabs =
{
    "lanternbottle_light",
}

local function OnTurnOffSound(inst, owner)
    inst.lanternbottle_soundtask = nil

    (owner ~= nil and owner:IsValid()
    and owner.SoundEmitter or inst.SoundEmitter):PlaySound("apo_sounds/common/lanternbottle/turn_off")
end

local function OnPlayTurnOffSound(inst)
    if inst.lanternbottle_soundtask == nil and inst:GetTimeAlive() > 0 then
        inst.lanternbottle_soundtask = inst:DoTaskInTime(0, OnTurnOffSound, inst.components.inventoryitem.owner)
    end
end

local function OnPlayTurnOnSound(inst)
    if inst.lanternbottle_soundtask ~= nil then
        inst.lanternbottle_soundtask:Cancel()
        inst.lanternbottle_soundtask = nil
    elseif not POPULATING then
        inst.lanternbottle_light.SoundEmitter:PlaySound("apo_sounds/common/lanternbottle/turn_on")
    end
end

local function OnFuelUpdate(inst)
    if inst.lanternbottle_light ~= nil then
        if inst.components.fueled ~= nil then
            local percent = inst.components.fueled:GetPercent()

            inst.lanternbottle_light.Light:SetIntensity(Lerp(0.4, 0.65, percent))
            inst.lanternbottle_light.Light:SetRadius(Lerp(3, 5, percent))
            inst.lanternbottle_light.Light:SetFalloff(.9)
        end
    end
end

local function OnRemoveLight(light)
    light.lanternbottle.lanternbottle_light = nil
end

local function OnStopTrackingOwner(inst)
    if inst.lanternbottle_owner ~= nil then
        inst:RemoveEventCallback("equip", inst.lanternbottle_onownerequip, inst.lanternbottle_owner)
        inst.lanternbottle_owner = nil
    end
end

local function OnStartTrackingOwner(inst, owner)
    if owner ~= inst.lanternbottle_owner then
        OnStopTrackingOwner(inst)

        if owner ~= nil and owner.components.inventory ~= nil then
            inst.lanternbottle_owner = owner

            inst:ListenForEvent("equip", inst.lanternbottle_onownerequip, owner)
        end
    end
end

local function OnTurnOn(inst)
    if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
        inst.components.fueled:StartConsuming()

        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner

        if inst.lanternbottle_light == nil then
            inst.lanternbottle_light = SpawnPrefab("lanternbottle_light")
            inst.lanternbottle_light.lanternbottle = inst

            inst:ListenForEvent("onremove", OnRemoveLight, inst.lanternbottle_light)

            OnFuelUpdate(inst)
            OnPlayTurnOnSound(inst)
        end

        inst.lanternbottle_light.entity:SetParent((owner or inst).entity)

        inst.AnimState:PlayAnimation("idle_on")

        if owner ~= nil then
            if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
                owner.AnimState:Show("LANTERN_OVERLAY")
            end
        end

        if inst.components.machine ~= nil then
            inst.components.machine.ison = true
        end

        if inst.components.inventoryitem ~= nil then
            local invon = inst.components.inventoryitem:ChangeImageName((inst:GetSkinName() or "lanternbottle").."_lit")
            print("BOTTLE ON", invon)
        end

        inst:PushEvent("lantern_on")
    end
end

local function OnTurnOff(inst)
    OnStopTrackingOwner(inst)

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end

    if inst.lanternbottle_light ~= nil then
        inst.lanternbottle_light:Remove()

        OnPlayTurnOffSound(inst)
    end

    inst.AnimState:PlayAnimation("idle_off")

    if inst.components.equippable ~= nil and inst.components.inventoryitem ~= nil then
        if inst.components.equippable:IsEquipped() then
            inst.components.inventoryitem.owner.AnimState:Hide("LANTERN_OVERLAY")
        end
    end

    if inst.components.machine ~= nil then
        inst.components.machine.ison = false
    end

    if inst.components.inventoryitem ~= nil then
        local invoff = inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
        print("BOTTLE OFF", invoff)
    end

    inst:PushEvent("lantern_off")
end

local function OnRemove(inst)
    if inst.lanternbottle_light ~= nil then
        inst.lanternbottle_light:Remove()
    end

    if inst.lanternbottle_soundtask ~= nil then
        inst.lanternbottle_soundtask:Cancel()
    end
end

local function OnDropped(inst)
    OnTurnOff(inst)
    OnTurnOn(inst)
end

local function OnEquip(inst, owner)
    if owner ~= nil then
        local skin_build = inst:GetSkinBuild()

        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_lanternbottle", inst.GUID, "swap_lanternbottle")
            owner.AnimState:OverrideItemSkinSymbol("lantern_overlay", skin_build, "lantern_overlay", inst.GUID, "swap_lanternbottle")
        else
            owner.AnimState:OverrideSymbol("swap_object", "swap_lanternbottle", "swap_lanternbottle")
            owner.AnimState:OverrideSymbol("lantern_overlay", "swap_lanternbottle", "lantern_overlay")
        end

        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

        if inst.components.fueled ~= nil then
            if inst.components.fueled:IsEmpty() then
                owner.AnimState:Hide("LANTERN_OVERLAY")
            else
                owner.AnimState:Show("LANTERN_OVERLAY")
                OnTurnOn(inst)
            end
        end
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

        owner.AnimState:ClearOverrideSymbol("lantern_overlay")

        owner.AnimState:Hide("LANTERN_OVERLAY")

        if inst.components.machine ~= nil and inst.components.machine.ison then
            OnStartTrackingOwner(inst, owner)
        end
    end
end

local function OnEquipToModel(inst, owner, from_ground)
    if owner ~= nil then
        if inst.components.machine ~= nil and inst.components.machine.ison then
            OnStartTrackingOwner(inst, owner)
        end
    end

    OnTurnOff(inst)
end

local function OnDepleted(inst)
    if inst.components.equippable ~= nil and inst.components.inventoryitem ~= nil then
        if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
            local data = { prefab = inst.prefab, equipslot = inst.components.equippable.equipslot }

            OnTurnOff(inst)

            inst.components.inventoryitem.owner:PushEvent("torchranout", data)
        else
            OnTurnOff(inst)
        end
    end
end

local function OnTakeFuel(inst)
    if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
        OnTurnOn(inst)
    end
end

local function OnEntityWake(inst)
    if not inst.SoundEmitter:PlayingSound("loop") then
        inst.SoundEmitter:PlaySound("apo_sounds/common/lanternbottle/loop", "loop")
    end
end

local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("loop")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", 0.2, 0.65)

    inst.AnimState:SetBank("lanternbottle")
    inst.AnimState:SetBuild("lanternbottle")
    inst.AnimState:PlayAnimation("idle_off")

    inst:AddTag("light")
    inst:AddTag("lanternbottle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sounds = sounds
    inst.lanternbottle_light = nil

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnTurnOff)

    inst:AddComponent("machine")
    inst.components.machine.turnonfn = OnTurnOn
    inst.components.machine.turnofffn = OnTurnOff
    inst.components.machine.cooldowntime = 0

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.CAVE
    inst.components.fueled.secondaryfueltype = FUELTYPE.MOONBUTTERFLY
    inst.components.fueled:InitializeFuelLevel(TUNING.APO_LANTERNBOTTLE.PERISHTIME)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled:SetUpdateFn(OnFuelUpdate)
    inst.components.fueled:SetDepletedFn(OnDepleted)
    inst.components.fueled:SetTakeFuelFn(OnTakeFuel)
    inst.components.fueled.accepting = true

    inst.lanternbottle_onownerequip = function(owner, data)
        if data.item ~= inst and (data.eslot == EQUIPSLOTS.HANDS
        or (data.eslot == EQUIPSLOTS.BODY and data.item:HasTag("heavy"))) then
            OnTurnOff(inst)
        end
    end

    inst.OnRemoveEntity = OnRemove

    MakeHauntableLaunch(inst)

    return inst
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Light:SetColour(0/255, 180/255, 255/255)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.OnEntityWake = OnEntityWake
    inst.OnEntitySleep = OnEntitySleep

    return inst
end

return Prefab("lanternbottle", fn, assets, prefabs),
Prefab("lanternbottle_light", lightfn)