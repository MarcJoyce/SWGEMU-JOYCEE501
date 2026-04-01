meatlump_king = Creature:new {
	objectName = "",
	customName = "The Meatlump King",
	mobType = MOB_NPC,
	socialGroup = "meatlump",
	faction = "meatlump",
	level = 350,
	chanceHit = 100,
	damageMin = 3270,
	damageMax = 4250,
	-- baseXp = 28549,
	baseHAM = 575000,
	baseHAMmax = 625000,
	armor = 3,
	resists = {200,200,200,200,200,200,200,200,200},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.000000,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + HERD + KILLER + HEALER + NODOT,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	lightsaberColors = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },

	templates = {"thug"},
	lootGroups = {
		{
			groups = {
				-- { group = "meatlump_king", chance = 10000000 },
			}
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "dark_jedi_weapons_gen4",
	secondaryWeapon = "dark_jedi_weapons_ranged",
	reactionStf = "@npc_reaction/slang",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(meatlump_king, "meatlump_king")
