local _G = GLOBAL

local function BernieActivePostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    local _GoBig = inst.GoBig

    if _GoBig ~= nil then
        inst.GoBig = function(inst, leader, ...)
            local big = _GoBig(inst, leader, ...)

            if big ~= nil and leader ~= nil then
                leader:PushEvent("onberniebig", { bernie = big, oldbernie = inst })
            end

            return big
        end
    end
end

AddPrefabPostInit("bernie_active", BernieActivePostInit)