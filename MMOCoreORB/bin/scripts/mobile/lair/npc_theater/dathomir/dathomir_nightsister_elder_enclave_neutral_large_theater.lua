dathomir_nightsister_elder_enclave_neutral_large_theater = Lair:new {
	mobiles = {
		{"nightsister_elder",1},
		{"nightsister_protector",2},
		{"nightsister_sentinel",4},
		{"nightsister_initiate",4}
	},
	spawnLimit = 15,
	buildingsVeryEasy = {"object/tangible/lair/base/poi_all_lair_bones_large_evil_fire_green.iff"},
	buildingsEasy = {"object/tangible/lair/base/poi_all_lair_bones_large_evil_fire_green.iff"},
	buildingsMedium = {"object/tangible/lair/base/poi_all_lair_bones_large_evil_fire_green.iff"},
	buildingsHard = {"object/tangible/lair/base/poi_all_lair_bones_large_evil_fire_green.iff"},
	buildingsVeryHard = {"object/tangible/lair/base/poi_all_lair_bones_large_evil_fire_green.iff"},
	-- buildingsVeryEasy = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	-- buildingsEasy = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	-- buildingsMedium = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	-- buildingsHard = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	-- buildingsVeryHard = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	mobType = "npc",
	buildingType = "theater"
}

addLairTemplate("dathomir_nightsister_elder_enclave_neutral_large_theater", dathomir_nightsister_elder_enclave_neutral_large_theater)
