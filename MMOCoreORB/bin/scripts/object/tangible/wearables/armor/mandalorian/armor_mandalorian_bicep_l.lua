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


object_tangible_wearables_armor_mandalorian_armor_mandalorian_bicep_l = object_tangible_wearables_armor_mandalorian_shared_armor_mandalorian_bicep_l:new {
	templateType = ARMOROBJECT,
	objectMenuComponent = "ArmorObjectMenuComponent",

	-- certificationsRequired = { "combat_bountyhunter_master",
	-- 				"combat_commando_master",
	-- 				"outdoors_squadleader_master",
	-- 				"outdoors_ranger_master" },

	playerRaces = { "object/creature/player/bothan_male.iff",
				"object/creature/player/bothan_female.iff",
				"object/creature/player/human_male.iff",
				"object/creature/player/human_female.iff",
				"object/creature/player/moncal_male.iff",
				"object/creature/player/moncal_female.iff",
				"object/creature/player/rodian_male.iff",
				"object/creature/player/rodian_female.iff",
				"object/creature/player/sullustan_male.iff",
				"object/creature/player/sullustan_female.iff",
				"object/creature/player/trandoshan_male.iff",
				"object/creature/player/trandoshan_female.iff",
				"object/creature/player/twilek_male.iff",
				"object/creature/player/twilek_female.iff",
				"object/creature/player/zabrak_male.iff",
				"object/creature/player/zabrak_female.iff",
				"object/mobile/vendor/aqualish_female.iff",
				"object/mobile/vendor/aqualish_male.iff",
				"object/mobile/vendor/bith_female.iff",
				"object/mobile/vendor/bith_male.iff",
				"object/mobile/vendor/bothan_female.iff",
				"object/mobile/vendor/bothan_male.iff",
				"object/mobile/vendor/devaronian_male.iff",
				"object/mobile/vendor/gran_male.iff",
				"object/mobile/vendor/human_female.iff",
				"object/mobile/vendor/human_male.iff",
				"object/mobile/vendor/ishi_tib_male.iff",
				"object/mobile/vendor/moncal_female.iff",
				"object/mobile/vendor/moncal_male.iff",
				"object/mobile/vendor/nikto_male.iff",
				"object/mobile/vendor/quarren_male.iff",
				"object/mobile/vendor/rodian_female.iff",
				"object/mobile/vendor/rodian_male.iff",
				"object/mobile/vendor/sullustan_female.iff",
				"object/mobile/vendor/sullustan_male.iff",
				"object/mobile/vendor/trandoshan_female.iff",
				"object/mobile/vendor/trandoshan_male.iff",
				"object/mobile/vendor/twilek_female.iff",
				"object/mobile/vendor/twilek_male.iff",
				"object/mobile/vendor/weequay_male.iff",
				"object/mobile/vendor/zabrak_female.iff",
				"object/mobile/vendor/zabrak_male.iff" },
	
	-- Damage types in WeaponObject
	-- vulnerability = COLD + ELECTRICITY + STUN + LIGHTSABER,

	-- These are default Blue Frog stats, These are also used as temporary DWB crafting stats. Needs to be adjusted to random color, and Blast should be a Special Resist. Encumberance on boots and all arm/hand armor are estimated. Helm/Chest/Leggings are correct. 
	healthEncumbrance = 0,
	actionEncumbrance = 0,
	mindEncumbrance = 0,

	-- LIGHT, MEDIUM, HEAVY
	rating = HEAVY,
	maxCondition = 100000,

	kinetic = 90,
	energy = 90,
	electricity = 90,
	stun = 90,
	blast = 90,
	heat = 90,
	cold = 90,
	acid = 90,
	lightSaber = 90
}

ObjectTemplates:addTemplate(object_tangible_wearables_armor_mandalorian_armor_mandalorian_bicep_l, "object/tangible/wearables/armor/mandalorian/armor_mandalorian_bicep_l.iff")
