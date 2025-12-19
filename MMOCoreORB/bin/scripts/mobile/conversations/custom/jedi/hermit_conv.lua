hermit_convo_template = ConvoTemplate:new {
	initialScreen = "init_screen",
	templateType = "Lua",
	luaClassHandler = "hermitConvoHandler",
	screens = {},
};

init_screen = ConvoScreen:new {
  id = "init_screen",
  leftDialog = "@conversation/custom_string:hermit_init_screen",
  stopConversation = "false",
  options =  { },
}
hermit_convo_template:addScreen(init_screen);

success = ConvoScreen:new {
  id = "success",
  leftDialog = "@conversation/custom_string:hermit_success",
  stopConversation = "true",
  options =  { },
}
hermit_convo_template:addScreen(success);

addConversationTemplate("hermit_convo_template", hermit_convo_template);