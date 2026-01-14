hermit_convo_template = ConvoTemplate:new {
	initialScreen = "init_screen",
	templateType = "Lua",
	luaClassHandler = "hermitConvoHandler",
	screens = {},
};

init_screen = ConvoScreen:new {
  id = "init_screen",
  customDialogText = "Care to help an old man?",
  stopConversation = "false",
  options =  { },
}
hermit_convo_template:addScreen(init_screen);

success = ConvoScreen:new {
  id = "success",
  customDialogText = "Thank you, thank you stranger, your kindness will be rewarded.",
  stopConversation = "true",
  options =  { },
}
hermit_convo_template:addScreen(success);

addConversationTemplate("hermit_convo_template", hermit_convo_template);