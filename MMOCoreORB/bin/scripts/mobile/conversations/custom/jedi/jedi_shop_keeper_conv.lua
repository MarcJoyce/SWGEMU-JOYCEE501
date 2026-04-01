jedi_shop_keeper_convo_template = ConvoTemplate:new {
  initialScreen = "greeting",
  templateType = "Lua",
  luaClassHandler = "jediShopKeeperConvoHandler",
  screens = {}
}

wip = ConvoScreen:new {
  id = "wip",
  customDialogText = "Greetings curious one, my speech is still a work in progress, but I will have more to say soon. Please check in with Stan, our fearless leader, for all your force related needs.",
  stopConversation = "true",
  options = {}
}
jedi_shop_keeper_convo_template:addScreen(wip)

greeting = ConvoScreen:new {
  id = "greeting",
  customDialogText = "Welcome Master. I am the keeper of the Force Relics. If you are looking for something specific, I may be able to help you find it.",
  stopConversation = "false",
  options = {
    { "What do you have for sale?", "what_do_you_sell" },
    { "Do you have any information about the Force?", "force_info" },
    { "Goodbye.", "goodbye" }
  }
}
jedi_shop_keeper_convo_template:addScreen(greeting)

what_do_you_sell = ConvoScreen:new {
  id = "what_do_you_sell",
  customDialogText = "I have a variety of Force Relics for sale. Some are quite rare and powerful, while others are more common. What exactly did you have in mind?",
  stopConversation = "true",
  options = {}
}
jedi_shop_keeper_convo_template:addScreen(what_do_you_sell)

force_info = ConvoScreen:new {
  id = "force_info",
  customDialogText = "The Force is a powerful energy field that binds the galaxy together. It can be used for good or evil, depending on the user's intentions. If you're interested in learning more about the Force, I may be able to point you in the right direction.",
  stopConversation = "false",
  options = {
    { "Thanks, I'll take a look.", "goodbye" },
  }
}
jedi_shop_keeper_convo_template:addScreen(force_info)

goodbye = ConvoScreen:new {
  id = "goodbye",
  customDialogText = "May the Force be with you, Master.",
  stopConversation = "true",
  options = {}
}
jedi_shop_keeper_convo_template:addScreen(goodbye)

addConversationTemplate("jedi_shop_keeper_convo_template", jedi_shop_keeper_convo_template)