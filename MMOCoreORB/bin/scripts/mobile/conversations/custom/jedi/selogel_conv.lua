selogelConvoTemplate = ConvoTemplate:new {
	initialScreen = "init_screen",
	templateType = "Lua",
	luaClassHandler = "selogelConvoHandler",
	screens = {},
};

init_screen = ConvoScreen:new {
  id = "init_screen",
  customDialogText = "May the Force be with you, Master Jedi... ah, wait, no, not yet.",
  stopConversation = "false",
  options =  {
    { "Shut up you drunken fool, you could get me in trouble!", "explain_one" },
    { "Sorry friend; you must have mistaken me for someone else, I am no Jedi", "explain_one" },
  },
}
selogelConvoTemplate:addScreen(init_screen);

hello_friend = ConvoScreen:new {
  id = "hello_friend",
  customDialogText = "Hello there... again, or perhaps for the first time.",
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
  customDialogText = "I serve only the Force. And the Force... well, it nudged you toward me. Gently for now. It's saving the shoving for later.",
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
  customDialogText = "If you are to walk the path ahead, you must learn the ways of the Force. Only then can you follow me to Alderaan, ah... or what's left of Alderaan. I forget which era you think you're in.",
  stopConversation = "false",
  options = {
    {"Alderaan? You old fool, the Alderaanians destroyed their planet when they rebeled against the Empire. Go back to your drink and leave me be.", "explain_five" },
    {"Alderaan? Stay here, I will go and find a doctor for you.", "explain_five" },
  },
}

selogelConvoTemplate:addScreen(explain_four);

explain_five = ConvoScreen:new {
  id = "explain_five",
  customDialogText = "Wait, don't go. I can help you unlock truths the Empire buried... truths they'd silence you for knowing. But for that, I need your help as well.",
  stopConversation = "false",
  options = {
    {"What do you want from me?", "explain_six" },
    {"How can I be of service?", "explain_six" },
  },
}

selogelConvoTemplate:addScreen(explain_five);

explain_six = ConvoScreen:new {
  id = "explain_six",
  customDialogText = "The Empire teaches lies. Forget them for a moment and listen. Long before Palpatine... before Plagueis... before even the Ones who shaped the balance of the galaxy, there existed mysterious beings called the Whills.",
  stopConversation = "false",
  options = {
    {"The Whills?", "explain_seven" },
  },
}

selogelConvoTemplate:addScreen(explain_six);

explain_seven = ConvoScreen:new {
  id = "explain_seven",
  customDialogText = "They exist everywhere and nowhere. In all moments, and in none. Imagine Schrodinger's cat in a tardis. Yes, yes, I know, those words mean nothing here. Humor what's left of my mind.",
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
  customDialogText = "Your sensitivity is locked... sealed long ago. This artifact can open it. I stole it from Palpatine himself, back when my mind still belonged to me. He shattered it, shattered me, for daring to take it. If he senses us speaking, we are both in danger. We must move quickly.",
  stopConversation = "false",
  options = {
    {"Ok...", "explain_ten" },
  },
}

selogelConvoTemplate:addScreen(explain_nine);

explain_ten = ConvoScreen:new {
  id = "explain_ten",
  customDialogText = "There are eight steps to awakening your connection to the Force. When they're complete, a friend, one you haven't met yet, will guide you toward becoming a Jedi. I've unlocked what I can... but more of the artifact remains veiled.",
  stopConversation = "false",
  options = {
    {"What do I need to do?", "explain_eleven" },
  },
}

selogelConvoTemplate:addScreen(explain_ten);

explain_eleven = ConvoScreen:new {
  id = "explain_eleven",
  customDialogText = "Your first test: reassemble the Orb of the Whills. It was broken, scattered across the galaxy like sparks in a solar wind. Eight fragments. Find them. Bring them to me. At least five are still on Tatooine... the sand remembers where it hides things.",
  stopConversation = "false",
  options = {
    {"Ok, find the pieces, assemble the orb, see you soon.", "explain_twelve"},
  },
}

selogelConvoTemplate:addScreen(explain_eleven);

explain_twelve = ConvoScreen:new {
  id = "explain_twelve",
  customDialogText = "Oh, impatient, are we? I suspected you'd want another clue.",
  stopConversation = "false",
  options = {
    {"That would be great", "trial_1_start"},
  },
}

selogelConvoTemplate:addScreen(explain_twelve);

trial_1_start = ConvoScreen:new {
  id = "trial_1_start",
  customDialogText = "The fragments pulse with the Force. That makes them valuable, and dangerous. Smugglers covet them. Traders hoard them. The strong simply feel them. A Hutt keeps one close. The Tuskens guard another with blood and tradition. Jawas... well, Jawas pick up anything not nailed down. And strangers from Lok fled this world too quickly, they may know something.  Go now. Do not return until all eight pieces are yours. Palpatine's shadow stretches far... and he likes to watch me suffer.",
  stopConversation = "true",
  options = {},
}

selogelConvoTemplate:addScreen(trial_1_start);

trial_1_ongoing = ConvoScreen:new {
  id = "trial_1_ongoing",
  customDialogText = "Back already? Without the pieces? No, no, Palpatine has eyes in every shadow. Hurry! Before my thoughts slip again.",
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
  customDialogText = "Your next step is simple... deceptively simple. You must learn a new discipline, master a skill so thoroughly the Force takes notice. Become the best at... well, you'll find out soon enough.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_2_start)

trial_2_ongoing = ConvoScreen:new {
  id = "trial_2_ongoing",
  customDialogText = "Ah, my friend! How goes your training toward mastery of... wait, it'll come to me. Eventually.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_2_ongoing)

trial_2_complete = ConvoScreen:new {
  id = "trial_2_complete",
  customDialogText = "Excellent work, master of... that thing you mastered. Adaptability will serve you well before this journey ends.",
  stopConversation = "false",
  options = {
    { "What now old man?", "trial_3_explain" },
    { "It was fun learning some new skills, do you know the next step?", "trial_3_explain" },
  }
}
selogelConvoTemplate:addScreen(trial_2_complete)

trial_3_explain = ConvoScreen:new {
  id = "trial_3_explain",
  customDialogText = "The artifact has whispered a name: Vessa Kael. She needs your help... or perhaps your end. The Whills are unclear. What is clear is that someone must be removed from the galaxy for your journey to continue. Maybe Vessa Kael is that someone.",
  stopConversation = "false",
  options = {
    { "Now thats what Im talking about!", "trial_3_start" },
    { "End, like death? I thought the Jedi did everything they could not to kill?", "trial_3_start" },
  }
}
selogelConvoTemplate:addScreen(trial_3_explain)

trial_3_start = ConvoScreen:new {
  id = "trial_3_start",
  customDialogText = "Whether you agree or not, the artifact is unwavering. Death is inevitable, and Vessa Kael is the key. I have marked her location in your datapad. Go there, learn what you can, and decide how to proceed.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_3_start)

trial_3_ongoing = ConvoScreen:new {
  id = "trial_3_ongoing",
  customDialogText = "I can't help you while your task remains incomplete. The artifact refuses to speak further until you have completed your task.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_3_ongoing)

trial_3_complete = ConvoScreen:new {
  id = "trial_3_complete",
  customDialogText = "You've returned. Good. Though I sense... conflict in you. The deed is done, but the ripples still move.",
  stopConversation = "false",
  options = {
    { "Vessa Kael was the murderer!? Did the artifact, did you know?", "trial_3_complete_two" }
  }
}
selogelConvoTemplate:addScreen(trial_3_complete)

trial_3_complete_two = ConvoScreen:new {
  id = "trial_3_complete_two",
  customDialogText = "What's done is done. Dwelling is for those who never move forward. You may turn back now... but I hope you won't.",
  stopConversation = "false",
  options = {
    { "Do you know the next step?", "trial_4_start" },
    { "Let's continue.", "trial_4_start" }
  }
}
selogelConvoTemplate:addScreen(trial_3_complete_two)

trial_4_start = ConvoScreen:new {
  id = "trial_4_start",
  customDialogText = "Good. Your next step brings you into your own past, into who you were before the galaxy told you who to be. You must again learn a skill... master a profession in its entirety. Prepare yourself.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_4_start)

trial_4_ongoing = ConvoScreen:new {
  id = "trial_4_ongoing",
  customDialogText = "Ah, my friend! How goes your training toward mastery of... wait, it'll come to me. Eventually.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_4_ongoing)

trial_4_complete = ConvoScreen:new {
  id = "trial_4_complete",
  customDialogText = "Is this a glitch in the matrix, or have we been here before? Anyway, great job Master... of that thing.",
  stopConversation = "false",
  options = {
    { "What now old man?", "trial_5_start" },
    { "It was fun learning some new skills, do you know the next step?", "trial_5_start" },
  }
}
selogelConvoTemplate:addScreen(trial_4_complete)

trial_5_start = ConvoScreen:new {
  id = "trial_5_start",
  customDialogText = "Two names echo through the resonance of the Force... Cozmic and Sap. Their pain weighs heavily, like chains. You must go to Endor and seek them out. Tread carefully, friend; this trial is steeped in conflict.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_5_start)

trial_5_ongoing = ConvoScreen:new {
  id = "trial_5_ongoing",
  customDialogText = "The currents of the Force remain clouded until you help settle the turmoil between Cozmic and Sap. Travel to Endor. Resolve their suffering, or the path will remain closed to you.",
  stopConversation = "true",
  options = {}
}
selogelConvoTemplate:addScreen(trial_5_ongoing)

trial_5_complete = ConvoScreen:new {
  id = "trial_5_complete",
  customDialogText = "You return... and the Force feels steadier around you. Your steps grow more certain, yet a disturbance lies ahead. Something unforeseen.",
  stopConversation = "false",
  options = {
    { "What now?", "trial_6_explain" },
    { "That doesn't sound good...", "trial_6_explain" }
  }
}
selogelConvoTemplate:addScreen(trial_5_complete)

trial_6_explain = ConvoScreen:new {
  id = "trial_6_explain",
  customDialogText = "Your next trial comes from the Whills themseleves. The inscription is... cryptic. It's message is illegible but does say: 'Speak the word.'. What that means... even I cannot tell.",
  stopConversation = "false",
  options = {
    { "Show me the inscription.", "trial_6_explain_two" }
  }
}
selogelConvoTemplate:addScreen(trial_6_explain)

trial_6_explain_two = ConvoScreen:new {
  id = "trial_6_explain_two",
  customDialogText = "Here. Look closely; etched into the fragment's memory. A single name reverberates as if spoken through time itself: Lazarus Cain.",
  stopConversation = "false",
  options = {
    { "Sounds like a trick. Who is Lazarus Cain?", "trial_6_start" },
    { "So... Lazarus Cain is the word?", "trial_6_start" }
  }
}
selogelConvoTemplate:addScreen(trial_6_explain_two)

trial_6_start = ConvoScreen:new {
  id = "trial_6_start",
  customDialogText = "The name stirs an old memory... I once crossed paths with a man called Cain on Dathomir, near a Force spring that the Nightsisters fear. If he still lives, he may know why the Whills speak his name.",
  stopConversation = "true",
  options = { }
}
selogelConvoTemplate:addScreen(trial_6_start)

trial_6_ongoing = ConvoScreen:new {
  id = "trial_6_ongoing",
  customDialogText = "The inscription hasn't changed. The name remains. Find this Cain, Hear his truth. Until then, the Force will offer us nothing more.",
  stopConversation = "true",
  options = { }
}
selogelConvoTemplate:addScreen(trial_6_ongoing)

completed_lazarus = ConvoScreen:new {
  id = "completed_lazarus",
  customDialogText = "Ah, friend... the inscription shifts again, though much remains shrouded. You found Lazarus, yes? What knowledge, or riddles, did he impart?",
  stopConversation = "false",
  options = { 
    { "I found him, he asked me some rather strange questions, then told me to leave.", "trial_6_part_one" },
  }
}
selogelConvoTemplate:addScreen(completed_lazarus)

trial_6_part_one = ConvoScreen:new {
  id = "trial_6_part_one",
  customDialogText = "Curious... indeed most curious. Ancient texts speak of these inscriptions as gateways to insight. Some trials may appear... peculiar, even nonsensical, but the Force flows through all of them.",
  stopConversation = "false",
  options = { 
    { "Ok... Let's hear your list.", "trial_6_part_one_two" }
  }
}
selogelConvoTemplate:addScreen(trial_6_part_one)

trial_6_part_one_two = ConvoScreen:new {
  id = "trial_6_part_one_two",
  customDialogText = "I have studied many such prophecies and glyphs. There are theories, legends and perhaps deceptions. Yet each contains a spark of truth... or folly. Here, the list:",
  stopConversation = "false",
  options = { 
    { "I'm ready.", "trial_6_part_one_three" }
  }
}
selogelConvoTemplate:addScreen(trial_6_part_one_two)

trial_6_part_one_three = ConvoScreen:new {
  id = "trial_6_part_one_three",
  customDialogText = "Master six skills, obtain ten Ancient Krayt Dragon hides, spend irl 'credits' to awaken Force sensitivity, be born with high midi-chlorians, be called 'Jett' and inherit all things, collect 'Theme Park' badges, visit key locations across the galaxy, dwell in this realm for a full galactic cycle, suffer a fatal wound and finally... confront the Meatlump King.",
  stopConversation = "false",
  options = { 
    { "I... what is irl? Who is 'Jett'? And what manner of Theme Park? Death?! I think I need a drink.", "trial_6_decipher_start" }
  }
}
selogelConvoTemplate:addScreen(trial_6_part_one_three)

trial_6_decipher_start = ConvoScreen:new {
  id = "trial_6_decipher_start",
  customDialogText = "Ah yes, the Pan-Galactic-Gargle-Blaster works wonders for clarity. Some of these trials may seem absurd, but each contains a seed of truth. You must depart now. Once the inscriptions reveal further secrets, I will summon you. I feel a disturbance... Palpatine or perhaps the Whills. Stay vigilant, friend.",
  stopConversation = "true",
  options = { }
}
selogelConvoTemplate:addScreen(trial_6_decipher_start)

trial_6_ongoing_decipher = ConvoScreen:new {
  id = "trial_6_ongoing_decipher",
  customDialogText = "The glyphs remain veiled. Continue your work. When the text is fully unveiled, I shall summon you.",
  stopConversation = "true",
  options = { }
}
selogelConvoTemplate:addScreen(trial_6_ongoing_decipher)

trial_6_complete_decipher = ConvoScreen:new {
  id = "trial_6_complete_decipher",
  customDialogText = "It is done... the inscription is clear at last. Your trial is ready. Speak the word, and the path to Force mastery shall unfold.",
  stopConversation = "true",
  options = { }
}
selogelConvoTemplate:addScreen(trial_6_complete_decipher)

trial_6_complete = ConvoScreen:new {
  id = "trial_6_complete",
  customDialogText = "You've done it. And now... the next trial, your penultimate step. Oh dear...",
  stopConversation = "false",
  options = {
    { "'Oh dear' never sounds promising.", "trial_7_start"}
   }
}
selogelConvoTemplate:addScreen(trial_6_complete)

trial_7_start = ConvoScreen:new {
  id = "trial_7_start",
  customDialogText = "This trial demands two relics of knowledge; one born of purity, the other steeped in corruption. I cannot assist you here, my friend. Bring these two artifacts to me, and together they shall open the path to the final test.",
  stopConversation = "true",
  options = { }
}
selogelConvoTemplate:addScreen(trial_7_start)

trial_7_ongoing = ConvoScreen:new {
  id = "trial_7_ongoing",
  customDialogText = "I have searched every archive I can, but the answer remains hidden. Still, look how far you've come. I have no doubt you will uncover what is needed.",
  stopConversation = "true",
  options = { }
}
selogelConvoTemplate:addScreen(trial_7_ongoing)

trial_7_complete = ConvoScreen:new {
  id = "trial_7_complete",
  customDialogText = "Of course... how could I have been so blind? A Jedi Holocron, and a Sith Holocron. Light and dark, knowledge opposed yet intertwined. Very well... but we must tread carefully",
  stopConversation = "false",
  options = {
    { "What must be done to reveal the final test?", "trial_8_explain" }
   }
}
selogelConvoTemplate:addScreen(trial_7_complete)

trial_8_explain = ConvoScreen:new {
  id = "trial_8_explain",
  customDialogText = "You need do nothing more. I can open the path, but at great cost. Thank you, my friend, for your companionship through all of this. But now... I feel his presence clawing at my mind, Palpatine, pushing to control the knowledge. I must use everything I have to unlock your final trial. If this is my last act... then it is worth it.",
  stopConversation = "false",
  options = {
    { "No, there must be another way!", "trial_8_start" }
   }
}
selogelConvoTemplate:addScreen(trial_8_explain)

trial_8_start = ConvoScreen:new {
  id = "trial_8_start",
  customDialogText = "Do not grieve. Yesterday is history, tomorrow is a mystery, but today... today is a gift. And you must use it wisely. Your final test is simple to say, but difficult to live: 'You must unlearn what you have learned.' Cast aside all you think you know... then seek the place where the Chosen One was discovered. Only there will the Force reveal your path.",
  stopConversation = "true",
  options = { }
}
selogelConvoTemplate:addScreen(trial_8_start)

addConversationTemplate("selogelConvoTemplate", selogelConvoTemplate);

