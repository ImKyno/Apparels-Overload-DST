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
end)