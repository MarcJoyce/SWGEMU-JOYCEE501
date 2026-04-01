world_boss_quenker_drone = Creature:new {
	objectName = "@mob/creature_names:quenker",
	socialGroup = "quenker",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 100,
	chanceHit = 10.0,
	damageMin = 500,
	damageMax = 1000,
	-- baseXp = 7500,
	baseHAM = 15000,
	baseHAMmax = 18500,
	armor = 2,
	resists = {145,145,145,145,145,145,145,145,10},
	meatType = "meat_wild",
	meatAmount = 500,
	hideType = "hide_scaley",
	hideAmount = 500,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 30,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
  scale = 1.2,

	templates = {"object/mobile/quenker_hue.iff"},
	hues = { 8, 9, 10, 11, 12, 13, 14, 15 },
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { {"strongpoison","stateAccuracyBonus=25"}, {"creatureareapoison","stateAccuracyBonus=25"}, {"posturedownattack","stateAccuracyBonus=25"}, {"dizzyattack","stateAccuracyBonus=25"} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(world_boss_quenker_drone, "world_boss_quenker_drone")
