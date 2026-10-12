local _G                 = GLOBAL
local require            = _G.require
local CraftingMenuWidget = require("widgets/redux/craftingmenu_widget")

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    local brainjellyhat_change = false

    local _UpdateFilterButtons = CraftingMenuWidget.UpdateFilterButtons

    function CraftingMenuWidget:UpdateFilterButtons(...)
        local wearing_brainjellyhat = self.owner and self.owner.replica.builder
        and self.owner.replica.builder.classified and self.owner.replica.builder.classified.isbrainjellyhat:value() or nil

        self.brainjellyhat_update = wearing_brainjellyhat ~= brainjellyhat_change

        local ret = { _UpdateFilterButtons(self, ...) }

        if wearing_brainjellyhat then
            self.crafting_station_filter:Show()
            brainjellyhat_change = true
        elseif brainjellyhat_change then
            self.crafting_station_filter:Hide()
            brainjellyhat_change = false
        end

        self.brainjellyhat_update = nil

        return _G.unpack(ret)
    end

    local _UpdateEventButtonLayout = CraftingMenuWidget.UpdateEventButtonLayout

    function CraftingMenuWidget:UpdateEventButtonLayout(...)
        if not self.brainjellyhat_update then
            return _UpdateEventButtonLayout(self, ...)
        end
    end
end