local QuestManager = require("managers.quest.quest_manager")

battleCoordinatorConvoHandler = conv_handler:new {}

function battleCoordinatorConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local specialGrants = {
		["281474993603702"] = { xpType = "combat_gladiator", amount = 35877 },
		["281474997062566"] = { xpType = "combat_gladiator", amount = 27671 },
		["281474997224459"] = { xpType = "combat_gladiator", amount = 18359 },
		["281474993622243"] = { xpType = "combat_gladiator", amount = 19417 },
		["281474997254656"] = { xpType = "combat_gladiator", amount = 19381 },
		["281474993833238"] = { xpType = "combat_gladiator", amount = 12534 },
		["281474993840195"] = { xpType = "combat_gladiator", amount = 6743 },
		["281474993619343"] = { xpType = "combat_gladiator", amount = 5193 },
		["281474996086936"] = { xpType = "combat_gladiator", amount = 4509 },
		["281475001698996"] = { xpType = "combat_gladiator", amount = 4872 },
		["281474993911974"] = { xpType = "combat_gladiator", amount = 4727 },
		["281474993630629"] = { xpType = "combat_gladiator", amount = 2354 },
		["281474997313484"] = { xpType = "combat_gladiator", amount = 2343 },
		["281474993710721"] = { xpType = "combat_gladiator", amount = 1767 },
		["281474993547517"] = { xpType = "combat_gladiator", amount = 1420 },
		["281474996255104"] = { xpType = "combat_gladiator", amount = 1254 },
		["281474993605708"] = { xpType = "combat_gladiator", amount = 770 },
		["281474993627424"] = { xpType = "combat_gladiator", amount = 502 },
		["281474993720118"] = { xpType = "combat_gladiator", amount = 462 },
		["281474993994353"] = { xpType = "combat_gladiator", amount = 280 },
	}

	-- Have used the following
	-- :backdateArenaXp_1

	-- Current :backdateArenaXp_2

	local pid = tostring(playerID)
	local grant = specialGrants[pid]

	if (grant) then
		local givenKey = ":backdateArenaXp_2"
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

