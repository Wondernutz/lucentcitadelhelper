LCH = LCH or {}
local LCH = LCH
LCH.Ryelaz = {
  playerSide = nil,
}

LCH.Ryelaz.constants = {
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

function LCH.Ryelaz.Init()
end

function LCH.Ryelaz.AddPadIcons()
  if LCH.savedVariables.showPadIcons and LCH.hasOSI() then

    if table.getn(LCH.status.RyelazPadIconNumber1) == 0 then
      table.insert(LCH.status.RyelazPadIconNumber1, 
        OSI.CreatePositionIcon(
          127371,
          33533,
          132051,
          "LucentCitadelHelper/icons/1.dds",
          1.5 * OSI.GetIconSize()))
    end
    if table.getn(LCH.status.RyelazPadIconNumber2) == 0 then
      table.insert(LCH.status.RyelazPadIconNumber2, 
        OSI.CreatePositionIcon(
          125015,
          33533,
          133229,
          "LucentCitadelHelper/icons/2.dds",
          1.5 * OSI.GetIconSize()))
    end
    if table.getn(LCH.status.RyelazPadIconNumber3) == 0 then
      table.insert(LCH.status.RyelazPadIconNumber3, 
        OSI.CreatePositionIcon(
          122751,
          33533,
          131966,
          "LucentCitadelHelper/icons/3.dds",
          1.5 * OSI.GetIconSize()))
    end
    if table.getn(LCH.status.ZilyessetPadIconNumber1) == 0 then
      table.insert(LCH.status.ZilyessetPadIconNumber1, 
        OSI.CreatePositionIcon(
          127396,
          33541,
          128074,
          "LucentCitadelHelper/icons/1.dds",
          1.5 * OSI.GetIconSize()))
    end
    if table.getn(LCH.status.ZilyessetPadIconNumber2) == 0 then
      table.insert(LCH.status.ZilyessetPadIconNumber2, 
        OSI.CreatePositionIcon(
          124978,
          33541,
          126882,
          "LucentCitadelHelper/icons/2.dds",
          1.5 * OSI.GetIconSize()))
    end
    if table.getn(LCH.status.ZilyessetPadIconNumber3) == 0 then
      table.insert(LCH.status.ZilyessetPadIconNumber3, 
        OSI.CreatePositionIcon(
          122814,
          33541,
          127806,
          "LucentCitadelHelper/icons/3.dds",
          1.5 * OSI.GetIconSize()))
    end
  end
end

function LCH.Ryelaz.RemovePadIcons()
  LCH.DiscardPositionIconList(LCH.status.RyelazPadIconNumber1)
  LCH.status.RyelazPadIconNumber1 = {}

  LCH.DiscardPositionIconList(LCH.status.RyelazPadIconNumber2)
  LCH.status.RyelazPadIconNumber2 = {}

  LCH.DiscardPositionIconList(LCH.status.RyelazPadIconNumber3)
  LCH.status.RyelazPadIconNumber3 = {}

  LCH.DiscardPositionIconList(LCH.status.ZilyessetPadIconNumber1)
  LCH.status.ZilyessetPadIconNumber1 = {}

  LCH.DiscardPositionIconList(LCH.status.ZilyessetPadIconNumber2)
  LCH.status.ZilyessetPadIconNumber2 = {}

  LCH.DiscardPositionIconList(LCH.status.ZilyessetPadIconNumber3)
  LCH.status.ZilyessetPadIconNumber3 = {}
end

function LCH.Ryelaz.Annihilation(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 2000 then
    LCH.Alert("", "Annihilation", 0xFF0033FF, LCH.Ryelaz.constants.brilliant_annihilation_id, SOUNDS.BATTLEGROUND_CAPTURE_FLAG_TAKEN_OWN_TEAM, 12000)
    CombatAlerts.AlertCast(LCH.Ryelaz.constants.brilliant_annihilation_id, "Annihilation", hitValue, {-2, 0})
  end
end

function LCH.Ryelaz.getPlayerSide()
  local buffs = GetNumBuffs('player')

  if buffs > 0 then
    for i = 1, buffs do
      local name, startTime, endTime, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, id, canClickOff, castByPlayer = GetUnitBuffInfo('player', i)
      if id == LCH.Ryelaz.constants.porcinlight_id then
        return "dark"
      elseif id == LCH.Ryelaz.constants.porcindark_id then
        return "light"
      end
    end
  end
  
  return nil
end

function LCH.Ryelaz.OnLightSide(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Ryelaz.playerSide = "light"
    end
  end
end

function LCH.Ryelaz.OnDarkSide(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      LCH.Ryelaz.playerSide = "dark"
    end
  end
end

function LCH.Ryelaz.SummonLightweaver(result, targetType, targetUnitId, hitValue)
  -- Summon big add from Zilyesset
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    if LCH.Ryelaz.playerSide == "dark" then
      return
    end

    LCH.Alert("", "Summon Lightweaver", 0xFFBCC6CC, LCH.Ryelaz.constants.summon_shardborn_lightweaver_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
  end
end

function LCH.Ryelaz.SummonBlackguard(result, targetType, targetUnitId, hitValue)
  -- Summon big add from Zilyesset
  if LCH.Ryelaz.playerSide == "light" then
    return
  end

  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    LCH.Alert("", "Summon Blackguard", 0xFF0033FF, LCH.Ryelaz.constants.summon_gloomy_blackguard_id, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
  end
end

function LCH.Ryelaz.UpdateTick(timeSec)

end
