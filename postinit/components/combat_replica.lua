local _G            = GLOBAL
local require       = _G.require
local CombatReplica = require("components/combat_replica")

local _GetWeapon = CombatReplica.GetWeapon

function CombatReplica:GetWeapon(...)
    if self.inst.components.combat ~= nil then
        return self.inst.components.combat:GetWeapon()
    elseif self.inst.replica.inventory ~= nil then
        local hand_item = self.inst.replica.inventory:GetEquippedItem(_G.EQUIPSLOTS.HANDS)

        if hand_item ~= nil and hand_item:HasTag("weaponlowpriority") then
            local head_item = self.inst.replica.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD)

            if head_item ~= nil and head_item:HasTag("weapon") then
                if head_item:HasTag("projectile") or head_item:HasTag("rangedweapon") then
                    return head_item
                end

                local rider = self.inst.replica.rider

                if rider == nil or not rider:IsRiding() then
                    return head_item
                end
            end
        end

        local item = hand_item or self.inst.replica.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD)

        if item ~= nil and item:HasTag("weapon") then
            if item:HasTag("projectile") or item:HasTag("rangedweapon") then
                return item
            end

            local rider = self.inst.replica.rider

            return not (rider ~= nil and rider:IsRiding()) and item or nil
        end
    end
end