-- Client-side checks for Island Adventures and Above the Couds Mods.
function APORecipeAlreadyExists(...)
    for _, recipe in ipairs({...}) do
        if AllRecipes[recipe] ~= nil then
            return true
        end
    end

    return false
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
                elseif item.components.armor ~= nil
                    and not item.components.armor:IsIndestructible() then

                    local armor = item.components.armor
                    local absorbed = math.min(damage, armor.condition * item_damage_per_use)

                    armor:TakeDamage(absorbed / item_damage_per_use)
                    damage = damage - absorbed
                end
            end

            if damage <= 0 then
                return 0
            end
        end
    end

    return damage
end