local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/apo_upvaluehacker")

local function IsFriendlyBee(inst)
    if inst == nil then
        return false
    end

    if inst ~= nil and inst:HasTag("beefriendly") then
        return true
    end

    if inst ~= nil and inst.components.inventory ~= nil then
        for _, slot in ipairs({ _G.EQUIPSLOTS.HEAD, _G.EQUIPSLOTS.BODY }) do
            local item = inst.components.inventory:GetEquippedItem(slot)

            if item ~= nil and item:HasAnyTag("flowered", "beefriend") then
                return true
            end
        end
    end

    return false
end

local function FriendlyBee(inst, picker)
    if picker ~= nil and picker.components.inventory ~= nil then
        local head = picker.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD) or nil
        local body = picker.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY) or nil

        if head ~= nil and head:HasTag("beefriend") then
            if head.components.armor ~= nil then
                local percent = head.components.armor:GetPercent()
                head.components.armor:SetPercent(percent - TUNING.APO_HATS.ANTMASK.CONSUPTION)
            end

            if TUNING.APO_TWEAK_BEEHAT then
                if head.prefab == "hivehat" then
                    if picker.components.sanity ~= nil then
                        picker.components.sanity:DoDelta(TUNING.APO_HATS.HIVE.SANITY) -- Gain sanity for harvesting. Yay.
                    end
                end
            end
        end

        if body ~= nil and body:HasTag("beefriend") then
            if body.components.armor ~= nil then
                local percent = body.components.armor:GetPercent()
                body.components.armor:SetPercent(percent - TUNING.APO_ARMORS.ANT.CONSUPTION)
            end
        end
    end
end

local function BeeBoxPostInit(inst)
    local updatelevel = UpvalueHacker.GetUpvalue(_G.Prefabs.beebox.fn, "updatelevel")

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.harvestable ~= nil then
        local _onharvestfn = inst.components.harvestable.onharvestfn

        inst.components.harvestable:SetOnHarvestFn(function(inst, picker, produce, ...)
            if not inst:HasTag("burnt") then
                if picker ~= nil then
                    if IsFriendlyBee(picker) then
                        if updatelevel ~= nil then
                            updatelevel(inst)
                        end

                        FriendlyBee(inst, picker)
                    else
                        if _onharvestfn ~= nil then
                            _onharvestfn(inst, picker, produce, ...)
                        end
                    end
                end
            end
        end)
    end
end

local BEEBOXES =
{
    "beebox",
    "beebox_hermit",
}

for k, v in pairs(BEEBOXES) do
    AddPrefabPostInit(v, BeeBoxPostInit)
end