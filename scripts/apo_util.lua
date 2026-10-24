local APOCheckLocalCanSee = 1

function APOGetCheckLocalCanSee()
    return APOCheckLocalCanSee
end

function APOPushCheckLocalEntityCanSee()
    APOCheckLocalCanSee = APOCheckLocalCanSee + 1
end

function APOPopCheckLocalEntityCanSee()
    APOCheckLocalCanSee = APOCheckLocalCanSee - 1
    assert(APOCheckLocalCanSee >= 0)
end

-- Client-side checks for Island Adventures and Above the Couds Mods.
function APORecipeAlreadyExists(...)
    for _, recipe in ipairs({...}) do
        if AllRecipes[recipe] ~= nil then
            return true
        end
    end

    return false
end

function APOAddEquipCallbacks(inst, onequip_extra_pre_fn, onequip_extra_post_fn)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.equippable ~= nil then
        local _onequipfn = inst.components.equippable.onequipfn
    
        if _onequipfn ~= nil then
            inst.components.equippable.onequipfn = function(inst, owner, ...)
                if onequip_extra_pre_fn ~= nil then
                    onequip_extra_pre_fn(inst, owner, ...)
                end

                _onequipfn(inst, owner, ...)

                if onequip_extra_post_fn ~= nil then
                    onequip_extra_post_fn(inst, owner, ...)
                end
            end
        end
    end
end

function APOAddUnequipCallbacks(inst, onunequip_extra_pre_fn, onunequip_extra_post_fn)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.equippable ~= nil then
        local _onunequipfn = inst.components.equippable.onunequipfn
    
        if _onunequipfn ~= nil then
            inst.components.equippable.onunequipfn = function(inst, owner, ...)
                if onunequip_extra_pre_fn ~= nil then
                    onunequip_extra_pre_fn(inst, owner, ...)
                end

                _onunequipfn(inst, owner, ...)

                if onunequip_extra_post_fn ~= nil then
                    onunequip_extra_post_fn(inst, owner, ...)
                end
            end
        end
    end
end

function APOAbsorbTemperatureDamage(inst, damage, damage_per_use, tag)
    if damage <= 0 or damage_per_use == nil or damage_per_use <= 0 then
        return damage
    end

    if inst.components.inventory == nil then
        return damage
    end

    local slots = { EQUIPSLOTS.HANDS, EQUIPSLOTS.BODY, EQUIPSLOTS.HEAD }

    if TUNING.APO_IS_OAE_ENABLED then
        if TUNING.APO_DEBUG_MODE then
            print("Apparels Overload Mod - Odds and Ends is not enabled!")
            print("Apparels Overload Mod - Adding PLAYERACCESORY to APOAbsorbTemperatureDamage.")
        end

        table.insert(slots, EQUIPSLOTS.PLAYERACCESSORY)
    end

    for _, slot in ipairs(slots) do
        local item = inst.components.inventory:GetEquippedItem(slot)

        if item ~= nil and item:HasTag(tag) then
            local item_damage_per_use = damage_per_use

            if tag == "absorbsfreezing" then
                item_damage_per_use = item.freezing_damage or damage_per_use
            elseif tag == "absorbsoverheat" then
                item_damage_per_use = item.overheat_damage or damage_per_use
            end

            if item_damage_per_use > 0 then
                if item.components.finiteuses ~= nil then
                    local uses_available = item.components.finiteuses:GetUses()

                    if uses_available > 0 then
                        local uses = math.min(damage / item_damage_per_use, uses_available)
                        local absorbed = uses * item_damage_per_use

                        item.components.finiteuses:Use(uses)
                        damage = damage - absorbed
                    end
                elseif item.components.armor ~= nil and not item.components.armor:IsIndestructible() then
                    local absorbed = math.min(damage, item.components.armor.condition * item_damage_per_use)

                    item.components.armor:TakeDamage(absorbed / item_damage_per_use)
                    damage = damage - absorbed
                elseif item.components.perishable ~= nil and item.components.perishable:IsPerishing() then
                    local absorbed = math.min(damage, item_damage_per_use)
                    local perish_damage = item.perish_damage or 0.01
                    local perish_percent = absorbed / (item_damage_per_use) * perish_damage

                    item.components.perishable:ReducePercent(perish_percent)
                    damage = damage - absorbed
                elseif item.components.fueled ~= nil then
                    local uses_available = item.components.fueled.currentfuel
                    local fuel_per_damage = item.components.fueled.maxfuel * 0.01

                    if uses_available > 0 then
                        local uses = math.min(damage / item_damage_per_use * fuel_per_damage, uses_available)
                        local absorbed = uses / fuel_per_damage * item_damage_per_use

                        item.components.fueled:DoDelta(-uses)
                        damage = damage - absorbed
                    end
                end
            end

            if damage <= 0 then
                return 0
            end
        end
    end

    return damage
end

function APOIsLostTechRecipe(recipe)
    for techname, level in pairs(TECH.LOST) do
        if recipe.level[techname] ~= level then
            return false
        end
    end

    for techname, level in pairs(recipe.level) do
        if TECH.LOST[techname] ~= level then
            return false
        end
    end

    return true
end

function APOIsSpecialEventTech(recipe)
    if recipe.hint_msg == nil then
        return false
    end

    local event = BRAINJELLY_SPECIAL_EVENTS[recipe.hint_msg]
    return event ~= nil and not IsSpecialEventActive(event)
end

function APOCanBrainJellyHatUnlockRecipe(builder, recipe)
    if APOIsLostTechRecipe(recipe) then
        return false -- Blocks recipes that requires Blueprint.
    end

    if APOIsSpecialEventTech(recipe) then
        return false -- Blocks recipes from inactive Special Events.
    end

    if recipe.nobrainjellyhat then
        return false
    end

    if recipe.actionstr ~= nil and string.find(recipe.actionstr, "SHOP") then
        return false
    end

    if recipe.name ~= nil and string.find(recipe.name, "shop") then
        return false
    end

    if recipe.hint_msg ~= nil and string.find(recipe.hint_msg, "HERMITCRAB") then
        return false
    end

    if recipe.name ~= nil and string.find(recipe.name, "hermitcrab") then
        return false
    end

    for techname, level in pairs(recipe.level) do
        if level ~= 0 and (BRAINJELLY_TECH_BLACKLIST[techname] or (TECH.BRAINJELLY[techname] or 0) == 0) then
            return false
        end
    end

    for i, v in ipairs(recipe.tech_ingredients) do
        if not builder:HasTechIngredient(v) then
            return false
        end
    end

    return (recipe.builder_tag == nil or builder.inst:HasTag(recipe.builder_tag))
end