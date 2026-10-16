local _G = GLOBAL

local BATVISION_CC   = GetModConfigData("BATVISION_CC",   true)
local HEATVISION_CC  = GetModConfigData("HEATVISION_CC",  true)
local SHOOTVISION_CC = GetModConfigData("SHOOTVISION_CC", true)

local function OnSetBatVision(self, enabled)
    self.inst:PushEvent("batvision", { enabled = enabled })

    if enabled then
        -- PushForcedNightVision(source, priority, customcctable, blend, customambienttable, nonightvisioncc)
        if BATVISION_CC then
            self:PushForcedNightVision("BATVISION", 100, TUNING.APO_MISC.BATVISION.CC_TABLE, 1)
        else
            self:PushForcedNightVision("BATVISION", 100, nil, 1, nil, true)
        end
    else
        self:PopForcedNightVision("BATVISION")
    end
end

local function OnSetHeatVision(self, enabled)
    self.inst:PushEvent("heatvision", { enabled = enabled })

    if enabled then
        if HEATVISION_CC then
            self:PushForcedNightVision("HEATVISION", 100, TUNING.APO_MISC.HEATVISION.CC_TABLE, 1)
        else
            self:PushForcedNightVision("HEATVISION", 100, nil, 1, nil, true)
        end
    else
        self:PopForcedNightVision("HEATVISION")
    end
end

local function OnSetShootVision(self, enabled)
    self.inst:PushEvent("shootvision", { enabled = enabled })

    if enabled then
        if SHOOTVISION_CC then
            self:PushForcedNightVision("SHOOTVISION", 100, TUNING.APO_MISC.SHOOTVISION.CC_TABLE, 1)
        else
            self:PushForcedNightVision("SHOOTVISION", 100, nil, 1, nil, true)
        end
    else
        self:PopForcedNightVision("SHOOTVISION")
    end
end

local function OnEquipChanged(inst)
    local self = inst.components.playervision

    if self.batvision == not inst.replica.inventory:EquipHasTag("batvision") then
        self.batvision = not self.batvision

        if not self.forcebatvision and self.inst == _G.ThePlayer then
            OnSetBatVision(self, self.batvision)
        end
    end

    if self.heatvision == not inst.replica.inventory:EquipHasTag("heatvision") then
        self.heatvision = not self.heatvision

        if not self.forceheatvision and self.inst == _G.ThePlayer then
            OnSetHeatVision(self, self.heatvision)
        end
    end

    if self.shootvision == not inst.replica.inventory:EquipHasTag("shootvision") then
        self.shootvision = not self.shootvision

        if not self.forceshootvision and self.inst == _G.ThePlayer then
            OnSetShootVision(self, self.shootvision)
        end
    end
end

local function OnInit(inst, self)
    inst:ListenForEvent("equip", OnEquipChanged)
    inst:ListenForEvent("unequip", OnEquipChanged)

    if not _G.TheWorld.ismastersim then
        inst:ListenForEvent("inventoryclosed", OnEquipChanged)

        if inst.replica.inventory == nil then
            return
        end
    end

    OnEquipChanged(inst)
end

AddComponentPostInit("playervision", function(self)
    self.batvision = false
    self.forcebatvision = false

    self.heatvision = false
    self.forceheatvision = false

    self.shootvision = false
    self.forceshootvision = false

    function self:HasBatVision()
        return self.batvision or self.forcebatvision
    end

    function self:ForceBatVision(force)
        if not self.forcebatvision ~= not force then
            self.forcebatvision = force == true

            if not self.batvision and self.inst == _G.ThePlayer then
                OnSetBatVision(self, self.forcebatvision)
            end
        end
    end

    function self:HasHeatVision()
        return self.heatvision or self.forceheatvision
    end

    function self:ForceHeatVision(force)
        if not self.forceheatvision ~= not force then
            self.forceheatvision = force == true

            if not self.heatvision and self.inst == _G.ThePlayer then
                OnSetHeatVision(self, self.forceheatvision)
            end
        end
    end

    function self:HasShootVision()
        return self.shootvision or self.forceshootvision
    end

    function self:ForceShootVision(force)
        if not self.forceshootvision ~= not force then
            self.forceshootvision = force == true

            if not self.shootvision and self.inst == _G.ThePlayer then
                OnSetShootVision(self, self.forceshootvision)
            end
        end
    end

    self.inst:DoTaskInTime(0, OnInit, self)
end)