local _G                       = GLOBAL
local require                  = _G.require
local WagstaffGogglesArmorOver = require("widgets/wagstaffgogglesarmorover")

AddClassPostConstruct("widgets/controls", function(self)
    if self.owner ~= nil then
        self.wagstaffgogglesarmorover = self:AddChild(WagstaffGogglesArmorOver(self.owner))
        self.wagstaffgogglesarmorover:MoveToBack()
    end
end)