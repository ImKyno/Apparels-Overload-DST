local _G        = GLOBAL
local require   = _G.require
local BatVision = require("widgets/batvision")

AddClassPostConstruct("screens/playerhud", function(self)
    local _CreateOverlays = self.CreateOverlays

    function self:CreateOverlays(owner, ...)
        _CreateOverlays(self, owner, ...)

        self.batvision = self.overlayroot:AddChild(BatVision(owner))
        self.batvision:Hide()
    end
end)