TreasureScreenPlay = ScreenPlay:new {
  numberOfActs = 1,
  AdminPlayerID = 281474993547517, 
  screenplayName = "TreasureScreenPlay",
  spawnPoints = {
    -- planet, x, z, y, heading, cellid
    { "tatooine", 69.5801, 52, -5309.01, 166.001, 0 },
    { "tatooine", 3444.49, 5, -4791.82, 354, 0 },
    { "tatooine", -2907, 5, 2097, 262, 0 },
    { "tatooine", 1231, 7, 3011, 329, 0 },
    { "tatooine", -1217, 12, -3684, 291, 0 },
    { "corellia", -245, 28, -4784, 356, 0 },
    { "corellia", 6734, 330, -5926, 340, 0 },
    { "corellia", -5319, 4, -6435, 50, 0 },
    { "talus", 4277, 2, 5140, 315, 0 },
    { "talus", 4132, 9, 916, 340, 0 },
    { "talus", 4162, 2, 5310, 176, 0 },
    { "talus", 4212, 2, 5311, 150, 0 },
    { "talus", 4103, 2, 5256, 240, 0 },
    { "naboo", 5068, 350, -1510, 152, 0 },
    { "naboo", -5459, -150, -61, 269, 0 },
    { "naboo", 41, 8, -43, 305, 1692104 },
    { "naboo", -40, 8, -43, 52, 1692104 },
    { "rori", 5432, 80, 5530, 339, 0 },
    { "rori", 3702, 96, -6470, 237, 0 },
    { "tatooine", 105.086, 52, -5317.64, 156, 0 },
    { "tatooine", 163.24, 52, -5329.61, 272, 0 },
    { "tatooine", 135.637, 52, -5369.08, 121, 0 },
    { "dantooine", -623.705, 3, 2446.13, 352, 0 },
    { "dantooine", -597.51, 3, 2478.33, 318, 0 },
    { "dantooine", -594.163, 3, 2526.78, 195, 0 },
    { "dathomir", -77.6813, 18, -1641.94, 27, 0 },
    { "dathomir", -133.056, 18, -1579.06, 142, 0 },
    { "yavin4", -6917.35, 73, -5738.96, 274, 0 },
    { "yavin4", -6971.24, 73.0124, -5768.63, 36, 0 },
    { "yavin4", -6951.92, 73, -5771.06, 332, 0 },
    { "yavin4", -6980.04, 72.9405, -5651, 199, 0 },
    { "yavin4", -6895.74, 73, -5655.6, 226, 0 },
    { "yavin4", -6877.63, 73, -5691.22, 269, 0 },
    { "endor", -873.992, 80.6017, 1547.54, 235, 0 },
    { "endor", -857.123, 80.0032, 1551.24, 86, 0 },
    { "endor", -834.798, 76, 1569.65, 7, 0 },
    { "endor", -838.902, 79.949, 1612.02, 105, 0 },
    { "endor", -869.627, 76, 1631.81, 262, 0 },
    { "lok", 456.368, 2.99648, 5435.29, 55, 0 },
    { "lok", 470.151, 3, 5441.58, 267, 0 },
    { "lok", 457.344, 3, 5450.24, 152, 0 },
    { "lok", 368.805, 12.1322, 5106.23, 57, 0 },
    { "lok", 395.682, 12, 5004.22, 305, 0 },
    { "lok", 470.601, 11.9147, 5034.67, 251, 0 },
    { "lok", 453.355, 11.8449, 5000.51, 14, 0 },
    { "lok", 506.535, 12.0835, 4980.66, 99, 0 },
    { "lok", 498.944, 11.7831, 5202.02, 264, 0 },
  }
}

registerScreenPlay("TreasureScreenPlay", true)

function TreasureScreenPlay:start() 
  self:spawnStan()
end

function TreasureScreenPlay:spawnStan()
  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)
  local location = self.spawnPoints[getRandomNumber(1, #self.spawnPoints)]
  local pMobile = spawnMobile(location[1], "treasure_stan", 0, location[2], location[3], location[4], location[5], location[6])

  if (pMobile ~= nil) then
    logToFile("Treasure Stan spawned on " .. location[1] .. " at " .. location[2] .. ", " .. location [4] .. ".", "log/treasure_stan.log")
    
    local randomName = tostring(getRandomNumber(1, 9999))
    SceneObject(pMobile):setCustomObjectName(randomName .. " clone of Stan")
    
    local objectID = tostring(SceneObject(pMobile):getObjectID())
    
    writeScreenPlayData(pAdminPlayer, "TreasureScreenPlay", "stanId", objectID)
  else 
    logToFile("Failed to spawn Treasure Stan", "log/treasure_stan.log")
  end

end

function TreasureScreenPlay:refreshStan()
  self:despawnStan()
  self:spawnStan()
end

function TreasureScreenPlay:despawnStan()
  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)
  local objectID = tonumber(readScreenPlayData(pAdminPlayer, "TreasureScreenPlay", "stanId"))

  local pStan = getCreatureObject(objectID)

  if (pStan ~= nil) then
    SceneObject(pStan):destroyObjectFromWorld()
  end

  deleteScreenPlayData(pAdminPlayer, "TreasureScreenPlay", "stanId")
  deleteScreenPlayData(pAdminPlayer, "TreasureScreenPlay", "givenTreasure")
end
