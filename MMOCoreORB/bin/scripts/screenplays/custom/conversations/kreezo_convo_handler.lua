local QuestManager = require("managers.quest.quest_manager")

kreezoConvoHandler = conv_handler:new {}

function kreezoConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local accountID = 0
	local pAdminPlayer = getCreatureObject(281474993547517)

  return convoTemplate:getScreen("greeting")
end

function kreezoConvoHandler:hasItems(pPlayer, credits, item, item2) 
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local hasCredits = CreatureObject(pPlayer):getCashCredits() >= credits
	local pItem = getContainerObjectByCustomName(pInventory, item, false)
	local pItem2 = getContainerObjectByCustomName(pInventory, item2, false)
	if (pItem ~= nil and pItem2 ~= nil and hasCredits) then
		return true
	end
	
	return false
end

function kreezoConvoHandler:removeItems(pPlayer, credits, item, item2)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local pItem = getContainerObjectByCustomName(pInventory, item, true)
	local pItem2 = getContainerObjectByCustomName(pInventory, item2, false)

	if (pItem ~= nil and pItem2 ~= nil) then
		SceneObject(pItem):destroyObjectFromWorld()
		SceneObject(pItem):destroyObjectFromDatabase()
		SceneObject(pItem2):destroyObjectFromWorld()
		SceneObject(pItem2):destroyObjectFromDatabase()
	end

	CreatureObject(pPlayer):subtractCashCredits(credits)
end

function kreezoConvoHandler:giveCraftingTool(pPlayer, tool)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")
	logToFile(CreatureObject(pPlayer):getFirstName() .. " has received " .. tool .. " from Kreezo.", "log/kreezo.log")

	if (pInventory ~= nil) then
		createLoot(pInventory, tool, 350, true)
	end

end

function kreezoConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	local pAdminPlayer = getCreatureObject(281474993547517)

	if (screenID == "greeting") then
		-- clonedConversation:removeAllOptions();

		-- clonedConversation:setCustomDialogText("Utinni! Stan-man say you might come. Kreezo is master of scrap-craft. Bring parts and credits and Kreezo can help with your enhancement modifications. Kreezo is not ready to deliver SEA Removal tools yet, The big man in the sky has not finished me off yet. Maybe go bug him about it.");

		-- clonedConversation:setStopConversation("true");
	elseif (screenID == "tier1_armor") then
        local hasItems = self:hasItems(pPlayer, 150000, "Mag-Seal Breaker", "a Blank Armor Enhancement Disk")
		if (hasItems) then
			clonedConversation:addOption("I have the items, here.", "tier1_armor_confirm")
		else 
			clonedConversation:addOption("I don't have the items.", "does_not_have_items")
		end

		clonedConversation:addOption("Show me the other options.", "services")
		clonedConversation:addOption("Nevermind.", "goodbye")
	elseif (screenID == "tier1_clothing") then
		local hasItems = self:hasItems(pPlayer, 150000, "Fiber Matrix Separator", "a Blank Clothing Enhancement Disk")
		if (hasItems) then
			clonedConversation:addOption("I have the items, here.", "tier1_clothing_confirm")
		else 
			clonedConversation:addOption("I don't have the items.", "does_not_have_items")
		end

		clonedConversation:addOption("Show me the other options.", "services")
		clonedConversation:addOption("Nevermind.", "goodbye")
	elseif (screenID == "tier2_armor") then
		local hasItems = self:hasItems(pPlayer, 400000, "Servo-Torque Extractor", "a Blank Armor Enhancement Disk")
		if (hasItems) then
			clonedConversation:addOption("I have the items, here.", "tier2_armor_confirm")
		else 
			clonedConversation:addOption("I don't have the items.", "does_not_have_items")
		end

		clonedConversation:addOption("Show me the other options.", "services")
		clonedConversation:addOption("Nevermind.", "goodbye")
	elseif (screenID == "tier2_clothing") then
		local hasItems = self:hasItems(pPlayer, 400000, "Nano-Stitch Dissolver", "a Blank Clothing Enhancement Disk")
		if (hasItems) then
			clonedConversation:addOption("I have the items, here.", "tier2_clothing_confirm")
		else
			clonedConversation:addOption("I don't have the items.", "does_not_have_items")
		end

		clonedConversation:addOption("Show me the other options.", "services")
		clonedConversation:addOption("Nevermind.", "goodbye")
	elseif (screenID == "tier3_armor") then
		local hasItems = self:hasItems(pPlayer, 700000, "Kinetic Resonance Hammer", "a Blank Armor Enhancement Disk")
		if (hasItems) then
			clonedConversation:addOption("I have the items, here.", "tier3_armor_confirm")
		else
			clonedConversation:addOption("I don't have the items.", "does_not_have_items")
		end
		clonedConversation:addOption("Show me the other options.", "services")
		clonedConversation:addOption("Nevermind.", "goodbye")
	elseif (screenID == "tier3_clothing") then
		local hasItems = self:hasItems(pPlayer, 700000, "Micro Loom Reverser", "a Blank Clothing Enhancement Disk")
		if (hasItems) then
			clonedConversation:addOption("I have the items, here.", "tier3_clothing_confirm")
		else
			clonedConversation:addOption("I don't have the items.", "does_not_have_items")
		end
		clonedConversation:addOption("Show me the other options.", "services")
		clonedConversation:addOption("Nevermind.", "goodbye")
	elseif (screenID == "tier4_armor") then
		local hasItems = self:hasItems(pPlayer, 1050000, "Micro Fusion Arc Probe", "a Blank Armor Enhancement Disk")
		if (hasItems) then
			clonedConversation:addOption("I have the items, here.", "tier4_armor_confirm")
		else
			clonedConversation:addOption("I don't have the items.", "does_not_have_items")
		end
		clonedConversation:addOption("Show me the other options.", "services")
		clonedConversation:addOption("Nevermind.", "goodbye")
	elseif (screenID == "tier4_clothing") then
		local hasItems = self:hasItems(pPlayer, 1050000, "Spectral Fabric Analyzer", "a Blank Clothing Enhancement Disk")
		if (hasItems) then
			clonedConversation:addOption("I have the items, here.", "tier4_clothing_confirm")
		else
			clonedConversation:addOption("I don't have the items.", "does_not_have_items")
		end
		clonedConversation:addOption("Show me the other options.", "services")
		clonedConversation:addOption("Nevermind.", "goodbye")

	elseif (screenID == "tier1_armor_start") then
		self:removeItems(pPlayer, 150000, "Mag-Seal Breaker", "a Blank Armor Enhancement Disk")
		self:giveCraftingTool(pPlayer, "sea_armor_removal_1")
	elseif (screenID == "tier1_clothing_start") then
		self:removeItems(pPlayer, 150000, "Fiber Matrix Separator", "a Blank Clothing Enhancement Disk")
		self:giveCraftingTool(pPlayer, "sea_clothing_removal_1")
	elseif (screenID == "tier2_armor_start") then
		self:removeItems(pPlayer, 400000, "Servo-Torque Extractor", "a Blank Armor Enhancement Disk")
		self:giveCraftingTool(pPlayer, "sea_armor_removal_2")
	elseif (screenID == "tier2_clothing_start") then
		self:removeItems(pPlayer, 400000, "Nano-Stitch Dissolver", "a Blank Clothing Enhancement Disk")
		self:giveCraftingTool(pPlayer, "sea_clothing_removal_2")
	elseif (screenID == "tier3_armor_start") then
		self:removeItems(pPlayer, 700000, "Kinetic Resonance Hammer", "a Blank Armor Enhancement Disk")
		self:giveCraftingTool(pPlayer, "sea_armor_removal_3")
	elseif (screenID == "tier3_clothing_start") then
		self:removeItems(pPlayer, 700000, "Micro Loom Reverser", "a Blank Clothing Enhancement Disk")
		self:giveCraftingTool(pPlayer, "sea_clothing_removal_3")
	elseif (screenID == "tier4_armor_start") then
		self:removeItems(pPlayer, 1050000, "Micro Fusion Arc Probe", "a Blank Armor Enhancement Disk")
		self:giveCraftingTool(pPlayer, "sea_armor_removal_4")
	elseif (screenID == "tier4_clothing_start") then
		self:removeItems(pPlayer, 1050000, "Spectral Fabric Analyzer", "a Blank Clothing Enhancement Disk")
		self:giveCraftingTool(pPlayer, "sea_clothing_removal_4")
	end

	return pConvScreen
end
