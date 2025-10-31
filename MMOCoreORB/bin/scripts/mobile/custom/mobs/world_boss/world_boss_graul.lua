world_boss_graul = Creature:new {
	customName = "Graul Abomination",
	socialGroup = "graul",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 250,
	chanceHit = 30.0,
	damageMin = 2000,
	damageMax = 4000,
	baseXp = 18043,
	baseHAM = 300000,
	baseHAMmax = 325000,
	armor = 3,
	resists = {185,185,185,185,185,185,185,185,25},
	meatType = "meat_carnivore",
	meatAmount = 10000,
	hideType = "hide_leathery",
	hideAmount = 10000,
	boneType = "bone_mammal",
	boneAmount = 10000,
	milk = 0,
	tamingChance = 0,
	ferocity = 50,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
  scale = 1.5,

	templates = {"object/mobile/graul_hue.iff"},
	hues = { 8, 9, 10, 11, 12, 13, 14, 15 },
	scale = 1.35,
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
  primaryAttacks = { {"creatureareacombo","stateAccuracyBonus=50"}, {"creatureareaknockdown","stateAccuracyBonus=50"}, {"creatureareableeding","stateAccuracyBonus=50"}, {"stunattack","stateAccuracyBonus=50"} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(world_boss_graul, "world_boss_graul")
