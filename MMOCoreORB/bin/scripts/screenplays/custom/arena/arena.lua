Arena = ScreenPlay:new
{
	numberOfActs = 1,

	screenplayName = "Arena",
}

registerScreenPlay("Arena", true)

function Arena:start()
	if (isZoneEnabled("lok")) then
		self:spawnMobiles()
    self:spawnObjects()
	end
end

function Arena:spawnMobiles()
-- z = 66
end

function Arena:spawnObjects()
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2900, 66, 500, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2913.39746, 66, 550, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2950, 66, 586.6025404, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3000, 66, 600, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3050, 66, 586.6025404, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3086.60254, 66, 550, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3100, 66, 500, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3086.60254, 66, 450, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3050, 66, 413.3974596, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3000, 66, 400, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2950, 66, 413.3974596, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2913.39746, 66, 450, 0, 0);
end