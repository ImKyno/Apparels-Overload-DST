local Widget = require("widgets/widget")
local Image  = require("widgets/image")

local WagstaffGogglesArmorOver = Class(Widget, function(self, owner, storm_overlays)
    self.owner = owner

    Widget._ctor(self, "WagstaffGogglesArmorOver")

    self:SetClickable(false)

    self.bg = self:AddChild(Image("images/hudimages/visor_over.xml", "visor_over.tex"))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_FILLSCREEN)

    self:Hide()

    self.owner:ListenForEvent("equip", function()
        return self:ToggleGoggles()
    end)

    self.owner:ListenForEvent("unequip", function()
        return self:ToggleGoggles()
    end)

    self.owner:ListenForEvent("ms_respawnedfromghost", function()
        return self:ToggleGoggles()
    end)

    self.owner:ListenForEvent("ms_becameghost", function()
        return self:ToggleGoggles()
    end)

    self.inst:ListenForEvent("gogglevision", function(owner, data)
        self:ToggleGoggles(data.enabled)
    end, owner)

    if owner ~= nil then
        local gogglesvision = owner.components.playervision ~= nil and owner.components.playervision:HasGoggleVision()

        if gogglesvision then
            self:ToggleGoggles(true)
        end
    end
end)

function WagstaffGogglesArmorOver:ToggleGoggles(show)
    local gogglesarmor = self.owner ~= nil and self.owner.replica.inventory ~= nil
    and self.owner.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil

    if gogglesarmor and gogglesarmor:HasTag("gogglesarmor") then
        self:Show()
    else
        self:Hide()
    end
end

return WagstaffGogglesArmorOver