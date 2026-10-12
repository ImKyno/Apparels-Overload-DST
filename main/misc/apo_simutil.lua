GLOBAL.setfenv(1, GLOBAL)

require("simutil")

local function _LOCAL_DoesEntityHaveBatVision(inst)
    if ThePlayer == nil or ThePlayer.HUD == nil or ThePlayer.HUD.batvision == nil then
        return false
    end

    if inst.components.playervision ~= nil and not inst.components.playervision:HasBatVision() then
        return false
    end

    local sonarlevel = ThePlayer.HUD.batvision:GetSonarLevel()

    if sonarlevel < TUNING.APO_MISC.BATVISION.CUT_OFF_RANGE then
        return false
    end

    return true
end

local function _LOCAL_CanEntitySeeInDark(inst)
    if inst.components.playervision ~= nil then
        return inst.components.playervision:HasBatVision()
    end

    local inventory = inst.replica.inventory
    
    return inst:HasTag("canseeindark") or (inventory ~= nil and inventory:EquipHasTag("batvision"))
end

local _CanEntitySeePoint = CanEntitySeePoint
function CanEntitySeePoint(inst, x, y, z, ...)
    return _CanEntitySeePoint(inst, x, y, z, ...)
    and (APOGetCheckLocalCanSee() == 0 or not _LOCAL_DoesEntityHaveBatVision(inst)
    or inst:GetDistanceSqToPoint(x, y, z) < TUNING.APO_MISC.BATVISION.VISION_RANGE_SQ)
end

local _CanEntitySeeInDark = CanEntitySeeInDark
function CanEntitySeeInDark(inst, ...)
    return _CanEntitySeeInDark(inst, ...) or _LOCAL_CanEntitySeeInDark(inst)
end