encounter_vader = Creature:new {
	objectName = "@mob/creature_names:darth_vader",
	socialGroup = "dark_jedi",
	faction = "",
	mobType = MOB_NPC,
	level = 1000,
	chanceHit = 100,
	damageMin = 5000,
	damageMax = 10000,
	baseXp = 1,
	baseHAM = 5000000,
	baseHAMmax = 5000000,
	armor = 3,
	resists = {95,95,95,95,95,95,95,95,95},
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
	creatureBitmask = KILLER + NOINTIMIDATE + NODOT,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
  scale = 1.25,

	templates = {"object/mobile/darth_vader.iff"},
	lootGroups = {
		{
			groups = {
				{group = "world_boss", chance = 10000000}
			}
		},
		{
			groups = {
				{group = "world_boss", chance = 10000000},
			}
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "darth_vader_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(encounter_vader, "encounter_vader")
