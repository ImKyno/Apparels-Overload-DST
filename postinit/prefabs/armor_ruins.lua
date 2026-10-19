local _G = GLOBAL

-- Thulecite Suit Set Bonus:
-- Increases Thulecite Club damage by 25% and allows it to perform a special attack.
local function OnGetEquippedWeapon(owner)
    if owner ~= nil and owner.components.inventory ~= nil then
        local weapon = owner.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HANDS)

        if weapon ~= nil and weapon.prefab == "ruins_bat" then
            return weapon
        end
    end

    return nil
end

local function OnEnabledSetBonus(inst)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

    if owner ~= nil then
        inst._armorruins_setbonus_owner = owner
        owner._armorruins_setbonus = inst

        local weapon = OnGetEquippedWeapon(owner)

        if weapon ~= nil then
            inst._armorruins_setbonus_weapon = weapon

            if weapon.OnUpdateSetBonus ~= nil then
                weapon:OnUpdateSetBonus()
            end
        end
    end
end

local function OnDisabledSetBonus(inst)
    local owner = inst._armorruins_setbonus_owner
    local weapon = inst._armorruins_setbonus_weapon

    if owner ~= nil then
        local weapon = OnGetEquippedWeapon(owner)

        if weapon ~= nil and weapon.OnUpdateSetBonus ~= nil then
            owner._armorruins_setbonus = nil
            weapon:OnUpdateSetBonus()
        else
            owner._armorruins_setbonus = nil
        end
    end

    inst._armorruins_setbonus_owner = nil
end

local function ArmorRuinsPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.setbonus == nil then
        inst:AddComponent("setbonus")
        inst.components.setbonus:SetSetName(_G.EQUIPMENTSETNAMES.THULECITE)
        inst.components.setbonus:SetOnEnabledFn(OnEnabledSetBonus)
        inst.components.setbonus:SetOnDisabledFn(OnDisabledSetBonus)
    end
end

if TUNING.APO_TWEAK_ARMORRUINS then
    AddPrefabPostInit("armorruins", ArmorRuinsPostInit)
end