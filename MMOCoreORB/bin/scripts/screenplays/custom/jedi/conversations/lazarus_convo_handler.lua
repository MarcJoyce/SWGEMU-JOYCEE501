local ObjectManager = require("managers.object.object_manager")

lazarusConvoHandler = conv_handler:new {}

function lazarusConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

  if (not CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_6")) then
    return convoTemplate:getScreen("fail")
  elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "lazarus")) then
    return convoTemplate:getScreen("success")
  else 
    return convoTemplate:getScreen("first_screen")
  end
end

function lazarusConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local playerID = CreatureObject(pPlayer):getObjectID()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pConvScreen
	end

  local fullName = SceneObject(pPlayer):getDisplayedName()

  if (screenID == "success") then
    if (not CreatureObject(pPlayer):hasScreenPlayState(2, "lazarus")) then
      CreatureObject(pPlayer):setScreenPlayState(2, "lazarus")
      local decipherQuestsCompleted = tonumber(readScreenPlayData(pPlayer, "DecipherQuest", "trialsCompleted")) or 0  
      writeScreenPlayData(pPlayer, "DecipherQuest", "trialsCompleted", decipherQuestsCompleted + 1)
    end
  elseif (screenID == "question_one") then
    clonedConversation:addOption("@conversation/custom_string:lazarus_question_one_response_one", "fail")
    clonedConversation:addOption("@conversation/custom_string:lazarus_question_one_response_two", "fail")
    clonedConversation:addOption(fullName, "question_two")
  elseif (screenID == "fail") then
    for i = 1, 2, 1 do
      local zoneName = CreatureObject(pPlayer):getZoneName()
      local xLoc = SceneObject(pPlayer):getWorldPositionX() + (-10 + getRandomNumber(20))
      local yLoc = SceneObject(pPlayer):getWorldPositionY() + (-10 + getRandomNumber(20))
      local zLoc = getTerrainHeight(pPlayer, xLoc, yLoc)

      local pMobile = spawnMobile(zoneName, "lazarus_monster", 0, xLoc, zLoc, yLoc, 0, 0)

      if (pMobile ~= nil) then
        AiAgent(pMobile):setDefender(pPlayer)
      end
    end
  end
  return pConvScreen
end