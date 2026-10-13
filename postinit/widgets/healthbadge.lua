local _G = GLOBAL

AddClassPostConstruct("widgets/healthbadge", function(self)
    local _OnUpdate = self.OnUpdate

    function self:OnUpdate(dt, ...)
        local owner = self.owner

        local has_overtime_damage = owner ~= nil and owner.damageovertimeactive ~= nil and owner.damageovertimeactive:value()

        if has_overtime_damage then
            local anim = "arrow_loop_decrease"

            if self.arrowdir ~= anim then
                self.arrowdir = anim
                self.sanityarrow:GetAnimState():PlayAnimation(anim, true)
            end

            return
        end

        if _OnUpdate ~= nil then
            return _OnUpdate(self, dt, ...)
        end
    end
end)