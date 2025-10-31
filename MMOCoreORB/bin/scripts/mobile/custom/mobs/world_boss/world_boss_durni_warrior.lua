world_boss_durni_warrior = Creature:new {
	customName = "Durni Protector",
	socialGroup = "durni",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 75,
	chanceHit = 15.0,
	damageMin = 1500,
	damageMax = 2500,
	baseXp = 14543,
	baseHAM = 100000,
	baseHAMmax = 150000,
	armor = 2,
	resists = {175,175,175,175,175,175,175,175,25},
	meatType = "meat_herbivore",
	meatAmount = 750,
	hideType = "hide_wooly",
	hideAmount = 750,
	boneType = "bone_mammal",
	boneAmount = 750,
	milk = 0,
	tamingChance = 0,
	ferocity = 20,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
  scale = 2.5,

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
	primaryAttacks = { {"creatureareacombo","stateAccuracyBonus=50"}, {"creatureareaknockdown","stateAccuracyBonus=50"} },
	secondaryAttacks = { {"stunattack",""} }
}

CreatureTemplates:addCreatureTemplate(world_boss_durni_warrior, "world_boss_durni_warrior")
