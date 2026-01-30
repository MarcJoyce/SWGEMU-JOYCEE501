jabbaHenchmanCustomConvoHandler = conv_handler:new {}

function jabbaHenchmanCustomConvoHandler:getInitialScreen(pPlayer, nNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  if (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_six")) then
    return convoTemplate:getScreen("go_away")
  elseif (not CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_1")) then
    return convoTemplate:getScreen("go_away")
  elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "pay_jabba")) then
    return convoTemplate:getScreen("pay")
  elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "krayt_dragon")) then
    return convoTemplate:getScreen("kill_success")
  elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "krayt_dragon")) then
    return convoTemplate:getScreen("kill_ongoing")
  else
    return convoTemplate:getScreen("first_screen")
  end
end

function jabbaHenchmanCustomConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
  local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

  local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pClonedScreen
	end

	local ghost = LuaPlayerObject(pGhost)

  if (screenID == "first_screen") then
    local jabbaStanding = ghost:getFactionStanding("jabba")

    if (jabbaStanding > 4500) then
      clonedConversation:addOption("Jabba and I are close. He'll want me to have it.", "free")
    elseif (jabbaStanding > 2500) then
      clonedConversation:addOption("Jabba and I are close. He'll want me to have it.", "pay")
    else
      clonedConversation:addOption("I need it, no matter the cost", "kill")
    end

  elseif (screenID == "free") then
    CreatureObject(pPlayer):setScreenPlayState(1, "piece_of_eight_six")
    logToFile(CreatureObject(pPlayer):getFirstName() .. " received piece_of_eight_six", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
    CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\Gurkk hands you a piece of the orb")
  elseif (screenID == "pay") then
    local playerCredits = CreatureObject(pPlayer):getCashCredits()
    CreatureObject(pPlayer):setScreenPlayState(1, "pay_jabba")

    if (playerCredits > 999999) then
      clonedConversation:addOption("Ok, here you go", "pay_success")
    else
      clonedConversation:addOption("I don't have that much", "pay_failed")
    end
  elseif (screenID == "pay_success") then
    CreatureObject(pPlayer):subtractCashCredits(1000000)
    CreatureObject(pPlayer):setScreenPlayState(1, "piece_of_eight_six")
    logToFile(CreatureObject(pPlayer):getFirstName() .. " received piece_of_eight_six", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
    CreatureObject(pPlayer):removeScreenPlayState(1, "pay_jabba")
    CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\Gurkk hands you a piece of the orb")
  elseif (screenID == "kill") then
    CreatureObject(pPlayer):setScreenPlayState(1, "krayt_dragon")
    createObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceSix", pPlayer)
  elseif (screenID == "kill_success") then
    CreatureObject(pPlayer):removeScreenPlayState(1, "krayt_dragon")
    CreatureObject(pPlayer):removeScreenPlayState(2, "krayt_dragon")
    CreatureObject(pPlayer):setScreenPlayState(1, "piece_of_eight_six")
    logToFile(CreatureObject(pPlayer):getFirstName() .. " received piece_of_eight_six", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
    CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\Gurkk hands you a piece of the orb")
  end

  return pConvScreen
end

