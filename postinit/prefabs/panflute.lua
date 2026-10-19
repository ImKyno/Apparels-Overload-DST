local _G = GLOBAL

local function PanFlutePostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.instrument ~= nil then
        local _onheard = inst.components.instrument.onheard

        if _onheard ~= nil then
            inst.components.instrument.onheard = function(inst, ...)
                if inst:HasTag("soundproof") then
                    return
                end

                _onheard(inst, ...)
            end
        end
    end
end

AddPrefabPostInit("panflute", PanFlutePostInit)