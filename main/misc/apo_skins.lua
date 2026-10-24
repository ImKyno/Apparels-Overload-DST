local _G = GLOBAL

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    -- Sleek Hat.
    _G.aerodynamichat_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "hat_aerodynamic")
    end

    _G.aerodynamichat_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "hat_aerodynamic")
    end

    -- Cactus Husk.
    _G.armor_cactus_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "armor_cactus")
    end

    _G.armor_cactus_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "armor_cactus")
    end

    -- Leather Jacket.
    _G.armor_snakeskin_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "armor_snakeskin")
    end

    _G.armor_snakeskin_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "armor_snakeskin")
    end

    -- Rainbreaker.
    _G.armor_windbreaker_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "armor_windbreaker")
    end

    _G.armor_windbreaker_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "armor_windbreaker")
    end

    -- Dumbrella.
    _G.double_umbrellahat_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "hat_double_umbrella")
    end

    _G.double_umbrellahat_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "hat_double_umbrella")
    end

    -- Lune Woven Garland
    _G.foodbonushat_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "hat_foodbonus")
    end

    _G.foodbonushat_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "hat_foodbonus")
    end

    -- Gas Mask.
    _G.gasmaskhat_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "hat_gasmask")

        if build_name == "ms_hat_gasmask_hazard" then
            inst:AddTag("mufflehat")
        end
    end

    _G.gasmaskhat_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "hat_gasmask")

        inst:RemoveTag("mufflehat")
    end

    -- Lune Blossom Headband
    _G.healingbonushat_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "hat_healingbonus")
    end

    _G.healingbonushat_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "hat_healingbonus")
    end

    -- Bottle Lantern.
    _G.lanternbottle_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "lanternbottle")

        if inst.OnUpdateLightColour ~= nil then
            inst.OnUpdateLightColour(inst)
        end
    end

    _G.lanternbottle_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "lanternbottle")

        if inst.OnUpdateLightColour ~= nil then
            inst.OnUpdateLightColour(inst)
        end
    end

    -- Soulstealer's Crown
    _G.lifestealhat_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "hat_lifesteal")
    end

    _G.lifestealhat_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "hat_lifesteal")
    end

    -- Respledent Guardian Helm
    _G.minotaurcrownhat_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "hat_minotaurcrown")
    end

    _G.minotaurcrownhat_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "hat_minotaurcrown")
    end

    -- Lunar Crystal Tiara
    _G.sanitydamagehat_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "hat_sanitydamage")
    end

    _G.sanitydamagehat_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "hat_sanitydamage")
    end

    -- Leather Hat
    _G.snakeskinhat_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "hat_snakeskin")
    end

    _G.snakeskinhat_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "hat_snakeskin")
    end
end