world_boss_butterfly_drone = Creature:new {
	objectName = "@mob/creature_names:corellian_butterfly_drone",
	socialGroup = "butterfly",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 130,
	chanceHit = 5.0,
	damageMin = 500,
	damageMax = 2000,
	baseXp = 19544,
	baseHAM = 41000,
	baseHAMmax = 45000,
	armor = 3,
	resists = {75,75,75,75,75,75,75,75,25},
	meatType = "meat_insect",
	meatAmount = 120,
	hideType = "hide_scaley",
	hideAmount = 120,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 30,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
  scale = 2.5,

	templates = {"object/mobile/corellian_butterfly_hue.iff"},
	hues = { 24, 25, 26, 27, 28, 29, 30, 31 },
	controlDeviceTemplate = "object/intangible/pet/corellian_butterfly_hue.iff",
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "object/weapon/ranged/creature/creature_spit_small_toxicgreen.iff",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
		primaryAttacks = { {"creatureareacombo","stateAccuracyBonus=50"}, {"creatureareaknockdown","stateAccuracyBonus=50"} },
	secondaryAttacks = { {"stunattack",""} }
}

CreatureTemplates:addCreatureTemplate(world_boss_butterfly_drone, "world_boss_butterfly_drone")
