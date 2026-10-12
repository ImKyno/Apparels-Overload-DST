local _G              = GLOBAL
local require         = _G.require
local CraftingMenuHUD = require("widgets/redux/craftingmenu_hud")

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    local _RebuildRecipes = CraftingMenuHUD.RebuildRecipes

    function CraftingMenuHUD:RebuildRecipes(...)
        local ret = { _RebuildRecipes(self, ...) }

        if self.owner ~= nil and self.owner.replica.builder ~= nil then
            local builder = self.owner.replica.builder
            local not_free_build = not builder:IsFreeBuildMode()

            for k, recipe in pairs(_G.AllRecipes) do
                if _G.IsRecipeValid(recipe.name) then
                    local meta = self.valid_recipes[recipe.name].meta

                    if not_free_build and builder:IsBuildBuffered(recipe.name) and builder:CanLearn(recipe.name) then
                        meta.can_build = true
                        meta.build_state = "buffered"
                    end
                end
            end
        end

        return _G.unpack(ret)
    end
end