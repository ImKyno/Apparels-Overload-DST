local _G = GLOBAL

local WEAPONS =
{
    "cane",
    "orangestaff",
    "walking_stick",
}

local function WeaponLowPriorityPostInit(inst)
    inst:AddTag("weaponlowpriority")
end

for k, v in pairs(WEAPONS) do
    AddPrefabPostInit(v, WeaponLowPriorityPostInit)
end