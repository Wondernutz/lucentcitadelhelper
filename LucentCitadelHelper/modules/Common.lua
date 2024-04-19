LCH = LCH or {}
local LCH = LCH
LCH.Common = {

}

LCH.Common.constants = {
  hindered_id = 165972,
}

function LCH.Common.Init()

end

function LCH.Common.Hindered(result, targetUnitId, hitValue)
  local isDPS, isHeal, isTank = GetPlayerRoles()
  if isDPS then
    return
  end
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    LCH.AddIconForDuration(
      LCH.GetTagForId(targetUnitId),
      "LucentCitadelHelper/icons/shattered.dds",
      hitValue)
  elseif result == ACTION_RESULT_HEAL_ABSORBED then
    -- TODO: Track how much healing is left.
  elseif result == ACTION_RESULT_EFFECT_FADED then
    LCH.RemoveIcon(LCH.GetTagForId(targetUnitId))
  end
end