local QuestManager = require("managers.quest.quest_manager")

bazaarBotHelperConvoHandler = conv_handler:new {}

function bazaarBotHelperConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local accountID = 0
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if pGhost == nil then
		
	else
		accountID = PlayerObject(pGhost):getAccountID()
	end

	if (not accountID == 17) then
		return convoTemplate:getScreen("hello")
  end
  return convoTemplate:getScreen("todo")
end

function bazaarBotHelperConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

  local pGhost = CreatureObject(pPlayer):getPlayerObject()

  local playerCredits = CreatureObject(pPlayer):getCashCredits()

  if (screenID == "todo_clear_inv") then
    rescheduleServerEvent("BazaarBotCleanInventory", 1 * 1000)
  elseif (screenID == "todo_relist") then
    rescheduleServerEvent("BazaarBotAddArmor", 1 * 1000)
    rescheduleServerEvent("BazaarBotAddClothing", 1 * 1000)
    rescheduleServerEvent("BazaarBotAddFood", 1 * 1000)
    rescheduleServerEvent("BazaarBotAddFurniture", 1 * 1000)
    rescheduleServerEvent("BazaarBotAddArtisanItems", 1 * 1000)
    rescheduleServerEvent("BazaarBotAddLoot", 1 * 1000)
    rescheduleServerEvent("BazaarBotAddMedicine", 1 * 1000)
    rescheduleServerEvent("BazaarBotAddStructures", 1 * 1000)
    rescheduleServerEvent("BazaarBotAddVehicles", 1 * 1000)
    rescheduleServerEvent("BazaarBotAddWeapons", 1 * 1000)
  elseif (screenID == "add_wps") then
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    local playerID = SceneObject(pPlayer):getObjectID()
    PlayerObject(pGhost):addWaypoint("corellia", "Corellia: WorldBoss#1", "", 547, 0, -308, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("corellia", "Corellia: WorldBoss#2", "", 4596, 0, 1426, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("dantooine", "Dantooine: WorldBoss#1", "", -141, 0, -484, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("dantooine", "Dantooine: WorldBoss#2", "", -640, 0, -4704, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("dathomir", "Dathomir: WorldBoss#1", "", -141, 0, -484, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("dathomir", "Dathomir: WorldBoss#2", "", -640, 0, -4704, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("dathomir", "Dathomir: WorldBoss#3", "", -6048, 0, -32, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("endor", "Endor: WorldBoss#1", "", -4409, 0, 4284, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("endor", "Endor: WorldBoss#2", "", 3552, 0, 3552, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("endor", "Endor: WorldBoss#3", "", 1000, 0, -800, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("lok", "Lok: WorldBoss#1", "", 2470, 0, -4217, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("lok", "Lok: WorldBoss#2", "", -2253, 0, -3070, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("naboo", "Naboo: WorldBoss#1", "", -5331, 0, 3498, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("naboo", "Naboo: WorldBoss#2", "", -2080, 0, -5157, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("talus", "Talus: WorldBoss#1", "", 4307, 0, 1015, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("talus", "Talus: WorldBoss#2", "", 395, 0, -821, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("tatooine", "Tatooine: WorldBoss#1", "", -5870, 0, -5178, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("tatooine", "Tatooine: WorldBoss#2", "", 5376, 0, 2400, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("tatooine", "Tatooine: WorldBoss#3", "", -5456, 0, 6320, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("tatooine", "Tatooine: WorldBoss#4", "", 1954, 0, -4879, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("yavin4", "Yavin4: WorldBoss#1", "", 4763, 0, 5248, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("yavin4", "Yavin4: WorldBoss#2", "", 5854, 0, -4383, WAYPOINT_YELLOW, true, true, 0)
  end

  return pConvScreen
end

