local E, C, L = unpack(ElvUI) -- Import Functions/Constants, Config, Locales


if not C["unitframes"].enable == true and not C["raidframes"].enable == true and not C["nameplate"].enable == true then return end
------------------------------------------------------------------------
--	Colors
------------------------------------------------------------------------
local E, C, L = unpack(ElvUI) -- Import Functions/Constants, Config, Locales

E.oUF_colors = setmetatable({
	tapped = E.colors.tapped,
	disconnected = E.colors.disconnected,
	power = setmetatable({
		["MANA"] = E.colors.power.MANA,
		["RAGE"] = E.colors.power.RAGE,
		["FOCUS"] = E.colors.power.FOCUS,
		["ENERGY"] = E.colors.power.ENERGY,
		["RUNES"] = E.colors.power.RUNES,
		["RUNIC_POWER"] = E.colors.power.RUNIC_POWER,
		["AMMOSLOT"] = E.colors.power.AMMOSLOT,
		["FUEL"] = E.colors.power.FUEL,
		["POWER_TYPE_STEAM"] = E.colors.power.POWER_TYPE_STEAM,
		["POWER_TYPE_PYRITE"] = E.colors.power.POWER_TYPE_PYRITE,
	}, {__index = oUF.colors.power}),
	happiness = setmetatable({
		[1] = E.colors.happiness[1],
		[2] = E.colors.happiness[2],
		[3] = E.colors.happiness[3],
	}, {__index = oUF.colors.happiness}),
	runes = setmetatable({
			[1] = E.colors.runes[1],
			[2] = E.colors.runes[2],
			[3] = E.colors.runes[3],
			[4] = E.colors.runes[4],
	}, {__index = oUF.colors.runes}),
	reaction = setmetatable({
		[1] = E.colors.reaction[1], -- Hated
		[2] = E.colors.reaction[2], -- Hostile
		[3] = E.colors.reaction[3], -- Unfriendly
		[4] = E.colors.reaction[4], -- Neutral
		[5] = E.colors.reaction[5], -- Friendly
		[6] = E.colors.reaction[6], -- Honored
		[7] = E.colors.reaction[7], -- Revered
		[8] = E.colors.reaction[8], -- Exalted	
	}, {__index = oUF.colors.reaction}),
	class = setmetatable({
		["DEATHKNIGHT"] = E.colors.class.DEATHKNIGHT,
		["DRUID"]       = E.colors.class.DRUID,
		["HUNTER"]      = E.colors.class.HUNTER,
		["MAGE"]        = E.colors.class.MAGE,
		["PALADIN"]     = E.colors.class.PALADIN,
		["PRIEST"]      = E.colors.class.PRIEST,
		["ROGUE"]       = E.colors.class.ROGUE,
		["SHAMAN"]      = E.colors.class.SHAMAN,
		["WARLOCK"]     = E.colors.class.WARLOCK,
		["WARRIOR"]     = E.colors.class.WARRIOR,
	}, {__index = oUF.colors.class}),
}, {__index = oUF.colors})