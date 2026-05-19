BBArtisanConfig = {
	path = "object/draft_schematic/item/item_",
	qualityMin = 50,
	qualityAvg = 50, -- 10% chance to use this as the min value and qualityMax as the max value
	qualityMax = 50, -- 1% Chance to get up to +5 to the max value, with qualityMax as the min value
	freq = 86400, -- Every x seconds
	eventName = "BazaarBotAddArtisanItems",
	functionName = "addMoreArtisanItems",
	listingChance = 100
}

-- {price", "quantity", "crateQuantity", "altTemplate", "templates"...},
-- price: Price * (random(QualityRoll/4, QualityRoll/2) / 100 + 1) * crateQuantity
-- quantity: How many of each item in the group will be listed every freq seconds
-- crateQuantity: Set higher than 1 to make factory crates rather than individual items
-- altTemplate: Items such as statues that have a drop down to choose alternate final objects
-- Items that don't have altTemplates and should be the same price can be grouped together
BBArtisanItems = {
	{250, 10, 1, 0, "clothing_tool", "food_tool", "generic_tool", "space_tool", "structure_tool", "weapon_tool"},
	{100, 10, 1, 0, "survey_tool_flora", "survey_tool_gas", "survey_tool_liquid", "survey_tool_mineral", "survey_tool_moisture", "survey_tool_solar", "survey_tool_wind"},
	{1000, 10, 1, 0, "clothing_station", "food_station", "structure_station", "weapon_station"},
	--{95000, 4, 10, 0, "recycler_chemical", "recycler_creature", "recycler_flora",	"recycler_metal", "recycler_ore"},
}

BBArtisanItemsUnused = {
	"space_station",
}


