han_solo_glowing_convo_template = ConvoTemplate:new {
  initialScreen = "first_screen",
  templateType = "Lua",
  luaClassHandler = "hanSoloConvoHandler",
  screens = {}
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "Alright kid, listen up. I don't do favors for strangers, but I'm stuck waiting here and need someone to check on the ship me and Chewie 'borrowed.' Think you've got the guts for it?",
  stopConversation = "false",
  options = {
    { "Sure thing, I can handle that!", "accept" },
  }
}
han_solo_glowing_convo_template:addScreen(first_screen)

imperial = ConvoScreen:new {
  id = "imperial",
  customDialogText = "You really think an Imperial's gonna stroll into a Rebel hideout and haul me off? Heh… not today. Now, are you helping me or wasting your time? There's a nice reward in it if you do.",
  stopConversation = "false",
  options = {
    { "Fine, where's your ship?", "accept" },
    { "No, I don't deal with Rebels.", "leave" }
  }
}
han_solo_glowing_convo_template:addScreen(imperial)

accept = ConvoScreen:new {
  id = "accept",
  customDialogText = "I parked her just outside of town. Watch for Tuskens—those sand rats are relentless—and keep an eye on Jawas; they've got sticky fingers. Don't let them strip the Falcon for parts.",
  stopConversation = "false",
  options = {
    { "I'm on my way!", "accept_quest" },
  }
}
han_solo_glowing_convo_template:addScreen(accept)

leave = ConvoScreen:new {
  id = "leave",
  customDialogText = "Shame, kid. Best you get moving before Chewie comes back and mistakes you for a snack.",
  stopConversation = "true",
  options = {}
}
han_solo_glowing_convo_template:addScreen(leave)

accept_quest = ConvoScreen:new {
  id = "accept_quest",
  customDialogText = "Good kid! I'll ping you a comm when you get there. Don't get caught napping by anyone with a blaster, alright?",
  stopConversation = "true",
  options = {}
}
han_solo_glowing_convo_template:addScreen(accept_quest)

accept_quest_active = ConvoScreen:new {
	id = "accept_quest_active",
  customDialogText = "Hey! Have you checked on the Falcon yet, or just sightseeing in the desert?",
	stopConversation = "true",
	options = {}
}
han_solo_glowing_convo_template:addScreen(accept_quest_active);

quest_complete = ConvoScreen:new {
	id = "quest_complete",
  customDialogText = "Nice work! Here's something for your trouble. Keep your eyes open and maybe we'll cross paths again. Don't do anything I wouldn't do… which isn't much, but still.",
	stopConversation = "true",
	options = {}
}
han_solo_glowing_convo_template:addScreen(quest_complete);

quest_complete_return = ConvoScreen:new {
	id = "quest_complete_return",
  customDialogText = "Well, look who it is! Good to see you, kid. You keeping out of trouble, or just hiding from it better than I do?",
	stopConversation = "true",
	options = {}
}
han_solo_glowing_convo_template:addScreen(quest_complete_return);

not_ready = ConvoScreen:new {
	id = "not_ready",
  customDialogText = "I wouldn't stick around here if I were you. A few scruffy-lookin' nerf herders are wandering about, and trust me—they don't share blasters politely.",
	stopConversation = "true",
	options = {}
}
han_solo_glowing_convo_template:addScreen(not_ready);

addConversationTemplate("han_solo_glowing_convo_template", han_solo_glowing_convo_template);