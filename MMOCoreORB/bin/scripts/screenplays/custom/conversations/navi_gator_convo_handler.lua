local QuestManager = require("managers.quest.quest_manager")

naviGatorConvoHandler = conv_handler:new {}

function naviGatorConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  if (CreatureObject(pPlayer):hasScreenPlayState(1, "navi_gator")) then
    return convoTemplate:getScreen("first_screen_has_met")
  end
  return convoTemplate:getScreen("first_screen_not_met")
end

function naviGatorConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

  local pGhost = CreatureObject(pPlayer):getPlayerObject()

  local playerCredits = CreatureObject(pPlayer):getCashCredits()

if (screenID == "first_screen_not_met" or screenID == "first_screen_has_met") then
  if (not CreatureObject(pPlayer):hasScreenPlayState(1, "navi_gator")) then
    CreatureObject(pPlayer):setScreenPlayState(1, "navi_gator")
  end
  
  if (playerCredits < 1001) then
    clonedConversation:addOption("I don't have many credits", "no_credits")
  end
  
  if (playerCredits > 999) then
    clonedConversation:addOption("1k - Coronet", "coronet")
    clonedConversation:addOption("1k - Mos Eisley", "mos_eisley")
    clonedConversation:addOption("1k - Theed", "theed")
  end

  if (playerCredits > 4999) then
    clonedConversation:addOption("5k - Jabba's Palace", "jabba")
  end
  
  if (playerCredits > 9999) then
    clonedConversation:addOption("10k - Death Watch Bunker", "dwb")
    clonedConversation:addOption("10k - Geo Cave", "geo")
    clonedConversation:addOption("10k - Nightsister Stronghold", "ns_stronghold")
    clonedConversation:addOption("10k - Krayt Graveyard", "krayt")
    clonedConversation:addOption("10k - Fort Tusken", "fort_tusken")
    clonedConversation:addOption("10k - Janta Stronghold", "janta_cave")
  end

  
  if (playerCredits > 9999 and QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests.LOOT_DATAPAD_2)) then
    clonedConversation:addOption("10k - Jedi Village", "village")
  end

  if (playerCredits > 9999 and PlayerObject(pGhost):isJedi()) then
    clonedConversation:addOption("10k - Light Jedi Enclave", "lje")
    clonedConversation:addOption("10k - Dark Jedi Enclave", "dje")
  end
      
  elseif (screenID == "coronet_go") then
    CreatureObject(pPlayer):subtractCashCredits(1000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 1000 credits.")
    SceneObject(pPlayer):switchZone("corellia", -138, 28, -4723, 0)
  elseif (screenID == "mos_eisley_go") then
    CreatureObject(pPlayer):subtractCashCredits(1000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 1000 credits.")
    SceneObject(pPlayer):switchZone("tatooine", 3528, 5, -4802, 0)
  elseif (screenID == "theed_go") then
    CreatureObject(pPlayer):subtractCashCredits(1000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 1000 credits.")
    SceneObject(pPlayer):switchZone("naboo", -4874, 6, 4146, 0)
  elseif (screenID == "jabba_go") then
    CreatureObject(pPlayer):subtractCashCredits(5000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 5000 credits.")
    SceneObject(pPlayer):switchZone("tatooine", -5860, 90, -6196, 0)
  elseif (screenID == "fort_tusken_go") then
    CreatureObject(pPlayer):subtractCashCredits(10000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 10000 credits.")
    SceneObject(pPlayer):switchZone("tatooine", -3984, 10, 6435, 0)
  elseif (screenID == "janta_cave_go") then
    CreatureObject(pPlayer):subtractCashCredits(10000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 10000 credits.")
    SceneObject(pPlayer):switchZone("dantooine", 6974, 10, -4116, 0)
  elseif (screenID == "krayt_go") then
    CreatureObject(pPlayer):subtractCashCredits(10000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 10000 credits.")
    SceneObject(pPlayer):switchZone("tatooine", 6324, 43, 4091, 0)
  elseif (screenID == "dwb_go") then
    CreatureObject(pPlayer):subtractCashCredits(10000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 10000 credits.")
    SceneObject(pPlayer):switchZone("endor", -4657, 14.4, 4322.3, 0)
  elseif (screenID == "geo_go") then
    CreatureObject(pPlayer):subtractCashCredits(10000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 10000 credits.")
    SceneObject(pPlayer):switchZone("yavin4", -6488, 83, -417, 0)
  elseif (screenID == "ns_stronghold_go") then
    CreatureObject(pPlayer):subtractCashCredits(10000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 10000 credits.")
    SceneObject(pPlayer):switchZone("dathomir", -3922, 125, -32, 0)
  elseif (screenID == "village_go") then
    CreatureObject(pPlayer):subtractCashCredits(10000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 10000 credits.")
    SceneObject(pPlayer):switchZone("dathomir", 5296, 78, -4155, 0)
  elseif (screenID == "lje_go") then
    CreatureObject(pPlayer):subtractCashCredits(10000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 10000 credits.")
    SceneObject(pPlayer):switchZone("yavin4", -5575, 100, 4901, 0)
  elseif (screenID == "dje_go") then
    CreatureObject(pPlayer):subtractCashCredits(10000)
    CreatureObject(pPlayer):sendSystemMessage("You pay Gator 10000 credits.")
    SceneObject(pPlayer):switchZone("yavin4", 5080, 100, 306, 0)
  end

  return pConvScreen
end

