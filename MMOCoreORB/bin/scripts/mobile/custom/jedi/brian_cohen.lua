brian_cohen = Creature:new {
	customName = "Brian Cohen",
	mobType = MOB_NPC,
	socialGroup = "kun",
	faction = "",
	level = 300,
	chanceHit = 30,
	damageMin = 1645,
	damageMax = 3000,
	specialDamageMult = 2.5,
	baseXp = 28549,
	baseHAM = 200000,
	baseHAMmax = 300000,
	armor = 3,
	resists = {195,195,195,195,195,195,195,195,195},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + HEALER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	lightsaberColors = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
	templates = { "dark_jedi", "light_jedi" },
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "dark_jedi_weapons_gen4",
	secondaryWeapon = "dark_jedi_weapons_ranged",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(brian_cohen, "brian_cohen")
