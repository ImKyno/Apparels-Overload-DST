local _G      = GLOBAL
local STRINGS = _G.STRINGS

local function OnBuriedTreasureChestFound(inst, data)
    if inst.components.talker ~= nil then
        inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_BURIEDTREASURECHEST_FOUND"))
    end
end

AddComponentPostInit("wisecracker", function(self)
    self.inst:ListenForEvent("onburiedtreasurechestfound", OnBuriedTreasureChestFound)
end)