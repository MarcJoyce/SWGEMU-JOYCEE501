bh_ig_assassin_droid_180 = Creature:new {
	objectName = "@mob/creature_names:ig_assassin_droid",
	customName = "IG-88",
	socialGroup = "",
	faction = "",
	mobType = MOB_ANDROID,
	level = 350,
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/ig_assassin_droid.iff"},
	lootGroups = {
		{
			groups = {
				{group = "world_boss", chance = 10000000}
			}
		}
	},
	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(bh_ig_assassin_droid_180, "bh_ig_assassin_droid_180")
