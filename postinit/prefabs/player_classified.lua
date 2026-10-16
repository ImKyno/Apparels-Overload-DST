local _G = GLOBAL

-- Cowl Sounds
local function OnBatvisionOnEvent(inst)
    if inst._parent ~= nil and _G.TheFocalPoint.entity:GetParent() == inst._parent then
        _G.TheFocalPoint.SoundEmitter:PlaySound("apo_sounds/HUD/hat_bat/turn_on")
    end
end

local function OnBatvisionOffEvent(inst)
    if inst._parent ~= nil and _G.TheFocalPoint.entity:GetParent() == inst._parent then
        _G.TheFocalPoint.SoundEmitter:PlaySound("apo_sounds/HUD/hat_bat/turn_off")
    end
end

local function OnBatvisionOn(parent)
    parent.player_classified.batvisiononevent:push()
end

local function OnBatvisionOff(parent)
    parent.player_classified.batvisionoffevent:push()
end

-- Fryfocals /Infroggles Sounds
local function OnWagstaffGogglesOnEvent(inst)
    if inst._parent ~= nil and _G.TheFocalPoint.entity:GetParent() == inst._parent then
        _G.TheFocalPoint.SoundEmitter:PlaySound("apo_sounds/HUD/hat_wagstaff_goggles_heat/turn_on")
    end
end

local function OnWagstaffGogglesOffEvent(inst)
    if inst._parent ~= nil and _G.TheFocalPoint.entity:GetParent() == inst._parent then
        _G.TheFocalPoint.SoundEmitter:PlaySound("apo_sounds/HUD/hat_wagstaff_goggles_heat/turn_off")
    end
end

local function OnWagstaffGogglesOn(parent)
    parent.player_classified.wagstaffgogglesonevent:push()
end

local function OnWagstaffGogglesOff(parent)
    parent.player_classified.wagstaffgogglesoffevent:push()
end

-- Visor Sounds
local function OnWagstaffGogglesArmorOnEvent(inst)
    if inst._parent ~= nil and _G.TheFocalPoint.entity:GetParent() == inst._parent then
        _G.TheFocalPoint.SoundEmitter:PlaySound("apo_sounds/HUD/hat_wagstaff_goggles_armor/visor_on")
    end
end

local function OnWagstaffGogglesArmorOffEvent(inst)
    if inst._parent ~= nil and _G.TheFocalPoint.entity:GetParent() == inst._parent then
        _G.TheFocalPoint.SoundEmitter:PlaySound("apo_sounds/HUD/hat_wagstaff_goggles_armor/visor_off")
    end
end

local function OnWagstaffGogglesArmorOn(parent)
    parent.player_classified.wagstaffgogglesarmoronevent:push()
end

local function OnWagstaffGogglesArmorOff(parent)
    parent.player_classified.wagstaffgogglesarmoroffevent:push()
end

local function OnRegisterNetListeners(inst)
    if _G.TheWorld.ismastersim then
        inst:ListenForEvent("batvision_on", OnBatvisionOn, inst.entity:GetParent())
        inst:ListenForEvent("batvision_off", OnBatvisionOff, inst.entity:GetParent())

        inst:ListenForEvent("wagstaff_goggles_on", OnWagstaffGogglesOn, inst.entity:GetParent())
        inst:ListenForEvent("wagstaff_goggles_off", OnWagstaffGogglesOff, inst.entity:GetParent())

        inst:ListenForEvent("wagstaff_goggles_armor_on", OnWagstaffGogglesArmorOn, inst.entity:GetParent())
        inst:ListenForEvent("wagstaff_goggles_armor_off", OnWagstaffGogglesArmorOff, inst.entity:GetParent())
    end

    inst:ListenForEvent("event.batvision_on", OnBatvisionOnEvent)
    inst:ListenForEvent("event.batvision_off", OnBatvisionOffEvent)

    inst:ListenForEvent("event.wagstaff_goggles_on", OnWagstaffGogglesOnEvent)
    inst:ListenForEvent("event.wagstaff_goggles_off", OnWagstaffGogglesOffEvent)

    inst:ListenForEvent("event.wagstaff_goggles_armor_on", OnWagstaffGogglesArmorOnEvent)
    inst:ListenForEvent("event.wagstaff_goggles_armor_off", OnWagstaffGogglesArmorOffEvent)
end

local function PlayerClassifiedPostInit(inst)
    inst.isbrainjellyhat = _G.net_bool(inst.GUID, "builder.brainjellyhat", "recipesdirty")
    inst.isbrainjellyhat:set(false)

    inst.batvisiononevent = _G.net_event(inst.GUID, "event.batvision_on")
    inst.batvisionoffevent = _G.net_event(inst.GUID, "event.batvision_off")

    inst.wagstaffgogglesonevent = _G.net_event(inst.GUID, "event.wagstaff_goggles_on")
    inst.wagstaffgogglesoffevent = _G.net_event(inst.GUID, "event.wagstaff_goggles_off")

    inst.wagstaffgogglesarmoronevent = _G.net_event(inst.GUID, "event.wagstaff_goggles_armor_on")
    inst.wagstaffgogglesarmoroffevent = _G.net_event(inst.GUID, "event.wagstaff_goggles_armor_off")

    inst:DoStaticTaskInTime(0, OnRegisterNetListeners)
end

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    AddPrefabPostInit("player_classified", PlayerClassifiedPostInit)
end