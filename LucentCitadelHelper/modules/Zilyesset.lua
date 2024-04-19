LCH = LCH or {}
local LCH = LCH
LCH.Zilyesset = {

}

LCH.Zilyesset.constants = {
  brilliant_annihilation_id = 214187,
}

function LCH.Zilyesset.Init()

end

function LCH.Zilyesset.Annihilation(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 2000 then
    LCH.Alert("", "Annihilation", 0xFF0033FF, LCH.Zilyesset.constants.brilliant_annihilation_id, SOUNDS.BATTLEGROUND_CAPTURE_FLAG_TAKEN_OWN_TEAM, 12000)
    CombatAlerts.AlertCast(LCH.Zilyesset.constants.brilliant_annihilation_id, "Annihilation", hitValue, {-2, 0})
  end
end

function LCH.Zilyesset.UpdateTick(timeSec)

end
