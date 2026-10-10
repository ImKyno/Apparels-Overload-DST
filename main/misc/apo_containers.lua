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