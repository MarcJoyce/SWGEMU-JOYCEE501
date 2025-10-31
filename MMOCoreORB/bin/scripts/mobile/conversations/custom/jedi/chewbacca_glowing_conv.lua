chewbacca_glowing_convo_template = ConvoTemplate:new {
  initialScreen = "friendly",
  templateType = "Lua",
  luaClassHandler = "chewbaccaConvoHandler",
  screens = {}
};

friendly = ConvoScreen:new {
  id = "friendly",
  customDialogText = "",
  stopConversation = "true",
  options = {}
}
chewbacca_glowing_convo_template:addScreen(friendly)

cautious = ConvoScreen:new {
  id = "cautious",
  customDialogText = "",
  stopConversation = "true",
  options = {}
}
chewbacca_glowing_convo_template:addScreen(cautious)

addConversationTemplate("chewbacca_glowing_convo_template", chewbacca_glowing_convo_template);
