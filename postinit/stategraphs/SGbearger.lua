local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/apo_upvaluehacker")

AddStategraphPostInit("bearger", function(sg)
    local _yawn_timeline = sg.states["yawn"].timeline[2].fn

    local YAWNTARGET_CANT_TAGS = UpvalueHacker.GetUpvalue(_yawn_timeline, "YAWNTARGET_CANT_TAGS")
    table.insert(YAWNTARGET_CANT_TAGS, "soundproof")
end)