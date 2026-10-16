local _G          = GLOBAL
local require     = _G.require
local GogglesOver = require("widgets/gogglesover")

local _ToggleGoggles = GogglesOver.ToggleGoggles
local function ToggleGoggles(self, show)
    local goggles = self.owner ~= nil and self.owner.replica.inventory ~= nil 
    and self.owner.replica.inventory:EquipHasTag("goggles_wagstaff")

    if not goggles then
        return _ToggleGoggles(self, show)
    end

    if show then
        if not self.shown then
            self:Show()
            self:AddChild(self.storm_overlays):MoveToBack()
        end
    elseif self.shown then
        self:Hide()
        self.storm_root:AddChild(self.storm_overlays)
    end
end

AddClassPostConstruct("widgets/gogglesover", function(self)
    self.ToggleGoggles = ToggleGoggles
end)