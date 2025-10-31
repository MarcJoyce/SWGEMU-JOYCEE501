-- Conversations
includeFile("conversations.lua")

-- Dress Groups - Must be loaded before mobiles
includeFile("dressgroup/serverobjects.lua") 

-- Creatures
includeFile("corellia/serverobjects.lua")
includeFile("dantooine/serverobjects.lua")
includeFile("dathomir/serverobjects.lua")
includeFile("endor/serverobjects.lua")
includeFile("event/serverobjects.lua")
includeFile("herald/serverobjects.lua")
includeFile("lok/serverobjects.lua")
includeFile("misc/serverobjects.lua")
includeFile("naboo/serverobjects.lua")
includeFile("pet/serverobjects.lua")
includeFile("quest/serverobjects.lua")
includeFile("rori/serverobjects.lua")
includeFile("space/serverobjects.lua")
includeFile("talus/serverobjects.lua")
includeFile("tatooine/serverobjects.lua")
includeFile("thug/serverobjects.lua")
includeFile("townsperson/serverobjects.lua")
includeFile("tutorial/serverobjects.lua")
includeFile("yavin4/serverobjects.lua")

includeFile("faction/serverobjects.lua")
includeFile("dungeon/serverobjects.lua") 

-- Weapons
includeFile("weapon/serverobjects.lua") 

-- Spawn Groups
includeFile("spawn/serverobjects.lua")

-- Trainer
includeFile("trainer/serverobjects.lua")

-- Mission
includeFile("mission/serverobjects.lua")

-- Lairs
includeFile("lair/serverobjects.lua")

-- Outfits
includeFile("outfits/serverobjects.lua")

--Custom
includeFile("custom/jedi/selogel.lua")
includeFile("custom/jedi/klik_klak.lua")
includeFile("custom/jedi/tusken_queen.lua")
includeFile("custom/jedi/brian_cohen.lua")
includeFile("custom/jedi/thalos_krenn.lua")
includeFile("custom/jedi/jabba_henchman_custom.lua")
includeFile("custom/jedi/han_solo_glowing.lua")
includeFile("custom/jedi/chewbacca_glowing.lua")

includeFile("custom/jedi/nym/imp_commander.lua")
includeFile("custom/jedi/nym/imp_trooper.lua")
includeFile("custom/jedi/nym/reb_commander.lua")
includeFile("custom/jedi/nym/reb_trooper.lua")
includeFile("custom/jedi/nym/jabba_commander.lua")
includeFile("custom/jedi/nym/jabba_trooper.lua")

includeFile("custom/jedi/shadows/shadows_captive_one.lua")
includeFile("custom/jedi/shadows/shadows_guard.lua")
includeFile("custom/jedi/shadows/shadows_exile.lua")
includeFile("custom/jedi/shadows/konlan_voss.lua")

includeFile("custom/navi_gator.lua")
includeFile("custom/bazaarBotHelper.lua")
includeFile("custom/dedlee_syn.lua")

includeFile("custom/mobs/krayt_dragon_elder.lua")
includeFile("custom/mobs/world_boss/world_boss_butterfly_drone.lua")
includeFile("custom/mobs/world_boss/world_boss_butterfly.lua")
includeFile("custom/mobs/world_boss/world_boss_durni.lua")
includeFile("custom/mobs/world_boss/world_boss_durni_warrior.lua")
includeFile("custom/mobs/world_boss/world_boss_durni_drone.lua")
includeFile("custom/mobs/world_boss/world_boss_carrion_spat.lua")
includeFile("custom/mobs/world_boss/world_boss_carrion_spat_drone.lua")
includeFile("custom/mobs/world_boss/world_boss_graul.lua")
includeFile("custom/mobs/world_boss/world_boss_voritor.lua")
includeFile("custom/mobs/world_boss/world_boss_voritor_drone.lua")
includeFile("custom/mobs/world_boss/world_boss_quenker.lua")
includeFile("custom/mobs/world_boss/world_boss_quenker_drone.lua")
includeFile("custom/mobs/world_boss/world_boss_jedi.lua")
includeFile("custom/mobs/world_boss/world_boss_jedi_drone.lua")
includeFile("custom/mobs/world_boss/world_boss_rancor.lua")
includeFile("custom/mobs/world_boss/world_boss_rancor_drone.lua")
includeFile("custom/mobs/world_boss/world_boss_nightsister.lua")
includeFile("custom/mobs/world_boss/world_boss_nightsister_drone.lua")
includeFile("custom/mobs/world_boss/world_boss_singing_mountain_clan.lua")
includeFile("custom/mobs/world_boss/world_boss_singing_mountain_clan_drone.lua")
includeFile("custom/mobs/world_boss/world_boss_krayt.lua")
includeFile("custom/mobs/world_boss/world_boss_krayt_drone.lua")

-- Custom content - Loads last to allow for overrides
includeFile("../custom_scripts/mobile/serverobjects.lua")