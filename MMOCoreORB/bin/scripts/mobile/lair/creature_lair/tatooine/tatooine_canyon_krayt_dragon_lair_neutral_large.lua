tatooine_canyon_krayt_dragon_lair_neutral_large = Lair:new {
	mobiles = {
		{"krayt_dragon_grand",1},
		{"giant_canyon_krayt_dragon",2},
		{"canyon_krayt_dragon",3},
		{"krayt_dragon_adolescent", 4},
		{"juvenile_canyon_krayt_dragon",5}
	},
	bossMobiles = {
		{"krayt_dragon_ancient", 2},
		{"krayt_dragon_elder", 1}
	},
	spawnLimit = 5,
	buildingsVeryEasy = {"object/tangible/lair/base/poi_all_lair_bones_large.iff"},
	buildingsEasy = {"object/tangible/lair/base/poi_all_lair_bones_large.iff"},
	buildingsMedium = {"object/tangible/lair/base/poi_all_lair_bones_large.iff"},
	buildingsHard = {"object/tangible/lair/base/poi_all_lair_bones_large.iff"},
	buildingsVeryHard = {"object/tangible/lair/base/poi_all_lair_bones_large.iff"},
}

addLairTemplate("tatooine_canyon_krayt_dragon_lair_neutral_large", tatooine_canyon_krayt_dragon_lair_neutral_large)
