herald_convo_template = ConvoTemplate:new {
	initialScreen = "first_screen",
	templateType = "Lua",
	luaClassHandler = "heraldConvoHandler",
	screens = {},
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  leftDialog = "@conversation/custom_string:herald_first_screen",
  stopConversation = "false",
  options =  {
    { "@conversation/custom_string:herald_first_screen_response", "herald_one" },
  },
}
herald_convo_template:addScreen(first_screen);

herald_one = ConvoScreen:new {
  id = "herald_one",
  leftDialog = "@conversation/custom_string:herald_herald_one",
  stopConversation = "true",
  options =  { },
}
herald_convo_template:addScreen(herald_one);

unlearn = ConvoScreen:new {
  id = "unlearn",
  leftDialog = "@conversation/custom_string:herald_unlearn",
  stopConversation = "true",
  options =  {},
}
herald_convo_template:addScreen(unlearn);

not_ready = ConvoScreen:new {
  id = "not_ready",
  leftDialog = "@conversation/custom_string:herald_not_ready",
  stopConversation = "true",
  options =  {},
}
herald_convo_template:addScreen(not_ready);

addConversationTemplate("herald_convo_template", herald_convo_template);