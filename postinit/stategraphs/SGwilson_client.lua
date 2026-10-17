local _G = GLOBAL

AddStategraphPostInit("wilson_client", function(inst)
    local _attackhandler = inst.actionhandlers[_G.ACTIONS.ATTACK].deststate

    inst.actionhandlers[_G.ACTIONS.ATTACK].deststate = function(inst, action, ...)
        if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget
        or inst.replica.health ~= nil and inst.replica.health:IsDead()) then
            local equip = inst.replica.inventory ~= nil and inst.replica.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD)

            if equip and equip:HasTag("gogglesshoot") then
                return "wagstaff_goggles_attack"
            end
        end

        return _attackhandler(inst, action, ...)
    end
end)