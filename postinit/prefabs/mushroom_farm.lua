local _G = GLOBAL

local function MushroomFarmPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.harvestable ~= nil then
        local _onharvestfn = inst.components.harvestable.onharvestfn

        inst.components.harvestable:SetOnHarvestFn(function(inst, picker, produce, ...)
            if _onharvestfn ~= nil then
                _onharvestfn(inst, picker, ...)
            end

            if picker ~= nil and picker.components.inventory ~= nil and produce ~= nil and produce >= 4 then
                local product = inst.components.harvestable.product
                local data = product ~= nil and TUNING.APO_MISC.MUSHROOM_TO_HATS.PLANTER[product] or nil

                if data ~= nil then
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
        end)
    end
end

if TUNING.APO_TWEAK_MUSHROOMHAT then
    AddPrefabPostInit("mushroom_farm", MushroomFarmPostInit)
end