world_boss_arachne_warrior = Creature:new {
	objectName = "@mob/creature_names:arachne_warrior",
	socialGroup = "arachne",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 120,
	chanceHit = 0.44,
	damageMin = 655,
	damageMax = 820,
	baseXp = 4097,
	baseHAM = 91000,
	baseHAMmax = 110000,
	armor = 2,
	resists = {80,80,80,80,80,80,80,80,40},
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
	creatureBitmask = PACK + HERD + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/angler_hue.iff"},
	hues = { 0, 1, 2, 3, 4, 5, 6, 7 },
	scale = 1.2,
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "object/weapon/ranged/creature/creature_spit_spray_toxicgreen.iff",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { {"blindattack",""}, {"strongpoison",""} },
	secondaryAttacks = { {"blindattack",""}, {"strongpoison",""} }
}

CreatureTemplates:addCreatureTemplate(world_boss_arachne_warrior, "world_boss_arachne_warrior")
