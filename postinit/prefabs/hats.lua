local _G = GLOBAL

local HATS_BEE =
{
    "beehat",
    "hivehat",
}

local HATS_MUSHROOM =
{
    "blue_mushroomhat",
    "green_mushroomhat",
    "moon_mushroomhat",
    "red_mushroomhat",
}

local function HatAntlionPostInit(inst)
    local function OnRepaired(inst, doer, repair_item)
        if doer ~= nil then
            doer:PushEvent("repair")
        end
    end

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.container ~= nil then
        inst.components.container:EnableInfiniteStackSize(true)
    end

    if inst.components.finiteuses ~= nil then
        inst.components.finiteuses:SetMaxUses(TUNING.APO_HATS.ANTLION.USES)
        inst.components.finiteuses:SetUses(TUNING.APO_HATS.ANTLION.USES)
    end

    if inst.components.repairable == nil then
        inst:AddComponent("repairable")
        inst.components.repairable.repairmaterial = _G.MATERIALS.TOWNPORTALTALISMAN
        inst.components.repairable.onrepaired = OnRepaired
        inst.components.repairable.finiteusesrepairable = true
        inst.components.repairable.noannounce = true
    end
end

local function HatBeePostInit(inst)
    inst:AddTag("beefriend")
end

local function HatEarmuffsPostInit(inst)
    _G.APOAddEquipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            owner:AddTag("soundproof")
        end
    end)

    _G.APOAddUnequipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            owner:RemoveTag("soundproof")
        end
    end)
end

local function HatCatcoonPostInit(inst)
    _G.APOAddEquipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            local modifier = TUNING.APO_HATS.CATCOON.HUNGER_MODIFIER

            if owner.components.hunger ~= nil then
                owner.components.hunger.burnratemodifiers:SetModifier(inst, modifier, "catcoonhat")
            end
        end
    end)

    _G.APOAddUnequipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            if owner.components.hunger ~= nil then
                owner.components.hunger.burnratemodifiers:RemoveModifier(inst, "catcoonhat")
            end
        end
    end)
end

local function HatCookieCutterPostInit(inst)
    local function OnCooldown(inst)
        inst.cookiecutter_cooldown = nil
    end

    local function OnDoThorns(inst, owner)
        inst.cookiecutter_cooldown = inst:DoTaskInTime(.3, OnCooldown)

        _G.SpawnPrefab("bramblefx_armor"):SetFXOwner(owner)

        if owner.SoundEmitter ~= nil then
            owner.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
        end
    end

    local function OnBlocked(owner, data, inst)
        if inst.cookiecutter_cooldown == nil and data ~= nil and not data.redirected then
            OnDoThorns(inst, owner)
        end
    end

    _G.APOAddEquipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            inst:ListenForEvent("blocked", inst.cookiecutter_onblocked, owner)
            inst:ListenForEvent("attacked", inst.cookiecutter_onblocked, owner)    
        end
    end)

    _G.APOAddUnequipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            inst:RemoveEventCallback("blocked", inst.cookiecutter_onblocked, owner)
            inst:RemoveEventCallback("attacked", inst.cookiecutter_onblocked, owner)  
        end
    end)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.cookiecutter_onblocked = function(owner, data)
        OnBlocked(owner, data, inst)
    end
end

local function HatFootballPostInit(inst)
    inst.SCANNABLE_RECIPENAME = "wagstaff_goggles_armorhat"
end

local function HatInspectaclesPostInit(inst)
    inst:AddTag("goggles_wagstaff")
end

local function HatMermPostInit(inst)
    local function OnWaxedDirty(inst)
        if inst.waxed:value() then
            inst.displayadjectivefn = function()
                return STRINGS.UI.HUD.WAXED
            end

            if not TheNet:IsDedicated() then
                inst:PushEvent("hide_spoilage")
            end
        end
    end

    local function OnWaxed(inst)
        if not inst.waxed:value() then
            inst:RemoveComponent("perishable")
            inst:RemoveComponent("waxable")

            inst:RemoveTag("show_spoilage")

            inst.waxed:set(true)

            OnWaxedDirty(inst)

            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

            if owner ~= nil then
                local inventory = owner.components.inventory or owner.components.container

                if inventory ~= nil and not inventory:CanTakeItemInSlot(inst) then
                    inventory:DropItem(inst, true, true)
                end
            end

            if inst.components.equippable ~= nil then
                inst.components.equippable.dapperness = 0
            end
        end
    end

    local function OnWax(inst, doer, item)
        OnWaxed(inst)

        return true
    end

    local function OnSave(inst, data)
        data.waxed = inst.waxed:value() or nil
    end

    local function OnLoad(inst, data)
        if data ~= nil and data.waxed then
            OnWaxed(inst)

            inst.waxed:set(true)

            OnWaxedDirty(inst)
        end
    end

    inst:AddTag("waxable")

    inst.waxed = _G.net_bool(inst.GUID, "merm.waxed", "mermwaxeddirty")

    if not _G.TheWorld.ismastersim then
        inst:ListenForEvent("mermwaxeddirty", OnWaxedDirty)

        return inst
    end

    inst:AddComponent("waxable")
    inst.components.waxable:SetWaxfn(OnWax)

    local _OnSave = inst.OnSave

    inst.OnSave = function(inst, data, ...)
        if _OnSave ~= nil then
            _OnSave(inst, data, ...)
        end

        OnSave(inst, data)
    end

    local _OnLoad = inst.OnLoad

    inst.OnLoad = function(inst, data, ...)
        if _OnLoad ~= nil then
            _OnLoad(inst, data, ...)
        end

        OnLoad(inst, data)
    end
end

local function HatMolePostInit(inst)
    inst.SCANNABLE_RECIPENAME = "wagstaff_goggles_heathat"
end

local function HatMoonstormGogglesPostInit(inst)
    inst.SCANNABLE_RECIPENAME = "wagstaff_goggles_shoothat"
end

local function HatMushroomPostInit(inst)
    inst:AddTag("mushroomsource")
end

local function HatRainPostInit(inst)
    _G.APOAddEquipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            if owner.rainhat_fisherman == nil then
                owner.rainhat_fisherman = true
            end
        end
    end)

    _G.APOAddUnequipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            if owner.rainhat_fisherman ~= nil then
                owner.rainhat_fisherman = nil
            end
        end
    end)
end

local function HatRuinsPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if TUNING.APO_TWEAK_ARMORRUINS then
        if inst.components.setbonus == nil then
            inst:AddComponent("setbonus")
            inst.components.setbonus:SetSetName(_G.EQUIPMENTSETNAMES.THULECITE)
        end
    end
end

local function HatSpiderPostInit(inst)
    local function OnGetSpiderBonusDamage(inst, target)
        return (target:HasTag("spider") and TUNING.APO_HATS.SPIDER.MODIFIERS.DAMAGE) or 1
    end

    _G.APOAddEquipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            if owner.components.damagetypebonus ~= nil then
                owner.components.damagetypebonus:AddBonusCallback(OnGetSpiderBonusDamage)
            end
        end
    end)

    _G.APOAddUnequipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            if owner.components.damagetypebonus ~= nil then
                owner.components.damagetypebonus:RemoveBonusCallback(OnGetSpiderBonusDamage)
            end
        end
    end)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.SPIDER.PERISHTIME)
    end
end

local function HatSlurtlePostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("damagetyperesist")
    inst.components.damagetyperesist:AddResist("explosive", inst, TUNING.APO_HATS.SLURTLE.DAMAGETYPE_RESIST)

    if inst.components.setbonus == nil then
        inst:AddComponent("setbonus")
        inst.components.setbonus:SetSetName(_G.EQUIPMENTSETNAMES.SNURTLE)
    end
end

local function HatWatermelonPostInit(inst)
    local function OnWaxedDirty(inst)
        if inst.waxed:value() then
            inst.displayadjectivefn = function()
                return STRINGS.UI.HUD.WAXED
            end

            if not TheNet:IsDedicated() then
                inst:PushEvent("hide_spoilage")
            end
        end
    end

    local function OnWaxed(inst)
        if not inst.waxed:value() then
            inst:RemoveComponent("perishable")
            inst:RemoveComponent("waxable")

            inst:RemoveTag("show_spoilage")

            inst.waxed:set(true)

            OnWaxedDirty(inst)

            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

            if owner ~= nil then
                local inventory = owner.components.inventory or owner.components.container

                if inventory ~= nil and not inventory:CanTakeItemInSlot(inst) then
                    inventory:DropItem(inst, true, true)
                end
            end

            if inst.components.equippable ~= nil then
                inst.components.equippable.dapperness = 0
                inst.components.equippable.equippedmoisture = 0
                inst.components.equippable.maxequippedmoisture = 0
            end
        end
    end

    local function OnWax(inst, doer, item)
        OnWaxed(inst)

        return true
    end

    local function OnSave(inst, data)
        data.waxed = inst.waxed:value() or nil
    end

    local function OnLoad(inst, data)
        if data ~= nil and data.waxed then
            OnWaxed(inst)

            inst.waxed:set(true)

            OnWaxedDirty(inst)
        end
    end

    inst:AddTag("waxable")

    inst.waxed = _G.net_bool(inst.GUID, "watermelon.waxed", "watermelonwaxeddirty")

    if not _G.TheWorld.ismastersim then
        inst:ListenForEvent("watermelonwaxeddirty", OnWaxedDirty)

        return inst
    end

    inst:AddComponent("waxable")
    inst.components.waxable:SetWaxfn(OnWax)

    local _OnSave = inst.OnSave

    inst.OnSave = function(inst, data, ...)
        if _OnSave ~= nil then
            _OnSave(inst, data, ...)
        end

        OnSave(inst, data)
    end

    local _OnLoad = inst.OnLoad

    inst.OnLoad = function(inst, data, ...)
        if _OnLoad ~= nil then
            _OnLoad(inst, data, ...)
        end

        OnLoad(inst, data)
    end
end

local function HatWinterPostInit(inst)
    local function OnApplyStatus(inst, bonus)
        if inst.winter_bonusstats then
            return false
        end

        inst.winter_bonusstats = bonus

        if inst.components.health ~= nil then
            local current_health = inst.health_percent or inst.components.health:GetPercent()
            inst.health_percent = nil

            inst.components.health:SetMaxHealth(inst.components.health.maxhealth + bonus)
            inst.components.health:SetPercent(current_health)
        end

        if inst.components.hunger ~= nil then
            local current_hunger = inst.hunger_percent or inst.components.hunger:GetPercent()
            inst.hunger_percent = nil

            inst.components.hunger:SetMax(inst.components.hunger.max + bonus)
            inst.components.hunger:SetPercent(current_hunger)
        end

        if inst.components.sanity ~= nil then
            local current_sanity = inst.sanity_percent or inst.components.sanity:GetPercent()
            inst.sanity_percent = nil

            inst.components.sanity:SetMax(inst.components.sanity.max + bonus)
            inst.components.sanity:SetPercent(current_sanity)
        end

        return true
    end

    local function OnRemoveStatus(inst)
        if not inst.winter_bonusstats then
            return
        end

        if inst.components.health ~= nil then
            local current_health = inst.health_percent or inst.components.health:GetPercent()
            inst.health_percent = nil

            inst.components.health:SetMaxHealth(inst.components.health.maxhealth - inst.winter_bonusstats)
            inst.components.health:SetPercent(current_health)
        end

        if inst.components.hunger ~= nil then
            local current_hunger = inst.hunger_percent or inst.components.hunger:GetPercent()
            inst.hunger_percent = nil

            inst.components.hunger:SetMax(inst.components.hunger.max - inst.winter_bonusstats)
            inst.components.hunger:SetPercent(current_hunger)
        end

        if inst.components.sanity ~= nil then
            local current_sanity = inst.sanity_percent or inst.components.sanity:GetPercent()
            inst.sanity_percent = nil

            inst.components.sanity:SetMax(inst.components.sanity.max - inst.winter_bonusstats)
            inst.components.sanity:SetPercent(current_sanity)
        end

        inst.winter_bonusstats = nil
    end

    local function OnUpdateStatus(owner, season)
        if season == "winter" then
            OnApplyStatus(owner, TUNING.APO_HATS.WINTER.BONUS)
        else
            OnRemoveStatus(owner)
        end
    end

    _G.APOAddEquipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            owner:WatchWorldState("season", OnUpdateStatus)

            OnUpdateStatus(owner, _G.TheWorld.state.season)
        end
    end)

    _G.APOAddUnequipCallbacks(inst, function(inst, owner)
        if owner ~= nil then
            owner:StopWatchingWorldState("season", OnUpdateStatus)

            OnRemoveStatus(owner)
        end
    end)
end

if TUNING.APO_TWEAK_ANTLIONHAT then
    AddPrefabPostInit("antlionhat", HatAntlionPostInit)
end

if TUNING.APO_TWEAK_BEEHAT then
    for k, v in pairs(HATS_BEE) do
        AddPrefabPostInit(v, HatBeePostInit)
    end
end

if TUNING.APO_TWEAK_CATCOONHAT then
    AddPrefabPostInit("catcoonhat", HatCatcoonPostInit)
end

if TUNING.APO_TWEAK_COOKIECUTTERHAT then
    AddPrefabPostInit("cookiecutterhat", HatCookieCutterPostInit)
end

if TUNING.APO_TWEAK_EARMUFFSHAT then
    AddPrefabPostInit("earmuffshat", HatEarmuffsPostInit)
end

if TUNING.APO_TWEAK_INSPECTACLESHAT then
    AddPrefabPostInit("inspectacleshat", HatInspectaclesPostInit)
end

if TUNING.APO_TWEAK_MERMHAT then
    AddPrefabPostInit("mermhat", HatMermPostInit)
end

if TUNING.APO_TWEAK_MUSHROOMHAT then
    for k, v in pairs(HATS_MUSHROOM) do
        AddPrefabPostInit(v, HatMushroomPostInit)
    end
end

if TUNING.APO_TWEAK_RAINHAT then
    AddPrefabPostInit("rainhat", HatRainPostInit)
end

if TUNING.APO_TWEAK_SLURTLEHAT then
    AddPrefabPostInit("slurtlehat", HatSlurtlePostInit)
end

if TUNING.APO_TWEAK_SPIDERHAT then
    AddPrefabPostInit("spiderhat", HatSpiderPostInit)
end

if TUNING.APO_TWEAK_WATERMELONHAT then
    AddPrefabPostInit("watermelonhat", HatWatermelonPostInit)
end

if TUNING.APO_TWEAK_WINTERHAT then
    AddPrefabPostInit("winterhat", HatWinterPostInit)
end

AddPrefabPostInit("footballhat",          HatFootballPostInit)
AddPrefabPostInit("molehat",              HatMolePostInit)
AddPrefabPostInit("moonstorm_goggleshat", HatMoonstormGogglesPostInit)
AddPrefabPostInit("ruinshat",             HatRuinsPostInit)