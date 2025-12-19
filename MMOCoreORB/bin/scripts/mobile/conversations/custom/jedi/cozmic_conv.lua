cozmic_convo_template = ConvoTemplate:new {
	initialScreen = "first_screen",
	templateType = "Lua",
	luaClassHandler = "cozmicConvoHandler",
	screens = {},
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  leftDialog = "@conversation/custom_string:cozmic_first_screen",
  stopConversation = "false",
  options =  {
    { "@conversation/custom_string:cozmic_first_screen_response_one", "cozmic_explain" },
    { "@conversation/custom_string:cozmic_first_screen_response_two", "cozmic_explain" },
  },
}
cozmic_convo_template:addScreen(first_screen);

cozmic_explain = ConvoScreen:new {
  id = "cozmic_explain",
  leftDialog = "@conversation/custom_string:cozmic_explain",
  stopConversation = "false",
  options =  {
    { "@conversation/custom_string:cozmic_explain_response", "quest_accept" }
  },
}
cozmic_convo_template:addScreen(cozmic_explain);

quest_accept = ConvoScreen:new {
  id = "quest_accept",
  leftDialog = "@conversation/custom_string:cozmic_quest_accept",
  stopConversation = "true",
  options =  {},
}
cozmic_convo_template:addScreen(quest_accept);

quest_ongoing = ConvoScreen:new {
  id = "quest_ongoing",
  leftDialog = "@conversation/custom_string:cozmic_quest_ongoing",
  stopConversation = "true",
  options =  {},
}
cozmic_convo_template:addScreen(quest_ongoing);

quest_complete = ConvoScreen:new {
  id = "quest_complete",
  leftDialog = "@conversation/custom_string:cozmic_quest_complete",
  stopConversation = "true",
  options =  {},
}
cozmic_convo_template:addScreen(quest_complete);

allied_with_enemy = ConvoScreen:new {
  id = "allied_with_enemy",
  leftDialog = "@conversation/custom_string:cozmic_allied_with_enemy",
  stopConversation = "true",
  options =  {},
}
cozmic_convo_template:addScreen(allied_with_enemy);

not_ready = ConvoScreen:new {
  id = "not_ready",
  leftDialog = "@conversation/custom_string:cozmic_not_ready",
  stopConversation = "true",
  options =  {},
}
cozmic_convo_template:addScreen(not_ready);

addConversationTemplate("cozmic_convo_template", cozmic_convo_template);