local ObjectManager = require("managers.object.object_manager")

DarkJediScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "DarkJediScreenPlay",
}

registerScreenPlay("DarkJediScreenPlay", true)

function DarkJediScreenPlay:start()
	if (isZoneEnabled("yavin4")) then
		self:spawnMobiles()
	end
end

function DarkJediScreenPlay:spawnMobiles()
    local pNpc = spawnMobile("yavin4", "dark_jedi_padawan", 1, 21.211, -43.4244, -27.6535, 150, 3435634)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "dark_jedi_padawan", 1, -16.5363, -43.4244, -37.5491, 0, 3435634)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "dark_jedi_padawan", 1, -22.1047, -43.4244, -56.9032, 38, 3435643)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "dark_jedi_padawan", 1, -21.5596, -43.4244, -55.2292, 192, 3435643)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "dark_jedi_padawan", 1, -20.0159, -43.4244, -55.8092, 229, 3435643)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "dark_jedi_padawan", 1, -0.153147, -43.4244, -44.1253, 179, 3435643)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "dark_jedi_padawan", 1, 22.2374, -43.4244, -55.6432, 238, 3435643)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "dark_jedi_padawan", 1, 20.069, -43.4244, -56.8611, 59, 3435643)
    self:setMoodString(pNpc, "conversation")

    pNpc = spawnMobile("yavin4", "jedi_shop_keeper", 1, -1.01, -43.42, -56.45, 359, 3435643)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "jedi_quest_giver", 1, -0.749, -43.42, -56.37, 359, 3435643)
    self:setMoodString(pNpc, "conversation")

end
