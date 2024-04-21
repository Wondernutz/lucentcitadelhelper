LCH = LCH or {}
local LCH = LCH
LCH.Zilyesset = {
  playerSide = nil,
}

LCH.Zilyesset.constants = {
  brilliant_annihilation_id = 214187,

  porcinlight_id = 219329, -- Having this buff means player is on dark side with Count Ryelaz
  porcindark_id = 219330, -- Having this buff means player is on light side with Zilyesset
  summon_shardborn_lightweaver_id = 218113, -- Big add from Zilyesset
  summon_gloomy_blackguard_id = 218109, -- Big add from Count Ryelaz
}

function LCH.Zilyesset.Init()
end

function LCH.Zilyesset.Annihilation(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 2000 then
    LCH.Alert("", "Annihilation", 0xFF0033FF, LCH.Zilyesset.constants.brilliant_annihilation_id, SOUNDS.BATTLEGROUND_CAPTURE_FLAG_TAKEN_OWN_TEAM, 4000)
    CombatAlerts.CastAlertsStart(LCH.Zilyesset.constants.brilliant_annihilation_id, "Annihilation", hitValue, 12000, nil, nil)
  end
end

function LCH.Zilyesset.getPlayerSide()
  local buffs = GetNumBuffs('player')

  if buffs > 0 then
    for i = 1, buffs do
      local name, startTime, endTime, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, id, canClickOff, castByPlayer = GetUnitBuffInfo('player', i)
      if id == LCH.Zilyesset.constants.porcinlight_id then
        return "dark"
      elseif id == LCH.Zilyesset.constants.porcindark_id then
        return "light"
      end
    end
  end
  
  return nil
end

function LCH.Zilyesset.OnLightSide(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Zilyesset.playerSide = "light"
    end
  end
end

function LCH.Zilyesset.OnDarkSide(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Zilyesset.playerSide = "dark"
    end
  end
end

function LCH.Zilyesset.SummonLightweaver(result, targetType, targetUnitId, hitValue)
  -- Summon big add from Zilyesset
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    if LCH.Zilyesset.playerSide == "dark" then
      return
    end

    LCH.Alert("", "Summon Lightweaver", 0xBCC6CCFF, LCH.Zilyesset.constants.summon_shardborn_lightweaver_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
  end
end

function LCH.Zilyesset.SummonBlackguard(result, targetType, targetUnitId, hitValue)
  -- Summon big add from Zilyesset
  if LCH.Zilyesset.playerSide == "light" then
    return
  end

  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    LCH.Alert("", "Summon Blackguard", 0x71797EFF, LCH.Zilyesset.constants.summon_gloomy_blackguard_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
  end
end

function LCH.Zilyesset.UpdateTick(timeSec)

end
