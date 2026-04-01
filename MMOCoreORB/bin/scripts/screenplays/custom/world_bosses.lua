WorldBossesScreenPlay = ScreenPlay:new {
  numberOfActs = 1,
  AdminPlayerID = 281474993547517, -- PlayerID of Admin character
  screenplayName = "WorldBossesScreenPlay",
  respawnFrequency = 1000 * 86400 / 24 / 2, -- 30 mins
  specialSpawns = { 
    {
      { "world_boss_jedi", 1 },
      { "world_boss_jedi_drone", 1 }
    },
    {
      { "world_boss_stan", 1 }
    }
  },
  spawns = {
    { "corellia", 
      { 
        {
          { "world_boss_butterfly", 1 },
          { "world_boss_butterfly_drone", 10 }
        },
        {
          { "world_boss_durni", 1 },
          { "world_boss_durni_warrior", 3 },
          { "world_boss_durni_drone", 10 }
        },
        {
          { "world_boss_carrion_spat", 1 },
          { "world_boss_carrion_spat_drone", 3 }
        }
      },
      { 
        {{ x = 547, z = 25, y = -308 }, " west of Lord Nyax's cult."},
        {{ x = 4596, z = 22, y = 1426 }, " near the Rogue Corsec base."}
      }
    },
    { "dantooine", 
      { 
        {
          { "world_boss_graul", 1 },
          { "world_boss_graul", 2 },
        },
        {
          { "world_boss_voritor", 1 },
          { "world_boss_voritor_drone", 5 }
        },
        {
          { "world_boss_quenker", 1 },
          { "world_boss_quenker_drone", 5 }
        },
        {
          { "world_boss_jedi", 1 },
          { "world_boss_jedi_drone", 1 }
        }
      },
      { 
        {{ x = -141, z = 10, y = -484 }, " tormenting Kunga's near their stronghold."},
        {{ x = -640, z = 23, y = -4704 }, " south of the Warren."}
      }
    },
    { "dathomir", 
      { 
        {
          { "world_boss_rancor", 1 },
          { "world_boss_rancor_drone", 15 }
        },
        {
          { "world_boss_nightsister", 1 },
          { "world_boss_nightsister_drone", 5 }
        },
        {
          { "world_boss_jedi", 1 },
          { "world_boss_jedi_drone", 1 }
        },
        {
          { "world_boss_singing_mountain_clan", 1 },
          { "world_boss_singing_mountain_clan_drone", 5 }
        },
      },
      { 
        {{ x = -141, z = 10, y = -484 }, " north of the Singing Mountain Clan, along the beach."},
        {{ x = -640, z = 23, y = -4704 }, " east of the Dathomir Tarpits."},
        {{ x = -6048, z = 125, y = -32 }, " south of the Dathomir Imperial Prison."}
      }
    },
    { "endor", 
      { 
        {
          { "blurrg", 1 },
        },
        {
          { "world_boss_death_watch", 1 },
          { "world_boss_death_watch_drone", 10 }
        },
        {
          { "world_boss_arachne", 1 },
          { "world_boss_arachne_warrior", 3 },
          { "world_boss_arachne_drone", 12 }
        }
      },
      { 
        {{ x = -4409, z = 22, y = 4284 }, " in close proximity of the Death Watch Bunker."},
        {{ x = 3552, z = 9, y = 3552 }, " east of the Korga cave."},
        {{ x = 1000, z = 31, y = -800 }, " between the Endorian outposts."}
      }
    },
    { "lok", 
      { 
        {
          { "world_boss_kimo", 1 },
          { "world_boss_kimo_drone", 2 }
        },
        {
          { "world_boss_jedi", 1 },
          { "world_boss_jedi_drone", 1 }
        },
      },
      { 
        {{ x = 2470, z = 18, y = -4217 }, " at the foot of Adi's Rest."},
        {{ x = -2253, z = 11, y = -3070 }, " preparing to seige the Lokian Imperial Outpost."}
      }
    },
    { "naboo", 
      { 
        { 
          { "world_boss_sbd", 1 },
          { "world_boss_sbd", 2 },
          { "world_boss_bd", 15 }
        },
        {
          { "world_boss_jedi", 1 },
          { "world_boss_jedi_drone", 1 }
        },
      },
      { 
        {{ x = -5331, z = 11, y = 3498 }, " south of Theed"},
        {{ x = -2080, z = 61, y = -5157 }, " stalking Mordran"}
      }
    },
    { "talus", 
      { 
        {
          { "world_boss_gsp", 1 },
          { "world_boss_gsp_drone", 10 }
        },
        {
          { "world_boss_jedi", 1 },
          { "world_boss_jedi_drone", 1 }
        },
      },
      { 
        {{ x = 4307, z = 6, y = 1015 }, " seeking refuge in the Lost Village of Durbin."},
        {{ x = 395, z = 44, y = -821 }, " west of the Giant Fynock Cave."}
      }
    },
    { "tatooine", 
      { 
        {
          { "world_boss_krayt", 1 },
          { "world_boss_krayt_drone", 2 }
        },
        {
          { "world_boss_jedi", 1 },
          { "world_boss_jedi_drone", 1 }
        },
        {
          { "world_boss_jabba_overlord", 1 },
          { "world_boss_jabba_henchman", 20 }
        }
      },
      {
        {{ x = -5870, z = 32, y = -5178 }, " north of Jabba's Palace."},
        {{ x = 5376, z = 34, y = 2400 }, " east of Mos Taike."},
        {{ x = -5456, z = 39, y = 6320 }, " west of Fort Tusken"},
        {{ x = 1954, z = 0, y = -4879 }, " between Mos Eisley and Anchorhead."}
      }
    },
    { "yavin4", 
      { 
        {
          { "world_boss_jedi", 1 },
          { "world_boss_jedi_drone", 1 }
        },
        {
          { "world_boss_death_watch", 1 },
          { "world_boss_death_watch_drone", 15 }
        }
      },
      { 
        {{ x = 4763, z = 98, y = 5248 }, " south-west of Exar Kun's Temple."},
        {{ x = 5854, z = 661, y = -4383 }, " north-east of the Yavinian Imperial Outpost."}
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
  local templates = selection[2][getRandomNumber(1, #selection[2])]

  local roll = getRandomNumber(1, 100)

  if (roll > 90) then
    templates = self.specialSpawns[getRandomNumber(1, #self.specialSpawns)]
  end

  local location = selection[3][getRandomNumber(1, #selection[3])]
  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)

  local coords = location[1]
  local suffixMessage = location[2]

  local message = "Locals have reported sightings of dangerous creatures" .. suffixMessage


  for i = 1, #templates, 1 do
    local template = templates[i][1]
    local numToSpawn = templates[i][2]

    for j = 1, numToSpawn, 1 do
      local pMobile = spawnMobile(planet, template, 0, coords.x + getRandomNumber(1, 5), coords.z, coords.y + getRandomNumber(1, 5), 0, 0)

      if (pMobile ~= nil) then
        self:log("WorldBossesScreenPlay: spawned " .. template .. " on " .. planet .. " at " .. coords.x .. ", " .. coords.y .. ".")
        if (i == 1) then
          createObserver(OBJECTDESTRUCTION, "WorldBossesScreenPlay", "bossKilled", pMobile)
        end
      else 
        self:log("WorldBossesScreenPlay: ERROR spawning: " .. template .. " on " .. planet .. " at " .. coords.x .. ", " .. coords.y .. ".")
      end
    end
  end
  writeScreenPlayData(pAdminPlayer, "WorldBossesScreenPlay", "huntLocation", message)
  broadcastToGalaxy(nullptr, message)
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
      self:log("WorldBossesScreenPlay: " .. CreatureObject(pPlayer):getFirstName() .. " received world boss loot.")

      if pInventory == nil then
        self:log("Error locating target inventory\n")
        return nil
      end

      createLoot(pInventory, "world_boss", 350, true)

      CreatureObject(pPlayer):sendSystemMessage("You have received a loot item!")
    end
  end

  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)
  createEvent(self.respawnFrequency, "WorldBossesScreenPlay", "respawnBoss", nil, "")
  deleteScreenPlayData(pAdminPlayer, "WorldBossesScreenPlay", "huntLocation")
  return 1
end

function WorldBossesScreenPlay:log(message)
  local outputFile = "log/world_bosses.log"
  logToFile(message, outputFile)
end
