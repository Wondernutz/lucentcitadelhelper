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

  pad_icon_number1_pos_list = {
    [1] = {127343,33533,131965}, -- Count Ryelaz
    [2] = {127396,33541,128127}, -- Zilyesset
  },
  pad_icon_number2_pos_list = {
    [1] = {125035,33533,133352}, -- Count Ryelaz
    [2] = {124954,33541,126737}, -- Zilyesset
  },
  pad_icon_number3_pos_list = {
    [1] = {122672,33533,132013}, -- Count Ryelaz
    [2] = {122769,33541,127603}, -- Zilyesset
  },
}

function LCH.Zilyesset.Init()
end

function LCH.Zilyesset.AddPadIcons()
  if LCH.savedVariables.showPadIcons and LCH.hasOSI() then

    if table.getn(LCH.status.PadIconNumber1) == 0 then
      for i=1,3 do
        table.insert(LCH.status.PadIconNumber1, 
          OSI.CreatePositionIcon(
            LCH.Zilyesset.constants.pad_icon_number1_pos_list[i][1],
            LCH.Zilyesset.constants.pad_icon_number1_pos_list[i][2],
            LCH.Zilyesset.constants.pad_icon_number1_pos_list[i][3],
            "LucentCitadelHelper/icons/1.dds",
            1 * OSI.GetIconSize()))
      end
    end

    if table.getn(LCH.status.PadIconNumber2) == 0 then
      for i=1,3 do
        table.insert(LCH.status.PadIconNumber2, 
          OSI.CreatePositionIcon(
            LCH.Zilyesset.constants.pad_icon_number2_pos_list[i][1],
            LCH.Zilyesset.constants.pad_icon_number2_pos_list[i][2],
            LCH.Zilyesset.constants.pad_icon_number2_pos_list[i][3],
            "LucentCitadelHelper/icons/2.dds",
            1 * OSI.GetIconSize()))
      end
    end

    if table.getn(LCH.status.PadIconNumber3) == 0 then
      for i=1,3 do
        table.insert(LCH.status.PadIconNumber3, 
          OSI.CreatePositionIcon(
            LCH.Zilyesset.constants.pad_icon_number3_pos_list[i][1],
            LCH.Zilyesset.constants.pad_icon_number3_pos_list[i][2],
            LCH.Zilyesset.constants.pad_icon_number3_pos_list[i][3],
            "LucentCitadelHelper/icons/3.dds",
            1 * OSI.GetIconSize()))
      end
    end
  end
end

function LCH.Zilyesset.RemovePadIcons()
  LCH.DiscardPositionIconList(LCH.status.PadIconNumber1)
  LCH.status.PadIconNumber1 = {}

  LCH.DiscardPositionIconList(LCH.status.PadIconNumber2)
  LCH.status.PadIconNumber2 = {}

  LCH.DiscardPositionIconList(LCH.status.PadIconNumber3)
  LCH.status.PadIconNumber3 = {}
end

function LCH.Zilyesset.Annihilation(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 2000 then
    LCH.Alert("", "Annihilation", 0xFF0033FF, LCH.Zilyesset.constants.brilliant_annihilation_id, SOUNDS.BATTLEGROUND_CAPTURE_FLAG_TAKEN_OWN_TEAM, 12000)
    CombatAlerts.AlertCast(LCH.Zilyesset.constants.brilliant_annihilation_id, "Annihilation", hitValue, {-2, 0})
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

    LCH.Alert("", "Summon Lightweaver", 0xFFBCC6CC, LCH.Zilyesset.constants.summon_shardborn_lightweaver_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
  end
end

function LCH.Zilyesset.SummonBlackguard(result, targetType, targetUnitId, hitValue)
  -- Summon big add from Zilyesset
  if LCH.Zilyesset.playerSide == "light" then
    return
  end

  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    LCH.Alert("", "Summon Blackguard", 0xFF0033FF, LCH.Zilyesset.constants.summon_gloomy_blackguard_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
  end
end

function LCH.Zilyesset.UpdateTick(timeSec)

end
