local _G = GLOBAL

AddComponentPostInit("fishingrod", function(self)
    local _Collect = self.Collect

    function self:Collect(...)
        local fisherman = self.fisherman
        local caughtfish = self.caughtfish

        if _Collect ~= nil then
            _Collect(self, ...)
        end

        if fisherman and caughtfish then
            if not fisherman.rainhat_fisherman then
                return
            end

            local extrafish = _G.SpawnPrefab(caughtfish.prefab)

            if extrafish ~= nil then
                extrafish.Transform:SetPosition(caughtfish.Transform:GetWorldPosition())

                if extrafish.components.weighable ~= nil then
                    extrafish.components.weighable:SetPlayerAsOwner(fisherman)
                end
            end
        end
    end
end)