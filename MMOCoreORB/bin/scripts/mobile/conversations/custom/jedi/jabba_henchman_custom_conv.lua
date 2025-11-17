jabba_henchman_custom_convo_template = ConvoTemplate:new {
  initialScreen = "first_screen",
  templateType = "Lua",
  luaClassHandler = "jabbaHenchmanCustomConvoHandler",
  screens = {}
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "You here for shiny? Jabba shiny. Why you get, hmm?",
  stopConversation = "false",
  options = {}
}
jabba_henchman_custom_convo_template:addScreen(first_screen)

free = ConvoScreen:new {
  id = "free",
  customDialogText = "Boss say you okay. Hmph. Take shiny… but no touch anything else! Hmph!",
  stopConversation = "true",
  options = {}
}
jabba_henchman_custom_convo_template:addScreen(free)

pay = ConvoScreen:new {
  id = "pay",
  customDialogText = "You not friend… but not bad. Shiny cost big. One million credits. You pay, yes?",
  stopConversation = "false",
  options = {}
}
jabba_henchman_custom_convo_template:addScreen(pay)

pay_success = ConvoScreen:new {
  id = "pay_success",
  customDialogText = "Heh. Boss happy. Shiny is yours. Don't break, hmm.",
  stopConversation = "true",
  options = {}
}
jabba_henchman_custom_convo_template:addScreen(pay_success)

pay_failed = ConvoScreen:new {
  id = "pay_failed",
  customDialogText = "Come back when have credits. Hmph.",
  stopConversation = "true",
  options = {}
}
jabba_henchman_custom_convo_template:addScreen(pay_failed)

kill = ConvoScreen:new {
  id = "kill",
  customDialogText = "Boss no like you. No credits. You want shiny? Kill big sand lizard. Krayt. Not baby… Ancient Krayt.",
  stopConversation = "false",
  options = {
    {"A krayt dragon? Fine. I'll be back with its head.", "kill_bye" },
    {"That's suicide. There's got to be another way.", "kill_bye_two" }
  }
}
jabba_henchman_custom_convo_template:addScreen(kill)

kill_bye = ConvoScreen:new {
  id = "kill_bye",
  customDialogText = "Hmph. Don't get eaten. Hmph!",
  stopConversation = "true",
  options = {}
}
jabba_henchman_custom_convo_template:addScreen(kill_bye)

kill_bye_two = ConvoScreen:new {
  id = "kill_bye_two",
  customDialogText = "No! Kill Krayt… get shiny. Now go, hmm!",
  stopConversation = "true",
  options = {}
}
jabba_henchman_custom_convo_template:addScreen(kill_bye_two)

kill_success = ConvoScreen:new {
  id = "kill_success",
  customDialogText = "You live. Kill Krayt… good. Boss happy. Shiny is yours. Hmph!",
  stopConversation = "true",
  options = {}
}
jabba_henchman_custom_convo_template:addScreen(kill_success)

kill_ongoing = ConvoScreen:new {
  id = "kill_ongoing",
  customDialogText = "Kill Krayt… get shiny. Leave now, hmm!",
  stopConversation = "true",
  options = {}
}
jabba_henchman_custom_convo_template:addScreen(kill_ongoing)

go_away = ConvoScreen:new {
  id = "go_away",
  customDialogText = "Hmph! Go, stranger!",
  stopConversation = "true",
  options = {}
}
jabba_henchman_custom_convo_template:addScreen(go_away)

addConversationTemplate("jabba_henchman_custom_convo_template", jabba_henchman_custom_convo_template);