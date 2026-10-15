local _G = GLOBAL

local function onsecondaryfueltype(self, secondaryfueltype, old_secondaryfueltype)
    if old_secondaryfueltype ~= nil then
        self.inst:RemoveTag(old_secondaryfueltype.."_secondaryfuel")
    end

    if secondaryfueltype ~= nil then
        self.inst:AddTag(secondaryfueltype.."_secondaryfuel")
    end
end

AddComponentPostInit("fuel", function(self)
    _G.addsetter(self, "secondaryfueltype", onsecondaryfueltype)
end)