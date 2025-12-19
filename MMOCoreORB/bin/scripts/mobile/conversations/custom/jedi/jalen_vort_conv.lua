jalen_vort_convo_template = ConvoTemplate:new {
	initialScreen = "first_screen",
	templateType = "Lua",
	luaClassHandler = "jalenVortConvoHandler",
	screens = {},
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "What do you want? Can't you see I want to be left alone?",
  stopConversation = "false",
  options = {
    { "I'm investigating a murder, can you help?", "help_investigate" },
  }
}
jalen_vort_convo_template:addScreen(first_screen);

help_investigate = ConvoScreen:new {
  id = "help_investigate",
  customDialogText = "Listen... I'm not protecting anyone, least of all the Empire. But I didn't kill that officer. Despite what Vessa Kael will have you believe.",
  stopConversation = "false",
  options = {
    { "What did you see?", "help_investigate_two" },
  }
}
jalen_vort_convo_template:addScreen(help_investigate);

help_investigate_two = ConvoScreen:new {
  id = "help_investigate_two",
  customDialogText = "The night it happened, I was in the supply depot trying to requisition a replacement for my rifle. The requisition terminal was locked out. Someone had accessed it not ten minutes before I arrived.",
  stopConversation = "false",
  options = {
    { "Did you see who had accessed it?", "help_investigate_three" },
  }
}
jalen_vort_convo_template:addScreen(help_investigate_two);

help_investigate_three = ConvoScreen:new {
  id = "help_investigate_three",
  customDialogText = "No, they were long gone by then. Killed the log entirely. That's something only an active-duty soldier can do. I didn't think much of it... until I heard about the murder. Whoever did it was armed with an Imperial-grade holdout. That's not easy to come by.",
  stopConversation = "false",
  options = {
    { "Who do you think it was?", "help_investigate_four" },
  }
}
jalen_vort_convo_template:addScreen(help_investigate_three);

help_investigate_four = ConvoScreen:new {
  id = "help_investigate_four",
  customDialogText = "I don't know, but the only person on this dust-ball who still has override access to weapons requisitions... isn't me.",
  stopConversation = "true",
  options = {}
}
jalen_vort_convo_template:addScreen(help_investigate_four);

no_more = ConvoScreen:new {
  id = "no_more",
  customDialogText = "I have said all I know. Leave me be.",
  stopConversation = "true",
  options = {}
}
jalen_vort_convo_template:addScreen(no_more);

bye = ConvoScreen:new {
  id = "bye",
  customDialogText = "Leave me be.",
  stopConversation = "true",
  options = {}
}
jalen_vort_convo_template:addScreen(bye);

addConversationTemplate("jalen_vort_convo_template", jalen_vort_convo_template);
