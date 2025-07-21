bh_boba_fett = Creature:new {
	objectName = "@mob/creature_names:boba_fett",
	mobType = MOB_NPC,
	socialGroup = "jabba",
	faction = "jabba",
	level = 500,
	chanceHit = 30,
	damageMin = 2500,
	damageMax = 3810,
	baseXp = 27849,
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
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/boba_fett.iff"},
	lootGroups = {
		{
			groups = {
				{group = "world_boss", chance = 10000000}
			}
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "boba_fett_weapons",
	secondaryWeapon = "force_sword",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(bountyhuntermaster, carbinemaster, marksmanmaster),
	secondaryAttacks = merge(tkamaster,swordsmanmaster,fencermaster,pikemanmaster,brawlermaster,forcepowermaster),
}

CreatureTemplates:addCreatureTemplate(bh_boba_fett, "bh_boba_fett")
