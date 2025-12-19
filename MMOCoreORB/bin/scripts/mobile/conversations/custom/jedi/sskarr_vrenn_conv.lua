sskarr_vrenn_convo_template = ConvoTemplate:new {
	initialScreen = "first_screen",
	templateType = "Lua",
	luaClassHandler = "sskarrVrennConvoHandler",
	screens = {},
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "Why do you bother me, I have no time for your concerns...",
  stopConversation = "false",
  options = {
    { "I'm investigating a murder, can you help?", "help_investigate" },
  }
}
sskarr_vrenn_convo_template:addScreen(first_screen);

help_investigate = ConvoScreen:new {
  id = "help_investigate",
  customDialogText = "Hssssk... I care little for your Imperial games. That officer... Kael... she came to me days before that officer was murdered. Wanted information about the victim. Asked if they owed credits, had enemies, made deals.",
  stopConversation = "false",
  options = {
    { "Kael thought someone wanted the officer dead?", "help_investigate_two" },
  }
}
sskarr_vrenn_convo_template:addScreen(help_investigate);

help_investigate_two = ConvoScreen:new {
  id = "help_investigate_two",
  customDialogText = "She was desperate to find a reason. Any reason. I told her the truth: they owed nothing. Clean record. Boring human.",
  stopConversation = "false",
  options = {
    { "How did Kael react?", "help_investigate_three" },
  }
}
sskarr_vrenn_convo_template:addScreen(help_investigate_two);

help_investigate_three = ConvoScreen:new {
  id = "help_investigate_three",
  customDialogText = "After that, she left in a rage. Said 'everyone has something to hide'... like she was looking for an excuse. A story. Most curious.",
  stopConversation = "false",
  options = {
    { "Curious? How so?", "help_investigate_four" },
  }
}
sskarr_vrenn_convo_template:addScreen(help_investigate_three);

help_investigate_four = ConvoScreen:new {
  id = "help_investigate_four",
  customDialogText = "Hssssk... No hunter searches that hard for prey... unless they already know their target.",
  stopConversation = "true",
  options = {}
}
sskarr_vrenn_convo_template:addScreen(help_investigate_four);

no_more = ConvoScreen:new {
  id = "no_more",
  customDialogText = "I've given you what you want, now leave before I get hungry.",
  stopConversation = "true",
  options = {}
}
sskarr_vrenn_convo_template:addScreen(no_more);

bye = ConvoScreen:new {
  id = "bye",
  customDialogText = "Hssssk... You should leave.",
  stopConversation = "true",
  options = {}
}
sskarr_vrenn_convo_template:addScreen(bye);

addConversationTemplate("sskarr_vrenn_convo_template", sskarr_vrenn_convo_template);