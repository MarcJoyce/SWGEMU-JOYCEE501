klik_klak = Creature:new {
	customName = "Klik Klak",
	socialGroup = "jawa",
	faction = "jawa",
	mobType = MOB_NPC,
	level = 777,
	chanceHit = 0.24,
	damageMin = 40,
	damageMax = 45,
	-- baseXp = 62,
	baseHAM = 113,
	baseHAMmax = 138,
	armor = 3,
	resists = {200,200,200,200,200,200,200,200,200},
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
	scale = 1,

	templates = {"object/mobile/jawa_male.iff"},
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "jawa_warlord_weapons",
	secondaryWeapon = "unarmed",
	-- conversationTemplate = "tutorial_convo_template",
	conversationTemplate = "klik_klak_convo_template",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(brawlermid,marksmanmid),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(klik_klak, "klik_klak")
