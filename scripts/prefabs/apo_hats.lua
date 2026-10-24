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

    hat_fns.simple_onisacidraining = function(inst, isacidraining)
        if inst.components.fueled ~= nil then
            if isacidraining then
                inst.components.fueled.rate_modifiers:SetModifier(inst, -1, "acidrain")
            else
                inst.components.fueled.rate_modifiers:RemoveModifier(inst, "acidrain")
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

    hat_fns.aerodynamic_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            inst:AddTag("luckysource")

            if owner.components.luckuser ~= nil then
                owner.components.luckuser:SetLuckSource(TUNING.APO_HATS.AERODYNAMIC.LUCK, inst)
            end
        end
    end

    hat_fns.aerodynamic_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            inst:RemoveTag("luckysource")

            if owner.components.luckuser ~= nil then
                owner.components.luckuser:RemoveLuckSource(inst)
            end
        end
    end

    hat_fns.aerodynamic_custom_init = function(inst)
        inst.AnimState:SetRayTestOnBB(true)
    end

    hat_fns.aerodynamic = function()
        local inst = simple(hat_fns.aerodynamic_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.aerodynamic_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.aerodynamic_onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
        inst.components.equippable.walkspeedmult = TUNING.APO_HATS.AERODYNAMIC.WALKSPEEDMULT

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.AERODYNAMIC.PERISHTIME)
        inst.components.fueled:SetDepletedFn(hat_fns.simple_onperish)

        return inst
    end

    hat_fns.antmask_getsetbonusequip = function(inst, owner)
        local body = owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil
        return body ~= nil and body.prefab == "armor_ant" and body or nil
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

        inst:AddComponent("setbonus")
        inst.components.setbonus:SetSetName(EQUIPMENTSETNAMES.ANT)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.ANTMASK.PERISHTIME)
        inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
        inst.components.fueled:SetDepletedFn(hat_fns.simple_onperish)
        inst.components.fueled:SetUpdateFn(hat_fns.antmask_onupdate)

        return inst
    end

    hat_fns.bandit_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            inst.notraptrigger = owner:HasTag("notraptrigger")

            owner:AddTag("notraptrigger")

            if owner.components.locomotor ~= nil then
                inst.triggerscreep = owner.components.locomotor.triggerscreep
                inst.fasteroncreep = owner.components.locomotor.fasteroncreep

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
            if inst.notraptrigger then
                owner:AddTag("notraptrigger")
            else
                owner:RemoveTag("notraptrigger")
            end

            if owner.components.locomotor ~= nil then
                if inst.triggerscreep ~= nil then
                    owner.components.locomotor:SetTriggersCreep(inst.triggerscreep)
                end

                if inst.fasteroncreep ~= nil then
                    owner.components.locomotor:SetFasterOnCreep(inst.fasteroncreep)
                end
            end

            if inst.components.extralootdropper ~= nil then
                inst.components.extralootdropper:StopListening()
            end
        end

        inst.notraptrigger = nil
        inst.triggerscreep = nil
        inst.fasteroncreep = nil
    end

    hat_fns.bandit_onequiptomodel = function(inst, owner, from_ground)
        hat_fns.simple_onequiptomodel(inst, owner, from_ground)

        if inst.components.extralootdropper ~= nil then
            inst.components.extralootdropper:StopListening()
        end
    end

    hat_fns.bandit_custom_init = function(inst)
        inst:AddTag("extralootsource")
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

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.BANDIT.PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)
        inst.components.fueled.no_sewing = true

        return inst
    end

    hat_fns.bat_onturnon = function(owner)
        if owner ~= nil then
            owner:PushEvent("batvision_on")
        end
    end

    hat_fns.bat_onturnoff = function(owner)
        if owner ~= nil then
            owner:PushEvent("batvision_off")
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

                    if owner.components.sanity ~= nil then
                        owner.components.sanity:DoDelta(-owner.components.sanity.max * TUNING.APO_HATS.BRAINJELLY.SANITY_COST)
                    end
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

    hat_fns.candle_onapplyskillbrightness = function(inst, value)
        if inst.candlefire then
            for i, fx in ipairs(inst.candlefire) do
                fx:SetLightRange(value)
            end
        end
    end

    hat_fns.candle_onapplyskillfueleffect = function(inst, value)
        if inst.components.fueled ~= nil then
            if value ~= 1 then
                inst.components.fueled.rate_modifiers:SetModifier(inst, value, "wilsonskill")
            else
                inst.components.fueled.rate_modifiers:RemoveModifier(inst, "wilsonskill")
            end
        end
    end

    hat_fns.candle_ongetskillfueleffectmodifier = function(skilltreeupdater)
        return (skilltreeupdater:IsActivated("wilson_torch_3") and TUNING.SKILLS.WILSON_TORCH_3)
        or (skilltreeupdater:IsActivated("wilson_torch_2") and TUNING.SKILLS.WILSON_TORCH_2)
        or (skilltreeupdater:IsActivated("wilson_torch_1") and TUNING.SKILLS.WILSON_TORCH_1)
        or 1
    end

    hat_fns.candle_ongetskillbrightnesseffectmodifier = function(skilltreeupdater)
        return (skilltreeupdater:IsActivated("wilson_torch_6") and TUNING.SKILLS.WILSON_TORCH_6)
        or (skilltreeupdater:IsActivated("wilson_torch_5") and TUNING.SKILLS.WILSON_TORCH_5)
        or (skilltreeupdater:IsActivated("wilson_torch_4") and TUNING.SKILLS.WILSON_TORCH_4)
        or 1
    end

    hat_fns.candle_onskillrefresh = function(inst, owner)
        local skilltreeupdater = owner ~= nil and owner.components.skilltreeupdater or nil

        if skilltreeupdater ~= nil then
            hat_fns.candle_onapplyskillbrightness(inst, hat_fns.candle_ongetskillbrightnesseffectmodifier(skilltreeupdater))
            hat_fns.candle_onapplyskillfueleffect(inst, hat_fns.candle_ongetskillfueleffectmodifier(skilltreeupdater))
        else
            hat_fns.candle_onapplyskillbrightness(inst, 1)
            hat_fns.candle_onapplyskillfueleffect(inst, 1)
        end
    end

    hat_fns.candle_onwatchskillrefresh = function(inst, owner)
        if inst.candle_owner then
            inst:RemoveEventCallback("onactivateskill_server", inst.candle_onskillrefresh, inst.candle_owner)
            inst:RemoveEventCallback("ondeactivateskill_server", inst.candle_onskillrefresh, inst.candle_owner)
        end

        inst.candle_owner = owner

        if owner then
            inst:ListenForEvent("onactivateskill_server", inst.candle_onskillrefresh, owner)
            inst:ListenForEvent("ondeactivateskill_server", inst.candle_onskillrefresh, owner)
        end
    end

    hat_fns.candle_onturnon = function(inst, owner)
        if owner ~= nil then
            if inst.components.fueled ~= nil then
                if not inst.components.fueled:IsEmpty() then
                    inst.components.fueled:StartConsuming()

                    if inst.components.lighter == nil then
                        inst:AddTag("lighter")
                        inst:AddComponent("lighter")
                    end

                    inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_LP", "torch")
                    inst.SoundEmitter:SetParameter("torch", "intensity", 1)

                    if not inst.candlefire then
                        inst.candlefire = SpawnPrefab("torchfire_rag")

                        if inst.candlefire then
                            local follower = inst.candlefire.entity:AddFollower()
                            follower:FollowSymbol(owner.GUID, "swap_hat", 0, -250, 0)

                            inst.candlefire:AddTag("fire")
                        end
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

                if inst.components.lighter ~= nil then
                    inst:RemoveTag("lighter")
                    inst:RemoveComponent("lighter")
                end

                if not inst.components.fueled:IsEmpty() then
                    inst.SoundEmitter:PlaySound("dontstarve/common/fireOut")
                end
            end
        end
    end

    hat_fns.candle_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)
        hat_fns.candle_onturnon(inst, owner)

        hat_fns.candle_onwatchskillrefresh(inst, owner)
        hat_fns.candle_onskillrefresh(inst, owner)
    end

    hat_fns.candle_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)
        hat_fns.candle_onturnoff(inst, owner)

        hat_fns.candle_onwatchskillrefresh(inst, nil)
        hat_fns.candle_onskillrefresh(inst, nil)
    end

    hat_fns.candle_onequiptomodel = function(inst, owner, from_ground)
        hat_fns.simple_onequiptomodel(inst, owner, from_ground)
        hat_fns.candle_onturnoff(inst, owner)

        hat_fns.candle_onwatchskillrefresh(inst, nil)
        hat_fns.candle_onskillrefresh(inst, nil)
    end

    hat_fns.candle_onperish = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        local equipped = inst.components.equippable ~= nil and inst.components.equippable:IsEquipped()

        if equipped and owner ~= nil then
            hat_fns.candle_onturnoff(inst, owner)

            inst.SoundEmitter:PlaySound("dontstarve/common/fireOut")

            local data =
            {
                prefab = inst.prefab,
                equipslot = inst.components.equippable.equipslot,
                announce = "ANNOUNCE_TORCH_OUT",
            }

            owner:PushEvent("itemranout", data)
        end
    end

    hat_fns.candle_ondropped = function(inst, owner)
        hat_fns.candle_onturnoff(inst, owner)
    end

    hat_fns.candle_ontakefuel = function(inst)
        inst.SoundEmitter:KillSound("addfuel")
        inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel", "addfuel", 0.5)

        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

            if owner ~= nil then
                hat_fns.candle_onturnon(inst, owner)
            end
        end
    end

    hat_fns.candle_onupdatefuel = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        local owner_protected = owner ~= nil and
        (owner.components.sheltered ~= nil and owner.components.sheltered.sheltered or owner.components.rainimmunity ~= nil)

        if inst.components.fueled ~= nil then
            inst.components.fueled.rate = (owner_protected or inst.components.rainimmunity ~= nil)
            and (inst.candle_fuelratemult or 1) or (1 + TUNING.APO_HATS.CANDLE.RAIN_RATE * TheWorld.state.precipitationrate)
            * (inst.candle_fuelratemult or 1)
        end
    end

    hat_fns.candle_onisraining = function(inst, israining)
        if inst.components.fueled ~= nil then
            if israining then
                inst.components.fueled:SetUpdateFn(hat_fns.candle_onupdatefuel)
                hat_fns.candle_onupdatefuel(inst)
            else
                inst.components.fueled:SetUpdateFn()
                inst.components.fueled.rate = inst.candle_fuelratemult or 1
            end
        end
    end

    hat_fns.candle_onfuelratemult = function(inst, mult)
        mult = mult ~= 1 and mult or nil

        if inst.candle_fuelratemult ~= mult then
            inst.candle_fuelratemult = mult
            hat_fns.candle_onisraining(inst, TheWorld.state.israining)
        end
    end

    hat_fns.candle_custom_init = function(inst)
        inst.entity:AddSoundEmitter()

        inst:AddTag("torch")
        inst:AddTag("wildfireprotected")
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

        inst:AddComponent("burnable")
        inst.components.burnable.canlight = false
        inst.components.burnable.fxprefab = nil

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.BURNABLE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.CANDLE.PERISHTIME)
        inst.components.fueled:SetDepletedFn(hat_fns.candle_onperish)
        inst.components.fueled.ontakefuelfn = hat_fns.candle_ontakefuel
        inst.components.fueled.accepting = true

        inst.candle_onskillrefresh = function(owner)
            hat_fns.candle_onskillrefresh(inst, owner)
        end

        inst:WatchWorldState("israining", hat_fns.candle_onisraining)
        hat_fns.candle_onisraining(inst, TheWorld.state.israining)

        inst.candle_fuelratemult = nil
        inst.candle_onfuelratemult = hat_fns.candle_onfuelratemult

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
        hat_fns.simple_onequiptomodel(inst, owner, from_ground)

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

        if TUNING.APO_TWEAK_RESTRICTED then
            inst.components.equippable.restrictedtag = "spiderwhisperer"
        end

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
        inst.components.equippable.insulated = true

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)

        inst:AddComponent("insulator")
        inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
        inst.components.insulator:SetSummer()

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.DOUBLE_UMBRELLA.PERISHTIME)
        inst.components.fueled:SetDepletedFn(hat_fns.double_umbrella_onperish)

        return inst
    end

    hat_fns.gas_custom_init = function(inst)
        inst:AddTag("acidrainimmune")
    end

    hat_fns.gas = function()
        local inst = simple(hat_fns.gas_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable.dapperness = TUNING.DAPPERNESS_TINY

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.GAS.PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)

        return inst
    end

    hat_fns.gasmask_onequip = function(inst, owner)
        hat_fns.opentop_onequip(inst, owner)

        if owner ~= nil then
            owner:AddTag("gasimmune")
        end
    end

    hat_fns.gasmask_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            owner:RemoveTag("gasimmune")
        end
    end

    hat_fns.gasmask_custom_init = function(inst)
        inst:AddTag("goggles")
        inst:AddTag("gasmask")
        inst:AddTag("miasmaimmune")
        inst:AddTag("open_top_hat")
        inst:AddTag("waterproofer")
    end

    hat_fns.gasmask = function()
        local inst = simple(hat_fns.gasmask_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
        inst.components.equippable:SetOnEquip(hat_fns.gasmask_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.gasmask_onunequip)

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.GASMASK.PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)

        return inst
    end

    hat_fns.luckytreasure_onspawntreasure = function(new_sec, old_sec, inst, doer)
        if new_sec >= old_sec then
            return
        end

        if inst.components.buriedtreasurefinder ~= nil then
            inst.components.buriedtreasurefinder:FindTreasure()
            inst.components.buriedtreasurefinder:RevealTreasure()
        end
    end

    hat_fns.luckytreasure_onupdate = function(inst, owner)
        if owner ~= nil then
            if owner:GetCurrentPlatform() then
                if inst.components.equippable ~= nil then
                    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE
                end
            else
                if inst.components.equippable ~= nil then
                    inst.components.equippable.dapperness = 0
                end
            end
        end
    end

    hat_fns.luckytreasure_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            inst:AddTag("luckysource")

            if owner.components.luckuser ~= nil then
                owner.components.luckuser:SetLuckSource(TUNING.APO_HATS.LUCKYTREASURE.LUCK, inst)
            end

            if inst.components.buriedtreasurefinder ~= nil then
                inst.components.buriedtreasurefinder:Start(owner)
            end

            inst:ListenForEvent("player_on_platform", inst.luckytreasure_onplatform, owner)
            inst:ListenForEvent("player_off_platform", inst.luckytreasure_offplatform, owner)

            hat_fns.luckytreasure_onupdate(inst, owner)
        end
    end

    hat_fns.luckytreasure_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            inst:RemoveTag("luckysource")

            if owner.components.luckuser ~= nil then
                owner.components.luckuser:RemoveLuckSource(inst)
            end

            if inst.components.buriedtreasurefinder ~= nil then
                inst.components.buriedtreasurefinder:Stop()
            end

            if inst.components.equippable ~= nil then
                inst.components.equippable.dapperness = 0
            end

            inst:RemoveEventCallback("player_on_platform", inst.luckytreasure_onplatform, owner)
            inst:RemoveEventCallback("player_off_platform", inst.luckytreasure_offplatform, owner)
        end
    end

    -- Yeah, no way I will let you guys farm treasures using mannequins.
    hat_fns.luckytreasure_onequiptomodel = function(inst, owner, from_ground)
        hat_fns.simple_onequiptomodel(inst, owner, from_ground)

        if owner ~= nil then
            if inst.components.buriedtreasurefinder ~= nil then
                inst.components.buriedtreasurefinder:Stop()
            end

            if inst.components.equippable ~= nil then
                inst.components.equippable.dapperness = 0
            end

            inst:RemoveEventCallback("player_on_platform", inst.luckytreasure_onplatform, owner)
            inst:RemoveEventCallback("player_off_platform", inst.luckytreasure_offplatform, owner)
        end
    end

    hat_fns.luckytreasure_custom_init = function(inst)
        inst:AddTag("buriedtreasurefinder")
        inst:AddTag("waterproofer")
    end

    hat_fns.luckytreasure = function()
        local inst = simple(hat_fns.luckytreasure_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.luckytreasure_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.luckytreasure_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.luckytreasure_onequiptomodel)
        inst.components.equippable.dapperness = 0

        inst:AddComponent("buriedtreasurefinder")

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.LUCKYTREASURE.PERISHTIME)
        inst.components.fueled:SetSections(TUNING.APO_HATS.LUCKYTREASURE.SECTIONS)
        inst.components.fueled:SetSectionCallback(hat_fns.luckytreasure_onspawntreasure)
        inst.components.fueled:SetDepletedFn(inst.Remove)

        inst.luckytreasure_onplatform = function(owner)
            hat_fns.luckytreasure_onupdate(inst, owner)
        end

        inst.luckytreasure_offplatform = function(owner)
            hat_fns.luckytreasure_onupdate(inst, owner)
        end

        return inst
    end

    hat_fns.metalplate_getsetbonusequip = function(inst, owner)
        local body = owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil
        return body ~= nil and body.prefab == "armor_metalplate" and body or nil
    end

    hat_fns.metalplate_custom_init = function(inst)
        inst:AddTag("heavyarmor")
        inst:AddTag("hardarmor")
    end

    hat_fns.metalplate = function()
        local inst = simple(hat_fns.metalplate_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable.walkspeedmult = TUNING.APO_HATS.METALPLATE.WALKSPEEDMULT

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.APO_HATS.METALPLATE.CONDITION, TUNING.APO_HATS.METALPLATE.ABSORPTION)

        inst:AddComponent("setbonus")
        inst.components.setbonus:SetSetName(EQUIPMENTSETNAMES.METALPLATE)

        return inst
    end

    hat_fns.ox_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            owner:AddTag("beefalo")
        end
    end

    hat_fns.ox_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            owner:RemoveTag("beefalo")
        end
    end

    hat_fns.ox_onequiptomodel = function(inst, owner, from_ground)
        if owner ~= nil then
            owner:RemoveTag("beefalo")
        end
    end

    hat_fns.ox_custom_init = function(inst)
        inst:AddTag("waterproofer")
    end

    hat_fns.ox = function()
        local inst = simple(hat_fns.ox_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.ox_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.ox_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.ox_onequiptomodel)

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.APO_HATS.OX.CONDITION, TUNING.APO_HATS.OX.ABSORPTION)

        inst:AddComponent("damagetyperesist")
        inst.components.damagetyperesist:AddResist("explosive", inst, TUNING.APO_HATS.OX.DAMAGETYPE_RESIST)

        return inst
    end

    hat_fns.pigcrown_onapplyhealthbuff = function(follower)
        if follower.pigcrown_bonushealth then
            return
        end

        if follower.components.health ~= nil and not follower.components.health:IsDead() then
            local current_health = follower.components.health:GetPercent()
            local bonus = follower.components.health.maxhealth * (TUNING.APO_HATS.PIGCROWN.MODIFIERS.HEALTH - 1)

            follower.pigcrown_bonushealth = bonus

            follower.components.health:SetMaxHealth(follower.components.health.maxhealth + bonus)
            follower.components.health:SetPercent(current_health)
        end
    end

    hat_fns.pigcrown_onremovehealthbuff = function(follower)
        local bonus = follower.pigcrown_bonushealth

        if bonus == nil then
            return
        end

        if follower.components.health ~= nil then
            local current_health = follower.components.health:GetPercent()

            follower.components.health:SetMaxHealth(math.max(1, follower.components.health.maxhealth - bonus))
            follower.components.health:SetPercent(current_health)
        end

        follower.pigcrown_bonushealth = nil
    end

    hat_fns.pigcrown_onapplyfollowerbuff = function(follower)
        local MODIFIER = TUNING.APO_HATS.PIGCROWN.MODIFIERS.DAMAGE

        if follower.components.combat ~= nil and not follower:HasAnyTag("abigail", "nofolloweramplifier") then
            follower.components.combat.externaldamagemultipliers:SetModifier(follower, MODIFIER, "pigcrownhat")
        end

        hat_fns.pigcrown_onapplyhealthbuff(follower)
    end

    hat_fns.pigcrown_onremovefollowerbuff = function(follower)
        if follower.components.combat ~= nil then
            follower.components.combat.externaldamagemultipliers:RemoveModifier(follower, "pigcrownhat")
        end

        hat_fns.pigcrown_onremovehealthbuff(follower)
    end

    hat_fns.pigcrown_onupdatefollowers = function(owner, fn)
        local leader = owner.components.leader

        if leader ~= nil and leader.followers ~= nil then
            for follower in pairs(leader.followers) do
                if follower ~= nil and follower.components.combat ~= nil
                and follower.components.health ~= nil and not follower.components.health:IsDead() then
                    fn(follower)
                end
            end
        end
    end

    hat_fns.pigcrown_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            hat_fns.pigcrown_onupdatefollowers(owner, hat_fns.pigcrown_onapplyfollowerbuff)

            owner:ListenForEvent("followeradded", inst.pigcrown_onfolloweradded)
        end
    end

    hat_fns.pigcrown_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            hat_fns.pigcrown_onupdatefollowers(owner, hat_fns.pigcrown_onremovefollowerbuff)

            owner:RemoveEventCallback("followeradded", inst.pigcrown_onfolloweradded)
        end
    end

    hat_fns.pigcrown_custom_init = function(inst, owner)
        inst:AddTag("regal")
        inst:AddTag("followeramplifier")
        inst:AddTag("waterproofer")
    end

    hat_fns.pigcrown = function()
        local inst = simple(hat_fns.pigcrown_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.tradable.goldvalue = TUNING.APO_HATS.PIGCROWN.GOLDVALUE

        inst.components.equippable:SetOnEquip(hat_fns.pigcrown_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.pigcrown_onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_MED)

        inst.pigcrown_onfolloweradded = function(owner, data)
            local follower = data ~= nil and data.follower or nil

            if follower ~= nil and follower.components.combat ~= nil
            and follower.components.health ~= nil and not follower.components.health:IsDead() then
                hat_fns.pigcrown_onapplyfollowerbuff(follower)
            end
        end

        return inst
    end

    hat_fns.pirate_onupdate = function(inst, owner)
        local MODIFIER = TUNING.APO_HATS.PIRATE.MODIFIER

        if owner ~= nil then
            if owner:GetCurrentPlatform() then
                if owner.components.combat ~= nil then
                    owner.components.combat.externaldamagemultipliers:SetModifier(owner, MODIFIER, "piratehat")
                end

                if inst.components.equippable ~= nil then
                    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
                end
            else
                if owner.components.combat ~= nil then
                    owner.components.combat.externaldamagemultipliers:RemoveModifier(owner, "piratehat")
                end

                if inst.components.equippable ~= nil then
                    inst.components.equippable.dapperness = 0
                end
            end
        end
    end

    hat_fns.pirate_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            inst:ListenForEvent("player_on_platform", inst.pirate_onplatform, owner)
            inst:ListenForEvent("player_off_platform", inst.pirate_offplatform, owner)

            hat_fns.pirate_onupdate(inst, owner)
        end
    end

    hat_fns.pirate_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            if owner.components.combat ~= nil then
                owner.components.combat.externaldamagemultipliers:RemoveModifier(owner, "piratehat")
            end

            if inst.components.equippable ~= nil then
                inst.components.equippable.dapperness = 0
            end

            inst:RemoveEventCallback("player_on_platform", inst.pirate_onplatform, owner)
            inst:RemoveEventCallback("player_off_platform", inst.pirate_offplatform, owner)
        end
    end

    hat_fns.pirate_onequiptomodel = function(inst, owner, from_ground)
        hat_fns.simple_onequiptomodel(inst, owner, from_ground)

        if owner ~= nil then
            if owner.components.combat ~= nil then
                owner.components.combat.externaldamagemultipliers:RemoveModifier(owner, "piratehat")
            end

            if inst.components.equippable ~= nil then
                inst.components.equippable.dapperness = 0
            end

            inst:RemoveEventCallback("player_on_platform", inst.pirate_onplatform, owner)
            inst:RemoveEventCallback("player_off_platform", inst.pirate_offplatform, owner)
        end
    end

    hat_fns.pirate_custom_init = function(inst)
        inst:AddTag("waterproofer")
    end

    hat_fns.pirate = function()
        local inst = simple(hat_fns.pirate_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.pirate_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.pirate_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.pirate_onequiptomodel)
        inst.components.equippable.dapperness = 0

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.PIRATE.PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)

        inst.pirate_onplatform = function(owner)
            hat_fns.pirate_onupdate(inst, owner)
        end

        inst.pirate_offplatform = function(owner)
            hat_fns.pirate_onupdate(inst, owner)
        end

        return inst
    end

    hat_fns.pith_onslowmult = function(mult, reduction)
        if mult < 1 then
            local reclaim_speed_penalty = (1 - mult) * TUNING.APO_HATS.PITH.SLOWMULTIPLIER
            return math.min(mult + reclaim_speed_penalty, 1)
        end

        return mult
    end

    hat_fns.pith_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            if owner.components.locomotor ~= nil then
                if owner.pith_slowmultiplier == nil then
                    owner.pith_slowmultiplier = owner.components.locomotor.slowmultiplier
                end

                local SLOWMULTIPLIER = TUNING.APO_HATS.PITH.SLOWMULTIPLIER

                owner.components.locomotor:SetSlowMultiplier(hat_fns.pith_onslowmult(owner.pith_slowmultiplier, SLOWMULTIPLIER))

                if owner.pith_original_speed_modifier == nil then
                    owner.pith_original_speed_modifier = owner.ModifySpeedMultiplier
                    owner.pith_original_equippable_speed_modifier = owner.inventory_EquippableWalkSpeedMultModifier
                end

                local original_modify = owner.pith_original_speed_modifier
                local original_equippable_modify = owner.pith_original_equippable_speed_modifier

                owner.pith_speed_modifier = function(ent, mult, ...)
                    if original_modify ~= nil then
                        mult = original_modify(ent, mult, ...)
                    end

                    return hat_fns.pith_onslowmult(mult, SLOWMULTIPLIER)
                end

                owner.pith_equippable_speed_modifier = function(ent, mult, ...)
                    if original_equippable_modify ~= nil then
                        mult = original_equippable_modify(ent, mult, ...)
                    end

                    return hat_fns.pith_onslowmult(mult, SLOWMULTIPLIER)
                end

                owner.ModifySpeedMultiplier = owner.pith_speed_modifier
                owner.inventory_EquippableWalkSpeedMultModifier = owner.pith_equippable_speed_modifier

                owner.components.locomotor:SetTempGroundSpeedMultiplierModifier(owner.ModifySpeedMultiplier)
            end
        end
    end

    hat_fns.pith_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            if owner.components.locomotor ~= nil then
                if owner.pith_slowmultiplier ~= nil then
                    owner.components.locomotor:SetSlowMultiplier(owner.pith_slowmultiplier)
                    owner.pith_slowmultiplier = nil
                end

                owner.ModifySpeedMultiplier = owner.pith_original_speed_modifier
                owner.inventory_EquippableWalkSpeedMultModifier = owner.pith_original_equippable_speed_modifier

                owner.components.locomotor:SetTempGroundSpeedMultiplierModifier(owner.ModifySpeedMultiplier)

                owner.pith_original_speed_modifier = nil
                owner.pith_original_equippable_speed_modifier = nil
                owner.pith_speed_modifier = nil
                owner.pith_equippable_speed_modifier = nil
            end
        end
    end

    hat_fns.pith_custom_init = function(inst)
        inst:AddTag("waterproofer")
    end

    hat_fns.pith = function()
        local inst = simple(hat_fns.pith_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.pith_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.pith_onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.PITH.PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)

        return inst
    end

    hat_fns.shark_teeth_onspark = function(inst)
        if not inst.AnimState:IsCurrentAnimation("anim_sparkle") then
            inst.AnimState:PlayAnimation("anim_sparkle")
            inst.AnimState:PushAnimation("anim", true)
        end

        inst:DoTaskInTime(5 + math.random(), hat_fns.shark_teeth_onspark)
    end

    hat_fns.shark_teeth_onequip = function(inst, owner)
        hat_fns.opentop_onequip(inst, owner)

        if owner ~= nil then
            inst:AddTag("luckysource")

            if owner.components.luckuser ~= nil then
                owner.components.luckuser:SetLuckSource(TUNING.APO_HATS.SHARK_TEETH.LUCK, inst)
            end
        end
    end

    hat_fns.shark_teeth_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            inst:RemoveTag("luckysource")

            if owner.components.luckuser ~= nil then
                owner.components.luckuser:RemoveLuckSource(inst)
            end
        end
    end

    hat_fns.shark_teeth_custom_init = function(inst)
        inst:AddTag("open_top_hat")
    end

    hat_fns.shark_teeth = function()
        local inst = simple(hat_fns.shark_teeth_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.shark_teeth_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.shark_teeth_onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.SHARK_TEETH.PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)

        inst:DoTaskInTime(1, hat_fns.shark_teeth_onspark)

        return inst
    end

    hat_fns.snakeskin_getsetbonusequip = function(inst, owner)
        local body = owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil
        return body ~= nil and body.prefab == "armor_snakeskin" and body or nil
    end

    hat_fns.snakeskin_custom_init = function(inst)
        inst:AddTag("waterproofer")
    end

    hat_fns.snakeskin = function()
        local inst = simple(hat_fns.snakeskin_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable.insulated = true

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_HUGE)

        inst:AddComponent("setbonus")
        inst.components.setbonus:SetSetName(EQUIPMENTSETNAMES.SNAKESKIN)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.SNAKESKIN.PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)

        return inst
    end

    hat_fns.thunder_onsetbloom = function(inst, owner, enabled, lightoverride)
        lightoverride = lightoverride or 0

        if owner ~= nil then
            owner.AnimState:SetSymbolLightOverride("swap_hat", enabled and lightoverride or 0)

            if enabled then
                owner.AnimState:SetSymbolBloom("swap_hat")

                if owner.components.bloomer ~= nil then
                    owner.components.bloomer:PushBloom(inst, "shaders/anim.ksh", 1)
                else
                    owner.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
                end
            else
                owner.AnimState:ClearSymbolBloom("swap_hat")

                if owner.components.bloomer ~= nil then
                    owner.components.bloomer:PopBloom(inst)
                else
                    owner.AnimState:ClearBloomEffectHandle()
                end
            end
        end

        if (inst.thunder_charge_time or 0) > 0 then
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        else
            inst.AnimState:ClearBloomEffectHandle()
        end
    end

    hat_fns.thunder_oncansparks = function(inst)
        if inst == nil or (inst.thunder_charge_time or 0) <= 0 then
            return false
        end

        if inst.thunder_owner ~= nil then
            return true
        end

        if inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner ~= nil then
            return false
        end

        return not inst:IsInLimbo()
    end

    hat_fns.thunder_onstartspark = function(inst)
        if inst.thunder_spark_task ~= nil or not hat_fns.thunder_oncansparks(inst) then
            return
        end

        local function DoSpark(inst)
            inst.thunder_spark_task = nil

            if not hat_fns.thunder_oncansparks(inst) then
                return
            end

            local fx = SpawnPrefab("wx78_big_spark")

            if fx ~= nil then
                if inst.thunder_owner ~= nil then
                    fx.entity:SetParent(inst.thunder_owner.entity)
                    fx.Transform:SetPosition(0, 0, 0)
                else
                    local x, y, z = inst.Transform:GetWorldPosition()
                    fx.Transform:SetPosition(x, y, z)
                end
            end

            inst.thunder_spark_task = inst:DoTaskInTime(math.random(10, 30), DoSpark)
        end

        inst.thunder_spark_task = inst:DoTaskInTime(math.random(10, 30), DoSpark)
    end

    hat_fns.thunder_onstopspark = function(inst)
        if inst.thunder_spark_task ~= nil then
            inst.thunder_spark_task:Cancel()
            inst.thunder_spark_task = nil
        end
    end

    hat_fns.thunder_onstartattack = function(inst, owner)
        if owner.components.electricattacks == nil then
            owner:AddComponent("electricattacks")
        end

        owner.components.electricattacks:AddSource(inst)

        if inst._onattackother == nil then
            inst._onattackother = function(attacker, data)
                if data.weapon ~= nil then
                    if data.projectile == nil then
                        if data.weapon.components.projectile ~= nil then
                            return
                        elseif data.weapon.components.complexprojectile ~= nil then
                            return
                        elseif data.weapon.components.weapon ~= nil and data.weapon.components.weapon:CanRangedAttack() then
                            return
                        end
                    end

                    if data.weapon.components.weapon ~= nil and data.weapon.components.weapon.stimuli == "electric" then
                        return
                    end
                end

                SpawnElectricHitSparks(data.projectile ~= nil and data.projectile:IsValid()
                and data.projectile or attacker, data.owner, true)
            end

            inst:ListenForEvent("onattackother", inst._onattackother, owner)
        end

        SpawnPrefab("electricchargedfx"):SetTarget(owner)
    end

    hat_fns.thunder_onstopattack = function(inst, owner)
        if owner.components.electricattacks ~= nil then
            owner.components.electricattacks:RemoveSource(inst)
        end

        if inst._onattackother ~= nil then
            inst:RemoveEventCallback("onattackother", inst._onattackother, owner)
            inst._onattackother = nil
        end
    end

    hat_fns.thunder_onseteffects = function(inst, enabled, radius)
        local owner = inst.thunder_owner

        local THUNDER_LIGHT_RADIUS = TUNING.APO_HATS.THUNDER.LIGHT.RADIUS

        if not enabled or owner == nil or not owner:IsValid() then
            if inst.thunder_light ~= nil then
                inst.thunder_light:Remove()
                inst.thunder_light = nil
            end

            return
        end

        if inst.thunder_light == nil or not inst.thunder_light:IsValid() then
            inst.thunder_light = SpawnPrefab("thunderhat_light")

            if inst.thunder_light ~= nil then
                inst.thunder_light.entity:SetParent(owner.entity)
                inst.thunder_light.Transform:SetPosition(0, 0, 0)
            end
        end

        if inst.thunder_light ~= nil then
            inst.thunder_light.Light:SetRadius(radius or THUNDER_LIGHT_RADIUS)
        end

        hat_fns.thunder_onsetbloom(inst, owner, true, TUNING.APO_HATS.THUNDER.LIGHT.LIGHT_OVERRIDE)
    end

    hat_fns.thunder_ondisable = function(inst)
        local owner = inst.thunder_owner

        if inst.thunder_charged_task ~= nil then
            inst.thunder_charged_task:Cancel()
            inst.thunder_charged_task = nil
        end

        hat_fns.thunder_onstopspark(inst)
        hat_fns.thunder_onstopattack(inst, owner)
        hat_fns.thunder_onsetbloom(inst, owner, false, 0)
    end

    hat_fns.thunder_onupdatelight = function(inst)
        local charged = (inst.thunder_charge_time or 0) > 0

        local onground = inst.thunder_owner == nil and inst.components.inventoryitem ~= nil
        and inst.components.inventoryitem.owner == nil and not inst:IsInLimbo()

        if inst.Light ~= nil then
            inst.Light:Enable(charged and onground)
        end

        if charged and onground then
            inst:AddTag("charged")
        else
            inst:RemoveTag("charged")
        end
    end

    hat_fns.thunder_onupdate = function(inst, dt)
        local THUNDER_LIGHT_RADIUS = TUNING.APO_HATS.THUNDER.LIGHT.RADIUS

        inst.thunder_charge_time = math.max(0, (inst.thunder_charge_time or 0) - dt)

        hat_fns.thunder_onupdatelight(inst)

        if inst.thunder_charge_time <= 0 then
            inst.thunder_charge_time = 0

            hat_fns.thunder_ondisable(inst)
            hat_fns.thunder_onseteffects(inst, false)

            return
        end

        local radius = THUNDER_LIGHT_RADIUS

        if inst.thunder_charge_time < 60 then
            radius = math.max(0.1, THUNDER_LIGHT_RADIUS * (inst.thunder_charge_time / 60))
        end

        if inst.thunder_owner ~= nil then
            hat_fns.thunder_onseteffects(inst, true, radius)
        end
    end

    hat_fns.thunder_onenable = function(inst)
        local THUNDER_LIGHT_RADIUS = TUNING.APO_HATS.THUNDER.LIGHT.RADIUS

        if inst.thunder_charged_task == nil and inst.thunder_charge_time > 0 then
            inst.thunder_charged_task = inst:DoPeriodicTask(1, hat_fns.thunder_onupdate, nil, 1)
        end

        if inst.thunder_charge_time > 0 and inst.thunder_owner ~= nil then
            local radius = THUNDER_LIGHT_RADIUS

            if inst.thunder_charge_time < 60 then
                radius = math.max(0.1, THUNDER_LIGHT_RADIUS * (inst.thunder_charge_time / 60))
            end

            hat_fns.thunder_onupdatelight(inst)
            hat_fns.thunder_onseteffects(inst, true, radius)
        end
    end

    hat_fns.thunder_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            inst.thunder_owner = owner

            if owner.components.playerlightningtarget ~= nil then
                if inst.playerlightningtarget_hitchance == nil then
                    inst.playerlightningtarget_hitchance = owner.components.playerlightningtarget.hitchance
                end

                owner.components.playerlightningtarget:SetHitChance(1)
            end

            owner:ListenForEvent("playerlightningtargeted", inst.thunder_lightningstrike)

            if inst.thunder_charge_time > 0 then
                hat_fns.thunder_onenable(inst)
                hat_fns.thunder_onstartspark(inst)
                hat_fns.thunder_onstartattack(inst, owner)
            else
                hat_fns.thunder_onseteffects(inst, false)
            end
        end
    end

    hat_fns.thunder_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            hat_fns.thunder_onstopattack(inst, owner)
            hat_fns.thunder_onsetbloom(inst, owner, false, 0)

            if owner.components.playerlightningtarget ~= nil and inst.playerlightningtarget_hitchance ~= nil then
                owner.components.playerlightningtarget:SetHitChance(inst.playerlightningtarget_hitchance)
            end

            owner:RemoveEventCallback("playerlightningtargeted", inst.thunder_lightningstrike)
        end

        inst.thunder_owner = nil

        hat_fns.thunder_onstopspark(inst)
        hat_fns.thunder_onseteffects(inst, false)
    end

    hat_fns.thunder_onequiptomodel = function(inst, owner, from_ground)
        hat_fns.simple_onequiptomodel(inst, owner, from_ground)

        if owner ~= nil then
            owner:RemoveEventCallback("playerlightningtargeted", inst.thunder_lightningstrike)
        end

        inst.thunder_owner = nil

        hat_fns.thunder_onseteffects(inst, false)
    end

    hat_fns.thunder_ondropped = function(inst)
        hat_fns.thunder_onupdatelight(inst)

        if hat_fns.thunder_oncansparks(inst) then
            hat_fns.thunder_onstartspark(inst)
        end
    end

    hat_fns.thunder_onputininventory = function(inst, guy)
        inst.Light:Enable(false)
        hat_fns.thunder_onstopspark(inst)

        if (inst.thunder_charge_time and inst.thunder_charge_time > 0) and inst:HasTag("charged") and guy ~= nil
        and guy.components.combat ~= nil and guy.components.inventory ~= nil and not guy.components.inventory:IsInsulated() then
            if not guy:HasAnyTag("shadowminion", "electricdamageimmune") then
                guy.components.health:DoDelta(-TUNING.APO_HATS.THUNDER.CHARGE.DAMAGE.PICKUP, nil, inst.prefab, nil, inst)
                guy.sg:HandleEvent("electrocute")
            end

            inst:RemoveTag("charged")
        end
    end

    hat_fns.thunder_onsave = function(inst, data)
        data.thunder_charge_time = inst.thunder_charge_time or 0
    end

    hat_fns.thunder_onload = function(inst, data)
        if data ~= nil and data.thunder_charge_time ~= nil then
            inst.thunder_charge_time = math.max(0, data.thunder_charge_time)
        end

        if inst.thunder_charge_time > 0 then
            hat_fns.thunder_onenable(inst)

            inst:DoTaskInTime(0, function(inst)
                hat_fns.thunder_onupdatelight(inst)
                hat_fns.thunder_onstartspark(inst)
            end)
        else
            inst.Light:Enable(false)

            hat_fns.thunder_onstopspark(inst)
            hat_fns.thunder_onseteffects(inst, false)

            inst:RemoveTag("charged")
        end
    end

    hat_fns.thunder_onremove = function(inst)
        if inst.thunder_light ~= nil and inst.thunder_light:IsValid() then
            inst.thunder_light:Remove()
        end
    end

    hat_fns.thunder_custom_init = function(inst)
        inst.entity:AddLight()

        inst.Light:SetFalloff(0.7)
        inst.Light:SetIntensity(0.5)
        inst.Light:SetRadius(0.5)
        inst.Light:SetColour(235/255, 121/255, 12/255)
        inst.Light:Enable(false)

        inst:AddTag("metal")
        inst:AddTag("lightningcatcher")
        inst:AddTag("waterproofer")
    end

    hat_fns.thunder = function()
        local inst = simple(hat_fns.thunder_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.thunder_charge_time = 0

        inst.components.inventoryitem:SetOnDroppedFn(hat_fns.thunder_ondropped)
        inst.components.inventoryitem:SetOnPutInInventoryFn(hat_fns.thunder_onputininventory)

        inst.components.equippable:SetOnEquip(hat_fns.thunder_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.thunder_onunequip)
        inst.components.equippable:SetOnEquipToModel(hat_fns.thunder_onequiptomodel)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
        -- inst.components.equippable.insulated = true -- We need to get struck...

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_MED)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.THUNDER.PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)
        inst.components.fueled.no_sewing = true

        inst.thunder_lightningstrike = function(owner)
            local THUNDER_MAX_CHARGE = TUNING.APO_HATS.THUNDER.CHARGE.MAX_DURATION
            local THUNDER_CHARGE_PER_STRIKE = TUNING.APO_HATS.THUNDER.CHARGE.DURATION

            if inst.components.fueled ~= nil then
                inst.components.fueled:DoDelta(TUNING.APO_HATS.THUNDER.CONSUPTION)
            end

            inst.thunder_charge_time = math.min(THUNDER_MAX_CHARGE, (inst.thunder_charge_time or 0) + THUNDER_CHARGE_PER_STRIKE)

            hat_fns.thunder_onenable(inst)
            hat_fns.thunder_onstartattack(inst, owner)
        end

        inst.OnSave = hat_fns.thunder_onsave
        inst.OnLoad = hat_fns.thunder_onload

        inst.OnRemoveEntity = hat_fns.thunder_onremove

        return inst
    end

    hat_fns.wagstaff_goggles_onsetup = function(inst)
        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(hat_fns.opentop_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.simple_onunequip)

        if TUNING.APO_TWEAK_RESTRICTED then
            inst.components.equippable.restrictedtag = "portableengineer"
        end
    end

    hat_fns.wagstaff_goggles_onbroken = function(inst)
        if inst.components.equippable ~= nil then
            inst:RemoveComponent("equippable")

            inst:AddTag("broken")

            if inst.components.inspectable ~= nil then
                inst.components.inspectable.nameoverride = "BROKEN_FORGEDITEM"
            end
        end
    end

    hat_fns.wagstaff_goggles_onrepaired = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        if owner ~= nil then
            owner:PushEvent("repair")
        end

        if inst.components.equippable == nil then
            hat_fns.wagstaff_goggles_onsetup(inst)

            inst:RemoveTag("broken")

            if inst.components.inspectable ~= nil then
                inst.components.inspectable.nameoverride = nil
            end
        end
    end

    hat_fns.wagstaff_goggles_custom_init = function(inst)
        inst:AddTag("goggles")
        inst:AddTag("goggles_wagstaff")
        inst:AddTag("show_broken_ui")
        inst:AddTag("open_top_hat")
    end

    hat_fns.wagstaff_goggles = function()
        local inst = simple(hat_fns.wagstaff_goggles_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.opentop_onequip)

        if TUNING.APO_TWEAK_RESTRICTED then
            inst.components.equippable.restrictedtag = "portableengineer"
        end

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.MAGIC
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.WAGSTAFF_GOGGLES.PERISHTIME)
        inst.components.fueled:SetDepletedFn(hat_fns.simple_onperish)

        local OnBroken = hat_fns.wagstaff_goggles_onbroken
        local OnRepaired = hat_fns.wagstaff_goggles_onrepaired

        MakeForgeRepairable(inst, FORGEMATERIALS.WAGPUNKBITS, OnBroken, OnRepaired)

        return inst
    end

    hat_fns.wagstaff_goggles_armor_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        if owner ~= nil then
            owner:PushEvent("wagstaff_goggles_armor_on")
        end
    end

    hat_fns.wagstaff_goggles_armor_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        if owner ~= nil then
            owner:PushEvent("wagstaff_goggles_armor_off")
        end
    end

    hat_fns.wagstaff_goggles_armor_onsetup = function(inst)
        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(hat_fns.wagstaff_goggles_armor_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.wagstaff_goggles_armor_onunequip)

        if TUNING.APO_TWEAK_RESTRICTED then
            inst.components.equippable.restrictedtag = "portableengineer"
        end
    end

    hat_fns.wagstaff_goggles_armor_onbroken = function(inst)
        if inst.components.equippable ~= nil then
            inst:RemoveComponent("equippable")

            inst:AddTag("broken")

            if inst.components.inspectable ~= nil then
                inst.components.inspectable.nameoverride = "BROKEN_FORGEDITEM"
            end
        end
    end

    hat_fns.wagstaff_goggles_armor_onrepaired = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        if owner ~= nil then
            owner:PushEvent("repair")
        end

        if inst.components.equippable == nil then
            hat_fns.wagstaff_goggles_armor_onsetup(inst)

            inst:RemoveTag("broken")

            if inst.components.inspectable ~= nil then
                inst.components.inspectable.nameoverride = nil
            end
        end
    end

    hat_fns.wagstaff_goggles_armor_custom_init = function(inst)
        inst.entity:AddSoundEmitter()

        inst:AddTag("metal")
        inst:AddTag("goggles")
        inst:AddTag("goggles_wagstaff")
        inst:AddTag("gogglesarmor")
        inst:AddTag("show_broken_ui")
        inst:AddTag("waterproofer")
    end

    hat_fns.wagstaff_goggles_armor = function()
        local inst = simple(hat_fns.wagstaff_goggles_armor_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.wagstaff_goggles_armor_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.wagstaff_goggles_armor_onunequip)
        inst.components.equippable.walkspeedmult = TUNING.APO_HATS.WAGSTAFF_GOGGLES_ARMOR.WALKSPEEDMULT

        if TUNING.APO_TWEAK_RESTRICTED then
            inst.components.equippable.restrictedtag = "portableengineer"
        end

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_MED)

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.APO_HATS.WAGSTAFF_GOGGLES_ARMOR.CONDITION, TUNING.APO_HATS.WAGSTAFF_GOGGLES_ARMOR.ABSORPTION)

        inst:AddComponent("planardefense")
        inst.components.planardefense:SetBaseDefense(TUNING.APO_HATS.WAGSTAFF_GOGGLES_ARMOR.PLANAR_ABSORPTION)

        local OnBroken = hat_fns.wagstaff_goggles_armor_onbroken
        local OnRepaired = hat_fns.wagstaff_goggles_armor_onrepaired

        MakeForgeRepairable(inst, FORGEMATERIALS.WAGPUNKBITS, OnBroken, OnRepaired)

        return inst
    end

    hat_fns.wagstaff_goggles_heat_onturnon = function(owner)
        if owner ~= nil then
            owner:PushEvent("wagstaff_goggles_on")
        end
    end

    hat_fns.wagstaff_goggles_heat_onturnoff = function(owner)
        if owner ~= nil then
            owner:PushEvent("wagstaff_goggles_off")
        end
    end

    hat_fns.wagstaff_goggles_heat_onequip = function(inst, owner)
        hat_fns.opentop_onequip(inst, owner)
        hat_fns.wagstaff_goggles_heat_onturnon(owner)

        if owner ~= nil then
            if owner.components.grue ~= nil then
                owner.components.grue:AddImmunity("wagstaff_goggles_heathat")
            end
        end
    end

    hat_fns.wagstaff_goggles_heat_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)
        hat_fns.wagstaff_goggles_heat_onturnoff(owner)

        if owner ~= nil then
            if owner.components.grue ~= nil then
                owner.components.grue:RemoveImmunity("wagstaff_goggles_heathat")
            end
        end
    end

    hat_fns.wagstaff_goggles_heat_onsetup = function(inst)
        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(hat_fns.wagstaff_goggles_heat_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.wagstaff_goggles_heat_onunequip)

        if TUNING.APO_TWEAK_RESTRICTED then
            inst.components.equippable.restrictedtag = "portableengineer"
        end
    end

    hat_fns.wagstaff_goggles_heat_onbroken = function(inst)
        if inst.components.equippable ~= nil then
            inst:RemoveComponent("equippable")

            inst:AddTag("broken")

            if inst.components.inspectable ~= nil then
                inst.components.inspectable.nameoverride = "BROKEN_FORGEDITEM"
            end
        end
    end

    hat_fns.wagstaff_goggles_heat_onrepaired = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        if owner ~= nil then
            owner:PushEvent("repair")
        end

        if inst.components.equippable == nil then
            hat_fns.wagstaff_goggles_heat_onsetup(inst)

            inst:RemoveTag("broken")

            if inst.components.inspectable ~= nil then
                inst.components.inspectable.nameoverride = nil
            end
        end
    end

    hat_fns.wagstaff_goggles_heat_custom_init = function(inst)
        inst.entity:AddSoundEmitter()

        inst:AddTag("metal")
        inst:AddTag("goggles")
        inst:AddTag("goggles_wagstaff")
        inst:AddTag("heatvision")
        inst:AddTag("show_broken_ui")
        inst:AddTag("open_top_hat")
    end

    hat_fns.wagstaff_goggles_heat = function()
        local inst = simple(hat_fns.wagstaff_goggles_heat_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(hat_fns.wagstaff_goggles_heat_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.wagstaff_goggles_heat_onunequip)

        if TUNING.APO_TWEAK_RESTRICTED then
            inst.components.equippable.restrictedtag = "portableengineer"
        end

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.MAGIC
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.WAGSTAFF_GOGGLES_HEAT.PERISHTIME)

        local OnBroken = hat_fns.wagstaff_goggles_heat_onbroken
        local OnRepaired = hat_fns.wagstaff_goggles_heat_onrepaired

        MakeForgeRepairable(inst, FORGEMATERIALS.WAGPUNKBITS, OnBroken, OnRepaired)

        return inst
    end

    hat_fns.wagstaff_goggles_shoot_onturnon = function(owner)
        if owner ~= nil then
            owner:PushEvent("wagstaff_goggles_on")
        end
    end

    hat_fns.wagstaff_goggles_shoot_onturnoff = function(owner)
        if owner ~= nil then
            owner:PushEvent("wagstaff_goggles_off")
        end
    end

    hat_fns.wagstaff_goggles_shoot_onattack = function(inst, attacker, target)
        if inst.components.fueled ~= nil then
            inst.components.fueled:DoDelta(-TUNING.APO_HATS.WAGSTAFF_GOGGLES_SHOOT.CONSUPTION)
        end
    end

    hat_fns.wagstaff_goggles_shoot_onequip = function(inst, owner)
        hat_fns.opentop_onequip(inst, owner)
        hat_fns.wagstaff_goggles_shoot_onturnon(owner)

        if owner ~= nil then
            if owner.components.grue ~= nil then
                owner.components.grue:AddImmunity("wagstaff_goggles_shoothat")
            end
        end
    end

    hat_fns.wagstaff_goggles_shoot_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)
        hat_fns.wagstaff_goggles_shoot_onturnoff(owner)

        if owner ~= nil then
            if owner.components.grue ~= nil then
                owner.components.grue:RemoveImmunity("wagstaff_goggles_shoothat")
            end
        end
    end

    hat_fns.wagstaff_goggles_shoot_onsetup = function(inst)
        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(hat_fns.wagstaff_goggles_shoot_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.wagstaff_goggles_shoot_onunequip)

        if TUNING.APO_TWEAK_RESTRICTED then
            inst.components.equippable.restrictedtag = "portableengineer"
        end
    end

    hat_fns.wagstaff_goggles_shoot_onbroken = function(inst)
        if inst.components.equippable ~= nil then
            inst:RemoveComponent("equippable")

            inst:AddTag("broken")

            if inst.components.inspectable ~= nil then
                inst.components.inspectable.nameoverride = "BROKEN_FORGEDITEM"
            end
        end
    end

    hat_fns.wagstaff_goggles_shoot_onrepaired = function(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        if owner ~= nil then
            owner:PushEvent("repair")
        end

        if inst.components.equippable == nil then
            hat_fns.wagstaff_goggles_shoot_onsetup(inst)

            inst:RemoveTag("broken")

            if inst.components.inspectable ~= nil then
                inst.components.inspectable.nameoverride = nil
            end
        end
    end

    hat_fns.wagstaff_goggles_shoot_custom_init = function(inst)
        inst.entity:AddSoundEmitter()

        inst:AddTag("metal")
        inst:AddTag("goggles")
        inst:AddTag("goggles_wagstaff")
        inst:AddTag("gogglesshoot")
        inst:AddTag("shootvision")
        inst:AddTag("rangedweapon")
        inst:AddTag("show_broken_ui")
        inst:AddTag("open_top_hat")
    end

    hat_fns.wagstaff_goggles_shoot = function()
        local inst = simple(hat_fns.wagstaff_goggles_shoot_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.wagstaff_goggles_shoot_damage = TUNING.APO_HATS.WAGSTAFF_GOGGLES_SHOOT.DAMAGE
        inst.wagstaff_goggles_shoot_stimuli = "electric"

        inst.components.equippable:SetOnEquip(hat_fns.wagstaff_goggles_shoot_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.wagstaff_goggles_shoot_onunequip)

        if TUNING.APO_TWEAK_RESTRICTED then
            inst.components.equippable.restrictedtag = "portableengineer"
        end

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.MAGIC
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.WAGSTAFF_GOGGLES_SHOOT.PERISHTIME)

        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(0)
        inst.components.weapon:SetRange(10, 12)
        inst.components.weapon:SetProjectile("wagstaff_goggles_shoothat_projectile")
        inst.components.weapon:SetOnAttack(hat_fns.wagstaff_goggles_shoot_onattack)

        local OnBroken = hat_fns.wagstaff_goggles_shoot_onbroken
        local OnRepaired = hat_fns.wagstaff_goggles_shoot_onrepaired

        MakeForgeRepairable(inst, FORGEMATERIALS.WAGPUNKBITS, OnBroken, OnRepaired)

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
    elseif name == "gas" then
        hat_fn = hat_fns.gas
    elseif name == "gasmask" then
        hat_fn = hat_fns.gasmask
    elseif name == "luckytreasure" then
        hat_fn = hat_fns.luckytreasure
    elseif name == "metalplate" then
        hat_fn = hat_fns.metalplate
    elseif name == "ox" then
        hat_fn = hat_fns.ox
    elseif name == "pigcrown" then
        hat_fn = hat_fns.pigcrown
    elseif name == "pirate" then
        hat_fn = hat_fns.pirate
    elseif name == "pith" then
        hat_fn = hat_fns.pith
    elseif name == "shark_teeth" then
        hat_fn = hat_fns.shark_teeth
    elseif name == "snakeskin" then
        hat_fn = hat_fns.snakeskin
    elseif name == "thunder" then
        prefabs = { "thunderhat_light", "wx78_big_spark", "electricchargedfx" }
        hat_fn = hat_fns.thunder
    elseif name == "wagstaff_goggles" then
        hat_fn = hat_fns.wagstaff_goggles
    elseif name == "wagstaff_goggles_armor" then
        hat_fn = hat_fns.wagstaff_goggles_armor
    elseif name == "wagstaff_goggles_heat" then
        hat_fn = hat_fns.wagstaff_goggles_heat
    elseif name == "wagstaff_goggles_shoot" then
        prefabs = { "wagstaff_goggles_shoothat_charge", "wagstaff_goggles_shoothat_projectile" }
        hat_fn = hat_fns.wagstaff_goggles_shoot
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
MakeHat("double_umbrella"),
MakeHat("gas"),
MakeHat("gasmask"),
MakeHat("luckytreasure"),
MakeHat("metalplate"),
MakeHat("ox"),
MakeHat("pigcrown"),
MakeHat("pirate"),
MakeHat("pith"),
MakeHat("shark_teeth"),
MakeHat("snakeskin"),
MakeHat("thunder"),
MakeHat("wagstaff_goggles"),
MakeHat("wagstaff_goggles_armor"),
MakeHat("wagstaff_goggles_heat"),
MakeHat("wagstaff_goggles_shoot")