local hat_fns3 = {}

local function MakeHat(name)
    local hat_fns    = {}
    local fname      = "hat_"..name
    local symname    = name.."hat"
    local prefabname = symname

    local swap_data = { bank = symname, anim = "anim" }

    local function _base_onequip(inst, owner, symbol_override, swap_hat_override)
        if owner ~= nil then
            local skin_build = inst:GetSkinBuild()

            if skin_build ~= nil then
                owner:PushEvent("equipskinneditem", inst:GetSkinName())
                owner.AnimState:OverrideItemSkinSymbol(swap_hat_override or "swap_hat", skin_build, symbol_override or "swap_hat", inst.GUID, fname)
            else
                owner.AnimState:OverrideSymbol(swap_hat_override or "swap_hat", fname, symbol_override or "swap_hat")
            end

            if inst.components.fueled ~= nil then
                inst.components.fueled:StartConsuming()
            end

            if inst.skin_equip_sound and owner.SoundEmitter then
                owner.SoundEmitter:PlaySound(inst.skin_equip_sound)
            end
        end
    end

    local function _onequip(inst, owner, symbol_override, headbase_hat_override)
        if owner ~= nil then
            _base_onequip(inst, owner, symbol_override)

            owner.AnimState:ClearOverrideSymbol("headbase_hat")

            if headbase_hat_override ~= nil then
                local skin_build = owner.AnimState:GetSkinBuild()

                if skin_build ~= "" then
                    owner.AnimState:OverrideSkinSymbol("headbase_hat", skin_build, headbase_hat_override)
                else
                    local build = owner.AnimState:GetBuild()
                    owner.AnimState:OverrideSymbol("headbase_hat", build, headbase_hat_override)
                end
            end

            owner.AnimState:Show("HAT")
            owner.AnimState:Show("HAIR_HAT")
            owner.AnimState:Hide("HAIR_NOHAT")
            owner.AnimState:Hide("HAIR")

            if owner.isplayer then
                owner.AnimState:Hide("HEAD")
                owner.AnimState:Show("HEAD_HAT")
                owner.AnimState:Show("HEAD_HAT_NOHELM")
                owner.AnimState:Hide("HEAD_HAT_HELM")
            end
        end
    end

    local function _onunequip(inst, owner)
        if owner ~= nil then
            local skin_build = inst:GetSkinBuild()

            if skin_build ~= nil then
                owner:PushEvent("unequipskinneditem", inst:GetSkinName())
            end

            owner.AnimState:ClearOverrideSymbol("headbase_hat")

            if owner.components.skinner ~= nil then
                owner.components.skinner.base_change_cb = owner.old_base_change_cb
            end

            owner.AnimState:ClearOverrideSymbol("swap_hat")

            owner.AnimState:Hide("HAT")
            owner.AnimState:Hide("HAIR_HAT")
            owner.AnimState:Show("HAIR_NOHAT")
            owner.AnimState:Show("HAIR")

            if owner.isplayer then
                owner.AnimState:Show("HEAD")
                owner.AnimState:Hide("HEAD_HAT")
                owner.AnimState:Hide("HEAD_HAT_NOHELM")
                owner.AnimState:Hide("HEAD_HAT_HELM")
            end

            if inst.components.fueled ~= nil then
                inst.components.fueled:StopConsuming()
            end
        end
    end

    hat_fns.simple_onperish = function(inst, owner)
        inst:Remove()
    end

    hat_fns.simple_onequip = function(inst, owner, from_ground)
        if owner ~= nil then
            _onequip(inst, owner)
        end
    end

    hat_fns.simple_onunequip = function(inst, owner, from_ground)
        if owner ~= nil then
            _onunequip(inst, owner)
        end
    end

    hat_fns.opentop_onequip = function(inst, owner)
        if owner ~= nil then
            _base_onequip(inst, owner)

            owner.AnimState:Show("HAT")
            owner.AnimState:Hide("HAIR_HAT")
            owner.AnimState:Show("HAIR_NOHAT")
            owner.AnimState:Show("HAIR")

            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
            owner.AnimState:Hide("HEAD_HAT_NOHELM")
            owner.AnimState:Hide("HEAD_HAT_HELM")
        end
    end

    hat_fns.fullhelm_onequip = function(inst, owner)
        if owner ~= nil then
            if owner.isplayer then
                _base_onequip(inst, owner, nil, "headbase_hat")

                owner.AnimState:Hide("HAT")
                owner.AnimState:Hide("HAIR_HAT")
                owner.AnimState:Hide("HAIR_NOHAT")
                owner.AnimState:Hide("HAIR")

                owner.AnimState:Hide("HEAD")
                owner.AnimState:Show("HEAD_HAT")
                owner.AnimState:Hide("HEAD_HAT_NOHELM")
                owner.AnimState:Show("HEAD_HAT_HELM")

                owner.AnimState:HideSymbol("face")
                owner.AnimState:HideSymbol("swap_face")
                owner.AnimState:HideSymbol("beard")
                owner.AnimState:HideSymbol("cheeks")

                owner.AnimState:UseHeadHatExchange(true)
            else
                _base_onequip(inst, owner)

                owner.AnimState:Show("HAT")
                owner.AnimState:Hide("HAIR_HAT")
                owner.AnimState:Hide("HAIR_NOHAT")
                owner.AnimState:Hide("HAIR")
            end
        end
    end

    hat_fns.fullhelm_onunequip = function(inst, owner)
        if owner ~= nil then
            _onunequip(inst, owner)

            if owner.isplayer then
                owner.AnimState:ShowSymbol("face")
                owner.AnimState:ShowSymbol("swap_face")
                owner.AnimState:ShowSymbol("beard")
                owner.AnimState:ShowSymbol("cheeks")

                owner.AnimState:UseHeadHatExchange(false)
            end
        end
    end

    hat_fns.simple_onequiptomodel = function(inst, owner, from_ground)
        if owner ~= nil then
            if inst.components.fueled ~= nil then
                inst.components.fueled:StopConsuming()
            end
        end
    end

    local _skinhat_fns =
    {
        simple_onperish       = hat_fns.simple_onperish,
        simple_onequip        = hat_fns.simple_onequip,
        simple_onunequip      = hat_fns.simple_onunequip,
        opentop_onequip       = hat_fns.opentop_onequip,
        fullhelm_onequip      = hat_fns.fullhelm_onequip,
        fullhelm_onunequip    = hat_fns.fullhelm_onunequip,
        simple_onequiptomodel = hat_fns.simple_onequiptomodel,
    }

    local function simple(custom_init)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst)
        inst.components.floater:SetBankSwapOnFloat(false, nil, swap_data)

        inst.AnimState:SetBank(symname)
        inst.AnimState:SetBuild(fname)
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("hat")

        inst:AddComponent("snowmandecor")

        if custom_init ~= nil then
            custom_init(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst._skinhat_fns = _skinhat_fns

        inst:AddComponent("tradable")
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(hat_fns.simple_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.simple_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.simple_onequiptomodel)

        MakeHauntableLaunch(inst)

        return inst
    end

    hat_fns.bucket_onresistdamage = function(inst, damage)
        if inst.components.armor ~= nil then
            inst.components.armor:TakeDamage(damage)
        end
    end

    hat_fns.bucket_custom_init = function(inst)
        inst:AddTag("wood")
    end

    hat_fns.bucket = function()
        local inst = simple(hat_fns.bucket_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.APO_HATS.BUCKET.CONDITION, TUNING.APO_HATS.BUCKET.ABSORPTION)
        inst.components.armor:AddWeakness("beaver", TUNING.BEAVER_WOOD_DAMAGE)

        inst:AddComponent("resistance")
        inst.components.resistance:AddResistance("quakedebris")
        inst.components.resistance:AddResistance("lunarhaildebris")
        inst.components.resistance:SetOnResistDamageFn(hat_fns.bucket_onresistdamage)

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        return inst
    end

    hat_fns.carnival_host_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            inst:AddTag("luckysource")

            if owner.components.luckuser ~= nil then
                owner.components.luckuser:SetLuckSource(TUNING.APO_HATS.CARNIVAL_HOST.LUCK, inst)
            end
        end
    end

    hat_fns.carnival_host_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            inst:RemoveTag("luckysource")

            if owner.components.luckuser ~= nil then
                owner.components.luckuser:RemoveLuckSource(inst)
            end
        end
    end

    hat_fns.carnival_host_custom_init = function(inst)
        inst:AddTag("carnivalwinner")
    end

    hat_fns.carnival_host = function()
        local inst = simple(hat_fns.carnival_host_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.carnival_host_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.carnival_host_onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE
        inst.components.equippable.walkspeedmult = TUNING.APO_HATS.CARNIVAL_HOST.WALKSPEEDMULT

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.CARNIVAL_HOST.PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)

        return inst
    end

    hat_fns.extraheavy_getsetbonusequip = function(inst, owner)
        local body = owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil
        return body ~= nil and body.prefab == "armormarble" and body or nil
    end

    hat_fns.extraheavy_custom_init = function(inst)
        inst:AddTag("marble")
        inst:AddTag("heavyarmor")
        inst:AddTag("hardarmor")
    end

    hat_fns.extraheavy = function()
        local inst = simple(hat_fns.extraheavy_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable.walkspeedmult = TUNING.APO_HATS.EXTRAHEAVY.WALKSPEEDMULT

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.APO_HATS.EXTRAHEAVY.CONDITION, TUNING.APO_HATS.EXTRAHEAVY.ABSORPTION)

        inst:AddComponent("setbonus")
        inst.components.setbonus:SetSetName(EQUIPMENTSETNAMES.MARBLE)

        return inst
    end

    hat_fns.foodbasket_onapplybonus = function(inst, bonus)
        if inst.foodbasket_bonushunger then
            return false
        end

        inst.foodbasket_bonushunger = bonus

        if inst.components.hunger ~= nil then
            local current_hunger = inst.hunger_percent or inst.components.hunger:GetPercent()
            inst.hunger_percent = nil

            inst.components.hunger:SetMax(inst.components.hunger.max + bonus)
            inst.components.hunger:SetPercent(current_hunger)
        end

        return true
    end

    hat_fns.foodbasket_onremovebonus = function(inst)
        if not inst.foodbasket_bonushunger then
            return
        end

        if inst.components.hunger ~= nil then
            local current_hunger = inst.hunger_percent or inst.components.hunger:GetPercent()
            inst.hunger_percent = nil

            inst.components.hunger:SetMax(inst.components.hunger.max - inst.foodbasket_bonushunger)
            inst.components.hunger:SetPercent(current_hunger)
        end

        inst.foodbasket_bonushunger = nil
    end

    hat_fns.foodbasket_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            local bonus = TUNING.APO_HATS.FOODBASKET.BONUS
            local modifier = TUNING.APO_HATS.FOODBASKET.HUNGER_MODIFIER
 
            hat_fns.foodbasket_onapplybonus(owner, bonus)

            if owner.components.hunger ~= nil then
                owner.components.hunger.burnratemodifiers:SetModifier(inst, modifier, "foodbaskethat")
            end
        end
    end

    hat_fns.foodbasket_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            hat_fns.foodbasket_onremovebonus(owner)

            if owner.components.hunger ~= nil then
                owner.components.hunger.burnratemodifiers:RemoveModifier(inst, "foodbaskethat")
            end
        end
    end

    hat_fns.foodbasket_custom_init = function(inst)
        inst:AddTag("icebox_valid")
        inst:AddTag("show_spoilage")
    end

    hat_fns.foodbasket = function()
        local inst = simple(hat_fns.foodbasket_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.foodbasket_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.foodbasket_onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
        inst.components.equippable.flipdapperonmerms = true

        inst:AddComponent("forcecompostable")
        inst.components.forcecompostable.green = true

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
        inst.components.perishable:SetOnPerishFn(inst.Remove)
        inst.components.perishable:StartPerishing()

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end

    hat_fns.foodbonus_oneatfood = function(inst, data)
        local food = data ~= nil and data.food or nil

        local hat = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
        hat = hat ~= nil and hat.components.perishable or nil

        local perishpercent = hat ~= nil and hat:GetPercent() or 1
        local bonus = TUNING.APO_HATS.FOODBONUS.BONUS * perishpercent

        if food ~= nil and food.components.edible ~= nil then
            local health = food.components.edible:GetHealth(inst)
            local hunger = food.components.edible:GetHunger(inst)
            local sanity = food.components.edible:GetSanity(inst)

            if health > 0 and inst.components.health ~= nil then
                inst.components.health:DoDelta(health * bonus, nil, "foodbonushat")
            end

            if hunger > 0 and inst.components.hunger ~= nil then
                inst.components.hunger:DoDelta(hunger * bonus)
            end

            if sanity > 0 and inst.components.sanity ~= nil then
                inst.components.sanity:DoDelta(sanity * bonus)
            end
        end
    end

    hat_fns.foodbonus_onequip = function(inst, owner)
        hat_fns.opentop_onequip(inst, owner)

        if owner ~= nil then
            if owner.foodbonus_oneat == nil then
                owner.foodbonus_oneat = function(player, data)
                    hat_fns.foodbonus_oneatfood(player, data)
                end

                owner:ListenForEvent("oneat", owner.foodbonus_oneat)
            end
        end
    end

    hat_fns.foodbonus_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            if owner.foodbonus_oneat ~= nil then
                owner:RemoveEventCallback("oneat", owner.foodbonus_oneat)
            end
        end

        owner.foodbonus_oneat = nil
    end

    hat_fns.foodbonus_custom_init = function(inst)
        inst:AddTag("gestaltprotection")
        inst:AddTag("open_top_hat")
        inst:AddTag("show_spoilage")
    end

    hat_fns.foodbonus = function()
        local inst = simple(hat_fns.foodbonus_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("forcecompostable")
        inst.components.forcecompostable.green = true

        inst.components.equippable:SetOnEquip(hat_fns.foodbonus_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.foodbonus_onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
        inst.components.equippable.flipdapperonmerms = true

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
        inst.components.perishable:SetOnPerishFn(inst.Remove)
        inst.components.perishable:StartPerishing()

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end

    hat_fns.healingbonus_onapplybonus = function(inst, bonus)
        if inst.healingbonus_bonushealth then
            return false
        end

        inst.healingbonus_bonushealth = bonus

        if inst.components.health ~= nil then
            local current_health = inst.health_percent or inst.components.health:GetPercent()
            inst.health_percent = nil

            inst.components.health:SetMaxHealth(inst.components.health.maxhealth + bonus)
            inst.components.health:SetPercent(current_health)
        end

        return true
    end

    hat_fns.healingbonus_onremovebonus = function(inst)
        if not inst.healingbonus_bonushealth then
            return
        end

        if inst.components.health ~= nil then
            local current_health = inst.health_percent or inst.components.health:GetPercent()
            inst.health_percent = nil

            inst.components.health:SetMaxHealth(inst.components.health.maxhealth - inst.healingbonus_bonushealth)
            inst.components.health:SetPercent(current_health)
        end

        inst.healingbonus_bonushealth = nil
    end

    hat_fns.healingbonus_onregen = function(inst, owner)
        local THRESHOLD = TUNING.APO_HATS.HEALINGBONUS.REGEN.THRESHOLD
        local AMOUNT = TUNING.APO_HATS.HEALINGBONUS.REGEN.AMOUNT

        if owner ~= nil and owner.components.health ~= nil and not owner.components.health:IsDead() then
            if owner.components.health:GetPercent() < THRESHOLD then
                owner.components.health:DoDelta(AMOUNT, nil, "healingbonushat")
            end
        end
    end

    hat_fns.healthbonus_onstopregen = function(inst, owner)
        if inst.healingbonus_regen ~= nil then
            inst.healingbonus_regen:Cancel()
            inst.healingbonus_regen = nil
        end

        if owner ~= nil then
            owner:PushEvent("healthregenactive", { active = false })
        end
    end

    hat_fns.healthbonus_onstartregen = function(inst, owner)
        if inst.healingbonus_regen ~= nil then
            return
        end

        local AMOUNT = TUNING.APO_HATS.HEALINGBONUS.REGEN.AMOUNT
        local PERIOD = TUNING.APO_HATS.HEALINGBONUS.REGEN.PERIOD
        local THRESHOLD = TUNING.APO_HATS.HEALINGBONUS.REGEN.THRESHOLD

        if owner ~= nil then
            if owner.components.health ~= nil and owner.components.health:GetPercent() >= THRESHOLD then
                return
            end

            inst.healingbonus_regen = inst:DoPeriodicTask(PERIOD, function()
                if owner.components.health ~= nil and owner.components.health:GetPercent() >= THRESHOLD then
                    hat_fns.healthbonus_onstopregen(inst, owner)

                    return
                end

                hat_fns.healingbonus_onregen(inst, owner)
            end)

            owner:PushEvent("healthregenactive", { active = true })
        end
    end

    hat_fns.healingbonus_onequip = function(inst, owner)
        hat_fns.opentop_onequip(inst, owner)

        if owner ~= nil then
            local bonus = TUNING.APO_HATS.HEALINGBONUS.BONUS
            local THRESHOLD = TUNING.APO_HATS.HEALINGBONUS.REGEN.THRESHOLD

            hat_fns.healingbonus_onapplybonus(owner, bonus)

            inst.healthbonus_healthdelta = function(owner)
                if owner.components.health ~= nil then
                    if owner.components.health:GetPercent() >= THRESHOLD then
                        hat_fns.healthbonus_onstopregen(inst, owner)
                    else
                        hat_fns.healthbonus_onstartregen(inst, owner)
                    end
                end
            end

            owner:ListenForEvent("healthdelta", inst.healthbonus_healthdelta)

            inst.healthbonus_healthdelta(owner)
        end
    end

    hat_fns.healingbonus_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            hat_fns.healingbonus_onremovebonus(owner)

            if inst.healthbonus_healthdelta ~= nil then
                owner:RemoveEventCallback("healthdelta", inst.healthbonus_healthdelta)

                inst.healthbonus_healthdelta = nil
            end
        end

        hat_fns.healthbonus_onstopregen(inst, owner)
    end

    hat_fns.healingbonus_onequiptomodel = function(inst, owner, from_ground)
        hat_fns.simple_onequiptomodel(inst, owner, from_ground)

        if owner ~= nil then
            if inst.healthbonus_healthdelta ~= nil then
                owner:RemoveEventCallback("healthdelta", inst.healthbonus_healthdelta)

                inst.healthbonus_healthdelta = nil
            end
        end

        hat_fns.healthbonus_onstopregen(inst, owner)
    end

    hat_fns.healingbonus_custom_init = function(inst)
        inst:AddTag("gestaltprotection")
        inst:AddTag("open_top_hat")
        inst:AddTag("show_spoilage")
    end

    hat_fns.healingbonus = function()
        local inst = simple(hat_fns.healingbonus_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("forcecompostable")
        inst.components.forcecompostable.green = true

        inst.components.equippable:SetOnEquip(hat_fns.healingbonus_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.healingbonus_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.healingbonus_onequiptomodel)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
        inst.components.equippable.flipdapperonmerms = true

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
        inst.components.perishable:SetOnPerishFn(inst.Remove)
        inst.components.perishable:StartPerishing()

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end

    hat_fns.jiaolian_custom_init = function(inst)
        inst:AddTag("open_top_hat")
    end

    hat_fns.jiaolian = function()
        local inst = simple(hat_fns.jiaolian_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.opentop_onequip)

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.APO_HATS.JIAOLIAN.CONDITION, TUNING.APO_HATS.JIAOLIAN.ABSORPTION)
        inst.components.armor:SetTags(TUNING.APO_HATS.JIAOLIAN.TAGS)

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        return inst
    end

    hat_fns.lifesteal_onattack = function(owner, data)
        if owner ~= nil and data ~= nil then
            local target = data.target

            if target ~= nil and target:IsValid() then
                if owner.components.health ~= nil and not owner.components.health:IsHurt()
                or target:HasOneOfTags(NON_LIFEFORM_TARGET_TAGS) then
                    return
                end

                local amount = TUNING.APO_HATS.LIFESTEAL.LIFESTEAL.AMOUNT
                local amount_loss = TUNING.APO_HATS.LIFESTEAL.LIFESTEAL.LOSS
                local sanity_cost = amount * amount_loss

                if owner.components.sanity ~= nil and owner.components.sanity.current < sanity_cost then
                    return
                end

                local mult = owner.components.aoediminishingreturns ~= nil
                and owner.components.aoediminishingreturns.mult:Get() or 1

                if owner.components.health ~= nil then
                    owner.components.health:DoDelta(amount * mult, false, "lifestealhat")
                end

                if owner.components.sanity ~= nil then
                    owner.components.sanity:DoDelta(-amount * amount_loss)
                end

                local hat = owner.components.inventory ~= nil
                and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil

                if hat ~= nil and hat:HasTag("lifestealsource") then
                    if hat.components.finiteuses ~= nil then
                        hat.components.finiteuses:Use(1)
                    end
                end
            end
        end
    end

    hat_fns.lifesteal_onequip = function(inst, owner)
        hat_fns.opentop_onequip(inst, owner)

        if owner ~= nil then
            inst.lifesteal_owner = owner

            owner:ListenForEvent("onhitother", inst.lifesteal_onattack)
        end
    end

    hat_fns.lifesteal_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            owner:RemoveEventCallback("onhitother", inst.lifesteal_onattack)
        end

        inst.lifesteal_owner = nil
    end

    hat_fns.lifesteal_onperish = function(inst, owner)
        if owner ~= nil then
            owner:RemoveEventCallback("onhitother", inst.lifesteal_onattack)
        end

        inst.lifesteal_owner = nil

        hat_fns.simple_onperish(inst)
    end

    hat_fns.lifesteal_custom_init = function(inst)
        inst:AddTag("shadowlevel")
        inst:AddTag("lifestealsource")
    end

    hat_fns.lifesteal = function()
        local inst = simple(hat_fns.lifesteal_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.lifesteal_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.lifesteal_onunequip)
        inst.components.equippable.dapperness = -TUNING.DAPPERNESS_MED
        inst.components.equippable.walkspeedmult = TUNING.APO_HATS.LIFESTEAL.WALKSPEEDMULT
        inst.components.equippable.is_magic_dapperness = true

        inst:AddComponent("shadowlevel")
        inst.components.shadowlevel:SetDefaultLevel(TUNING.APO_HATS.LIFESTEAL.SHADOWLEVEL)

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.APO_HATS.LIFESTEAL.USES)
        inst.components.finiteuses:SetUses(TUNING.APO_HATS.LIFESTEAL.USES)
        inst.components.finiteuses:SetOnFinished(hat_fns.lifesteal_onperish)

        inst.lifesteal_onattack = hat_fns.lifesteal_onattack

        return inst
    end

    hat_fns.minotaurcrown_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            if owner.components.combat ~= nil then
                local MODIFIER = TUNING.APO_HATS.MINOTAURCROWN.MODIFIER

                inst._min_attack_period = owner.components.combat.min_attack_period

                owner.components.combat:SetAttackPeriod(inst._min_attack_period * inst.attackspeedsource_mult)
                owner.components.combat.externaldamagemultipliers:SetModifier(owner, MODIFIER, "minotaurcrownhat")
            end
        end
    end

    hat_fns.minotaurcrown_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            if owner.components.combat ~= nil then
                if inst._min_attack_period ~= nil then
                    owner.components.combat:SetAttackPeriod(inst._min_attack_period)
                end

                owner.components.combat.externaldamagemultipliers:RemoveModifier(owner, "minotaurcrownhat")
            end
        end

        inst._min_attack_period = nil
    end

    hat_fns.minotaurcrown_custom_init = function(inst)
        inst:AddTag("attackspeedsource")
        inst:AddTag("shadowlevel")
    end

    hat_fns.minotaurcrown = function()
        local inst = simple(hat_fns.minotaurcrown_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.attackspeedsource_mult = TUNING.APO_HATS.MINOTAURCROWN.MIN_ATTACK_PERIOD_MULT

        inst.components.equippable:SetOnEquip(hat_fns.minotaurcrown_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.minotaurcrown_onunequip)
        inst.components.equippable.walkspeedmult = TUNING.APO_HATS.MINOTAURCROWN.WALKSPEEDMULT

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.APO_HATS.MINOTAURCROWN.CONDITION, TUNING.APO_HATS.MINOTAURCROWN.ABSORPTION)

        inst:AddComponent("shadowlevel")
        inst.components.shadowlevel:SetDefaultLevel(TUNING.APO_HATS.MINOTAURCROWN.SHADOWLEVEL)

        return inst
    end

    hat_fns.peagawkfeather_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            local birdattractor = owner.components.birdattractor

            if birdattractor ~= nil then
                birdattractor.spawnmodifier:SetModifier(inst, TUNING.APO_HATS.PEAGAWKFEATHER.BIRD_SPAWN_MAXDELTA, "maxbirds")
                birdattractor.spawnmodifier:SetModifier(inst, TUNING.APO_HATS.PEAGAWKFEATHER.BIRD_SPAWN_DELAYDELTA.MIN, "mindelay")
                birdattractor.spawnmodifier:SetModifier(inst, TUNING.APO_HATS.PEAGAWKFEATHER.BIRD_SPAWN_DELAYDELTA.MAX, "maxdelay")

                if TheWorld.components.birdspawner ~= nil then
                    TheWorld.components.birdspawner:ToggleUpdate(true)
                end

                -- Heap of Foods Nocturnal Birds...
                if TheWorld.components.nightbirdspawner ~= nil then
                    TheWorld.components.nightbirdspawner:ToggleUpdate(true)
                end
            end
        end
    end

    hat_fns.peagawkfeather_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            local attractor = owner.components.birdattractor

            if attractor ~= nil then
                attractor.spawnmodifier:RemoveModifier(inst)

                if TheWorld.components.birdspawner ~= nil then
                    TheWorld.components.birdspawner:ToggleUpdate(true)
                end

                if TheWorld.components.nightbirdspawner ~= nil then
                    TheWorld.components.nightbirdspawner:ToggleUpdate(true)
                end
            end
        end
    end

    hat_fns.peagawkfeather = function()
        local inst = simple()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.peagawkfeather_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.peagawkfeather_onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.PEAGAWKFEATHER.PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)

        return inst
    end

    hat_fns.propeller_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            if inst.components.heater ~= nil then
                inst.components.heater:SetThermics(false, true)
            end

            if inst.propeller_fan ~= nil then
                inst.propeller_fan:Remove()
            end

            inst.propeller_fan = SpawnPrefab("propellerhat_fan")
            inst.propeller_fan.entity:SetParent(owner.entity)

            inst.propeller_fan:OnSetSpinning(true)
        end
    end

    hat_fns.propeller_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            if inst.components.heater ~= nil then
                inst.components.heater:SetThermics(false, false)
            end

            if inst.propeller_fan ~= nil then
                inst.propeller_fan:OnStartUnequipping(inst)
                inst.propeller_fan = nil
            end
        end
    end

    hat_fns.propeller_onequiptomodel = function(inst, owner, from_ground)
        if owner ~= nil then
            if inst.components.heater ~= nil then
                inst.components.heater:SetThermics(false, false)
            end

            if inst.propeller_fan ~= nil then
                inst.propeller_fan:Remove()
            end

            inst.propeller_fan = SpawnPrefab("propellerhat_fan")
            inst.propeller_fan.entity:SetParent(owner.entity)

            inst.propeller_fan:OnSetSpinning(true) -- Set to false?

            if inst.components.fueled ~= nil then
                inst.components.fueled:StopConsuming()
            end
        end
    end

    hat_fns.propeller_ontakefuel = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        if owner ~= nil then
            owner:PushEvent("repair")
        end
    end

    hat_fns.propeller_onperish = function(inst)
        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

            if owner ~= nil then
                owner:PushEvent("itemranout",
                {
                    prefab    = inst.prefab,
                    equipslot = inst.components.equippable.equipslot,
                    announce  = "ANNOUNCE_FAN_OUT",
                })
            end
        end

        hat_fns.simple_onperish(inst)
    end

    hat_fns.propeller_custom_init = function(inst)
        inst.entity:AddSoundEmitter()

        inst:AddTag("HASHEATER")
        inst:AddTag("metal")
    end

    hat_fns.propeller = function()
        local inst = simple(hat_fns.propeller_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.propeller_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.propeller_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.propeller_onequiptomodel)
        inst.components.equippable.walkspeedmult = TUNING.APO_HATS.PROPELLER.WALKSPEEDMULT

        inst:AddComponent("heater")
        inst.components.heater.equippedheat = TUNING.APO_HATS.PROPELLER.HEAT

        inst:AddComponent("insulator")
        inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)
        inst.components.insulator:SetSummer()

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.MAGIC
        inst.components.fueled.secondaryfueltype = FUELTYPE.GEARS
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.PROPELLER.PERISHTIME)
        inst.components.fueled:SetTakeFuelFn(hat_fns.propeller_ontakefuel)
        inst.components.fueled:SetDepletedFn(hat_fns.propeller_onperish)
        inst.components.fueled.bonusmult = TUNING.APO_HATS.PROPELLER.FUEL_BONUS_MULT
        inst.components.fueled.accepting = true

        return inst
    end

    hat_fns.pumpkinhead_onwaxed = function(inst)
        if not inst.waxed:value() then
            inst:RemoveComponent("perishable")
            inst:RemoveComponent("waxable")

            inst:RemoveTag("show_spoilage")
            inst:RemoveTag("icebox_valid")

            inst.waxed:set(true)

            hat_fns.pumpkinhead_onwaxeddirty(inst)

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

    hat_fns.pumpkinhead_onwax = function(inst, doer, item)
        hat_fns.pumpkinhead_onwaxed(inst)

        return true
    end

    hat_fns.pumpkinhead_onwaxeddirty = function(inst)
        if inst.waxed:value() then
            inst.displayadjectivefn = function()
                return STRINGS.UI.HUD.WAXED
            end

            if not TheNet:IsDedicated() then
                inst:PushEvent("hide_spoilage")
            end
        end
    end

    hat_fns.pumpkinhead_onsave = function(inst, data)
        data.waxed = inst.waxed:value() or nil
    end

    hat_fns.pumpkinhead_onload = function(inst, data)
        if data ~= nil and data.waxed then
            hat_fns.pumpkinhead_onwaxed(inst)

            inst.waxed:set(true)

            hat_fns.pumpkinhead_onwaxeddirty(inst)
        end
    end

    hat_fns.pumpkinhead_custom_init = function(inst)
        inst:AddTag("fullhelm_hat")
        inst:AddTag("spook_protection")
        inst:AddTag("show_spoilage")
        inst:AddTag("icebox_valid")
        inst:AddTag("waxable")

        inst.waxed = net_bool(inst.GUID, "pumpkinhead.waxed", "pumpkinheadwaxeddirty")
    end

    hat_fns.pumpkinhead = function()
        local inst = simple(hat_fns.pumpkinhead_custom_init)

        if not TheWorld.ismastersim then
            inst:ListenForEvent("pumpkinheadwaxeddirty", hat_fns.pumpkinhead_onwaxeddirty)

            return inst
        end

        inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL

        inst:AddComponent("waxable")
        inst.components.waxable:SetWaxfn(hat_fns.pumpkinhead_onwax)

        inst:AddComponent("forcecompostable")
        inst.components.forcecompostable.green = true

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS)
        and TUNING.PERISH_SLOW or TUNING.PERISH_FASTISH)
        inst.components.perishable:SetOnPerishFn(inst.Remove)
        inst.components.perishable:StartPerishing()

        inst.OnSave = hat_fns.pumpkinhead_onsave
        inst.OnLoad = hat_fns.pumpkinhead_onload

        return inst
    end

    hat_fns.sanitydamage_custom_init = function(inst)
        inst:AddTag("damagetosanity")
        inst:AddTag("gestaltprotection")
        inst:AddTag("open_top_hat")
    end

    hat_fns.sanitydamage = function()
        local inst = simple(hat_fns.sanitydamage_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.opentop_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.simple_onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.APO_HATS.SANITYDAMAGE.CONDITION, TUNING.APO_HATS.SANITYDAMAGE.ABSORPTION)

        inst:AddComponent("damagetyperesist")
        inst.components.damagetyperesist:AddResist("lunar_aligned", inst, TUNING.APO_HATS.SANITYDAMAGE.DAMAGETYPE_RESIST)

        return inst
    end

    hat_fns.volcanocold_onupdatelight = function(inst)
        local hasfuel = inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty()
        local equipped = inst.components.equippable ~= nil and inst.components.equippable:IsEquipped()
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        local ininventory = owner ~= nil
        local onground = not equipped and not ininventory and not inst:IsInLimbo()

        if inst.Light ~= nil then
            inst.Light:Enable(onground and hasfuel)
        end

        if inst.components.inventoryitem ~= nil then
            inst.components.inventoryitem:ChangeImageName(hasfuel and "volcanocoldhat" or "volcanocoldhat_off")
        end

        inst.AnimState:PlayAnimation(hasfuel and "anim_on" or "anim_off", true)

        if equipped and owner ~= nil then
            _onequip(inst, owner, hasfuel and "swap_hat" or "swap_hat_off")
        end
    end

    hat_fns.volcanocold_onturnon = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        if owner == nil or (inst.components.fueled ~= nil and inst.components.fueled:IsEmpty()) then
            hat_fns.volcanocold_onturnoff(inst)

            return
        end

        _onequip(inst, owner, "swap_hat")
        inst.AnimState:PlayAnimation("anim_on", true)

        if inst.components.inventoryitem ~= nil then
            inst.components.inventoryitem:ChangeImageName("volcanocoldhat")
        end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end

        if inst.components.heater ~= nil then
            inst.components.heater:SetThermics(false, true)
        end

        if inst.components.insulator ~= nil then
            inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
        end

        if inst.volcanocold_light == nil or not inst.volcanocold_light:IsValid() then
            inst.volcanocold_light = SpawnPrefab("volcanocoldhat_light")

            if inst.volcanocold_light ~= nil then
                inst.volcanocold_light.entity:SetParent(owner.entity)
                inst.volcanocold_light.Transform:SetPosition(0, 0, 0)
            end
        end

        local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
        soundemitter:PlaySound("dontstarve/common/fireAddFuel")

        hat_fns.volcanocold_onupdatelight(inst)
    end

    hat_fns.volcanocold_onturnoff = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        if owner ~= nil then
            if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
                _onequip(inst, owner, "swap_hat_off")
            end

            if inst.components.fueled ~= nil then
                inst.components.fueled:StopConsuming()
            end

            if inst.components.heater ~= nil then
                inst.components.heater:SetThermics(false, false)
            end

            if inst.components.insulator ~= nil then
                inst.components.insulator:SetInsulation(0)
            end

            if inst.volcanocold_light ~= nil then
                if inst.volcanocold_light:IsValid() then
                    inst.volcanocold_light:Remove()
                end

                inst.volcanocold_light = nil
            end
        end

        local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
        soundemitter:PlaySound("dontstarve/common/minerhatOut")

        hat_fns.volcanocold_onupdatelight(inst)
    end

    hat_fns.volcanocold_onequip = function(inst, owner)
        if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
            hat_fns.volcanocold_onturnon(inst)
        else
            hat_fns.volcanocold_onturnoff(inst)
            hat_fns.volcanocold_onupdatelight(inst)
        end
    end

    hat_fns.volcanocold_onunequip = function(inst, owner)
        _onunequip(inst, owner)

        hat_fns.volcanocold_onturnoff(inst)
        hat_fns.volcanocold_onupdatelight(inst)
    end

    hat_fns.volcanocold_onequiptomodel = function(inst, owner, from_ground)
        hat_fns.simple_onequiptomodel(inst, owner, from_ground)
        hat_fns.volcanocold_onturnoff(inst)
        hat_fns.volcanocold_onupdatelight(inst)
    end

    hat_fns.volcanocold_ondropped = function(inst)
        hat_fns.volcanocold_onupdatelight(inst)
    end

    hat_fns.volcanocold_onputininventory = function(inst, guy)
        if inst.Light ~= nil then
            inst.Light:Enable(false)
        end

        hat_fns.volcanocold_onupdatelight(inst)
    end

    hat_fns.volcanocold_ontakefuel = function(inst)
        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            hat_fns.volcanocold_onturnon(inst)
        else
            hat_fns.volcanocold_onupdatelight(inst)
        end
    end

    hat_fns.volcanocold_onperish = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        local equipped = inst.components.equippable ~= nil and inst.components.equippable:IsEquipped()

        hat_fns.volcanocold_onturnoff(inst)
        hat_fns.volcanocold_onupdatelight(inst)

        if equipped and owner ~= nil then
            owner:PushEvent("torchranout", { prefab = inst.prefab, equipslot = inst.components.equippable.equipslot })
        end
    end

    hat_fns.volcanocold_onload = function(inst, data)
        inst:DoTaskInTime(0, function(inst)
            local equipped = inst.components.equippable ~= nil and inst.components.equippable:IsEquipped()
            local hasfuel = inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty()

            if equipped then
                if hasfuel then
                    hat_fns.volcanocold_onturnon(inst)
                else
                    hat_fns.volcanocold_onturnoff(inst)
                end
            else
                hat_fns.volcanocold_onupdatelight(inst)
            end
        end)
    end

    hat_fns.volcanocold_onremove = function(inst)
        if inst.volcanocold_light ~= nil and inst.volcanocold_light:IsValid() then
            inst.volcanocold_light:Remove()
        end
    end

    hat_fns.volcanocold_custom_init = function(inst)
        inst.entity:AddSoundEmitter()
        inst.entity:AddLight()

        inst.Light:SetFalloff(0.7)
        inst.Light:SetIntensity(0.5)
        inst.Light:SetRadius(0.5)
        inst.Light:SetColour(100/255, 190/255, 255/255)
        inst.Light:Enable(false)

        inst:AddTag("HASHEATER")
        inst:AddTag("waterproofer")
    end

    hat_fns.volcanocold = function()
        local inst = simple(hat_fns.volcanocold_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.volcanocold_light = nil

        inst.components.inventoryitem:SetOnDroppedFn(hat_fns.volcanocold_ondropped)

        inst.components.equippable:SetOnEquip(hat_fns.volcanocold_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.volcanocold_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.volcanocold_onequiptomodel)

        inst:AddComponent("insulator")
        inst.components.insulator:SetSummer()

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_LARGE)

        inst:AddComponent("heater")
        inst.components.heater.heat = TUNING.APO_HATS.VOLCANOCOLD.HEAT
        inst.components.heater.equippedheat = TUNING.APO_HATS.VOLCANOCOLD.HEAT

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.MAGIC
        inst.components.fueled.secondaryfueltype = FUELTYPE.BLUEGEM
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.VOLCANOCOLD.PERISHTIME)
        inst.components.fueled:SetDepletedFn(hat_fns.volcanocold_onperish)
        inst.components.fueled:SetTakeFuelFn(hat_fns.volcanocold_ontakefuel)
        inst.components.fueled.bonusmult = TUNING.APO_HATS.VOLCANOCOLD.FUEL_BONUS_MULT
        inst.components.fueled.accepting = true

        inst.OnLoad = hat_fns.volcanocold_onload
        inst.OnRemoveEntity = hat_fns.volcanocold_onremove

        return inst
    end

    hat_fns.volcano_onupdatelight = function(inst)
        local hasfuel = inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty()
        local equipped = inst.components.equippable ~= nil and inst.components.equippable:IsEquipped()
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        local ininventory = owner ~= nil
        local onground = not equipped and not ininventory and not inst:IsInLimbo()

        if inst.Light ~= nil then
            inst.Light:Enable(onground and hasfuel)
        end

        if inst.components.inventoryitem ~= nil then
            inst.components.inventoryitem:ChangeImageName(hasfuel and "volcanohat" or "volcanohat_off")
        end

        inst.AnimState:PlayAnimation(hasfuel and "anim_on" or "anim_off", true)

        if equipped and owner ~= nil then
            _onequip(inst, owner, hasfuel and "swap_hat" or "swap_hat_off")
        end
    end

    hat_fns.volcano_onturnon = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        if owner == nil or (inst.components.fueled ~= nil and inst.components.fueled:IsEmpty()) then
            hat_fns.volcano_onturnoff(inst)

            return
        end

        _onequip(inst, owner, "swap_hat")
        inst.AnimState:PlayAnimation("anim_on", true)

        if inst.components.inventoryitem ~= nil then
            inst.components.inventoryitem:ChangeImageName("volcanohat")
        end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end

        if inst.components.heater ~= nil then
            inst.components.heater:SetThermics(true, false)
        end

        if inst.components.insulator ~= nil then
            inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
        end

        if inst.volcano_light == nil or not inst.volcano_light:IsValid() then
            inst.volcano_light = SpawnPrefab("volcanohat_light")

            if inst.volcano_light ~= nil then
                inst.volcano_light.entity:SetParent(owner.entity)
                inst.volcano_light.Transform:SetPosition(0, 0, 0)
            end
        end

        local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
        soundemitter:PlaySound("dontstarve/common/fireAddFuel")

        hat_fns.volcano_onupdatelight(inst)
    end

    hat_fns.volcano_onturnoff = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        if owner ~= nil then
            if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
                _onequip(inst, owner, "swap_hat_off")
            end

            if inst.components.fueled ~= nil then
                inst.components.fueled:StopConsuming()
            end

            if inst.components.heater ~= nil then
                inst.components.heater:SetThermics(false, false)
            end

            if inst.components.insulator ~= nil then
                inst.components.insulator:SetInsulation(0)
            end

            if inst.volcano_light ~= nil then
                if inst.volcano_light:IsValid() then
                    inst.volcano_light:Remove()
                end

                inst.volcano_light = nil
            end
        end

        local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
        soundemitter:PlaySound("dontstarve/common/minerhatOut")

        hat_fns.volcano_onupdatelight(inst)
    end

    hat_fns.volcano_onequip = function(inst, owner)
        if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
            hat_fns.volcano_onturnon(inst)
        else
            hat_fns.volcano_onturnoff(inst)
            hat_fns.volcano_onupdatelight(inst)
        end
    end

    hat_fns.volcano_onunequip = function(inst, owner)
        _onunequip(inst, owner)

        hat_fns.volcano_onturnoff(inst)
        hat_fns.volcano_onupdatelight(inst)
    end

    hat_fns.volcano_onequiptomodel = function(inst, owner, from_ground)
        hat_fns.simple_onequiptomodel(inst, owner, from_ground)
        hat_fns.volcano_onturnoff(inst)
        hat_fns.volcano_onupdatelight(inst)
    end

    hat_fns.volcano_ondropped = function(inst)
        hat_fns.volcano_onupdatelight(inst)
    end

    hat_fns.volcano_onputininventory = function(inst, guy)
        if inst.Light ~= nil then
            inst.Light:Enable(false)
        end

        hat_fns.volcano_onupdatelight(inst)
    end

    hat_fns.volcano_ontakefuel = function(inst)
        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            hat_fns.volcano_onturnon(inst)
        else
            hat_fns.volcano_onupdatelight(inst)
        end
    end

    hat_fns.volcano_onperish = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        local equipped = inst.components.equippable ~= nil and inst.components.equippable:IsEquipped()

        hat_fns.volcano_onturnoff(inst)
        hat_fns.volcano_onupdatelight(inst)

        if equipped and owner ~= nil then
            owner:PushEvent("torchranout", { prefab = inst.prefab, equipslot = inst.components.equippable.equipslot })
        end
    end

    hat_fns.volcano_onload = function(inst, data)
        inst:DoTaskInTime(0, function(inst)
            local equipped = inst.components.equippable ~= nil and inst.components.equippable:IsEquipped()
            local hasfuel = inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty()

            if equipped then
                if hasfuel then
                    hat_fns.volcano_onturnon(inst)
                else
                    hat_fns.volcano_onturnoff(inst)
                end
            else
                hat_fns.volcano_onupdatelight(inst)
            end
        end)
    end

    hat_fns.volcano_onremove = function(inst)
        if inst.volcano_light ~= nil and inst.volcano_light:IsValid() then
            inst.volcano_light:Remove()
        end
    end

    hat_fns.volcano_custom_init = function(inst)
        inst.entity:AddSoundEmitter()
        inst.entity:AddLight()

        inst.Light:SetFalloff(0.7)
        inst.Light:SetIntensity(0.5)
        inst.Light:SetRadius(0.5)
        inst.Light:SetColour(232/255, 141/255, 67/255)
        inst.Light:Enable(false)

        inst:AddTag("HASHEATER")
        inst:AddTag("cooker")
        inst:AddTag("waterproofer")
    end

    hat_fns.volcano = function()
        local inst = simple(hat_fns.volcano_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.volcano_light = nil

        inst.components.inventoryitem:SetOnDroppedFn(hat_fns.volcano_ondropped)

        inst.components.equippable:SetOnEquip(hat_fns.volcano_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.volcano_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.volcano_onequiptomodel)

        inst:AddComponent("cooker")
        inst:AddComponent("insulator")

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_LARGE)

        inst:AddComponent("heater")
        inst.components.heater.heat = TUNING.APO_HATS.VOLCANO.HEAT
        inst.components.heater.equippedheat = TUNING.APO_HATS.VOLCANO.HEAT

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.MAGIC
        inst.components.fueled.secondaryfueltype = FUELTYPE.REDGEM
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.VOLCANO.PERISHTIME)
        inst.components.fueled:SetDepletedFn(hat_fns.volcano_onperish)
        inst.components.fueled:SetTakeFuelFn(hat_fns.volcano_ontakefuel)
        inst.components.fueled.bonusmult = TUNING.APO_HATS.VOLCANO.FUEL_BONUS_MULT
        inst.components.fueled.accepting = true

        inst.OnLoad = hat_fns.volcano_onload
        inst.OnRemoveEntity = hat_fns.volcano_onremove

        return inst
    end

    hat_fns.willowold_onapplyhealthbuff = function(bernie)
        if bernie.willowold_bonushealth then
            return
        end

        if bernie.components.health ~= nil and not bernie.components.health:IsDead() then
            local current_health = bernie.components.health:GetPercent()
            local bonus = bernie.components.health.maxhealth * (TUNING.APO_HATS.WILLOWOLD.MODIFIERS.HEALTH - 1)

            bernie.willowold_bonushealth = bonus

            bernie.components.health:SetMaxHealth(bernie.components.health.maxhealth + bonus)
            bernie.components.health:SetPercent(current_health)
        end
    end

    hat_fns.willowold_onremovehealthbuff = function(bernie)
        local bonus = bernie.willowold_bonushealth

        if bonus == nil then
            return
        end

        if bernie.components.health ~= nil then
            local current_health = bernie.components.health:GetPercent()

            bernie.components.health:SetMaxHealth(math.max(1, bernie.components.health.maxhealth - bonus))
            bernie.components.health:SetPercent(current_health)
        end

        bernie.willowold_bonushealth = nil
    end

    hat_fns.willowold_onapplybuff = function(bernie)
        local MODIFIER = TUNING.APO_HATS.WILLOWOLD.MODIFIERS.DAMAGE

        if bernie.components.combat ~= nil then
            bernie.components.combat.externaldamagemultipliers:SetModifier(bernie, MODIFIER, "willowoldhat")
        end

        hat_fns.willowold_onapplyhealthbuff(bernie)
    end

    hat_fns.willowold_onremovebuff = function(bernie)
        if bernie.components.combat ~= nil then
            bernie.components.combat.externaldamagemultipliers:RemoveModifier(bernie, "willowoldhat")
        end

        hat_fns.willowold_onremovehealthbuff(bernie)
    end

    hat_fns.willowold_onupdate = function(owner, fn)
        local function ApplyToBernie(bernie)
            if bernie ~= nil and bernie:IsValid() and (bernie.prefab == "bernie_active" or bernie.prefab == "bernie_big")
            and bernie.components.combat ~= nil and bernie.components.health ~= nil and not bernie.components.health:IsDead() then
                fn(bernie)
            end
        end

        local leader = owner.components.leader

        if leader ~= nil and leader.followers ~= nil then
            for follower in pairs(leader.followers) do
                ApplyToBernie(follower)
            end
        end

        if owner.bigbernies ~= nil then
            for bernie in pairs(owner.bigbernies) do
                ApplyToBernie(bernie)
            end
        end
    end

    hat_fns.willowold_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil and owner.prefab == "willow" then
            if inst.components.equippable ~= nil then
                inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED

                owner:ListenForEvent("onberniebig", inst.willowold_onberniebig)

                hat_fns.willowold_onupdate(owner, hat_fns.willowold_onapplybuff)
            end
        end
    end

    hat_fns.willowold_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            if inst.components.equippable ~= nil then
                inst.components.equippable.dapperness = 0

                owner:RemoveEventCallback("onberniebig", inst.willowold_onberniebig)

                hat_fns.willowold_onupdate(owner, hat_fns.willowold_onremovebuff)
            end
        end
    end

    hat_fns.willowold_custom_init = function(inst)
        inst:AddTag("followeramplifier")
        inst:AddTag("waterproofer")
    end

    hat_fns.willowold = function()
        local inst = simple(hat_fns.willowold_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.willowold_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.willowold_onunequip)
        inst.components.equippable.dapperness = 0

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst:AddComponent("insulator")
        inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.WILLOWOLD.PERISHTIME)
        inst.components.fueled:SetDepletedFn(hat_fns.simple_onperish)

        inst.willowold_onberniebig = function(owner, data)
            if data ~= nil and data.bernie ~= nil then
                local bernie = data.bernie

                -- Need to delay the buff to let bernie initiliaze his stuff...
                bernie:DoTaskInTime(2, function()
                    hat_fns.willowold_onapplybuff(bernie)
                end)
            end
        end

        return inst
    end

    -- ranged crown    = lifesteal +10 mv speed
    -- minotaurcrown   = +25% atk speed + 25% dmg +10 mv speed

    local hat_fn  = nil

    local assets  =
    {
        Asset("ANIM", "anim/"..fname..".zip"),

        Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
        Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
        Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),
    }

    local prefabs = nil

    if name == "bucket" then
        hat_fn = hat_fns.bucket
    elseif name == "carnival_host" then
        hat_fn = hat_fns.carnival_host
    elseif name == "extraheavy" then
        hat_fn = hat_fns.extraheavy
    elseif name == "foodbasket" then
        hat_fn = hat_fns.foodbasket
    elseif name == "foodbonus" then
        hat_fn = hat_fns.foodbonus
    elseif name == "healingbonus" then
        hat_fn = hat_fns.healingbonus
    elseif name == "jiaolian" then
        hat_fn = hat_fns.jiaolian
    elseif name == "lifesteal" then
        hat_fn = hat_fns.lifesteal
    elseif name == "minotaurcrown" then
        hat_fn = hat_fns.minotaurcrown
    elseif name == "peagawkfeather" then
        hat_fn = hat_fns.peagawkfeather
    elseif name == "propeller" then
        prefabs = { "propellerhat_fan" }
        hat_fn = hat_fns.propeller
    elseif name == "pumpkinhead" then
        hat_fn = hat_fns.pumpkinhead
    elseif name == "sanitydamage" then
        hat_fn = hat_fns.sanitydamage
    elseif name == "volcanocold" then
        prefabs = { "volcanocoldhat_light" }
        hat_fn = hat_fns.volcanocold
    elseif name == "volcano" then
        prefabs = { "volcanohat_light" }
        hat_fn = hat_fns.volcano
    elseif name == "willowold" then
        hat_fn = hat_fns.willowold
    end

    table.insert(ALL_HAT_PREFAB_NAMES, prefabname)

    return Prefab(prefabname, hat_fn, assets, prefabs)
end

return MakeHat("bucket"),
MakeHat("carnival_host"),
MakeHat("extraheavy"),
MakeHat("foodbasket"),
MakeHat("foodbonus"),
MakeHat("healingbonus"),
MakeHat("jiaolian"),
MakeHat("lifesteal"),
MakeHat("minotaurcrown"),
MakeHat("peagawkfeather"),
MakeHat("propeller"),
MakeHat("pumpkinhead"),
MakeHat("sanitydamage"),
MakeHat("volcanocold"),
MakeHat("volcano"),
MakeHat("willowold")