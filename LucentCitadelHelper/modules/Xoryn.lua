LCH = LCH or {}
local LCH = LCH
LCH.Xoryn = {
  lastFluctuatingCurrent = 0,
  fluctuatingCurrentDuration = 0,
}

LCH.Xoryn.constants = {
  splintered_burst_id = 219799, -- Crystal Atronach AOE On Tank
  arcane_conveyance_cast_id = 223024, -- Tether cast
  arcane_conveyance_debuff_id = 223060, -- Tether debuff

  necrotic_spear_id = 219928, -- buff id for when it fully spawns?

  necrotic_rain_id = 222809, -- necromancer bridge
  necrotic_rain_first_cd = 16, -- first cast of rain
  necrotic_rain_cd = 33, -- cooldown

  lustrous_javelin_id = 223546, -- Mantikora Javelin
  accelerating_charge_id = 214542, -- Channel before chain lightning
  fluctuating_current_id = 214597, -- Debuff when holding it
  overloaded_current_id = 214745, -- Debuff from holding/dropping fluctuating current
  tempest_id = 215107, -- Groupwide line mechanic from mirrors
}

function LCH.Xoryn.Init()
  LCH.Xoryn.lastNecroticRain = GetGameTimeSeconds()
  LCH.Xoryn.isFirstNecroticRain = true
  LCH.Xoryn.mzrelnirActive = false
  LCH.Xoryn.lastFluctuatingCurrent = 0
  LCH.Xoryn.fluctuatingCurrentDuration = 0
end

function LCH.Xoryn.LustrousJavelin(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      CombatAlerts.AlertCast(LCH.Xoryn.constants.lustrous_javelin_id, "Lustrous Javelin", hitValue, {-3, 2})
    end
  end
end

function LCH.Xoryn.SplinteredBurst(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Alert("", "Splintered Burst", 0x66CCFFFF, LCH.Xoryn.constants.splintered_burst_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
    end

    LCH.AddIconForDuration(
      LCH.GetTagForId(targetUnitId),
      "LucentCitadelHelper/icons/target.dds",
      hitValue
    )
  end
end

function LCH.Xoryn.ArcaneConveyanceIncoming(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 1000 then
    LCH.Alert("", "Arcane Conveyance Incoming", 0xFFD700FF, LCH.Xoryn.constants.arcane_conveyance_cast_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
  end
end

function LCH.Xoryn.ArcaneConveyance(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Alert("", "Arcane Conveyance (you)", 0xFFD700FF, LCH.Xoryn.constants.arcane_conveyance_cast_id, SOUNDS.DUEL_START, 2000)
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

function LCH.Xoryn.NecroticSpear(result, targetType, targetUnitId, hitValue)
  -- Mzrelnir first becomes active when a Necromancer casts Necrotic Spear
  if result == ACTION_RESULT_BEGIN then
    LCH.Xoryn.mzrelnirActive = true
    LCH.Xoryn.lastNecroticRain = GetGameTimeSeconds()
    LCH.Xoryn.isFirstNecroticRain = true
  end
end

function LCH.Xoryn.NecroticRain(result, targetType, targetUnitId, hitValue)
  -- Mzrelnir Necrotic Rain
  if result == ACTION_RESULT_BEGIN and hitValue > 500 then
    LCH.Xoryn.lastNecroticRain = GetGameTimeSeconds()
    LCH.Xoryn.isFirstNecroticRain = false
    
    LCH.Alert("", "Necrotic Rain (Don't Stack)", 0xFFD666FF, LCH.Xoryn.constants.necrotic_rain_id, SOUNDS.OBJECTIVE_DISCOVERED, 6000)
    CombatAlerts.AlertCast(LCH.Xoryn.constants.necrotic_rain_id, "Necrotic Rain", hitValue, {-3, 0})
  end
end

function LCH.Xoryn.AcceleratingCharge(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 2000 then
    LCH.Alert("", "Chain Lightning", 0xFFD666FF, LCH.Xoryn.constants.accelerating_charge_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
    CombatAlerts.CastAlertsStart(LCH.Xoryn.constants.accelerating_charge_id, "Chain Lightning", hitValue, nil, nil, { hitValue, "Block!", 1, 0.4, 0, 0.5, nil })
  end
end

function LCH.Xoryn.Tempest(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 500 then
    LCH.Alert("", "Tempest", 0x6082B6FF, LCH.Xoryn.constants.tempest_id, SOUNDS.BATTLEGROUND_CAPTURE_FLAG_TAKEN_OWN_TEAM, 2000)
    CombatAlerts.CastAlertsStart(LCH.Xoryn.constants.tempest_id, "Tempest", hitValue, 10000, nil, nil)
  end
end

function LCH.Xoryn.FluctuatingCurrent(result, targetType, targetUnitId, hitValue)
  local borderId = "fluctuatingCurrent"

  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    LCH.Xoryn.lastFluctuatingCurrent = GetGameTimeSeconds()
    LCH.Xoryn.fluctuatingCurrentDuration = hitValue / 1000
    
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Alert("", "Fluctuating Current (you)", 0xFFD666FF, LCH.Xoryn.constants.fluctuating_current_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
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

function LCH.Xoryn.OverloadedCurrent(result, targetType, targetUnitId, hitValue)
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

function LCH.Xoryn.UpdateTick(timeSec)
  LCHStatus:SetHidden(not (LCH.savedVariables.showFluctuatingCurrentTimer))
  LCHStatus:SetHidden(not (LCH.savedVariables.showNecroticRainTimer))
  
  LCH.Xoryn.FluctuatingCurrentUpdateTick(timeSec)
  LCH.Xoryn.NecroticRainUpdateTick(timeSec)
end

function LCH.Xoryn.FluctuatingCurrentUpdateTick(timeSec)
  LCHStatusLabelXoryn2:SetHidden(not (LCH.savedVariables.showFluctuatingCurrentTimer))
  LCHStatusLabelXoryn2Value:SetHidden(not (LCH.savedVariables.showFluctuatingCurrentTimer))

  local delta = timeSec - LCH.Xoryn.lastFluctuatingCurrent

  local timeLeft = LCH.Xoryn.fluctuatingCurrentDuration - delta

  LCHStatusLabelXoryn2Value:SetText(LCH.Xoryn.getSecondsRemainingString(timeLeft))
end

function LCH.Xoryn.getSecondsRemainingString(seconds)
  if seconds > 5 then 
    return string.format("%.0f", seconds) .. "s "
  elseif seconds > 0 then 
    return string.format("%.1f", seconds) .. "s "
  else
    return "-"
  end
end

function LCH.Xoryn.NecroticRainUpdateTick(timeSec)
  LCHStatusLabelXoryn1:SetHidden(not (LCH.savedVariables.showNecroticRainTimer and LCH.Xoryn.mzrelnirActive))
  LCHStatusLabelXoryn1Value:SetHidden(not (LCH.savedVariables.showNecroticRainTimer and LCH.Xoryn.mzrelnirActive))

  local delta = timeSec - LCH.Xoryn.lastNecroticRain

  local timeLeft = 0
  if LCH.Xoryn.isFirstNecroticRain then
    timeLeft = LCH.Xoryn.constants.necrotic_rain_first_cd - delta
  else
    timeLeft = LCH.Xoryn.constants.necrotic_rain_cd - delta
  end

  LCHStatusLabelXoryn1Value:SetText(LCH.GetSecondsRemainingString(timeLeft))
end