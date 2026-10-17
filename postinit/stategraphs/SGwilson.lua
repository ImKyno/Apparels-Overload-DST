local _G = GLOBAL

AddStategraphPostInit("wilson", function(inst)
    local _attackhandler = inst.actionhandlers[_G.ACTIONS.ATTACK].deststate

    inst.actionhandlers[_G.ACTIONS.ATTACK].deststate = function(inst, action, ...)
        if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget
        or inst.components.health ~= nil and inst.components.health:IsDead()) then
            local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil

            if weapon and weapon:HasTag("gogglesshoot") then
                return "wagstaff_goggles_attack"
            end
        end

        return _attackhandler(inst, action, ...)
    end
end)