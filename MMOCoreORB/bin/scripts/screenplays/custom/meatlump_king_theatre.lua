local ObjectManager = require("managers.object.object_manager")
local QuestManager = require("managers.quest.quest_manager")
local SpawnMobiles = require("utils.spawn_mobiles")
require("utils.helpers")

MeatlumpKingTheatre = GoToTheater:new {
	-- Task properties
	taskName = "MeatlumpKingTheatre",
	-- GoToTheater properties
  planet = { "corellia", "talus", "tatooine", "rori", "naboo", "lok", "dantooine" },
	minimumDistance = 0,
	maximumDistance = 11000,
	theater = {
		{ template = "object/tangible/furniture/all/frn_all_light_lamp_table_s03.iff", xDiff = 0.52, zDiff = 1.14, yDiff = -3.37, heading = 0 },
		{ template = "object/tangible/camp/camp_crate_s1.iff", xDiff = -3.78, zDiff = 0, yDiff = 0.91, heading = -18.91 },
		{ template = "object/weapon/ranged/pistol/pistol_dl44_metal.iff", xDiff = 0.13, zDiff = 1.17, yDiff = -2.9, heading = -9.74 },
		{ template = "object/tangible/camp/camp_crate_s1.iff", xDiff = 1.74, zDiff = 0, yDiff = -2.84, heading = -80.214 },
		{ template = "object/static/structure/general/camp_lawn_chair_s01.iff", xDiff = 3.74, zDiff = 0, yDiff = 2.42, heading = -47.74 },
		{ template = "object/static/structure/general/camp_lawn_chair_s01.iff", xDiff = 2.04, zDiff = 0, yDiff = 1.55, heading = 0.39 },
		{ template = "object/static/structure/general/camp_lawn_chair_s01.iff", xDiff = -0.26, zDiff = 0, yDiff = 5.28, heading = 111.15 },
		{ template = "object/static/structure/general/campfire_fresh.iff", xDiff = 2.30, zDiff = 0, yDiff = 4.01, heading = 0 },
		{ template = "object/static/structure/general/camp_spit_s01.iff", xDiff = 1.72, zDiff = 0, yDiff = 3.92, heading = 83.59 },
		{ template = "object/static/structure/general/camp_spit_s01.iff", xDiff = 2.76, zDiff = 0, yDiff = 4.21, heading = 63.79 },
		{ template = "object/static/structure/general/camp_spit_s01.iff", xDiff = 2.33, zDiff = 0, yDiff = 3.3, heading = -24.13 },
		{ template = "object/static/structure/general/trash_pile_s01.iff", xDiff = -3.48, zDiff = 0, yDiff = 2.61, heading = -120.3 },
		{ template = "object/static/structure/tatooine/debris_tatt_crate_1.iff", xDiff = 1.78, zDiff = 0, yDiff = -2.7, heading = 7.45 },
		{ template = "object/static/structure/tatooine/debris_tatt_drum_dented_1.iff", xDiff = 1.61, zDiff = 0, yDiff = -3.92, heading = -82.51 },
		{ template = "object/static/structure/tatooine/debris_tatt_crate_metal_1.iff", xDiff = -2.18, zDiff = 0, yDiff = 1.27, heading = -12.03 },
		{ template = "object/static/structure/general/camp_cot_s01.iff", xDiff = -1.2, zDiff = 0, yDiff = -4.84, heading = -20.05 },
		{ template = "object/static/structure/tatooine/tent_house_tatooine_style_01.iff", xDiff = -2.46, zDiff = 0, yDiff = -2.15, heading = -140.38 },
		{ template = "object/static/structure/tatooine/debris_tatt_drum_dented_1.iff", xDiff = 0.32, zDiff = 0, yDiff = -3.04, heading = 9.74 },
		{ template = "object/static/structure/general/trash_pile_s01.iff", xDiff = -3.64, zDiff = 0, yDiff = 2.997, heading = 156.99 },
		{ template = "object/static/structure/tatooine/debris_tatt_crate_1.iff", xDiff = -2.3, zDiff = 0, yDiff = 1.28, heading = -110.58 },
		{ template = "object/static/structure/general/camp_cot_s01.iff", xDiff = -4.51, zDiff = 0, yDiff = -4.41, heading = 39.53 },
		{ template = "object/static/structure/general/camp_cot_s01.iff", xDiff = -5.42, zDiff = 0, yDiff = -1.45, heading = 99.69 },
		{ template = "object/static/structure/tatooine/debris_tatt_crate_metal_1.iff", xDiff = 1.92, zDiff = 0, yDiff = -1.88, heading = -12.03 },
		{ template = "object/static/item/item_container_organic_food.iff", xDiff = -3.13, zDiff = 0, yDiff = 1.086, heading = 137.69 },
	},
  waypointDescription = "Meatlump King camp",
	mobileList = {
		{ template = "meatlump_king", minimumDistance = 3, maximumDistance = 6, referencePoint = 0 }
	},
	activeAreaRadius = 64,
	flattenLayer = true
}

function MeatlumpKingTheatre:log(message) 
  local outputFile = "log/" .. self.taskName .. ".log"
  logToFile(message, outputFile)
end

function MeatlumpKingTheatre:onTheaterCreated(pPlayer)

end

function MeatlumpKingTheatre:onObjectsSpawned(pPlayer, spawnedMobilesList)
	if (pPlayer == nil or spawnedMobilesList == nil or not SpawnMobiles.isValidMobile(spawnedMobilesList[1])) then
		return
	end

  createObserver(DAMAGERECEIVED, self.taskName, "onMeatlumpKingDamage90", spawnedMobilesList[1])
  createObserver(OBJECTDESTRUCTION, self.taskName, "notifyOnKingKilled", spawnedMobilesList[1])
end

function MeatlumpKingTheatre:notifyOnKingKilled(pMobile)
  if (pMobile == nil) then
    return
  end

  local playerTable = SceneObject(pMobile):getPlayersInRange(120)

  for i = 1, #playerTable, 1 do
    local pPlayer = playerTable[i]

    if (pPlayer ~= nil) then
      local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
      self:log(self.taskName .. ": " .. CreatureObject(pPlayer):getFirstName() .. " received meatlump king theatre loot.")

      if pInventory == nil then
        self:log("Error locating target inventory\n")
        return nil
      end

      createLoot(pInventory, "meatlump_king", 350, true)

      CreatureObject(pPlayer):sendSystemMessage("You have received a loot item!")
    end
  end

  rescheduleServerEvent("meatlump_theatre_finish", getRandomNumber(1800, 5400) * 1000)

  return 0
end

function MeatlumpKingTheatre:damageTaken(pNpc, damageThreshold)
  if ((CreatureObject(pNpc):getHAM(0) <= (CreatureObject(pNpc):getMaxHAM(0) * (damageThreshold / 100))) or (CreatureObject(pNpc):getHAM(3) <= (CreatureObject(pNpc):getMaxHAM(3) * (damageThreshold / 100))) or (CreatureObject(pNpc):getHAM(6) <= (CreatureObject(pNpc):getMaxHAM(6) * (damageThreshold / 100)))) then
    return true
  else
    return false
  end
end

function MeatlumpKingTheatre:getPlayersInRange(pNpc)
  local playerTable = SceneObject(pNpc):getPlayersInRange(120)

  return #playerTable
end

function MeatlumpKingTheatre:getHelp(pNpc, num, template, pAttacker)

  local numberOfPlayers = self:getPlayersInRange(pNpc)
  local numToSpawn = math.max(num * numberOfPlayers, num * 5)

  for i = 1, numToSpawn do
          local zoneName = CreatureObject(pNpc):getZoneName()
      local xLoc = SceneObject(pNpc):getWorldPositionX() + (-20 + getRandomNumber(30))
      local yLoc = SceneObject(pNpc):getWorldPositionY() + (-20 + getRandomNumber(30))
      local zLoc = getTerrainHeight(pNpc, xLoc, yLoc)

      local pMobile = spawnMobile(zoneName, template, 0, xLoc, zLoc, yLoc, 0, 0)

      if (pMobile ~= nil) then
        AiAgent(pMobile):setDefender(pAttacker)
      end
  end
end

function MeatlumpKingTheatre:onMeatlumpKingDamage90(pMeatlumpKing, pAttacker, damage)
  if pMeatlumpKing == nil then return 1 end

  if self:damageTaken(pMeatlumpKing, 90) then
    dropObserver(DAMAGERECEIVED, self.taskName, "onMeatlumpKingDamage90", pMeatlumpKing)

    self:getHelp(pMeatlumpKing, getRandomNumber(2), "meatlump_king_buffoon", pAttacker)
    self:getHelp(pMeatlumpKing, getRandomNumber(2), "meatlump_king_loon", pAttacker)
    spatialChat(pMeatlumpKing, "The Meatlump King always triumphs! Have at you! Come on then.")

    createObserver(DAMAGERECEIVED, self.taskName, "onMeatlumpKingDamage75", pMeatlumpKing)
    return 1
  else
      return 0
  end
end

function MeatlumpKingTheatre:onMeatlumpKingDamage75(pMeatlumpKing, pAttacker, damage)
  if pMeatlumpKing == nil then
		return 1
	end

  if (self:damageTaken(pMeatlumpKing, 75)) then

    dropObserver(DAMAGERECEIVED, self.taskName, "onMeatlumpKingDamage75", pMeatlumpKing)

    self:getHelp(pMeatlumpKing, getRandomNumber(2), "meatlump_king_fool", pAttacker)
    spatialChat(pMeatlumpKing, "Tis but a scratch!")
      self:healTenPercent(pMeatlumpKing)

    createObserver(DAMAGERECEIVED, self.taskName, "onMeatlumpKingDamage50", pMeatlumpKing)
    return 1
  else
      return 0
  end
end

function MeatlumpKingTheatre:onMeatlumpKingDamage50(pMeatlumpKing, pAttacker, damage)
  if pMeatlumpKing == nil then
		return 1
	end

  if (self:damageTaken(pMeatlumpKing, 50)) then

    dropObserver(DAMAGERECEIVED, self.taskName, "onMeatlumpKingDamage50", pMeatlumpKing)

    self:getHelp(pMeatlumpKing, getRandomNumber(2), "meatlump_king_stooge", pAttacker)
    spatialChat(pMeatlumpKing, "I've had worse!")
    self:healTenPercent(pMeatlumpKing)

    createObserver(DAMAGERECEIVED, self.taskName, "onMeatlumpKingDamage33", pMeatlumpKing)
    return 1
  else
      return 0
  end
end

function MeatlumpKingTheatre:onMeatlumpKingDamage33(pMeatlumpKing, pAttacker, damage)
  if pMeatlumpKing == nil then
		return 1
	end

  if (self:damageTaken(pMeatlumpKing, 33)) then

    dropObserver(DAMAGERECEIVED, self.taskName, "onMeatlumpKingDamage33", pMeatlumpKing)

    self:getHelp(pMeatlumpKing, 1, "meatlump_king_clod", pAttacker)
    spatialChat(pMeatlumpKing, "I'm invincible!")
    self:healTenPercent(pMeatlumpKing)

    createObserver(DAMAGERECEIVED, self.taskName, "onMeatlumpKingDamage25", pMeatlumpKing)
    return 1
  else
      return 0
  end
end

function MeatlumpKingTheatre:onMeatlumpKingDamage25(pMeatlumpKing, pAttacker, damage)
  if pMeatlumpKing == nil then
		return 1
	end

  if (self:damageTaken(pMeatlumpKing, 25)) then

    dropObserver(DAMAGERECEIVED, self.taskName, "onMeatlumpKingDamage25", pMeatlumpKing)

    self:getHelp(pMeatlumpKing, 1, "meatlump_king_oaf", pAttacker)
    spatialChat(pMeatlumpKing, "All right, we'll call it a draw!")
    self:healTenPercent(pMeatlumpKing)

    createObserver(DAMAGERECEIVED, self.taskName, "onMeatlumpKingDamage10", pMeatlumpKing)
    return 1
  else
    return 0
  end
end

function MeatlumpKingTheatre:onMeatlumpKingDamage10(pMeatlumpKing, pAttacker, damage)
  if pMeatlumpKing == nil then
		return 1
	end

  if (self:damageTaken(pMeatlumpKing, 10)) then

    dropObserver(DAMAGERECEIVED, self.taskName, "onMeatlumpKingDamage10", pMeatlumpKing)

    self:getHelp(pMeatlumpKing, 1, "meatlump_king_cretin", pAttacker)
    spatialChat(pMeatlumpKing, "Running away eh? Come back here and take what's coming to you! I'll bite your legs off!")
    self:finalHeal(pMeatlumpKing)
    return 1
  else
    return 0
  end
end

function MeatlumpKingTheatre:finalHeal(pObj)
	if (pObj == nil) then
		return
	end

	SceneObject(pObj):playEffect("clienteffect/healing_healdamage.cef", "")

	if (SceneObject(pObj):isCreatureObject()) then
		for i = 0, 6, 3 do
			local toHeal = CreatureObject(pObj):getMaxHAM(i) * 0.5;
      local currentHAM = CreatureObject(pObj):getHAM(i);
			CreatureObject(pObj):setHAM(i, math.min(CreatureObject(pObj):getMaxHAM(i), currentHAM + toHeal));
		end
	end
end

function MeatlumpKingTheatre:healTenPercent(pObj)
	if (pObj == nil) then
		return
	end

	SceneObject(pObj):playEffect("clienteffect/healing_healdamage.cef", "")

	if (SceneObject(pObj):isCreatureObject()) then
		for i = 0, 6, 3 do
			local toHeal = CreatureObject(pObj):getMaxHAM(i) * 0.1;
      local currentHAM = CreatureObject(pObj):getHAM(i);
      local newHAM = currentHAM + toHeal;
			CreatureObject(pObj):setHAM(i, newHAM);
		end
	end
end

function MeatlumpKingTheatre:finishUpTask()
  local pPlayer = getCreatureObject(281474993547517)
  self:finish(pPlayer)
  createEvent(10000, "MeatlumpKingScreenPlay", "respawn", pPlayer, "")
end

return MeatlumpKingTheatre
