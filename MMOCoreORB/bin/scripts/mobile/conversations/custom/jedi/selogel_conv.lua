selogelConvoTemplate = ConvoTemplate:new {
	initialScreen = "init_screen",
	templateType = "Lua",
	luaClassHandler = "selogelConvoHandler",
	screens = {},
};

init_screen = ConvoScreen:new {
  id = "init_screen",
  customDialogText = "May the force be with you, Master Jedi.",
  leftDialog = "",
  stopConversation = "false",
  options =  {
    { "Shut up you drunken fool, you could get me in trouble!", "explain_one" },
    { "Sorry friend; you must have mistaken me for someone else, I am no Jedi", "explain_one" },
  },
}
selogelConvoTemplate:addScreen(init_screen);

hello_friend = ConvoScreen:new {
  id = "hello_friend",
  customDialogText = "Hello there.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(hello_friend)

explain_one = ConvoScreen:new {
  id = "explain_one",
  customDialogText = "Oh, forgive me, you are not ready yet. It must still be early for you. Sometimes I see the galaxy through my future eyes.",
  stopConversation = "false",
  options =  {
    { "You better start making some sense, before I call the Stormtroopers.", "explain_two" },
    { "Future eyes? What does that mean?", "explain_two" },
  },
}

selogelConvoTemplate:addScreen(explain_one);

explain_two = ConvoScreen:new {
  id = "explain_two",
  customDialogText = "I am but a humble servant of the force, and it the force that has led you to me.",
  stopConversation = "false",
  options = {
    {"Ok sure; and did this magical force happen to tell you why it led me to you?", "explain_three" },
    {"The Force? Jedi? What are you trying to tell me, friend?", "explain_three" },
  },
}

selogelConvoTemplate:addScreen(explain_two);

explain_three = ConvoScreen:new {
  id = "explain_three",
  customDialogText = "The Force is what gives a Jedi his power. It is an energy field created by all living things. It surrounds us and penetrates us; it binds the galaxy together.",
  stopConversation = "false",
  options = {
    {"Penetrates? Really...", "explain_four" },
    {"Go on...", "explain_four" },
  },
}

selogelConvoTemplate:addScreen(explain_three);

explain_four = ConvoScreen:new {
  id = "explain_four",
  customDialogText = "You must learn the ways of the Force if you are to come with me to Alderaan.",
  stopConversation = "false",
  options = {
    {"Alderaan? You old fool, the Alderaanians destroyed their planet when they rebeled against the Empire. Go back to your drink and leave me be.", "explain_five" },
    {"Alderaan? Stay here, I will go and find a doctor for you.", "explain_five" },
  },
}

selogelConvoTemplate:addScreen(explain_four);

explain_five = ConvoScreen:new {
  id = "explain_five",
  customDialogText = "Wait, please just wait. I can help you to unlock secrets you never knew existed. I just need your help",
  stopConversation = "false",
  options = {
    {"What do you want from me?", "explain_six" },
    {"How can I be of service?", "explain_six" },
  },
}

selogelConvoTemplate:addScreen(explain_five);

explain_six = ConvoScreen:new {
  id = "explain_six",
  customDialogText = "Forget everything the Empire has taught you and listen. A millenia ago, before Emperor Palpatine, before Plageius; before even the Father, the Son and the Daughter; there lived a community of beings called the Whills.",
  stopConversation = "false",
  options = {
    {"The Whills?", "explain_seven" },
  },
}

selogelConvoTemplate:addScreen(explain_six);

explain_seven = ConvoScreen:new {
  id = "explain_seven",
  customDialogText = "They both exist, and do not exist, throughout all of time and space; at all times and at no times. Think schrodinger's cat in a tardis.",
  stopConversation = "false",
  options = {
    {"Schrodinger? Tardis? Cat? What are these strange words?", "explain_eight" },
  },
}

selogelConvoTemplate:addScreen(explain_seven);

explain_eight = ConvoScreen:new {
  id = "explain_eight",
  customDialogText = "All in good time friend, what is important right now is that you begin your journey. Now listen.",
  stopConversation = "false",
  options = {
    {"Get to the point!?", "explain_nine" },
    {"Please, go on.", "explain_nine" },
  },
}

selogelConvoTemplate:addScreen(explain_eight);

explain_nine = ConvoScreen:new {
  id = "explain_nine",
  customDialogText = "The key to unlocking your force sensitivity lies within this artifact. I stole this from Palpatine many years ago on Naboo; he cursed my mind and I am stuck in a constant battle with him. I fear he senses I am talking to you so we must be quick, so please listen carefully.",
  stopConversation = "false",
  options = {
    {"Ok...", "explain_ten" },
  },
}

selogelConvoTemplate:addScreen(explain_nine);

explain_ten = ConvoScreen:new {
  id = "explain_ten",
  customDialogText = "There are eight steps to unlocking your force sensitivity, after which a friend will visit you to set you on the path to becoming a Jedi. I have managed to unlock a few of the secrets so far; but I need time to unlock the rest.",
  stopConversation = "false",
  options = {
    {"What do I need to do?", "explain_eleven" },
  },
}

selogelConvoTemplate:addScreen(explain_ten);

explain_eleven = ConvoScreen:new {
  id = "explain_eleven",
  customDialogText = "The first step involves assembling the orb of the Whills, that will aid me in unlocking more of the artifact. The orb was broken and split across the galaxy. There are eight pieces you must find and return to me. Fear not, for at least five of the pieces are here on Tatooine.",
  stopConversation = "false",
  options = {
    {"Ok, find the pieces, assemble the orb, see you soon.", "explain_twelve"},
  },
}

selogelConvoTemplate:addScreen(explain_eleven);

explain_twelve = ConvoScreen:new {
  id = "explain_twelve",
  customDialogText = "Oh, I thought you would want another clue..",
  stopConversation = "false",
  options = {
    {"That would be great", "trial_1_start"},
  },
}

selogelConvoTemplate:addScreen(explain_twelve);

trial_1_start = ConvoScreen:new {
  id = "trial_1_start",
  customDialogText = "The pieces of the orb are strong with force energy; so will be highly coveted by smugglers, traders and those strong in the force. I hear a rumour the great Hutt has a piece in his possession, as do the mighty Tusken warriors. The Jawas are notorious for picking up forgotten and lost things. Some strangers from Lok left in a hurry; maybe they have information that could assist you. Now, you must go, do not return until you have assembled all eight pieces. Palpatine is likely to be watching us.",
  stopConversation = "true",
  options = {},
}

selogelConvoTemplate:addScreen(trial_1_start);

trial_1_ongoing = ConvoScreen:new {
  id = "trial_1_ongoing",
  customDialogText = "What are you doing back here without the pieces, Palpatine has spies everywhere. Hurry, theres no time to lose.",
  stopConversation = "true",
  options = {},
}

selogelConvoTemplate:addScreen(trial_1_ongoing);

trial_1_complete = ConvoScreen:new {
  id = "trial_1_complete",
  customDialogText = "Fantastic work my friend; you have assembled all the pieces, I hope it wasnt too difficult. You have made great strides towards unlocking your force potential.",
  stopConversation = "false",
  options = {
    { "It was a piece of cake. Whats next?", "trial_2_start"},
    { "It wasnt easy. Does this help unlock more steps?", "trial_2_start" },
  }
}
selogelConvoTemplate:addScreen(trial_1_complete)

trial_2_start = ConvoScreen:new {
  id = "trial_2_start",
  customDialogText = "The next step in your journey is fairly simple. You must learn a new skill. Not just learn any skill, you must master the art by becoming...",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_2_start)

trial_2_ongoing = ConvoScreen:new {
  id = "trial_2_ongoing",
  customDialogText = "Hello friend, how goes your learning towards your mastery of...",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_2_ongoing)

trial_2_complete = ConvoScreen:new {
  id = "trial_2_complete",
  customDialogText = "Congratulations master. Your adaptability will come in most handy as you continue on through your journey.",
  stopConversation = "false",
  options = {
    { "What now old man?", "trial_3_explain" },
    { "It was fun learning some new skills, do you know the next step?", "trial_3_explain" },
  }
}
selogelConvoTemplate:addScreen(trial_2_complete)

trial_3_explain = ConvoScreen:new {
  id = "trial_3_explain",
  customDialogText = "Does the name Kraven Drax mean anything to you? The artifact has given his name and requires you to kill him.",
  stopConversation = "false",
  options = {
    { "Now thats what Im talking about!", "trial_3_start" },
    { "Kill? I thought the Jedi did everything they could not to kill?", "trial_3_start" },
  }
}
selogelConvoTemplate:addScreen(trial_3_explain)

trial_3_start = ConvoScreen:new {
  id = "trial_3_start",
  customDialogText = "Yes, well the artifact is quite clear. You must kill Kraven Drax. Head to the Lucky Deposit, theres someone inside with information.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_3_start)

trial_3_ongoing = ConvoScreen:new {
  id = "trial_3_ongoing",
  customDialogText = "Hello friend, I have nothing for you until Kraven is dead.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_3_ongoing)

trial_3_complete = ConvoScreen:new {
  id = "trial_3_complete",
  customDialogText = "Hello friend, I trust you were able to complete the task unscathed.",
  stopConversation = "false",
  options = {
    { "I dont want to talk about it.", "trial_3_complete_two" },
    { "Did he really deserve to die?", "trial_3_complete_two" }
  }
}
selogelConvoTemplate:addScreen(trial_3_complete)

trial_3_complete_two = ConvoScreen:new {
  id = "trial_3_complete_two",
  customDialogText = "Whatever happened, has happened. You cannot dwell on the past. You can stop these trials at any point, but I hope you continue.",
  stopConversation = "false",
  options = {
    { "Do you know the next step?", "trial_4_start" },
    { "I will continue.", "trial_4_start" }
  }
}
selogelConvoTemplate:addScreen(trial_3_complete_two)

trial_4_start = ConvoScreen:new {
  id = "trial_4_start",
  customDialogText = "Good, good. We are to revisit the past with this next step. You are required to learn a new skill, mastering the profession of...",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_4_start)

-- trial_4_ongoing = ConvoScreen:new {
--   id = "trial_4_ongoing",
--   customDialogText = "Hello friend, how goes your learning towards your mastery of...",
--   stopConversation = "true",
--   options = {}
-- }
-- selogelConvoTemplate:addScreen(trial_4_ongoing)

-- trial_4_complete = ConvoScreen:new {
--   id = "trial_4_complete",
--   customDialogText = "Congratulations master. Yet again, you have shown great perseverance and determination, both traits that will serve you well in the days to come.",
--   stopConversation = "false",
--   options = {
--     { "Four down, four to go. What next?", "trial_5_explain" },
--     { "I feel good, do you know what the next step is?, do you know the next step?", "trial_5_explain" }
--   }
-- }
-- selogelConvoTemplate:addScreen(trial_4_complete)

-- trial_5_explain = ConvoScreen:new {
--   id = "trial_5_explain",
--   customDialogText = "I can see two names, Cozmic and Sap; go to Endor and seek them out. Be careful friend; I sense a lot of pain and conflict in this trial",
--   stopConversation = "true",
--   options = {}
-- }
-- selogelConvoTemplate:addScreen(trial_5_explain)

-- trial_5_ongoing = ConvoScreen:new {
--   id = "trial_5_ongoing",
--   customDialogText = "I have nothing for you until you have resolved the issue with Cozmic and Sap. Head to Endor and seek them out.",
--   stopConversation = "true",
--   options = {}
-- }
-- selogelConvoTemplate:addScreen(trial_5_ongoing)

-- trial_5_complete = ConvoScreen:new {
--   id = "trial_5_complete",
--   customDialogText = "Hello friend, I am glad to see you. You are making great progress, but we have a problem.",
--   stopConversation = "false",
--   options = {
--     { "What now?", "trial_6_explain" },
--     { "Oh no, whats the issue?", "trial_6_explain"}
--   }
-- }
-- selogelConvoTemplate:addScreen(trial_5_complete)

-- trial_6_explain = ConvoScreen:new {
--   id = "trial_6_explain",
--   customDialogText = "Your next trial has been decided; though I cannot decipher what the Whills require you to do. All it says is you must speak the word.",
--   stopConversation = "false",
--   options = {
--     { "Can you show me?", "trial_6_explain_two" }
--   }
-- }
-- selogelConvoTemplate:addScreen(trial_6_explain)

-- trial_6_explain_two = ConvoScreen:new {
--   id = "trial_6_explain_two",
--   customDialogText = "Of course, here",
--   stopConversation = "false",
--   options = {
--     { "Is this some sort of trick old man? Who is Lazarus Cain", "trial_6_start" },
--     { "Lazarus Cain, is that a name?", "trial_6_start" }
--   }
-- }
-- selogelConvoTemplate:addScreen(trial_6_explain_two)

-- trial_6_start = ConvoScreen:new {
--   id = "trial_6_start",
--   customDialogText = "Lazarus Cain? Lazarus.. Cain..? I recall meeting a man called Cain on Dathomir once upon a time. He had a hut near the force spring. Perhaps you should find him and see if he has any knowledge to share?",
--   stopConversation = "true",
--   options = {}
-- }
-- selogelConvoTemplate:addScreen(trial_6_start)

-- trial_6_ongoing_one = ConvoScreen:new {
--   id = "trial_6_ongoing_one",
--   customDialogText = "Nothing has changed friend, here look. Did you find Cain, did you tell you anything? No? Then what are you doing here? Go find him!",
--   stopConversation = "true",
--   options= {}
-- }
-- selogelConvoTemplate:addScreen(trial_6_ongoing_one)

addConversationTemplate("selogelConvoTemplate", selogelConvoTemplate);