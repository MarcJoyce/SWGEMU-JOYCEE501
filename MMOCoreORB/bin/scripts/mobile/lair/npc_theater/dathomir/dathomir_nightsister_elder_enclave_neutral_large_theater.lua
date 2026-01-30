dathomir_nightsister_elder_enclave_neutral_large_theater = Lair:new {
	mobiles = {
		{"nightsister_elder",1},
		{"nightsister_protector",2},
		{"nightsister_sentinel",4},
		{"nightsister_initiate",4}
	},
	spawnLimit = 15,
	buildingsVeryEasy = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff","object/building/poi/tatooine_hutt_businessmen_camp_small2.iff"},
	buildingsEasy = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff","object/building/poi/tatooine_hutt_businessmen_camp_small2.iff"},
	buildingsMedium = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff","object/building/poi/tatooine_hutt_businessmen_camp_small2.iff"},
	buildingsHard = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff","object/building/poi/tatooine_hutt_businessmen_camp_small2.iff"},
	buildingsVeryHard = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff","object/building/poi/tatooine_hutt_businessmen_camp_small2.iff"},
	missionBuilding = "object/tangible/lair/base/objective_banner_generic_2.iff",
	-- buildingsVeryEasy = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	-- buildingsEasy = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	-- buildingsMedium = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	-- buildingsHard = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	-- buildingsVeryHard = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	mobType = "npc",
	buildingType = "theater"
}

addLairTemplate("dathomir_nightsister_elder_enclave_neutral_large_theater", dathomir_nightsister_elder_enclave_neutral_large_theater)
