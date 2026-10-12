local _G             = GLOBAL
local require        = _G.require
local BuilderReplica = require("components/builder_replica")

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    function BuilderReplica:SetIsBrainJelly(isbrainjellyhat)
        if self.classified ~= nil then
            self.classified.isbrainjellyhat:set(isbrainjellyhat)
        end
    end

    function BuilderReplica:IsBrainJellyHat()
        if self.classified ~= nil then
            return self.classified.isbrainjellyhat:value()
        end

        return false
    end

    local _ignorebrainjellyhat = false
    local _KnowsRecipe = BuilderReplica.KnowsRecipe

    function BuilderReplica:KnowsRecipe(recipe, ...)
        local ret = { _KnowsRecipe(self, recipe, ...) }

        if _ignorebrainjellyhat then
            return _G.unpack(ret)
        end

        if self.inst.components.builder ~= nil or self.classified == nil then
            return _G.unpack(ret)
        end

        if self.classified.isfreebuildmode:value() then
            return _G.unpack(ret)
        end

        if type(recipe) == "string" then
            recipe = _G.GetValidRecipe(recipe)
        end

        if recipe == nil or ret[1] then
            return _G.unpack(ret)
        end

        if self.classified.isbrainjellyhat:value() then
            ret[1] = _G.APOCanBrainJellyHatUnlockRecipe(self, recipe)
        end

        return _G.unpack(ret)
    end

    function BuilderReplica:KnowsRecipeWithoutBrainJellyHat(...)
        if self.inst.components.builder ~= nil then
            return self.inst.components.builder:KnowsRecipeWithoutBrainJellyHat(...)
        end

        local previous = _ignorebrainjellyhat
        _ignorebrainjellyhat = true

        local ret = { self:KnowsRecipe(...) }

        _ignorebrainjellyhat = previous

        return _G.unpack(ret)
    end
end