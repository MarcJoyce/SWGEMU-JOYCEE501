world_boss_stan = Creature:new {
	-- objectName = "@mob/creature_names:dark_jedi_knight",
	customName = "Stan",
	mobType = MOB_NPC,
	socialGroup = "self",
	faction = "self",
	level = 777,
	chanceHit = 100,
	damageMin = 5000,
	damageMax = 7500,
	baseXp = 1,
	baseHAM = 650000,
	baseHAMmax = 800000,
	armor = 3,
	resists = {195,195,195,195,195,195,195,195,195},
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
	creatureBitmask = KILLER + NOINTIMIDATE + NODOT + HEALER + NODIZZY,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.25,
	lightsaberColors = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },

	templates = {"object/mobile/dressed_commoner_naboo_moncal_male_01.iff"},
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "light_jedi_weapons",
	secondaryWeapon = "light_jedi_weapons_ranged",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(world_boss_stan, "world_boss_stan")
