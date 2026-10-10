local BuriedTreasureFinder = Class(function(self, inst)
    self.inst = inst

    self.num_found = 0
    self.owner = nil
end)

function BuriedTreasureFinder:Start(owner)
    self.owner = owner
end

function BuriedTreasureFinder:Stop()
    self.owner = nil
end

function BuriedTreasureFinder:GetTreasureChance()
    if self.owner == nil then
        return TUNING.APO_MISC.BURIEDTREASUREFINDER.CHANCE.NONE
    elseif self.owner:HasTag("piratecaptain") then
        return TUNING.APO_MISC.BURIEDTREASUREFINDER.CHANCE.PIRATE
    end

    return TUNING.APO_MISC.BURIEDTREASUREFINDER.CHANCE.NONE.NORMAL
end

function BuriedTreasureFinder:RevealTreasures()
    for i = 1, self.num_found do
        local pos = self.inst:GetPosition()
        local offset = FindWalkableOffset(pos, math.random() * 2 * math.pi, math.random(25, 30), 18)

        if offset then
            local spawn_pos = pos + offset
            local treasure = SpawnPrefab("buriedtreasurechest")

            treasure.Transform:SetPosition(spawn_pos:Get())

            if self.owner then
                self.owner:PushEvent("ontreasurefound", { treasure = treasure })
            end

            self.num_found = self.num_found - 1
        end
    end
end

function BuriedTreasureFinder:FindTreasure()
    if math.random() <= self:GetTreasureChance() then
        self.num_found = self.num_found + 1
    end
end

function BuriedTreasureFinder:OnRemoveFromEntity()
    self:RevealTreasures()
    self:Stop()
end

function BuriedTreasureFinder:OnSave()
    local data = {}

    data.num_found = self.num_found

    return data
end

function BuriedTreasureFinder:OnLoad(data)
    if data == nil then
        return
    end

    self.num_found = data.num_found or 0
end

return BuriedTreasureFinder