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
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2918, 66, 500, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2919, 66, 508, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2922, 66, 516, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2927, 66, 523, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2934, 66, 528, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2942, 66, 531, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2950, 66, 532, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2958, 66, 531, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2966, 66, 528, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2973, 66, 523, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2978, 66, 516, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2981, 66, 508, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2982, 66, 500, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2981, 66, 492, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2978, 66, 484, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2973, 66, 477, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2966, 66, 472, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2958, 66, 469, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2950, 66, 468, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2942, 66, 469, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2934, 66, 472, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2927, 66, 477, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2922, 66, 484, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2919, 66, 492, 0, 0);
end