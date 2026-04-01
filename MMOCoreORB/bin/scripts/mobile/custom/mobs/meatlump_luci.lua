meatlump_luci = Creature:new {
		objectName = "",
	customName = "Luci",
	mobType = MOB_NPC,
	socialGroup = "meatlump",
	faction = "meatlump",
	level = 300,
	chanceHit = 1000,
	damageMin = 1200,
	damageMax = 2400,
	-- baseXp = 28549,
	baseHAM = 510000,
	baseHAMmax = 545000,
	armor = 3,
	resists = {190,190,190,190,190,190,190,190,190},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.000000,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + HERD + KILLER + HEALER + NODOT,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 0.85,

	templates = {"object/mobile/minor_sludge_panther.iff"},
	hues = { 24, 25, 26, 27, 28, 29, 30, 31 },
	lootGroups = {
		{
			groups = {
				-- { group = "meatlump_king", chance = 10000000 },
			}
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { 
		{"creatureareacombo","stateAccuracyBonus=100"},
		{"creatureareaattack","stateAccuracyBonus=100"},
		{"creatureareadisease", "stateAccuracyBonus=100"},
	},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(meatlump_luci, "meatlump_luci")
