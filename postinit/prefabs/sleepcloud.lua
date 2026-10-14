local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/apo_upvaluehacker")

local SLEEP_CLOUDS =
{
    "sleepcloud",
    "sleepcloud_lunar",
}

local function SleepCloudPostInit(inst)
    local TARGET_CANT_TAGS = UpvalueHacker.GetUpvalue(_G.Prefabs.sleepcloud.fn, "TARGET_CANT_TAGS")
    local TARGET_PVP_CANT_TAGS = UpvalueHacker.GetUpvalue(_G.Prefabs.sleepcloud.fn, "TARGET_PVP_CANT_TAGS")

    if TARGET_CANT_TAGS ~= nil and TARGET_PVP_CANT_TAGS ~= nil then
        table.insert(TARGET_CANT_TAGS, "gasimmune")
        table.insert(TARGET_PVP_CANT_TAGS, "gasimmune")
    end
end

for k, v in pairs(SLEEP_CLOUDS) do
    AddPrefabPostInit(v, SleepCloudPostInit)
end