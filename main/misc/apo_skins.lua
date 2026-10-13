local _G = GLOBAL

if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    -- Leather Jacket.
    _G.armor_snakeskin_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "armor_snakeskin")
    end

    _G.armor_snakeskin_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "armor_snakeskin")
    end

    -- Sleek Hat.
    _G.aerodynamichat_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "hat_aerodynamic")
    end

    _G.aerodynamichat_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "hat_aerodynamic")
    end

    -- Dumbrella.
    _G.double_umbrellahat_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "hat_double_umbrella")
    end

    _G.double_umbrellahat_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "hat_double_umbrella")
    end
end