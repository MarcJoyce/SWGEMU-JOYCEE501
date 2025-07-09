WorldBossesScreenPlay = ScreenPlay:new {
  numberOfActs = 1,
  screenplayName = "WorldBossesScreenPlay",
  respawnFrequency = 1000 * 60,
  spawnTemplates = {
    -- "acklay_boss", "krayt_dragon_elder_boss", "rancor_boss", "jedi_boss", "graul_boss", "tusken_boss"
    "acklay", "krayt_dragon_ancient", "rancor", "dark_jedi_master", "graul", "tusken_king", "nightsister_elder", "singing_mountain_clan_councilwoman"
  },
  spawnPlanets = {
    "corellia", "dantooine", "dathomir", "endor", "lok", "naboo", "rori", "talus", "tatooine", "yavin4"
  },
  spawnLocations = {
    {x = 0, z = 0, y = 0},
  },
  spawns = {
    { "corellia", 
      { "acklay", "krayt_dragon_ancient" },
      { 
        { x = 547, z = 25, y = -308 }, " east of Lord Nyax's cult.",
        { x = 4596, z = 22, y = 1426 }, " near the Rogue Corsec base.",
      }
    },
    { "dantooine", 
      { "acklay", "krayt_dragon_ancient" },
      { 
        { x = -141, z = 10, y = -484 }, " tormenting Kunga's near their stronghold.",
        { x = -640, z = 23, y = -4704 }, " south of the Warren.",
      }
    },
    { "dathomir", 
      { "acklay", "krayt_dragon_ancient" },
      { 
        { x = -141, z = 10, y = -484 }, " north of the Singing Mountain Clan, along the beach.",
        { x = -640, z = 23, y = -4704 }, " near the Dathomir Tarpits.",
        { x = -6048, z = 125, y = -32 }, " south of the Dathomir Imperial Prison.",
      }
    },
    { "endor", 
      { "acklay", "krayt_dragon_ancient" },
      { 
        { x = -4409, z = 22, y = 4284 }, " escaped captivity of the Death Watch.",
        { x = 3552, z = 9, y = 3552 }, " east of the Korga cave.",
        { x = 1000, z = 31, y = -800 }, " between the Endorian outposts.",
      }
    },
    { "lok", 
      { "acklay", "krayt_dragon_ancient" },
      { 
        { x = 2470, z = 18, y = -4217 }, " at the foot of Adi's Rest.",
        { x = -2253, z = 11, y = -3070 }, " preparing to seige the Lokian Imperial Outpost.",
      }
    },
    { "naboo", 
      { "acklay", "krayt_dragon_ancient" },
      { 
        { x = -5331, z = 11, y = 3498 }, " south of Theed",
        { x = -2464, z = 61, y = -2992 }, " stalking Mordran",
      }
    },
    { "talus", 
      { "acklay", "krayt_dragon_ancient" },
      { 
        { x = 4307, z = 6, y = 1015 }, " seeking refuge in the Lost Village of Durbin.",
        { x = 395, z = 44, y = -821 }, " west of the Giant Fynock Cave.",
      }
    },
    { "tatooine", 
    { "krayt_dragon_ancient", "tusken_witch_doctor" },
    { 
      { x = -5870, z = 32, y = -5178 }, " north of Jabba's Palace.",
      { x = 5376, z = 34, y = 2400 }, " east of Mos Taike.",
      { x = -5456, z = 39, y = 6320 }, " west of Fort Tusken.",
      { x = 1954, z = 0, y = -4879 }, " between Mos Eisley and Anchorhead.",
    }
  },
  { "yavin4", 
    { "acklay", "krayt_dragon_ancient" },
    { 
      { x = 4763, z = 98, y = 5248 }, " south-west of Exar Kun.",
      { x = 5854, z = 661, y = -4383 }, " north-east of Imperial Outpost on Yavin4.",
    }
  },
  }
}

registerScreenPlay("WorldBossesScreenPlay", true)

function WorldBossesScreenPlay:start() 
  if (isZoneEnabled("corellia")) then
    self:respawnBoss()
  end
end

function WorldBossesScreenPlay:respawnBoss()
  local selection = self.spawns[getRandomNumber(1, #self.spawns)]
  local planet = selection[1]
  local template = selection[2][getRandomNumber(1, #selection[2])]
  local location = selection[3][getRandomNumber(1, #selection[3])]

  local coords = location[1]
  local suffixMessage = location[2]

  local message = "Locals have reporting sighting dangerous creatures" .. suffixMessage

  local pMobile = spawnMobile(planet, template, 0, coords.x, coords.z, coords.y, 0, 0)

  if (pMobile ~= nil) then
    printf("WorldBossesScreenPlay: " .. template .. " spawned on " .. planet .. " at " .. location.x .. ", " .. location.y .. ".")
    createObserver(OBJECTDESTRUCTION, "WorldBossesScreenPlay", "bossKilled", pMobile)
    broadcastToGalaxy(nullptr, message)
  else
    printf("WorldBossesScreenPlay: ERROR spawning boss: " .. template .. " spawned on " .. planet .. " at " .. location.x .. ", " .. location.y .. ".")
  end

  -- local boss = self:getRandomBoss()
  -- local planet = self:getRandomPlanet()
  -- local location = self:getRandomLocation()

  -- local pMobile = spawnMobile(planet, boss, 0, location.x, location.z, location.y, 0, 0)

  -- if (pMobile ~= nil) then
  --   printf("WorldBossesScreenPlay: " .. boss .. " spawned on " .. planet .. "at  " .. location.x .. ", " .. location.y .. ".")
  --   createObserver(OBJECTDESTRUCTION, "WorldBossesScreenPlay", "bossKilled", pMobile)
  -- else
  --   printf("WorldBossesScreenPlay: Error spawning boss, pMobile is nil")
  -- end

  -- broadcastToGalaxy(nullptr, "Locals on " .. planet .. " have reported sighting dangerous creatures around " .. location.x .. ", " .. location.y .. "...")
end

function WorldBossesScreenPlay:bossKilled(pMobile)
  if (pMobile == nil) then
    return
  end

  local playerTable = SceneObject(pMobile):getPlayersInRange(120)

  for i = 1, #playerTable, 1 do
    local pPlayer = playerTable[i]

    if (pPlayer ~= nil) then
      local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")

      if pInventory == nil then
        printf("Error locating target inventory\n")
        return nil
      end

      local pItem = createLootFromCollection(pInventory, "world_boss", 300)

      CreatureObject(pPlayer):sendSystemMessage("You have received a loot item!")
    end
  end

  createEvent(self.respawnFrequency, "WorldBossesScreenPlay", "respawnBoss", nil, "")
  return 1
end

function WorldBossesScreenPlay:getRandomBoss()
  local index = getRandomNumber(1, #self.spawnTemplates)
  return self.spawnTemplates[index]
end

function WorldBossesScreenPlay:getRandomPlanet()
  local index = getRandomNumber(1, #self.spawnPlanets)
  return self.spawnPlanets[index]
end

function WorldBossesScreenPlay:getRandomLocation()
  local index = getRandomNumber(1, #self.spawnLocations)
  return self.spawnLocations[index]
end
