local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/apo_upvaluehacker")

local BEES =
{
    "bee",
    "killerbee",
}

local function IsBeeProtected(target)
    if target ~= nil and target:HasTag("beefriendly") then
        return true
    end

    if target ~= nil and target.components.inventory ~= nil then
        local body = target.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)
        local head = target.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD)

        return (body ~= nil and body:HasAnyTag("flowered", "beefriend"))
        or (head ~= nil and head:HasAnyTag("flowered", "beefriend"))
    end

    return false
end

local function BeePostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.combat ~= nil then
        if inst.components.combat._cantarget_hooked then
            return
        end

        local _CanTarget = inst.components.combat.CanTarget

        inst.components.combat.CanTarget = function(self, target, ...)
            if IsBeeProtected(target) then
                return false
            end

            return _CanTarget(self, target, ...)
        end

        inst.components.combat._cantarget_hooked = true
    end
end

for k, v in pairs(BEES) do
    AddPrefabPostInit(v, BeePostInit)
end