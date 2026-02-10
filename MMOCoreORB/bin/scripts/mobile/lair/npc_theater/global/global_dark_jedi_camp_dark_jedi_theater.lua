global_dark_jedi_camp_dark_jedi_theater = Lair:new {
	mobiles = {{"dark_adept",4}, {"dark_jedi_knight",1}},
	bossMobiles = {{"dark_jedi_master",1}},
	spawnLimit = 8,
	buildingsVeryEasy = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff","object/building/poi/tatooine_hutt_businessmen_camp_small2.iff"},
	buildingsEasy = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff","object/building/poi/tatooine_hutt_businessmen_camp_small2.iff"},
	buildingsMedium = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff","object/building/poi/tatooine_hutt_businessmen_camp_small2.iff"},
	buildingsHard = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff","object/building/poi/tatooine_hutt_businessmen_camp_small2.iff"},
	buildingsVeryHard = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff","object/building/poi/tatooine_hutt_businessmen_camp_small2.iff"},
	missionBuilding = "object/tangible/lair/base/objective_banner_generic_2.iff",
	-- buildingsVeryEasy = {"object/building/poi/dathomir_nightsister_small1.iff","object/building/poi/dathomir_nightsister_small2.iff","object/building/poi/dathomir_nightsister_small3.iff"},
	-- buildingsEasy = {"object/building/poi/dathomir_nightsister_small1.iff","object/building/poi/dathomir_nightsister_small2.iff","object/building/poi/dathomir_nightsister_small3.iff"},
	-- buildingsMedium = {"object/building/poi/dathomir_nightsister_small1.iff","object/building/poi/dathomir_nightsister_small2.iff","object/building/poi/dathomir_nightsister_small3.iff"},
	-- buildingsHard = {"object/building/poi/dathomir_nightsister_small1.iff","object/building/poi/dathomir_nightsister_small2.iff","object/building/poi/dathomir_nightsister_small3.iff"},
	-- buildingsVeryHard = {"object/building/poi/dathomir_nightsister_small1.iff","object/building/poi/dathomir_nightsister_small2.iff","object/building/poi/dathomir_nightsister_small3.iff"},
	mobType = "npc",
	buildingType = "theater"
}

addLairTemplate("global_dark_jedi_camp_dark_jedi_theater", global_dark_jedi_camp_dark_jedi_theater)