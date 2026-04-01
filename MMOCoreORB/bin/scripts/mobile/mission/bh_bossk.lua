bh_bossk = Creature:new {
	objectName = "@mob/creature_names:bossk",
	customName = "Bossk",
	socialGroup = "mercenary",
	faction = "",
	mobType = MOB_NPC,
	level = 350,
	chanceHit = 30,
	damageMin = 2500,
	damageMax = 3810,
	-- baseXp = 27849,
	baseHAM = 350000,
	baseHAMmax = 400000,
	armor = 3,
	resists = {90,90,90,90,90,90,90,90,-1},
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
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.15,

	templates = {"object/mobile/bossk.iff"},
	lootGroups = {
		{
			groups = {
				{group = "world_boss", chance = 10000000}
			}
		}
	},
	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "imperial_carbine",
	secondaryWeapon = "stormtrooper_sword",
	conversationTemplate = "",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(bountyhuntermaster,marksmanmaster,carbineermaster),
	secondaryAttacks = merge(fencermaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(bh_bossk, "bh_bossk")
