monstrous_brute = Creature:new {
	objectName = "@mob/creature_names:rancor_monstrous_brute",
	socialGroup = "rancor",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 350,
	chanceHit = 35.0,
	damageMin = 3000,
	damageMax = 5000,
	baseXp = 28549,
	baseHAM = 375000,
	baseHAMmax = 400000,
	armor = 3,
	resists = {195,195,195,195,195,195,195,195,125},
	meatType = "meat_carnivore",
	meatAmount = 10000,
	hideType = "hide_leathery",
	hideAmount = 10000,
	boneType = "bone_mammal",
	boneAmount = 10000,
	milk = 0,
	tamingChance = 0,
	ferocity = 30,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
	scale = 1.5,

	templates = {"object/mobile/rancor_hue.iff"},
	lootGroups = {
		{
			groups = {
				{group = "rancor_common", chance = 4000000},
				{group = "armor_all", chance = 2000000},
				{group = "weapons_all", chance = 2500000},
				{group = "wearables_all", chance = 1500000}
			},
			lootChance = 2740000
		},
		{ 
			groups = {
				{group = "named_crystals", chance = 2000000},
				{group = "jedi_clothing_attachments", chance = 2000000},
				{group = "rancor_elder", chance = 6000000},
			},
			lootChance = 10000000
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { {"creatureareacombo","stateAccuracyBonus=100"}, {"creatureareaknockdown","stateAccuracyBonus=100"} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(monstrous_brute, "monstrous_brute")
