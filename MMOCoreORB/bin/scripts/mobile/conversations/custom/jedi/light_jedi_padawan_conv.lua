light_jedi_padawan_convo_template = ConvoTemplate:new {
  initialScreen = "hello",
  templateType = "Lua",
  luaClassHandler = "lightJediConvoHandler",
  screens = {}
}

hello = ConvoScreen:new {
  id = "hello",
  customDialogText = "",
  stopConversation = "true",
  options = {
  }
}
light_jedi_padawan_convo_template:addScreen(hello)

addConversationTemplate("light_jedi_padawan_convo_template", light_jedi_padawan_convo_template);

