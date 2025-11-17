selogelConvoTemplate = ConvoTemplate:new {
	initialScreen = "init_screen",
	templateType = "Lua",
	luaClassHandler = "selogelConvoHandler",
	screens = {},
};

init_screen = ConvoScreen:new {
  id = "init_screen",
  customDialogText = "May the Force be with you, Master Jedi… ah—wait, no, not yet.",
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
  customDialogText = "Hello there… again, or perhaps for the first time.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(hello_friend)

explain_one = ConvoScreen:new {
  id = "explain_one",
  customDialogText = "Forgive an old mind, friend. Time does not always flow in the right direction for me. Some days I see the galaxy through eyes that haven't opened yet.",
  stopConversation = "false",
  options =  {
    { "You better start making some sense, before I call the Stormtroopers.", "explain_two" },
    { "Future eyes? What does that mean?", "explain_two" },
  },
}

selogelConvoTemplate:addScreen(explain_one);

explain_two = ConvoScreen:new {
  id = "explain_two",
  customDialogText = "I serve only the Force. And the Force… well, it nudged you toward me. Gently for now. It's saving the shoving for later.",
  stopConversation = "false",
  options = {
    {"Ok sure; and did this magical force happen to tell you why it led me to you?", "explain_three" },
    {"The Force? Jedi? What are you trying to tell me, friend?", "explain_three" },
  },
}

selogelConvoTemplate:addScreen(explain_two);

explain_three = ConvoScreen:new {
  id = "explain_three",
  customDialogText = "The Force is what gives a Jedi his power. It is an energy field created by all living things. It surrounds us and penetrates us; it binds the galaxy together. You've felt it already. Even if you pretend you haven't.",
  stopConversation = "false",
  options = {
    {"Penetrates? Really...", "explain_four" },
    {"Go on...", "explain_four" },
  },
}

selogelConvoTemplate:addScreen(explain_three);

explain_four = ConvoScreen:new {
  id = "explain_four",
  customDialogText = "If you are to walk the path ahead, you must learn the ways of the Force. Only then can you follow me to Alderaan—ah… or what's left of Alderaan. I forget which era you think you're in.",
  stopConversation = "false",
  options = {
    {"Alderaan? You old fool, the Alderaanians destroyed their planet when they rebeled against the Empire. Go back to your drink and leave me be.", "explain_five" },
    {"Alderaan? Stay here, I will go and find a doctor for you.", "explain_five" },
  },
}

selogelConvoTemplate:addScreen(explain_four);

explain_five = ConvoScreen:new {
  id = "explain_five",
  customDialogText = "Wait—don't go. I can help you unlock truths the Empire buried… truths they'd silence you for knowing. But for that, I need your help as well.",
  stopConversation = "false",
  options = {
    {"What do you want from me?", "explain_six" },
    {"How can I be of service?", "explain_six" },
  },
}

selogelConvoTemplate:addScreen(explain_five);

explain_six = ConvoScreen:new {
  id = "explain_six",
  customDialogText = "The Empire teaches lies. Forget them for a moment and listen. Long before Palpatine… before Plagueis… before even the Ones who shaped the balance of the galaxy, there existed mysterious beings called the Whills.",
  stopConversation = "false",
  options = {
    {"The Whills?", "explain_seven" },
  },
}

selogelConvoTemplate:addScreen(explain_six);

explain_seven = ConvoScreen:new {
  id = "explain_seven",
  customDialogText = "They exist everywhere and nowhere. In all moments, and in none. Imagine Schrodinger's cat in a tardis. Yes, yes, I know—those words mean nothing here. Humor what's left of my mind.",
  stopConversation = "false",
  options = {
    {"Schrodinger? Tardis? What are these strange words?", "explain_eight" },
  },
}

selogelConvoTemplate:addScreen(explain_seven);

explain_eight = ConvoScreen:new {
  id = "explain_eight",
  customDialogText = "In time, friend. For now, your path begins. Focus. Listen. The Force is tugging at your sleeve.",
  stopConversation = "false",
  options = {
    {"Get to the point!?", "explain_nine" },
    {"Please, go on.", "explain_nine" },
  },
}

selogelConvoTemplate:addScreen(explain_eight);

explain_nine = ConvoScreen:new {
  id = "explain_nine",
  customDialogText = "Your sensitivity is locked… sealed long ago. This artifact can open it. I stole it from Palpatine himself, back when my mind still belonged to me. He shattered it—shattered me—for daring to take it. If he senses us speaking, we are both in danger. We must move quickly.",
  stopConversation = "false",
  options = {
    {"Ok...", "explain_ten" },
  },
}

selogelConvoTemplate:addScreen(explain_nine);

explain_ten = ConvoScreen:new {
  id = "explain_ten",
  customDialogText = "There are eight steps to awakening your connection to the Force. When they're complete, a friend—one you haven't met yet—will guide you towardecoming a Jedi. I've unlocked what I can… but more of the artifact remains veiled.",
  stopConversation = "false",
  options = {
    {"What do I need to do?", "explain_eleven" },
  },
}

selogelConvoTemplate:addScreen(explain_ten);

explain_eleven = ConvoScreen:new {
  id = "explain_eleven",
  customDialogText = "Your first test: reassemble the Orb of the Whills. It was broken—scattered across the galaxy like sparks in a solar wind. Eight fragments. Find them. Bring them to me. At least five are still on Tatooine… the sand remembers where it hides things.",
  stopConversation = "false",
  options = {
    {"Ok, find the pieces, assemble the orb, see you soon.", "explain_twelve"},
  },
}

selogelConvoTemplate:addScreen(explain_eleven);

explain_twelve = ConvoScreen:new {
  id = "explain_twelve",
  customDialogText = "Oh—impatient, are we? I suspected you'd want another clue.",
  stopConversation = "false",
  options = {
    {"That would be great", "trial_1_start"},
  },
}

selogelConvoTemplate:addScreen(explain_twelve);

trial_1_start = ConvoScreen:new {
  id = "trial_1_start",
  customDialogText = "The fragments pulse with the Force. That makes them valuable—and dangerous. Smugglers covet them. Traders hoard them. The strong simply *feel* them. A Hutt keeps one close. The Tuskens guard another with blood and tradition. Jawas… well, Jawas pick up anything not nailed down. And strangers from Lok fled this world too quickly—they may know something.  Go now. Do not return until all eight pieces are yours. Palpatine's shadow stretches far… and he likes to watch me suffer.",
  stopConversation = "true",
  options = {},
}

selogelConvoTemplate:addScreen(trial_1_start);

trial_1_ongoing = ConvoScreen:new {
  id = "trial_1_ongoing",
  customDialogText = "Back already? Without the pieces? No, no—Palpatine has eyes in every shadow. Hurry! Before my thoughts slip again.",
  stopConversation = "true",
  options = {},
}

selogelConvoTemplate:addScreen(trial_1_ongoing);

trial_1_complete = ConvoScreen:new {
  id = "trial_1_complete",
  customDialogText = "You've done it! The Orb hums with life once more. You've taken your first true step toward awakening.",
  stopConversation = "false",
  options = {
    { "It was a piece of cake. Whats next?", "trial_2_start"},
    { "It wasnt easy. Does this help unlock more steps?", "trial_2_start" },
  }
}
selogelConvoTemplate:addScreen(trial_1_complete)

trial_2_start = ConvoScreen:new {
  id = "trial_2_start",
  customDialogText = "Your next step is simple… deceptively simple. You must learn a new discipline—master a skill so thoroughly the Force takes notice. Become the best at… well, you'll find out soon enough.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_2_start)

trial_2_ongoing = ConvoScreen:new {
  id = "trial_2_ongoing",
  customDialogText = "Ah, my friend! How goes your training toward mastery of… wait, it'll come to me. Eventually.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_2_ongoing)

trial_2_complete = ConvoScreen:new {
  id = "trial_2_complete",
  customDialogText = "Excellent work, master of… that thing you mastered. Adaptability will serve you well before this journey ends.",
  stopConversation = "false",
  options = {
    { "What now old man?", "trial_3_explain" },
    { "It was fun learning some new skills, do you know the next step?", "trial_3_explain" },
  }
}
selogelConvoTemplate:addScreen(trial_2_complete)

trial_3_explain = ConvoScreen:new {
  id = "trial_3_explain",
  customDialogText = "The artifact has whispered a name: Vessa Kael. It insists—loudly—that she must die. I don't get to choose the tasks. I only relay them.",
  stopConversation = "false",
  options = {
    { "Now thats what Im talking about!", "trial_3_start" },
    { "Kill? I thought the Jedi did everything they could not to kill?", "trial_3_start" },
  }
}
selogelConvoTemplate:addScreen(trial_3_explain)

trial_3_start = ConvoScreen:new {
  id = "trial_3_start",
  customDialogText = "Whether you agree or not, the artifact is unwavering. Vessa Kael must fall. Travel to the Lucky Deposit—someone there knows where to find her.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_3_start)

trial_3_ongoing = ConvoScreen:new {
  id = "trial_3_ongoing",
  customDialogText = "I can't help you until Kael is gone. The artifact refuses to speak while her life still echoes.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_3_ongoing)

trial_3_complete = ConvoScreen:new {
  id = "trial_3_complete",
  customDialogText = "You've returned. Good. Though I sense… conflict in you. The deed is done, but the ripples still move.",
  stopConversation = "false",
  options = {
    { "I dont want to talk about it.", "trial_3_complete_two" },
    { "Did she really deserve to die?", "trial_3_complete_two" }
  }
}
selogelConvoTemplate:addScreen(trial_3_complete)

trial_3_complete_two = ConvoScreen:new {
  id = "trial_3_complete_two",
  customDialogText = "What's done is done. Dwelling is for those who never move forward. You may turn back now… but I hope you won't.",
  stopConversation = "false",
  options = {
    { "Do you know the next step?", "trial_4_start" },
    { "I will continue.", "trial_4_start" }
  }
}
selogelConvoTemplate:addScreen(trial_3_complete_two)

trial_4_start = ConvoScreen:new {
  id = "trial_4_start",
  customDialogText = "Good. Your next step brings you into your own past—into who you were before the galaxy told you who to be. You must again learn a skill… master a profession in its entirety.  
Prepare yourself.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_4_start)

trial_4_ongoing = ConvoScreen:new {
  id = "trial_4_ongoing",
  customDialogText = "Ah, my friend! How goes your training toward mastery of… wait, it'll come to me. Eventually.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_4_ongoing)

trial_4_complete = ConvoScreen:new {
  id = "trial_4_complete",
  customDialogText = "Is this a glitch in the matrix, or have we been here before? Anyway, great job Master of, that thing.",
  stopConversation = "false",
  options = {
    { "What now old man?", "trial_5_explain" },
    { "It was fun learning some new skills, do you know the next step?", "trial_5_explain" },
  }
}
selogelConvoTemplate:addScreen(trial_4_complete)

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