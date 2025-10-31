thalos_krenn_convo_template = ConvoTemplate:new {
  initialScreen = "first_screen",
  templateType = "Lua",
  luaClassHandler = "thalosKrennConvoHandler",
  screens = {}
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "You're not from around here... and your stalking is drawing stormtroops attention here. Why are you searching for Jedi relics?",
  stopConversation = "false",
  options = {
    { "I believe in what they stood for. The Jedi meant something", "honest" },
    { "Heard Jedi artifacts sell well. Figured I'd try my luck", "greed" },
    { "I dont know... something drew me here.", "drawn" }
  }
}
thalos_krenn_convo_template:addScreen(first_screen)

honest = ConvoScreen:new {
  id = "honest",
  customDialogText = "You speak like someone who still believes the galaxy can be better. Maybe you're the one I've been waiting for.",
  stopConversation = "false",
  options = {
    { "What is it you have?", "reward" }
  }
}
thalos_krenn_convo_template:addScreen(honest)

greed = ConvoScreen:new {
  id = "greed",
  customDialogText = "Tch. Greed... Yet, here you are, alone. Maybe there's more to you.",
  stopConversation = "false",
  options = {
    { "Maybe, what are you offering?", "reward" }
  }
}
thalos_krenn_convo_template:addScreen(greed)

drawn = ConvoScreen:new {
  id = "drawn",
  customDialogText = "The Force calls in whispers. Few hear it. Fewer follow. Perhaps... it brought you here.",
  stopConversation = "false",
  options = {
    { "Then let me seee what it's guided me to.", "reward" }
  }
}
thalos_krenn_convo_template:addScreen(drawn)

reward = ConvoScreen:new {
  id = "reward",
  customDialogText = "This shard once belonged to a Padawan who died defending the Temple. Now... it belongs to you.",
  stopConversation = "true",
  options = {}
}
thalos_krenn_convo_template:addScreen(reward)

not_ready = ConvoScreen:new {
  id = "not_ready",
  customDialogText = "Get out of here, I don't need the stormtroopers sniffing around here.",
  stopConversation = "true",
  options = {}
}
thalos_krenn_convo_template:addScreen(not_ready)

complete = ConvoScreen:new {
  id = "complete",
  customDialogText = "May the Force be with you.",
  stopConversation = "true",
  options = {}
}
thalos_krenn_convo_template:addScreen(complete)

addConversationTemplate("thalos_krenn_convo_template", thalos_krenn_convo_template);