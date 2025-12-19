shae_torrvek_convo_template = ConvoTemplate:new {
  initialScreen = "first_screen",
  templateType = "Lua",
  luaClassHandler = "shaeTorrvekConvoHandler",
  screens = {}
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "Look alive. I don't have patience for the slow or the foolish.",
  stopConversation = "false",
  options = {
    { "I'm neither slow, nor foolish", "information" }
  }
}
shae_torrvek_convo_template:addScreen(first_screen)

ex_bounty_hunter = ConvoScreen:new {
  id = "ex_bounty_hunter",
  customDialogText = "Look who decided to grow a conscience... or run out of spine. Doesn't matter. You're not a hunter anymore, so don't waste my time.",
  stopConversation = "true",
  options = {}
}
shae_torrvek_convo_template:addScreen(ex_bounty_hunter)

not_bounty_hunter = ConvoScreen:new {
  id = "not_bounty_hunter",
  customDialogText = "You? A hunter? I've seen rancors with more experience than you. Scram.",
  stopConversation = "true",
  options = {}
}
shae_torrvek_convo_template:addScreen(not_bounty_hunter)

information = ConvoScreen:new {
  id = "information",
  customDialogText = "Listen carefully. You work for me now. I'll send targets your way. Dead only, no half measures, no mercy. Complete the assignments I give you, then report back. Survive a few of these hunts, and maybe I'll teach you a thing or two. Don't show up early, don't show up late. Show up when I tell you to.",
  stopConversation = "true",
  options = {}
}
shae_torrvek_convo_template:addScreen(information)

returned_early = ConvoScreen:new {
  id = "returned_early",
  customDialogText = "Look who showed up before the body cooled. Did you think I'd congratulate you for impatience?",
  stopConversation = "true",
  options = {}
}
shae_torrvek_convo_template:addScreen(returned_early)

training_i = ConvoScreen:new {
  id = "training_i",
  customDialogText = "Well, you didn't embarrass yourself... much. I suppose you're ready for some instruction. Try to survive it. Now get back out there, your next contract is coming.",
  stopConversation = "true",
  options = {}
}
shae_torrvek_convo_template:addScreen(training_i)

training_ii = ConvoScreen:new {
  id = "training_ii",
  customDialogText = "Huh. You're not completely useless. Maybe there's hope for you yet. Listen carefully, I won't repeat myself twice. Now get back out there, your next contract is coming.",
  stopConversation = "true",
  options = {}
}
shae_torrvek_convo_template:addScreen(training_ii)

training_iii = ConvoScreen:new {
  id = "training_iii",
  customDialogText = "Finally. You've proven you can handle a contract without turning it into a funeral for yourself. Don't get cocky, I teach, but I don't coddle. Now get back out there, your next contract is coming.",
  stopConversation = "true",
  options = {}
}
shae_torrvek_convo_template:addScreen(training_iii)

training_iv = ConvoScreen:new {
  id = "training_iv",
  customDialogText = "Looks like you finally stopped embarrassing the guild. You've earned my attention... and maybe a fraction of my respect. Don't expect kindness, surviving this line of work is reward enough.",
  stopConversation = "true",
  options = {}
}
shae_torrvek_convo_template:addScreen(training_iv)

no_more_work = ConvoScreen:new {
  id = "no_more_work",
  customDialogText = "Well, look at you... a proper hunter at last. I've got nothing left for you, so don't expect more handouts. Go make your own contracts, and don't get soft. The galaxy won't wait for you to rest.",
  stopConversation = "true",
  options = {}
}
shae_torrvek_convo_template:addScreen(no_more_work)

addConversationTemplate("shae_torrvek_convo_template", shae_torrvek_convo_template);