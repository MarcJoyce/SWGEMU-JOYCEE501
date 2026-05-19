local QuestManager = require("managers.quest.quest_manager")

jediShopKeeperConvoHandler = conv_handler:new {}

function jediShopKeeperConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  local playerID = SceneObject(pPlayer):getObjectID()

  local accountID = 0
  -- local pAdminPlayer = getCreatureObject(281474993547517)

  local specialGrants = {
		["281474997062566"] = { xpType = "force_rank_xp", amount = 125000 }
	}

	-- Have used the following

	-- Current :refund_frs_item

	local pid = tostring(playerID)
	local grant = specialGrants[pid]

	if (grant) then
		local givenKey = ":refund_frs_item"
		local already = tonumber(readScreenPlayData(pPlayer, "ForceRankXp", givenKey)) or 0

		if (already == 0) then
			CreatureObject(pPlayer):awardExperience(grant.xpType, grant.amount, true)
			writeScreenPlayData(pPlayer, "ForceRankXp", givenKey, 1)
		end
	end

  -- return convoTemplate:getScreen("wip")
  return convoTemplate:getScreen("greeting")
end

function jediShopKeeperConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
    local screen = LuaConversationScreen(pConvScreen)

    local convoTemplate = LuaConversationTemplate(pConvTemplate)
    local pConvScreen = screen:cloneScreen()
    local clonedConversation = LuaConversationScreen(pConvScreen)

    local screenID = screen:getScreenID()
    -- local playerID = SceneObject(pPlayer):getObjectID()
    -- local npcID = SceneObject(pNpc):getObjectID()

    local pGhost = CreatureObject(pPlayer):getPlayerObject()

    -- local pAdminPlayer = getCreatureObject(281474993547517)

    local frsXp = PlayerObject(pGhost):getExperience("force_rank_xp")

    -- -- if (screenID == "goodbye") then
    -- --   CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\The shop keeper is still working on his dialogue, but he will have more to say soon. Please check in with Stan, our fearless leader, for all your force related needs.")
    -- -- end

    if (screenID == "what_do_you_sell") then
        if (frsXp > 50) then
          -- clonedConversation:addOption("50FRS xp - Random Color Crystal", "color_crystal")
        end
        if (frsXp > 500) then
          clonedConversation:addOption("500FRS xp - Power Crystal", "power_crystal")
          clonedConversation:addOption("500FRS xp - Krayt Dragon Pearl", "pearl")
        end

        if (frsXp > 10000) then
          clonedConversation:addOption("10,000FRS xp - Random Named Color Crystal", "named_crystal")
        end

        if (frsXp > 25000) then
          clonedConversation:addOption("25,000FRS xp - B'nars Sacrifice", "bnars_sacrifice")
          clonedConversation:addOption("25,000FRS xp - Baas Wisdom", "baass_wisdom")
          clonedConversation:addOption("25,000FRS xp - Banes Heart", "banes_heart")
          clonedConversation:addOption("25,000FRS xp - Bondaras Folly", "bondaras_folly")
          clonedConversation:addOption("25,000FRS xp - Dawn of Dagobah", "dawn_of_dagobah")
          clonedConversation:addOption("25,000FRS xp - Gallias Intuition", "gallias_intuition")
          clonedConversation:addOption("25,000FRS xp - Horns Future", "horns_future")
          clonedConversation:addOption("25,000FRS xp - Kenobi's Legacy", "kenobis_legacy")
          clonedConversation:addOption("25,000FRS xp - Kit's Ferocity", "kits_ferocity")
          clonedConversation:addOption("25,000FRS xp - Kun's Blood", "kuns_blood")
          clonedConversation:addOption("25,000FRS xp - Maul's Vengence", "mauls_vengence")
          clonedConversation:addOption("25,000FRS xp - Mundi's Response", "mundis_response")
          clonedConversation:addOption("25,000FRS xp - Prowess of Plo Koon", "prowess_of_plo_koon")
          clonedConversation:addOption("25,000FRS xp - Qui-Gon's Devotion", "qui_gons_devotion")
          clonedConversation:addOption("25,000FRS xp - Quintessence of the Force", "quintessence_of_the_force")
          clonedConversation:addOption("25,000FRS xp - Strength of Luminaria", "strength_of_luminaria")
          clonedConversation:addOption("25,000FRS xp - Sunrider's Destiny", "sunriders_destiny")
          clonedConversation:addOption("25,000FRS xp - Ulic's Redemption", "ulics_redemption")
          clonedConversation:addOption("25,000FRS xp - Windu's Guile", "windus_guile")
        end
    elseif (screenID == "color_crystal") then
      self:giveLoot(pPlayer, "force_color_crystal")
      self:doXp(pPlayer, 50)
    elseif (screenID == "power_crystal") then
      self:giveLoot(pPlayer, "power_crystals")
      self:doXp(pPlayer, 500)
    elseif (screenID == "pearl") then
      self:giveLoot(pPlayer, "krayt_pearls")
      self:doXp(pPlayer, 500)
    elseif (screenID == "named_crystal") then
      self:giveLoot(pPlayer, "named_crystals")
      self:doXp(pPlayer, 10000)
    elseif (screenID == "bnars_sacrifice") then
      self:giveLoot(pPlayer, "crystal_bnars_sacrifice")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "baass_wisdom") then
      self:giveLoot(pPlayer, "crystal_baass_wisdom")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "banes_heart") then
      self:giveLoot(pPlayer, "crystal_banes_heart")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "bondaras_folly") then
      self:giveLoot(pPlayer, "crystal_bondaras_folly")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "dawn_of_dagobah") then
      self:giveLoot(pPlayer, "crystal_dawn_of_dagobah")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "gallias_intuition") then
      self:giveLoot(pPlayer, "crystal_gallias_intuition")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "horns_future") then
      self:giveLoot(pPlayer, "crystal_horns_future")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "kenobis_legacy") then
      self:giveLoot(pPlayer, "crystal_kenobis_legacy")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "kits_ferocity") then
      self:giveLoot(pPlayer, "crystal_kits_ferocity")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "kuns_blood") then
      self:giveLoot(pPlayer, "crystal_kuns_blood")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "mauls_vengence") then
      self:giveLoot(pPlayer, "crystal_mauls_vengence")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "mundis_response") then
      self:giveLoot(pPlayer, "crystal_mundis_response")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "prowess_of_plo_koon") then
      self:giveLoot(pPlayer, "crystal_prowess_of_plo_koon")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "qui_gons_devotion") then
      self:giveLoot(pPlayer, "crystal_qui_gons_devotion")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "quintessence_of_the_force") then
      self:giveLoot(pPlayer, "crystal_quintessence_of_the_force")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "strength_of_luminaria") then
      self:giveLoot(pPlayer, "crystal_strength_of_luminaria")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "sunriders_destiny") then
      self:giveLoot(pPlayer, "crystal_sunriders_destiny")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "ulics_redemption") then
      self:giveLoot(pPlayer, "crystal_ulics_redemption")
      self:doXp(pPlayer, 25000)
    elseif (screenID == "windus_guile") then
      self:giveLoot(pPlayer, "crystal_windus_guile")
      self:doXp(pPlayer, 25000)
    end

    return pConvScreen
end

function jediShopKeeperConvoHandler:doXp(pPlayer, amount) 
  CreatureObject(pPlayer):awardExperience("force_rank_xp", amount * -1, false)
  CreatureObject(pPlayer):sendSystemMessage("You purchase the item and paid with " .. amount .. " force rank xp.")
end

function jediShopKeeperConvoHandler:giveLoot(pPlayer, lootGroup)
	if (pPlayer == nil) then
		return
	end

	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")

	if pInventory == nil then
		return
	end

  logToFile(CreatureObject(pPlayer):getFirstName() .. " purchased " .. lootGroup, "log/jedi_shop_keeper_convo_handler.log")
	createLoot(pInventory, lootGroup, 0, true)
end