LCH = LCH or {}
local LCH = LCH
LCH.Rize = {

}

LCH.Rize.constants = {
  splintered_burst_id = 219799, -- Crystal Atronach AOE On Tank
}

function LCH.Rize.Init()

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

function LCH.Rize.UpdateTick(timeSec)

end
