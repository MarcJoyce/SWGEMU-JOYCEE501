local ObjectManager = require("managers.object.object_manager")
local Logger = require("utils.logger")

ShadowsScreenPlay = ScreenPlay:new {}

registerScreenPlay("ShadowsScreenPlay", true)

function ShadowsScreenPlay:start()
  if (isZoneEnabled("yavin4")) then
    self:spawnShadowsTwo()
  end
end

function ShadowsScreenPlay:playerLoggedIn(pPlayer)
  ShadowsIntroTheatre:finish(pPlayer)
  -- ShadowsMeetUpTheatre:finish(pPlayer)

  if (not CreatureObject(pPlayer):hasScreenPlayState(2, "shadows_one") and CreatureObject(pPlayer):hasScreenPlayState(1, "shadows_one")) then
    ShadowsIntroTheatre:start(pPlayer)
  end

  if (not CreatureObject(pPlayer):hasScreenPlayState(2, "shadows_three") and CreatureObject(pPlayer):hasScreenPlayState(1, "shadows_three")) then
    ShadowsMeetUpTheatre:start(pPlayer)
  end

end

function ShadowsScreenPlay:spawnShadowsTwo()
  local spawnedSceneObject = LuaSceneObject(nil)
  local spawnedPointer = spawnSceneObject("yavin4", "object/tangible/container/drum/tatt_drum_1.iff", -335, 11.4, 1044, 0, 257);

  if (spawnedPointer ~= nil) then
    spawnedSceneObject:_setObject(spawnedPointer)
    SceneObject(spawnedPointer):setContainerInheritPermissionsFromParent(false)
	  SceneObject(spawnedPointer):setContainerDefaultDenyPermission(MOVEIN)
	  SceneObject(spawnedPointer):setContainerDefaultAllowPermission(OPEN + MOVEOUT)
    createObserver(OPENCONTAINER, "ShadowsGuardDetailScreenPlay", "boxLootedShadowsGuardDetail", spawnedPointer)
  end
  
  local pMobile = spawnMobile("yavin4", "shadows_exile", 300, -335, 11, 1041, 188, 0)
  AiAgent(pMobile):addObjectFlag(AI_STATIC)
  
  pMobile = spawnMobile("yavin4", "shadows_exile", 300, -337, 11, 1047, 279, 0)
  AiAgent(pMobile):addObjectFlag(AI_STATIC)

  spawnMobile("yavin4", "shadows_guard", 300, -340, 11, 1045, 0, 0)
  spawnMobile("yavin4", "shadows_guard", 300, -340, 11, 1045, 0, 0)
  spawnMobile("yavin4", "shadows_guard", 300, -340, 11, 1045, 0, 0)
end

function ShadowsScreenPlay:spawnSceneObjects()

end

function ShadowsScreenPlay:spawnMobiles()

end

function ShadowsScreenPlay:endShadowsIntroTheatre(pPlayer) 
  local pActiveArea = spawnActiveArea(CreatureObject(pPlayer):getZoneName(), "object/active_area.iff", SceneObject(pPlayer):getWorldPositionX(), 0, SceneObject(pPlayer):getWorldPositionY(), 150, 0)

  if (pActiveArea ~= nil) then
    createObserver(EXITEDAREA, "ShadowsIntroTheatre", "handleExitedMissionAreaEvent", pActiveArea)
  end
end

function ShadowsScreenPlay:startShadowsGuardDetail(pPlayer)
  local pGhost = CreatureObject(pPlayer):getPlayerObject()
  local playerID = SceneObject(pPlayer):getObjectID()
  local waypointID = PlayerObject(pGhost):addWaypoint("yavin4", "Guard Detail", "", -335, 11.4, 1044, WAYPOINT_COLOR_PURPLE, true, true, 0)
  setQuestStatus(playerID .. ":shadowsGuardDetailWaypointID", waypointID)
end

-- ## Questline Title: “Shadows of the Flame”

-- ### Theme: The cost of the Jedi path. Letting go of attachments. The pain of duty over emotion.

-- ---

-- ### Overview Premise:

-- Before fully committing to the Jedi path, the player must confront their past and sever ties that could lead to attachment, fear, and ultimately the dark side. This culminates in the player discovering an old friend or sibling who has turned to the dark side—either out of love, pain, or misguided loyalty. The final act is a tragic confrontation where redemption is no longer possible.

-- ---

-- ## Step-by-Step Breakdown:

-- ---

-- ### Step 1: A Whisper from the Past - go_to_theatre (sith_theatre_intro) x

--  Objective: Speak to an old family friend or mentor (static NPC).
--  Dialogue: They tell you someone from your past has been asking about you—worried, desperate. They feared you were in danger and were trying to find you.
--  Reward: New waypoint + holocron fragment.

-- ---

-- ### Step 2: Echoes on the Wind - loot container on yavin4 guarded by force exiles x

--  Objective: Retrieve a memory chip from a derelict datapad in a remote location.
--  Details: The chip contains a personal message from the person—a sibling, close friend, or lover figure (you can pick depending on backstory flexibility)—begging you to meet them.
--  Dialogue (chip): They're afraid, say the galaxy is broken, and they know things the Jedi won't tell you.
--  Reward: XP, small loot item.

-- ---

-- ### Step 3: Crossroads - narmle cantina x

--  Objective: Meet a contact in a seedy outpost (static NPC).
--  Info: The contact says the person you’re looking for has gotten involved with Force-sensitive outlaws or a rogue cult. They fear this person has “changed.”
--  Clue: They’ve been seen attacking slavers, bounty hunters, but also innocents.
--  Reward: Map to hideout.

-- ---

-- ### Step 4: Shadows Rising - korga stronghold (replace 1 side with force exiles and untrained dark jedi guarding loot box)

--  Objective: Explore a cave or abandoned base. Fight corrupted Force adepts or rogue followers.
--  End Encounter: You find a journal or another recording from the person. They believe the Jedi are lying, and want to protect you from their mistakes. They're embracing power to "save" you.
--  Emotional Beat: The person still loves you, but thinks you're being brainwashed.
--  Reward: XP + Lightsaber part or Force-sensitive trinket.

-- ---

-- ### Step 5: Council’s Concern - Jedi mentor talus in tent somewhere

--  Objective: Report findings to a Jedi Mentor NPC.
--  Dialogue: The Jedi reveals that the person is dangerously close to falling to the dark side. You must confront them, but try to bring them back if possible.
--  Moral Conflict: The Jedi warns that if they refuse redemption, you may have no choice but to end it.
--  Reward: Jedi Trial token (in-lore item).

-- ---

-- ### Step 6: Final Plea

--  Objective: Meet the person in a hidden temple ruin (new location).
--  Dialogue (Cinematic): They appear calm, nostalgic. Try to convince you to leave the Jedi. They talk about your shared past—childhood, dreams.
--  Player Options (Dialogue tree): Try to reason with them, remind them of hope, or warn them.
--  Outcome: They say if you choose the Jedi, they will stop you. They can’t lose you.
--  No combat yet. Emotional build-up only.

-- ---

-- ### Step 7: Descent

--  Objective: Return to Jedi Mentor.
--  Reveal: The Jedi has received word that your loved one has attacked a Jedi outpost. It’s no longer a personal matter.
--  Task: You are ordered to end it. Not as vengeance, but to protect others.
--  You are told: “This is your trial.”

-- ---

-- ### Step 8: The Flame Extinguished

--  Objective: Return to the ruins. Final confrontation with the NPC.
--  NPC is now hostile.
--  Before battle: They say one last line—“I loved you. But love made me weak.”
--  Fight ensues. Upon defeat, they collapse.
--  Death Dialogue: “You… chose them.” or “I was only trying… to save you.”
--  Reward: XP, Force unlock step/item, Jedi robe or symbolic memento (like a broken locket or ring).

-- ---