meatlump_spike = Creature:new {
	objectName = "",
	customName = "Spike",
	mobType = MOB_NPC,
	socialGroup = "meatlump",
	faction = "meatlump",
	level = 300,
	chanceHit = 1000,
	damageMin = 2800,
	damageMax = 3200,
	baseXp = 28549,
	baseHAM = 510000,
	baseHAMmax = 545000,
	armor = 3,
	resists = {80,80,80,80,80,80,80,80,80},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.000000,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + HERD + KILLER + HEALER + NODOT,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.15,

	templates = {"object/mobile/gurreck_hue.iff"},
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
		{"creatureareaattack","stateAccuracyBonus=100"},
		{"creatureareaknockdown","stateAccuracyBonus=100"},
		{"creatureareableeding", "stateAccuracyBonus=100"},
	},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(meatlump_spike, "meatlump_spike")
