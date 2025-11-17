dedlee_syn_convo_template = ConvoTemplate:new {
  initialScreen = "first_screen_not_met",
  templateType = "Lua",
  luaClassHandler = "dedleeSynConvoHandler",
  screens = {}
}

first_screen_not_met = ConvoScreen:new {
  id = "first_screen_not_met",
  customDialogText = "Ahh… a fresh face in the galaxy's underbelly. Tell me, traveler—does the promise of fame, fortune, and finely tuned firepower spark your interest?",
  stopConversation = "false",
  options = {
    { "Sounds like fun, what would you have me do?", "information" },
  }
}
dedlee_syn_convo_template:addScreen(first_screen_not_met)

first_screen_has_met = ConvoScreen:new {
  id = "first_screen_has_met",
  customDialogText = "Back again, friend? The black-market winds favor you today. What can I offer?",
  stopConversation = "false",
  options = {
    { "Remind me, what's this all about?", "information" },
    { "How many tokens have I earned so far?", "score" },
    { "What can I buy?", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(first_screen_has_met)

information = ConvoScreen:new {
  id = "information",
  customDialogText = "Here's the deal: you take down high-value targets, the kind that make Imperial tacticians flinch… and I hand you tokens. Stack enough tokens, and I'll arm you with weapons even Hutts whisper about.",
  stopConversation = "false",
  options = {
    { "How many tokens have I earned so far?", "score" },
    { "What can I buy?", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(information)

score = ConvoScreen:new {
  id = "score",
  customDialogText = "Your current token haul stands at this many. Not bad—some beings would've died collecting half that.",
  stopConversation = "false",
  options = {
    { "Remind me, what's this all about?", "information" },
    { "What can I buy?", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(score)

shop = ConvoScreen:new {
  id = "shop",
  customDialogText = "Let's outfit you properly. What kind of armament does your legend demand?",
  stopConversation = "false",
  options = {

  }
}
dedlee_syn_convo_template:addScreen(shop)

ranged = ConvoScreen:new {
  id = "ranged",
  customDialogText = "Blasters at a distance, hm? A wise choice—no glory in getting vaporized up close.",
  stopConversation = "false",
  options = {
    { "Carbine", "carbine" },
    { "Pistol", "pistol" },
    { "Rifle", "rifle" },
    { "Special", "special" },
    { "Let me start again.", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(ranged)

carbine = ConvoScreen:new {
  id = "carbine",
  customDialogText = "A carbine connoisseur, I see. Compact, reliable, and deadly—just like I like my clients.",
  stopConversation = "false",
  options = {
    { "CDEF Carbine", "cdefcarbine" },
    { "Corsec CDEF Carbine", "corseccdefcarbine" },
    { "DH17 Carbine", "dh17carbine" },
    { "DH17 Carbine (black)", "dh17blackcarbine" },
    { "DH17 Short Carbine", "dh17shortcarbine" },
    { "DXR6 Carbine", "dxr6carbine" },
    { "E11 Carbine", "e11carbine" },
    { "Enhanced E11 Carbine", "enhancede11carbine" },
    { "Lithitanium Carbine", "lithitaniumcarbine" },
    { "EE3 Carbine", "ee3carbine" },
    { "Elite Carbine", "elitecarbine" },
    { "Laser Carbine", "lasercarbine" },
    { "Nym's Slug-thrower Carbine", "nymscarbine" },
    { "Let me start again.", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(carbine)

pistol = ConvoScreen:new {
  id = "pistol",
  customDialogText = "Going compact? Perfect for smugglers, spies, and anyone who prefers a quick draw over a long speech.",
  stopConversation = "false",
  options = {
    { "Black Metal Gaderiffi Baton", "blackmetalgaderiffibaton" },
    { "CDEF Pistol", "cdefpistol" },
    { "Corsec CDEF Pistol", "corseccdefpistol" },
    { "D18 Pistol", "d18pistol" },
    { "DE-10 Pistol", "de10pistol" },
    { "DH17 Pistol", "dh17pistol" },
    { "DL44 Pistol", "dl44pistol" },
    { "DL44 Metal Pistol", "dl44metalpistol" },
    { "DX2 Pistol", "dx2pistol" },
    { "FWG5 Pistol", "fwg5pistol" },
    { "Featherweight FWG5 Pistol", "featherweightfwg5pistol" },
    { "Geonosian Sonic Blaster", "geonosiansonicblaster" },
    { "Launcher Pistol", "launcherpistol" },
    { "Power5 Pistol", "power5pistol" },
    { "Republic Blaster", "republicblaster" },
    { "Modified Republic Blaster", "modifiedrepublicblaster" },
    { "Scatter Pistol", "scatterpistol" },
    { "Scout Blaster", "scoutblaster" },
    { "SR Combat Pistol", "srcombatpistol" },
    { "Striker Pistol", "strikerpistol" },
    { "Tangle Pistol", "tanglepistol" },
    { "Let me start again.", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(pistol)

rifle = ConvoScreen:new {
  id = "rifle",
  customDialogText = "A rifle? So you *are* the patient type. Long-range justice—it has a certain poetry to it.",
  stopConversation = "false",
  options = {
    { "Berserker Rifle", "berserkerrifle" },
    { "Bowcaster", "bowcaster" },
    { "CDEF Rifle", "cdefrifle" },
    { "DLT20 Rifle", "dlt20rifle" },
    { "DLT20a Rifle", "dlt20arifle" },
    { "E11 Rifle", "e11rifle" },
    { "Ewok Crossbow", "ewokcrossbow" },
    { "Jawa Ion Rifle", "jawaionrifle" },
    { "Laser Rifle", "laserrifle" },
    { "Lithitanium Rifle", "lithitaniumrifle" },
    { "SG82 Rifle", "sg82rifle" },
    { "Spraystick", "spraystick" },
    { "Tenloss DXR-6 Disruptor Rifle", "tenlossdxr6disruptorrifle" },
    { "T21", "t21" },
    { "Tusken Rifle", "tuskenrifle" },
    { "Let me start again.", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(rifle)

special = ConvoScreen:new {
  id = "special",
  customDialogText = "Ahh… the exotic stuff. Hard to find, harder to survive, and very fun to point at someone else.",
  stopConversation = "false",
  options = {
    { "Flame Thrower", "flamethrower" },
    { "Heavy Acid Rifle", "heavyacidrifle" },
    { "Light Lightning Cannon", "lightlightningcannon" },
    { "Let me start again.", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(special)

melee = ConvoScreen:new {
  id = "melee",
  customDialogText = "Nothing like the thrill of closing the distance and letting your enemies see their mistake up close. What's your style?",
  stopConversation = "false",
  options = {
    { "OneHanded", "onehanded" },
    { "Polearm", "polearm" },
    { "TwoHanded", "twohanded" },
    { "Unarmed", "unarmed" },
    { "Let me start again.", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(melee)

onehanded = ConvoScreen:new {
  id = "onehanded",
  customDialogText = "Elegant, precise—very old-Republic of you. A duelist's weapon for a duelist's ego.",
  stopConversation = "false",
  options = {
    { "Sword", "sword" },
    { "Curved Sword", "curvedsword" },
    { "Ryyk Blade", "ryykblade" },
    { "Curved Nyax Sword", "curvednyaxsword" },
    { "Nyax Sword", "nyaxsword" },
    { "Rantok", "rantok" },
    { "Vibroblade", "vibroblade" },
    { "Jagged Vibroblade", "jaggedvibroblade" },
    { "Stun Baton", "stunbaton" },
    { "Gaderiffi Baton", "gaderiffibaton" },
    { "Let me start again.", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(onehanded)

polearm = ConvoScreen:new {
  id = "polearm",
  customDialogText = "A polearm? That sweeping, dramatic flair… you must enjoy looking impressive while ending lives.",
  stopConversation = "false",
  options = {
    { "Lance", "lance" },
    { "Nightsister Lance", "nightsisterlance" },
    { "Nightsister Energy Lance", "nightsisterenergylance" },
    { "Janta Staff", "jantastaff" },
    { "Metal Staff", "metalstaff" },
    { "Vibro Lance", "vibrolance" },
    { "Long Vibro Axe", "longvibroaxe" },
    { "Wood Staff", "woodstaff" },
    { "Reinforced Combat Staff", "reinforcedcombatstaff" },
    { "Let me start again.", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(polearm)

twohanded = ConvoScreen:new {
  id = "twohanded",
  customDialogText = "Now that's commitment; two-handed destruction. Nothing subtle about it, and that's why I respect it.",
  stopConversation = "false",
  options = {
    { "Two-handed Curved Sword", "twohandedcurvedsword" },
    { "Grooved Two-handed Sword", "groovedtwohandedcurvedsword" },
    { "Scythe Blade", "scytheblade" },
    { "Power Hammer", "powerhammer" },
    { "Two-handed Cleaver", "twohandedcleaver" },
    { "Black Sun Executioner's Hack", "blacksunexecutionershack" },
    { "Gamorrean Battleaxe", "gamorreanbattleaxe" },
    { "Heavy Axe", "heavyaxe" },
    { "Vibro Axe", "vibroaxe" },
    { "Let me start again.", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(twohanded)

unarmed = ConvoScreen:new {
  id = "unarmed",
  customDialogText = "Unarmed? A fistfighter in a galaxy of blasters. Either brave… or slightly unhinged. I approve.",
  stopConversation = "false",
  options = {
    { "Vibro Knuckler", "vibroknuckler" },
    { "Blacksun Razor Knuckler", "blacksunrazorknuckler" },
    { "Let me start again.", "shop" }
  }
}
dedlee_syn_convo_template:addScreen(unarmed)

local weaponIds = {
  "cdefcarbine",
  "corseccdefcarbine",
  "dh17carbine",
  "dh17blackcarbine",
  "dh17shortcarbine",
  "dxr6carbine",
  "e11carbine",
  "enhancede11carbine",
  "lithitaniumcarbine",
  "ee3carbine",
  "elitecarbine",
  "lasercarbine",
  "nymscarbine",
  "flamethrower",
  "heavyacidrifle",
  "lightlightningcannon",
  "sword",
  "curvedsword",
  "ryykblade",
  "curvednyaxsword",
  "nyaxsword",
  "rantok",
  "vibroblade",
  "jaggedvibroblade",
  "stunbaton",
  "gaderiffibaton",
  "blackmetalgaderiffibaton",
  "cdefpistol",
  "corseccdefpistol",
  "d18pistol",
  "de10pistol",
  "dh17pistol",
  "dl44pistol",
  "dl44metalpistol",
  "dx2pistol",
  "fwg5pistol",
  "featherweightfwg5pistol",
  "geonosiansonicblaster",
  "launcherpistol",
  "power5pistol",
  "republicblaster",
  "modifiedrepublicblaster",
  "scatterpistol",
  "scoutblaster",
  "srcombatpistol",
  "strikerpistol",
  "tanglepistol",
  "lance",
  "nightsisterlance",
  "nightsisterenergylance",
  "jantastaff",
  "metalstaff",
  "vibrolance",
  "longvibroaxe",
  "woodstaff",
  "reinforcedcombatstaff",
  "berserkerrifle",
  "bowcaster",
  "cdefrifle",
  "dlt20rifle",
  "dlt20arifle",
  "e11rifle",
  "ewokcrossbow",
  "jawaionrifle",
  "laserrifle",
  "lithitaniumrifle",
  "sg82rifle",
  "spraystick",
  "tenlossdxr6disruptorrifle",
  "t21",
  "tuskenrifle",
  "twohandedcurvedsword",
  "groovedtwohandedcurvedsword",
  "scytheblade",
  "powerhammer",
  "twohandedcleaver",
  "blacksunexecutionershack",
  "gamorreanbattleaxe",
  "heavyaxe",
  "vibroaxe",
  "vibroknuckler",
  "blacksunrazorknuckler"
}

for _, id in ipairs(weaponIds) do
  local screen = ConvoScreen:new {
    id = id,
    customDialogText = "What flavor of devastation are we pairing with this fine piece of craftsmanship?",
    stopConversation = "false",
    options = {
      { "Kinetic", "kin" },
      { "Energy", "ene" },
      { "Blast", "bla" },
      { "Stun", "stu" },
      { "Heat", "hea" },
      { "Cold", "col" },
      { "Acid", "aci" },
      { "Electricity", "ele" }
    }
  }
  dedlee_syn_convo_template:addScreen(screen)
end

local damageTypeIds = {
  "kin",
  "ene",
  "bla",
  "stu",
  "hea",
  "col",
  "aci",
  "ele"
}

for _, id in ipairs(damageTypeIds) do
  local screen = ConvoScreen:new {
    id = id,
    customDialogText = "Last step—how many of your hard-earned tokens are you ready to part with?",
    stopConversation = "false",
    options = {}
  }
  dedlee_syn_convo_template:addScreen(screen)
end

local tokens = {
  "twentyfive",
  "fifty",
  "onehundred"
}
for _, id in ipairs(tokens) do
  local screen = ConvoScreen:new {
    id = id,
    customDialogText =  "Take it—may it serve you well in the chaos ahead. Try not to vaporize anything you'll miss.",
    stopConversation = "true",
    options = {}
  }
  dedlee_syn_convo_template:addScreen(screen)
end

addConversationTemplate("dedlee_syn_convo_template", dedlee_syn_convo_template);