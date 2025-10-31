bazaar_bot_helper_convo_template = ConvoTemplate:new {
  initialScreen = "hello",
  templateType = "Lua",
  luaClassHandler = "bazaarBotHelperConvoHandler",
  screens = {}
}

hello = ConvoScreen:new {
  id = "hello",
  customDialogText = "Hello",
  stopConversation = "true",
  options = {}
}
bazaar_bot_helper_convo_template:addScreen(hello)

todo = ConvoScreen:new {
  id = "todo",
  customDialogText = "What do you want me to do?",
  stopConversation = "false",
  options = {
    { "Clear inv", "todo_clear_inv"},
    { "Relist things", "todo_relist"},
    { "Add World Boss waypoints", "add_wps"}
  }
}
bazaar_bot_helper_convo_template:addScreen(todo)

todo_clear_inv = ConvoScreen:new {
  id = "todo_clear_inv",
  customDialogText = "What do you want me to do?",
  stopConversation = "false",
  options = {
    { "Clear inv", "todo_clear_inv"},
    { "Relist things", "todo_relist"},
    { "Add World Boss waypoints", "add_wps"}
  }
}
bazaar_bot_helper_convo_template:addScreen(todo_clear_inv)

todo_relist = ConvoScreen:new {
  id = "todo_relist",
  customDialogText = "What do you want me to do?",
  stopConversation = "false",
  options = {
    { "Clear inv", "todo_clear_inv"},
    { "Relist things", "todo_relist"},
    { "Add World Boss waypoints", "add_wps"}
  }
}
bazaar_bot_helper_convo_template:addScreen(todo_relist)

add_wps = ConvoScreen:new {
  id = "add_wps",
  customDialogText = "What do you want me to do?",
  stopConversation = "false",
  options = {
    { "Clear inv", "todo_clear_inv"},
    { "Relist things", "todo_relist"},
    { "Add World Boss waypoints", "add_wps"}
  }
}
bazaar_bot_helper_convo_template:addScreen(add_wps)

addConversationTemplate("bazaar_bot_helper_convo_template", bazaar_bot_helper_convo_template);

