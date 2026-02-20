PlayerTriggers = { }

function PlayerTriggers:playerLoggedIn(pPlayer)
	if (pPlayer == nil) then
		return
	end
	ServerEventAutomation:playerLoggedIn(pPlayer)
	BestineElection:playerLoggedIn(pPlayer)
	CustomGlowingScreenPlay:playerLoggedIn(pPlayer)
	DedleeSynScreenPlay:playerLoggedIn(pPlayer)
	GCWEncounters:onPlayerLoggedIn(pPlayer)
	ArenaInvite:onPlayerLoggedIn(pPlayer)
	RewardFirst:onPlayerLoggedIn(pPlayer)
	RewardSecond:onPlayerLoggedIn(pPlayer)
	RewardThird:onPlayerLoggedIn(pPlayer)
end

function PlayerTriggers:playerLoggedOut(pPlayer)
	if (pPlayer == nil) then
		return
	end
	ServerEventAutomation:playerLoggedOut(pPlayer)
end
