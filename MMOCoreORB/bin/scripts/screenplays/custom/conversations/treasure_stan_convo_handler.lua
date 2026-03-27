local QuestManager = require("managers.quest.quest_manager")

treasureStanConvoHandler = conv_handler:new {}

function treasureStanConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local accountID = 0
	local pAdminPlayer = getCreatureObject(281474993547517)

  return convoTemplate:getScreen("hello")
end

function treasureStanConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	local pAdminPlayer = getCreatureObject(281474993547517)

	local givenTreasure = tonumber(readScreenPlayData(pAdminPlayer, "TreasureScreenPlay", "givenTreasure")) or 0

	if (screenID == "hello") then
		if (givenTreasure > 0) then
			clonedConversation:setCustomDialogText("Please please, don't tell Stan where I am!!")
		else 
			clonedConversation:setCustomDialogText("You found me, please, please don't take me back to that awful tyrant, here, I stole this from his workshop before I escaped.")
			writeScreenPlayData(pAdminPlayer, "TreasureScreenPlay", "givenTreasure", 1)
			
			local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
			logToFile(CreatureObject(pPlayer):getFirstName() .. " received treasure stan loot.", "log/treasure_stan.log")
			
      createLoot(pInventory, "blank_enhancement_disks", 350, true)
			
			createEvent(10000, "TreasureScreenPlay", "refreshStan", pAdminPlayer, "")
		end
	end
	
	return pConvScreen
end

