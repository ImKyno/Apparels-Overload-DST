local _G          = GLOBAL
local require     = _G.require
local GogglesOver = require("widgets/gogglesover")

local _ToggleGoggles = GogglesOver.ToggleGoggles

local function HasWagstaffGoggles(owner)
    if owner == nil then
        return false
    end

    local inventory = owner.replica ~= nil and owner.replica.inventory
    or owner.components ~= nil and owner.components.inventory

    return inventory ~= nil and inventory:EquipHasTag("goggles_wagstaff") or false
end

local function ToggleGoggles(self, show)
    if HasWagstaffGoggles(self.owner) then
        if self.shown then
            self:Hide()
        end

        if self.storm_overlays:GetParent() ~= self.storm_root then
            self.storm_root:AddChild(self.storm_overlays)
        end

        return
    end

    return _ToggleGoggles(self, show)
end

local function RefreshGoggles(self)
    local owner = self.owner

    if owner ~= nil and owner.components ~= nil and owner.components.playervision ~= nil then
        self:ToggleGoggles(owner.components.playervision:HasGoggleVision())
    end
end

AddClassPostConstruct("widgets/gogglesover", function(self)
    self.ToggleGoggles = ToggleGoggles

    local owner = self.owner

    if owner ~= nil then
        self.inst:ListenForEvent("equip", function()
            RefreshGoggles(self)
        end, owner)

        self.inst:ListenForEvent("unequip", function()
            RefreshGoggles(self)
        end, owner)

        self.inst:ListenForEvent("inventoryclosed", function()
            RefreshGoggles(self)
        end, owner)
    end
end)