local _G = GLOBAL

local function MushroomPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.pickable ~= nil then
        local _onpickedfn = inst.components.pickable.onpickedfn
    
        inst.components.pickable.onpickedfn = function(inst, picker, ...)
            if _onpickedfn ~= nil then
                _onpickedfn(inst, picker, ...)
            end

            if picker ~= nil and picker.components.inventory ~= nil then
                local product = inst.components.pickable.product
                local data = TUNING.APO_MISC.MUSHROOM_TO_HATS.GROUND[inst.prefab]

                if data ~= nil and product ~= nil then
                    local hat = picker.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD) or nil

                    if hat ~= nil and hat:HasTag("mushroomsource") and hat.prefab == data.hat then
                        for i = 1, data.amount do
                            local mushroom = _G.SpawnPrefab(product)

                            if mushroom ~= nil then
                                picker.components.inventory:GiveItem(mushroom, nil, inst:GetPosition())
                            end
                        end
                    end
                end
            end
        end
    end
end

if TUNING.APO_TWEAK_MUSHROOMHAT then
    for prefab, data in pairs(TUNING.APO_MISC.MUSHROOM_TO_HATS.GROUND) do
        AddPrefabPostInit(prefab, MushroomPostInit)
    end
end    