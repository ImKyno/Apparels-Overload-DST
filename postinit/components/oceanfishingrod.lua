local _G = GLOBAL

AddComponentPostInit("oceanfishingrod", function(self)
    _CatchFish = self.CatchFish

    function self:CatchFish(...)
        local fisher = self.fisher
        local target = self.target

        if _CatchFish ~= nil then
            _CatchFish(self, ...)
        end

        if fisher.rainhat_fisherman then
            local startpos = target:GetPosition()
            local targetpos = self:CalcCatchDest(startpos, fisher:GetPosition(), target.components.oceanfishable.catch_distance)

            local fish = _G.SpawnPrefab(target.prefab)

            if fish ~= nil then
                fish:SetPersistData(target:GetPersistData())
                fish = fish.components.oceanfishable:MakeProjectile()

                if fish.components.weighable ~= nil then
                    fish.components.weighable:SetPlayerAsOwner(fisher)
                end

                self:_LaunchFishProjectile(fish, startpos, targetpos)

                fisher:PushEvent("fishcaught", { fish = fish })
            end
        end
    end
end)