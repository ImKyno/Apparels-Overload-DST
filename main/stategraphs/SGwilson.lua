local _G           = GLOBAL
local FRAMES       = _G.FRAMES
local State        = _G.State
local TimeEvent    = _G.TimeEvent
local EventHandler = _G.EventHandler

AddStategraphState("wilson",
    State{
        name = "wagstaff_goggles_attack",
        tags = { "attack", "notalking", "abouttoattack" },

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
            local equip = inst.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD)

            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.Transform:SetFourFaced()
            end

            if inst.components.combat ~= nil then
                inst.components.combat:SetTarget(target)
                inst.components.combat:StartAttack()
            end

            if inst.components.locomotor ~= nil then
                inst.components.locomotor:Stop()
            end

            inst.AnimState:PlayAnimation("goggle_fast")

            if inst.sg.prevstate == inst.sg.currentstate then
                inst.sg.statemem.chained = true
                inst.AnimState:SetTime(5 * FRAMES)
            end

            inst.AnimState:PushAnimation("goggle_fast_pst", false)

            if inst.components.combat ~= nil then
                inst.sg:SetTimeout(math.max((inst.sg.statemem.chained and 14 or 18)
                * FRAMES, inst.components.combat.min_attack_period + .5 * FRAMES))
            end

            if target ~= nil and target:IsValid() then
                inst:FacePoint(target.Transform:GetWorldPosition())
                inst.sg.statemem.attacktarget = target
            end

            if (equip ~= nil and equip.projectiledelay or 0) > 0 then
                inst.sg.statemem.projectiledelay = (inst.sg.statemem.chained and 9 or 14) * FRAMES - equip.projectiledelay

                if inst.sg.statemem.projectiledelay <= 0 then
                    inst.sg.statemem.projectiledelay = nil
                end
            end

            inst.SoundEmitter:PlaySound("apo_sounds/common/hat_wagstaff_goggles_shoot/use")
        end,

        onupdate = function(inst, dt)
            if (inst.sg.statemem.projectiledelay or 0) > 0 then
                inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt

                if inst.sg.statemem.projectiledelay <= 0 then
                    inst:PerformBufferedAction()

                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst)
                if inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:PerformBufferedAction()

                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),

            TimeEvent(14 * FRAMES, function(inst)
                if not inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:PerformBufferedAction()

                    inst.sg:RemoveStateTag("abouttoattack")

                    if inst.components.moisture ~= nil and inst.components.moisture:GetMoisture() > 0 then
                        if inst.components.combat ~= nil then
                            inst.components.combat:GetAttacked(nil, TUNING.APO_HATS.WAGSTAFF_GOGGLES_SHOOT.DAMAGE_MOISTURE, nil, "electric")
                        end
                    end
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("equip", function(inst)
                inst.sg:GoToState("idle")
            end),

            EventHandler("unequip", function(inst)
                inst.sg:GoToState("idle")
            end),

            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.combat ~= nil then
                inst.components.combat:SetTarget(nil)
            end

            if inst.sg:HasStateTag("abouttoattack") then
                if inst.components.combat ~= nil then
                    inst.components.combat:CancelAttack()
                end
            end

            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.Transform:SetSixFaced()
            end
        end,
    }
)

AddStategraphState("wilson",
    State{
        name = "wagstaff_goggles_attack_pst",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("goggle_fast_pst")
        end,

        events =
        {
            EventHandler("unequip", function(inst)
                inst.sg:GoToState("idle")
            end),

            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    }
)