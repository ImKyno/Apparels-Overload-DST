local _G = GLOBAL

AddComponentPostInit("combat", function(self)
    local _GetAttacked = self.GetAttacked

    function self:GetAttacked(...)
        local inst = self.inst
        local previous = inst._receiving_combat_damage

        inst._receiving_combat_damage = true

        local result = _GetAttacked(self, ...)

        inst._receiving_combat_damage = previous

        return result
    end

    --[[
    function self:GetAttacked(...)
        local inst = self.inst
        local previous = inst._receiving_combat_damage

        inst._receiving_combat_damage = true

        local result = { _G.pcall(_GetAttacked, self, ...) }

        inst._receiving_combat_damage = previous

        if not result[1] then
            _G.error(result[2])
        end

        return _G.unpack(result, 2)
    end
    ]]--

    local _GetWeapon = self.GetWeapon

    function self:GetWeapon(...)
        if self.inst.wagstaff_goggles_shoot_proc then
            return nil
        end

        if self.inst.components.inventory ~= nil then
            local hand_item = self.inst.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HANDS)

            -- Fryfocals should have higher priority over items with this tag.
            if hand_item ~= nil and hand_item:HasTag("weaponlowpriority") then
                local head_item = self.inst.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD)

                if head_item ~= nil and head_item.components.weapon ~= nil
                and (head_item.components.projectile ~= nil
                or not (self.inst.components.rider ~= nil and self.inst.components.rider:IsRiding())
                or head_item:HasTag("rangedweapon")) then
                    return head_item
                end
            end
        end

        local weapon = _GetWeapon(self, ...)

        if weapon ~= nil then
            return weapon
        end

        if self.inst.components.inventory ~= nil then
            local head_item = self.inst.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD)

            return head_item ~= nil and head_item.components.weapon ~= nil
            and (head_item.components.projectile ~= nil
            or not (self.inst.components.rider ~= nil and self.inst.components.rider:IsRiding())
            or head_item:HasTag("rangedweapon")) and head_item or nil
        end
    end
end)