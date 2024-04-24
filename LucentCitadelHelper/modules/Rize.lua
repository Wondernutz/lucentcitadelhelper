LCH = LCH or {}
local LCH = LCH
LCH.Rize = {
  lastFluctuatingCurrent = 0,
  fluctuatingCurrentDuration = 0,
}

LCH.Rize.constants = {
  splintered_burst_id = 219799, -- Crystal Atronach AOE On Tank
  arcane_conveyance_cast_id = 223024, -- Tether cast
  arcane_conveyance_debuff_id = 223060, -- Tether debuff
  lustrous_javelin_id = 223546, -- Mantikora Javelin
  accelerating_charge_id = 214542, -- Channel before chain lightning
  fluctuating_current_id = 214597, -- Debuff when holding it
  overloaded_current_id = 214745, -- Debuff from holding/dropping fluctuating current
  tempest_id = 215107, -- Groupwide line mechanic from mirrors
}

function LCH.Rize.Init()
  LCH.Rize.lastFluctuatingCurrent = 0
  LCH.Rize.fluctuatingCurrentDuration = 0
end

function LCH.Rize.LustrousJavelin(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      CombatAlerts.AlertCast(LCH.Rize.constants.lustrous_javelin_id, "Lustrous Javelin", hitValue, {-3, 2})
    end
  end
end

function LCH.Rize.SplinteredBurst(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Alert("", "Splintered Burst", 0x66CCFFFF, LCH.Rize.constants.splintered_burst_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
    end

    LCH.AddIconForDuration(
      LCH.GetTagForId(targetUnitId),
      "LucentCitadelHelper/icons/target.dds",
      hitValue
    )
  end
end

function LCH.Rize.ArcaneConveyanceIncoming(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 1000 then
    LCH.Alert("", "Arcane Conveyance Incoming", 0xFFD700FF, LCH.Rize.constants.arcane_conveyance_cast_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
  end
end

function LCH.Rize.ArcaneConveyance(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Alert("", "Arcane Conveyance (you)", 0xFFD700FF, LCH.Rize.constants.arcane_conveyance_cast_id, SOUNDS.DUEL_START, 2000)
    end

    LCH.AddIconForDuration(
      LCH.GetTagForId(targetUnitId),
      "LucentCitadelHelper/icons/portalyellow.dds",
      hitValue
    )
  elseif result == ACTION_RESULT_EFFECT_FADED then
    LCH.RemoveIcon(LCH.GetTagForId(targetUnitId))
  end
end

function LCH.Rize.AcceleratingCharge(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 2000 then
    LCH.Alert("", "Chain Lightning", 0xFFD666FF, LCH.Rize.constants.accelerating_charge_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
    CombatAlerts.CastAlertsStart(LCH.Rize.constants.accelerating_charge_id, "Chain Lightning", hitValue, nil, nil, { hitValue, "Block!", 1, 0.4, 0, 0.5, nil })
  end
end

function LCH.Rize.Tempest(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 500 then
    LCH.Alert("", "Tempest", 0x6082B6FF, LCH.Rize.constants.tempest_id, SOUNDS.BATTLEGROUND_CAPTURE_FLAG_TAKEN_OWN_TEAM, 2000)
    CombatAlerts.CastAlertsStart(LCH.Rize.constants.tempest_id, "Tempest", hitValue, 10000, nil, nil)
  end
end

function LCH.Rize.FluctuatingCurrent(result, targetType, targetUnitId, hitValue)
  local borderId = "fluctuatingCurrent"

  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    LCH.Rize.lastFluctuatingCurrent = GetGameTimeSeconds()
    LCH.Rize.fluctuatingCurrentDuration = hitValue / 1000
    
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Alert("", "Fluctuating Current (you)", 0xFFD666FF, LCH.Rize.constants.fluctuating_current_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
      CombatAlerts.ScreenBorderEnable(0x22AAFF99, hitValue, borderId)
    end

    LCH.AddIconForDuration(
      LCH.GetTagForId(targetUnitId),
      "LucentCitadelHelper/icons/portal.dds",
      hitValue
    )

  elseif result == ACTION_RESULT_EFFECT_FADED then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      CombatAlerts.ScreenBorderDisable(borderId)
    end

    LCH.RemoveIcon(LCH.GetTagForId(targetUnitId))
  end
end

function LCH.Rize.OverloadedCurrent(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    LCH.AddIconForDuration(
      LCH.GetTagForId(targetUnitId),
      "LucentCitadelHelper/icons/portalpurple.dds",
      hitValue
    )
  elseif result == ACTION_RESULT_EFFECT_FADED then
    LCH.RemoveIcon(LCH.GetTagForId(targetUnitId))
  end
end

function LCH.Rize.UpdateTick(timeSec)
  LCHStatus:SetHidden(not (LCH.savedVariables.showFluctuatingCurrentTimer))

  LCH.Rize.FluctuatingCurrentUpdateTick(timeSec)
end

function LCH.Rize.FluctuatingCurrentUpdateTick(timeSec)
  LCHStatusLabelRize2:SetHidden(not (LCH.savedVariables.showFluctuatingCurrentTimer))
  LCHStatusLabelRize2Value:SetHidden(not (LCH.savedVariables.showFluctuatingCurrentTimer))

  local delta = timeSec - LCH.Rize.lastFluctuatingCurrent

  local timeLeft = LCH.Rize.fluctuatingCurrentDuration - delta

  LCHStatusLabelRize2Value:SetText(LCH.Rize.getSecondsRemainingString(timeLeft))
end

function LCH.Rize.getSecondsRemainingString(seconds)
  if seconds > 5 then 
    return string.format("%.0f", seconds) .. "s "
  elseif seconds > 0 then 
    return string.format("%.1f", seconds) .. "s "
  else
    return "-"
  end
end