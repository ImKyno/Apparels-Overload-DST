local _G         = GLOBAL
local require    = _G.require
local RecipeTile = require("widgets/recipetile")

-- This updates alongside "craftingmenu_skinselector" widget.
local _SetImageFromRecipe = RecipeTile.sSetImageFromRecipe
RecipeTile.sSetImageFromRecipe = function(image, recipe, item, ...)
    _SetImageFromRecipe(image, recipe, item, ...)

    if recipe ~= nil and recipe.product == "lanternbottle" and item ~= nil then
        local image_name = _G.GetSkinInvIconName(item) .. "_lit.tex"

        image:SetTexture(_G.GetInventoryItemAtlas(image_name), image_name, "default.tex")
    end
end