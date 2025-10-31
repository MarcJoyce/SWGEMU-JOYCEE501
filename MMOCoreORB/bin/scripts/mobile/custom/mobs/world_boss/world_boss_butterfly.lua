world_boss_butterfly = Creature:new {
	customName = "Papilio Giaganticus",
	socialGroup = "butterfly",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 350,
	chanceHit = 30.0,
	damageMin = 3000,
	damageMax = 5000,
	baseXp = 29543,
	baseHAM = 410000,
	baseHAMmax = 450000,
	armor = 3,
	resists = {195,195,195,195,195,195,195,195,50},
	meatType = "meat_insect",
	meatAmount = 1200,
	hideType = "hide_scaley",
	hideAmount = 1200,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 30,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
  scale = 5.0,

	templates = {"object/mobile/corellian_butterfly_hue.iff"},
	hues = { 24, 25, 26, 27, 28, 29, 30, 31 },
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "object/weapon/ranged/creature/creature_spit_small_toxicgreen.iff",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { {"creatureareacombo","stateAccuracyBonus=100"}, {"creatureareaknockdown","stateAccuracyBonus=100"} },
	secondaryAttacks = { {"stunattack",""} }
}

CreatureTemplates:addCreatureTemplate(world_boss_butterfly, "world_boss_butterfly")
