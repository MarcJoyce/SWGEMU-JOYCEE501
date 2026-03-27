treasure_stan_convo_template = ConvoTemplate:new {
  initialScreen = "hello",
  templateType = "Lua",
  luaClassHandler = "treasureStanConvoHandler",
  screens = {}
}

hello = ConvoScreen:new {
  id = "hello",
  customDialogText = "Congratulations, you found me, here is your reward, goodbye!",
  stopConversation = "true",
  options = {}
}
treasure_stan_convo_template:addScreen(hello)

addConversationTemplate("treasure_stan_convo_template", treasure_stan_convo_template);

