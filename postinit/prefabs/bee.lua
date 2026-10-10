local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/apo_upvaluehacker")

local function BeePostInit(inst)
    local RETARGET_CANT_TAGS = UpvalueHacker.GetUpvalue(_G.Prefabs.bee.fn, "SpringBeeRetarget", "RETARGET_CANT_TAGS")
    table.insert(RETARGET_CANT_TAGS, "beefriend")
end

AddPrefabPostInit("bee",       BeePostInit)
AddPrefabPostInit("killerbee", BeePostInit)