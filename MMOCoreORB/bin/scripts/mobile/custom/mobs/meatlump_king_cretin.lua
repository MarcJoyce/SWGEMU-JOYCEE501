meatlump_king_cretin = Creature:new {
	objectName = "@mob/creature_names:meatlump_cretin",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "meatlump",
	faction = "meatlump",
	level = 275,
	chanceHit = 29,
	damageMin = 2054,
	damageMax = 3824,
	baseXp = 26248,
	baseHAM = 272858,
	baseHAMmax = 352426,
	armor = 2,
	resists = {65,65,65,65,65,65,65,65,65},
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
	creatureBitmask = PACK + KILLER + HERD + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"thug"},
	lootGroups = {
		{
			groups = {
				{group = "meatlump_tier_1", chance = 10000000}
			}
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "force_sword",
	secondaryWeapon = "force_sword_ranged",
	reactionStf = "@npc_reaction/slang",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(fencermaster,swordsmanmaster,tkamaster,brawlermaster,pikemanmaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(meatlump_king_cretin, "meatlump_king_cretin")
