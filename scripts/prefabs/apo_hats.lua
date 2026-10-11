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

    hat_fns.simple_onequip =  function(inst, owner, from_ground)
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
        inst.components.fueled:SetDepletedFn(inst.Remove)

        return inst
    end

    hat_fns.antmask_onequip = function(inst, owner)
        hat_fns.simple_onequip(inst, owner)

        owner:AddTag("beefriend")
    end

    hat_fns.antmask_onunequip = function(inst, owner)
        hat_fns.simple_onunequip(inst, owner)

        owner:RemoveTag("beefriend")
    end

    hat_fns.antmask_custom_init = function(inst)
        inst.AnimState:SetRayTestOnBB(true)

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

        inst.components.equippable:SetOnEquip(hat_fns.antmask_onequip)
        inst.components.equippable:SetOnUnequip(hat_fns.antmask_onunequip)

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.APO_HATS.ANTMASK.CONDITION, TUNING.APO_HATS.ANTMASK.ABSORPTION)
        inst.components.armor:SetTags(TUNING.APO_HATS.ANTMASK.TAGS)

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
    end

    table.insert(ALL_HAT_PREFAB_NAMES, prefabname)

    return Prefab(prefabname, hat_fn, assets, prefabs)
end

return MakeHat("aerodynamic"),
MakeHat("antmask"),
MakeHat("bandit")