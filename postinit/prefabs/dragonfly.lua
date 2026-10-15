local _G = GLOBAL

local function DragonflyPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("loot_prefab_spawned", function(inst, data)
        if not inst._loot_prefab_spawned then
            if inst.enraged or math.random() < TUNING.APO_MISC.DRAGONFLY.LOOT.VOLCANO then
                inst._loot_prefab_spawned = true

                if inst.components.lootdropper ~= nil then
                    local blueprint = _G.TheWorld.state.iswinter and "volcanocoldhat_blueprint" or "volcanohat_blueprint"
                    inst.components.lootdropper:SpawnLootPrefab(blueprint)
                end
            end
        end
    end)
end

AddPrefabPostInit("dragonfly", DragonflyPostInit)