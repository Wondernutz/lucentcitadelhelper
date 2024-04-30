LCH = LCH or {}
local LCH = LCH
LCH.Zilyesset = {
  playerSide = nil,
  annihilationOngoing = false,
}

LCH.Zilyesset.constants = {
  brilliant_annihilation_id = 214187, -- Room wipe
  bleak_annihilation_id = 214203, -- Room wipe
  porcinlight_id = 219329, -- Having this buff means player is on dark side with Count Ryelaz
  porcindark_id = 219330, -- Having this buff means player is on light side with Zilyesset
  summon_shardborn_lightweaver_id = 218113, -- Big add from Zilyesset
  summon_gloomy_blackguard_id = 218109, -- Big add from Count Ryelaz
  bleak_lusterbeam_id = 214254, -- Aura to remove protection from adds
  brilliant_lusterbeam_id = 214237, -- Aura to remove protection from adds
}

function LCH.Zilyesset.Init()
  LCH.Zilyesset.annihilationOngoing = false
end

function LCH.Zilyesset.Annihilation(abilityId, result, targetType, targetUnitId, hitValue)
  -- There are two different Annihilation casts, but it's possible that one of them will not register for the player
  if result == ACTION_RESULT_BEGIN and hitValue > 2000 and not LCH.Zilyesset.annihilationOngoing then
    LCH.Zilyesset.annihilationOngoing = true
    LCH.Alert("", "Annihilation", 0xFF0033FF, abilityId, SOUNDS.BATTLEGROUND_CAPTURE_FLAG_TAKEN_OWN_TEAM, 4000)
    CombatAlerts.CastAlertsStart(abilityId, "Annihilation", hitValue, 12000, nil, nil)

    zo_callLater(function () LCH.Zilyesset.annihilationOngoing = false end, hitValue)
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
  if LCH.Zilyesset.playerSide == "dark" then
    return
  end

  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
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

function LCH.Zilyesset.Lusterbeam(abilityId, result, targetType, targetUnitId, hitValue)
  -- Aura to remove protection from adds
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Alert("", GetFormattedAbilityName(abilityId), 0xB22222FF, abilityId, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
    end
  end
end

function LCH.Zilyesset.UpdateTick(timeSec)

end
