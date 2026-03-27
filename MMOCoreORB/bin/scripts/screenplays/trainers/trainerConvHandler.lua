trainerConvHandler = conv_handler:new {}

function trainerConvHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local trainerType = SkillTrainer:getTrainerType(pPlayer, pNpc, pConvTemplate)
	local prereqSkills = SkillTrainer:getPrerequisiteTrainerSkills(trainerType)

	if (trainerType == "") then
		return convoTemplate:getScreen("trainer_unknown")
	elseif (not SkillTrainer:hasAllPrereqSkills(pPlayer, trainerType)) then
		return convoTemplate:getScreen("no_qualify")
	elseif (SkillTrainer:hasSurpassedTrainer(pPlayer, trainerType)) then
		return convoTemplate:getScreen("topped_out")
	end

	return convoTemplate:getScreen("intro")
end

function trainerConvHandler:log(message)
	local outputFile = "log/trainerConvHandler.log"
	logToFile(message, outputFile)
end

function trainerConvHandler:isCraftingTrainer(trainerType)
	if (trainerType == "trainer_artisan" or trainerType == "trainer_architect" or trainerType == "trainer_armorsmith" or trainerType == "trainer_droidengineer" or trainerType == "trainer_weaponsmith") then
		return true
	end

	return false
end

function trainerConvHandler:hasAnySpecialItem(pPlayer, customItemPrefix) 
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local hasAny = false
	for i = 1, 10 do
		local itemFullName = customItemPrefix .. " (" .. i .. "/10)"
		local pItem = getContainerObjectByCustomName(pInventory, itemFullName, true)

		if (pItem ~= nil) then
			hasAny = true
			break
		end
	end

	return hasAny
end

function trainerConvHandler:hasAllSpecialItem(pPlayer, customItemPrefix) 
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local hasAll = true
	for i = 1, 10 do
		local itemFullName = customItemPrefix .. " (" .. i .. "/10)"
		local pItem = getContainerObjectByCustomName(pInventory, itemFullName, true)

		if (pItem == nil) then
			hasAll = false
			break
		end
	end

	return hasAll
end

function trainerConvHandler:removeSpecialItems(pPlayer, customItemPrefix) 
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	for i = 1, 10 do
		local itemFullName = customItemPrefix .. " (" .. i .. "/10)"
		local pItem = getContainerObjectByCustomName(pInventory, itemFullName, true)

		if (pItem ~= nil) then
			SceneObject(pItem):destroyObjectFromWorld()
			SceneObject(pItem):destroyObjectFromDatabase()
		end
	end
end

function trainerConvHandler:giveBarcSpeederDeed(pPlayer)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local pItem = giveItem(pInventory, "object/tangible/deed/vehicle_deed/barc_speeder_deed.iff" , -1)

	if (pItem ~= nil) then
			SceneObject(pItem):sendTo(pPlayer)
			CreatureObject(pPlayer):sendSystemMessage("You hand over the Aratech Repulsor Company Disks and receive a BARC Speeder deed.")
	else 
		self:log(CreatureObject(pPlayer):getFirstName() .. " could not be given BARC as their inventory was full.")
	end
end

function trainerConvHandler:getNamedCrystals()
		local namedLightsaberCrystals = {
			{ "Baas's Wisdom", "crystal_baass_wisdom" },
			{ "Bane's Heart", "crystal_banes_heart" },
			{ "B'nar's Sacrifice", "crystal_bnars_sacrifice" },
			{ "Bondara's Folly", "crystal_bondaras_folly" },
			{ "Dawn of Dagobah", "crystal_dawn_of_dagobah" },
			{ "Gallia's Intuition", "crystal_gallias_intuition" },
			{ "Horn's Future", "crystal_horns_future" },
			{ "Kenobi's Legacy", "crystal_kenobis_legacy" },
			{ "Kit's Ferocity", "crystal_kits_ferocity" },
			{ "Kun's Blood", "crystal_kuns_blood" },
			{ "Maul's Vengence", "crystal_mauls_vengence" },
			{ "Mundi's Response", "crystal_mundis_response" },
			{ "Prowess of Plo Koon", "crystal_prowess_of_plo_koon" },
			{ "Qui-Gon's Devotion", "crystal_qui-gons_devotion" },
			{ "Quintessence of the Force", "crystal_quintessence_of_the_force" },
			{ "Strength of Luminaria", "crystal_strength_of_luminaria" },
			{ "Sunrider's Destiny", "crystal_sunriders_destiny" },
			{ "Ulic's Redemption", "crystal_ulics_redemption" },
			{ "Windu's Guile", "crystal_windus_guile"}
	}

	return namedLightsaberCrystals
end

function trainerConvHandler:hasNamedCrystal(pPlayer)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local namedLightsaberCrystals = self:getNamedCrystals()

	local hasCrystal = false
	for i = 1, #namedLightsaberCrystals do
		local pItem = getContainerObjectByCustomName(pInventory, namedLightsaberCrystals[i][1], true)

		if (pItem ~= nil and SceneObject(pItem):getCustomObjectName() == namedLightsaberCrystals[i][1]) then
			hasCrystal = true
			break
		end
	end

	return hasCrystal
end

function trainerConvHandler:giveInfusedLightsaberCrystal(pPlayer)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local namedLightsaberCrystals = self:getNamedCrystals()
	local crystalToBeRemoved = nil

	for i = 1, #namedLightsaberCrystals do
		local pItem = getContainerObjectByCustomName(pInventory, namedLightsaberCrystals[i][1], true)

		if (pItem ~= nil and SceneObject(pItem):getCustomObjectName() == namedLightsaberCrystals[i][1]) then
			crystalToBeRemoved = namedLightsaberCrystals[i][2]
			SceneObject(pItem):destroyObjectFromWorld()
			SceneObject(pItem):destroyObjectFromDatabase()
			break
		end
	end

	createLoot(pInventory, "infused_" .. crystalToBeRemoved, 350, true)

	CreatureObject(pPlayer):sendSystemMessage("You hand over your Holocron Splinters and a named Lightsaber Crystal and receive an infused Lightsaber Crystal.")
end

function trainerConvHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local trainerType = SkillTrainer:getTrainerType(pPlayer, pNpc, pConvTemplate)
	local playerID = SceneObject(pPlayer):getObjectID()
	local stringTable = "@skill_teacher:"
	local isJediTrainer = false

	if (trainerType == "trainer_jedi") then
		isJediTrainer = true
		stringTable = "@jedi_trainer:"
	end

	if (screenID == "intro") then
		local pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		if (isJediTrainer) then
			clonedConversation:setDialogTextStringId(stringTable .. "greeting")
		else
			clonedConversation:setDialogTextStringId(stringTable .. trainerType)
		end

		clonedConversation:addOption("@skill_teacher:opt1_1", "msg2_1")
		clonedConversation:addOption("@skill_teacher:opt1_2", "msg2_2")

		if (self:isCraftingTrainer(trainerType)) then
			if (self:hasAllSpecialItem(pPlayer, "Aratech Repulsor Company Disk")) then
				clonedConversation:addOption("I couldn't help notice you have a collection of old Aratech Repulsor Company Disk's. May I have a look?", "barc_disks_all")
			elseif (self:hasAnySpecialItem(pPlayer, "Aratech Repulsor Company Disk")) then
				clonedConversation:addOption("I couldn't help notice you have an old Aratech Repulsor Company Disk. May I have a look?", "barc_disks_any")
			end
		end

		if (isJediTrainer) then
			if (self:hasAllSpecialItem(pPlayer, "Holocron Splinter") and self:hasNamedCrystal(pPlayer)) then
				clonedConversation:addOption("I couldn't help notice you have a collection of Holocron splinters, and a special Lightsaber crystal. May I have a look?", "holocron_splinter_all")
			elseif (self:hasAnySpecialItem(pPlayer, "Holocron Splinter")) then
				clonedConversation:addOption("I couldn't help notice you have, what seems to be a Holocron splinter. May I have a look?", "holocron_splinter_any")
			end
		end

		return pConvScreen
	end

	if (screenID == "barc_disks_all") then
		self:removeSpecialItems(pPlayer, "Aratech Repulsor Company Disk")
		self:giveBarcSpeederDeed(pPlayer)
	end

	if (screenID == "holocron_splinter_all") then
		self:removeSpecialItems(pPlayer, "Holocron Splinter")
		self:giveInfusedLightsaberCrystal(pPlayer)
	end


	local skillList

	if (screenID == "msg2_1") then
		pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		skillList = SkillTrainer:getTeachableSkills(pPlayer, trainerType, true)

		if (#skillList == 0) then
			clonedConversation:setDialogTextStringId(stringTable .. "msg3_1")
			clonedConversation:addOption("@skill_teacher:opt1_1", "msg2_1")
			clonedConversation:addOption("@skill_teacher:opt1_2", "msg2_2")
		else
			clonedConversation:setDialogTextStringId(stringTable .. screenID)
			pConvScreen = self:addSkillResponses(pConvScreen, skillList, stringTable, "learn")
		end
	elseif (screenID == "msg2_2") then
		pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		clonedConversation:setDialogTextStringId(stringTable .. screenID)
		skillList = SkillTrainer:getTeachableSkills(pPlayer, trainerType, false)
		pConvScreen = self:addSkillResponses(pConvScreen, skillList, stringTable, "info")
	elseif (screenID == "cancel_learn") then
		pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		clonedConversation:setDialogTextStringId(stringTable .. "msg_no")
		deleteData(playerID .. ":trainerTeachSkill")
	elseif (screenID == "topped_out") then
		pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		clonedConversation:setDialogTextStringId(stringTable .. "topped_out")
	elseif (screenID == "no_qualify") then
		pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		clonedConversation:setDialogTextStringId(stringTable .. "no_qualify")

		SkillTrainer:sendPrereqSui(pPlayer, pNpc, trainerType)
	elseif (screenID == "nsf_skill_points") then
		skillList = SkillTrainer:getTeachableSkills(pPlayer, trainerType, true)
		local skillNum = readData(playerID .. ":trainerTeachSkill")

		pConvScreen = self:handleNsfSkillPointsScreen(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen, trainerType, stringTable, skillList, skillNum)
	elseif (screenID == "confirm_learn") then
		skillList = SkillTrainer:getTeachableSkills(pPlayer, trainerType, true)
		local skillNum = readData(playerID .. ":trainerTeachSkill")

		pConvScreen = self:handleConfirmLearnScreen(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen, trainerType, stringTable, skillList, skillNum)
	elseif (screenID == "learn") then
		skillList = SkillTrainer:getTeachableSkills(pPlayer, trainerType, true)
		local skillNum = math.floor(selectedOption + 1)

		pConvScreen = self:handleLearnScreen(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen, trainerType, stringTable, skillList, skillNum)
	elseif (screenID == "info") then
		pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		skillList = SkillTrainer:getTeachableSkills(pPlayer, trainerType, false)
		local skillNum = math.floor(selectedOption + 1)
		local skillName = skillList[skillNum]

		clonedConversation:setDialogTextStringId(stringTable .. "msg3_3")
		clonedConversation:addOption("@skill_teacher:opt1_1", "msg2_1")
		clonedConversation:addOption("@skill_teacher:opt1_2", "msg2_2")
		SkillTrainer:sendSkillInfoSui(pPlayer, pNpc, skillName)
	end

	return pConvScreen
end

function trainerConvHandler:addSkillResponses(pConvScreen, skillList, stringTable, optionTag)
	local clonedConversation = LuaConversationScreen(pConvScreen)

	for i = 1, #skillList, 1 do
		clonedConversation:addOption("@skl_n:" .. skillList[i], optionTag)
	end

	clonedConversation:addOption("@skill_teacher:back", "intro")

	return pConvScreen
end

function trainerConvHandler:handleLearnScreen(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen, trainerType, stringTable, skillList, skillNum)
	local screen = LuaConversationScreen(pConvScreen)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	if (skillNum == nil) then
		printLuaError("Nil skillNum sent to handleLearnScreen for trainer type " .. trainerType)
		return pConvScreen
	elseif (skillNum <= 0) then
		printLuaError("Invalid skillNum (" .. skillNum .. ") sent to handleLearnScreen for trainer type " .. trainerType)
		return pConvScreen
	end

	local skillName = skillList[skillNum]
	local skillManager = LuaSkillManager()

	if (skillName == nil or skillName == "") then
		printLuaError(CreatureObject(pPlayer):getFirstName() .. " tried to learn a nil or empty skillName using trainer type " .. trainerType .. ", skillNum of " .. skillNum .. " with a table size of " .. #skillList)
		return pConvScreen
	end

	local pSkill = skillManager:getSkill(skillName)

	if (pSkill == nil) then
		return pConvScreen
	end

	local skillStringId = getStringId("@skl_n:" .. skillName)
	local skillObject = LuaSkill(pSkill)

	local moneyRequired = skillObject:getMoneyRequired()
	local persuasion = CreatureObject(pPlayer):getSkillMod("force_persuade")

	if (persuasion > 0) then
		moneyRequired = moneyRequired - ((moneyRequired * persuasion) / 100)
	end

	clonedConversation:setDialogTextStringId(stringTable .. "prose_cost")
	clonedConversation:setDialogTextDI(moneyRequired)
	clonedConversation:setDialogTextTO(skillStringId)

	writeData(SceneObject(pPlayer):getObjectID() .. ":trainerTeachSkill", skillNum)
	clonedConversation:addOption("@skill_teacher:yes", "confirm_learn")
	clonedConversation:addOption("@skill_teacher:no", "cancel_learn")

	return pConvScreen
end

function trainerConvHandler:handleConfirmLearnScreen(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen, trainerType, stringTable, skillList, skillNum)
	local screen = LuaConversationScreen(pConvScreen)

	if (skillNum == nil) then
		printLuaError("Nil skillNum sent to handleConfirmLearnScreen for trainer type " .. trainerType)
		return pConvScreen
	elseif (skillNum <= 0) then
		printLuaError("Invalid skillNum (" .. skillNum .. ") sent to handleConfirmLearnScreen for trainer type " .. trainerType)
		return pConvScreen
	end

	local skillName = skillList[skillNum]
	local skillManager = LuaSkillManager()

	if (skillName == nil or skillName == "") then
		printLuaError(CreatureObject(pPlayer):getFirstName() .. " tried to learn a nil or empty skillName using trainer type " .. trainerType .. ", skillNum of " .. skillNum .. " with a table size of " .. #skillList)
		return pConvScreen
	end

	local pSkill = skillManager:getSkill(skillName)

	if (pSkill == nil) then
		return pConvScreen
	end

	local skillStringId = getStringId("@skl_n:" .. skillName)
	local skillObject = LuaSkill(pSkill)

	local moneyRequired = skillObject:getMoneyRequired()
	local persuasion = CreatureObject(pPlayer):getSkillMod("force_persuade")

	if (persuasion > 0) then
		moneyRequired = moneyRequired - ((moneyRequired * persuasion) / 100)
	end

	local cashCredits = CreatureObject(pPlayer):getCashCredits()
	local bankCredits = CreatureObject(pPlayer):getBankCredits()
	local playerCredits = cashCredits + bankCredits

	if playerCredits < moneyRequired then
		local messageString = LuaStringIdChatParameter(stringTable .. "prose_nsf")
		messageString:setDI(moneyRequired)
		messageString:setTO(skillStringId)
		CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())

		local convoTemplate = LuaConversationTemplate(pConvTemplate)
		pConvScreen = convoTemplate:getScreen("intro")
		return self:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	end

	if (not skillManager:canLearnSkill(pPlayer, skillName, true)) then
		local convoTemplate = LuaConversationTemplate(pConvTemplate)
		pConvScreen = convoTemplate:getScreen("nsf_skill_points")
		return self:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	end

	local success = skillManager:awardSkill(pPlayer, skillName)

	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	if (success) then
		local messageString = LuaStringIdChatParameter(stringTable .. "prose_pay")
		messageString:setDI(moneyRequired)
		messageString:setTO(skillStringId)
		CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())

		if (moneyRequired <= cashCredits) then
			CreatureObject(pPlayer):subtractCashCredits(moneyRequired)
		else
			bankRequired = moneyRequired - cashCredits
			CreatureObject(pPlayer):subtractCashCredits(cashCredits)
			CreatureObject(pPlayer):subtractBankCredits(bankRequired)
		end

		local messageString = LuaStringIdChatParameter(stringTable .. "prose_skill_learned")
		messageString:setTO(skillStringId)
		CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())
		clonedConversation:setDialogTextStringId(stringTable .. "msg3_2")

		local pGhost = CreatureObject(pPlayer):getPlayerObject()

		if (pGhost ~= nil and PlayerObject(pGhost):isJediTrainer(pNpc) and not CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03") and not JediTrials:isOnKnightTrials(pPlayer) and JediTrials:isEligibleForKnightTrials(pPlayer)) then
			KnightTrials:startKnightTrials(pPlayer)
		end
	else
		local messageString = LuaStringIdChatParameter(stringTable .. "prose_train_failed")
		messageString:setTO(skillStringId)
		CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())
		clonedConversation:setDialogTextStringId(stringTable .. "error_grant_skill")
	end

	if (SkillTrainer:hasSurpassedTrainer(pPlayer, trainerType)) then
		clonedConversation:setDialogTextStringId(stringTable .. "surpass_trainer")
		clonedConversation:setDialogTextTT(CreatureObject(pPlayer):getFirstName())
		clonedConversation:setStopConversation(true)

		return pConvScreen
	end

	deleteData(SceneObject(pPlayer):getObjectID() .. ":trainerTeachSkill")

	clonedConversation:addOption("@skill_teacher:opt1_1", "msg2_1")
	clonedConversation:addOption("@skill_teacher:opt1_2", "msg2_2")

	return pConvScreen
end

function trainerConvHandler:handleNsfSkillPointsScreen(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen, trainerType, stringTable, skillList, skillNum)
	local screen = LuaConversationScreen(pConvScreen)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	if (skillNum == nil) then
		printLuaError("Nil skillNum sent to handleNsfSkillPointsScreen for trainer type " .. trainerType)
		return pConvScreen
	elseif (skillNum <= 0) then
		printLuaError("Invalid skillNum (" .. skillNum .. ") sent to handleNsfSkillPointsScreen for trainer type " .. trainerType)
		return pConvScreen
	end

	local skillName = skillList[skillNum]

	if (skillName == nil or skillName == "") then
		printLuaError(CreatureObject(pPlayer):getFirstName() .. " tried to learn a nil or empty skillName using trainer type " .. trainerType .. ", skillNum of " .. skillNum .. " with a table size of " .. #skillList)
		return pConvScreen
	end

	local skillManager = LuaSkillManager()

	local pSkill = skillManager:getSkill(skillName)

	if (pSkill == nil) then
		return pConvScreen
	end

	local skillObject = LuaSkill(pSkill)

	local pointsReq = skillObject:getSkillPointsRequired()
	local skillStringId = getStringId("@skl_n:" .. skillName)

	clonedConversation:setDialogTextStringId(stringTable .. "nsf_skill_pts")
	clonedConversation:setDialogTextDI(pointsReq)
	clonedConversation:setDialogTextTO(skillStringId)

	clonedConversation:addOption("@skill_teacher:opt1_1", "msg2_1")
	clonedConversation:addOption("@skill_teacher:opt1_2", "msg2_2")

	return pConvScreen
end
