local QuestManager = require("managers.quest.quest_manager")

battleCoordinatorConvoHandler = conv_handler:new {}

function battleCoordinatorConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	if (not CreatureObject(pPlayer):hasScreenPlayState(1, "arena")) then
		return convoTemplate:getScreen("not_eligible")
	else 
		return convoTemplate:getScreen("hello")
	end
	
end

function battleCoordinatorConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	local cooldown = tonumber(readScreenPlayData(pPlayer, "Arena", ":arenaCooldown")) or 0
	local ranking = tonumber(Arena:getPlayerPosition(playerID)) or 0

	if (screenID == "begin") then
		Arena:beginArena(pPlayer)
	elseif screenID == "games" then
		if (Arena:isArenaOccupied()) then
			clonedConversation:addOption("I'm ready, let's do this!", "busy")
		elseif (cooldown > os.time()) then
			clonedConversation:addOption("I'm ready, let's do this!", "cooldown")
		else 
			clonedConversation:addOption("I'm ready, let's do this!", "begin")
		end
    
		if (ranking > 0) then 
			clonedConversation:addOption("How do I fare in the rankings?", "ranking")
		end
		clonedConversation:addOption("I need time to think about this.", "goodbye")
	
	elseif screenID == "ranking" then
		local performs = ""
		if (ranking <=3) then
			performs = "well"
		else
			performs = "poorly"
		end
		clonedConversation:setCustomDialogText("The great and mighty " .. CreatureObject(pPlayer):getFirstName() .. " performs... " .. performs .. " . You are currently rank " .. ranking .. ". Dare face the Arena again?")
		if (Arena:isArenaOccupied()) then
			clonedConversation:addOption("I'm ready, let's do this!", "busy")
		elseif (cooldown > os.time()) then
			clonedConversation:addOption("I'm ready, let's do this!", "cooldown")
		else 
			clonedConversation:addOption("I'm ready, let's do this!", "begin")
		end
		clonedConversation:addOption("I need time to think about this.", "goodbye")
	elseif screenID == "cooldown" then
		clonedConversation:setCustomDialogText("Ha! You seek more glory? The crowd have had their fill of " .. CreatureObject(pPlayer):getFirstName() .. " the 'mighty'. Come back again soon, when their appetite might demand your blood.")
		CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\ You can re-enter the arena in: " .. math.ceil((cooldown - os.time()) / 60) .. " minutes.")
	end
	
	return pConvScreen
end

