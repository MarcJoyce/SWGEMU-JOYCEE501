BBWeaponsConfig = {
	path = "object/draft_schematic/weapon/",
	qualityMin = 40,
	qualityAvg = 50, -- 10% chance to use this as the min value and qualityMax as the max value
	qualityMax = 55, -- 1% Chance to get up to +5 to the max value, with qualityMax as the min value
	freq = 604800, -- Every x seconds
	eventName = "BazaarBotAddWeapons",
	functionName = "addMoreWeapons",
	listingChance = 50
}

-- {price, quantity, crateQuantity, "altTemplate", "templates"...},
-- price: Price * (random(QualityRoll/4, QualityRoll/2) / 100 + 1) * crateQuantity
-- quantity: How many of each item in the group will be listed every freq seconds
-- crateQuantity: Set higher than 1 to make factory crates rather than individual items
-- altTemplate: Items such as statues that have a drop down to choose alternate final objects
-- Items that don't have altTemplates and should be the same price can be grouped together

BBWeaponsItems = {
	-- Starter
	{350, 1, 1, 0, "axe"},
	{350, 1, 1, 0, "carbine_blaster_cdef"},
	{350, 1, 1, 0, "knife_survival"},
	{350, 1, 1, 0, "pistol_blaster_cdef"},
	{350, 1, 1, 0, "rifle_blaster_cdef"},
	{350, 1, 1, 0, "staff"},
	{350, 1, 1, 0, "rifle_blaster_dlt20"},
	{350, 1, 1, 0, "rifle_light_blaster_dh17_carbine"},
	{350, 1, 1, 0, "pistol_blaster_d18"},

	-- Tier 1 Marksman/Brawler
	{1000, 1, 1, 0, "baton_gaderiffi"},
	{1000, 1, 1, 0, "knife_vibroblade"},
	{1000, 1, 1, 0, "2h_sword_scythe"},
	{1000, 1, 1, 0, "sword"},
	{1000, 1, 1, 0, "staff_metal"},
	{1000, 1, 1, 0, "staff_reinforced"},
	{1000, 1, 1, 0, "battleaxe"},
	{1000, 1, 1, 0, "lance_vibro"},
	{1000, 1, 1, 0, "katana"},
	{1000, 1, 1, 0, "rifle_projectile_tusken"},
	{1000, 1, 1, 0, "rifle_blaster_dlt20a"},
	{1000, 1, 1, 0, "pistol_blaster_dl44"},
	{1000, 1, 1, 0, "pistol_blaster_dl44_metal"},
	{1000, 1, 1, 0, "rifle_light_blaster_dh17_carbine_snubnose"},

	-- Tier 2 Marksman/Brawler
	{2500, 1, 1, 0, "sword_curved"},
	{2500, 1, 1, 0, "pistol_blaster_scout_trooper"},
	{2500, 1, 1, 0, "pistol_blaster_dh17"},
	{2500, 1, 1, 0, "rifle_light_blaster_e11_carbine"},
	{2500, 1, 1, 0, "rifle_sonic_sg82"},
	{2500, 1, 1, 0, "rifle_blaster_laser_rifle"},
	{2500, 1, 1, 0, "pistol_de_10"},
	{2500, 1, 1, 0, "rifle_tenloss_disrupter"},
	{2500, 1, 1, 0, "rifle_bowcaster"},

	-- Tier 3 Marksman/Brawler
	{4500, 1, 1, 0, "sword_ryyk_blade"},
	{4500, 1, 1, 0, "axe_vibro"},
	{4500, 1, 1, 0, "poleaxe_vibro"},
	{4500, 1, 1, 0, "rifle_spray_stick_stohli"},
	{4500, 1, 1, 0, "pistol_blaster_power5"},
	{4500, 1, 1, 0, "pistol_projectile_striker"},
	{4500, 1, 1, 0, "rifle_light_blaster_laser_carbine"},
	{4500, 1, 1, 0, "pistol_geo_sonic_blaster"},

	-- Tier 4 Marksman/Brawler
	{7500, 1, 1, 0, "cleaver"},
	{7500, 1, 1, 0, "maul"},
	{7500, 1, 1, 0, "baton_stun"},
	{7500, 1, 1, 0, "rifle_disrupter_dxr6"},
	{7500, 1, 1, 0, "rifle_light_blaster_ee3"},
	{7500, 1, 1, 0, "pistol_flechette_fwg5"},
	{7500, 1, 1, 0, "pistol_blaster_short_range_combat"},
	{7500, 1, 1, 0, "rifle_tangle_gun7"},
	{7500, 1, 1, 0, "rifle_blaster_e11"},
	{7500, 1, 1, 0, "rifle_blaster_ionization_jawa"},

	-- Elite professions
	{10500, 1, 1, 0, "knuckler_vibro"},
	{10500, 1, 1, 0, "rifle_t21"},
	{10500, 1, 1, 0, "pistol_scatter"},
	{10500, 1, 1, 0, "rifle_lightning"},
	{10500, 1, 1, 0, "heavy_acid_beam"},
	{10500, 1, 1, 0, "heavy_lightning_beam"},
	{10500, 1, 1, 0, "heavy_particle_beam"},
	{10500, 1, 1, 0, "heavy_rocket_launcher"},
	{10500, 1, 1, 0, "pistol_launcher"},
	{10500, 1, 1, 0, "rifle_acid_beam"},
	{10500, 1, 1, 0, "rifle_beam"},
	{10500, 1, 1, 0, "rifle_flame_thrower"},
	{10500, 1, 1, 0, "pistol_disrupter_dx2"},
	{10500, 1, 1, 0, "pistol_republic_blaster"},
}

-- BBWeaponsItems = {
-- 	-- Starter
-- 	{350, 1, 1, 0, 
-- 	"axe", 
-- 	"carbine_blaster_cdef", 
-- 	"knife_survival", 
-- 	"pistol_blaster_cdef", 
-- 	"rifle_blaster_cdef", 
-- 	"staff", 
-- 	"rifle_blaster_dlt20", 
-- 	"rifle_light_blaster_dh17_carbine", 
-- 	"pistol_blaster_d18"
-- 	},
-- 	-- Teir 1 Marksman/Brawler
-- 	{1000, 1, 1, 0, 
-- 	"baton_gaderiffi", 
-- 	"knife_vibroblade", 
-- 	"2h_sword_scythe", 
-- 	"sword", 
-- 	"staff_metal", 
-- 	"staff_reinforced", 
-- 	"battleaxe", 
-- 	"lance_vibro", 
-- 	"katana", 
-- 	"rifle_projectile_tusken", 
-- 	"rifle_blaster_dlt20a", 
-- 	"pistol_blaster_dl44", 
-- 	"pistol_blaster_dl44_metal", 
-- 	"rifle_light_blaster_dh17_carbine_snubnose"
-- 	},
-- 	-- Teir 2 Marksman/Brawler
-- 	{2500, 1, 1, 0, 
-- 	"sword_curved", 
-- 	"pistol_blaster_scout_trooper", 
-- 	"pistol_blaster_dh17",
-- 	"rifle_light_blaster_e11_carbine", 
-- 	"rifle_sonic_sg82", 
-- 	"rifle_blaster_laser_rifle", 
-- 	"pistol_de_10", 
-- 	"rifle_tenloss_disrupter", 
-- 	"rifle_bowcaster"
-- 	},
-- 	-- Teir 3 Marksman/Brawler
-- 	{4500, 1, 1, 0, 
-- 	"sword_ryyk_blade", 
-- 	"axe_vibro", 
-- 	"poleaxe_vibro", 
-- 	"rifle_spray_stick_stohli", 
-- 	"pistol_blaster_power5", 
-- 	"pistol_projectile_striker", 
-- 	"rifle_light_blaster_laser_carbine", 
-- 	"pistol_geo_sonic_blaster"
-- 	},
-- 	-- Teir 4 Marksman/Brawler
-- 	{7500, 1, 1, 0, 
-- 	"cleaver", 
-- 	"maul", 
-- 	"baton_stun", 
-- 	"rifle_disrupter_dxr6", 
-- 	"rifle_light_blaster_ee3", 
-- 	"pistol_flechette_fwg5", 
-- 	"pistol_blaster_short_range_combat", 
-- 	"rifle_tangle_gun7", 
-- 	"rifle_blaster_e11", 
-- 	"rifle_blaster_ionization_jawa"
-- 	},
-- 	-- Eilite professions
-- 	{10500, 1, 1, 0, 
-- 	"knuckler_vibro", 
-- 	"rifle_t21", 
-- 	"pistol_scatter", 
-- 	"rifle_lightning", 
-- 	"heavy_acid_beam", 
-- 	"heavy_lightning_beam", 
-- 	"heavy_particle_beam", 
-- 	"heavy_rocket_launcher", 
-- 	"pistol_launcher", 
-- 	"rifle_acid_beam", 
-- 	"rifle_beam", 
-- 	"rifle_flame_thrower", 
-- 	"pistol_disrupter_dx2", 
-- 	"pistol_republic_blaster"
-- 	},
-- } 