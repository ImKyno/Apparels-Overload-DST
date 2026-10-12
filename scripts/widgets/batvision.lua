local Widget = require("widgets/widget")
local easing = require("easing")

local FADE_PERCENT_START = 0.65
local TRANSITION_TIME_IN = 5.0
local TRANSITION_TIME_OUT = 0.2

local function PlaySonarAnim(x, y, z)
    local inst = CreateEntity()

    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.Transform:SetScale(2,2,2)
    inst.Transform:SetPosition(x, y, z)

    inst.AnimState:SetBank("bearger_ring_fx")
    inst.AnimState:SetBuild("bearger_ring_fx")
    inst.AnimState:PlayAnimation("idle")

    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetFinalOffset(3)
    inst.AnimState:SetSortOrder(3)

    inst:AddTag("FX")

    inst:ListenForEvent("animover", inst.Remove)
end

local function SpawnSonarAnim(owner, self)
    if owner == nil or not self.active then
        return
    end

    local x, y, z = owner.Transform:GetWorldPosition()

    PlaySonarAnim(x, y, z)
end

local BatVision = Class(Widget, function(self, owner)
    self.owner = owner

    Widget._ctor(self, "BatVision")
    self:SetClickable(false)

    self.bg = self:AddChild(Image())
    self.bg:SetTexture("images/hudimages/batvision_over.xml", "batvision_over.tex")
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_FILLSCREEN)
    self.bg:SetPosition(0, 0)

    self.active = false

    self.fade = 0
    self.fadein = false
    self.fadeto = 0
    self.fadetime = TRANSITION_TIME_OUT

    if owner ~= nil then
        self.inst:ListenForEvent("batvision", function(owner, data)
            self:SetActive(data.enabled)
        end, owner)

        if owner.components.playervision ~= nil and owner.components.playervision:HasBatVision() then
            self:SetActive(true)
        end
    end
end)

function BatVision:GetSonarLevel()
    return self.fade
end

function BatVision:SetActive(active)
    if active then
        if not self.active then
            self.active = true
            self.fade = FADE_PERCENT_START
            self:ApplyLevels()

            self:SetFadeMode(true)
            self:StartUpdating()
        end
    else
        if self.active then
            self.active = false

            self:SetFadeMode(false, true)
            self:StopUpdating()
        end
    end
end

function BatVision:SetFadeMode(fadein, instant)
    if fadein ~= self.fadein then
        self.fadein = fadein

        if fadein then
            self.fadeto = 1.0
            self.fadetime = TRANSITION_TIME_IN
        else
            self.fadeto = 0.0
            self.fadetime = TRANSITION_TIME_OUT
        end

        if instant then
            self:OnUpdate(math.huge)
        end
    end
end

function BatVision:ApplyLevels()
    self.alpha = self.fade

    if self.alpha > 0 then
        self.bg:SetTint(0, 0, 0, self.alpha)

        if not self.shown then
            self:Show()
        end
    elseif self.shown then
        self:Hide()
    end
end

function BatVision:GetSpeedMult()
    if self.owner ~= nil and self.owner:HasTag("quickbatvisionuser") then
        return easing.inOutQuint(self.fade, 0, 1, 1)
    end

    return 1
end

function BatVision:OnUpdate(dt)
    if TheNet:IsServerPaused() then
        return
    end

    local dirty = false

    local speed_mult = self:GetSpeedMult()

    if self.fadeto < self.fade then
        self.fade = math.max(self.fadeto, self.fade - dt * speed_mult / self.fadetime)
        dirty = true
    elseif self.fadeto > self.fade then
        self.fade = math.min(self.fadeto, self.fade + dt * speed_mult / self.fadetime)
        dirty = true
    end

    if dirty then
        self:ApplyLevels()
    else
        if self.fadein then
            TheFocalPoint.SoundEmitter:PlaySound("apo_sounds/common/hat_bat/sonar")

            SpawnSonarAnim(self.owner, self)

            self.owner:DoTaskInTime(0.1, SpawnSonarAnim, self)
        end

        self:SetFadeMode(not self.fadein)
    end
end

return BatVision