navi_gator_convo_template = ConvoTemplate:new {
  initialScreen = "first_screen_not_met",
  templateType = "Lua",
  luaClassHandler = "naviGatorConvoHandler",
  screens = {}
}

first_screen_not_met = ConvoScreen:new {
  id = "first_screen_not_met",
  customDialogText = "Well, look who wandered into my hangar. You don't look the sort to cause trouble, so that's a good start. The name's Navi, but all my friends call me Gator. I move cargo, people, secrets, you name it. So... where in this blasted galaxy do you need to be?",
  stopConversation = "false",
  options = {}
}

navi_gator_convo_template:addScreen(first_screen_not_met)

first_screen_has_met = ConvoScreen:new {
  id = "first_screen_has_met",
  customDialogText = "Back already? Can't get enough of Gators charm, huh? Or is this another 'urgent' trip across the stars? Either way, you know the drill - fuel's not free, and neither is my time. Where to this time?",
  stopConversation = "false",
  options = {}
}

navi_gator_convo_template:addScreen(first_screen_has_met)

no_credits = ConvoScreen:new {
  id = "no_credits",
  customDialogText = "Ahhh... the old 'I'll pay you next cycle' routine. Look, kid - I've flown through asteroid fields with a busted hyperdrive, out-manoeuvred Star Destroyers and even out-run Trade Federation blockades; but flying broke passengers is where I draw the line. Come back when your credits weight more than your promises.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(no_credits)

coronet = ConvoScreen:new {
  id = "coronet",
  customDialogText = "Great, let's get going then. I don't wanna stay here any more than I need to.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(coronet)

mos_eisley = ConvoScreen:new {
  id = "mos_eisley",
  customDialogText = "Great, let's get going then. I don't wanna stay here any more than I need to.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(mos_eisley)

theed = ConvoScreen:new {
  id = "theed",
  customDialogText = "Great, let's get going then. I don't wanna stay here any more than I need to.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(theed)

jabba = ConvoScreen:new {
  id = "jabba",
  customDialogText = "Great, let's get going then. I don't wanna stay here any more than I need to.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(jabba)

dwb = ConvoScreen:new {
  id = "dwb",
  customDialogText = "Great, let's get going then. I don't wanna stay here any more than I need to.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(dwb)

geo = ConvoScreen:new {
  id = "geo",
  customDialogText = "Great, let's get going then. I don't wanna stay here any more than I need to.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(geo)

ns_stronghold = ConvoScreen:new {
  id = "ns_stronghold",
  customDialogText = "Great, let's get going then. I don't wanna stay here any more than I need to.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(ns_stronghold)

krayt = ConvoScreen:new {
  id = "krayt",
  customDialogText = "Great, let's get going then. I don't wanna stay here any more than I need to.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(krayt)

fort_tusken = ConvoScreen:new {
  id = "fort_tusken",
  customDialogText = "Great, let's get going then. I don't wanna stay here any more than I need to.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(fort_tusken)

village = ConvoScreen:new {
  id = "village",
  customDialogText = "Great, let's get going then. I don't wanna stay here any more than I need to.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(village)

lje = ConvoScreen:new {
  id = "lje",
  customDialogText = "Great, let's get going then. I don't wanna stay here any more than I need to.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(lje)

dje = ConvoScreen:new {
  id = "dje",
  customDialogText = "Great, let's get going then. I don't wanna stay here any more than I need to.",
  stopConversation = "true",
  options = {}
}

navi_gator_convo_template:addScreen(dje)

addConversationTemplate("navi_gator_convo_template", navi_gator_convo_template);

