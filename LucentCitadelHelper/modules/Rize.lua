LCH = LCH or {}
local LCH = LCH
LCH.Rize = {
  lastNecroticRain = 0,
  isFirstNecroticRain = true,
  mzrelnirActive = false,
}

LCH.Rize.constants = {
  splintered_burst_id = 219799, -- Crystal Atronach AOE On Tank
  arcane_conveyance_cast_id = 223024, -- Tether cast

  necrotic_spear_id = 219928, -- buff id for when it fully spawns?

  necrotic_rain_id = 222809, -- necromancer bridge
  necrotic_rain_first_cd = 18, -- first cast of rain
  necrotic_rain_cd = 33, -- cooldown
  lustrous_javelin_id = 223546, -- Mantikora Javelin
}

function LCH.Rize.Init()
  LCH.Rize.lastNecroticRain = GetGameTimeSeconds()
  LCH.Rize.isFirstNecroticRain = true
  LCH.Rize.mzrelnirActive = false
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

function LCH.Rize.ArcaneConveyance(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Alert("", "Arcane Conveyance (You)", 0xFFFFD700, LCH.Rize.constants.arcane_conveyance_cast_id, SOUNDS.DUEL_START, 2000)
    end

    LCH.AddIconForDuration(
      LCH.GetTagForId(targetUnitId),
      "LucentCitadelHelper/icons/portalyellow.dds",
      hitValue
    )
  end
end

function LCH.Rize.NecroticSpear(result, targetType, targetUnitId, hitValue)
  -- Mzrelnir first becomes active when a Necromancer casts Necrotic Spear
  if result == ACTION_RESULT_BEGIN then
    LCH.Rize.mzrelnirActive = true
    LCH.Rize.lastNecroticRain = GetGameTimeSeconds()
    LCH.Rize.isFirstNecroticRain = true
  end
end

function LCH.Rize.NecroticRain(result, targetType, targetUnitId, hitValue, abilityId)
  -- Mzrelnir Necrotic Rain
  if result == ACTION_RESULT_BEGIN and abilityId == LCH.Rize.constants.necrotic_rain_id then
    LCH.Rize.lastNecroticRain = GetGameTimeSeconds()
    LCH.Rize.isFirstNecroticRain = false
    
    LCH.Alert("", "Necrotic Rain (Don't Stack)", 0xFFD666FF, LCH.Rize.constants.necrotic_rain_id, SOUNDS.OBJECTIVE_DISCOVERED, 6000)
    CombatAlerts.AlertCast(LCH.Rize.constants.necrotic_rain_id, "Necrotic Rain", hitValue, {-3, 0})
  end
end


function LCH.Rize.UpdateTick(timeSec)
  LCHStatus:SetHidden(not (LCH.savedVariables.showNecroticRainTimer))

  LCH.Rize.NecroticRainUpdateTick(timeSec)
end

function LCH.Rize.NecroticRainUpdateTick(timeSec)
  LCHStatusLabelRize1:SetHidden(not (LCH.savedVariables.showNecroticRainTimer and LCH.Rize.mzrelnirActive))
  LCHStatusLabelRize1Value:SetHidden(not (LCH.savedVariables.showNecroticRainTimer and LCH.Rize.mzrelnirActive))

  local delta = timeSec - LCH.Rize.lastNecroticRain

  local timeLeft = 0
  if LCH.Rize.isFirstNecroticRain then
    timeLeft = LCH.Rize.constants.necrotic_rain_first_cd - delta
  else
    timeLeft = LCH.Rize.constants.necrotic_rain_cd - delta
  end

  LCHStatusLabelRize1Value:SetText(LCH.GetSecondsRemainingString(timeLeft))
end
