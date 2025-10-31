shadows_captive_one_convo_template = ConvoTemplate:new {
  initialScreen = "screen_one",
  templateType = "Lua",
  luaClassHandler = "shadowsCaptiveOneConvoHandler",
  screens = {}
};

screen_one = ConvoScreen:new {
  id = "screen_one",
  customDialogText = "It's you! The one they spoke about.",
  stopConversation = "false",
  options = {
    { "What do you mean? Who spoke about me?" , "screen_two" }
  }
}
shadows_captive_one_convo_template:addScreen(screen_one)

screen_two = ConvoScreen:new {
  id = "screen_two",
  customDialogText = "The guards, they knew you. They knew you'd come to save me, and they were right.",
  stopConversation = "false",
  options = {
    { "Tell me what you know." , "screen_three" }
  }
}
shadows_captive_one_convo_template:addScreen(screen_two)

screen_three = ConvoScreen:new {
  id = "screen_three",
  customDialogText = "They spoke of you and the one that seeks to save you. They had to keep me captive, whilst they protected something on Yavin 4.",
  stopConversation = "false",
  options = {
    { "Save me?" , "screen_four" },
    { "What were they protecting?" , "screen_four" },
  }
}
shadows_captive_one_convo_template:addScreen(screen_three)

screen_four = ConvoScreen:new {
  id = "screen_four",
  customDialogText = "I'm sorry, I don't know anymore than I've already told you. Head to Yavin4 and I hope you find more answers.",
  stopConversation = "true",
  options = {}
}
shadows_captive_one_convo_template:addScreen(screen_four)


addConversationTemplate("shadows_captive_one_convo_template", shadows_captive_one_convo_template);
