world_boss_carrion_spat_drone = Creature:new {
	objectName = "@mob/creature_names:carrion_spat",
	socialGroup = "carrion_spat",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 125,
	chanceHit = 20.0,
	damageMin = 1500,
	damageMax = 2500,
	-- baseXp = 14543,
	baseHAM = 250000,
	baseHAMmax = 275000,
	armor = 2,
	resists = {150,150,150,150,150,150,150,150,25},
	meatType = "meat_avian",
	meatAmount = 2600,
	hideType = "",
	hideAmount = 0,
	boneType = "bone_avian",
	boneAmount = 2600,
	milk = 0,
	tamingChance = 0,
	ferocity = 30,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
  scale = 2.5,

	templates = {"object/mobile/carrion_spat_hue.iff"},
	hues = { 0, 1, 2, 3, 4, 5, 6, 7 },
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

CreatureTemplates:addCreatureTemplate(world_boss_carrion_spat_drone, "world_boss_carrion_spat_drone")
