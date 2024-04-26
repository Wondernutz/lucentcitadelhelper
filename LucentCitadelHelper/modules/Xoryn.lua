LCH = LCH or {}
local LCH = LCH
LCH.Xoryn = {
  lastFluctuatingCurrent = 0,
  fluctuatingCurrentDuration = 0,

  lastOverloadedCurrent = 0,
  overloadedCurrentDuration = 0,

  activeIcons = {}
}

LCH.Xoryn.constants = {
  splintered_burst_id = 219799, -- Crystal Atronach AOE On Tank
  glass_stomp_id = 219797, -- Splintered Shards cast ID
  arcane_conveyance_cast_id = 223024, -- Tether cast
  arcane_conveyance_debuff_id = 223060, -- Tether debuff
  lustrous_javelin_id = 223546, -- Mantikora Javelin
  accelerating_charge_id = 214542, -- Channel before chain lightning
  fluctuating_current_id = 214597, -- Debuff when holding it
  overloaded_current_id = 214745, -- Debuff from holding/dropping fluctuating current
  tempest_id = 215107, -- Groupwide line mechanic from mirrors
}

function LCH.Xoryn.Init()
  LCH.Xoryn.lastFluctuatingCurrent = 0
  LCH.Xoryn.fluctuatingCurrentDuration = 0

  LCH.Xoryn.lastOverloadedCurrent = 0
  LCH.Xoryn.overloadedCurrentDuration = 0
end

function LCH.Xoryn.SplinteredBurst(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Alert("", "Splintered Burst", 0x66CCFFFF, LCH.Xoryn.constants.glass_stomp_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
      CombatAlerts.AlertCast(LCH.Xoryn.constants.glass_stomp_id, "Splintered Burst", hitValue, {-2, 1})
    end

    LCH.AddIconForDuration(
      LCH.GetTagForId(targetUnitId),
      "LucentCitadelHelper/icons/crystal-burst.dds",
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
      "LucentCitadelHelper/icons/death-warning.dds",
      hitValue
    )
  elseif result == ACTION_RESULT_EFFECT_FADED then
    LCH.RemoveIcon(LCH.GetTagForId(targetUnitId))
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
      "LucentCitadelHelper/icons/electric-badge.dds",
      hitValue
    )
    LCH.Xoryn.activeIcons[targetUnitId] = "fluctuating"

  elseif result == ACTION_RESULT_EFFECT_FADED then
    LCH.Xoryn.fluctuatingCurrentDuration = 0

    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      CombatAlerts.ScreenBorderDisable(borderId)
    end
    -- The overloaded buff happens before fluctuating falls off, so calling LCH.RemoveIcon() would remove the overloaded icon
    if LCH.Xoryn.activeIcons[targetUnitId] == "fluctuating" then
      LCH.RemoveIcon(LCH.GetTagForId(targetUnitId))
      LCH.Xoryn.activeIcons[targetUnitId] = nil
    end
  end
end

function LCH.Xoryn.OverloadedCurrent(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Xoryn.lastOverloadedCurrent = GetGameTimeSeconds()
      LCH.Xoryn.overloadedCurrentDuration = hitValue / 1000
    end

    LCH.AddIconForDuration(
      LCH.GetTagForId(targetUnitId),
      "LucentCitadelHelper/icons/no-electric.dds",
      hitValue
    )
    LCH.Xoryn.activeIcons[targetUnitId] = "overloaded"
    
  elseif result == ACTION_RESULT_EFFECT_FADED then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Xoryn.overloadedCurrentDuration = 0
    end

    LCH.RemoveIcon(LCH.GetTagForId(targetUnitId))
    LCH.Xoryn.activeIcons[targetUnitId] = nil
  end
end

function LCH.Xoryn.UpdateTick(timeSec)
  LCHStatus:SetHidden(not (LCH.savedVariables.showFluctuatingCurrentTimer or LCH.savedVariables.showOverloadedCurrentTimer))

  LCH.Xoryn.FluctuatingCurrentUpdateTick(timeSec)
  LCH.Xoryn.OverloadedCurrentUpdateTick(timeSec)
end

function LCH.Xoryn.FluctuatingCurrentUpdateTick(timeSec)
  LCHStatusLabelXoryn2:SetHidden(not (LCH.savedVariables.showFluctuatingCurrentTimer))
  LCHStatusLabelXoryn2Value:SetHidden(not (LCH.savedVariables.showFluctuatingCurrentTimer))

  local delta = timeSec - LCH.Xoryn.lastFluctuatingCurrent
  local timeLeft = LCH.Xoryn.fluctuatingCurrentDuration - delta

  LCHStatusLabelXoryn2Value:SetText(LCH.Xoryn.getFluctuatingText(timeLeft))
end

function LCH.Xoryn.getFluctuatingText(seconds)
  if seconds > 5 then 
    return string.format("%.0f", seconds) .. "s "
  elseif seconds > 0 then 
    return string.format("%.1f", seconds) .. "s "
  else
    return "-"
  end
end

function LCH.Xoryn.OverloadedCurrentUpdateTick(timeSec)
  LCHStatusLabelXoryn3:SetHidden(not (LCH.savedVariables.showOverloadedCurrentTimer))
  LCHStatusLabelXoryn3Value:SetHidden(not (LCH.savedVariables.showOverloadedCurrentTimer))

  local delta = timeSec - LCH.Xoryn.lastOverloadedCurrent
  local timeLeft = LCH.Xoryn.overloadedCurrentDuration - delta

  LCHStatusLabelXoryn3Value:SetText(LCH.Xoryn.getOverloadedText(timeLeft))
  local color = (timeLeft > 0 and 0xFF0000FF or 0x00FF00FF)
  LCHStatusLabelXoryn3Value:SetColor(LCH.UnpackRGBA(color))
end

function LCH.Xoryn.getOverloadedText(seconds)
  if seconds > 5 then 
    return string.format("YES - %.0f", seconds) .. "s "
  elseif seconds > 0 then 
    return string.format("YES - %.1f", seconds) .. "s "
  else
    return "NO"
  end
end