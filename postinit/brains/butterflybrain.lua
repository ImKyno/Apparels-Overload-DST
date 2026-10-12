local _G             = GLOBAL
local require        = _G.require
local ButterflyBrain = require("brains/butterflybrain")
local UpvalueHacker  = _G.require("tools/apo_upvaluehacker")

local function IsProtectedFromButterfly(ent)
    if ent ~= nil and ent.components.inventory ~= nil then
        local body = ent.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)
        local head = ent.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD)

        return (body ~= nil and body:HasTag("flowered"))
        or (head ~= nil and head:HasTag("flowered"))
    end

    return false
end

local RUN_AWAY_PARAMS = UpvalueHacker.GetUpvalue(ButterflyBrain.OnStart, "RUN_AWAY_PARAMS")

if RUN_AWAY_PARAMS ~= nil and RUN_AWAY_PARAMS.fn ~= nil then
    local _RUN_AWAY_PARAMS = RUN_AWAY_PARAMS.fn

    RUN_AWAY_PARAMS.fn = function(guy, ...)
        if IsProtectedFromButterfly(guy) then
            return false
        end

        return _RUN_AWAY_PARAMS(guy, ...)
    end
end