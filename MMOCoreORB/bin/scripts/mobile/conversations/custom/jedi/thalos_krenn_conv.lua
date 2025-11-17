thalos_krenn_convo_template = ConvoTemplate:new {
  initialScreen = "first_screen",
  templateType = "Lua",
  luaClassHandler = "thalosKrennConvoHandler",
  screens = {}
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "You're far from home, traveler… and your shadow lingers too long. Stormtroopers have been watching this district, and you're drawing their gaze. Tell me—why hunt for remnants of the Jedi?",
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
  customDialogText = "You speak with conviction… rare, these days. There was a time when hope echoed across the stars. Perhaps… perhaps you are the one the Force has been quietly nudging toward me.",
  stopConversation = "false",
  options = {
    { "What is it you have?", "reward" }
  }
}
thalos_krenn_convo_template:addScreen(honest)

greed = ConvoScreen:new {
  id = "greed",
  customDialogText = "Hmph. Credits. Always credits. Yet here you stand, alone, risking far more than a profit. Greed doesn't drive someone into the jaws of the Empire. Maybe you're not being entirely honest with yourself.",
  stopConversation = "false",
  options = {
    { "Maybe, what are you offering?", "reward" }
  }
}
thalos_krenn_convo_template:addScreen(greed)

drawn = ConvoScreen:new {
  id = "drawn",
  customDialogText = "Then the Force has brushed against you. Few feel its whisper. Fewer heed it. If something pulled you here… we should not ignore it.",
  stopConversation = "false",
  options = {
    { "Then let me seee what it's guided me to.", "reward" }
  }
}
thalos_krenn_convo_template:addScreen(drawn)

reward = ConvoScreen:new {
  id = "reward",
  customDialogText = "This fragment is all that remains of a Padawan I once knew. She died defending the Temple as the sky fell and the clones turned their guns upon us. Take it. Her courage should not lie forgotten beneath Imperial boots.",
  stopConversation = "true",
  options = {}
}
thalos_krenn_convo_template:addScreen(reward)

not_ready = ConvoScreen:new {
  id = "not_ready",
  customDialogText = "Go. Quickly. If the Empire senses a gathering here, neither of us will walk away from it.",
  stopConversation = "true",
  options = {}
}
thalos_krenn_convo_template:addScreen(not_ready)

complete = ConvoScreen:new {
  id = "complete",
  customDialogText = "Then our paths part here. Walk carefully—and may the Force be with you, wherever it leads.",
  stopConversation = "true",
  options = {}
}
thalos_krenn_convo_template:addScreen(complete)

addConversationTemplate("thalos_krenn_convo_template", thalos_krenn_convo_template);