local hat_fns2 = {}

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
                    owner.AnimState:OverrideSkinSymbol("headbase_hat", skin_build, headbase_hat_override )
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

    hat_fns.aerodynamic_custom_init = function(inst)
        inst.AnimState:SetRayTestOnBB(true)
    end

    hat_fns.aerodynamic = function()
        local inst = simple(hat_fns.aerodynamic_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
        inst.components.equippable.walkspeedmult = TUNING.APO_HATS.AERODYNAMIC.WALKSPEEDMULT

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.AERODYNAMIC.PERISHTIME)
        inst.components.fueled:SetDepletedFn(hat_fns.simple_onperish)

        return inst
    end

    hat_fns.antmask_onupdate = function(inst)
        if inst.components.armor ~= nil then
            inst.components.armor:SetPercent(inst.components.fueled:GetPercent())
        end
    end

    hat_fns.antmask_ontakedamage = function(inst, damage_amount, absorbed, leftover)
        if inst.components.armor ~= nil and inst.components.fueled ~= nil then
            local absorbed = damage_amount * TUNING.APO_HATS.ANTMASK.ABSORPTION
            local absorbed_dmg = absorbed / inst.components.armor.maxcondition

            local percent = inst.components.fueled:GetPercent()
            local newpercent = percent - absorbed_dmg

            inst.components.fueled:SetPercent(newpercent)
        end
    end

    hat_fns.antmask_custom_init = function(inst)
        inst.AnimState:SetRayTestOnBB(true)

        inst:AddTag("beefriend")
        inst:AddTag("waterproofer")
    end

    hat_fns.antmask = function()
        local inst = simple(hat_fns.antmask_custom_init)

        inst.components.floater:SetSize("med")
        inst.components.floater:SetVerticalOffset(0.1)
        inst.components.floater:SetScale(0.65)

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.APO_HATS.ANTMASK.CONDITION, TUNING.APO_HATS.ANTMASK.ABSORPTION)
        inst.components.armor:SetTags(TUNING.APO_HATS.ANTMASK.TAGS)
        inst.components.armor.ontakedamage = hat_fns.antmask_ontakedamage

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.ANTMASK.PERISHTIME)
        inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
        inst.components.fueled:SetDepletedFn(hat_fns.simple_onperish)
        inst.components.fueled:SetUpdateFn(hat_fns.antmask_onupdate)

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        return inst
    end

    hat_fns.bandit_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            inst._notraptrigger = owner:HasTag("notraptrigger")

            owner:AddTag("notraptrigger")

            if owner.components.locomotor ~= nil then
                inst._triggerscreep = owner.components.locomotor.triggerscreep
                inst._fasteroncreep = owner.components.locomotor.fasteroncreep

                owner.components.locomotor:SetTriggersCreep(false)
                owner.components.locomotor:SetFasterOnCreep(true)
            end

            if inst.components.extralootdropper ~= nil then
                inst.components.extralootdropper:StartListening(owner)
            end
        end
    end

    hat_fns.bandit_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            if inst._notraptrigger then
                owner:AddTag("notraptrigger")
            else
                owner:RemoveTag("notraptrigger")
            end

            if owner.components.locomotor ~= nil then
                if inst._triggerscreep ~= nil then
                    owner.components.locomotor:SetTriggersCreep(inst._triggerscreep)
                end

                if inst._fasteroncreep ~= nil then
                    owner.components.locomotor:SetFasterOnCreep(inst._fasteroncreep)
                end
            end

            if inst.components.extralootdropper ~= nil then
                inst.components.extralootdropper:StopListening()
            end
        end

        inst._notraptrigger = nil
        inst._triggerscreep = nil
        inst._fasteroncreep = nil
    end

    hat_fns.bandit_onequiptomodel = function(inst, owner, from_ground)
        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end

        if inst.components.extralootdropper ~= nil then
            inst.components.extralootdropper:StopListening()
        end
    end

    hat_fns.bandit_custom_init = function(inst)
        inst:AddTag("extralootsource")
        inst:AddTag("waterproofer")
    end

    hat_fns.bandit = function()
        local inst = simple(hat_fns.bandit_custom_init)

        inst.components.floater:SetSize("med")
        inst.components.floater:SetScale(0.8)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.bandit_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.bandit_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.bandit_onequiptomodel)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL

        inst:AddComponent("extralootdropper")

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.BANDIT.PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)

        return inst
    end

    hat_fns.bat_onturnon = function(owner)
        if owner ~= nil and owner.SoundEmitter ~= nil then
            owner.SoundEmitter:PlaySound("apo_sounds/common/hat_bat/turn_on")
        end
    end

    hat_fns.bat_onturnoff = function(owner)
        if owner ~= nil and owner.SoundEmitter ~= nil then
            owner.SoundEmitter:PlaySound("apo_sounds/common/hat_bat/turn_off")
        end
    end

    hat_fns.bat_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)
        hat_fns.bat_onturnon(owner)

        if owner ~= nil then
            if owner.components.grue ~= nil then
                owner.components.grue:AddImmunity("bathat")
            end
        end
    end

    hat_fns.bat_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)
        hat_fns.bat_onturnoff(owner)

        if owner ~= nil then
            if owner.components.grue ~= nil then
                owner.components.grue:RemoveImmunity("bathat")
            end
        end
    end

    hat_fns.bat_onperish = function(inst)
        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

            if owner ~= nil then
                hat_fns.bat_onturnoff(owner)
            end
        end

        hat_fns.simple_onperish(inst)
    end

    hat_fns.bat_custom_init = function(inst)
        inst.entity:AddSoundEmitter()

        inst:AddTag("no_sewing")
        inst:AddTag("batvision")
    end

    hat_fns.bat = function()
        local inst = simple(hat_fns.bat_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.bat_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.bat_onunequip)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.BAT.PERISHTIME)
        inst.components.fueled:SetDepletedFn(hat_fns.simple_onperish)
        inst.components.fueled.no_sewing = true

        return inst
    end

    hat_fns.brainjelly_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner.components.builder ~= nil then
            owner.components.builder.brainjellyhat = true

            owner:PushEvent("techlevelchange")
            owner:PushEvent("unlockrecipe")

            owner:ListenForEvent("builditem", inst.brainjelly_onbuild)
            owner:ListenForEvent("bufferbuild", inst.brainjelly_onbuild)
            owner:ListenForEvent("buildstructure", inst.brainjelly_onbuildstructure)
        end
    end

    hat_fns.brainjelly_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner.components.builder ~= nil then
            owner.components.builder.brainjellyhat = false

            owner:PushEvent("techlevelchange")
            owner:PushEvent("unlockrecipe")

            owner:RemoveEventCallback("builditem", inst.brainjelly_onbuild)
            owner:RemoveEventCallback("bufferbuild", inst.brainjelly_onbuild)
            owner:RemoveEventCallback("buildstructure", inst.brainjelly_onbuildstructure)

            if owner.bufferedaction and owner.bufferedaction.action == ACTIONS.BUILD then
                owner:ClearBufferedAction()
            end
        end
    end

    hat_fns.brainjelly_custom_init = function(inst)
        inst:AddTag("smarthat")
    end

    hat_fns.brainjelly = function()
        local inst = simple(hat_fns.brainjelly_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.brainjelly_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.brainjelly_onunequip)

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.APO_HATS.BRAINJELLY.USES)
        inst.components.finiteuses:SetUses(TUNING.APO_HATS.BRAINJELLY.USES)
        inst.components.finiteuses:SetOnFinished(inst.Remove)

        inst.brainjelly_onbuild = function(_, data)
            local owner = inst.components.inventoryitem:GetGrandOwner()

            if data and data.recipe and not owner.components.builder:KnowsRecipeWithoutBrainJellyHat(data.recipe, true) then
                if not owner.components.builder.current_prototyper or not CanPrototypeRecipe(data.recipe.level,
                owner.components.builder.current_prototyper.components.prototyper.trees) then
                    inst.components.finiteuses:Use(1)
                else
                    owner.components.builder:UnlockRecipe(data.recipe.name)
                    owner.components.builder:ActivateCurrentResearchMachine()
                    owner.components.builder:ForceAddRecipe(data.recipe.name)
                end
            end
        end

        inst.brainjelly_onbuildstructure = function(_, data)
            if data and data.item and data.item.prefab and (string.sub(data.item.prefab, 1, 10) == "chesspiece"
            or string.sub(data.item.prefab, 1, 21) == "blueprint_craftingset") then
                inst.brainjelly_onbuild(_, data)
            end
        end

        return inst
    end

    hat_fns.candle_onturnon = function(inst, owner)
        if owner ~= nil then
            if inst.components.fueled ~= nil then
                if not inst.components.fueled:IsEmpty() then
                    inst.components.fueled:StartConsuming()

                    inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_LP", "torch")
                    inst.SoundEmitter:SetParameter("torch", "intensity", 1)

                    if not inst.candlefire then
                        inst.candlefire = SpawnPrefab("torchfire_rag")

                        local follower = inst.candlefire.entity:AddFollower()
                        follower:FollowSymbol(owner.GUID, "swap_hat", 0, -250, 0)
                    end
                end
            end
        end
    end

    hat_fns.candle_onturnoff = function(inst, owner)
        if owner ~= nil then
            if inst.components.fueled ~= nil then
                inst.components.fueled:StopConsuming()

                if inst.candlefire then
                    inst.candlefire:Remove()
                    inst.candlefire = nil
                end

                inst.SoundEmitter:KillSound("torch")
                inst.SoundEmitter:PlaySound("dontstarve/common/fireOut")
            end
        end
    end

    hat_fns.candle_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)
        hat_fns.candle_onturnon(inst, owner)
    end

    hat_fns.candle_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)
        hat_fns.candle_onturnoff(inst, owner)
    end

    hat_fns.candle_onequiptomodel = function(inst, owner, from_ground)
        hat_fns.candle_onturnoff(inst, owner)
    end

    hat_fns.candle_onperish = function(inst)
        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

            if owner ~= nil then
                hat_fns.candle_onturnoff(inst, owner)
                owner:PushEvent("torchranout", { torch = inst })
            end
        end

        hat_fns.simple_onperish(inst)
    end

    hat_fns.candle_ondropped = function(inst, owner)
        hat_fns.candle_onturnoff(inst, owner)
    end

    hat_fns.candle_ontakefuel = function(inst, owner)
        inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")

        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            hat_fns.candle_onturnon(inst, owner)
        end
    end

    hat_fns.candle_custom_init = function(inst)
        inst.entity:AddSoundEmitter()

        inst:AddTag("torch")
        inst:AddTag("waterproofer")
    end

    hat_fns.candle = function()
        local inst = simple(hat_fns.candle_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.inventoryitem:SetOnDroppedFn(hat_fns.candle_ondropped)

        inst.components.equippable:SetOnEquip(hat_fns.candle_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.candle_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.candle_onequiptomodel)

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.BURNABLE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.CANDLE.PERISHTIME)
        inst.components.fueled:SetDepletedFn(hat_fns.candle_onperish)
        inst.components.fueled.ontakefuelfn = hat_fns.candle_ontakefuel
        inst.components.fueled.accepting = true

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        return inst
    end

    hat_fns.captain_onupdate = function(inst, owner)
        if owner ~= nil then
            if owner:GetCurrentPlatform() then
                if owner.components.hunger ~= nil then
                    owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING.APO_HATS.CAPTAIN.HUNGER_MODIFIER)
                end

                if inst.components.equippable ~= nil then
                    inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE
                end
            else
                if owner.components.hunger ~= nil then
                    owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
                end

                if inst.components.equippable ~= nil then
                    inst.components.equippable.dapperness = 0
                end
            end
        end
    end

    hat_fns.captain_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            inst:ListenForEvent("player_on_platform", inst.captain_onplatform, owner)
            inst:ListenForEvent("player_off_platform", inst.captain_offplatform, owner)

            hat_fns.captain_onupdate(inst, owner)
        end
    end

    hat_fns.captain_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            if owner.components.hunger ~= nil then
                owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
            end

            if inst.components.equippable ~= nil then
                inst.components.equippable.dapperness = 0
            end

            inst:RemoveEventCallback("player_on_platform", inst.captain_onplatform, owner)
            inst:RemoveEventCallback("player_off_platform", inst.captain_offplatform, owner)
        end
    end

    hat_fns.captain_onequiptomodel = function(inst, owner, from_ground)
        if owner ~= nil then
            if inst.components.fueled ~= nil then
                inst.components.fueled:StopConsuming()
            end

            if owner.components.hunger ~= nil then
                owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
            end

            if inst.components.equippable ~= nil then
                inst.components.equippable.dapperness = 0
            end
        end
    end

    hat_fns.captain_custom_init = function(inst)
        inst:AddTag("boatcaptain")
    end

    hat_fns.captain = function()
        local inst = simple(hat_fns.captain_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.captain_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.captain_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.captain_onequiptomodel)
        inst.components.equippable.dapperness = 0

        inst:AddComponent("insulator")
        inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)
        inst.components.insulator:SetSummer()

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.CAPTAIN.PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)

        inst.captain_onplatform = function(owner)
            hat_fns.captain_onupdate(inst, owner)
        end

        inst.captain_offplatform = function(owner)
            hat_fns.captain_onupdate(inst, owner)
        end

        return inst
    end

    hat_fns.disguise_onremovefollowers = function(owner)
        if owner ~= nil then
            if owner.components.leader ~= nil then
                owner.components.leader:RemoveFollowersByTag("pig")
                owner.components.leader:RemoveFollowersByTag("bunnyman")
            end
        end
    end

    hat_fns.disguise_ondisable = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        if owner ~= nil then
            if owner.disguise_wasmonster then
                owner:AddTag("monster")
                owner.disguise_wasmonster = nil
            end

            if owner.disguise_wasmerm then
                owner:AddTag("merm")
                owner.disguise_wasmerm = nil
            end

            if owner.disguised then
                owner:RemoveTag("monsterdisguise")
                owner:RemoveTag("pigdisguise")

                owner.disguised = nil

                if owner.disguise_task ~= nil then
                    owner.disguise_task:Cancel()
                    owner.disguise_task = nil
                end
            end

            hat_fns.disguise_onremovefollowers(owner)
        end
    end

    hat_fns.disguise_onenable = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        if owner ~= nil then
            if owner.components.leader ~= nil then
                owner.components.leader:RemoveFollowersByTag("merm")
            end

            if owner:HasTag("monster") then
                owner.disguise_wasmonster = true
                owner:RemoveTag("monster")
            end

            if owner:HasTag("merm") then
                owner.disguise_wasmerm = true
                owner:RemoveTag("merm")
            end

            owner.disguised = true

            if owner.disguise_task ~= nil then
                owner.disguise_task:Cancel()
                owner.disguise_task = nil
            end

            owner:AddTag("pigdisguise")
        end
    end

    hat_fns.disguise_onequip = function(inst, owner)
        hat_fns.opentop_onequip(inst, owner)
        hat_fns.disguise_onenable(inst)
    end

    hat_fns.disguise_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)
        hat_fns.disguise_ondisable(inst)
    end

    hat_fns.disguise_onequiptomodel = function(inst, owner, from_ground)
        hat_fns.simple_onequiptomodel(inst, owner, from_ground)
        hat_fns.disguise_ondisable(inst)
    end

    hat_fns.disguise_custom_init = function(inst)
        inst:AddTag("open_top_hat")
        inst:AddTag("disguise")
    end

    hat_fns.disguise = function()
        local inst = simple(hat_fns.disguise_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.disguise_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.disguise_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.disguise_onequiptomodel)

        return inst
    end

    hat_fns.double_umbrella_onequip = function(inst, owner)
        hat_fns.opentop_onequip(inst, owner)

        if owner.DynamicShadow ~= nil then
            owner.DynamicShadow:SetSize(2.2, 1.4)
        end
    end

    hat_fns.double_umbrella_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner.DynamicShadow ~= nil then
            owner.DynamicShadow:SetSize(1.3, 0.6)
        end
    end

    hat_fns.double_umbrella_onperish = function(inst)
        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

            if owner ~= nil then
                if owner.DynamicShadow ~= nil then
                    owner.DynamicShadow:SetSize(1.3, 0.6)
                end

                local data = { prefab = inst.prefab, equipslot = equippable.equipslot }

                inst:Remove()

                owner:PushEvent("umbrellaranout", data)

                return
            end
        end

        inst:Remove()
    end

    hat_fns.double_umbrella_custom_init = function(inst)
        inst:AddTag("open_top_hat")
        inst:AddTag("umbrella")
        inst:AddTag("waterproofer")
    end

    hat_fns.double_umbrella = function()
        local inst = simple(hat_fns.double_umbrella_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.double_umbrella_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.double_umbrella_onunequip)

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)

        inst:AddComponent("insulator")
        inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
        inst.components.insulator:SetSummer()
        inst.components.equippable.insulated = true

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.DOUBLE_UMBRELLA.PERISHTIME)
        inst.components.fueled:SetDepletedFn(hat_fns.double_umbrella_onperish)

        return inst
    end

    local hat_fn  = nil

    local assets  =
    {
        Asset("ANIM", "anim/"..fname..".zip"),

        Asset("IMAGE", "images/inventoryimages/apo_inventoryimages.tex"),
        Asset("ATLAS", "images/inventoryimages/apo_inventoryimages.xml"),
        Asset("ATLAS_BUILD", "images/inventoryimages/apo_inventoryimages.xml", 256),
    }

    local prefabs = nil

    if name == "aerodynamic" then
        hat_fn = hat_fns.aerodynamic
    elseif name == "antmask" then
        hat_fn = hat_fns.antmask
    elseif name == "bandit" then
        hat_fn = hat_fns.bandit
    elseif name == "bat" then
        hat_fn = hat_fns.bat
    elseif name == "brainjelly" then
        hat_fn = hat_fns.brainjelly
    elseif name == "candle" then
        prefabs = { "torchfire_rag" }
        hat_fn = hat_fns.candle
    elseif name == "captain" then
        hat_fn = hat_fns.captain
    elseif name == "disguise" then
        hat_fn = hat_fns.disguise
    elseif name == "double_umbrella" then
        hat_fn = hat_fns.double_umbrella
    end

    table.insert(ALL_HAT_PREFAB_NAMES, prefabname)

    return Prefab(prefabname, hat_fn, assets, prefabs)
end

return MakeHat("aerodynamic"),
MakeHat("antmask"),
MakeHat("bandit"),
MakeHat("bat"),
MakeHat("brainjelly"),
MakeHat("candle"),
MakeHat("captain"),
MakeHat("disguise"),
MakeHat("double_umbrella")