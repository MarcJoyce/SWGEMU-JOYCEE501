local ObjectManager = require("managers.object.object_manager")
local Logger = require("utils.logger")

NaviGatorScreenPlay = ScreenPlay:new {}

registerScreenPlay("NaviGatorScreenPlay", true)

function NaviGatorScreenPlay:start()
  if (isZoneEnabled("tatooine")) then
    self:spawnTatooine()
  end

  if (isZoneEnabled("corellia")) then
    self:spawnCorellia()
  end

  if (isZoneEnabled("naboo")) then
    self:spawnNaboo()
  end
end

function NaviGatorScreenPlay:spawnCorellia()
  -- Cnet Starport
  spawnMobile("corellia", "navi_gator", 300, -47.4, 2.6, 29.2, 340.07, 1855683)
end

function NaviGatorScreenPlay:spawnTatooine()
  -- Eisley Starport
  spawnMobile("tatooine", "navi_gator", 300, -29.1, 1.6, 50.2, 338.543, 1106377)
  -- Jabbas Palace
  spawnMobile("tatooine", "navi_gator", 300, -8.1, 0.2, 120.0, 82.6833, 1177466)
end

function NaviGatorScreenPlay:spawnNaboo()
  -- Theed Starport
  spawnMobile("naboo", "navi_gator", 300, -16.3, 0.7, -67.9, 126.881, 1692102)
end
