--Copyright (C) 2007 <SWGEmu>

--This File is part of Core3.

--This program is free software; you can redistribute
--it and/or modify it under the terms of the GNU Lesser
--General Public License as published by the Free Software
--Foundation; either version 2 of the License,
--or (at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--See the GNU Lesser General Public License for
--more details.

--You should have received a copy of the GNU Lesser General
--Public License along with this program; if not, write to
--the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

--Linking Engine3 statically or dynamically with other modules
--is making a combined work based on Engine3.
--Thus, the terms and conditions of the GNU Lesser General Public License
--cover the whole combination.

--In addition, as a special exception, the copyright holders of Engine3
--give you permission to combine Engine3 program with free software
--programs or libraries that are released under the GNU LGPL and with
--code included in the standard release of Core3 under the GNU LGPL
--license (or modified versions of such code, with unchanged license).
--You may copy and distribute such a system following the terms of the
--GNU LGPL for Engine3 and the licenses of the other code concerned,
--provided that you include the source code of that other code when
--and as the GNU LGPL requires distribution of source code.

--Note that people who make modified versions of Engine3 are not obligated
--to grant this special exception for their modified versions;
--it is their choice whether to do so. The GNU Lesser General Public License
--gives permission to release a modified version without this exception;
--this exception also makes it possible to release a modified version
--which carries forward this exception.

--Time, in seconds, that a shuttle is away for
shuttleportAwayTime = 17
starportAwayTime = 17

--Time, in seconds, that a shuttle takes to land
shuttleportLandingTime = 10
starportLandingTime = 10

--Time, in seconds, that a shuttle is landed for
shuttleportLandedTime = 999
starportLandedTime = 999


corellia = {
	weatherEnabled = 1,
	gcwEnabled = 1,

	planetTravelPoints = {
		{name = "Coronet Shuttle B", x = -329.76605, z = 28, y = -4641.23, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Coronet Shuttle A", x = -25.671804, z = 28, y = -4409.7847, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Coronet Starport", x = -66.760902, z = 28, y = -4711.3281, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Vreni Island Shuttle", x = -5551.9473, z = 15.890146, y = -6059.9673, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Tyrena Shuttle B", x = -5600.6367, z = 21, y = -2790.7429, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Tyrena Shuttle A", x = -5005.354, z = 21, y = -2386.9819, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Tyrena Starport", x = -5003.0649, z = 21, y = -2228.3665, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Kor Vella Shuttleport", x = -3775.2546, z = 31, y = 3234.2202, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Kor Vella Starport", x = -3157.2834, z = 31, y = 2876.2029, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Doaba Guerfel Shuttleport", x = 3085.4963, z = 280, y = 4993.0098, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Doaba Guerfel Starport", x = 3349.8933, z = 308, y = 5598.1362, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Bela Vistal Shuttleport A", x = 6644.269, z = 330, y = -5922.5225, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Bela Vistal Shuttleport B", x = 6930.8042, z = 330, y = -5534.8936, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
	},

	jtlLaunchPoint = {"space_corellia", 6520, -5400, -2600},

	badgeAreas = {
		{"badge_agrilat_swap",1387,3749,0,30,20},
		{"badge_bela_vistal_fountain",6767,-5617,0,30,81},
		{"badge_rebel_hideout",-6530,5967,0,30,78},
		{"badge_rogue_corsec_base",5291,1494,0,30,79},
		{"badge_tyrena_theater",-5418,-6248,0,30,80},
	},

	navAreas = {
		{"imperial_detachment_hq",-2977,2908,50},
		{"lonely_wall",2547,4744,40},
		{"lord_nyaxs_cult",1357,-323,50},
		{"rebel_hideout",-6504,5993,100},
		{"rogue_corsec_base",5222,1588,100},
		{"stronghold",4665,-5781,100},
	},

	planetObjects = {
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = -0.664289, oz = 0, ow = 0.747476, x = -133.192, z = 28, y = -4711.16, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.346712, oz = 0, ow = 0.937972, x = -5049.64, z = 21, y = -2304.52, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.290803, oz = 0, ow = 0.956783, x = 3330.38, z = 308, y = 5517.14, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = -0.666281, oz = 0, ow = 0.745701, x = -136.437, z = 28, y = -4730.23, parentid = 0}
	}
}

dantooine = {
	weatherEnabled = 1,
	gcwEnabled = 1,

	planetTravelPoints = {
		{name = "Dantooine Mining Outpost", x = -637.0, z = 3, y = 2504.4, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Dantooine Imperial Outpost", x = -4208.6602, z = 3, y = -2350.24, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Dantooine Agro Outpost", x = 1569.66, z = 4, y = -6415.7598, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Abandoned Rebel Base", x = -6799.6, z = 46.0, y = 5574.3, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 0, landingRange = 3}
	},

	jtlLaunchPoint = {"space_dantooine", 1380, -750, -5900},

	badgeAreas = {
		{"badge_dantari_village1",-3929,-5632,0,30,84},
		{"badge_dantari_village2",-7185,-883,0,30,85},
		{"badge_jedi_temple",4195,5203,0,30,30},
		{"badge_rebel_base",-6836,5520,0,30,31},
	},

	navAreas = {
		{"abandoned_rebel_base",-6882,5540,300},
		{"dantari_village_east",5559,-654,75},
		{"dantari_village_sw",-3836,-5720,100},
		{"dantari_village_west",-7185,-861,100},
		{"jedi_temple_ruins",4203,5222,100},
		{"mokk_stronghold",-7046,-3332,50},
		{"ris_armor_hut",-6805,6021,32},
		{"the_warren",-550,-3834,50},
	},

	planetObjects = {
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.695864, oz = 0, ow = 0.718174, x = 1585.68, z = 4, y = -6368.95, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.725999, oz = 0, ow = -0.687696, x = -629.417, z = 3, y = 2481.24, parentid = 0}
	}
}

dathomir = {
	weatherEnabled = 1,
	gcwEnabled = 1,

	planetTravelPoints = {
		{name = "Trade Outpost", x = 618.89258, z = 6.039608, y = 3092.0142, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Science Outpost", x = -49.021923, z = 18, y = -1584.7278, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 3}
	},

	jtlLaunchPoint = {"space_dathomir", -6900, 2750, -4000},

	badgeAreas = {
		{"badge_crashed_ship",5676,1901,0,30,82},
		{"badge_escape_pod",-4427,586,0,30,27},
		{"badge_imperial_prison",-6141,973,0,30,83},
		{"badge_misty_falls_1",3558,1554,0,30,28},
		{"badge_misty_falls_2",3021,1289,0,30,29},
		{"badge_sarlacc",-2101,3165,0,30,26},
		{"badge_tarpit",652,-4888,0,30,25},
	},

	navAreas = {
		{"ancient_stone_hut",3490,-395,64},
		{"burial_site_nw",-5259,1299,32},
		{"ceremonial_site",1072,-4485,50},
		{"dathomir_worship_stone",-6953,-3032,32},
		{"destroyed_rebel_base",-4705,-4772,50},
		{"empty_hut",-6894,-4854,32},
		{"fenced_building",50,-164,32},
		{"floating_rocks_ne",3000,-5145,32},
		{"floating_rocks_sw_2",-6603,-745,60},
		{"free_slaves_and_huts",7205,5560,32},
		{"lookout_station",-4573,-6556,32},
		{"nightsister_beach_tower",915,6858,32},
		{"nightsister_guard_camp",-4179,-854,32},
		{"nightsister_outcast_camp",-2597,4953,32},
		{"nightsister_outcasts_home",-3250,-6585,32},
		{"nightsister_stalkers_home",-2933,-1025,32},
		{"nightsister_stronghold",-4050,-175,200},
		{"singing_mountain_clan_arch",1125,-1022,32},
		{"singing_mountain_clan_hut",5556,-688,32},
		{"singing_mountain_clan_outcasts_hut",7480,-912,32},
		{"singing_mountain_clan_rock_se",5205,-3084,32},
		{"singing_mountain_clan_rock_sw",-2419,-3111,32},
		{"singing_mountain_clan_village",530,4205,100},
		{"singing_mountain_clan_village_nw",-7081,5888,50},
		{"spiderclan_floating_rocks",-7120,2931,32},
		{"spiderclan_stone_arch",7070,-6440,32},
		{"torch",-2610,-4861,32},
		{"tower_and_stones",-443,-1156,32},
		{"tree_hut",-5045,-2773,32},
		{"wall",7442,-3024,32},
	},

	planetObjects = {
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.701463, oz = 0, ow = 0.712705, x = 592.612, z = 6, y = 3089.84, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.314904, oz = 0, ow = 0.949123, x = -67.6585, z = 18, y = -1595.3, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.314904, oz = 0, ow = 0.949123, x = 5289.6, z = 78.5, y = -4146.1, parentid = 0}
	}
}

endor = {
	weatherEnabled = 1,
	gcwEnabled = 1,

	planetTravelPoints = {
		{name = "Smuggler Outpost", x = -950.59241, z = 73, y = 1553.4125, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Research Outpost", x = 3201.6599, z = 24, y = -3499.76, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 3}
	},

	jtlLaunchPoint = {"space_endor", -5300, -1500, 5250},

	badgeAreas = {
		{"badge_dulok_villlage",5921,-2514,0,30,88},
		{"badge_ewok_tree_villlage",4661,-2425,0,30,86},
		{"badge_imp_outpost",-4628,-2273,0,30,89},
		{"badge_lake_villlage",1454,-3272,0,30,87},
	},

	navAreas = {
		{"donkuwah_hut",4032,-7669,32},
		{"dulok_village_nw",-1205,2965,100},
		{"dulok_village_se",6063,-2473,100},
		{"ewok_lake_village_s",-575,-5066,128},
		{"ewok_lake_village_se",1432,-3268,160},
		{"ewok_tree_village_north",82,39,60},
		{"ewok_tree_village_east",4551,-2409,100},
		{"marauder_stronghold",-4628,-2273,100},
		{"merek_spawns",3901,5780,50},
		{"panshee_hut",-5452,-2185,32},
		{"panshee_shaman_hut",-7559,4457,32},
		{"pubam_shaman_hut",-6880,1364,32},
	},

	planetObjects = {
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.932952, oz = 0, ow = -0.360002, x = -963.537, z = 73, y = 1556.86, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.723459, oz = 0, ow = -0.690367, x = 3240.5, z = 24, y = -3484.79, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.723459, oz = 0, ow = -0.690367, x = -4657.0, z = 14.4, y = 4322.3, parentid = 0}
	}
}

lok = {
	weatherEnabled = 1,
	gcwEnabled = 1,

	planetTravelPoints = {
		{name = "Nym's Stronghold", x = 478.92676, z = 9, y = 5511.9565, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 3},
	},

	jtlLaunchPoint = {"space_lok", -6200, -5350, 113},

	badgeAreas = {
		{"badge_imp_outpost",-1814,-3086,0,10,98},
		{"badge_kimogila_skeleton",4562,-1156,0,10,99},
		{"badge_volcano",3091,-4638,0,10,24},
	},

	navAreas = {
		{"abandoned_camp",-234,-457,32},
		{"camp_ruins",5075,-4117,15},
		{"canyon_corsair_stronghold",-3868,-3820,128},
		{"downed_blood_razor_transport",3640,2178,128},
		{"great_maze",3827,-540,50},
		{"gurk_camp",-3763,-3477,32},
		{"imperial_lookout",-2569,-861,32},
		{"kimogila_town",-78,2710,50},
		{"lok_broken_wall",-4433,-5750,32},
		{"lokkian_fountain",6399,5102,64},
		{"rebel_house",-4751,3525,75},
		{"torches_and_arches",716,-3380,32},
	},

	planetObjects = {
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.999879, oz = 0, ow = 0.015506, x = 464.677, z = 8.75806, y = 5506.49, parentid = 0}
	}
}

naboo = {
	weatherEnabled = 1,
	gcwEnabled = 1,

	planetTravelPoints = {
		{name = "Keren Starport", x = 1371.5938, z = 13, y = 2747.9043, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Keren Shuttleport South", x = 1567.5193, z = 25, y = 2837.8777, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Keren Shuttleport", x = 2021.0026, z = 19, y = 2525.679, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Theed Shuttle A", x = -5856.1055, z = 6, y = 4172.1606, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Theed Shuttle B", x = -5005, z = 6, y = 4072, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Theed Shuttle C", x = -5411.0171, z = 6, y = 4322.3315, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Theed Spaceport", x = -4858.834, z = 5.9483199, y = 4164.0679, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "The Lake Retreat", x = -5494.4224, z = -150, y = -21.837162, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Moenia", x = 4731.1743, z = 4.1700001, y = -4677.5439, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Moenia Shuttleport", x = 4961.9409, z = 3.75, y = -4892.6997, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Dee'ja Peak Shuttleport", x = 5331.9375, z = 327.02765, y = -1576.6733, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Kaadara Starport", x = 5280.2002, z = -192, y = 6688.0498, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Kaadara Shuttleport", x = 5123.3857, z = -192, y = 6616.0264, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Emperor's Retreat", x = 2442.8, z = 292.0, y = -3916.8, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 0, landingRange = 3}
	},

	jtlLaunchPoint = {"space_naboo", -2500, 900, -6500},

	badgeAreas = {
		{"badge_amidalas_sandy_beach",-5828,-93,0,10,77},
		{"badge_deeja_falls_top",5161,-1627,0,10,76},
		{"badge_gungan_sacred_place",-2000,-5429,0,10,19},
		{"badge_theed_falls_bottom",-4614,4261,0,10,75},
	},

	navAreas = {
		{"amidalas_beach",-5526,-31,128},
		{"beach_gungan_ruins",7570,6968,32},
		{"emperors_retreat",2415,-3921,100},
		{"fire_and_pillars",-1775,-487,32},
		{"fishing_pond",-6312,-5086,32},
		{"gate_and_gazebo",-258,-61,32},
		{"gungan_ruins",0,-1866,32},
		{"gungan_sacred_place",-1991,-5422,200},
		{"imperial_outpost",-4769,-3982,32},
		{"mauler_stronghold",2912,1118,50},
		{"naboo_broken_wall",3485,-2882,32},
		{"naboo_crashed_escape_pod",-2433,-2492,32},
		{"naboo_pirate_outpost",-1496,-1728,50},
		{"pillars",7263,-2973,32},
		{"ruined_gate",-7324,-4149,32},
		{"ruined_walls",-3586,-880,32},
		{"statue_and_ruins",-189,-905,32},
		{"statue_heads",3422, 5080, 32},
		{"statues_with_fire",-1634,-4035,32},
		{"weapon_development_faciliy",-6505,-3310,96},
	},

	planetObjects = {
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.715602, oz = 0, ow = -0.698509, x = 4824.53, z = 4.17, y = -4704.9, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.309582, oz = 0, ow = 0.950873, x = -4876.99, z = 6, y = 4142.12, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = -0.0116238, oz = 0, ow = 0.999932, x = 5193.14, z = -192, y = 6680.25, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = -0.0116238, oz = 0, ow = -0.686427, x = 1445.8, z = 13, y = 2771.98, parentid = 0}
	}
}

rori = {
	weatherEnabled = 1,
	gcwEnabled = 1,

	planetTravelPoints = {
		{name = "Restuss Starport", x = 5340, z = 80, y = 5734, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Restuss Shuttleport", x = 5211, z = 80, y = 5791, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Narmle Starport", x = -5374.0718, z = 80, y = -2188.6143, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Narmle Shuttleport", x = -5255.4116, z = 80.664185, y = -2161.6274, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Rebel Outpost", x = 3691.9023, z = 96, y = -6403.4404, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 3}
	},

	jtlLaunchPoint = {"space_naboo", 6300, -4400, 500},

	badgeAreas = {
		{"badge_imp_camp",-5633,-5661,0,10,96},
		{"badge_imp_hyperdrive_fac",-1130,4544,0,10,97},
		{"badge_kobala_spice_mine",7304,63,0,10,94},
		{"badge_rebel_outpost",3664,-6501,0,10,95}
	},

	navAreas = {
		{"4_columns",-432,3264,32},
		{"cobral_tent",-4972,-670,32},
		{"crashed_corvette",0,2012,50},
		{"crashed_escape_pod_east",4272,2509,32},
		{"crashed_escape_pod_north",959,6899,32},
		{"debris",-989,-315,32},
		{"flooded_ruins",2528,7260,32},
		{"gate",2996,-3668,32},
		{"gazebo",3783,-4473,32},
		{"graveyard",-1710,6144,32},
		{"imperial_encampment",-5565,-5660,75},
		{"narmle_militia_estate",5207,1023,32},
		{"partially_buried_gazebo",1001,5360,32},
		{"rancher_and_pets",-431,-5434,32},
		{"rebel_outpost",-5348,5042,75},
		{"rorgungan_gravestones",1163,698,32},
		{"rorgungan_monument_north",-70,5229,64},
		{"rorgungan_monument_nw",-5819,5826,32},
		{"rorgungan_ruins_east_1",3593,345,32},
		{"rorgungan_ruins_east_2",6119,-509,32},
		{"rorgungan_ruins_central",-1491,1684,32},
		{"rorgungan_ruins_ne",3379,5861,32},
		{"rorgungan_ruins_north",956,4049,32},
		{"rorgungan_ruins_se",3462,-2174,32},
		{"rorgungan_ruins_south",-2641,-752,32},
		{"rorgungan_ruins_sw",-6967,-5642,32},
		{"rorgungan_shield",-5507,2096,32},
		{"rorgungan_swamp_town",-2069,3301,100},
		{"rori_bounty_hunter_camp",-3650,5531,32},
		{"rori_ruins_east",5584,2436,32},
		{"rori_sunken_ruins",5961,-2598,32},
		{"ruined_outpost",5083,4676,32},
		{"ruins_ne",6684,6882,32},
		{"ruins_north",958,6521,32},
		{"ruins_nw_1",-4706,3580,32},
		{"ruins_nw_2",-2713,4486,32},
		{"ruins_south",-760,-4085,32},
		{"ruins_in_lake",1871,1761,32},
		{"small_imperial_base",6520,-4766,64},
		{"spike",-3392,-2098,32},
		{"statue",-2902,2588,32},
		{"statue_head_north_1",1116,3833,32},
		{"statue_head_north_2",961,4493,32},
		{"statue_head_west",-2140,614,32},
		{"wall_1",959,5080,64},
		{"wall_2",-1230,-3207,64},
	},

	planetObjects = {
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = -0.100263, oz = 0, ow = 0.994961, x = -5307.37, z = 80.1274, y = -2216.91, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = -0.69192, oz = 0, ow = 0.721974, x = 5370.22, z = 80, y = 5666.04, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = -0.0274543, oz = 0, ow = 0.999623, x = 3672.91, z = 96, y = -6441.07, parentid = 0}
	}
}

talus = {
	weatherEnabled = 1,
	gcwEnabled = 1,

	planetTravelPoints = {
		{name = "Dearic Starport", x = 263.58401, z = 6, y = -2952.1284, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Dearic Shuttleport", x = 699.297, z = 6, y = -3041.4199, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Talus Imperial Outpost", x = -2227.4, z = 20, y = 2319.9, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 2},
		{name = "Nashal Shuttleport", x = 4334.5786, z = 9.8999996, y = 5431.0415, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Nashal Starport", x = 4453.7212, z = 2, y = 5354.3345, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 3}
	},

	jtlLaunchPoint = {"space_corellia", -6400, -5300, -4000},

	badgeAreas = {
		{"badge_aqualish_cave",-4425,-1414,0,30,93},
		{"badge_creature_village",4300,1020,0,30,90},
		{"badge_imp_base",-2185,2383,0,30,91},
		{"badge_imp_vs_reb_battle",-2595,3724,0,30,92},
	},

	navAreas = {
		{"atst_cabin",-2771,1568,32},
		{"aqualish_fishing_spot",5348,4545,32},
		{"backbone",-5730,2856,32},
		{"binyare_pirate_bunker",5583,-4080,32},
		{"bridge",-150,323,32},
		{"bridge_and_debris",5480,1085,50},
		{"broken_atat",-2434,-2218,32},
		{"broken_bridge",-4046,3663,32},
		{"broken_flora_harvester",-4350,1542,32},
		{"burning_rocks",4310,2563,32},
		{"crashed_transport",-2400,2033,32},
		{"debris_central",-1729,-2886,32},
		{"debris_sw",-1011,-5092,32},
		{"detainment_center",4989,-6037,50},
		{"diseased_debris",-5139,3706,32},
		{"diseased_ruins",-5117,3213,96},
		{"erran_sif",2147,-5632,32},
		{"flag",-3460,1550,32},
		{"fountain",-3153,-922,32},
		{"four_stone_fire",-1832,1438,32},
		{"gas_harvester",-1470,1231,32},
		{"gateway",2338,2936,32},
		{"generator",-5647,-2370,32},
		{"geyser",-4595,5707,32},
		{"imperial_house_central",1718,1610,32},
		{"imperial_house_east",5985,-1185,32},
		{"imperial_watch_tower",3209,1262,32},
		{"kahmurra_biogenetic_research_station",-4799,-4752,32},
		{"large_broken_tower",-5517,1064,32},
		{"lake_monument",2445,2485,32},
		{"lost_aqualish_house",17,-910,32},
		{"lost_village_of_durbin",4215,1003,165},
		{"pillar",618,1100,32},
		{"pillars_ruins",4974,3849,32},
		{"quarantined_building",3886,-2848,32},
		{"rebel_camp",3100,-4044,32},
		{"rebel_installation",2371,-4989,50},
		{"ruined_lookout_tower",-4382,2673,32},
		{"ruins_central_1",-1394,2117,32},
		{"ruins_central_2",-1600,-540,32},
		{"ruins_nw",-3492,3697,32},
		{"scientist_camp",-3640,6332,32},
		{"selonian_camp",145,-5583,32},
		{"small_moisture_farm",-4916,-4510,32},
		{"talus_broken_walls",1115,1489,32},
		{"talus_crashed_escape_pod",-4984,5753,32},
		{"talus_ruins_east",5190,-1735,32},
		{"talus_sunken_ruins",-4575,4356,32},
		{"talus_worship_stone",-861,1020,32},
		{"three_stones",-1362,1060,32},
		{"weapons_depot",-4925,-3119,64},
		{"wind_generators",-4557,-2906,32},
	},

	planetObjects = {
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.996369, oz = 0, ow = -0.0851417, x = 4447.08, z = 2, y = 5286.96, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.692641, oz = 0, ow = 0.721282, x = 329.666, z = 6, y = -2924.69, parentid = 0}
	}
}

tatooine = {
	weatherEnabled = 1,
	gcwEnabled = 1,

	planetTravelPoints = {
		{name = "Mos Eisley Shuttleport", x = 3416.6914, z = 5, y = -4648.1411, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Mos Eisley Starport", x = 3599.894, z = 5, y = -4780.4487, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Bestine Starport", x = -1361.1917, z = 12, y = -3600.0254, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Bestine Shuttleport", x = -1098.4836, z = 12, y = -3563.5342, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Mos Espa Shuttleport South", x = -2897.0933, z = 5, y = 1933.4144, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Mos Espa Shuttleport West", x = -3112.1296, z = 5, y = 2176.9607, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Mos Espa Starport", x = -2833.1609, z = 5, y = 2107.3787, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Mos Espa Shuttleport East", x = -2803.511, z = 5, y = 2182.9648, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Anchorhead Shuttleport", x = 47.565128, z = 52, y = -5338.9072, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Mos Entha Starport", x = 1266.0996, z = 7, y = 3065.1392, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Mos Entha Shuttle B", x = 1395.447, z = 7, y = 3467.0117, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Mos Entha Shuttle A", x = 1730.8828, z = 7, y = 3184.6135, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 1, landingRange = 6},
		{name = "Jabba's Palace", x = -6171.6, z = 90.0, y = -6381.5, interplanetaryTravelAllowed = 0, incomingTravelAllowed = 0, landingRange = 3}
	},

	jtlLaunchPoint = {"space_tatooine",2300,-5900,1900},

	badgeAreas = {
		{"badge_bens_hut",-4512,-2270,0,10,12},
		{"badge_escape_pod",-3930,-4425,0,10,15},
		{"badge_krayt_graveyard",7396,4478,0,10,18},
		{"badge_krayt_skeleton",-4650,-4363,0,10,14},
		{"badge_lars_homestead",-2579,-5500,0,10,17},
		{"badge_sarlacc_pit",-6176,-3372,0,10,16},
		{"badge_tusken_pool",-3971,6267,1189178,10,13},
	},

	navAreas = {
		{"broken_house",2315,3255,32},
		{"broken_machinery",-4698,5456,32},
		{"building_ruins_1",588,348,50},
		{"building_ruins_2",6395,195,32},
		{"buried_building",-2041,2593,32},
		{"crashed_escape_pod_2",-6174,5886,32},
		{"darklighter_estate",-695,-6721,164},
		{"fort_tusken",-3981,6261,128},
		{"imperial_oasis",-5315,2685,128},
		{"jabas_palace",-5968,-6277,500},
		{"jawa_traders",-6120,1872,100},
		{"makeshift_camp",-4464,5784,32},
		{"mark_of_honor_ranch",5002,-4684,75},
		{"pirate_camp",-4931,1260,32},
		{"tatooine_maze",-3029,-5113,32},
		{"tusken_bunker",-1476,-180,32},
		{"tusken_king_outpost",-5315,-4440,60},
		{"tusken_outpost_east",5693,1871,75},
		{"ranchers_camp",-3168,3638,32},
		{"rock_pillar",-6449,2614,32},
		{"ruined_building",-4878,2950,32},
		{"ruins_and_skeletons",-5723,6483,32},
		{"tatooine_bounty_hunter_camp",7044,7047,32},
		{"tatooine_broken_walls",2980,6465,32},
	},

	planetObjects = {
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.768226, oz = 0, ow = -0.640178, x = 3533.04, z = 5, y = -4796, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = -0.486657, oz = 0, ow = 0.873593, x = -1271.07, z = 12, y = -3590.22, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = -0.514176, oz = 0, ow = 0.857684, x = -2896.35, z = 5, y = 2130.87, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.989124, oz = 0, ow = -0.147086, x = 1299.08, z = 7, y = 3145.21, parentid = 0}
	}
}

yavin4 = {
	weatherEnabled = 1,
	gcwEnabled = 1,

	planetTravelPoints = {
		{name = "Yavin IV Labor Outpost", x = -6921.6733, z = 73, y = -5726.5161, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Yavin IV Mining Outpost", x = -267.23914, z = 35, y = 4896.3013, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 1, landingRange = 3},
		{name = "Yavin IV Imperial Outpost", x = 4054.1, z = 37, y = -6216.9, interplanetaryTravelAllowed = 1, incomingTravelAllowed = 0, landingRange = 3}
	},

	jtlLaunchPoint = {"space_yavin4", -5600, -5200, -5200},

	badgeAreas = {
		{"badge_temple_exar_kun",5097,5537,0,30,23},
		{"badge_temple_woolamander",519,-646,0,30,21},
		{"badge_yav_temple_blueleaf",-875,-2047,0,30,22},
	},

	navAreas = {
		{"dark_jedi_enclave",5080,306,100},
		{"geonosian_lab",-6440,-388,75},
		{"light_jedi_enclave",-5575,4901,100},
		{"massassi_temple",-3050,-2950,250},
		{"temple_blueleaf",-830,-2056,150},
		{"temple_exar_kun",5035,5537,150},
		{"woolamander_palace",547,-643,128},
		{"yavin4_imperial_base",4036,-6233,75},
	},

	planetObjects = {
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = -0.705623, oz = 0, ow = 0.708587, x = -6917.18, z = 73, y = -5732.25, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.723339, oz = 0, ow = -0.690493, x = 4057.69, z = 37, y = -6217.54, parentid = 0},
		{templateFile = "object/tangible/terminal/terminal_character_builder.iff", ox = 0, oy = 0.00721678, oz = 0, ow = 0.999974, x = -293.367, z = 35, y = 4854.52, parentid = 0}
	}
}

tutorial = {
	weatherEnabled = 0,
	gcwEnabled = 0,

	jtlLaunchPoint = {"space_dathomir", -6900, 2750, -4000},
}

dungeon1 = {
	weatherEnabled = 0,
	gcwEnabled = 0,
}

creature_test = {
	weatherEnabled = 1,
	gcwEnabled = 1,

	planetTravelPoints = {
	},

	badgeAreas = {
	},

	navAreas = {
	},

	planetObjects = {
	}
}