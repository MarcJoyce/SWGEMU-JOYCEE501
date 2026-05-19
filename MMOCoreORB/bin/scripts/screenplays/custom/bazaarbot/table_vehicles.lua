BBVehicleConfig = {
  path = "object/draft_schematic/vehicle/civilian/",
  qualityMin = 50,
	qualityAvg = 75, -- 10% chance to use this as the min value and qualityMax as the max value
	qualityMax = 95, -- 1% Chance to get up to +5 to the max value, with qualityMax as the min value
  freq = 86400,
  eventName = "BazaarBotAddVehicles",
  functionName = "addMoreVehicles",
  listingChance = 100
}

BBVehicleItems = {
  {250, 5, 1, 0, "landspeeder_x34"},
  {500, 5, 1, 0, "speeder_bike"},
  {5000, 5, 1, 0, "speeder_bike_swoop"}
}