local _G = GLOBAL

AddComponentPostInit("walkableplatformplayer", function(self)
    local _GetOnPlatform = self.GetOnPlatform
    local _GetOffPlatform = self.GetOffPlatform

    function self:GetOnPlatform(...)
        self.inst:PushEvent("player_on_platform", platform)
        return _GetOnPlatform(self, ...)
    end

    function self:GetOffPlatform(...)
        self.inst:PushEvent("player_off_platform", self.platform)
        return _GetOffPlatform(self, ...)
    end
end)