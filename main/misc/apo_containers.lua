local _G         = GLOBAL
local require    = _G.require
local Vector3    = _G.Vector3
local containers = require("containers")
local params     = {}

local _widgetsetup = containers.widgetsetup
function containers.widgetsetup(container, prefab, data, ...)
    local tbl = params[prefab or container.inst.prefab]

    if tbl ~= nil then
        for k, v in pairs(tbl) do
            container[k] = v
        end

        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    else
        _widgetsetup(container, prefab, data, ...)
    end
end

params.thatchsack =
{
    widget =
    {
        slotpos =
        {
            Vector3(0,   32 + 4,  0),
            Vector3(0, -(32 + 4), 0),
        },

        slotbg = {},

        animbank = "ui_chest_1x2",
        animbuild = "ui_chest_1x2",

        pos = Vector3(0, 175, 0),
        side_align_tip = 160,

    },

    type = "chest",
}

function params.thatchsack.itemtestfn(container, item, slot)
    return true
end