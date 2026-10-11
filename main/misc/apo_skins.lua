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
        _G.basic_init_fn(inst, build_name, "aerodynamichat")
    end

    _G.aerodynamichat_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "aerodynamichat")
    end
end