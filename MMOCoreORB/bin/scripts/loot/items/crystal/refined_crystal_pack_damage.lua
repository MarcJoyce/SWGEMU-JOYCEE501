refined_crystal_pack_damage = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Refined Crystal Pack",
	directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_refined_crystal_pack.iff",
	craftingValues = {
		{"mindamage", 50,50,0},
		{"maxdamage", 50,50,0},
		{"attackspeed",0.0,0.0,1},
		{"woundchance",0,0,1},
		{"forcecost",0.0,0.0,1},
		{"useCount",2,2,0}
	},
	customizationStringName = {},
	customizationValues = {}
}


addLootItemTemplate("refined_crystal_pack_damage", refined_crystal_pack_damage)
