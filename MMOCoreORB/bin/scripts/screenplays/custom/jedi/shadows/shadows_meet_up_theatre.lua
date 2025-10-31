local ObjectManager = require("managers.object.object_manager")
local QuestManager = require("managers.quest.quest_manager")
local SpawnMobiles = require("utils.spawn_mobiles")

require("utils.helpers")

ShadowsMeetUpTheatre = GoToTheater:new {
	-- Task properties
	taskName = "ShadowsMeetUpTheatre",
	-- GoToTheater properties
	planet = "dathomir",
	minimumDistance = 8192,
	maximumDistance = 10240,
	theater = {
		-- { template = "object/static/structure/military/military_wall_med_imperial_style_01.iff", xDiff = 0.5, zDiff = -0.11, yDiff = 2.12, heading = -14.32 },
		-- { template = "object/static/structure/military/military_column_med_imperial_style_01.iff", xDiff = -3.84, zDiff = -0.11, yDiff = 1.098, heading = -14.32 },
		-- { template = "object/static/structure/military/military_column_med_imperial_style_01.iff", xDiff = 4.95, zDiff = -0.1, yDiff = 3.24, heading = -14.32 },
		{ template = "object/static/structure/naboo/poi_nboo_tent_small.iff", xDiff = -1.61, zDiff = 0.32, yDiff = -6.46, heading = 14.32 }
	},
	waypointDescription = "Answers...",
	mobileListWithLoc = {
		-- { template = "shadows_sister_one", x = 1.146, y = -0.849 },
		{ template = "shadows_guard", x = 2.42, y = 1.669 },
		{ template = "shadows_guard", x = -0.127, y = -3.36 }
	},
	activeAreaRadius = 64,
  flattenLayer = true
}

function ShadowsMeetUpTheatre:onEnteredActiveArea(pPlayer, mobileList)
	if (pPlayer == nil or mobileList  == nil) then
		return
	end

  for i = 1, #mobileList do
    if (not i == 1) then
      if (SpawnMobiles.isValidMobile(mobileList[i])) then
        AiAgent(mobileList[i]):setDefender(pPlayer)
			end
    end
  end
end

function ShadowsMeetUpTheatre:handleExitedMissionAreaEvent(pActiveArea, pPlayer, nothing)
	if (not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	self:finish(pPlayer)
	return 1
end

function ShadowsMeetUpTheatre:onObjectsSpawned(pPlayer, mobileList)
	if (pPlayer == nil) then
		return
	end

	if (SpawnMobiles.isValidMobile(mobileList[1])) then
		AiAgent(mobileList[1]):addObjectFlag(AI_STATIONARY)
		CreatureObject(mobileList[1]):setPvpStatusBitmask(0)
	end
end

return ShadowsMeetUpTheatre
