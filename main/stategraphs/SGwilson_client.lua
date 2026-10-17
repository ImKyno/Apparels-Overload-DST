local _G           = GLOBAL
local FRAMES       = _G.FRAMES
local State        = _G.State
local TimeEvent    = _G.TimeEvent
local EventHandler = _G.EventHandler

AddStategraphState("wilson_client",
    State{
        name = "wagstaff_goggles_attack",
        tags = { "attack", "notalking", "abouttoattack" },

        onenter = function(inst)
            local equip = inst.replica.inventory ~= nil and inst.replica.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD)
            or inst.replica.inventory:GetEquippedItem(_G.EQUIPSLOTS.HANDS)
            or inst.replica.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)

            if inst.components.locomotor ~= nil then
                inst.components.locomotor:Stop()
            end

            inst.AnimState:PlayAnimation("goggle_fast")

            if inst.sg.prevstate == inst.sg.currentstate then
                inst.sg.statemem.chained = true
                inst.AnimState:SetTime(5 * FRAMES)
            end

            inst.AnimState:PushAnimation("goggle_fast_pst", false)

            if inst.replica.combat ~= nil then
                inst.replica.combat:StartAttack()

                inst.sg:SetTimeout(math.max((inst.sg.statemem.chained and 14 or 18)
                * FRAMES, inst.replica.combat:MinAttackPeriod() + .5 * FRAMES))
            end

            local buffaction = inst:GetBufferedAction()

            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()

                if buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target:GetPosition())

                    inst.sg.statemem.attacktarget = buffaction.target
                end
            end

            if (equip.projectiledelay or 0) > 0 then
                inst.sg.statemem.projectiledelay = (inst.sg.statemem.chained and 9 or 14) * FRAMES - equip.projectiledelay

                if inst.sg.statemem.projectiledelay <= 0 then
                    inst.sg.statemem.projectiledelay = nil
                end
            end
        end,

        onupdate = function(inst, dt)
            if (inst.sg.statemem.projectiledelay or 0) > 0 then
                inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt

                if inst.sg.statemem.projectiledelay <= 0 then
                    inst:ClearBufferedAction()

                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst)
                if inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:ClearBufferedAction()

                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),

            TimeEvent(14 * FRAMES, function(inst)
                if not inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:ClearBufferedAction()

                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
                inst.replica.combat:CancelAttack()
            end
        end,
    }
)

AddStategraphState("wilson_client",
    State{
        name = "wagstaff_goggles_attack_pst",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("goggle_fast_pst")
        end,

        events=
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