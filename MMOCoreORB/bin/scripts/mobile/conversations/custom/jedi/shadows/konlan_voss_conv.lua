konlan_voss_convo_template = ConvoTemplate:new {
  initialScreen = "init_screen",
  templateType = "Lua",
  luaClassHandler = "konlanVossConvoHandler",
  screens = {}
};

go_away = ConvoScreen:new {
  id = "go_away",
  customDialogText = "Leave me be.",
  stopConversation = "true",
  options = {}
}
konlan_voss_convo_template:addScreen(go_away)

init_screen = ConvoScreen:new {
  id = "init_screen",
  customDialogText = "She said you'd come. Eventually...",
  stopConversation = "false",
  options = {
    { "Who are you? Who said I'd come? What is going on?!" , "explain" }
  }
}
konlan_voss_convo_template:addScreen(init_screen)

explain = ConvoScreen:new {
  id = "explain",
  customDialogText = "I can't say too much.",
  stopConversation = "false",
  options = {
    { "Can't or wont?" , "explain_two" },
  }
}
konlan_voss_convo_template:addScreen(explain)

explain_two = ConvoScreen:new {
  id = "explain_two",
  customDialogText = "Ha, I can't, because I don't know too much.",
  stopConversation = "false",
  options = {
    { "Then tell me what you do know." , "explain_three" },
  }
}
konlan_voss_convo_template:addScreen(explain_two)

explain_three = ConvoScreen:new {
  id = "explain_three",
  customDialogText = "You've been running so hard, and so fast I bet you never thought to stop and wonder how you ended up on that Imperial space station in the first place did you?",
  stopConversation = "false",
  options = {
    { "They said the transport I was on was attacked by pirates." , "explain_four" },
  }
}
konlan_voss_convo_template:addScreen(explain_three)

explain_four = ConvoScreen:new {
  id = "explain_four",
  customDialogText = "Pirates!? Ha! No, not pirates. The Empire attacked your ship, because they were trying to stop... her.",
  stopConversation = "false",
  options = {
    { "Who? Please, you have to tell me." , "explain_five" },
  }
}
konlan_voss_convo_template:addScreen(explain_four)

explain_five = ConvoScreen:new {
  id = "explain_five",
  customDialogText = "Sorry, but she'll kill me if I told you. Here, give me the disk.",
  stopConversation = "false",
  options = {
    { "How did you know? Um, here.." , "explain_six" },
  }
}
konlan_voss_convo_template:addScreen(explain_five)

explain_six = ConvoScreen:new {
  id = "explain_six",
  customDialogText = "I've added an entry to your datapad. Go and find your answers.",
  stopConversation = "true",
  options = {}
}
konlan_voss_convo_template:addScreen(explain_six)

explain_seven = ConvoScreen:new {
  id = "explain_seven",
  customDialogText = "What are you doing here? I told you where to go.",
  stopConversation = "true",
  options = {}
}
konlan_voss_convo_template:addScreen(explain_seven)

addConversationTemplate("konlan_voss_convo_template", konlan_voss_convo_template);
