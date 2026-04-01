dark_jedi_padawan = Creature:new {
	-- objectName = "@mob/creature_names:dark_jedi_sentinel",
    customName = "a Dark Jedi Padawan",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "self",
	faction = "",
	level = 89,
	chanceHit = 30,
	damageMin = 2645,
	damageMax = 5000,
	-- baseXp = 45,
	baseHAM = 51000,
	baseHAMmax = 52000,
	armor = 3,
	resists = {95,95,95,95,95,95,95,95,25},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = NONE,
	creatureBitmask = HERD,
	optionsBitmask = INVULNERABLE + CONVERSABLE,
	diet = HERBIVORE,

	templates = { "dark_jedi" },
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "dark_jedi_weapons_gen2",
	secondaryWeapon = "dark_jedi_weapons_gen2_ranged",
	conversationTemplate = "dark_jedi_padawan_convo_template",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(dark_jedi_padawan, "dark_jedi_padawan")
