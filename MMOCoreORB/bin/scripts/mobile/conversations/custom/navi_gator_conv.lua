navi_gator_convo_template = ConvoTemplate:new {
  initialScreen = "first_screen_not_met",
  templateType = "Lua",
  luaClassHandler = "naviGatorConvoHandler",
  screens = {}
}

first_screen_not_met = ConvoScreen:new {
  id = "first_screen_not_met",
  customDialogText = "Well, well… look who wandered into my hangar. You don't look like trouble, which is probably why you're still breathing. Name's Navi; folks who value their lives call me Gator. I move cargo, fugitives, credits, secrets… anything that fits in my ship or my schedule. So tell me, where in this kriffed-up galaxy are you trying to disappear to?",
  stopConversation = "false",
  options = {}
}

navi_gator_convo_template:addScreen(first_screen_not_met)

first_screen_has_met = ConvoScreen:new {
  id = "first_screen_has_met",
  customDialogText = "Back already? Stars above, you must really enjoy risking your neck with me. Another urgent jump? Another someone you'd rather avoid? Either way, you know how this works—fuel costs credits, danger costs extra. So… where to this time?",
  stopConversation = "false",
  options = {}
}

navi_gator_convo_template:addScreen(first_screen_has_met)

no_credits = ConvoScreen:new {
  id = "no_credits",
  customDialogText = "Ahh, the classic ‘I'll pay you next cycle' routine. Kid, I've flown through ion storms with half a hyperdrive, slipped past Imperial scanners, and even outrun a Hutt debt collector—but hauling broke passengers? That's where I draw the line. Come back when your credits outweigh your excuses.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(no_credits)

coronet = ConvoScreen:new {
  id = "coronet",
  customDialogText = "Coronet City? Civilized enough on the surface, but trust me—its shadows bite. Strap in.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(coronet)

mos_eisley = ConvoScreen:new {
  id = "mos_eisley",
  customDialogText = "Mos Eisley? Heh… scum, villainy, and cheap drinks. My kind of place. Let's fly.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(mos_eisley)

theed = ConvoScreen:new {
  id = "theed",
  customDialogText = "Theed, huh? Elegant… peaceful… boring. Let's make the trip quick.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(theed)

jabba = ConvoScreen:new {
  id = "jabba",
  customDialogText = "Heading to Jabba's turf? Brave. Or stupid. Either way, get in the seat—we're leaving.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(jabba)

dwb = ConvoScreen:new {
  id = "dwb",
  customDialogText = "Death Watch territory? You're either insane or impressively committed. Engines hot—let's go.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(dwb)

geo = ConvoScreen:new {
  id = "geo",
  customDialogText = "Geonosian space. Hope you like dust, droids, and the constant feeling you're being watched. Buckle up.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(geo)

ns_stronghold = ConvoScreen:new {
  id = "ns_stronghold",
  customDialogText = "Nightsister land? You sure about that? Those witches hate outsiders. Alright… your funeral, your fare.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(ns_stronghold)

krayt = ConvoScreen:new {
  id = "krayt",
  customDialogText = "Krayt territory? Stars help you. Let's jump before something huge decides to eat my ship.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(krayt)

fort_tusken = ConvoScreen:new {
  id = "fort_tusken",
  customDialogText = "Fort Tusken? The locals aren't exactly welcoming. Sit tight—don't make any sudden moves out there.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(fort_tusken)

village = ConvoScreen:new {
  id = "village",
  customDialogText = "A quiet little village? Finally—somewhere I'm not likely to get shot. Probably. Let's go.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(village)

lje = ConvoScreen:new {
  id = "lje",
  customDialogText = "Jedi territory? I never liked flying near mystics. Messes with my instincts. Still—your credits, your call.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(lje)

dje = ConvoScreen:new {
  id = "dje",
  customDialogText = "Dark Jedi ruins… great. Nothing like ancient evil to ruin a pilot's day. Off we go then.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(dje)

addConversationTemplate("navi_gator_convo_template", navi_gator_convo_template);

