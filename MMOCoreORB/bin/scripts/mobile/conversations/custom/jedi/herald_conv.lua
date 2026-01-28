herald_convo_template = ConvoTemplate:new {
	initialScreen = "first_screen",
	templateType = "Lua",
	luaClassHandler = "heraldConvoHandler",
	screens = {},
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "Oh! There you are. About time. You shine louder than a malfunctioning protocol droid. The Whills have given me quite the nudge 'Find this one,' they said, 'this one listens.' So! Congratulations, you are officially noticed. Don't panic, it only stings a little. I hope you can see me, I've chosen a form that you can comprehend, far less floaty than my usual self. Now then, are you ready to begin your journey?",
  stopConversation = "false",
  options =  {
    { "I am ready.", "herald_one" },
  },
}
herald_convo_template:addScreen(first_screen);

herald_one = ConvoScreen:new {
  id = "herald_one",
  customDialogText = "Phew, that's a relief! Imagine you'd have said no!! 'Ermm sorry great Whills of the beyond, this mortal has refused your ultimate power.' Anyway, a second herald is on his way, Much more... human shaped now, the mouse thing was just... a phase, we hope. He'll give you something, an anchor for your first steps. Don't lose it. Or do lose it. The Force tends to put thinks back where they belong.",
  stopConversation = "true",
  options =  { },
}
herald_convo_template:addScreen(herald_one);

unlearn = ConvoScreen:new {
  id = "unlearn",
  customDialogText = "Heeded your friends words not, did you? Unlearn what you have learned.",
  stopConversation = "true",
  options =  {},
}
herald_convo_template:addScreen(unlearn);

not_ready = ConvoScreen:new {
  id = "not_ready",
  customDialogText = "You shouldn't linger here.",
  stopConversation = "true",
  options =  {},
}
herald_convo_template:addScreen(not_ready);

addConversationTemplate("herald_convo_template", herald_convo_template);