force_crystal_prowess_of_plo_koon = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Prowess of Plo Koon",
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
		{"color",18,18,0},
		{"quality",7,7,0},
	},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("force_crystal_prowess_of_plo_koon", force_crystal_prowess_of_plo_koon)
