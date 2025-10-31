dedleeSynConvoHandler = conv_handler:new {}

function dedleeSynConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  if (CreatureObject(pPlayer):hasScreenPlayState(1, "dedlee_syn")) then
    return convoTemplate:getScreen("first_screen_has_met")
  else 
    return convoTemplate:getScreen("first_screen_not_met")
  end
end

function dedleeSynConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
  local screen = LuaConversationScreen(pConvScreen)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)
  local pConvScreen = screen:cloneScreen()
  local clonedConversation = LuaConversationScreen(pConvScreen)

  local screenID = screen:getScreenID()
  local playerID = SceneObject(pPlayer):getObjectID()
  local npcID = SceneObject(pNpc):getObjectID()

  local pGhost = CreatureObject(pPlayer):getPlayerObject()
  local accountID = PlayerObject(pGhost):getAccountID()

  local pAdminPlayer = getCreatureObject(281475000105551)
  local huntTarget = readScreenPlayData(pAdminPlayer, "DedleeSynScreenPlay", "huntTargetMessage")
  local huntCount = tonumber(readScreenPlayData(pPlayer, "DedleeSynScreenPlay", "huntCount")) or 0

  local weaponsMap = {
    cdefcarbine = "object/weapon/ranged/carbine/carbine_cdef.iff",
    corseccdefcarbine = "object/weapon/ranged/carbine/carbine_cdef_corsec.iff",
    dh17carbine = "object/weapon/ranged/carbine/carbine_dh17.iff",
    dh17blackcarbine = "object/weapon/ranged/carbine/carbine_dh17_black.iff",
    dh17shortcarbine = "object/weapon/ranged/carbine/carbine_dh17_snubnose.iff",
    dxr6carbine = "object/weapon/ranged/carbine/carbine_dxr6.iff",
    e11carbine = "object/weapon/ranged/carbine/carbine_e11.iff",
    enhancede11carbine = "object/weapon/ranged/carbine/carbine_e11_quest.iff",
    lithitaniumcarbine = "object/weapon/ranged/carbine/carbine_e11_victor_quest.iff",
    ee3carbine = "object/weapon/ranged/carbine/carbine_ee3.iff",
    elitecarbine = "object/weapon/ranged/carbine/carbine_elite.iff",
    lasercarbine = "object/weapon/ranged/carbine/carbine_laser.iff",
    nymscarbine = "object/weapon/ranged/carbine/carbine_nym_slugthrower.iff",
    flamethrower = "object/weapon/ranged/rifle/rifle_flame_thrower.iff",
    heavyacidrifle = "object/weapon/ranged/rifle/rifle_acid_beam.iff",
    lightlightningcannon = "object/weapon/ranged/rifle/rifle_lightning.iff",
    sword = "object/weapon/melee/sword/sword_01.iff",
    curvedsword = "object/weapon/melee/sword/sword_02.iff",
    ryykblade = "object/weapon/melee/sword/sword_blade_ryyk.iff",
    curvednyaxsword = "object/weapon/melee/sword/sword_curved_nyax.iff",
    nyaxsword = "object/weapon/melee/sword/sword_nyax.iff",
    rantok = "object/weapon/melee/sword/sword_rantok.iff",
    vibroblade = "object/weapon/melee/knife/knife_vibroblade.iff",
    jaggedvibroblade = "object/weapon/melee/knife/knife_vibroblade_quest.iff",
    stunbaton = "object/weapon/melee/baton/baton_stun.iff",
    gaderiffibaton = "object/weapon/melee/baton/baton_gaderiffi.iff",
    blackmetalgaderiffibaton = "object/weapon/melee/baton/victor_baton_gaderiffi.iff",
    cdefpistol = "object/weapon/ranged/pistol/pistol_cdef.iff",
    corseccdefpistol = "object/weapon/ranged/pistol/pistol_cdef_corsec.iff",
    d18pistol = "object/weapon/ranged/pistol/pistol_d18.iff",
    de10pistol = "object/weapon/ranged/pistol/pistol_de_10.iff",
    dh17pistol = "object/weapon/ranged/pistol/pistol_dh17.iff",
    dl44pistol = "object/weapon/ranged/pistol/pistol_dl44.iff",
    dl44metalpistol = "object/weapon/ranged/pistol/pistol_dl44_metal.iff",
    dx2pistol = "object/weapon/ranged/pistol/pistol_dx2.iff",
    fwg5pistol = "object/weapon/ranged/pistol/pistol_fwg5.iff",
    featherweightfwg5pistol = "object/weapon/ranged/pistol/pistol_fwg5_quest.iff",
    geonosiansonicblaster = "object/weapon/ranged/pistol/pistol_geonosian_sonic_blaster_loot.iff",
    launcherpistol = "object/weapon/ranged/pistol/pistol_launcher.iff",
    power5pistol = "object/weapon/ranged/pistol/pistol_power5.iff",
    republicblaster = "object/weapon/ranged/pistol/pistol_republic_blaster.iff",
    modifiedrepublicblaster = "object/weapon/ranged/pistol/pistol_republic_blaster_quest.iff",
    scatterpistol = "object/weapon/ranged/pistol/pistol_scatter.iff",
    scoutblaster = "object/weapon/ranged/pistol/pistol_scout_blaster.iff",
    srcombatpistol = "object/weapon/ranged/pistol/pistol_srcombat.iff",
    strikerpistol = "object/weapon/ranged/pistol/pistol_striker.iff",
    tanglepistol = "object/weapon/ranged/pistol/pistol_tangle.iff",
    lance = "object/weapon/melee/polearm/lance_controllerfp.iff",
    nightsisterlance = "object/weapon/melee/polearm/lance_controllerfp_nightsister.iff",
    nightsisterenergylance = "object/weapon/melee/polearm/lance_nightsister.iff",
    jantastaff = "object/weapon/melee/polearm/lance_staff_janta.iff",
    metalstaff = "object/weapon/melee/polearm/lance_staff_metal.iff",
    vibrolance = "object/weapon/melee/polearm/lance_vibrolance.iff",
    longvibroaxe = "object/weapon/melee/polearm/polearm_vibro_axe.iff",
    woodstaff = "object/weapon/melee/polearm/lance_staff_wood_s1.iff",
    reinforcedcombatstaff = "object/weapon/melee/polearm/lance_staff_wood_s2.iff",
    berserkerrifle = "object/weapon/ranged/rifle/rifle_berserker.iff",
    bowcaster = "object/weapon/ranged/rifle/rifle_bowcaster.iff",
    cdefrifle = "object/weapon/ranged/rifle/rifle_cdef.iff",
    dlt20rifle = "object/weapon/ranged/rifle/rifle_dlt20.iff",
    dlt20arifle = "object/weapon/ranged/rifle/rifle_dlt20a.iff",
    e11rifle = "object/weapon/ranged/rifle/rifle_e11.iff",
    ewokcrossbow = "object/weapon/ranged/rifle/rifle_ewok_crossbow.iff",
    jawaionrifle = "object/weapon/ranged/rifle/rifle_jawa_ion.iff",
    laserrifle = "object/weapon/ranged/rifle/rifle_laser.iff",
    lithitaniumrifle = "object/weapon/ranged/rifle/rifle_victor_tusken.iff",
    sg82rifle = "object/weapon/ranged/rifle/rifle_sg82.iff",
    spraystick = "object/weapon/ranged/rifle/rifle_spraystick.iff",
    tenlossdxr6disruptorrifle = "object/weapon/ranged/rifle/rifle_tenloss_dxr6_disruptor_loot.iff",
    t21 = "object/weapon/ranged/rifle/rifle_t21.iff",
    tuskenrifle = "object/weapon/ranged/rifle/rifle_tusken.iff",
    twohandedcurvedsword = "object/weapon/melee/2h_sword/2h_sword_katana.iff",
    groovedtwohandedcurvedsword = "object/weapon/melee/2h_sword/2h_sword_katana_quest.iff",
    scytheblade = "object/weapon/melee/2h_sword/2h_sword_scythe.iff",
    powerhammer = "object/weapon/melee/2h_sword/2h_sword_maul.iff",
    twohandedcleaver = "object/weapon/melee/2h_sword/2h_sword_cleaver.iff",
    blacksunexecutionershack = "object/weapon/melee/2h_sword/2h_sword_blacksun_hack.iff",
    gamorreanbattleaxe = "object/weapon/melee/2h_sword/2h_sword_battleaxe_quest.iff",
    heavyaxe = "object/weapon/melee/axe/axe_heavy_duty.iff",
    vibroaxe = "object/weapon/melee/axe/axe_vibroaxe.iff",
    vibroknuckler = "object/weapon/melee/special/vibroknuckler.iff",
    blacksunrazorknuckler = "object/weapon/melee/special/blacksun_razor.iff",
  }

  local damageTypeMap = {
    kin = 1,
    ene = 2,
    bla = 4,
    stu = 8,
    hea = 32,
    col = 64,
    aci = 128,
    ele = 256
  }

  local tokensToSpendMap = {
    twentyfive = 25,
    fifty = 50,
    onehundred = 100
  }

  local weaponSelection = readScreenPlayData(pPlayer, "DedleeSynScreenPlay", "weaponSelection")
  local damageTypeSelection = tonumber(readScreenPlayData(pPlayer, "DedleeSynScreenPlay", "damageTypeSelection")) or 0

  -- DedleeSynScreenPlay:log("DedleeSyn debug: Weapon: " .. weaponSelection .. ". DamageType: " .. damageTypeSelection)

  -- Screen handling
  if screenID == "information" then
    if not CreatureObject(pPlayer):hasScreenPlayState(1, "dedlee_syn") then
      CreatureObject(pPlayer):setScreenPlayState(1, "dedlee_syn")
      DedleeSynScreenPlay:joinTheHunt(pPlayer)
    end
    CreatureObject(pPlayer):sendSystemMessage("Hunt target is: " .. huntTarget)

  elseif screenID == "score" then
    CreatureObject(pPlayer):sendSystemMessage("Tokens: " .. huntCount)

  elseif screenID == "shop" then
    if huntCount < 25 then
      clonedConversation:setCustomDialogText("You don't have enough tokens to purchase anything yet. Keep killing and come back when you have at least 25 tokens.")
      clonedConversation:addOption("Remind me, what's this all about?", "information")
      clonedConversation:addOption("How many tokens have I earned so far?", "score")
    else
      clonedConversation:addOption("A ranged weapon", "ranged")
      clonedConversation:addOption("A melee weapon", "melee")
      clonedConversation:addOption("Remind me, what's this all about?", "information")
      clonedConversation:addOption("How many tokens have I earned so far?", "score")
    end

  elseif damageTypeMap[screenID] then
    deleteScreenPlayData(pPlayer, "DedleeSynScreenPlay", "damageTypeSelection")
    writeScreenPlayData(pPlayer, "DedleeSynScreenPlay", "damageTypeSelection", damageTypeMap[screenID])
    
    if huntCount >= 25 then
      clonedConversation:addOption("25.", "twentyfive")
    end
    if huntCount >= 50 then
      clonedConversation:addOption("50.", "fifty")
    end
    if huntCount >= 100 then
      clonedConversation:addOption("100.", "onehundred")
    end

  elseif weaponsMap[screenID] then
    deleteScreenPlayData(pPlayer, "DedleeSynScreenPlay", "weaponSelection")
    writeScreenPlayData(pPlayer, "DedleeSynScreenPlay", "weaponSelection", weaponsMap[screenID])

  elseif tokensToSpendMap[screenID] then
    local tokensToSpend = tokensToSpendMap[screenID]
    local newHuntCount = huntCount - tokensToSpend

    generateWeapon(pPlayer, weaponSelection, damageTypeSelection, tokensToSpend)

    deleteScreenPlayData(pPlayer, "DedleeSynScreenPlay", "huntCount")
    writeScreenPlayData(pPlayer, "DedleeSynScreenPlay", "huntCount", newHuntCount)
  end

  return pConvScreen
end
