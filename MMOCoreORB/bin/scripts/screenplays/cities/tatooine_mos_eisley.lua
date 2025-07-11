TatooineMosEisleyScreenPlay = CityScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "TatooineMosEisleyScreenPlay",

	planet = "tatooine",

	gcwMobs = {
		{"comm_operator", "rebel_resistance_leader", 3410.5,5,-4735.8,-154,0, "", "", true},
		{"elite_sand_trooper", "rebel_staff_sergeant", 3500.8,8,-4683.9,143,0, "", "", true},
		{"elite_sand_trooper", "rebel_staff_sergeant", 3496.81,5.52789,-4923.13,352.589,0, "neutral", "neutral", true},
		{"imperial_noncom", "rebel_warrant_officer_i", 3760.6,5,-4802,68,0, "", "", true},
		{"sand_trooper", "rebel_crewman", 3322.23,4.77649,-4623.57,331.647,0, "", "", true},
		{"sand_trooper", "rebel_crewman", 3304.54,5,-4602.49,86.0652,0, "", ""},
		{"sand_trooper", "rebel_crewman", 3288.68,4.72215,-4636.09,61.7463,0, "", "", true},
		{"sand_trooper", "rebel_crewman", 3278.49,4.75246,-4676.19,22.0117,0, "", "", true},
		{"sand_trooper", "rebel_crewman", 3290.4,5,-4696.4,137,0, "", "", true},
		{"sand_trooper", "rebel_crewman", 3427.14,5,-4952.92,91.6772,0, "", "", true},
		{"sand_trooper", "rebel_crewman", 3417.99,5,-4974.46,-54,0, "", "", true},
		{"sand_trooper", "rebel_crewman", 3538.04,5.12541,-4806.46,312.721,0, "", "", true},
		{"sand_trooper", "rebel_crewman", 3516.17,5,-4879.7,80,0, "neutral", "neutral", true},
		{"sand_trooper", "rebel_crewman", 3279.95,5,-4835.74,40,0, "", "", true},
		{"sand_trooper", "rebel_crewman", 3341.8,5,-4750.9,124,0, "", "", true},
		{"scout_trooper", "rebel_trooper", 3585.84,5,-4719.95,281.969,0, "", "", true},
		{"scout_trooper", "rebel_trooper", 3288.12,4.9981,-4842.11,27.4222,0, "", "", true},
		{"scout_trooper", "rebel_trooper", 3377.5,0,-4709,156,0, "", ""},
		{"stormtrooper", "rebel_commando", 3242.3,5,-4532.3,151,0, "npc_imperial", "neutral", true},
		{"stormtrooper_rifleman", "rebel_warrant_officer_ii", 3756.71,5,-4845.03,78.2181,0, "", ""},
		{"imperial_colonel", "rebel_colonel", 3490.5,5,-4733.94,305,0, "npc_imperial", "conversation"},
		{"mos_eisley_police_lieutenant", "mos_eisley_police_lieutenant_rebel", 3407,0,-4505,255,0, "npc_imperial", "calm", true},
		{"mos_eisley_police_sergeant", "mos_eisley_police_sergeant_rebel", 3405.2,0,-4505.5,75,0, "npc_accusing", "calm"},
		{"mos_eisley_police_officer", "mos_eisley_police_officer_rebel", 3298.17,4.72998,-4655.93,335.574,0, "", "", true},
		{"mos_eisley_police_officer", "mos_eisley_police_officer_rebel", 3286.4,5,-4870.7,-1,0, "", "", true},
		{"mos_eisley_police_officer", "mos_eisley_police_officer_rebel", 3371.8,5,-4731.5,161,0, "", "", true},
		{"mos_eisley_police_officer", "mos_eisley_police_officer_rebel", 3318.3,5,-4613,229.675,0, "", "", true},
		{"mos_eisley_police_officer", "mos_eisley_police_officer_rebel", 3287.5,5,-4682.63,144.337,0, "", "", true},
		{"mos_eisley_police_officer", "mos_eisley_police_officer_rebel", 3426.18,5,-4963.54,310,0, "", "", true},
		{"mos_eisley_police_sergeant", "mos_eisley_police_sergeant_rebel", 3536.3,5,-4799.3,226,0, "npc_accusing", "calm", true},
		{"mos_eisley_police_lieutenant", "mos_eisley_police_lieutenant_rebel", 3243.7,5,-4533.1,137,0, "npc_imperial", "calm", true},
	},

	patrolNpcs = {"commoner_fat_patrol", "commoner_old_patrol", "commoner_tatooine_patrol", "commoner_technician_patrol", "explorer_patrol", "gambler_patrol", "scientist_patrol"},

	patrolMobiles = {
		--{patrolPoints, template, x, z, y, direction, cell, mood, combatPatrol},

		--Droids
		{"cll8_1", "cll8_binary_load_lifter", 3352.63, 4.00222, -4771.23, 23.6541, 0, "", false},
		{"r2_1", "r2", 3710.16, 4, -4789.97, 354.654, 0, "", false},
		{"r3_1", "r3", 15.9, -0.9, -0.2, 56, 1082877, "", false},
		{"r4_1", "r4", 3466.1, 4, -4883.9, 56, 0, "", false},
		{"r5_1", "r5", 1.4, 1.0, 5.7, 13, 1187871, "", false},
		{"r5_2", "r5", 3324.84, 4.14982, -4819.95, 222.5, 0, "", false},
		{"r5_3", "r5", 3460.21, 4.00358, -4888.86, 241.665, 0, "", false},
		{"eg6_1", "eg6_power_droid", 3650.7, 5, -4734.7, 276.9, 0, "", false},

		--NPCs
		{"npc_1", "patrolNpc", 3377, 4, -4753, 305, 0, "", false},
		{"npc_2", "patrolNpc", 3330, 4, -4637, 208, 0, "", false},
		{"npc_3", "patrolNpc", 3381, 4, -4675, 80, 0, "", false},
		{"npc_4", "patrolNpc", 3559, 4, -4725, 194, 0, "", false},
		{"npc_5", "patrolNpc", 3513, 4, -4725, 293, 0, "", false},
		{"npc_6", "patrolNpc", 3458, 4, -4890, 312, 0, "", false},
	},

	patrolPoints = {
		--table_name = {{x, z, y, cell, delayAtNextPoint}}
		cll8_1 = {{3318, 5, -4811, 0, false}, {3359, 5, -4755, 0, false}, {3403, 5, -4775, 0, false}, {3430, 5, -4772, 0, false}, {3470, 5, -4795, 0, false}, {3377, 5, -4745, 0, false}},
		r2_1 = {{3710, 4, -4789, 0, false}, {3708, 5, -4747, 0, false}, {3676, 5, -4731, 0, false}, {3739, 5, -4781, 0, false}, {3724, 5, -4854, 0, false}, {3640, 5, -4870, 0, false}, {3724, 5, -4854, 0, false}, {3711, 5, -4827, 0 ,false}},
		r3_1 = {{15.9, -0.89, -0.21, 1082877, false}, {9.2, -0.9, 7.8, 1082877, false}, {-9.4, -0.9, 8.6, 1082877, false}, {9.2, -0.9, 7.8, 1082877, true}},
		r4_1 = {{3466, 5, -4883, 0, false}, {3478, 5, -4856, 0, false}, {3496, 5, -4838, 0, false}, {3515, 5, -4851, 0, false}, {3495, 5, -4858, 0, false}},
		r5_1 = {{1.4, 1.0, 5.7, 1187871, false}, {1.3, 1.0, 2.7, 1187871, false}, {10.1, 1.0, -0.1, 1187871, true}, {10.0, 1, -8.9, 1187871, false}, {10.1, 1.0, -0.1, 1187871, false}, {-9.3, 1.0, 1.5, 1187871, false}, {-10.3, 1.0, -8.5, 1187871, false}, {-9.3, 1.0, 1.5, 1187871, false}, {1.3, 1.0, 2.7, 1187871, true}},
		r5_2 = {{3324, 4, -4819, 0, false}, {3284, 5, -4838, 0, false}, {3281, 5, -4864, 0, false}, {3266, 5, -4878, 0, false}, {3249, 5, -4863, 0, false}, {3265, 5, -4843, 0, false}, {3284, 5, -4838, 0, false}},
		r5_3 = {{3460, 5, -4888, 0, false}, {3473, 5, -4899, 0, false}, {3419.0, 5, -4966.4, 0, false}, {3394.9, 5, -4944.1, 0, false}, {3428.3, 5, -4911.1, 0, false}, {3444.6, 5, -4883.9, 0, false}},
		eg6_1 = {{3650, 5, -4734, 0 , false}, {3523, 5, -4713, 0, false}, {3478, 5, -4725, 0, false}, {3523, 5, -4713, 0, false}},

		npc_1 = {{3377, 4, -4753, 0, false}, {3353, 5, -4747, 0, true}, {3299, 5, -4710, 0, false}, {3297, 5, -4699, 0, true}},
		npc_2 = {{3330, 4, -4637, 0, true}, {3305, 5, -4627, 0, true}, {3328, 5, -4614, 0, true}},
		npc_3 = {{3381, 4, -4675, 0, true}, {3389, 5, -4712, 0, false}, {3390, 5, -4691, 0, true}, {3408, 5, -4640, 0, true}},
		npc_4 = {{3559, 4, -4725, 0, true}, {3556, 5, -4757, 0, false}, {3556, 5, -4744, 0, true}, {3545, 5, -4729, 0, true}},
		npc_5 = {{3513, 4, -4725, 0, false}, {3494, 5, -4724, 0, true}, {3467, 5, -4739, 0, false}, {3494, 5, -4724, 0, true}},
		npc_6 = {{3458, 4, -4890, 0, false}, {3436, 5, -4903, 0, true}, {3454, 5, -4917, 0, true}},
	},

	stationaryCommoners = {"commoner", "commoner_fat", "commoner_old", "commoner_tatooine"},
	stationaryNpcs = {"artisan", "bodyguard", "bothan_diplomat", "bounty_hunter", "businessman", "commoner_technician", "contractor", "criminal", "entertainer", "explorer", "farmer", "farmer_rancher", "fringer",
			"gambler", "info_broker", "medic", "mercenary", "miner", "noble", "official", "pilot", "rancher", "scavenger", "scientist", "slicer"},

	--{respawn, x, z, y, direction, cell, mood}
	stationaryMobiles = {
		{1, 3247.43, 4.00222, -4850.96, 0, 0, "conversation"}, {1, 3247.43, 4.00848, -4849.66, 180, 0, "conversation"}, {1, 3532.96, 5, -4788.08, 313, 0, "happy"}, {1, 3636.8, 5, -4877.95, 55, 0, ""},
		{1, 3699, 5, -4768.14, 122.053, 0, ""}, {1, 3698.19, 4.91134, -4838.24, 31, 0, ""}, {1, 3359.65, 5, -4496.04, 277, 0, ""}, {1, 3422.6, 5, -4847, 300, 0, "npc_sitting_table"},
		{1, 3377.1, 5, -4864.9, 7, 0, "npc_sitting_chair"}, {1, 3414.1, 5, -4629.9, 155, 0, "npc_sitting_chair"}, {1, 3415.9, 5, -4630.2, 60, 0, "npc_use_terminal_high"}, {1, 3371.5, 0, -4858.4, 210, 0, "npc_use_terminal_high"},
		{1, 3397.3, 0, -4689.8, 88, 0, "npc_use_terminal_high"}, {1, 3285.75, 5, -4923.4, 54, 0, ""}, {1, 3482.43, 5, -5002.18, 227, 0, ""}, {1, 3232.74, 5, -4798.26, 202, 0, ""},
		{1, 3258.46, 4.05782, -4673.77, 110, 0, ""}, {1,  3532.7,  5,  -4723.7,  90,  0, "conversation"}, {1, 3526.85, 4.44117, -4700.74, 200, 0, ""}, {1, 3357.54, 4.2333, -4649.49, 43, 0, ""},
		{1, 3529.16, 5, -4900.65, 339, 0, ""}, {1, 3329.54, 5, -4975.12, 351, 0, ""}, {1, 3247.46, 5, -4841.69, 135, 0, "conversation"}, {1, 3211.43, 5, -4751.8, 127.282, 0, ""},
		{1, 3535.1, 4, -4724.2, 275, 0, "conversation"}, {1, 3354.2, 0, -4824.3, 330, 0, "worried"}, {1, 3697.52, 5, -4757.76, 158, 0, ""}, {1, 3650.15, 5, -4860.75, 108, 0, ""},
		{1, 3563.18, 5, -4946.05, 34, 0, ""}, {1, 3499.6, 5, -5019.9, 2335, 0, ""}, {1, 3507.53, 5, -5002.63, 318, 0, ""}, {1, 3496, 5, -4993.49, 82, 0, ""},
		{1, 3347.29, 5, -4974.32, 230, 0, ""}, {1, 3379.18, 5, -4898.03, 283, 0, ""}, {1, 3316.48, 4.96935, -4888.61, 231, 0, ""}, {1, 3732.52, 4.00003, -4769.38, 321, 0, ""},
		{1, 3271.6, 5, -4863.7, 231, 0, "npc_sitting_chair"}, {1, 3268.3, 5, -4854, 290, 0, "npc_sitting_chair"}, {1, 3268.7, 5, -4851.2, 194, 0, "npc_sitting_chair"}
	},

	mobiles = {
		--Starport
		{"chassis_dealer",60,2.32807,0.639422,67.8972,165.339,1106372, "neutral"},
		{"ecik",60,1.1,0.639421,66.3,101.522,1106372, "neutral"},
		{"trainer_shipwright",60,-3.2,0.6,67.6,160,1106372, "neutral"},

		-- Front of Starport
		{"vincie_kalhoon", 0, 3525.6, 5.0, -4799.7, 123, 0, ""},
		{"mooch_davoney", 0, 3526.8, 5.0, -4799.0, 123, 0, ""},
		{"guillo_parootchie", 0, 3528.1, 5.0, -4799.4, 172, 0, ""},

		--Cantina
		{"commoner_old",60,36,0.1,0.7,310,1082876, "npc_sitting_chair"},
		{"commoner_tatooine",60,29.6,0.1,-7.4,71,1082876, "npc_sitting_chair"},
		{"commoner_tatooine",60,30.9,0.1,-8.8,10,1082876, "npc_sitting_chair"},
		{"commoner_tatooine",60,29.4,0.1,-6.1,107,1082876, "npc_sitting_chair"},
		{"commoner_tatooine",60,35.7,0.1,3.1,180,1082876, "npc_sitting_table"},
		{"businessman",60,10.65,-0.894992,1.91,330,1082877, "npc_standing_drinking"},
		{"businessman",60,-4.11,-0.894992,5.4,26.8951,1082877, "happy"},
		{"chadra_fan_female",60,10.43,-0.894992,-1.47,123.102,1082877, "worried"},
		{"chadra_fan_male",60,10.7,-0.894992,-0.23,80.4821,1082877, ""},
		{"commoner",60,10.17,-0.894992,2.74,125.098,1082877, "conversation"},
		{"commoner_fat",60,2.11,-0.894992,5.4,180,1082877, "npc_standing_drinking"},
		{"commoner_fat",60,-2.2,-0.9,-10.9,65,1082877, "npc_sitting_table_eating"},
		{"commoner_naboo",60,3.11,0,5.4,161.005,1082877, "bored"},
		{"commoner_naboo",60,1.11,0,5.4,330.024,1082877, "npc_standing_drinking"},
		{"commoner_naboo",60,-3.11,0,5.4,16.6733,1082877, "npc_standing_drinking"},
		{"commoner_naboo",60,16.1,-0.9,4.1,340,1082877, "conversation"},
		{"commoner_tatooine",60,4.11,-0.894992,5.4,158.443,1082877, "npc_standing_drinking"},
		{"commoner_tatooine",60,1.99,-0.894992,-8.44,325.01,1082877, "conversation"},
		{"commoner_tatooine",60,1.19,-0.894992,-7.63,152.004,1082877, "conversation"},
		{"entertainer",60,9.4,0,3.9,310,1082877, "conversation"},
		{"marco_vahn",60,-9.34,-0.894992,5.66,59.306,1082877, "calm"},
		{"muftak",60,20.2,-0.9,5,107,1082877, "happy"},
		{"noble",60,8.49,-0.894992,4.64,128.74,1082877, "conversation"},
		{"patron",60,14.2,-0.9,-4.8,67,1082877, "npc_sitting_chair"},
		{"patron",60,14.7,-0.9,-3,147,1082877, "npc_sitting_chair"},
		{"patron",60,16.5,-0.9,-4.8,320,1082877, "npc_sitting_chair"},
		{"patron",60,24.5,-0.9,-8.1,51,1082877, "npc_sitting_table"},
		{"patron",60,26.1,-0.9,-8.2,317,1082877, "npc_sitting_table_eating"},
		{"patron",60,8.8,-0.9,-6,208,1082877, "entertained"},
		{"patron",60,6.8,-0.9,-6.5,230,1082877, "entertained"},
		{"patron",60,-2.2,-0.9,11.8,97,1082877, "npc_sitting_table"},
		{"patron",60,0.6,-0.9,11.9,269,1082877, "npc_sitting_chair"},
		{"patron_chiss",60,3.62,-0.894992,-4.77,184.005,1082877, "sad"},
		{"patron_chiss",60,1.74,-0.894992,-4.91,95.0028,1082877, "npc_consoling"},
		{"patron_devaronian",60,21.4,-0.9,5.4,161,1082877, "npc_sitting_table"},
		{"patron_ishitib",60,22.3,-0.9,3.1,339,1082877, "npc_sitting_chair"},
		{"patron_ithorian",60,14.9,-0.9,4.9,51,1082877, "npc_sitting_table"},
		{"patron_klaatu",60,15,-0.9,6.9,139,1082877, "npc_sitting_chair"},
		{"patron_nikto",60,23.4,-0.9,4.8,272,1082877, "npc_sitting_chair"},
		{"patron_quarren",60,17,-0.9,6.8,226,1082877, "npc_sitting_chair"},
		{"stormtrooper",400,2.84,-0.894992,-6.3,16.0005,1082877, "npc_imperial"},
		{"stormtrooper_squad_leader",400,3.62,-0.894992,-6.78,360.011,1082877, "npc_accusing"},
		{"doikk_nats",60,2.32,-0.894992,-16.47,44.0013,1082880, "themepark_music_3"},
		{"figrin_dan",60,3.69,-0.894992,-14.4,50.0015,1082880, "themepark_music_3"},
		{"nalan_cheel",60,0.54,-0.894992,-17.13,38.0011,1082880, "themepark_music_1"},
		{"tech_mor",60,4.11,-0.894992,-17.07,45.0013,1082880, "themepark_music_2"},
		{"tedn_dahai",60,1.29,-0.894992,-15.18,70.0021,1082880, "themepark_music_3"},
		{"dravis",60,-21.2103,-0.894989,24.3324,164.437,1082886, "neutral"},
		{"talon_karrde",60,-18.7,-0.9,24.9,-31.0,1082886, "npc_sitting_chair"},
		{"boba_fett", 60, 11.0, -0.9, 1.1, 88, 1082877, "neutral"},

		--western Tavern A
		{"protocol_droid_3po",60,5.3,1.0,4.2,0,1188033, "conversation"},
		{"eg6_power_droid",60,-0.7,0.4,-0.8,-90,1188034, "worried"},
		{"surgical_droid_21b",60,-2.3,0.4,-0.9,90,1188034, "angry"},
		{"surgical_droid_21b",60,0,0.4,-2.6,0,1188034, "angry"},
		{"surgical_droid_21b",60,1.0,0.4,-0.7,-102,1188034, "angry"},
		{"surgical_droid_21b",60,-1.0,0.4,0.4,173,1188034, "angry"},
		{"info_broker",60,-9.1,1.0,8.0,141,1188035, "npc_sitting_table_eating"},
		{"contractor",60,-9.3,1.0,5.0,58,1188035, "npc_sitting_table_eating"},

		--western Tavern B
		{"sullustan_male",60,0.7,1.0,6.9,-42,1188048, "npc_sitting_chair"},
		{"sullustan_male",60,-1.8,1.0,8.8,-130,1188048, "npc_sitting_table"},
		{"sullustan_male",60,-5.6,1.0,8.8,136,1188048, "npc_sitting_chair"},
		{"businessman",60,-8.1,1.0,7.0,97,1188048, "npc_sitting_table_eating"},
		{"sullustan_male",60,-5.7,1.0,5.1,43,1188048, "npc_sitting_table"},
		{"sullustan_male",60,-1.9,1.0,5.1,-26,1188048, "npc_sitting_chair"},
		{"entertainer",60,-6.9,0.4,-6.3,-90,1188047, "calm"},

		--western Tavern C
		{"chiss_female",60,0.4,1.0,6.8,-42,1187987, "npc_sitting_chair"},
		{"scientist",60,0,1.0,6.5,62,1187987, "sad"},
		{"jawa",360,-5.4,0.4,-7.4,0,1187986, "nervous"},

		--western Tavern D
		{"r4",60,4.7,1.0,4.5,50,1187918, "happy"},
		{"shadowy_figure",60,3.0,0.4,-0.4,175,1187919, "conversation"},
		{"twilek_slave",60,2.9,0.4,-4.1,0,1187919, "npc_sitting_ground"},
		{"patron_devaronian",60,1.7,0.4,-2.0,152,1187919, "npc_consoling"},
		{"patron_devaronian",60,0.5,0.4,-3.2,100,1187919, "npc_consoling"},
		{"patron_devaronian",60,0.4,0.4,-4.8,72,1187919, "npc_consoling"},
		{"patron_devaronian",60,1.7,0.4,-5.9,21,1187919, "npc_consoling"},
		{"patron_devaronian",60,4.1,0.4,-6.1,-30,1187919, "npc_consoling"},
		{"patron_devaronian",60,5.4,0.4,-4.9,-83,1187919, "npc_consoling"},
		{"patron_devaronian",60,5.5,0.4,-3.2,-107,1187919, "npc_consoling"},
		{"patron_devaronian",60,4.2,0.4,-2.2,-158,1187919, "bored"},
		{"noble",60,-7.4,0.4,-7.4,33,1187919, "npc_standing_drinking"},

		--western Tavern E
		{"businessman",60,5.2,1.0,4.2,7,1187892, "happy"},
		{"medic",60,10.3,0.4,5.6,-152,1187893, "calm"},
		{"surgical_droid_21b",60,10.4,0.4,4.3,-103,1187893, "neutral"},
		{"entertainer",60,2.9,0.4,-6.0,-6,1187893, "entertained"},
		{"patron_chiss",60,2.9,0.4,-2.7,168,1187893, "npc_sitting_ground"},
		{"commoner_tatooine",60,6.4,0.4,-3.0,-132,1187893, "npc_sitting_chair"},
		{"artisan",60,10.2,0.4,-5.7,90,1187893, "sad"},
		{"farmer_rancher",300,-3.56731,0.408271,-0.572452,135.005,1187893, "npc_consoling"},
		{"bounty_hunter",300,-2.46731,0.408271,-0.572452,180.01,1187893, "npc_accusing"},
		{"rancher",60,-2.46731,0.408271,-1.67245,0,1187893, "worried"},

		--large house west A
		{"commoner_fat",60,-5.1,0.5,-5.0,89,1187999, "npc_sitting_chair"},
		{"commoner_fat",60,-5.1,0.5,-8.0,89,1187999, "npc_sitting_chair"},
		{"commoner_fat",60,-3.0,0.5,-9.5,0,1187999, "npc_sitting_chair"},
		{"judge",60,0,0.5,-9.5,0,1187999, "npc_sitting_table_eating"},
		{"commoner_fat",60,3.0,0.5,-9.5,0,1187999, "npc_sitting_chair"},
		{"commoner_fat",60,5.1,0.5,-8.0,-89,1187999, "npc_sitting_chair"},
		{"commoner_fat",60,5.1,0.5,-5.0,-89,1187999, "npc_sitting_chair"},
		{"entertainer",60,2.3,0.5,-6.0,107,1187999, "entertained"},
		{"entertainer",60,0,0.5,-5.8,175,1187999, "entertained"},
		{"entertainer",60,-2.3,0.5,-6.4,-133,1187999, "entertained"},
		{"entertainer",60,0,0.5,-2.5,160,1187999, "npc_sitting_ground"},
		{"commoner_technician",300,-22.4,1.0,-9.0,-106,1188001, "sad"},

		--large house west B
		{"chiss_male",60,-2.3,1.0,6.7,90,1187871, "npc_sitting_chair"},
		{"chiss_female",60,2.2,1.0,6.7,-89,1187871, "npc_sitting_chair"},
		{"seeker",360,-24.8,1.0,-8.0,93,1187873, ""},
		{"seeker",240,-24.9,1.0,-9.1,80,1187873, ""},
		{"seeker",360,-24.5,1.0,-10.2,62,1187873, ""},
		{"jawa",360,-15.1,1.0,-9.1,-90,1187873, ""},

		--Guild Hall 3429 -4730
		{"trainer_artisan",0,-0.0585386,1.13306,-13.9039,0,1279964, ""},

		--Guild Hall 3479 -4684
		{"trainer_2hsword",0,11,1.1,-11,0,1189637, ""},
		{"trainer_brawler",0,-11,1.1,-14,0,1189639, ""},
		{"trainer_marksman",0,0,1.13306,-13,0,1189638, ""},
		{"trainer_rifleman",0,12,1.1,2,180,1189635, ""},
		{"trainer_scout", 0, -11.5, 1.1, 4.9, -177, 1189636, ""},
		{"junk_dealer", 0, -14.7, 1.1, 2.9, 109, 1189636, ""},

		--Guild Hall 3355 -4713
		{"trainer_droidengineer",0,-10.9183,1.13306,-14.2845,5,1189580, ""},
		{"trainer_architect",0,11,1.133,-14.5,0,1189578, ""},
		{"trainer_armorsmith",0,-12.2888,1.13306,3.6161,171,1189577, ""},
		{"trainer_merchant",0,12,1.13306,6,180,1189576, ""},
		{"trainer_weaponsmith",0,-2.87328,1.13306,-8.72939,122,1189579, ""},

		--Med Center
		{"trainer_1hsword",0,4.4,0.2,-7.8,36,9655496, ""},
		{"trainer_combatmedic",0,7.84086,0.184067,5.40226,80,9655496, ""},
		{"trainer_doctor",0,-7.29914,0.184067,0.0809266,186,9655496, ""},

		--Tavern 3488 -4745
		{"imperial_cadet",400,0.6,0,-9.7,188,1280131, "npc_imperial"},
		{"imperial_cadet",400,9.7,0,-5.9,90,1280131, "npc_imperial"},
		{"imperial_first_lieutenant",400,7.7,0,-7.6,229,1280131, "npc_imperial"},
		{"imperial_private",400,-7.3,0,-3.8,72,1280131, "npc_imperial"},
		{"imperial_recruiter",0,-0.86,0.4,-8,42,1280131, ""},
		{"imperial_army_captain",400,-8.8,1,8.7,90,1280132, "npc_imperial"},
		{"imperial_general",400,1.2,1,7.5,315,1280132, "npc_imperial"},

		--Lucky Despot Cantina 3332 -4604
		{"bounty_hunter",300,5.61884,7.01001,14.3502,118.356,1076949, ""},
		{"bounty_hunter",300,6.01244,7.01,-14.2554,63.6677,1076948, ""},
		{"informant_npc_lvl_3",0,3.8,7,-12.5,84,1076948, ""},
		{"junk_sneg", 0, -1.63376, 7.01, 7.35289, 203.569, 1076943, ""},

		--Lower Floor
		{"vendor",60,30.8955,-0.255725,2.05785,180.009,1076968, "conversation"},
		{"brawler",300,30.8955,-0.255725,0.957845,360.011,1076968, "conversation"},
		{"sullustan_male",60,29.7955,-0.255725,2.05785,135.01,1076968, "conversation"},
		{"medic",300,15.48,-0.255725,6.58106,0,1076966, "conversation"},
		{"commoner_old",300,15.48,-0.255725,7.68106,180.005,1076966, "conversation"},
		{"bounty_hunter",300,12.087,0.01,2.23598,360.011,1076961, "conversation"},
		{"twilek_slave",300,12.087,0.01,3.33598,180.011,1076961, "nervous"},
		{"shamdon_kree",60,-3.61827,0.01,-8.8941,199.448,1076952, "neutral"},
		{"businessman",60,-4.67224,0.0100001,12.0395,0,1076956, "conversation"},
		{"chiss_male",300,-4.67224,0.01,13.1395,179.996,1076956, "conversation"},
		{"info_broker",60,-19.4889,0.0100002,1.51058,180.015,1076958, "conversation"},
		{"businessman",60,-20.5889,0.0100002,1.51058,135.012,1076958, "conversation"},
		{"scientist",60,-19.4889,0.0100002,0.410576,360.011,1076958, "conversation"},

		--Guild Hall/Theater
		{"bounty_hunter",60,5.07127,2.6,7.75958,180.005,1105851, "conversation"},
		{"comm_operator",300,-3.43834,2.6,11.8623,357,1105851, "npc_imperial"},
		{"commoner_technician",300,-3.43834,2.6,12.9623,180.01,1105851, "conversation"},
		{"rodian_clan_captain", 300, 5.07127, 2.6, 6.65958, 0, 1105851, "conversation"},
		{"noble",60,26.93,2.12878,58.19,222.007,1105852, ""},
		{"noble",60,19.26,2.12847,56.13,266.008,1105853, ""},
		{"brawler",300,17.0318,2.12878,75.3601,0,1105853, "conversation"},
		{"dede_chesmi",60,26.7839,2.12847,70.8524,180.013,1105853, "conversation"},
		{"mebi_axane",60,26.7839,2.12876,69.7524,360.011,1105853, "conversation"},
		{"medic",300,17.0318,2.12878,76.3601,179.996,1105853, "conversation"},
		{"theater_manager",60,21.99,2.12804,64.05,4.00007,1105853, ""},
		{"trainer_dancer",0,17.9873,2.12874,53.6448,1,1105853, ""},
		{"trainer_imagedesigner", 0, -20.9956, 2.12878, 73.874, 90, 1105854, ""},

		--Outside
		{"criminal",300,3331.07,5,-4485.81,123.98,0, "worried"},
		{"criminal",300,3364.26,5,-4854.56,0.24067,0, ""},
		{"criminal",300,3352.2,5.0,-4821.5,90,0, "npc_sitting_chair"},
		{"criminal",300,3401.83,5,-4868.72,295.372,0, ""},
		{"explorer",300,3421,5,-4953.33,180.005,0, "conversation"},
		{"informant_npc_lvl_1",0,3447,5,-4850,135,0, ""},
		{"informant_npc_lvl_1",0,3253,5,-4923,180,0, ""},
		{"informant_npc_lvl_1",0,3488,5,-4782,135,0, ""},
		{"jawa",300,3472.22,5,-4918.59,270.008,0, "conversation"},
		{"jawa",300,3470.22,5,-4918.59,90.0027,0, "conversation"},
		{"jawa",300,3471.22,5,-4919.59,0,0, "conversation"},
		{"jawa",300,3488.01,5,-4884.73,270.008,0, "conversation"},
		{"jawa",300,3486.01,5,-4884.73,90.0027,0, "conversation"},
		{"jawa",300,3487.01,5,-4885.73,0,0, "conversation"},
		{"jawa",300,3739.55,4.3966,-4837.28,269.541,0, "conversation"},
		{"jawa",300,3737.55,4.03113,-4837.28,90.4693,0, "conversation"},
		{"jawa",300,3738.55,4.29151,-4838.28,35.3182,0, "conversation"},
		{"jawa",300,3475.25,4.93605,-4852.73,96.6921,0, ""},
		{"jawa",300,3451.49,4.87154,-4524.17,186.748,0, ""},
		{"jawa",300,3654.1,5,-4784.9,150,0, ""},
		{"jawa",300,3655.6,5,-4785,-116,0, ""},
		{"jawa",300,3654.8,5,-4786.2,-25,0, ""},
		{"jawa_engineer",300,3661.1,5,-4748.9,230,0, "npc_use_terminal_high"},
		{"jawa_henchman",300,3663,5,-4858.6,348,0, ""},
		{"jawa_henchman",300,3658,5,-4748.7,135,0, ""},
		{"jawa_smuggler",300,3469.3,4.13017,-4861.5,354.361,0, ""},
		{"jawa_thief",300,3425.73,4.00067,-4907.72,217.107,0, ""},
		{"jawa_thief",300,3655.3,5,-4801.2,118,0, ""},
		{"jawa_thief",300,3658.7,5,-4801.1,-155,0, ""},
		{"jawa_warlord",300,3450.7,0,-4526.2,20,0, "conversation"},
		{"jawa_warlord",300,3663.3,5,-4856,143,0, "scared"},
		{"jawa_warlord",300,3665,5,-4856.8,300,0, "worried"},

		{"junk_dealer", 0, 3355.75, 5, -4823.58, 122, 0, ""},
		{"junk_dealer", 0, 3699.2, 5, -4822, 92, 0, ""},

		{"planet_record_keeper_tatooine", 300, 3385.18, 4.68287, -4792.87, 298.466, 0, "calm"},
		{"noble",60,3247.46,4.9251,-4842.99,45.064,0, "conversation"},
		{"noble",60,3542.38,5,-4826.12,295.121,0, ""},
		{"noble",60,3410.4,0,-4632.8,330,0, "npc_use_terminal_high"},
		{"rodian_clan_captain",300,3421,5,-4954.63,360.011,0, "conversation"},
		{"rodian_clan_warchief",300,3248.76,5,-4841.69,180.005,0, "conversation"},
		{"scavenger",300,3248.76,4.9251,-4842.99,3.29811,0, "conversation"},
		{"scavenger",300,3356.9,5,-4780,56,0, "npc_sitting_table"},
		{"scientist",60,3666.51,5,-4856.14,121.288,0, ""},
		{"scientist",60,3348.69,5,-4513.14,182.356,0, ""},
		{"settler_townsperson",300,3420.74,5,-5007.61,2.42392,0, "conversation"},
		{"smuggler",300,3358.7,5,-4779.7,256,0, "npc_sitting_table"},

		--Trainers Outside
		{"trainer_artisan",0,3503,5,-4809,42,0, ""},
		{"trainer_bountyhunter",0,3357.1,5,-4839.6,64,0, "npc_sitting_chair"},
		{"trainer_brawler",0,3496,5,-4765,91,0, ""},
		{"trainer_carbine",0,3538.3,5,-4692.7,218,0, "npc_sitting_chair"},
		{"trainer_entertainer",0,3477.89,5,-4791.6,215,0, ""},
		{"trainer_marksman",0,3506,5,-4760,180,0, ""},
		{"trainer_marksman",0,3552,5,-4710,215,0, ""},
		{"trainer_medic",0,3522,5,-4774,200,0, ""},
		{"trainer_musician",0,3393,5,-4791,300,0, ""},
		{"trainer_pistol",0,3358.6,5,-4841.3,36,0, "npc_sitting_chair"},
		{"trainer_rifleman",0,3426,5,-4917,0,0, ""},
		{"trainer_scout",0,3519.76,5,-4786.9,77,0, ""},
		{"trainer_smuggler",0,3401,5,-4879,340,0, "worried"}
	}
}

registerScreenPlay("TatooineMosEisleyScreenPlay", true)

function TatooineMosEisleyScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		self:spawnPatrolMobiles()
		self:spawnStationaryMobiles()
		self:spawnSceneObjects()
		self:spawnGcwMobiles()
	end
end

function TatooineMosEisleyScreenPlay:spawnSceneObjects()
	--just outside starport
	spawnSceneObject(self.planet, "object/tangible/crafting/station/public_space_station.iff", 3520.67, 5, -4822.73, 0, math.rad(40) )

	--Lower Floor
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_elevator_down.iff", -3.5, 9, -21.4, 1076970, 1, 0, 0, 0) --Middle
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_elevator_up.iff", -3.5, 0, -21.4, 1076970, 1, 0, 0, 0)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_elevator_down.iff", .5, 9, -21.4, 1076971, 1, 0, 0, 0) --Left side
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_elevator_up.iff", .5, 0, -21.4, 1076971, 1, 0, 0, 0)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_elevator_down.iff", -7.5, 9, -21.4, 1076969, 1, 0, 0, 0) --Right side
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_elevator_up.iff", -7.5, 0, -21.4, 1076969, 1, 0, 0, 0)

	--Upper Floor
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_elevator_up.iff", 13.5, 7, -17.95, 1076972, 1, 0, 0, 0)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_elevator_down.iff", 13.5, 15, -17.95, 1076972, 1, 0, 0, 0)

	--western Tavern A
	spawnSceneObject(self.planet, "object/static/structure/general/droid_lemedical_powerdown.iff", -10.1, 0.4, 1.7, 1188034, math.rad(123) )

	--large house west A
	spawnSceneObject(self.planet, "object/static/structure/general/droid_21bmedical_powerdown.iff", -24.2, 1.0, -9.2, 1188001, math.rad(70) )
end

function TatooineMosEisleyScreenPlay:spawnMobiles()
	local mobiles = self.mobiles

	for i = 1, #mobiles, 1 do
		local mob = mobiles[i]

		-- {template, respawn, x, z, y, direction, cell, mood}
		local pMobile = spawnMobile(self.planet, mob[1], mob[2], mob[3], mob[4], mob[5], mob[6], mob[7])

		if (pMobile ~= nil) then
			if mob[8] ~= "" then
				CreatureObject(pMobile):setMoodString(mob[8])
			end

			AiAgent(pMobile):addObjectFlag(AI_STATIC)

			if CreatureObject(pMobile):getPvpStatusBitmask() == 0 then
				CreatureObject(pMobile):clearOptionBit(AIENABLED)
			end
		end
	end

	local pNpc = spawnMobile(self.planet, "junk_dealer", 0, 3271.49, 5, -4797.09, 52, 0)
	if pNpc ~= nil then
		AiAgent(pNpc):setConvoTemplate("junkDealerFineryConvoTemplate")
	end
	pNpc = spawnMobile(self.planet, "junk_dealer", 0, -31.1, -0.5, 7.1, 31, 1082887)
	if pNpc ~= nil then
		AiAgent(pNpc):setConvoTemplate("junkDealerArmsConvoTemplate")
	end

	--Creatures
	--[[
	spawnMobile(self.planet, "minor_worrt",300,3863.8,5,-4809.5,170,0)
	spawnMobile(self.planet, "minor_worrt",300,3857.8,5,-4814.4,127,0)
	spawnMobile(self.planet, "minor_worrt",300,3856.5,5,-4826.1,45,0)
	spawnMobile(self.planet, "minor_worrt",300,3864.6,5,-4826.3,-1,0)
	spawnMobile(self.planet, "minor_worrt",300,3870.9,5,-4818.6,-74,0)
	spawnMobile(self.planet, "minor_worrt",300,3867.6,5,-4811.8,-128,0)

	spawnMobile(self.planet, "rill",300,3851.3,5,-4725,-175,0)
	spawnMobile(self.planet, "rill",300,3845.2,5,-4734.8,36,0)
	spawnMobile(self.planet, "tempest_rill",300,3855,5,-4733,53,0)

	spawnMobile(self.planet, "rockmite",300,3957.1,5,-4739.8,67,0)
	spawnMobile(self.planet, "rockmite",300,3964.5,5,-4744.8,11,0)
	spawnMobile(self.planet, "rockmite",300,3970.4,5,-4739.3,-72,0)
	spawnMobile(self.planet, "rockmite",300,3966.1,5,-4731.9,-135,0)

	spawnMobile(self.planet, "rockmite",300,3979.2,5,-4824.1,-174,0)
	spawnMobile(self.planet, "rockmite",300,3972.4,5,-4829,110,0)
	spawnMobile(self.planet, "rockmite",300,3973.6,5,-4836.5,35,0)
	spawnMobile(self.planet, "rockmite",300,3981.7,5,-4836.7,-23,0)

	spawnMobile(self.planet, "rockmite",300,3597.7,11.6,-5046,156,0)
	spawnMobile(self.planet, "rockmite",300,3593,11.6,-5050.2,93,0)
	spawnMobile(self.planet, "rockmite",300,3597.7,13.2,-5055.8,14,0)
	spawnMobile(self.planet, "rockmite",300,3602.2,11.3,-5049.7,-80,0)

	spawnMobile(self.planet, "rockmite",300,3859.5,5.5,-4919.3,25,0)
	spawnMobile(self.planet, "rockmite",300,3865.8,5,-4919.4,-2,0)
	spawnMobile(self.planet, "rockmite",300,3867.8,5,-4912,-110,0)
	spawnMobile(self.planet, "rockmite",300,3860.9,5,-4909,130,0)

	spawnMobile(self.planet, "rockmite",300,3765.2,5,-4651.9,-163,0)
	spawnMobile(self.planet, "rockmite",300,3758.3,5,-4654.4,120,0)
	spawnMobile(self.planet, "rockmite",300,3763.3,5,-4660.2,18,0)
	spawnMobile(self.planet, "rockmite",300,3767.8,5,-4657.5,-80,0)

	spawnMobile(self.planet, "rockmite",300,3767.7,5,-4913.8,-44,0)
	spawnMobile(self.planet, "rockmite",300,3768.4,5,-4907,-107,0)
	spawnMobile(self.planet, "rockmite",300,3760.2,5,-4905.1,148,0)
	spawnMobile(self.planet, "rockmite",300,3760.4,5,-4912.9,54,0)

	spawnMobile(self.planet, "worrt",300,3659.4,5,-4601.8,-179,0)
	spawnMobile(self.planet, "worrt",300,3662.9,5,-4612.5,-26,0)
	spawnMobile(self.planet, "worrt",300,3651.5,5,-4612,31,0)
	spawnMobile(self.planet, "worrt",300,3652.1,5,-4602.8,123,0)

	spawnMobile(self.planet, "worrt",300,3584.9,5,-4536.4,-19,0)
	spawnMobile(self.planet, "worrt",300,3585.7,5,-4530.5,-81,0)
	spawnMobile(self.planet, "worrt",300,3573.9,5,-4529.6,108,0)
	spawnMobile(self.planet, "worrt",300,3580.5,5,-4544.8,34,0)
	]]
end
