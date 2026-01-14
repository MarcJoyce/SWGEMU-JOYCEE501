sap_convo_template = ConvoTemplate:new {
	initialScreen = "first_screen",
	templateType = "Lua",
	luaClassHandler = "sapConvoHandler",
	screens = {},
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "You smell of fear... but not prey. Good. Maybe you're hunter, like Sap. Bless by the Ssscorekeeper? I track fur-beasts. You interrupt the hunt... unless... you offer to help?",
  stopConversation = "false",
  options =  {
    { "What hunt are you talking about?", "sap_explain" },
    { "Easy, lizard-man, I'm just looking to help.", "sap_explain" },
  },
}
sap_convo_template:addScreen(first_screen);

sap_explain = ConvoScreen:new {
  id = "sap_explain",
  customDialogText = "Wookiees... Hiding in the forest, they escaped their nets, stole honor from me! Their spirits stink of desperation. Sap must reclaim my Jadsoshtah... but more claws make for easier kills. You hunt?",
  stopConversation = "false",
  options =  {
    { "What would you have me do?", "quest_accept" }
  },
}
sap_convo_template:addScreen(sap_explain);

quest_accept = ConvoScreen:new {
  id = "quest_accept",
  customDialogText = "Good... Wookiees are hiding with the Ewoks in the trees. Cornered, ssstarving... but they fight hard. Catch them, or kill them, Sap cares not. I take fur as trophies.",
  stopConversation = "true",
  options =  {},
}
sap_convo_template:addScreen(quest_accept);

quest_ongoing = ConvoScreen:new {
  id = "quest_ongoing",
  customDialogText = "Why return with empty claws? The village echo's with their roarsss. Each breath they take is insult to my honor. Hunt, or stop pretending to be a predator.",
  stopConversation = "true",
  options =  {},
}
sap_convo_template:addScreen(quest_ongoing);

quest_complete = ConvoScreen:new {
  id = "quest_complete",
  customDialogText = "You bring fur and meat, yesss... their fear still clings to it. Hah! The Ssscorekeeper sees me... rewards me for this. And you too hunter, take honor. You earned pointsss today.",
  stopConversation = "true",
  options =  {},
}
sap_convo_template:addScreen(quest_complete);

allied_with_enemy = ConvoScreen:new {
  id = "allied_with_enemy",
  customDialogText = "You stink of lies. You side with the fur-beasts. You have no honor...",
  stopConversation = "true",
  options =  {},
}
sap_convo_template:addScreen(allied_with_enemy);

not_ready = ConvoScreen:new {
  id = "not_ready",
  customDialogText = "Ssssstrange creature should leave before they become prey of the hunt.",
  stopConversation = "true",
  options =  {},
}
sap_convo_template:addScreen(not_ready);

addConversationTemplate("sap_convo_template", sap_convo_template);
