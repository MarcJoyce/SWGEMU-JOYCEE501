world_boss_rancor = Creature:new {
	objectName = "@mob/creature_names:rancor",
	socialGroup = "rancor",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 350,
	chanceHit = 30.0,
	damageMin = 2500,
	damageMax = 4500,
	baseXp = 29543,
	baseHAM = 450000,
	baseHAMmax = 475000,
	armor = 3,
	resists = {195,195,195,195,195,195,195,195,50},
	meatType = "meat_carnivore",
	meatAmount = 5000,
	hideType = "hide_leathery",
	hideAmount = 5000,
	boneType = "bone_mammal",
	boneAmount = 5000,
	milk = 0,
	tamingChance = 0,
	ferocity = 30,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
  scale = 1.75,

	templates = {
    "object/mobile/nsister_rancor_grovo.iff",
    "object/mobile/bull_rancor.iff",
    "object/mobile/mutant_rancor.iff",
  },
	hues = { 16, 17, 18, 19, 20, 21, 22, 23 },
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { {"creatureareacombo","stateAccuracyBonus=100"}, {"creatureareaknockdown","stateAccuracyBonus=100"}, {"strongdisease", ""}, {"creatureareadisease",""} },
	secondaryAttacks = { {"stunattack",""} }
}

CreatureTemplates:addCreatureTemplate(world_boss_rancor, "world_boss_rancor")
