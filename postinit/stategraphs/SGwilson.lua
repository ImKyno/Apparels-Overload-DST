local _G      = GLOBAL
local ACTIONS = _G.ACTIONS
local require = _G.require

require("stategraphs/commonstates")

local function AttackSpeedStategraphPostInit(sg)
    local slots = { _G.EQUIPSLOTS.HANDS, _G.EQUIPSLOTS.BODY, _G.EQUIPSLOTS.HEAD }

    if TUNING.APO_IS_OAE_ENABLED then
        if TUNING.APO_DEBUG_MODE then
            print("Apparels Overload Mod - Odds and Ends is not enabled!")
            print("Apparels Overload Mod - Adding PLAYERACCESORY to AttackSpeedStategraphPostInit.")
        end

        table.insert(slots, _G.EQUIPSLOTS.PLAYERACCESSORY)
    end

    for _, statename in ipairs(TUNING.APO_MISC.STATEGRAPH_ATTACKS_WHITELIST) do
        local state = sg.states[statename]

        if state ~= nil and state.onenter ~= nil then
            local _onenter = state.onenter

            state.onenter = function(inst, ...)
                local item

                if inst.components.inventory ~= nil then
                    for _, slot in ipairs(slots) do
                        local equipped = inst.components.inventory:GetEquippedItem(slot)

                        if equipped ~= nil and equipped:HasTag("attackspeedsource") and equipped.attackspeedsource_mult ~= nil then
                            item = equipped
                            break
                        end
                    end
                end

                if item == nil then
                    return _onenter(inst, ...)
                end

                local mult = item.attackspeedsource_mult
                local _SetTimeout = inst.sg.SetTimeout

                inst.sg.SetTimeout = function(sgself, timeout)
                    _SetTimeout(sgself, timeout * mult)
                end

                _onenter(inst, ...)

                inst.sg.SetTimeout = _SetTimeout
            end
        end
    end
end

local function WagstaffGogglesShootStategraphPostInit(inst)
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
end

AddStategraphPostInit("wilson", AttackSpeedStategraphPostInit)
AddStategraphPostInit("wilson", WagstaffGogglesShootStategraphPostInit)