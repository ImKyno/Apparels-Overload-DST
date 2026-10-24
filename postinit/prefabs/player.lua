local _G = GLOBAL

-- Spectoggles Warnings, this should apply to all wagstaff goggles.
local function OnResetGogglesWarnings(inst)
    for _, warning in pairs(inst.active_goggles_warnings) do
        if warning:IsValid() then
            warning:Remove()
        end
    end

    inst.active_goggles_warnings = {}
end

local function OnUpdateGogglesWarnings(inst)
    local disable = inst.replica.inventory ~= nil and not inst.replica.inventory:IsVisible()

    if not disable and inst.replica.inventory ~= nil and inst.replica.inventory:EquipHasTag("goggles_wagstaff") then
        local old_warnings = {}

        for danger, warning in pairs(inst.active_goggles_warnings) do
            old_warnings[danger] = warning
        end

        local x, y, z = inst.Transform:GetWorldPosition()

        local CANT_TAGS = TUNING.APO_HATS.WAGSTAFF_GOGGLES.DANGER.CANT_TAGS
        local MUST_TAGS = TUNING.APO_HATS.WAGSTAFF_GOGGLES.DANGER.MUST_TAGS
        local MUST_ONEOF_TAGS = TUNING.APO_HATS.WAGSTAFF_GOGGLES.DANGER.MUST_ONEOF_TAGS

        local dangers = _G.TheSim:FindEntities(x, y, z, 30, MUST_TAGS, CANT_TAGS, MUST_ONEOF_TAGS)

        for _, danger in ipairs(dangers) do
            if not _G.IsEntityDead(danger, true) then
                if inst.active_goggles_warnings[danger] == nil then
                    local fx = _G.SpawnPrefab("wagstaff_goggleshat_danger")

                    if fx ~= nil then
                        fx.entity:SetParent(danger.entity)
                        inst.active_goggles_warnings[danger] = fx
                    end
                else
                    old_warnings[danger] = nil
                end
            end
        end

        for danger, warning in pairs(old_warnings) do
            inst.active_goggles_warnings[danger] = nil

            if warning:IsValid() then
                _G.ErodeAway(warning, 0.5)
            end
        end
    elseif _G.next(inst.active_goggles_warnings) ~= nil then
        OnResetGogglesWarnings(inst)
    end
end

local function OnDisableGogglesWarnings(inst)
    if inst.goggles_warnings_task ~= nil then
        inst.goggles_warnings_task:Cancel()
        inst.goggles_warnings_task = nil
    end

    OnResetGogglesWarnings(inst)
end

local function OnEnableGogglesWarnings(inst)
    if inst.player_classified ~= nil then
        inst:ListenForEvent("playerdeactivated", OnDisableGogglesWarnings)

        if inst.goggles_warnings_task == nil then
            inst.goggles_warnings_task = inst:DoPeriodicTask(0.1, OnUpdateGogglesWarnings)
        end
    else
        inst:RemoveEventCallback("playeractivated", OnEnableGogglesWarnings)
    end
end

-- Infroggles Vision.
local function OnApplyHeatVision(ent)
    if ent == _G.TheWorld or ent:HasAnyTag("noheatvision") then
        return
    end

    if ent.AnimState ~= nil then
        local HEAT_MODE

        -- Should we include soulless tag in here?
        if not ent:HasAnyTag("shadow", "shadowcreature", "chess", "wagstaff_npc")
        and (ent:HasAnyTag("monster", "animal", "character", "smallcreature", "seacreature", "oceanfish", "hotblood")) then
            HEAT_MODE = TUNING.APO_MISC.HEATVISION.COLORS.HOT
        else
            HEAT_MODE = TUNING.APO_MISC.HEATVISION.COLORS.COLD
        end

        if HEAT_MODE.BLOOM then
            ent.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end

        ent.AnimState:SetMultColour(_G.unpack(HEAT_MODE.MULT_COLOUR))
        ent.AnimState:SetAddColour(_G.unpack(HEAT_MODE.ADD_COLOUR))
    end
end

local function OnUpdateHeatVision(inst)
    local disable = inst.replica.inventory ~= nil and not inst.replica.inventory:IsVisible()

    if not disable and inst.replica.inventory ~= nil and inst.replica.inventory:EquipHasTag("heatvision") then
        local x, y, z = inst.Transform:GetWorldPosition()
        local entities = _G.TheSim:FindEntities(x, y, z, 30)

        for _, ent in ipairs(entities) do
            OnApplyHeatVision(ent)
        end
    end
end

local function OnDisableHeatVision(inst)
    if inst.heatvision_task ~= nil then
        inst.heatvision_task:Cancel()
        inst.heatvision_task = nil
    end
end

local function OnEnableHeatVision(inst)
    if inst.player_classified ~= nil then
        inst:ListenForEvent("playerdeactivated", OnDisableHeatVision)

        if inst.heatvision_task == nil then
            inst.heatvision_task = inst:DoPeriodicTask(0.1, OnUpdateHeatVision)
        end
    else
        inst:RemoveEventCallback("playeractivated", OnEnableHeatVision)
    end
end

local function OnPlayerActivated(inst)
    _G.TheWorld:ListenForEvent("ccoverrides", function()
        inst:DoTaskInTime(0, function()
            if inst.components.playervision.heatvision or inst.components.playervision.forceheatvision then
                if _G.TheWorld.components.globalcolormodifier then
                    _G.TheWorld.components.globalcolormodifier:SetModifyColourFn(OnApplyHeatVision)
                end
            elseif inst.components.playervision.heatvision == false and inst.components.playervision.forceheatvision == false then
                if _G.TheWorld.components.globalcolormodifier then
                    _G.TheWorld.components.globalcolormodifier:Reset()
                end
            end
        end)
    end, inst)
end

local function OnHealthRegenActive(inst, data)
    if data ~= nil and data.active ~= nil then
        inst.healthregenactive:set(data.active)
    end
end

local function PlayerPostInit(inst)
    inst.AnimState:AddOverrideBuild("player_wagstaff_goggles")

    inst.damageovertimeactive = _G.net_bool(inst.GUID, "player.damageovertimeactive", "damageovertimeactive_dirty")

    inst.healthregenactive = _G.net_bool(inst.GUID, "healthregenactive")
    inst.healthregenactive:set(false)

    if not _G.TheNet:IsDedicated() then
        inst.active_goggles_warnings = {}

        inst:ListenForEvent("playeractivated", OnPlayerActivated)
        inst:ListenForEvent("playeractivated", OnEnableGogglesWarnings)
        inst:ListenForEvent("playeractivated", OnEnableHeatVision)
    end

    inst:ListenForEvent("healthregenactive", OnHealthRegenActive)
end

AddPlayerPostInit(PlayerPostInit)