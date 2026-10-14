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

    hat_fns.carnival_host_custom_init = function(inst)
        inst:AddTag("carnivalwinner")
    end

    hat_fns.carnival_host = function()
        local inst = simple(hat_fns.carnival_host_custom_init)

        if not TheWorld.ismastersim then
            return inst
        end

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

            inst.propeller_fan = SpawnPrefab("propeller_fan")
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

            inst.propeller_fan = SpawnPrefab("propeller_fan")
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
        inst.components.fueled.fueltype = FUELTYPE.GEARS
        inst.components.fueled:InitializeFuelLevel(TUNING.APO_HATS.PROPELLER.PERISHTIME)
        inst.components.fueled:SetTakeFuelFn(hat_fns.propeller_ontakefuel)
        inst.components.fueled:SetDepletedFn(hat_fns.propeller_onperish)
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
        inst.components.perishable:StartPerishing()
        inst.components.perishable:SetOnPerishFn(inst.Remove)

        inst.OnSave = hat_fns.pumpkinhead_onsave
        inst.OnLoad = hat_fns.pumpkinhead_onload

        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)

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

    if name == "bucket" then
        hat_fn = hat_fns.bucket
    elseif name == "carnival_host" then
        hat_fn = hat_fns.carnival_host
    elseif name == "extraheavy" then
        hat_fn = hat_fns.extraheavy
    elseif name == "jiaolian" then
        hat_fn = hat_fns.jiaolian
    elseif name == "peagawkfeather" then
        hat_fn = hat_fns.peagawkfeather
    elseif name == "propeller" then
        prefabs = { "propeller_fan" }
        hat_fn = hat_fns.propeller
    elseif name == "pumpkinhead" then
        hat_fn = hat_fns.pumpkinhead
    end

    table.insert(ALL_HAT_PREFAB_NAMES, prefabname)

    return Prefab(prefabname, hat_fn, assets, prefabs)
end

return MakeHat("bucket"),
MakeHat("carnival_host"),
MakeHat("extraheavy"),
MakeHat("jiaolian"),
MakeHat("peagawkfeather"),
MakeHat("propeller"),
MakeHat("pumpkinhead")