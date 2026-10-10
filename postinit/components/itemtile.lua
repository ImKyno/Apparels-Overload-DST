
local _G = GLOBAL
local require = _G.require
local UIAnim = require("widgets/uianim")

AddClassPostConstruct("widgets/itemtile", function(self)
    if self.item == nil or self.item.prefab ~= "armor_vortex" then
        return
    end

    local item = self.item

    local function SetRechargeColor()
        if self.rechargeframe ~= nil then
            self.rechargeframe:GetAnimState():SetMultColour(0, 0, 0, 0.64)
        end

        if self.recharge ~= nil then
            self.recharge:GetAnimState():SetMultColour(0, 0, 0, 0.64)
        end
    end

    self.rechargepct = 1
    self.rechargetime = TUNING.APO_ARMOR_VORTEX.COOLDOWN.NORMAL

    self.rechargeframe = self:AddChild(UIAnim())
    self.rechargeframe:GetAnimState():SetBank("recharge_meter")
    self.rechargeframe:GetAnimState():SetBuild("recharge_meter")
    self.rechargeframe:GetAnimState():PlayAnimation("frame")
    self.rechargeframe:GetAnimState():AnimateWhilePaused(false)

    self.recharge = self:AddChild(UIAnim())
    self.recharge:GetAnimState():SetBank("recharge_meter")
    self.recharge:GetAnimState():SetBuild("recharge_meter")
    self.recharge:GetAnimState():AnimateWhilePaused(false)
    self.recharge:SetClickable(false)

    local now = _G.GetTime()
    local endtime = item.rechargetimeend or 0
    local duration = item:GetRechargeTime()

    if duration > 0 and endtime > now then
        local remaining = item:GetRechargePercent()

        self:SetChargeTime(duration)
        self:SetChargePercent(1 - remaining)
    else
        self:SetChargeTime(TUNING.APO_ARMOR_VORTEX.COOLDOWN.NORMAL)
        self:SetChargePercent(1)
    end

    SetRechargeColor()

    self.inst:ListenForEvent("armor_vortex_rechargechange", function(_, data)
        if data ~= nil and data.percent ~= nil then
            self:SetChargePercent(data.percent)
            SetRechargeColor()
        end
    end, item)

    self.inst:ListenForEvent("armor_vortex_rechargetimechange", function(_, data)
        if data ~= nil and data.t ~= nil then
            self:SetChargeTime(data.t)
            SetRechargeColor()
        end
    end, item)
end)