
local _G                      = GLOBAL
local require                 = _G.require
local IngredientUI            = require("widgets/ingredientui")
local CraftingMenuIngredients = require("widgets/redux/craftingmenu_ingredients")

require("util")

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    local INGREDIENTS_SCALE = 0.75

    local _SetRecipe = CraftingMenuIngredients.SetRecipe

    function CraftingMenuIngredients:SetRecipe(recipe, ...)
        local ret = { _SetRecipe(self, recipe, ...) }

        local owner = self.owner
        local builder = owner.replica.builder
        local inventory = owner.replica.inventory
        local last_ingredient = self.ingredient_widgets[#self.ingredient_widgets]
        local hat = inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD)

        if last_ingredient == nil or not builder:IsBrainJellyHat()
        or not builder:KnowsRecipe(recipe) or builder:KnowsRecipeWithoutBrainJellyHat(recipe, true)
        or hat == nil or hat.prefab ~= "brainjellyhat" then
            return _G.unpack(ret)
        end

        local root = last_ingredient:GetParent()

        local w = 64
        local div = 10
        local half_div = div * 0.5

        self.num_items = self.num_items + 1

        local scale = math.min(1, self.max_ingredients_wide / self.num_items)
        root:SetScale(scale * INGREDIENTS_SCALE)

        local quant_text_scale = math.max(1, 1 / (scale * 1.125))

        if self.extra_quantity_scale ~= nil then
            quant_text_scale = quant_text_scale * self.extra_quantity_scale
        end

        for _, ing in ipairs(self.ingredient_widgets) do
            if ing.quant ~= nil and ing.quant.SetScale ~= nil then
                ing.quant:SetScale(quant_text_scale, quant_text_scale)
            end

            local x, y, z = ing:GetPosition():Get()
            ing:SetPosition(x - (w * 0.5 + half_div), y, z)
        end

        local offset = last_ingredient:GetPosition():Get()

        offset = offset + w + half_div

        local brain_atlas = hat.replica.inventoryitem:GetAtlas()
        local brain_img = hat.replica.inventoryitem:GetImage()

        local brain = root:AddChild(IngredientUI(brain_atlas, brain_img, 0.25, 0.25, true,
        _G.STRINGS.BRAINJELLYHAT_TOOLTIP, owner, _G.CHARACTER_INGREDIENT.MAX_HEALTH, quant_text_scale))

        brain:SetPosition(offset + half_div, 0)

        table.insert(self.ingredient_widgets, brain)

        return _G.unpack(ret)
    end
end