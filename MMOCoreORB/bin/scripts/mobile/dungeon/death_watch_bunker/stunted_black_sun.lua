stunted_black_sun = Creature:new {
	objectName = "@mob/creature_names:mand_bunker_blksun_guard",
	customName = "Stunted Black Sun",
	socialGroup = "death_watch",
	faction = "",
	mobType = MOB_NPC,
	level = 1,
	chanceHit = 0.01,
	damageMin = 1,
	damageMax = 1,
	baseXp = 1,
	baseHAM = 1,
	baseHAMmax = 1,
	armor = 1,
	resists = {-1,-1,-1,-1,-1,-1,-1,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1,

	templates = {"object/mobile/dressed_black_sun_assassin.iff"},
	lootGroups = {
		{
			groups = {
				{group = "rageon_vart_drop", chance = 10000000},
			},
			lootChance = 10000000,
		},
		{
			groups = {
				{group = "klin_nif_drop", chance = 10000000},
			},
			lootChance = 10000000,
		},
		{
			groups = {
				{group = "fenri_dalso_drop", chance = 10000000},
			},
			lootChance = 10000000,
		},
		{
			groups = {
				{group = "bounty_hunter_armor", chance = 10000000},
			},
			lootChance = 10000000,
		},
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "deathwatch_ranged",
	secondaryWeapon = "pirate_unarmed",
	conversationTemplate = "",
	thrownWeapon = "thrown_weapons",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(bountyhuntermaster,marksmanmaster,carbineermaster),
	secondaryAttacks = brawlermaster,
}

CreatureTemplates:addCreatureTemplate(stunted_black_sun, "stunted_black_sun")
