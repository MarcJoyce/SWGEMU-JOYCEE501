heraldConvoHandler = conv_handler:new {}

function heraldConvoHandler:getInitialScreen(pPlayer, nNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  local hasAnySkills = self:playerHasAnySkills(pPlayer)

  logToFile(CreatureObject(pPlayer):getFirstName() .. " hasAnySkills: " .. tostring(hasAnySkills))

  if (VillageJediManagerCommon.hasJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_GLOWING)) then
    return convoTemplate:getScreen("not_ready")
  elseif (not CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_8")) then
    return convoTemplate:getScreen("not_ready")
  end
  if (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_8")) then
    if (hasAnySkills == true) then
      return convoTemplate:getScreen("unlearn")
    else
      return convoTemplate:getScreen("first_screen")
    end
  end

  return convoTemplate:getScreen("not_ready")
end

function heraldConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local playerID = CreatureObject(pPlayer):getObjectID()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pConvScreen
	end

    if (screenID == "herald_one") then
      VillageJediManagerCommon.setJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_GLOWING)
      FsIntro:startPlayerOnIntro(pPlayer)
      CreatureObject(pPlayer):setScreenPlayState(2, "glowy_trial_8")
      logToFile(CreatureObject(pPlayer):getFirstName() .. " completed trial 8", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
    end

    return pConvScreen
end

function heraldConvoHandler:playerHasAnySkills(pPlayer)
  local pGhost = CreatureObject(pPlayer):getPlayerObject()

  local skills = {
    "crafting_artisan_novice",
    "combat_brawler_novice",
    "social_entertainer_novice",
    "combat_marksman_novice",
    "science_medic_novice",
    "outdoors_scout_novice"
  }

  local hasSkills = false

  for i = 1, #skills do
    if (CreatureObject(pPlayer):hasSkill(skills[i])) then
        hasSkills = true
    end
  end

  return hasSkills

end
