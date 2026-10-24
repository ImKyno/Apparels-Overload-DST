local Extralootdropper = Class(function(self, inst)
    self.inst = inst

    self.owner = nil
    self.targets = {}
end)

local function IsHatActive(self, owner)
    if owner == nil then
        return false
    end

    -- This currently only works for the Swashy Hat, maybe would be good to expand it later...
    if owner ~= nil and owner.components.inventory ~= nil then
        local hat = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil

        if hat ~= nil then
            return true
        end
    end

    return false
end

function Extralootdropper:StartListening(owner)
    self:StopListening()
    self.owner = owner
end

function Extralootdropper:StopListening()
    for target, data in pairs(self.targets) do
        if target:IsValid() then
            target:RemoveEventCallback("loot_prefab_spawned", data.listener)
        end
    end

    self.targets = {}
    self.owner = nil
end

function Extralootdropper:OnLootStart(target, killer)
    if self.owner ~= killer or not IsHatActive(self, killer) or target == nil or self.targets[target] ~= nil then
        return false
    end

    local data = { candidates = {} }

    data.listener = function(_, event)
        local loot = event ~= nil and event.loot or nil

        if target.components.lootdropper ~= nil and target.components.combat ~= nil
        and not target:HasAnyTag("noextralootdropper") then
            if target.components.lootdropper:IsValidExtraLootDropper(loot) then
                table.insert(data.candidates, { prefab = loot.prefab, recipetouse = loot.recipetouse })
            end
        end
    end

    self.targets[target] = data

    target:ListenForEvent("loot_prefab_spawned", data.listener)

    return true
end

function Extralootdropper:OnLootFinished(target)
    local data = self.targets[target]

    if data == nil then
        return
    end

    self.targets[target] = nil

    if target:IsValid() then
        target:RemoveEventCallback("loot_prefab_spawned", data.listener)
    end

    if #data.candidates == 0 or not IsHatActive(self, self.owner) then
        return
    end

    local selected = data.candidates[math.random(#data.candidates)]
    local prefab = selected.prefab

    -- If we are a blueprint, copy the original recipe.
    if selected.recipetouse then
        prefab = string.lower(selected.recipetouse).."_blueprint"
    end

    if target.components.lootdropper ~= nil then
        target.components.lootdropper:SpawnLootPrefab(prefab)
    end
end

function Extralootdropper:OnRemoveFromEntity()
    self:StopListening()
end

return Extralootdropper