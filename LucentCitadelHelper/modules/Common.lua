LCH = LCH or {}
local LCH = LCH
LCH.Common = {

}

LCH.Common.constants = {
  hindered_id = 165972,
}

LCH.Common.CCADodgeIDs = {
		--[[ Options ---------------------------------------
		1: Size of alert window
			0: None
			>0: Time, in milliseconds
			-1: Default (auto-detect)
			-2: Default (melee)
			-3: Default (projectile)
		2: Alert text/ping (ignored if alert window is 0)
			0: Never
			1: Always
			2: Suppressed for tanks
		3: Interruptible (optional, default false)
		4: Color, regular (optional)
		5: Color, alerted (optional)
		vet: Vet-only?
		offset: Offset to reported hitValue, in milliseconds
		--------------------------------------------------]]
    [222271] = { -2, 1 }, -- Zilyesset Heavy Strike
    [218274] = { -2, 1 }, -- Count Ryelaz Shear
    [219791] = { -2, 1 }, -- Crystal Atronach Crystal Spear
    [219792] = { -2, 1 }, -- Crystal Atronach Crunch
    [219793] = { -2, 1 }, -- Crystal Atronach Crushing Shards
}

function LCH.Common.AddToCCADodgeList()
  for k, v in pairs(LCH.Common.CCADodgeIDs) do
    CombatAlertsData.dodge.ids[k] = v
  end
end

function LCH.Common.Init()

end

function LCH.Common.Hindered(result, targetUnitId, hitValue)
  local isDPS, isHeal, isTank = GetPlayerRoles()
  if isDPS then
    return
  end
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    LCH.AddIconForDuration(
      LCH.GetTagForId(targetUnitId),
      "LucentCitadelHelper/icons/shattered.dds",
      hitValue)
  elseif result == ACTION_RESULT_HEAL_ABSORBED then
    -- TODO: Track how much healing is left.
  elseif result == ACTION_RESULT_EFFECT_FADED then
    LCH.RemoveIcon(LCH.GetTagForId(targetUnitId))
  end
end