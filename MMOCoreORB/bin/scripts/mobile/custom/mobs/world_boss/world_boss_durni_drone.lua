world_boss_durni_drone = Creature:new {
	customName = "Durni drone",
	socialGroup = "durni",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 25,
	chanceHit = 5.0,
	damageMin = 750,
	damageMax = 1000,
	baseXp = 2500,
	baseHAM = 10000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {125,125,125,125,125,125,125,125,-1},
	meatType = "meat_herbivore",
	meatAmount = 250,
	hideType = "hide_wooly",
	hideAmount = 250,
	boneType = "bone_mammal",
	boneAmount = 250,
	milk = 0,
	tamingChance = 0,
	ferocity = 20,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
  scale = 1.25,

	templates = {"object/mobile/durni_hue.iff"},
	hues = { 16, 17, 18, 19, 20, 21, 22, 23 },
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { {"creatureareacombo","stateAccuracyBonus=25"}, {"creatureareaknockdown","stateAccuracyBonus=25"} },
	secondaryAttacks = { {"stunattack",""} }
}

CreatureTemplates:addCreatureTemplate(world_boss_durni_drone, "world_boss_durni_drone")
