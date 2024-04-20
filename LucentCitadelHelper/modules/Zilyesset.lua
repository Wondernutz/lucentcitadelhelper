LCH = LCH or {}
local LCH = LCH
LCH.Zilyesset = {

}

LCH.Zilyesset.constants = {
  brilliant_annihilation_id = 214187, -- Wipe Mech
  ryelaz_shear_id = 218274, -- Heavy Attack (Followed by Meteors)
  ryelaz_summon_id = 218101, -- Summon Cast
  zilyesset_summon_id = 218105, -- Summon Cast
}

function LCH.Zilyesset.Init()

end

function LCH.Zilyesset.Annihilation(result, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN and hitValue > 2000 then
    LCH.Alert("", "Annihilation", 0xFF0033FF, LCH.Zilyesset.constants.brilliant_annihilation_id, SOUNDS.BATTLEGROUND_CAPTURE_FLAG_TAKEN_OWN_TEAM, 12000)
    CombatAlerts.AlertCast(LCH.Zilyesset.constants.brilliant_annihilation_id, "Annihilation", hitValue, {-2, 0})
  end
end

--function LCH.Zilyesset.MeteorCast(result, targetType, targetUnitId, hitValue)
--  if result == ACTION_RESULT_BEGIN and hitValue > 2000 then
--    LCH.Alert("", "Meteors", 0xFF0033FF, LCH.Zilyesset.constants.ryelaz_shear_id, SOUNDS.BATTLEGROUND_CAPTURE_FLAG_TAKEN_OWN_TEAM, 1600)
--    CombatAlerts.AlertCast(LCH.Zilyesset.constants.ryelaz_shear_id, "Meteor", hitValue, {-2, 0})
--  end
--end

function LCH.Zilyesset.UpdateTick(timeSec)

end
