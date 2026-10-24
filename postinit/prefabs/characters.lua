local _G = GLOBAL

local function WillowPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    local _OnNewSpawn = inst.OnNewSpawn

    inst.OnNewSpawn = function(inst, ...)
        if _OnNewSpawn ~= nil then
            _OnNewSpawn(inst, ...)
        end

        if inst.components.inventory ~= nil then
            for _, v in pairs(inst.components.inventory.itemslots) do
                if v.prefab == "willowoldhat" then
                    if v.components.fueled ~= nil then
                        local MIN = TUNING.APO_HATS.WILLOWOLD.START.MIN 
                        local MAX = TUNING.APO_HATS.WILLOWOLD.START.MAX

                        local percent = math.random(MIN, MAX) / 100
                        local maxfuel = v.components.fueled.maxfuel

                        v.components.fueled:SetPercent(percent)
                    end
                end
            end
        end
    end
end

AddPrefabPostInit("willow", WillowPostInit)

-- Willow starts the game with the Willow's Old Cap.
table.insert(TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WILLOW, "willowoldhat")

-- Webber starts the game with the Shamlet Mask.
table.insert(TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WEBBER, "disguisehat")

-- Winona starts the game with the Spectoggles.
table.insert(TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WINONA, "wagstaff_goggleshat")