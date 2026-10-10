local _G = GLOBAL

-- If Odds and Ends is enabled, use their hook instead...
if not TUNING.APO_IS_OAE_ENABLED then
    if TUNING.APO_DEBUG_MODE then
        print("Apparels Overload Mod - Odds and Ends is not enabled!")
        print("Apparels Overload Mod - Using our temperature component hook!")
    end

    AddComponentPostInit("temperature", function(self)
        local _OnUpdate = self.OnUpdate

        self.OnUpdate = function(self, dt, applyhealthdelta, ...)
            local should_apply_damage = applyhealthdelta ~= false and self.settemp == nil and not self.inst.is_teleporting
            and self.inst.components.health ~= nil and not self.inst.components.health:IsInvincible()

            if _OnUpdate ~= nil then
                _OnUpdate(self, dt, false, ...)
            end

            if not should_apply_damage then
                return
            end

            if self.current < 0 then
                local damage = self.hurtrate * dt

                damage = _G.APOAbsorbTemperatureDamage(self.inst, damage, 1, "absorbsfreezing")

                if damage > 0 then
                    self.inst.components.health:DoDelta(-damage, true, "cold")
                end

                return
            end

            if self.current > self.overheattemp then
                local damage = (self.overheathurtrate or self.hurtrate) * dt

                damage = _G.APOAbsorbTemperatureDamage(self.inst, damage, 1, "absorbsoverheat")

                if damage > 0 then
                    self.inst.components.health:DoDelta(-damage, true, "hot")
                end
            end
        end
    end)
else
    if TUNING.APO_DEBUG_MODE then
        print("Apparels Overload Mod - Odds and Ends Mod is enabled!")
        print("Apparels Overload Mod - Using their temperature component hook!")
    end
end