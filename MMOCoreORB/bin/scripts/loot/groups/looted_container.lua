looted_container = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		-- Junk/Misc Items (25% chance)
		-- Common
		{itemTemplate  =  "broken_decryptor", weight  = 96000 },
		{itemTemplate  =  "camera", weight  = 96000 },
		{itemTemplate  =  "corrupt_datadisk", weight  = 96000 },
		{itemTemplate  =  "corsec_id_badge", weight  = 96000 },
		{itemTemplate  =  "damaged_datapad", weight  = 96000 },
		{itemTemplate  =  "decorative_bowl", weight  = 96000 },
		{itemTemplate  =  "decorative_shisa", weight  = 96000 },
		{itemTemplate  =  "dermal_analyzer", weight  = 96000 },
		{itemTemplate  =  "dud_firework_grey", weight  = 96000 },
		{itemTemplate  =  "dud_firework_red", weight  = 96000 },
		{itemTemplate  =  "empty_cage", weight  = 96000 },
		{itemTemplate  =  "expensive_basket", weight  = 96000 },
		{itemTemplate  =  "expired_ticket", weight  = 96000 },
		{itemTemplate  =  "hyperdrive_part", weight  = 96000 },
		{itemTemplate  =  "ledger", weight  = 96000 },
		{itemTemplate  =  "locked_briefcase", weight  = 96000 },
		{itemTemplate  =  "locked_container", weight  = 96000 },
		{itemTemplate  =  "loudspeaker", weight  = 96000 },
		{itemTemplate  =  "palm_frond", weight  = 96000 },
		{itemTemplate  =  "photographic_image", weight  = 96000 },
		{itemTemplate  =  "recorded_image_1", weight  = 96000 },
		{itemTemplate  =  "recording_rod", weight  = 96000 },
		{itemTemplate  =  "slave_collar", weight  = 96000 },
		{itemTemplate  =  "used_ticket", weight  = 96000 },
		{itemTemplate  =  "worklight", weight  = 96000 },


		{itemTemplate  =  "force_color_crystal", weight  = 64000 },
		{itemTemplate  =  "force_power_crystal", weight  = 64000 },
		{itemTemplate  =  "jedi_holocron_dark", weight  = 48000 },
		{itemTemplate  =  "jedi_holocron_light", weight  = 48000 },
		{itemTemplate  =  "attachment_clothing", weight  = 64000 },
		{itemTemplate  =  "attachment_armor", weight  = 64000 },
		{groupTemplate  = "blank_enhancement_disks", weight = 16000 },
		{itemTemplate  = "attachment_jedi_clothing", weight = 32000 },
		-- Weapons (25% chance)
		{groupTemplate  =  "weapons_all", weight  = 2400000 },

		-- Armors (25% chance)
		{groupTemplate  =  "armor_all", weight  = 2400000 },

		-- Clothing (25% chance)
		{groupTemplate  =  "wearables_all", weight  = 2400000 },

	}
}

addLootGroupTemplate("looted_container", looted_container)
