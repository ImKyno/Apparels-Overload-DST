local _G = GLOBAL

local function OnSetBatVision(self, enabled)
    self.inst:PushEvent("batvision", { enabled = enabled })

    if enabled then
        self:PushForcedNightVision("BATVISION", 100, TUNING.APO_MISC.BATVISION.CC_TABLE, 1)
    else
        self:PopForcedNightVision("BATVISION")
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

    self.inst:DoTaskInTime(0, OnInit, self)
end)