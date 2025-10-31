han_solo_glowing_convo_template = ConvoTemplate:new {
  initialScreen = "first_screen",
  templateType = "Lua",
  luaClassHandler = "hanSoloConvoHandler",
  screens = {}
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "Listen up kid, I'm not one for asking for favours, especially people I don't know; but I'm stuck here waiting and need someone to check on the ship me and Chewie commandeered. Think you're up to the task?",
  stopConversation = "false",
  options = {
    { "Sure thing, I can do that!", "accept" },
  }
}
han_solo_glowing_convo_template:addScreen(first_screen)

imperial = ConvoScreen:new {
  id = "imperial",
  customDialogText = "You think some Imperial is going to waltz into a Rebel stronghold and arrest me? I'll let you off this time. Now are you gonna help me out or not? There's a reward in it for you.",
  stopConversation = "false",
  options = {
    { "Fine, where is your ship?", "accept" },
    { "No, I don't deal with Rebels.", "leave" }
  }
}
han_solo_glowing_convo_template:addScreen(imperial)

accept = ConvoScreen:new {
  id = "accept",
  customDialogText = "I parked it just on the outskirts of town, head over there and check no dammed Tuskens are lurking around, or them pesky Jawas have started stripping her for parts.",
  stopConversation = "false",
  options = {
    { "I'm on my way!", "accept_quest" },
  }
}
han_solo_glowing_convo_template:addScreen(accept)

leave = ConvoScreen:new {
  id = "leave",
  customDialogText = "That's a shame kid. You better get out of here before Chewie gets back.",
  stopConversation = "true",
  options = {}
}
han_solo_glowing_convo_template:addScreen(leave)

accept_quest = ConvoScreen:new {
  id = "accept_quest",
  customDialogText = "Great kid! I'll send you a comm message when you get there.",
  stopConversation = "true",
  options = {}
}
han_solo_glowing_convo_template:addScreen(accept_quest)

accept_quest_active = ConvoScreen:new {
	id = "accept_quest_active",
	customDialogText = "Have you checked the Falcon yet?",
	stopConversation = "true",
	options = {}
}
han_solo_glowing_convo_template:addScreen(accept_quest_active);

quest_complete = ConvoScreen:new {
	id = "quest_complete",
	customDialogText = "Well Done, here's something for your trouble. See ya around kid!",
	stopConversation = "true",
	options = {}
}
han_solo_glowing_convo_template:addScreen(quest_complete);

quest_complete_return = ConvoScreen:new {
	id = "quest_complete_return",
	customDialogText = "Hey kid! Good to see you, keeping out of trouble I hope.",
	stopConversation = "true",
	options = {}
}
han_solo_glowing_convo_template:addScreen(quest_complete_return);

not_ready = ConvoScreen:new {
	id = "not_ready",
	customDialogText = "I wouldn't hang around here kid, there's some scruffy lookin' nerf herders about.",
	stopConversation = "true",
	options = {}
}
han_solo_glowing_convo_template:addScreen(not_ready);

addConversationTemplate("han_solo_glowing_convo_template", han_solo_glowing_convo_template);