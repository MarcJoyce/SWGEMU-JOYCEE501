local ObjectManager = require("managers.object.object_manager")
local Logger = require("utils.logger")

DedleeSynScreenPlay = ScreenPlay:new {
  numberOfActs = 1,
  AdminPlayerID = 281475013738720, -- PlayerID of Admin character
  screenplayName = "DedleeSynScreenPlay",
  respawnFrequency = 1000 * 86400,
  spawns = {
    { "tusken_witch_doctor", "Tusken Witch Doctor" },
    { "tusken_observer", "Tusken Observer" },
    { "dark_jedi_knight", "Dark Jedi Knight" },
    { "spiderclan_elder", "SpiderClan Nightsister Elder" },
    { "nightsister_elder", "Nightsister Elder" },
    { "singing_mountain_clan_councilwoman", "Singing Mountain Clan Councilwoman" },
    { "krayt_dragon_ancient", "Ancient Krayt Dragon" },
  },
  messages = {
    "Boom! That one's not getting back up. Nice kill, ace. Remind me not to stand in your line of fire!",
    "Wasted! That was smoother than a speeder on cruise control. On to the next dance, partner.",
    "Confirmed kill! If you keep this up, we're gonna have to start charging admission.",
    "They never saw it coming-classic you. Let's keep this streak hotter than a twin-sunned tatoo.",
    "Another one bites the dust! You're making this look way too easy.",
    "That's a wrap for that poor soul! Someone call the med droid... or maybe just fetch a shovel.",
    "Bang! Headshot city. Are you secretly a droid, or just that damm good? Either way, we're impressed.",
    "Nice work! You're racking up more kills than a krayt dragon at a Jawa party.",
    "Target down. Dignity gone! Yours or theirs? Kidding. Let's keep this party going!",
    "You just sent that one to respawn purgatory. I hope they brought snacks.",
    "Whew! That folded faster than a sabaac rookie. Keep this up and you'll clear the whole sector solo.",
    "Zap! Target toasy. Remind me to stay behind you when the blasters start flying.",
    "Down they go! Bet they regret waking up today. You? You're just getting started.",
    "Another one deleted from the galaxy. Ever think about starting a killstreak fan club?",
    "They dropped like a malfunctioning probe droid. Your hit list better watch out!",
    "Nice work. If style points were credits, you'd be a billionaire by now.",
    "Target neutralized! You sure you're not a force-diety? Because that was scary smooth.",
    "Boom! That looked personal. Should I be worried... or just impressed?",
    "Another one down! You're cleaning house like a protocol droid with a grudge.",
    "Done and dusted! I swear you're farming kills like a moisture farmer chases rain.",
    "Damm, did that one owe you credits? Chasing cheques and breaking necks, am I right?!",
    "There's a rumour that when the boogeyman goes to sleep, he checks under his bed for you!"
  },
}

registerScreenPlay("DedleeSynScreenPlay", true)

function DedleeSynScreenPlay:start()
  if (isZoneEnabled("dathomir")) then
    self:spawnMobiles()
    self:setHuntMob()
  end
end

function DedleeSynScreenPlay:playerLoggedIn(pPlayer)
  dropObserver(KILLEDCREATURE, "DedleeSynScreenPlay", "notifyKilledCreature", pPlayer)
  if (CreatureObject(pPlayer):hasScreenPlayState(1, "dedlee_syn")) then
    createObserver(KILLEDCREATURE, "DedleeSynScreenPlay", "notifyKilledCreature", pPlayer)
  end
end

function DedleeSynScreenPlay:spawnMobiles() 
  spawnMobile("dathomir", "dedlee_syn", 300, -103.2, 18.0, -1618.8, 37.4151, 0)
end

function DedleeSynScreenPlay:setHuntMob()
  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)

  if (pAdminPlayer == nil) then
    self:log("pAdminPlayer is nil")
    return 0
  end

  local target = self.spawns[getRandomNumber(1, #self.spawns)]
  local targetTemplate = target[1]
  local targetMessage = target[2]
  self:log("DedleeSyn: New target selected. Template: " .. targetTemplate .. ", Message: " .. targetMessage)
  writeScreenPlayData(pAdminPlayer, "DedleeSynScreenPlay", "huntTargetTemplate", targetTemplate)
  writeScreenPlayData(pAdminPlayer, "DedleeSynScreenPlay", "huntTargetMessage", targetMessage)

  createEvent(self.respawnFrequency, "DedleeSynScreenPlay", "setHuntMob", nil, "")
end

function DedleeSynScreenPlay:joinTheHunt(pPlayer)
  createObserver(KILLEDCREATURE, "DedleeSynScreenPlay", "notifyKilledCreature", pPlayer)
end

function DedleeSynScreenPlay:notifyKilledCreature(pPlayer, pVictim)
  	if (pVictim == nil) then
		return 0
	end

	if (pPlayer == nil) then
		return 1
	end

  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)
  local huntCount = tonumber(readScreenPlayData(pPlayer, "DedleeSynScreenPlay", "huntCount")) or 0
  local huntTarget = readScreenPlayData(pAdminPlayer, "DedleeSynScreenPlay", "huntTargetTemplate")
	local victimName = SceneObject(pVictim):getObjectName()
  local victimCustomName = SceneObject(pVictim):getCustomObjectName()

  if (victimName == nil) then
    return 0
  end

  if (victimName == huntTarget or victimCustomName == huntTarget) then
    local message = self.messages[getRandomNumber(1, #self.messages)]
    CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\<Communicator>\\#FFFFFF\\" .. message)

    local tokens = 1000;

    writeScreenPlayData(pPlayer, "DedleeSynScreenPlay", "huntCount", huntCount + tokens)
  end

	return 0
end

function DedleeSynScreenPlay:log(message)
  local outputFile = "log/dedlee_syn.log"
  logToFile(message, outputFile)
end


