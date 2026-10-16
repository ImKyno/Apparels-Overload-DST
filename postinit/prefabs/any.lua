local _G = GLOBAL

-- This prevents clothing from perishing when held by the Sewing Mannequin.
local function AnyPerishableClothingPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.equippable ~= nil and inst.components.perishable ~= nil then
        local _onequiptomodelfn = inst.components.equippable.onequiptomodelfn

        if _onequiptomodelfn ~= nil then
            inst.components.equippable.onequiptomodelfn = function(...)
                inst._wasperishing = inst.components.perishable:IsPerishing()
                inst.components.perishable:StopPerishing()

                return _onequiptomodelfn and _onequiptomodelfn(...)
            end
        end

        local _onunequipfn = inst.components.equippable.onunequipfn

        if _onunequipfn ~= nil then
            inst.components.equippable.onunequipfn = function(inst, owner, ...)
                if owner ~= nil and owner:HasTag("equipmentmodel") then
                    if inst._wasperishing then
                        inst.components.perishable:StartPerishing()
                    end
                end

                return _onunequipfn and _onunequipfn(inst, owner, ...)
            end
        end
    end
end

-- This prevents clothing from perishing when held by Followers such as Pigs and Bunnymen.
local function AnyFollowerClothingPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

end

-- THIS OPTION IS BACKWARDS !!!
if not TUNING.APO_TWEAK_MANNEQUIN then
    AddPrefabPostInitAny(AnyPerishableClothingPostInit)
end