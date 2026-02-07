tatooine_tusken_raider_kingdom_neutral_large_theater = Lair:new {
	mobiles = {
		{"tusken_berserker",3},
		{"tusken_blood_champion",3},
		{"tusken_chief",3},
	 	{"tusken_elite_guard",3},
		{"tusken_gore_chief",2},
		{"tusken_torture_lord",2},
	},
	bossMobiles = {
		{"tusken_observer", 1},
		{"tusken_executioner",1},
	},
	spawnLimit = 15,
        buildingsVeryEasy = {"object/building/poi/tatooine_hutt_assassin_camp_large1.iff","object/building/poi/tatooine_hutt_assassin_camp_large2.iff","object/building/poi/tatooine_hutt_assassin_camp_large3.iff","object/building/poi/tatooine_hutt_assassin_camp_large4.iff"},
        buildingsEasy = {"object/building/poi/tatooine_hutt_assassin_camp_large1.iff","object/building/poi/tatooine_hutt_assassin_camp_large2.iff","object/building/poi/tatooine_hutt_assassin_camp_large3.iff","object/building/poi/tatooine_hutt_assassin_camp_large4.iff"},
        buildingsMedium = {"object/building/poi/tatooine_hutt_assassin_camp_large1.iff","object/building/poi/tatooine_hutt_assassin_camp_large2.iff","object/building/poi/tatooine_hutt_assassin_camp_large3.iff","object/building/poi/tatooine_hutt_assassin_camp_large4.iff"},
        buildingsHard = {"object/building/poi/tatooine_hutt_assassin_camp_large1.iff","object/building/poi/tatooine_hutt_assassin_camp_large2.iff","object/building/poi/tatooine_hutt_assassin_camp_large3.iff","object/building/poi/tatooine_hutt_assassin_camp_large4.iff"},
        buildingsVeryHard = {"object/building/poi/tatooine_hutt_assassin_camp_large1.iff","object/building/poi/tatooine_hutt_assassin_camp_large2.iff","object/building/poi/tatooine_hutt_assassin_camp_large3.iff","object/building/poi/tatooine_hutt_assassin_camp_large4.iff"},
        missionBuilding = "object/tangible/lair/base/objective_power_generator.iff",
        mobType = "npc",
        buildingType = "theater"
}

addLairTemplate("tatooine_tusken_raider_kingdom_neutral_large_theater", tatooine_tusken_raider_kingdom_neutral_large_theater)
