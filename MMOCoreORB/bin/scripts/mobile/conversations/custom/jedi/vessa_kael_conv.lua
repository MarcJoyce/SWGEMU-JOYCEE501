vessa_kael_convo_template = ConvoTemplate:new {
	initialScreen = "first_screen",
	templateType = "Lua",
	luaClassHandler = "vessaKaelConvoHandler",
	screens = {},
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "Good timing, I was just about to report in. Have you heard anything about the recent murders in the area?",
  stopConversation = "false",
  options = {
    { "Murders? I haven't heard anything. Are you Vessa Kael?", "explain_one" },
    { "I'm just passing through, I'll let you get back to your report.", "explain_one" },
  }
}
vessa_kael_convo_template:addScreen(first_screen);

explain_one = ConvoScreen:new {
  id = "explain_one",
  customDialogText = "Wait. Are you not the reinforcements I've been expecting? I was told to expect a detachment from Bestine. Strange. Well, in any case, I could use some help. There have been a series of murders in the area. I have narrowed the suspects down to three individuals, but I can't seem to determine who the culprit is. Would you be willing to help me investigate?",
  stopConversation = "false",
  options = {
    { "A murder mystery in the desert? Sign me up.", "explain_two" },
    { "I guess I could help out, for the right price.", "explain_two" },
  }
}
vessa_kael_convo_template:addScreen(explain_one);

explain_two = ConvoScreen:new {
  id = "explain_two",
  customDialogText = "The victim is... was, an officer of the Empire, so this must be your highest priority. There are three suspects; Rarrukk Graal, Jalen Vort, and Sskarr Vreen. Speak to them, and meet me back here.",
  stopConversation = "false",
  options = {
    { "Tell me more about Rarrukk Graal", "rarrukk" },
    { "Tell me more about Jalen Vort", "jalen" },
    { "Tell me more about Sskarr Vrenn", "sskarr" },
    { "Right, I'll be back once I've spoke with them.", "task_accept"}
  }
}
vessa_kael_convo_template:addScreen(explain_two);

rarrukk = ConvoScreen:new {
  id = "rarrukk",
  customDialogText = "Rarrukk Graal, a Wookiee mercenary for hire, he'll probably have ran to the saftey of the Hutts.",
  stopConversation = "false",
  options = {
    { "Tell me more about Jalen Vort", "jalen" },
    { "Tell me more about Sskarr Vrenn", "sskarr" },
    { "Right, I'll be back once I've spoke with them.", "task_accept"}
  }
}
vessa_kael_convo_template:addScreen(rarrukk);

jalen = ConvoScreen:new {
  id = "jalen",
  customDialogText = "Jalen Vort, a disgraced former imperial officer, who will be no doubt be lurking deep in a bar.",
  stopConversation = "false",
  options = {
    { "Tell me more about Rarrukk Graal", "rarrukk" },
    { "Tell me more about Sskarr Vrenn", "sskarr" },
    { "Right, I'll be back once I've spoke with them.", "task_accept"}
  }
}
vessa_kael_convo_template:addScreen(jalen);

sskarr = ConvoScreen:new {
  id = "sskarr",
  customDialogText = "Sskarr Vreen, an infamous Trandoshan slaver, he was last spotted heading to Mos Eisley Starport, but we have blocked all outgoing transports.",
  stopConversation = "false",
  options = {
    { "Tell me more about Jalen Vort", "jalen" },
    { "Tell me more about Rarrukk Graal", "rarrukk" },
    { "Right, I'll be back once I've spoke with them.", "task_accept"}
  }
}
vessa_kael_convo_template:addScreen(sskarr);

task_accept = ConvoScreen:new {
  id = "task_accept",
  customDialogText = "Hurry, time is of the essence. The longer we wait, the more likely the killer is to strike again.",
  stopConversation = "true",
  options = {}
}
vessa_kael_convo_template:addScreen(task_accept);

task_ongoing = ConvoScreen:new {
    id = "task_ongoing",
    customDialogText = "What are you doing back here? Go and speak with the suspects",
    stopConversation = "true",
    options = {}
}
vessa_kael_convo_template:addScreen(task_ongoing);

task_complete = ConvoScreen:new {
    id = "task_complete",
    customDialogText = "You're back. Good. Tell me you've found something I can use against one of those degenerates.",
    stopConversation = "false",
    options = {
        { "I found something... but not what you wanted.", "final_one" }
    }
}
vessa_kael_convo_template:addScreen(task_complete);

final_one = ConvoScreen:new {
    id = "final_one",
    customDialogText = "...Explain.",
    stopConversation = "false",
    options = {
        { "Rarruk Graal saw you meeting someone in secret before the murder. He said you were afraid.", "final_two" }
    }
}
vessa_kael_convo_template:addScreen(final_one);

final_two = ConvoScreen:new {
    id = "final_two",
    customDialogText = "Wookiee superstition. He smells 'fear' in every shadow.",
    stopConversation = "false",
    options = {
      { "Jalen Vort checked the requisition logs. Someone wiped the terminal minutes before the murder. Only an active-duty Imperial soldier could have done that.", "final_three" }
    }
}
vessa_kael_convo_template:addScreen(final_two);

final_three = ConvoScreen:new {
    id = "final_three",
    customDialogText = "...And",
    stopConversation = "false",
    options = {
      { "And Sskarr Vrenn said you were digging for dirt on the victim days before he died. Trying to give yourself a story... a scapegoat.", "final_four" }
    }
}
vessa_kael_convo_template:addScreen(final_three);

final_four = ConvoScreen:new {
    id = "final_four",
    customDialogText = "...So that's it. You think I did it.",
    stopConversation = "false",
    options = {
      { "I don't think. I know.", "final_five" }
    }
}
vessa_kael_convo_template:addScreen(final_four);

final_five = ConvoScreen:new {
    id = "final_five",
    customDialogText = "Fine, I admit it. He was going to expose me. He found out about the bribes. The cargo. The 'expedited' transfers. All of it. He forced my hand. Everything I've built... my career... my life... it was all about to collapse because of him. So I acted first. I had to. It was him or me.",
    stopConversation = "false",
    options = {
      { "So you tried to pin it on someone else?", "final_six" }
    }
}
vessa_kael_convo_template:addScreen(final_five);

final_six = ConvoScreen:new {
    id = "final_six",
    customDialogText = "What choice did I have? No one would have believed me if I said the officer was corrupt. No one trusts a disgraced imperial officer like Jalen Vort, or a mercenary like Rarruk Graal. And Sskarr Vrenn is a known criminal. They all had motives to want him dead. It was the perfect cover.",
    stopConversation = "false",
    options = {
      { "And now your cover is blown. Want some advice? Hand yourself in, prison is better than having the Empire on your tail the rest of your life.", "final_seven" }
    }
}
vessa_kael_convo_template:addScreen(final_six);

final_seven = ConvoScreen:new {
    id = "final_seven",
    customDialogText = "So be it. I'll face whatever comes. But know this; you have made a powerful enemy today. Vessa Kael does not forget those who cross her.",
    stopConversation = "true",
    options = {}
}
vessa_kael_convo_template:addScreen(final_seven);

revenge = ConvoScreen:new {
    id = "revenge",
    customDialogText = "Come to gloat? I'm sure you think this is some kind of victory. But you haven't seen the last of me. I'll be back, and next time, I won't be so forgiving.",
    stopConversation = "true",
    options = {}
}
vessa_kael_convo_template:addScreen(revenge);

addConversationTemplate("vessa_kael_convo_template", vessa_kael_convo_template);
