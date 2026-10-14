local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/apo_upvaluehacker")

local function SporeCloudPostInit(inst)
    local AURA_EXCLUDE_TAGS = UpvalueHacker.GetUpvalue(_G.Prefabs.sporecloud.fn, "AURA_EXCLUDE_TAGS")

    if AURA_EXCLUDE_TAGS ~= nil then
        table.insert(AURA_EXCLUDE_TAGS, "gasimmune")
    end
end

AddPrefabPostInit("sporecloud", SporeCloudPostInit)