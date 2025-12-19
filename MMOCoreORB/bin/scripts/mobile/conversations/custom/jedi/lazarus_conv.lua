lazarus_convo_template = ConvoTemplate:new {
	initialScreen = "first_screen",
	templateType = "Lua",
	luaClassHandler = "lazarusConvoHandler",
	screens = {},
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "Who would seek the power to see must answer me these questions three, ere the other side shall be.",
  stopConversation = "false",
  options =  {
    { "Are you Lazarus Cain?", "question_one" },
    { "Ask me your questions.", "question_one" },
  },
}
lazarus_convo_template:addScreen(first_screen);

question_one = ConvoScreen:new {
  id = "question_one",
  customDialogText = "What is your name?",
  stopConversation = "false",
  options =  {},
}
lazarus_convo_template:addScreen(question_one);

question_two = ConvoScreen:new {
  id = "question_two",
  customDialogText = "What beast can be found lurking in Jabbas Palace?",
  stopConversation = "false",
  options =  {
    { "A Bramalish", "fail" },
    { "A Graul Marauder", "fail" },
    { "A Rancor", "question_three" },
  },
}
lazarus_convo_template:addScreen(question_two);

question_three = ConvoScreen:new {
  id = "question_three",
  customDialogText = "What is the airspeed velocity of an unladen Vynock?",
  stopConversation = "false",
  options =  {
    { "As fast as a BARC", "fail" },
    { "How am I supposed to know that?", "fail" },
    { "What do you mean? A Corellian or Talusian Vynock?", "success" }
  },
}
lazarus_convo_template:addScreen(question_three);

fail = ConvoScreen:new {
  id = "fail",
  customDialogText = "Hee hee heh.",
  stopConversation = "true",
  options =  {},
}
lazarus_convo_template:addScreen(fail);

success = ConvoScreen:new {
  id = "success",
  customDialogText = "Go on. Off you go.",
  stopConversation = "true",
  options =  {},
}
lazarus_convo_template:addScreen(success);

addConversationTemplate("lazarus_convo_template", lazarus_convo_template);
