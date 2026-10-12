local _G            = GLOBAL
local require       = _G.require
local BeeBrain      = require("brains/beebrain")
local UpvalueHacker = _G.require("tools/apo_upvaluehacker")

local function IsBeeBeaconOnBody(ent)
    if ent ~= nil and ent.components.inventory ~= nil then
        local body = ent.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)
        return body ~= nil and body:HasTag("beebeacon")
    end
end

local function FindBeeBeaconOnBody(self)
    return _G.FindEntity(self.inst, 30, IsBeeBeaconOnBody)
end

local _FindBeeBeacon = UpvalueHacker.GetUpvalue(BeeBrain.OnStart, "FindBeeBeacon")

if _FindBeeBeacon ~= nil then
    local function FindBeeBeacon(self, ...)
        local beacon = _FindBeeBeacon(self, ...)

        if beacon ~= nil then
            return beacon
        end

        return FindBeeBeaconOnBody(self)
    end

    UpvalueHacker.SetUpvalue(BeeBrain.OnStart, FindBeeBeacon, "FindBeeBeacon")
end