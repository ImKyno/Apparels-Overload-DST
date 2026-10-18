local _G = GLOBAL

local function UpdateOvertimeDamageNetState(health)
    local inst = health.inst

    if inst.damageovertimeactive ~= nil then
        inst.damageovertimeactive:set(_G.next(health.overtime_damage_effects) ~= nil)
    end
end

local function ApplyOvertimeDamageTick(health, delta, cause, afflicter)
    local inst = health.inst

    if not inst:IsValid() or health:IsDead() then
        return false
    end

    local deltamodifierfn = health.deltamodifierfn
    local maxdamagetakenperhit = health.maxdamagetakenperhit
    local applying_overtime = inst._applying_damage_overtime
    local oldhealth = health.currenthealth

    health.deltamodifierfn = nil
    health.maxdamagetakenperhit = nil

    inst._applying_damage_overtime = true

    local success, result = _G.pcall(health.DoDelta, health, delta, true, cause, true, afflicter, true)

    health.deltamodifierfn = deltamodifierfn
    health.maxdamagetakenperhit = maxdamagetakenperhit

    inst._applying_damage_overtime = applying_overtime

    if not success then
        if TUNING.APO_DEBUG_MODE then
            print("Apparels Overload Mod - DamageOvertime: Error applying damage tick:", result)
        end

        return false
    end

    return not health:IsDead()
end

AddComponentPostInit("health", function(self)
    self.overtime_damage_sources = {}
    self.overtime_damage_effects = {}
    self.overtime_damage_next_id = 0

    function self:SetDamageOvertimeSource(source, enabled, duration, interval)
        if source == nil then
            return
        end

        if enabled then
            self.overtime_damage_sources[source] =
            {
                duration = duration or TUNING.APO_MISC.DAMAGEOVERTIME.DURATION,
                interval = interval or TUNING.APO_MISC.DAMAGEOVERTIME.INTERVAL,
            }
        else
            self.overtime_damage_sources[source] = nil
        end
    end

    function self:GetDamageOvertimeSource()
        for _, data in pairs(self.overtime_damage_sources) do
            return data
        end

        return nil
    end

    function self:DoDeltaOverTime(amount, duration, interval, cause, afflicter)
        if amount == 0 or duration == nil or duration <= 0 or interval == nil or interval <= 0 then
            return nil
        end

        -- This helper handles damage only. Damage is a negative delta.
        if amount > 0 then
            return nil
        end

        self.overtime_damage_next_id = self.overtime_damage_next_id + 1

        local id = self.overtime_damage_next_id
        local ticks = math.max(1, math.ceil(duration / interval))

        local effect =
        {
            remaining = amount,
            ticks     = ticks,
            elapsed   = 0,
            cause     = cause or "overtime_damage",
            afflicter = afflicter,
        }

        self.overtime_damage_effects[id] = effect
        UpdateOvertimeDamageNetState(self)

        local function OnTick()
            if self.overtime_damage_effects[id] ~= effect then
                return
            end

            if not self.inst:IsValid() or self:IsDead() then
                self.overtime_damage_effects[id] = nil
                UpdateOvertimeDamageNetState(self)

                return
            end

            effect.elapsed = effect.elapsed + 1

            -- Divide the remaining damage among the remaining ticks. The last tick applies the exact remainder.
            local delta

            if effect.elapsed >= effect.ticks then
                delta = effect.remaining
            else
                delta = effect.remaining / (effect.ticks - effect.elapsed + 1)
            end

            effect.remaining = effect.remaining - delta

            local alive = ApplyOvertimeDamageTick(self, delta, effect.cause, effect.afflicter)

            if effect.elapsed >= effect.ticks or not alive then
                self.overtime_damage_effects[id] = nil
                UpdateOvertimeDamageNetState(self)
            else
                effect.task = self.inst:DoTaskInTime(interval, OnTick)
            end
        end

        effect.task = self.inst:DoTaskInTime(interval, OnTick)

        return id
    end

    function self:CancelDeltaOverTime(id)
        local effect = self.overtime_damage_effects[id]

        if effect ~= nil then
            if effect.task ~= nil then
                effect.task:Cancel()
                effect.task = nil
            end

            self.overtime_damage_effects[id] = nil
            UpdateOvertimeDamageNetState(self)
        end
    end

    local _DoDelta = self.DoDelta

    function self:DoDelta(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
        local inst = self.inst
        local source = self:GetDamageOvertimeSource()

        -- Convert the final mitigated damage into sanity damage.
        local hat = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD) or nil
        local sanity = inst.components.sanity

        local convert_damage = amount < 0 and not overtime and inst._receiving_combat_damage
        and not inst._applying_damage_overtime and not self:IsDead()
        and hat ~= nil and hat:HasTag("damagetosanity") and sanity ~= nil

        if convert_damage then
            local old_percent = self:GetPercent()

            if old_percent <= self.nonlethal_pct and (((cause == "cold" or cause == "hot") and self.nonlethal_temperature)
            or (cause == "hunger" and self.nonlethal_hunger)) then
                return 0
            end

            if self.redirect ~= nil and self.redirect(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb) then
                return 0
            elseif not ignore_invincible and (self:IsInvincible() or inst.is_teleporting) then
                return 0
            end

            -- Apply the usual health damage reductions first.
            if not ignore_absorb then
                amount = amount* math.clamp(1 - (self.playerabsorb ~= 0 and afflicter ~= nil and afflicter:HasTag("player")
                and self.playerabsorb + self.absorb or self.absorb), 0, 1) * math.max(1 - self.externalabsorbmodifiers:Get(), 0)

                amount = afflicter ~= nil and math.min(0, amount + self.externalreductionmodifiers:Get()) or amount
            end

            if self.deltamodifierfn ~= nil then
                amount = self.deltamodifierfn(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
            end

            if self.maxdamagetakenperhit ~= nil and amount < self.maxdamagetakenperhit
            and not self._ignore_maxdamagetakenperhit then
                amount = self.maxdamagetakenperhit
            end

            if amount >= 0 then
                return _DoDelta(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
            end

            -- Convert incoming damage into sanity loss.
            local damage = -amount
            local sanity_damage = math.min(damage, math.max(0, sanity.current))

            if sanity_damage > 0 then
                sanity:DoDelta(-sanity_damage)
            end

            -- Any damage that sanity cannot absorb goes to health.
            local remaining_damage = damage - sanity_damage

            if remaining_damage <= 0 then
                return 0
            end

            local old_redirect = self.redirect
            local old_deltamodifierfn = self.deltamodifierfn
            local old_maxdamagetakenperhit = self.maxdamagetakenperhit

            self.redirect = nil
            self.deltamodifierfn = nil
            self.maxdamagetakenperhit = nil

            local result = _DoDelta(self, -remaining_damage, overtime, cause, true, afflicter, true, ...)

            self.redirect = old_redirect
            self.deltamodifierfn = old_deltamodifierfn
            self.maxdamagetakenperhit = old_maxdamagetakenperhit

            return result
        end

        -- Only intercept incoming combat damage.
        -- Normal healing, existing overtime damage and non-combat health changes use vanilla logic.
        if amount >= 0 or overtime or source == nil
        or not inst._receiving_combat_damage or inst._applying_damage_overtime or self:IsDead() then
            return _DoDelta(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
        end

        local old_percent = self:GetPercent()

        if old_percent <= self.nonlethal_pct and (((cause == "cold" or cause == "hot") and self.nonlethal_temperature)
        or (cause == "hunger" and self.nonlethal_hunger)) then
            return 0
        end

        if self.redirect ~= nil and self.redirect(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb) then
            return 0
        elseif not ignore_invincible and (self:IsInvincible() or inst.is_teleporting) then
            return 0
        elseif amount < 0 and not ignore_absorb then
            amount = amount * math.clamp(1 - (self.playerabsorb ~= 0 and afflicter ~= nil and afflicter:HasTag("player")
            and self.playerabsorb + self.absorb or self.absorb), 0, 1) * math.max(1 - self.externalabsorbmodifiers:Get(), 0)

            amount = afflicter ~= nil and math.min(0, amount + self.externalreductionmodifiers:Get()) or amount
        end

        if self.deltamodifierfn ~= nil then
            amount = self.deltamodifierfn(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
        end

        if self.maxdamagetakenperhit ~= nil and amount < self.maxdamagetakenperhit and not self._ignore_maxdamagetakenperhit then
            amount = self.maxdamagetakenperhit
        end

        -- If a modifier eliminated the damage, fall back to vanilla DoDelta.
        if amount >= 0 then
            return _DoDelta(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
        end

        -- Schedule the mitigated damage instead of removing health instantly.
        self:DoDeltaOverTime(amount, source.duration, source.interval, cause or "overtime_damage", afflicter)

        -- No health was lost immediately. Combat:GetAttacked still handles its normal impact sound and attacked event.
        return 0
    end
end)