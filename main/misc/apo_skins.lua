local _G = GLOBAL

-- Leather Jacket.
if not TUNING.APO_IS_ABC_ENABLED or TUNING.APO_IS_IAS_ENABLED then
    _G.armor_snakeskin_init_fn = function(inst, build_name)
        _G.basic_init_fn(inst, build_name, "armor_snakeskin")
    end

    _G.armor_snakeskin_clear_fn = function(inst)
        _G.basic_clear_fn(inst, "armor_snakeskin")
    end
end