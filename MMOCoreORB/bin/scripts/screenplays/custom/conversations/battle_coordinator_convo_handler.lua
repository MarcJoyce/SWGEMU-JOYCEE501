local QuestManager = require("managers.quest.quest_manager")

battleCoordinatorConvoHandler = conv_handler:new {}

function battleCoordinatorConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local specialGrants = {
		["281474993710721"] = { xpType = "combat_gladiator", amount = 1767 },
		["281474993994353"] = { xpType = "combat_gladiator", amount = 279 },
		["281474993627424"] = { xpType = "combat_gladiator", amount = 501 },
		["281474993720118"] = { xpType = "combat_gladiator", amount = 461 },
		["281474997254656"] = { xpType = "combat_gladiator", amount = 6923 },
		["281474993547517"] = { xpType = "combat_gladiator", amount = 1419 },
		["281474993603702"] = { xpType = "combat_gladiator", amount = 2318 },
		["281474993911974"] = { xpType = "combat_gladiator", amount = 3091 },
		["281474993622243"] = { xpType = "combat_gladiator", amount = 2285 },
		["281474996255104"] = { xpType = "combat_gladiator", amount = 1254 },
	}

	local pid = tostring(playerID)
	local grant = specialGrants[pid]

	if (grant) then
		local givenKey = ":backdateArenaXp_1"
		local already = tonumber(readScreenPlayData(pPlayer, "Arena", givenKey)) or 0

		if (already == 0) then
			CreatureObject(pPlayer):awardExperience(grant.xpType, grant.amount, true)
			writeScreenPlayData(pPlayer, "Arena", givenKey, 1)
		end
	end

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

