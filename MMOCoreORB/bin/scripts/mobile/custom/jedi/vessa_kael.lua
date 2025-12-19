vessa_kael = Creature:new {
	objectName = "",
  customName = "Vessa Kael",
	mobType = MOB_NPC,
	socialGroup = "imperial",
	faction = "imperial",
	level = 100,
	chanceHit = 0.5,
	damageMin = 290,
	damageMax = 300,
	baseXp = 2730,
	baseHAM = 8400,
	baseHAMmax = 10200,
	armor = 0,
	resists = {100,100,100,100,100,100,100,100,100},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = NONE,
	creatureBitmask = HERD,
	optionsBitmask = INVULNERABLE + CONVERSABLE,
	diet = HERBIVORE,

	templates = { "object/mobile/dressed_imperial_officer_f.iff" },
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "imperial_pistol",
	secondaryWeapon = "imperial_carbine",
	conversationTemplate = "vessa_kael_convo_template",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = pistoleermaster,
	secondaryAttacks = carbineermaster,
}

CreatureTemplates:addCreatureTemplate(vessa_kael, "vessa_kael")
