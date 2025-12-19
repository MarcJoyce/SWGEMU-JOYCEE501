infused_force_crystal_bondaras_folly = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "(Infused) Bondara's Folly",
	directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_module_force_crystal.iff",
	craftingValues = {
		{"mindamage",75,75,0},
		{"maxdamage",100,100,0},
		{"attackspeed",0,0,5},
		{"woundchance",4,4,5},
		{"hitpoints",100000,100000,0},
		{"attackhealthcost",0,0,0},
		{"attackactioncost",0,0,0},
		{"attackmindcost",0,0,0},
		{"forcecost",2.5,2.5,0},
		{"color",14,14,0},
		{"quality",7,7,0},
	},
	customizationStringNames = {},
	customizationValues = {},
	-- staticDotChance: The chance of this weapon object dropping with a static dot on it. Higher number means less chance. Set to 0 to always have a static dot.
	staticDotChance = 0,
	-- staticDotType: 1 = Poison, 2 = Disease, 3 = Fire, 4 = Bleed
	staticDotType = 3,
	-- staticDotValues: Object map that can randomly or statically generate a dot (used for weapon objects.)
	staticDotValues = {
		{"attribute", 0, 0}, -- See CreatureAttributes.h in src for numbers.
		{"strength", 1, 100},
		{"duration", 60, 180},
		{"potency", 50, 100},
		{"uses", -777, -777}
	},
}

addLootItemTemplate("infused_force_crystal_bondaras_folly", infused_force_crystal_bondaras_folly)
