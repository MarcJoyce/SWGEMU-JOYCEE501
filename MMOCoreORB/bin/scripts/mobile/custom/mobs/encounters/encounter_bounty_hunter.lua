encounter_bounty_hunter = Creature:new {
	objectName = "@mob/creature_names:bounty_hunter",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "mercenary",
	faction = "",
	level = 85,
	chanceHit = 25.0,
	damageMin = 750,
	damageMax = 1000,
	baseXp = 7500,
	baseHAM = 25000,
	baseHAMmax = 30000,
	armor = 1,
	resists = {75,75,75,75,75,75,75,75,25},
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
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {
    "thug"
  },
	lootGroups = {
		{
			groups = {
				{ group = "bandit_tier_4", chance = 3333333 },
				{ group = "bloodrazor_tier_1", chance = 3333333 },
				{ group = "canyon_corsair_tier_2", chance = 3333333 },
				{ group = "dark_jedi_tier_5", chance = 1 }
			}
		}
	},
  
  -- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "dark_trooper_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",
	thrownWeapon = "thrown_weapons",
	reactionStf = "@npc_reaction/slang",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(riflemanmaster,fencermaster,marksmanmaster,brawlermaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(encounter_bounty_hunter, "encounter_bounty_hunter")
