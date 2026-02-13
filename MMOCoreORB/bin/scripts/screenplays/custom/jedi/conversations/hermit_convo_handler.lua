local ObjectManager = require("managers.object.object_manager")

hermitConvoHandler = conv_handler:new {}

function hermitConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local accountID = 0
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (CreatureObject(pPlayer):hasScreenPlayState(1, "trial_6_decipher_hermit")) then
        return convoTemplate:getScreen("success")
    else
        return convoTemplate:getScreen("init_screen")
    end
end

function hermitConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local playerID = CreatureObject(pPlayer):getObjectID()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pConvScreen
	end

    if (screenID == "init_screen") then
        if (CreatureObject(pPlayer):hasScreenPlayState(1, "trial_6_decipher")) then
            clonedConversation:addOption("Here, old man, take some credits, get some help", "success")
				else 
					clonedConversation:setStopConversation(true)
        end
    elseif (screenID == "success") then
		if (not CreatureObject(pPlayer):hasScreenPlayState(1, "trial_6_decipher")) then	
			CreatureObject(pPlayer):setScreenPlayState(1, "trial_6_decipher_hermit")
			logToFile(CreatureObject(pPlayer):getFirstName() .. " completed trial 6 decipher hermit", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
			--CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\ You feel a surge of knowledge flow through you, after aiding the hermit.")

			local decipherQuestsCompleted = tonumber(readScreenPlayData(pPlayer, "DecipherQuest", "trialsCompleted")) or 0  
			writeScreenPlayData(pPlayer, "DecipherQuest", "trialsCompleted", decipherQuestsCompleted + 1)

			if (tonumber(readScreenPlayData(pPlayer, "DecipherQuest", "trialsCompleted")) == 4) then
				CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\<Communicator>\\#FFFFFF\\ Head back to Mos Eisley as soon as you can, the inscription is now clear.")
			end
		end
    end

	return pConvScreen
end
