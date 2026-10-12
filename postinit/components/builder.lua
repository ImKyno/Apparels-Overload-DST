local _G     = GLOBAL
local require = _G.require
local Builder = require("components/builder")

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    local function OnBrainJellyHat(self, brainjellyhat)
        if self.inst.replica.builder ~= nil then
            self.inst.replica.builder:SetIsBrainJelly(brainjellyhat)
        end
    end

    local _MakeRecipeAtPoint = Builder.MakeRecipeAtPoint

    function Builder:MakeRecipeAtPoint(recipe, pt, rot, skin, ...)
        if self:KnowsRecipe(recipe) then
            return _MakeRecipeAtPoint(self, recipe, pt, rot, skin, ...)
        end

        if recipe.placer ~= nil and self:IsBuildBuffered(recipe.name)
        and _G.TheWorld.Map:CanDeployRecipeAtPoint(pt, recipe, rot) then
            self:MakeRecipe(recipe, pt, rot, skin)
        else
            return _MakeRecipeAtPoint(self, recipe, pt, rot, skin, ...)
        end
    end

    local _ignorebrainjellyhat = false

    local _KnowsRecipe = Builder.KnowsRecipe

    function Builder:KnowsRecipe(recipe, ignore_tempbonus, ...)
        local ret = { _KnowsRecipe(self, recipe, ignore_tempbonus, ...) }

        if self.freebuildmode or _ignorebrainjellyhat then
            return _G.unpack(ret)
        end

        if type(recipe) == "string" then
            recipe = _G.GetValidRecipe(recipe)
        end

        if recipe == nil then
            return _G.unpack(ret)
        end

        if ret[1] then
            return _G.unpack(ret)
        end

        if self.brainjellyhat then
            ret[1] = _G.APOCanBrainJellyHatUnlockRecipe(self, recipe)
        end

        return _G.unpack(ret)
    end

    function Builder:KnowsRecipeWithoutBrainJellyHat(...)
        local previous = _ignorebrainjellyhat
        _ignorebrainjellyhat = true

        local ret = { self:KnowsRecipe(...) }

        _ignorebrainjellyhat = previous

        return _G.unpack(ret)
    end

    local _BufferBuild = Builder.BufferBuild

    function Builder:BufferBuild(recname, ...)
        local recipe = _G.GetValidRecipe(recname)
        local shouldevent = recipe ~= nil and recipe.placer ~= nil
        and not self:IsBuildBuffered(recname) and self:HasIngredients(recipe)

        local ret = { _BufferBuild(self, recname, ...) }

        if shouldevent then
            self.inst:PushEvent("bufferbuild", { recipe = recipe })
        end

        return _G.unpack(ret)
    end

    local _isloading = _G.setmetatable({}, { __mode = "k" })
    local _AddRecipe = Builder.AddRecipe

    function Builder:AddRecipe(recname, ...)
        if not self.brainjellyhat or _isloading[self] then
            return _AddRecipe(self, recname, ...)
        end
    end

    Builder.ForceAddRecipe = _AddRecipe

    local _OnLoad = Builder.OnLoad

    function Builder:OnLoad(data, ...)
        _isloading[self] = true

        local ret = { _OnLoad(self, data, ...) }

        _isloading[self] = nil

        return _G.unpack(ret)
    end

    AddComponentPostInit("builder", function(self)
        _G.addsetter(self, "brainjellyhat", OnBrainJellyHat)
        self.brainjellyhat = false
    end)
end