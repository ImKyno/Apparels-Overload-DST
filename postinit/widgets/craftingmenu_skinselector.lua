local _G                       = GLOBAL
local require                  = _G.require
local CraftingMenuSkinSelector = require("widgets/redux/craftingmenu_skinselector")

-- I want to show Bottle Lantern Skins with the light on in the skin selector.
local _GetSkinOptions = CraftingMenuSkinSelector.GetSkinOptions
CraftingMenuSkinSelector.GetSkinOptions = function(self, ...)
    local options = _GetSkinOptions(self, ...)

    if self.recipe ~= nil and self.recipe.product == "lanternbottle" then
        for i, option in ipairs(options) do
            if i > 1 then
                local skin = self.skins_list[i - 1].item
                local image_name = _G.GetSkinInvIconName(skin).."_lit.tex"

                option.image = { _G.GetInventoryItemAtlas(image_name), image_name, "default.tex" }
            end
        end
    end

    return options
end