global_surface_marshal_rebel_none = Lair:new {
	mobiles = {
		{"rebel_surface_marshall",1},
		{"rebel_colonel",1},
		{"rebel_major",2},
		{"rebel_commando",4}
	},
	bossMobiles = {{"corvette_rebel_rear_admiral", 2}},
	spawnLimit = 15,
	buildingsVeryEasy = {"object/building/poi/anywhere_rebel_camp_small_1.iff","object/building/poi/anywhere_rebel_camp_small_2.iff","object/building/poi/anywhere_rebel_camp_small_3.iff"},
	buildingsEasy = {"object/building/poi/anywhere_rebel_camp_small_1.iff","object/building/poi/anywhere_rebel_camp_small_2.iff","object/building/poi/anywhere_rebel_camp_small_3.iff"},
	buildingsMedium = {"object/building/poi/anywhere_rebel_camp_small_1.iff","object/building/poi/anywhere_rebel_camp_small_2.iff","object/building/poi/anywhere_rebel_camp_small_3.iff"},
	buildingsHard = {"object/building/poi/anywhere_rebel_camp_small_1.iff","object/building/poi/anywhere_rebel_camp_small_2.iff","object/building/poi/anywhere_rebel_camp_small_3.iff"},
	buildingsVeryHard = {"object/building/poi/anywhere_rebel_camp_small_1.iff","object/building/poi/anywhere_rebel_camp_small_2.iff","object/building/poi/anywhere_rebel_camp_small_3.iff"},
	missionBuilding = "object/tangible/lair/base/objective_banner_rebel.iff",
	mobType = "npc",
	buildingType = "theater",
	faction = "rebel"
}

addLairTemplate("global_surface_marshal_rebel_none", global_surface_marshal_rebel_none)
