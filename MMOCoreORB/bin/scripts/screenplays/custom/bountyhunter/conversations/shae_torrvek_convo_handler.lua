shaeTorrvekConvoHandler = conv_handler:new {}

function shaeTorrvekConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  local trialsCompleted = BountyHunterGuildScreenPlay:getTrialsCompleted(pPlayer)

  self:log("Shae Torr'vek Conversation Handler: Player " .. SceneObject(pPlayer):getObjectID() .. " has completed " .. trialsCompleted .. " trials.")

  -- Player is not a bounty hunter
  if (not CreatureObject(pPlayer):hasSkill("combat_bountyhunter_novice")) then
    -- Player has never been a bounty hunter
    if (not CreatureObject(pPlayer):hasScreenPlayState(1, "bounty_hunter_trial")) then
      return convoTemplate:getScreen("not_bounty_hunter")
    end

    -- Player used to be a bounty hunter
    return convoTemplate:getScreen("ex_bounty_hunter")
  end

  -- Player has not yet started the trials
  if (not CreatureObject(pPlayer):hasScreenPlayState(1, "bounty_hunter_trial")) then
    return convoTemplate:getScreen("first_screen")
  end

  -- Player has completed all trials and has received training iV
  if (trialsCompleted >= 16 and CreatureObject(pPlayer):hasSkill("combat_bountyhunter_investigation_04")) then
    return convoTemplate:getScreen("no_more_work")
  end

  -- Player has completed 16 trials and not received training IV
  if (trialsCompleted >= 16 and not CreatureObject(pPlayer):hasSkill("combat_bountyhunter_investigation_04")) then
    return convoTemplate:getScreen("training_iv")
  end

  -- Player has completed 12 trials and not received training III
  if (trialsCompleted >= 12 and not CreatureObject(pPlayer):hasSkill("combat_bountyhunter_investigation_03")) then
    return convoTemplate:getScreen("training_iii")
  end
  
  -- Player has completed 8 trials and not received training II
  if (trialsCompleted >= 8 and not CreatureObject(pPlayer):hasSkill("combat_bountyhunter_investigation_02")) then
    return convoTemplate:getScreen("training_ii")
  end
  
  -- Player has completed 4 trials and not received training I
  if (trialsCompleted >= 4 and not CreatureObject(pPlayer):hasSkill("combat_bountyhunter_investigation_01")) then
    return convoTemplate:getScreen("training_i")
  end

  -- Player has returned and cannot be trained
  return convoTemplate:getScreen("returned_early")
end

function shaeTorrvekConvoHandler:log(message)
	local outputFile = "log/shae_torrvek.log"
	logToFile(message, outputFile)
end

function shaeTorrvekConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
  local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()

  self:log("Shae Torr'vek Conversation Handler: Player " .. SceneObject(pPlayer):getObjectID() .. " selected option '" .. selectedOption .. "' on screen '" .. screenID .. "'.")

  local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")

  if (screenID == "first_screen") then
    BountyHunterGuildScreenPlay:setTrialsCompleted(pPlayer, 0)
  elseif (screenID == "information") then
    CreatureObject(pPlayer):setScreenPlayState(1, "bounty_hunter_trial")
    BountyHunterGuildScreenPlay:startNextTrial(pPlayer)
  elseif (screenID == "training_i") then
    awardSkill(pPlayer, "combat_bountyhunter_investigation_01")
    if (not CreatureObject(pPlayer):hasScreenPlayState(1, "bounty_hunter_trial_boots")) then
      CreatureObject(pPlayer):setScreenPlayState(1, "bounty_hunter_trial_boots")
      createLoot(pInventory, "bounty_hunter_boots", 300, true)
    end
  elseif (screenID == "training_ii") then
    awardSkill(pPlayer, "combat_bountyhunter_investigation_02")
    if (not CreatureObject(pPlayer):hasScreenPlayState(1, "bounty_hunter_trial_leggings")) then
      CreatureObject(pPlayer):setScreenPlayState(1, "bounty_hunter_trial_leggings")
      createLoot(pInventory, "bounty_hunter_leggings", 300, true)
    end
  elseif (screenID == "training_iii") then
    awardSkill(pPlayer, "combat_bountyhunter_investigation_03")
    if (not CreatureObject(pPlayer):hasScreenPlayState(1, "bounty_hunter_trial_chest_plate")) then
      CreatureObject(pPlayer):setScreenPlayState(1, "bounty_hunter_trial_chest_plate")
      createLoot(pInventory, "bounty_hunter_chest_plate", 300, true)
    end
  elseif (screenID == "training_iv") then
    awardSkill(pPlayer, "combat_bountyhunter_investigation_04")
    if (not CreatureObject(pPlayer):hasScreenPlayState(1, "bounty_hunter_trial_helmet")) then
      CreatureObject(pPlayer):setScreenPlayState(1, "bounty_hunter_trial_helmet")
      createLoot(pInventory, "bounty_hunter_helmet", 300, true)
    end
    if (not CreatureObject(pPlayer):hasScreenPlayState(1, "bounty_hunter_trial_carbine")) then
      CreatureObject(pPlayer):setScreenPlayState(1, "bounty_hunter_trial_carbine")
      createLoot(pInventory, "carbine_ee3", 300, true)
    end
  end

  return pConvScreen
end
