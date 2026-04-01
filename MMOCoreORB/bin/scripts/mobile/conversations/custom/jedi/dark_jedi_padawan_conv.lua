dark_jedi_padawan_convo_template = ConvoTemplate:new {
  initialScreen = "hello",
  templateType = "Lua",
  luaClassHandler = "darkJediConvoHandler",
  screens = {}
}

hello = ConvoScreen:new {
  id = "hello",
  customDialogText = "",
  stopConversation = "true",
  options = {
  }
}
dark_jedi_padawan_convo_template:addScreen(hello)

addConversationTemplate("dark_jedi_padawan_convo_template", dark_jedi_padawan_convo_template);
