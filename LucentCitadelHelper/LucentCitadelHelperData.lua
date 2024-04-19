LCH = LCH or {}
local LCH = LCH

LCH.data    = {

  zilyesset_ryelaz_meteor = 218283, -- Zilyesset Encounter -- Meteors
  zilyesset_brilliant_shield_debuff = 214237, -- Zilyesset Encounter -- Players "debuff" to break shields
  zilyesset_bleak_shield_debuff = 214254, -- Zilyesset Encounter -- Players "debuff" to break shields
  zilyesset_sides_swap = 219694, -- Zilyesset Encounter -- Bosses Channeling Wipe Mech

  --shard_volley_boss = 213900, -- Orphic Shattered Shard Encounter -- Buff on boss, removed after 3 seconds
  orphic_shard_volley_target = { 213909, 213907, 213902}, -- Orphic Shattered Shard Encounter -- Targets players?
  orphic_shield_charge = 215308, -- Orphic Shattered Shard Encounter -- Mechanic to force boss into the middle
  orphic_xoryn_jump = 214383, -- Orphic Shattered Shard Encounter -- Xoryn Jump Attack
  orphic_color_swap = 213913, -- Orphic Shattered Shard Encounter -- Boss Channeling Wipe Mech


  rize_ryelaz_meteor = 222610, -- Rize Encounter -- Meteors
  rize_xoryn_tempest = 215107, -- Xoryn Encounter -- Mirror Mech
  rize_xory_tempest_assault = 215184, -- Xoryn Encounter -- Mirror hit?

  hindered_effect = 165972,

  -- TODO: Consider using UnpackRGBA(0xFFFFFFFF)
  -- Colors
  color = {
    ice       = {tonumber("0x99")/255, tonumber("0xCC")/255, tonumber("0xFF")/255}, -- #99CCFF
    fire      = {tonumber("0xFF")/255, tonumber("0x57")/255, tonumber("0x33")/255}, -- #FF5733
    lightning = {tonumber("0xFF")/255, tonumber("0xD6")/255, tonumber("0x66")/255}, -- #FFD666
    poison    = {tonumber("0x66")/255, tonumber("0xCC")/255, tonumber("0x66")/255}, -- #66CC66
    orange    = {tonumber("0xFF")/255, tonumber("0x85")/255, tonumber("0x00")/255}, -- #FF8500
    red       = {1, 0, 0},                                                          -- #FF0000
    green     = {tonumber("0x66")/255, tonumber("0xCC")/255, tonumber("0x66")/255}, -- #66CC66
    pink      = {tonumber("0xD6")/255, tonumber("0x72")/255, tonumber("0xF7")/255}, -- #D672F7
    teal      = {tonumber("0x03")/255, tonumber("0xC0")/255, tonumber("0xC1")/255}, -- #03C0C1
    cleave      = {tonumber("0xCC")/255, tonumber("0x00")/255, tonumber("0x00")/255}, -- #CC0000
    -- Taleria bridges colors
    taleria_green       = {tonumber("0x65")/255, tonumber("0xC9")/255, tonumber("0x66")/255}, -- #65c966
    taleria_yellow      = {tonumber("0xE8")/255, tonumber("0xDD")/255, tonumber("0x68")/255}, -- #e8dd68
    taleria_purple      = {tonumber("0xC1")/255, tonumber("0x5A")/255, tonumber("0xDB")/255}, -- #c15adb
  },

  -- Boss names.
  -- String lower, to make sure changes here keep strings in lowercase.
  zilyessetName = string.lower(GetString(LCH_Zilyesset)),
  orphicName = string.lower(GetString(LCH_Orphic)),
  rizeName = string.lower(GetString(LCH_Rize)),

  --default_color = { 1, 0.7, 0, 0.5 },
  dodgeDuration = GetAbilityDuration(28549),
  maxDuration = 4000,
  holdBlock = "Hold Block!",
  lucentCitadelId = 1478,

  -- Taunt
  innerRage = 42056,
  pierceArmor = 38250,

  -- Testing/debugging values.
  olms_swipe = 95428,
}
