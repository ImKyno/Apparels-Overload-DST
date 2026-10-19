-- This component is available in the game already, modified for our needs.
local Multithruster = Class(function(self, inst)
    self.inst = inst

    self.enabled = false
    self.ready = false

    self.damage = 0
    self.cooldown = 5

    self.onrechargechange = function()
        self:UpdateReady()
    end

    self.inst:ListenForEvent("rechargechange", self.onrechargechange)
end)

function Multithruster:UpdateReady()
    self.ready = self.enabled
        and self.inst.components.rechargeable ~= nil
        and self.inst.components.rechargeable:IsCharged()

    if self.ready then
        self.inst:AddTag("multithruster")
    else
        self.inst:RemoveTag("multithruster")
    end
end

function Multithruster:SetEnabled(enabled)
    self.enabled = enabled
    self:UpdateReady()
end

function Multithruster:StartThrusting(player)
    if not self.enabled or not self.ready then
        return false
    end

    if player.sg ~= nil then
        player.sg:PushEvent("start_multithrust")

        return true
    end

    return false
end

-- Creates a thrust that hits the given target.
function Multithruster:DoThrust(player, target)
    if player.sg ~= nil then
        player.sg:PushEvent("do_multithrust")
    end

    if player.components.combat ~= nil and target ~= nil and target:IsValid() then
        local damage = player.components.combat:CalcDamage(target, self.inst)

        player.components.combat:DoAttack(target, self.inst, nil, nil, nil, damage)
    end
end

-- Stop thrusting and reset it.
function Multithruster:StopThrusting(player)
    if player.sg ~= nil then
        player.sg:PushEvent("stop_multithrust")
    end

    self.ready = false
    self.inst:RemoveTag("multithruster")

    self.damage = 0

    if self.inst.components.rechargeable ~= nil then
        self.inst.components.rechargeable:Discharge(self.cooldown)
    else
        self.inst:DoTaskInTime(self.cooldown, function()
            if self.inst:IsValid() then
                self.ready = true
            end
        end)
    end
end

function Multithruster:SetCooldown(cooldown)
    self.cooldown = cooldown
end

function Multithruster:OnRemoveFromEntity()
    self.inst:RemoveEventCallback("rechargechange", self.onrechargechange)
    self.inst:RemoveTag("multithruster")
end

return Multithruster