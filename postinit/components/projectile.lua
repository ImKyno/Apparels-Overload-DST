local _G = GLOBAL

AddComponentPostInit("projectile", function(self)
    local _Throw = self.Throw

    function self:Throw(owner, target, attacker, ...)
        if self.inst.prefab == "wagstaff_goggles_shoothat_projectile" then
            local isriding = attacker ~= nil and attacker.components.rider ~= nil and attacker.components.rider:IsRiding()

            local x = 2
            local y = isriding and 3 or 1

            self:SetLaunchOffset(_G.Vector3(x, y, 0))
            self:SetHitDist(math.sqrt(x * x + y * y))
        end

        return _Throw(self, owner, target, attacker, ...)
    end
end)