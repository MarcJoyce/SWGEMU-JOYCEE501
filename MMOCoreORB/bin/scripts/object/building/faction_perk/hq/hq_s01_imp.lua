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

object_building_faction_perk_hq_hq_s01_imp = object_building_faction_perk_hq_shared_hq_s01_imp:new {
	lotSize = 0,
	containerComponent = "GCWBaseContainerComponent",
	groundZoneComponent = "StructureZoneComponent",
	maintenanceCost = 0,
	baseMaintenanceRate = 0,
	faction = "imperial",
	pvpFaction = "imperial",
	pvpStatusBitmask = 0,
	dataObjectComponent = "DestructibleBuildingDataComponent",
	allowedZones = {"corellia", "dantooine", "dathomir", "endor", "lok", "naboo", "talus", "tatooine", "yavin4" },
	constructionMarker = "object/building/player/construction/construction_player_house_generic_medium_style_01.iff",
	length = 7,
	width = 6,
	planetMapCategory = "imperial",
	alwaysPublic = 1,
	factionBaseType = 1,

	childObjects = {
		{ templateFile = "object/static/structure/military/military_wall_weak_imperial_16_style_01.iff", x = 21, z = 0, y = -2, ox = 0, oy = 0.707, oz = 0, ow = 0.707, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/military/military_wall_weak_imperial_16_style_01.iff", x = -21, z = 0, y = -2, ox = 0, oy = 0.707, oz = 0, ow = 0.707, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/military/military_wall_weak_imperial_16_style_01.iff", x = -13, z = 0, y = -10, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/military/military_wall_weak_imperial_16_style_01.iff", x = 13, z = 0, y = -10, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },

		{ templateFile = "object/static/structure/military/military_wall_weak_imperial_style_01.iff", x = 17, z = 0, y = 6, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/military/military_wall_weak_imperial_style_01.iff", x = -9, z = 0, y = 14, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/military/military_wall_weak_imperial_style_01.iff", x = 13, z = 0, y = 10, ox = 0, oy = 0.707, oz = 0, ow = 0.707, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/military/military_wall_weak_imperial_style_01.iff", x = -17, z = 0, y = 6, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/military/military_wall_weak_imperial_style_01.iff", x = -13, z = 0, y = 10, ox = 0, oy = 0.707, oz = 0, ow = 0.707, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/military/military_wall_weak_imperial_style_01.iff", x = 9, z = 0, y = 14, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/military/military_wall_weak_imperial_style_01.iff", x = 0, z = 0, y = -10, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },

		{ templateFile = "object/static/structure/military/military_column_strong_imperial_style_01.iff", x = -4, z = 0, y = -10, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/military/military_column_strong_imperial_style_01.iff", x = 4, z = 0, y = -10, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },

		{ templateFile = "object/static/structure/military/corl_power_transformer_s02.iff", x = -17, z = 0, y = -1, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/military/corl_power_bubble_node.iff", x = -17, z = 0, y = -6, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/static/structure/military/corl_power_transformer_s01.iff", x = 17, z = 0, y = -6, ox = 0, oy = -0.707, oz = 0, ow = 0.707, cellid = -1, containmentType = -1 },

		{ templateFile = "object/installation/faction_perk/turret/tower_lg.iff", x = -17, z = 0, y = 10, ox = 0, oy = -0, oz = 0, ow = 1, cellid = -1, containmentType = -1 }, -- left turret front
		{ templateFile = "object/installation/faction_perk/turret/tower_lg.iff", x = 17, z = 0, y = 10, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },

		{ templateFile = "object/installation/faction_perk/covert_detector/detector_32m.iff", x = 0, z = 0, y = 18, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/installation/faction_perk/minefield/field_1x1.iff", x = 3.5, z = 0, y = 10, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },
		{ templateFile = "object/installation/faction_perk/minefield/field_1x1.iff", x = -3.5, z = 0, y = 10, ox = 0, oy = 0, oz = 0, ow = 1, cellid = -1, containmentType = -1 },

		{ templateFile = "object/tangible/terminal/terminal_hq_turret_control.iff", x = -1.5, z = 0, y = -1.8, ow = .7, ox = 0, oz = 0, oy = .7, cellid = 3, containmentType = -1 },
		{ templateFile = "object/tangible/terminal/terminal_hq_turret_control.iff", x = -1.5, z = 0, y = -.5, ow = .7, ox = 0, oz = 0, oy = .7, cellid = 3, containmentType = -1 },

		{ templateFile = "object/tangible/terminal/terminal_mission_imperial.iff", x = 4, z = 0.13, y = -5.89, ox = 0, oy = 0, oz = 0, ow = 1, cellid = 5, containmentType = -1 },

		{ templateFile = "object/tangible/terminal/terminal_hq_imperial.iff", x = 0, z = 0, y = -6, ox = 0, oy = 0, oz = 0, ow = 1, cellid = 3, containmentType = -1 },

		-- Base Alarms
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_hack.iff", x = -6, z = 2.8, y = 3, ow = 0.005, ox = 0.707, oy = 0.707, oz = 0.005, cellid = 2, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_hack_no_sound.iff", x = 0, z = 3.2, y = 2.5, ow = 0.700, ox = -0.700, oy = 0.04, oz = -0.04, cellid = 3, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_destruct.iff", x = -5, z = 3.1, y = 3, ow = 0, ox = 0, oy = 0, oz = 1, cellid = 2, containmentType = -1 },
		{ templateFile = "object/tangible/faction_perk/faction_base_item/alarm_destruct.iff", x = 0, z = 3.6, y = -2, ow = 0, ox = 0, oy = 0, oz = 1, cellid = 3, containmentType = -1 },
	},

	childCreatureObjects = {
		-- Exterior Spawns
		{ mobile = "fbase_imperial_sharpshooter", x = 4, z = 0, y = 50, cellid = -1, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_imperial_sharpshooter", x = 0, z = 0, y = 50, cellid = -1, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_imperial_sharpshooter", x = -4, z = 0, y = 50, cellid = -1, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "at_st", x = 0, z = 0, y = 42, cellid = -1, respawn = 300, containmentType = -1, heading = 0},

		{ mobile = "fbase_command_security_guard", x = -25, z = 0, y = 14, cellid = -1, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_command_security_guard", x = -30, z = 0, y = 14, cellid = -1, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_swamp_trooper", x = -27.5, z = 0, y = 16.5, cellid = -1, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_specialist_noncom", x = -25, z = 0, y = 19, cellid = -1, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_imperial_noncom", x = -30, z = 0, y = 19, cellid = -1, respawn = 300, containmentType = -1, heading = 0},

		{ mobile = "fbase_command_security_guard", x = 25, z = 0, y = 14, cellid = -1, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_command_security_guard", x = 30, z = 0, y = 14, cellid = -1, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_imperial_corporal", x = 27.5, z = 0, y = 16.5, cellid = -1, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_imperial_medic", x = 25, z = 0, y = 19, cellid = -1, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_imperial_sergeant", x = 30, z = 0, y = 19, cellid = -1, respawn = 300, containmentType = -1, heading = 0},

		{ mobile = "fbase_imperial_sharpshooter", x = -8, z = 0, y = 10, cellid = -1, respawn = 300, containmentType = -1, heading = 1.571 },
		{ mobile = "fbase_comm_operator", x = 8, z = 0, y = 10, cellid = -1, respawn = 300, containmentType = -1, heading = -1.571 },
		{ mobile = "fbase_imperial_warrant_officer_ii", x = 15, z = 0, y = 0, cellid = -1, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_imperial_master_sergeant", x = 0, z = 0, y = 9, cellid = -1, respawn = 300, containmentType = -1, heading = 0},

		-- Interior Spawns
		{ mobile = "imperial_recruiter", x = -3.9, z = 0.13, y = -3.47, cellid = 6, containmentType = -1, respawn = 60, heading = -4.71},
		{ mobile = "fbase_imperial_medic", x = 4.34, z = 0.13, y = 1.88, cellid = 4, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_imperial_first_lieutenant", x = 2.6, z = 0, y = 0.75, cellid = 4, respawn = 300, containmentType = -1, heading = 4.71 },
		{ mobile = "fbase_stormtrooper_captain", x = 3.4, z = 0.13, y = -3.3, cellid = 5, respawn = 300, containmentType = -1, heading = 4.71 },
		{ mobile = "fbase_imperial_sharpshooter", x = -0.9, z = 0.13, y = -5.1, cellid = 3, respawn = 300, containmentType = -1, heading = 0},
		{ mobile = "fbase_imperial_sharpshooter", x = 0.9, z = 0.13, y = -5.1, cellid = 3, respawn = 300, containmentType = -1, heading = 0},
	},

	securityPatrols = {
		{patrol = "imperial_small_1", x = 9.7, z = 0, y = 10.8, heading = 0},
		{patrol = "imperial_small_1", x = -9.7, z = 0, y = 10.8, heading = 0},
		{patrol = "imperial_small_1", x = 0, z = 0, y = -19.7, heading = 0},
		{patrol = "imperial_small_1", x = -10.8, z = 0, y = -1.7, heading = 0},
		{patrol = "imperial_small_1", x = 12.6, z = 0, y = -0.7, heading = 0},

		{patrol = "imperial_large_1", x = -25.7, z = 0, y = 33.5, heading = 0},
		{patrol = "imperial_large_1", x = 25.7, z = 0, y = 33.5, heading = 0},
	},
}

ObjectTemplates:addTemplate(object_building_faction_perk_hq_hq_s01_imp, "object/building/faction_perk/hq/hq_s01_imp.iff")
