local ObjectManager = require("managers.object.object_manager")

rarrukGraalConvoHandler = conv_handler:new {}

function rarrukGraalConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
    local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local accountID = 0
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

    if (CreatureObject(pPlayer):hasScreenPlayState(1, "vessa_kael")) then
        if (CreatureObject(pPlayer):hasScreenPlayState(1, "rarruk_graal")) then
            return convoTemplate:getScreen("no_more")
        else
            return convoTemplate:getScreen("first_screen")
        end
    else
        return convoTemplate:getScreen("bye")
    end
end

function rarrukGraalConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
    local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local playerID = CreatureObject(pPlayer):getObjectID()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pConvScreen
	end

    if (screenID == "help_investigate_four") then
        CreatureObject(pPlayer):setScreenPlayState(1, "rarruk_graal")
    end

    return pConvScreen
end