world_boss_quenker = Creature:new {
	customName = "Mutant Quenker",
	socialGroup = "quenker",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 300,
	chanceHit = 30.0,
	damageMin = 2500,
	damageMax = 5000,
	baseXp = 27500,
	baseHAM = 250000,
	baseHAMmax = 275000,
	armor = 3,
	resists = {195,195,195,195,195,195,195,195,50},
	meatType = "meat_wild",
	meatAmount = 5000,
	hideType = "hide_scaley",
	hideAmount = 5000,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 30,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
  scale = 2,

	templates = {"object/mobile/quenker_hue.iff", "object/mobile/quenker_relic_reaper.iff"},
	hues = { 8, 9, 10, 11, 12, 13, 14, 15 },
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { {"strongpoison","stateAccuracyBonus=50"}, {"creatureareapoison","stateAccuracyBonus=50"}, {"posturedownattack","stateAccuracyBonus=50"}, {"dizzyattack","stateAccuracyBonus=50"} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(world_boss_quenker, "world_boss_quenker")
