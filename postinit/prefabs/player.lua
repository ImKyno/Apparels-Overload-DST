local _G = GLOBAL

local function PlayerPostInit(inst)
    inst.damageovertimeactive = _G.net_bool(inst.GUID, "player.damageovertimeactive", "damageovertimeactive_dirty")
end

AddPlayerPostInit(PlayerPostInit)