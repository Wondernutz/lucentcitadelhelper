LCH = LCH or {}
local LCH = LCH
LCH.Dariel = {
}

LCH.Dariel.constants = {
  powerful_throw_id = 218971,
}

function LCH.Dariel.Init()

end

function LCH.Dariel.PowerfulThrow(result, targetType, targetUnitId, hitValue, abilityId)
  if result == ACTION_RESULT_BEGIN  and hitValue > 200 then
    CombatAlerts.AlertCast(abilityId, "", hitValue, {-2, 1})

    local unitTag = LCH.GetTagForId(targetUnitId)
    local icon = LCH.AddGroundIconOnPlayerForDuration(unitTag, "LucentCitadelHelper/icons/meeting-point.dds", hitValue + 1000)
  end
end
