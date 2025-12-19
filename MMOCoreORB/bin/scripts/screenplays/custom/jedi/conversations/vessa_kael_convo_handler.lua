local ObjectManager = require("managers.object.object_manager")

vessaKaelConvoHandler = conv_handler:new {}

function vessaKaelConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
    local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local accountID = 0
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

    if (CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_3")) then
        return convoTemplate:getScreen("revenge")
    elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "rarruk_graal") and CreatureObject(pPlayer):hasScreenPlayState(1, "jalen_vort") and CreatureObject(pPlayer):hasScreenPlayState(1, "sskarr_vrenn")) then
        return convoTemplate:getScreen("task_complete")
    elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "vessa_kael")) then
        return convoTemplate:getScreen("task_ongoing")
    else
        return convoTemplate:getScreen("first_screen")
    end
end

function vessaKaelConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
    local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local playerID = CreatureObject(pPlayer):getObjectID()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pConvScreen
	end

    if (screenID == "task_accept") then
        CreatureObject(pPlayer):setScreenPlayState(1, "vessa_kael")
        PlayerObject(pGhost):addWaypoint("tatooine", "Rarruk Graal", "", -5866, 0, -6201, WAYPOINT_YELLOW, true, true, 0)
        PlayerObject(pGhost):addWaypoint("tatooine", "Jalen Vort", "", 3366, 0, -4584, WAYPOINT_YELLOW, true, true, 0)
        PlayerObject(pGhost):addWaypoint("tatooine", "Sskarr Vrenn", "", 3540, 0, -4803, WAYPOINT_YELLOW, true, true, 0)
    elseif (screenID == "final_seven") then
        CreatureObject(pPlayer):setScreenPlayState(2, "glowy_trial_3")
        CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\<Communicator>\\#FFFFFF\\Hello, Hello, is this thing working? The artifact has indicated your task is complete, come see me as soon as you can.")
    end

    return pConvScreen
end