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
    elseif not self.owner:HasTag("player") then
        return TUNING.APO_MISC.BURIEDTREASUREFINDER.CHANCE.CREATURE
    elseif self.owner:HasAnyTag("wonkey", "pirate", "piratecaptain", "fleetadmiral") then
        return TUNING.APO_MISC.BURIEDTREASUREFINDER.CHANCE.PIRATE
    end

    return TUNING.APO_MISC.BURIEDTREASUREFINDER.CHANCE.NORMAL
end

function BuriedTreasureFinder:RevealTreasure()
    for i = 1, self.num_found do
        local pos = self.inst:GetPosition()
        local offset = FindWalkableOffset(pos, math.random() * 2 * math.pi, math.random(25, 30), 18)

        if offset then
            local spawn_pos = pos + offset
            local treasure = SpawnPrefab("buriedtreasurechest")

            treasure.Transform:SetPosition(spawn_pos:Get())

            if self.owner then
                self.owner:PushEvent("onburiedtreasurechestfound", { treasure = treasure })
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

-- Forces a treasure to spawn near the player.
function BuriedTreasureFinder:GenerateTreasure()
    self.num_found = self.num_found + 1
    self:RevealTreasure()
end

-- Forces a treasure to spawn at the cursor.
function BuriedTreasureFinder:GenerateTreasureAtPoint(pos)
    pos = pos or ConsoleWorldPosition()

    if pos == nil then
        return nil
    end

    local treasure = SpawnPrefab("buriedtreasurechest")

    if treasure ~= nil then
        treasure.Transform:SetPosition(pos:Get())

        if self.owner ~= nil then
            self.owner:PushEvent("onburiedtreasurechestfound", { treasure = treasure })
        end
    end

    return treasure
end

function BuriedTreasureFinder:OnRemoveFromEntity()
    self:RevealTreasure()
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