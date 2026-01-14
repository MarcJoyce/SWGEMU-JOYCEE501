cozmic_convo_template = ConvoTemplate:new {
	initialScreen = "first_screen",
	templateType = "Lua",
	luaClassHandler = "cozmicConvoHandler",
	screens = {},
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "Don't come closer! The Wookiees here have suffered enough... I won't let another slaver or hunter near them! Speak fast—why are you here?",
  stopConversation = "false",
  options =  {
    { "I'm not a slaver. I'm here to help.", "cozmic_explain" },
    { "Easy, I'm just looking for work.", "cozmic_explain" },
  },
}
cozmic_convo_template:addScreen(first_screen);

cozmic_explain = ConvoScreen:new {
  id = "cozmic_explain",
  customDialogText = "Hrrm... maybe truth in your voice. The Trandoshans—they hunt the fur-brothers for sport and sell their hides like trophies. Cozmic has been hiding survivors, but hunters close in. You will help?",
  stopConversation = "false",
  options =  {
    { "I'll take care of the slavers.", "quest_accept" }
  },
}
cozmic_convo_template:addScreen(cozmic_explain);

quest_accept = ConvoScreen:new {
  id = "quest_accept",
  customDialogText = "Good. The fur-brothers trust Cozmic but they need more protectors. Return when the village runs quiet with no Trandoshan laughter.",
  stopConversation = "true",
  options =  {},
}
cozmic_convo_template:addScreen(quest_accept);

quest_ongoing = ConvoScreen:new {
  id = "quest_ongoing",
  customDialogText = "Still breathing, are they? Don't return until their blood covers the ground! Wookiees deserve freedom—not false promises!",
  stopConversation = "true",
  options =  {},
}
cozmic_convo_template:addScreen(quest_ongoing);

quest_complete = ConvoScreen:new {
  id = "quest_complete",
  customDialogText = "You did it? The air smells clean—no slaver musk. Wookiees are safe today. Cozmic... thanks you. The fur-brothers will remember this day. Take this—gift from those who still breathe because of you.",
  stopConversation = "true",
  options =  {},
}
cozmic_convo_template:addScreen(quest_complete);

allied_with_enemy = ConvoScreen:new {
  id = "allied_with_enemy",
  customDialogText = "You try harm fur-brothers? Cozmic will gut you like Trandoshan meat. Leave. Now.",
  stopConversation = "true",
  options =  {},
}
cozmic_convo_template:addScreen(allied_with_enemy);

not_ready = ConvoScreen:new {
  id = "not_ready",
  customDialogText = "You should leave, Wookiees need warriors, not tourists.",
  stopConversation = "true",
  options =  {},
}
cozmic_convo_template:addScreen(not_ready);

addConversationTemplate("cozmic_convo_template", cozmic_convo_template);