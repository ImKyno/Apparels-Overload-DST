local _G = GLOBAL

-- This prevents clothing from perishing when held by Followers such as Pigs and Bunnymen.
local function IsValidWearer(owner)
    return owner ~= nil and not owner:HasAnyTag("equipmentmodel", "player", "playerghost")
    and owner.components.inventory ~= nil and owner.components.trader ~= nil
end

local function AnyFollowerClothingPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.equippable ~= nil and (inst.components.fueled ~= nil or inst.components.perishable ~= nil) then
        local _onequipfn = inst.components.equippable.onequipfn
        local _onunequipfn = inst.components.equippable.onunequipfn

        inst.components.equippable.onequipfn = function(inst, owner, ...)
            if IsValidWearer(owner) then
                if inst.components.fueled ~= nil then
                    inst._wasconsuming = inst.components.fueled:IsConsuming()
                    inst.components.fueled:StopConsuming()
                end

                if inst.components.perishable ~= nil then
                    inst._wasperishing = inst.components.perishable:IsPerishing()
                    inst.components.perishable:StopPerishing()
                end
            end

            if _onequipfn ~= nil then
                return _onequipfn(inst, owner, ...)
            end
        end

        inst.components.equippable.onunequipfn = function(inst, owner, ...)
            if IsValidWearer(owner) then
                if inst.components.fueled ~= nil then
                    if inst._wasconsuming then
                        inst.components.fueled:StartConsuming()
                    end

                    inst._wasconsuming = nil
                end

                if inst.components.perishable ~= nil then
                    if inst._wasperishing then
                        inst.components.perishable:StartPerishing()
                    end

                    inst._wasperishing = nil
                end
            end

            if _onunequipfn ~= nil then
                return _onunequipfn(inst, owner, ...)
            end
        end
    end
end

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

-- THESE OPTION ARE BACKWARDS !!!
if not TUNING.APO_TWEAK_FOLLOWER then
    AddPrefabPostInitAny(AnyFollowerClothingPostInit)
end

if not TUNING.APO_TWEAK_MANNEQUIN then
    AddPrefabPostInitAny(AnyPerishableClothingPostInit)
end