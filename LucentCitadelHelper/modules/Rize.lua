LCH = LCH or {}
local LCH = LCH
LCH.Rize = {

}

LCH.Rize.constants = {
  splintered_burst_id = 219799, -- Crystal Atronach AOE On Tank
  arcane_conveyance_cast_id = 223024, -- Tether cast
  lustrous_javelin_id = 223546, -- Mantikora Javelin
}

function LCH.Rize.Init()

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

function LCH.Rize.UpdateTick(timeSec)

end
