AncientKraytSkeletonScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

}

registerScreenPlay("AncientKraytSkeletonScreenPlay", false)

function AncientKraytSkeletonScreenPlay:start()
	if (isZoneEnabled("tatooine")) then
		self:spawnMobiles()
	end
end

function AncientKraytSkeletonScreenPlay:spawnMobiles()

	spawnMobile("tatooine", "krayt_dragon_grand", 900, -4555.0, 49.3, -4459.2, -116, 0)
	spawnMobile("tatooine", "krayt_dragon_ancient", 900, -4713.1, 46.5, -4288.3, 50, 0)
	spawnMobile("tatooine", "giant_canyon_krayt_dragon", 900, -4669.8, 30.1, -4477.7, 5, 0)
	spawnMobile("tatooine", "canyon_krayt_dragon", 900, -4528.8, 28.3, -4302.4, 144, 0)
	spawnMobile("tatooine", "krayt_dragon_ancient", 900, -4521.3, 27.2, -4298.2, 144, 0)
	spawnMobile("tatooine", "krayt_dragon_ancient", 900, -4747.2, 32.5, -4424.8, -91, 0)

end
