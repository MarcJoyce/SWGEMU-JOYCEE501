local ObjectManager = require("managers.object.object_manager")
local Logger = require("utils.logger")

CustomGlowingScreenPlay = ScreenPlay:new {}

-- Trial one - Pieces of eight
--  1 - Jawa Trader (Klik Klak) x 
--  2 - Jedi Temple (Brian Cohen) x
--  3 - Fort Tusken ("object/tangible/container/loot/placable_loot_crate_trashpile.iff") x 
--  4 - Anchorhead (Han Solo) x
--  5 - Nyms Stronghold x
--  6 - Jabbas Palace x
--  7 - Thalos Krenn (Jedi Sympathizer) x 
--  8 - Lars Homestead ("object/tangible/container/loot/placable_loot_crate_skeleton_human.iff") x 
-- Trial two - Combat Profession x
-- Trial three - Kill Vessa Kael 
-- Trial four - Support Profession x
-- Trial five - Cozmic (Rodian) vs Sap (Trando) War between Wookiees and Trandoshans
-- Trial six - Mega Riddle
-- Trial seven - Jedi and Sith Holocron
-- Trial eight - Surrender all Skills

registerScreenPlay("CustomGlowingScreenPlay", true)

function CustomGlowingScreenPlay:start()
  if (isZoneEnabled("dantooine")) then
    self:spawnMobilesDantooine()
  end

  if (isZoneEnabled("tatooine")) then
    self:spawnMobilesTatooine()
  end

  if (isZoneEnabled("naboo")) then
    self:spawnMobilesNaboo()
  end

  if (isZoneEnabled("lok")) then
    self:spawnMobilesLok()
  end
end

function CustomGlowingScreenPlay:playerLoggedIn(pPlayer)
  if (CreatureObject(pPlayer):hasScreenPlayState(1, "tusken_queen_head") and not CreatureObject(pPlayer):hasScreenPlayState(2, "tusken_queen_head")) then
    dropObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceOne", pPlayer)
    createObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceOne", pPlayer)
  end
  
  if (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_1") and not CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_two")) then
    dropObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceTwo", pPlayer);
    createObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceTwo", pPlayer);
  end

  if (CreatureObject(pPlayer):hasScreenPlayState(1, "krayt_dragon") and not CreatureObject(pPlayer):hasScreenPlayState(2, "krayt_dragon")) then
    dropObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceSix", pPlayer)
    createObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceSix", pPlayer)
  end

  if (CreatureObject(pPlayer):hasScreenPlayState(1, "nym_trial") and not CreatureObject(pPlayer):hasScreenPlayState(2, "nym_trial")) then
    dropObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceFive", pPlayer)
    createObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceFive", pPlayer)
  end

end

function CustomGlowingScreenPlay:spawnMobilesDantooine()
  -- Piece of eight two - Dantooine Jedi Temple
  local pMobile = spawnMobile("dantooine", "brian_cohen", 300, 4195, 9, 5203, 23.8, 0)

  AiAgent(pMobile):addObjectFlag(AI_STATIC)
end

function CustomGlowingScreenPlay:spawnMobilesTatooine()
  -- Piece of eight one - Klik Klik
  spawnMobile("tatooine", "klik_klak", 300, -6184.270, 7.253, 1852.560, 154.785, 0)
  -- Piece of eight one - Tusken Queen
  spawnMobile("tatooine", "tusken_queen", 300, -4.7, 37.9, -3.3, 92, 1189188)

  -- Piece of eight six - Jabba's Palace
  spawnMobile("tatooine", "jabba_henchman_custom", 300, -14.6, 2, 40.9, 49.6179, 1177487)

  -- Piece of eight four - Anchorhead
  self:arrangePieceFour()

  -- Piece of eight three - Fort Tusken
  local spawnedSceneObject = LuaSceneObject(nil)
  local spawnedPointer = spawnSceneObject("tatooine", "object/tangible/container/loot/placable_loot_crate_trashpile.iff", -8.3, 37.9, -31.8, 1189186, 89.617);

  if (spawnedPointer ~= nil) then
    spawnedSceneObject:_setObject(spawnedPointer)
    SceneObject(spawnedPointer):setContainerInheritPermissionsFromParent(false)
	  SceneObject(spawnedPointer):setContainerDefaultDenyPermission(MOVEIN)
	  SceneObject(spawnedPointer):setContainerDefaultAllowPermission(OPEN + MOVEOUT)
    createObserver(OPENCONTAINER, "CustomGlowingScreenPlay", "boxLootedTrialOnePieceThree", spawnedPointer)
  end

-- Piece of eight eight - Lars Homestead
  spawnedPointer = spawnSceneObject("tatooine", "object/tangible/container/loot/placable_loot_crate_skeleton_human.iff", -2582.22, 0, -5513.91, 0, 43.63);

  if (spawnedPointer ~= nil) then
    spawnedSceneObject:_setObject(spawnedPointer)
    SceneObject(spawnedPointer):setContainerInheritPermissionsFromParent(false)
	  SceneObject(spawnedPointer):setContainerDefaultDenyPermission(MOVEIN)
	  SceneObject(spawnedPointer):setContainerDefaultAllowPermission(OPEN + MOVEOUT)
    createObserver(OPENCONTAINER, "CustomGlowingScreenPlay", "boxLootedTrialOnePieceEight", spawnedPointer)
  end

end

function CustomGlowingScreenPlay:spawnMobilesNaboo()
  -- Piece of eight seven - Jedi Sympathiser
  spawnMobile("naboo", "thalos_krenn", 300, -5472.9, 14.0, 4462.0, 270.025, 0)
end

function CustomGlowingScreenPlay:spawnMobilesLok()
  spawnMobile("lok", "imp_trooper", 300, 519, 12, 4858, 267, 0)
  spawnMobile("lok", "imp_commander", 300, 519, 12, 4857, 249, 0)
  spawnMobile("lok", "imp_trooper", 300, 519, 12, 4856, 285, 0)
  spawnMobile("lok", "reb_trooper", 300, 428, 12, 4857, 98, 0)
  spawnMobile("lok", "reb_commander", 300, 428, 12, 4856, 80, 0)
  spawnMobile("lok", "reb_trooper", 300, 428, 12, 4855, 116, 0)
  spawnMobile("lok", "jabba_trooper", 300, 476, 12, 4884, 180, 0)
  spawnMobile("lok", "jabba_commander", 300, 477, 12, 4884, 180, 0)
  spawnMobile("lok", "jabba_trooper", 300, 478, 12, 4884, 180, 0)
end

function CustomGlowingScreenPlay:arrangePieceFour()
  -- Spawn mobiles
  spawnMobile("tatooine", "han_solo_glowing", 300, 49.2, 52, -5351, 350, 0)
  spawnMobile("tatooine", "chewbacca_glowing", 300, -181.67, 5.09, -5145.77, 190.029, 0)

  spawnSceneObject("tatooine", "object/static/vehicle/static_lambda_shuttle.iff", -187, 5, -5134, 0, math.rad(180));
  local pActiveArea = spawnActiveArea("tatooine", "object/active_area.iff", -187, 5, -5134, 40, 0)

  if (pActiveArea ~= nil) then
      createObserver(ENTEREDAREA, "CustomGlowingScreenPlay", "notifyEnteredArea", pActiveArea);
  end
end

function CustomGlowingScreenPlay:notifyEnteredArea(pActiveArea, pPlayer)
  if (not SceneObject(pPlayer):isPlayerCreature()) then
    return 0
  end

  if (CreatureObject(pPlayer):hasScreenPlayState(1, "han_solo_glowing")) then
    CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\<Communicator>  \\#FFFFFF\\Ok Kid, looks like she's all in one piece, head on back.")
    CreatureObject(pPlayer):removeScreenPlayState(1, "han_solo_glowing")
    CreatureObject(pPlayer):setScreenPlayState(2, "han_solo_glowing")
    return 0
  end
  return 0
end

function CustomGlowingScreenPlay:boxLootedTrialOnePieceThree(pSceneObject, pPlayer)
  if (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_1") and not CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_three")) then
    CreatureObject(pPlayer):setScreenPlayState(1, "piece_of_eight_three")
    CreatureObject(pPlayer):sendSystemMessage("At the bottom of the container you find a piece of the orb.");
  end
end

function CustomGlowingScreenPlay:boxLootedTrialOnePieceEight(pSceneObject, pPlayer)
  if (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_1") and not CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_eight")) then
    CreatureObject(pPlayer):setScreenPlayState(1, "piece_of_eight_eight")
    CreatureObject(pPlayer):sendSystemMessage("In amongst the remains, you find a piece of the orb.");
  end
end

function CustomGlowingScreenPlay:notifyKilledCreatureTrialOnePieceOne(pPlayer, pVictim)
	if (pVictim == nil) then
		return 0
	end

	if (pPlayer == nil) then
		return 1
	end

	local victimName = SceneObject(pVictim):getCustomObjectName()
	local playerID = SceneObject(pPlayer):getObjectID()

  if (victimName == "Tusken Queen") then
    CreatureObject(pPlayer):setScreenPlayState(2, "tusken_queen_head");
    CreatureObject(pPlayer):sendSystemMessage("You have killed the Tusken Queen and taken her head. You should return to Klik Klak for your reward!");

    dropObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceOne", pPlayer)
  end


	return 0
end

function CustomGlowingScreenPlay:notifyKilledCreatureTrialOnePieceTwo(pPlayer, pVictim)
	if (pVictim == nil) then
		return 0
	end

	if (pPlayer == nil) then
		return 1
	end

	local victimName = SceneObject(pVictim):getCustomObjectName()
	local playerID = SceneObject(pPlayer):getObjectID()

  if (victimName == "Brian Cohen") then
    CreatureObject(pPlayer):setScreenPlayState(1, "piece_of_eight_two")
    CreatureObject(pPlayer):sendSystemMessage("Searching through the remains, you find a piece of the orb.");

    dropObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceTwo", pPlayer);
  end

	return 0
end

function CustomGlowingScreenPlay:notifyKilledCreatureTrialOnePieceSix(pPlayer, pVictim)
	if (pVictim == nil) then
		return 0
	end

	if (pPlayer == nil) then
		return 1
	end

	local victimName = SceneObject(pVictim):getCustomObjectName()
	local playerID = SceneObject(pPlayer):getObjectID()

  if (victimName == "Elder Krayt Dragon") then
    CreatureObject(pPlayer):setScreenPlayState(2, "krayt_dragon")
    CreatureObject(pPlayer):sendSystemMessage("You have slain the Elder Krayt Dragon and should return to Jabbas Palace to collect your reward")
    dropObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceSix", pPlayer);
  end

	return 0
end

function CustomGlowingScreenPlay:notifyKilledCreatureTrialOnePieceFive(pPlayer, pVictim)
  printf("notifyKilledCreatureTrialOnePieceFive function called")
	if (pVictim == nil) then
    printf("pVictim is nil")
		return 0
	end

	if (pPlayer == nil) then
    printf("pPlayer is nil")
		return 1
	end

	local victimName = SceneObject(pVictim):getObjectName()
	local playerID = SceneObject(pPlayer):getObjectID()

  printf("Victim name is " .. victimName .. "\n")

  if (victimName == "gorax") then
    CreatureObject(pPlayer):setScreenPlayState(2, "nym_trial")
    CreatureObject(pPlayer):removeScreenPlayState(1, "nym_trial")
    CreatureObject(pPlayer):sendSystemMessage("You have slain the Gorax and should return to Nym to collect your reward")
    dropObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceFive", pPlayer);
  end

	return 0
end