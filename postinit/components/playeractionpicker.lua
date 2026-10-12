local _G = GLOBAL

AddComponentPostInit("playeractionpicker", function(self)
    local _DoGetMouseActions = self.DoGetMouseActions

    function self:DoGetMouseActions(...)
        _G.APOPushCheckLocalEntityCanSee()

        local ret = { _DoGetMouseActions(self, ...) }

        _G.APOPopCheckLocalEntityCanSee()

        return _G.unpack(ret)
    end
end)