local _G = GLOBAL

local function IsWearingLifeJacket(inst)
    if inst.components.inventory ~= nil then
        local body = inst.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)
        return body ~= nil and body:HasTag("lifejacket")
    end
end

local function OnWashedAshore(inst)
    if inst.components.inventory ~= nil then
        local body = inst.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)

        if body ~= nil and body:HasTag("lifejacket") then
            body:PushEvent("sink_washed_ashore", { owner = inst })
        end
    end
end

AddComponentPostInit("drownable", function(self)
    self.inst:ListenForEvent("on_washed_ashore", OnWashedAshore)

    local _ShouldDropItems = self.ShouldDropItems

    self.ShouldDropItems = function(self, ...)
        if IsWearingLifeJacket(self.inst) then
            return false
        end

        return _ShouldDropItems(self, ...)
    end

    local _OnFallInOcean = self.OnFallInOcean

    self.OnFallInOcean = function(self, shore_x, shore_y, shore_z, ...)
        if not IsWearingLifeJacket(self.inst) then
            return _OnFallInOcean(self, shore_x, shore_y, shore_z, ...)
        end

        local inv = self.inst.components.inventory
        local active_item = inv ~= nil and inv:GetActiveItem() or nil

        local _keepondrown = nil

        if active_item ~= nil and active_item.components.inventoryitem ~= nil then
            _keepondrown = active_item.components.inventoryitem.keepondrown
            active_item.components.inventoryitem.keepondrown = true
        end

        _OnFallInOcean(self, shore_x, shore_y, shore_z, ...)

        if active_item ~= nil and active_item:IsValid() and active_item.components.inventoryitem ~= nil then
            active_item.components.inventoryitem.keepondrown = _keepondrown
        end
    end

    local _GetDrowningDamageTuning = self.GetDrowningDamageTuning

    self.GetDrowningDamageTuning = function(self, ...)
        local tunings = _GetDrowningDamageTuning(self, ...)

        if not IsWearingLifeJacket(self.inst) or tunings == nil then
            return tunings
        end

        local modified = {}

        for k, v in pairs(tunings) do
            modified[k] = v
        end

        modified.WETNESS = nil

        return modified
    end
end)