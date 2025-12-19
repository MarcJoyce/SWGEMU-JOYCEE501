rarruk_graal_convo_template = ConvoTemplate:new {
	initialScreen = "first_screen",
	templateType = "Lua",
	luaClassHandler = "rarrukGraalConvoHandler",
	screens = {},
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "Grrr... What do you want? Can't you see I'm busy?",
  stopConversation = "false",
  options = {
    { "I'm investigating a murder, can you help?", "help_investigate" },
  }
}
rarruk_graal_convo_template:addScreen(first_screen);

help_investigate = ConvoScreen:new {
  id = "help_investigate",
  customDialogText = "Rrrgh... You seek answers about the officer? I have none that prove innocence... only what I saw.",
  stopConversation = "false",
  options = {
    { "What did you see?", "help_investigate_two" },
  }
}
rarruk_graal_convo_template:addScreen(help_investigate);

help_investigate_two = ConvoScreen:new {
  id = "help_investigate_two",
  customDialogText = "That night, the officer met someone in secret behind the comms station. They thought no one noticed. I smelled fear on them... sharp, bitter.",
  stopConversation = "false",
  options = {
    { "Did you see who they were meeting?", "help_investigate_three" },
  }
}
rarruk_graal_convo_template:addScreen(help_investigate_two);

help_investigate_three = ConvoScreen:new {
  id = "help_investigate_three",
  customDialogText = "Later, she confronted us; each of us; alone. Not as a commander... but like prey cornered. She warned me not to 'interfere with Imperial matters'.",
  stopConversation = "false",
  options = {
    { "Who questioned you?", "help_investigate_four" },
  }
}
rarruk_graal_convo_template:addScreen(help_investigate_three);

help_investigate_four = ConvoScreen:new {
  id = "help_investigate_four",
  customDialogText = "The other officer. Kael... Vessa Kael. I did nothing, I saw nothing. But the fear... it was real.",
  stopConversation = "true",
  options = {}
}
rarruk_graal_convo_template:addScreen(help_investigate_four);

no_more = ConvoScreen:new {
  id = "no_more",
  customDialogText = "Grrr... I have said all I know.",
  stopConversation = "true",
  options = {}
}
rarruk_graal_convo_template:addScreen(no_more);

bye = ConvoScreen:new {
  id = "bye",
  customDialogText = "Grrr...",
  stopConversation = "true",
  options = {}
}
rarruk_graal_convo_template:addScreen(bye);

addConversationTemplate("rarruk_graal_convo_template", rarruk_graal_convo_template);