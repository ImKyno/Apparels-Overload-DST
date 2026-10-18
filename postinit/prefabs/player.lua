local _G = GLOBAL

local function OnApplyHeatVision(ent)
    if ent == _G.TheWorld then
        return
    end

    if ent.AnimState ~= nil then
        local HEAT_MODE

        -- Should we include soulless tag in here?
        if not ent:HasAnyTag("shadow", "shadowcreature", "chess", "wagstaff_npc")
        and (ent:HasAnyTag("monster", "animal", "character", "smallcreature", "seacreature", "oceanfish")) then
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
        inst:ListenForEvent("playeractivated", OnPlayerActivated)
        inst:ListenForEvent("playeractivated", OnEnableHeatVision)
    end

    inst:ListenForEvent("healthregenactive", OnHealthRegenActive)
end

AddPlayerPostInit(PlayerPostInit)