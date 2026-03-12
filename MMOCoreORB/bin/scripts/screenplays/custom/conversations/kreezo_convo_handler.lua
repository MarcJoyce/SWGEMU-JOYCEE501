local QuestManager = require("managers.quest.quest_manager")

kreezoConvoHandler = conv_handler:new {}

function kreezoConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local accountID = 0
	local pAdminPlayer = getCreatureObject(281474993547517)

  return convoTemplate:getScreen("hello")
end

function kreezoConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	local pAdminPlayer = getCreatureObject(281474993547517)

	if (screenID == "services") then
        CreatureObject(pPlayer):sendSystemMessage("convoHandler working")
	end

	return pConvScreen
end

