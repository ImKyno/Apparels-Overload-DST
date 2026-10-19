local _G                = GLOBAL
local require           = _G.require
local ACTIONS           = _G.ACTIONS
local UpvalueHacker     = require("tools/apo_upvaluehacker")

local COMPONENT_ACTIONS = UpvalueHacker.GetUpvalue(_G.EntityScript.CollectActions, "COMPONENT_ACTIONS")
local USEITEM           = COMPONENT_ACTIONS.USEITEM

local _USEITEMfuel = USEITEM.fuel
function USEITEM.fuel(inst, doer, target, actions, right, ...)
    local _actioncount = #actions

    _USEITEMfuel(inst, doer, target, actions, right, ...)

    if #actions == _actioncount then
        if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
            or (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
            if inst.prefab ~= "spoiled_food" and inst:HasTag("quagmire_stewable") and target:HasTag("quagmire_stewer")
            and target.replica.container ~= nil and target.replica.container:IsOpenedBy(doer) then
                return
            end

            for k, v in pairs(_G.FUELTYPE) do
                if inst:HasTag(v.."_secondaryfuel") then
                    if target:HasTag(v.."_fueled") then
                        table.insert(actions, inst:GetIsWet() and ACTIONS.ADDWETFUEL or ACTIONS.ADDFUEL)
                    end
                end
            end
        end
    end
end

AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if inst:HasTag("townportaltalisman") and target:HasTag("turfhat") then
        _G.RemoveByValue(actions, ACTIONS.STORE)
    end
end)