local _G                = GLOBAL
local TAGS_BLACKLIST    = TUNING.APO_MISC.EXTRALOOTDROPPER.TAGS_BLACKLIST
local PREFABS_BLACKLIST = TUNING.APO_MISC.EXTRALOOTDROPPER.PREFABS_BLACKLIST

local LOOT_BLACKLIST    = {}

for _, prefab in ipairs(PREFABS_BLACKLIST) do
    LOOT_BLACKLIST[prefab] = true
end

AddComponentPostInit("lootdropper", function(self)
    local _DropLoot = self.DropLoot

    function self:IsValidExtraLootDropper(loot)
        return loot ~= nil and not LOOT_BLACKLIST[loot.prefab] and not loot:HasAnyTag(_G.unpack(TAGS_BLACKLIST))
    end

    function self:DropLoot(pt, prefabs, ...)
        local target = self.inst
        local killer = self:GetLuckyUser()
        local extralootdropper

        -- This currently only works for the Swashy Hat, maybe would be good to expand it later...
        if killer ~= nil and killer.components.inventory ~= nil then
            local hat = killer.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD) or nil

            if hat ~= nil and hat.components.extralootdropper ~= nil then
                if hat.components.extralootdropper:OnLootStart(target, killer) then
                    extralootdropper = hat.components.extralootdropper
                end
            end
        end

        local result = _DropLoot(self, pt, prefabs, ...)

        if extralootdropper ~= nil then
            extralootdropper:OnLootFinished(target)
        end

        return result
    end
end)