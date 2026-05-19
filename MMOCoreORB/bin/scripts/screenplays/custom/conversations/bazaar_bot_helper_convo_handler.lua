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
  elseif (screenID == "spawn_barbed") then
    local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")
    local pBuffItem = giveItem(pInventory, "object/tangible/item/quest/force_sensitive/fs_buff_item.iff", -1, true)

		if (pBuffItem == nil) then
			CreatureObject(pPlayer):sendSystemMessage("Error: Unable to generate item.")
		else
			local buffItem = LuaFsBuffItem(pBuffItem)
			-- buffItem:setBuffAttribute(6) -- Mind
			buffItem:setBuffAttribute(0) --  Health
			-- buffItem:setReuseTime(345600000) -- 4 days in milliseconds
			buffItem:setReuseTime(600000) -- 10 minutes in milliseconds
			-- buffItem:setBuffValue(900)
			buffItem:setBuffValue(1800)
			-- buffItem:setBuffDuration(5400) -- 1.5 hours in seconds
			buffItem:setBuffDuration(10800) -- 3 hours in seconds
		end
  elseif (screenID == "todo_relist") then
    BazaarBotScreenPlay:validateEvent("BazaarBotAddFood", "addMoreFood", 1)
  elseif (screenID == "add_wps") then
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    local playerID = SceneObject(pPlayer):getObjectID()
    PlayerObject(pGhost):addWaypoint("corellia", "Coronet Starport", "", -66.760902, 28, -4711.3281, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("corellia", "Tyrena Starport", "", -5003.0649, 21, -2228.3665, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("corellia", "Kor Vella Starport", "", -3157.2834, 31, 2876.2029, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("corellia", "Doaba Guerfel Starport", "", 3349.8933, 308, 5598.1362, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("corellia", "Bela Vistal Shuttleport A", "", 6644.269, 330, -5922.5225, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("dantooine", "Dantooine Mining Outpost", "", -637, 3, 2504.4, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("dantooine", "Dantooine Imperial Outpost", "", -4208.6602, 3, -2350.24, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("dantooine", "Dantooine Agro Outpost", "", 1569.66, 4, -6415.7598, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("dantooine", "Abandoned Rebel Base", "", -6799.6, 46, 5574.3, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("dathomir", "Trade Outpost", "", 618.89258, 6.039608, 3092.0142, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("dathomir", "Science Outpost", "", -49.021923, 18, -1584.7278, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("endor", "Smuggler Outpost", "", -950.59241, 73, 1553.4125, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("endor", "Research Outpost", "", 3201.6599, 24, -3499.76, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("lok", "Nyms Stronghold", "", 478.92676, 9, 5511.9565, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("naboo", "Keren Starport", "", 1371.5938, 13, 2747.9043, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("naboo", "Theed Spaceport", "", -4858.834, 5.9483199, 4164.0679, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("naboo", "The Lake Retreat", "", -5494.4224, -150, -21.837162, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("naboo", "Moenia", "", 4731.1743, 4.1700001, -4677.5439, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("naboo", "Deeja Peak Shuttleport", "", 5331.9375, 327.02765, -1576.6733, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("naboo", "Kaadara Starport", "", 5280.2002, -192, 6688.0498, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("naboo", "Emperors Retreat", "", 2442.8, 292, -3916.8, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("rori", "Restuss Starport", "", 5340, 80, 5734, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("rori", "Narmle Starport", "", -5374.0718, 80, -2188.6143, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("rori", "Rebel Outpost", "", 3691.9023, 96, -6403.4404, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("rori", "Dearic Starport", "", 263.58401, 6, -2952.1284, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("talus", "Talus Imperial Outpost", "", -2227.4, 20, 2319.9, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("talus", "Nashal Starport", "", 4453.7212, 2, 5354.3345, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("tatooine", "Mos Eisley Starport", "", 3599.894, 5, -4780.4487, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("tatooine", "Bestine Starport", "", -1361.1917, 12, -3600.0254, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("tatooine", "Mos Espa Starport", "", -2833.1609, 5, 2107.3787, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("tatooine", "Anchorhead Shuttleport", "", 47.565128, 52, -5338.9072, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("tatooine", "Mos Entha Starport", "", 1266.0996, 7, 3065.1392, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("tatooine", "Jabbas Palace", "", -6171.6, 90, -6381.5, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("yavin4", "Yavin IV Labor Outpost", "", -6921.6733, 73, -5726.5161, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("yavin4", "Yavin IV Mining Outpost", "", -267.23914, 35, 4896.3013, WAYPOINT_YELLOW, true, true, 0)
    PlayerObject(pGhost):addWaypoint("yavin4", "Yavin IV Imperial Outpost", "", 4054.1, 37, -6216.9, WAYPOINT_YELLOW, true, true, 0)
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

