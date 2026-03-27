BBAdditiveConfig = {
	path = "object/draft_schematic/food/additive/",
	qualityMin = 50,
	qualityAvg = 75, -- 10% chance to use this as the min value and qualityMax as the max value
	qualityMax = 95, -- 1% Chance to get up to +5 to the max value, with qualityMax as the min value
	freq = 86400, -- Every x seconds
	eventName = "BazaarBotAddAdditive",
	functionName = "addMoreAdditive",
	listingChance = 100
}

-- {price, quantity, crateQuantity, "altTemplate", "templates"...},
-- price: Price * (random(QualityRoll/4, QualityRoll/2) / 100 + 1) * crateQuantity
-- quantity: How many of each item in the group will be listed every freq seconds
-- crateQuantity: Set higher than 1 to make factory crates rather than individual items
-- altTemplate: Items such as statues that have a drop down to choose alternate final objects
-- Items that don't have altTemplates and should be the same price can be grouped together

BBAdditiveItems = {
  {15000, 5, 25, 0, "additive_light", "additive_medium", "additive_heavy" }
}