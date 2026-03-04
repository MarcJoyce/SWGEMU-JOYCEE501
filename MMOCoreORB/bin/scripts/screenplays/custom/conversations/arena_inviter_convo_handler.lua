local QuestManager = require("managers.quest.quest_manager")

arenaInviterConvoHandler = conv_handler:new {}

function arenaInviterConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

    local playerID = SceneObject(pPlayer):getObjectID()

    if not EncounterArenaInvite:doesInviterBelongToThePlayer(pPlayer, pNpc) then
        return convoTemplate:getScreen("nothing_to_discuss")
    end
    
    if (not CreatureObject(pPlayer):hasScreenPlayState(1, "arena")) then
        return convoTemplate:getScreen("invite")
    else 
        return convoTemplate:getScreen("already_accepted")
    end
end

function arenaInviterConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
    local screen = LuaConversationScreen(pConvScreen)

    local convoTemplate = LuaConversationTemplate(pConvTemplate)
    local pConvScreen = screen:cloneScreen()
    local clonedConversation = LuaConversationScreen(pConvScreen)

    local screenID = screen:getScreenID()
    local playerID = SceneObject(pPlayer):getObjectID()
    local npcID = SceneObject(pNpc):getObjectID()

    local pGhost = CreatureObject(pPlayer):getPlayerObject()

    if (screenID == "accept" or screenID == "decline") then
        CreatureObject(pPlayer):setScreenPlayState(1, "arena")
        PlayerObject(pGhost):addWaypoint("lok", "Vask the Pitmaster", "", -3042, 66, 500, WAYPOINT_PURPLE, true, true, 0)
        EncounterArenaInvite:scheduleDespawnOfInviter(pPlayer)
    end

    return pConvScreen
end