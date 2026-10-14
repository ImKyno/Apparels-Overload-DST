local _G = GLOBAL

local function LightningStrikeAttackPostInit()
    local _LightningStrikeAttack = _G.LightningStrikeAttack

    _G.LightningStrikeAttack = function(inst, ...)
        if inst ~= nil then
            local hat = inst.components.inventory ~= nil
            and inst.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD) or nil

            if hat ~= nil and hat:HasTag("lightningcatcher") then
                inst:PushEventImmediate("electrocute")

                return true
            end
        end

        return _LightningStrikeAttack(inst, ...)
    end
end

AddSimPostInit(LightningStrikeAttackPostInit)