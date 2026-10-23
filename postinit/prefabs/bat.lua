local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/apo_upvaluehacker")

local BATS =
{
    "bat",
}

local function IsBatProtected(target)
    if target ~= nil and target.components.inventory ~= nil then
        local head = target.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD)

        return (head ~= nil and head:HasTag("batvision"))
    end

    return false
end

local function BatPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.combat ~= nil then
        if inst.components.combat._cantarget_hooked then
            return
        end

        local _CanTarget = inst.components.combat.CanTarget

        inst.components.combat.CanTarget = function(self, target, ...)
            if IsBatProtected(target) then
                return false
            end

            return _CanTarget(self, target, ...)
        end

        inst.components.combat._cantarget_hooked = true
    end
end

for k, v in pairs(BATS) do
    AddPrefabPostInit(v, BatPostInit)
end