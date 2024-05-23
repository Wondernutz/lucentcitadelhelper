LCH = LCH or {}
local LCH = LCH
LCH.Common = {
  castSources = {}
}

LCH.Common.constants = {
  hindered_id = 165972,
  radiance_debuff_id = 214675,
  solar_flare_id = 222475, -- Dremora Spellcaster Solar Flare
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
    [218710] = { -2, 2 }, -- Darkcaster Slasher Butcher
    --[222271] = { -2, 2 }, -- Zilyesset Heavy Strike
    --[218274] = { -2, 2 }, -- Count Ryelaz Shear
    --[219420] = { -2, 2 }, -- Cavot Agnan Smite
    --[217971] = { -2, 2 }, -- Orphic Shattered Shard Heavy Strike
    [213685] = { -2, 2 }, -- Orphic Shattered Shard Shockwave
    --[221863] = { -2, 2 }, -- Crystal Hollow Sentinel Heavy Attack
    [221877] = { -2, 2 }, -- Ruinach Frenzy
    [219791] = { -2, 2 }, -- Crystal Atronach Crystal Spear
    [219792] = { -2, 2 }, -- Crystal Atronach Crunch
    --[219793] = { -2, 2,  }, -- Crystal Atronach Crushing Shards
    --[222605] = { -2, 2 }, -- Baron Rize Shear
    [223546] = { -3, 2 }, -- Mantikora Javelin
    --[219030] = { -2, 2 }, -- Jresazzel Power Bash
}

function LCH.Common.AddToCCADodgeList()
  for k, v in pairs(LCH.Common.CCADodgeIDs) do
    CombatAlertsData.dodge.ids[k] = v
  end
end

function LCH.Common.Init()
  LCH.Common.castSources = {}
end

function LCH.Common.Hindered(result, targetType, targetUnitId, hitValue)
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

function LCH.Common.Radiance(result, targetType, targetUnitId, hitValue)
  local borderId = "radiance"

  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      CombatAlerts.ScreenBorderEnable(0xBF40BF99, hitValue, borderId)
    end

  elseif result == ACTION_RESULT_EFFECT_FADED then
    if targetType == COMBAT_UNIT_TYPE_PLAYER then
      CombatAlerts.ScreenBorderDisable(borderId)
    end
  end
end

function LCH.Common.ProcessInterrupts(result, targetUnitId) 
  if (CombatAlertsData.dodge.interrupts[result] and LCH.Common.castSources[targetUnitId]) then
		CombatAlerts.CastAlertsStop(LCH.Common.castSources[targetUnitId])
  end
end

function LCH.Common.SolarFlare(abilityId, result, sourceName, sourceUnitId, targetType, targetUnitId, hitValue)
  if result == ACTION_RESULT_BEGIN then
    --if (targetType == COMBAT_UNIT_TYPE_PLAYER or CombatAlerts.DistanceCheck(targetUnitId, 6) or LibCombatAlerts.isTank) then
    local flareLandingTime = 500

    local id = CombatAlerts.AlertCast(abilityId, sourceName, hitValue + flareLandingTime,  { flareLandingTime, 0, false, { 1, 0.4, 0, 0.5 }})
    if (sourceUnitId and sourceUnitId ~= 0) then
      LCH.Common.castSources[sourceUnitId] = id
    end
    --end
  end
end