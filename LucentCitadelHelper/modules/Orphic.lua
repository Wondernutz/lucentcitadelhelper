LCH = LCH or {}
local LCH = LCH
LCH.Orphic = {
  lastThunderThrall = 0,
  isFirstThunderThrall = true,
  xorynActive = false,
}

LCH.Orphic.constants = {
  color_change_id = 213913, -- Color change/mirrors mechanic

  thunder_thrall_id = 214383,
  thunder_thrall_first_cd = 8.0, -- how soon Xoryn can first jump
  thunder_thrall_cd = 25.5, -- how often Xoryn jumps

  breakout_id = 220185, -- Debuff falls off when Orphic first becomes active
  xoryn_immune_id = 218006, -- Xoryn Thunder Thrall buff gained when immune?

  heavy_shock_id = 222072,

  fate_sealer_id = 214311, -- Ball summon
}

function LCH.Orphic.Init()
  LCH.Orphic.lastThunderThrall = GetGameTimeSeconds()
  LCH.Orphic.isFirstThunderThrall = true
  LCH.Orphic.xorynActive = false
end

function LCH.Orphic.ColorChange(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 2000 then
    LCH.Alert("", "Color Change", 0x96DED1FF, LCH.Orphic.constants.color_change_id, SOUNDS.BATTLEGROUND_CAPTURE_FLAG_TAKEN_OWN_TEAM, 4000)
    CombatAlerts.CastAlertsStart(LCH.Orphic.constants.color_change_id, "Color Change", hitValue, 12000, nil, nil)
  end
end

function LCH.Orphic.ThunderThrall(result, targetType, targetUnitId, hitValue)
  -- Xoryn Jump Mechanic
  if result == ACTION_RESULT_BEGIN and hitValue > 500 then
    LCH.Orphic.lastThunderThrall = GetGameTimeSeconds()
    LCH.Orphic.isFirstThunderThrall = false

    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Alert("", "Thunder Thrall", 0xFFD666FF, LCH.Orphic.constants.thunder_thrall_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
    end
  end
end

function LCH.Orphic.HeavyShock(result, targetType, targetUnitId, hitValue)
  -- Xoryn Channel Mechanic
  -- TODO(wonder): This isn't working, find actual ability ID
  if result == ACTION_RESULT_BEGIN and hitValue > 500 then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Alert("", "Heavy Shock", 0xFFD666FF, LCH.Orphic.constants.heavy_shock_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
    end

    LCH.AddIconForDuration(
      LCH.GetTagForId(targetUnitId),
      "OdySupportIcons/icons/lightning-bolt.dds",
      hitValue
    )
  end
end

function LCH.Orphic.FateSealer(result, targetType, targetUnitId, hitValue)
  -- Ball Summon Mechanic
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    LCH.Alert("", "Summon Fate Pillar", 0xFFD666FF, LCH.Orphic.constants.fate_sealer_id, SOUNDS.DUEL_START, 2000)
  end
end

function LCH.Orphic.Breakout(result, targetType, targetUnitId, hitValue)
  -- Orphic first becomes active when debuff falls off
  if result == ACTION_RESULT_EFFECT_FADED then
    LCH.Orphic.xorynActive = true
  end
end

function LCH.Orphic.XorynImmune(result, targetType, targetUnitId, hitValue)
  -- Detects when Xoryn becomes immune
  if result == ACTION_RESULT_EFFECT_GAINED then
    LCH.Orphic.xorynActive = false

  elseif result == ACTION_RESULT_EFFECT_FADED then
    LCH.Orphic.xorynActive = true
    LCH.Orphic.lastThunderThrall = GetGameTimeSeconds()
    LCH.Orphic.isFirstThunderThrall = true
  end
end

function LCH.Orphic.UpdateTick(timeSec)
  LCHStatus:SetHidden(not (LCH.savedVariables.showXorynJumpTimer))

  LCH.Orphic.ThunderThrallUpdateTick(timeSec)
end

function LCH.Orphic.ThunderThrallUpdateTick(timeSec)
  LCHStatusLabelOrphic1:SetHidden(not (LCH.savedVariables.showXorynJumpTimer and LCH.Orphic.xorynActive))
  LCHStatusLabelOrphic1Value:SetHidden(not (LCH.savedVariables.showXorynJumpTimer and LCH.Orphic.xorynActive))

  local delta = timeSec - LCH.Orphic.lastThunderThrall

  local timeLeft = 0
  if LCH.Orphic.isFirstThunderThrall then
    timeLeft = LCH.Orphic.constants.thunder_thrall_first_cd - delta
  else
    timeLeft = LCH.Orphic.constants.thunder_thrall_cd - delta
  end

  LCHStatusLabelOrphic1Value:SetText(LCH.GetSecondsRemainingString(timeLeft))
end