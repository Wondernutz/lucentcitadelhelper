LCH = LCH or {}
local LCH = LCH
LCH.Orphic = {
  lastThunderThrall = 0,
  isFirstThunderThrall = true,
}

LCH.Orphic.constants = {
  thunder_thrall_id = 214383,
  thunder_thrall_first_cd = 8.0, -- how soon Xoryn can first jump
  thunder_thrall_cd = 24.0, -- how often Xoryn jumps

  heavy_shock_id = 222072,
}

function LCH.Orphic.Init()
  LCH.Orphic.lastThunderThrall = GetGameTimeSeconds()
  LCH.Orphic.isFirstThunderThrall = true
end

function LCH.Orphic.ThunderThrall(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 500 then
    LCH.Orphic.lastThunderThrall = GetGameTimeSeconds()
    LCH.Orphic.isFirstThunderThrall = false

    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Alert("", "Thunder Thrall", 0xFFD666FF, LCH.Orphic.constants.thunder_thrall_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
    end
  end
end

function LCH.Orphic.HeavyShock(result, targetType, targetUnitId, hitValue)
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

function LCH.Orphic.UpdateTick(timeSec)
  LCHStatus:SetHidden(not (LCH.savedVariables.showXorynJumpTimer))

  LCH.Orphic.ThunderThrallUpdateTick(timeSec)
end

function LCH.Orphic.ThunderThrallUpdateTick(timeSec)
  LCHStatusLabelOrphic1:SetHidden(not LCH.savedVariables.showXorynJumpTimer)
  LCHStatusLabelOrphic1Value:SetHidden(not LCH.savedVariables.showXorynJumpTimer)

  local delta = timeSec - LCH.Orphic.lastThunderThrall

  local timeLeft = 0
  if LCH.Orphic.isFirstThunderThrall then
    timeLeft = LCH.Orphic.constants.thunder_thrall_first_cd - delta
  else
    timeLeft = LCH.Orphic.constants.thunder_thrall_cd - delta
  end

  LCHStatusLabelOrphic1Value:SetText(LCH.GetSecondsRemainingString(timeLeft))
end