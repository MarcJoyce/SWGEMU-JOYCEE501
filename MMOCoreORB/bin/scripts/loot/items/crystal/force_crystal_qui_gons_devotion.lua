force_crystal_qui_gons_devotion = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Qui-Gon's Devotion",
	directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_module_force_crystal.iff",
	craftingValues = {
		{"mindamage",25,25,0},
		{"maxdamage",50,50,0},
		{"attackspeed",0,0,5},
		{"woundchance",4,4,5},
		{"hitpoints",100000,100000,0},
		{"attackhealthcost",0,0,0},
		{"attackactioncost",0,0,0},
		{"attackmindcost",0,0,0},
		{"forcecost",-2.5,-2.5,0},
		{"color",27,27,0},
		{"quality",7,7,0},
	},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("force_crystal_qui_gons_devotion", force_crystal_qui_gons_devotion)
