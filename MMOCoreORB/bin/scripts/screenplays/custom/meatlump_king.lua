MeatlumpKingScreenPlay = ScreenPlay:new {
  numberOfActs = 1,
  AdminPlayerID = 281474993547517, -- PlayerID of Admin character
  screenplayName = "MeatlumpKingScreenPlay",
  respawnFrequency = 86400 * 1000, -- 24 Hours
  -- respawnFrequency = 60 * 1000, -- 60 seconds
}

registerScreenPlay("MeatlumpKingScreenPlay", true)

function MeatlumpKingScreenPlay:start()
  local pPlayer = getCreatureObject(self.AdminPlayerID)
	local offlineMode = false
	if (pPlayer == nil) then
			pPlayer = getObjectFromDatabase(self.AdminPlayerID)
			if (pPlayer ~= nil) then
					offlineMode = true
			end
	end

  self:respawn(pPlayer)
end

function MeatlumpKingScreenPlay:respawn(pPlayer)
  MeatlumpKingTheatre:start(pPlayer)
  createEvent(self.respawnFrequency, "MeatlumpKingTheatre", "finishUpTask", pPlayer, "")
end
