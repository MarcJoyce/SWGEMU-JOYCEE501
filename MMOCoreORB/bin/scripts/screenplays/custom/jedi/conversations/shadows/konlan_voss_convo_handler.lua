local ObjectManager = require("managers.object.object_manager")

konlanVossConvoHandler = conv_handler:new {}


function konlanVossConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local accountID = 0
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if pGhost == nil then
		
	else
		accountID = PlayerObject(pGhost):getAccountID()
	end

	if (CreatureObject(pPlayer):hasScreenPlayState(2, "shadows_three") or not CreatureObject(pPlayer):hasScreenPlayState(2, "shadows_two")) then
		return convoTemplate:getScreen("go_away")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "shadows_three")) then
		return convoTemplate:getScreen("explain_seven")
	end
	return convoTemplate:getScreen("init_screen")
end

function konlanVossConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local playerID = CreatureObject(pPlayer):getObjectID()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pConvScreen
	end

  if (screenID == "explain_six") then
		CreatureObject(pPlayer):setScreenPlayState(1, "shadows_three")

		-- TODO: SET UP SHADOWS PART 3
		-- ShadowsMeetUpTheatre:start(pPlayer)
	end

	return pConvScreen
end
