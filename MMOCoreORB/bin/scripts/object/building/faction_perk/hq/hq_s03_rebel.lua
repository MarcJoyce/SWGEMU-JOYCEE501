--Copyright (C) 2010 <SWGEmu>


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


object_building_faction_perk_hq_hq_s03_rebel = object_building_faction_perk_hq_shared_hq_s03_rebel:new {
	lotSize = 0,
	containerComponent = "GCWBaseContainerComponent",
	groundZoneComponent = "StructureZoneComponent",
	maintenanceCost = 0,
	baseMaintenanceRate = 0,
	faction = "rebel",
	pvpFaction = "rebel",
	dataObjectComponent = "DestructibleBuildingDataComponent",
	allowedZones = {"corellia", "dantooine", "dathomir", "endor", "lok", "naboo", "talus", "tatooine", "yavin4" },
	constructionMarker = "object/building/player/construction/construction_player_house_generic_medium_style_01.iff",
	length = 7,
	width = 6,
	planetMapCategory = "rebel",
	alwaysPublic = 1,
	factionBaseType = 1,

	skillMods = {
		{"private_buff_mind", 100},
		{"private_med_battle_fatigue", 5},
		{"private_medical_rating", 100},
	},

	childObjects = {
		{ templateFile = "object/static/structure/general/poi_all_rebl_corral_64x64_s01.iff", x = 0.28, z = 0, y = 7.35, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/general/tankfarm_s01.iff", x = 10.04, z = 0, y = -12, ox = 0, oy = -0.579, oz = 0, ow = 0.815, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/general/tankfarm_s01.iff", x = -9.27, z = 0, y = -11.87, ox = 0, oy = 0.565, oz = 0, ow = 0.825, cellid = -1, containmentType = -1 },

		{ templateFile = "object/installation/faction_perk/turret/tower_lg.iff", x = 14, z = 0, y = 25, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/installation/faction_perk/turret/tower_lg.iff", x = -14, z = 0, y = 25, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/installation/faction_perk/turret/tower_lg.iff", x = -25, z = 0, y = -9, ox = 0, oy = 1, oz = 0, ow = 0, cellid = -1, containmentType = -1 },
		{ templateFile = "object/installation/faction_perk/turret/tower_lg.iff", x = 25, z = 0, y = -9, ox = 0, oy = 1, oz = 0, ow = 0, cellid = -1, containmentType = -1 },

		{ templateFile = "object/installation/faction_perk/covert_detector/detector_32m.iff", x = 0, z = 0, y = 31.94, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/installation/faction_perk/minefield/field_1x1.iff", x = 0, z = 0, y = 20.44, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/installation/faction_perk/minefield/field_1x1.iff", x = 5.35, z = 0, y = 36, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/installation/faction_perk/minefield/field_1x1.iff", x = -5.35, z = 0, y = 36, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },

		{ templateFile = "object/tangible/terminal/terminal_hq_rebel.iff", x = 0, z = 0.25, y = 1.86, ox = 0, oy = 0, oz = 0, ow = 1, cellid = 2, containmentType = -1 },

		{ templateFile = "object/tangible/terminal/terminal_mission.iff", x = -4.71, z = -20.8, y = 24.4, ox = 0, oy = 0.707, oz = 0, ow = 0.707, cellid = 10, containmentType = -1 },
		{ templateFile = "object/tangible/terminal/terminal_mission_rebel.iff", x = 7.95, z = -20.8, y = 24.4, ox = 0, oy = -0.707, oz = 0, ow = 0.707, cellid = 10, containmentType = -1 },

		{ templateFile = "object/tangible/terminal/terminal_bank.iff", x = 4.75, z = -20.7, y = 2.13, ox = 0, oy = 0, oz = 0, ow = 1, cellid = 9, containmentType = -1 },
		{ templateFile = "object/tangible/terminal/terminal_bank.iff", x = -1.57, z = -20.7, y = 2.13, ox = 0, oy = 0, oz = 0, ow = 1, cellid = 9, containmentType = -1 },

		-- Base Alarms
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_hack.iff", x = 1.4, z = 2.97, y = 3.21, ow = 0.008, ox = -0.699, oy = 0.714, oz = -0.008, cellid = 2, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_hack_no_sound.iff", x = 5.48, z = -16.32, y = 9.03, ow = 0.508, ox = 0.509, oy = -0.491, oz = 0.490, cellid = 9, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_hack_no_sound.iff", x = -5.25, z = 3.4, y = -0.8, ow = 0.005, ox = 0.707, oy = 0.707, oz = 0.005, cellid = 2, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_hack_no_sound.iff", x = 0.07, z = 3.40, y = -5.50, ow = 0, ox = 0, oy = 0.724, oz = 0.689, cellid = 3, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_hack_no_sound.iff", x = 2.1, z = -10.2, y = 0.7, ow = 0.005, ox = 0.707, oy = 0.707, oz = 0.005, cellid = 6, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_hack_no_sound.iff", x = -1.446, z = -10.43, y = 10.489, ow = 0, ox = 0, oy = -0.689, oz = 0.724, cellid = 7, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_destruct.iff", x = 1.5, z = -15.65, y = 3.6, ow = 0, ox = 0, oy = 0, oz = 1, cellid = 9, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_destruct.iff", x = -3.69, z = 3.75, y = 3.19, ow = -0.011, ox = 0.99, oy = 0.017, oz = 0.002550, cellid = 2, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_destruct.iff", x = 3.5, z = 4.25, y = -5.3, ow = 0, ox = 0, oy = 0, oz = 1, cellid = 3, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_destruct.iff", x = 3.2, z = -9, y = 8.9, ow = 0, ox = 0, oy = 0, oz = 1, cellid = 7, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_destruct_no_sound.iff", x = 1.5, z = -15.65, y = 10.5, ow = 0, ox = 0, oy = 0, oz = 1, cellid = 9, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_destruct_no_sound.iff", x = -3.7, z = 3.75, y = -4.7, ow = 0, ox = 0, oy = 0, oz = 1, cellid = 2, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_destruct_no_sound.iff", x = 3.4, z = -9.8, y = -0.7, ow = 0, ox = 0, oy = 0, oz = 1, cellid = 6, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_destruct_no_sound.iff", x = -8.5, z = -9, y = 9, ow = 0, ox = 0, oy = 0, oz = 1, cellid = 7, containmentType = -1 },
	},

	childCreatureObjects = {
		-- Exterior Spawns
		{ mobile = "fbase_rebel_master_sergeant_hard", x = 10, z = 0, y = 4, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_command_security_guard_hard", x = 10, z = 0, y = 10, cellid = -1, respawn = 360, containmentType = -1, heading = 0},

		{ mobile = "fbase_rebel_sharpshooter_hard", x = -10, z = 0, y = 4, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_recruit_hard", x = -10, z = 0, y = 10, cellid = -1, respawn = 360, containmentType = -1, heading = 0},

		{ mobile = "fbase_rebel_recruit_hard", x = 8, z = 0, y = 20, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_recruit_hard", x = -8, z = 0, y = 20, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_sharpshooter_hard", x = 12, z = 0, y = 17, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_sergeant_hard", x = -12, z = 0, y = 17, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_command_security_guard_hard", x = 3, z = 0, y = 27, cellid = -1, respawn = 360, containmentType = -1, heading = .78},
		{ mobile = "fbase_rebel_command_security_guard_hard", x = -3, z = 0, y = 27, cellid = -1, respawn = 360, containmentType = -1, heading = .78},

		{ mobile = "fbase_rebel_first_lieutenant_hard", x = 5, z = 0, y = 18, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_recruit_hard", x = -5, z = 0, y = 18, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_warrant_officer_ii_hard", x = 0, z = 0, y = 53, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_sharpshooter_hard", x = 2.5, z = 0, y = 50, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_corporal_hard", x = -2.5, z = 0, y = 50, cellid = -1, respawn = 360, containmentType = -1, heading = 0},

		{ mobile = "fbase_rebel_sharpshooter_hard", x = -28, z = 0, y = 0, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_sharpshooter_hard", x = -33, z = 0, y = 0, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_sergeant_hard", x = -30.5, z = 0, y = 2.5, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_command_security_guard_hard", x = -28, z = 0, y = 5, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_medic_hard", x = -33, z = 0, y = 5, cellid = -1, respawn = 360, containmentType = -1, heading = 0},

		{ mobile = "fbase_rebel_sharpshooter_hard", x = 28, z = 0, y = 0, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_sharpshooter_hard", x = 33, z = 0, y = 0, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_command_security_guard_hard", x = 30.5, z = 0, y = 2.5, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_command_security_guard_hard", x = 28, z = 0, y = 5, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_medic_hard", x = 33, z = 0, y = 5, cellid = -1, respawn = 360, containmentType = -1, heading = 0},

		{ mobile = "fbase_rebel_sharpshooter_hard", x = -24.5, z = 0, y = 34.5, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_comm_operator_hard", x = -22, z = 0, y = 37, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_sharpshooter_hard", x = -27, z = 0, y = 37, cellid = -1, respawn = 360, containmentType = -1, heading = 0},

		{ mobile = "fbase_rebel_sergeant_hard", x = 24.5, z = 0, y = 34.5, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_comm_operator_hard", x = 22, z = 0, y = 37, cellid = -1, respawn = 360, containmentType = -1, heading = 0},
		{ mobile = "fbase_rebel_medic_hard", x = 27, z = 0, y = 37, cellid = -1, respawn = 360, containmentType = -1, heading = 0},

		-- Interior Spawns
		-- 1 entry
		-- 2 hall1
		{ mobile = "fbase_rebel_recruit_hard", x = -4.7, z = 0.3, y = 3.9, cellid = 2, containmentType = -1, respawn = 60, heading = 1.5708},
		{ mobile = "fbase_rebel_cadet", x = -4.6, z = 0.3, y = -3.9, cellid = 2, containmentType = -1, respawn = 60, heading = 1.5708},
		-- 3 hall2
		{ mobile = "fbase_rebel_heavy_trooper", x = 3.2, z = 0.3, y = -4.9, cellid = 3, containmentType = -1, respawn = 60, heading = 0},
		-- 4 ramp1
		{ mobile = "fbase_rebel_medic_hard", x = -3.9, z = -6.8, y = 5.9, cellid = 4, containmentType = -1, respawn = 60, heading = 4.71239},
		-- 5 ramp2
		{ mobile = "fbase_rebel_heavy_trooper", x = 3.6, z = -13.8, y = -6.9, cellid = 5, containmentType = -1, respawn = 60, heading = 1.0472},
		-- 7 room3
		{ mobile = "fbase_rebel_sharpshooter_hard", x = -8.9, z = -13.8, y = 6.2, cellid = 7, containmentType = -1, respawn = 60, heading = 3.07178},
		{ mobile = "fbase_rebel_sergeant_hard", x = 4.4, z = -13.8, y = 6.1, cellid = 7, containmentType = -1, respawn = 60, heading = 2.28638},
		-- 8 ramp3
		-- 9 foyer
		{ mobile = "fbase_rebel_warrant_officer_ii_hard", x = 4.4, z = -20.7, y = 6.7, cellid = 9, containmentType = -1, respawn = 60, heading = 2.11185},
		{ mobile = "fbase_rebel_elite_sand_rat", x = 4.7, z = -20.7, y = 4.4, cellid = 9, containmentType = -1, respawn = 60, heading = 0.296706},
		-- 10 bunker
		{ mobile = "rebel_recruiter", x = 1.3, z = -20.8, y = 25.55, cellid = 10, containmentType = -1, respawn = 60, heading = 0.0698132},
		{ mobile = "fbase_rebel_master_sergeant_hard", x = 3.9, z = -20.8, y = 30.2, cellid = 10, containmentType = -1, respawn = 60, heading = 4.08407},
		{ mobile = "fbase_rebel_corporal_hard", x = 0.4, z = -20.8, y = 30, cellid = 10, containmentType = -1, respawn = 60, heading = 2.33874},
		{ mobile = "fbase_rebel_comm_operator_hard", x = -3.4, z = -20.8, y = 34.5, cellid = 10, containmentType = -1, respawn = 60, heading = 0.383972},
		{ mobile = "fbase_rebel_first_lieutenant_hard", x = -3.6, z = -20.8, y = 29.1, cellid = 10, containmentType = -1, respawn = 60, heading = 4.7473},
	},

	securityPatrols = {
		{patrol = "rebel_small_3", x = -8.8, z = 0, y = 3.9, heading = 0},
		{patrol = "rebel_small_3", x = 8.7, z = 0, y = 3.9, heading = 0},
		{patrol = "rebel_small_3", x = 0, z = 0, y = -11, heading = 0},
		{patrol = "rebel_small_3", x = 0, z = 0, y = 38, heading = 0},

		{patrol = "rebel_large_3", x = 0, z = 0, y = 18.1, heading = 0},
		{patrol = "rebel_large_3", x = -31, z = 0, y = 6.8, heading = 0},
		{patrol = "rebel_large_3", x = 31, z = 0, y = 6.8, heading = 0},
	},
}

ObjectTemplates:addTemplate(object_building_faction_perk_hq_hq_s03_rebel, "object/building/faction_perk/hq/hq_s03_rebel.iff")
