han_solo_glowing_convo_template = ConvoTemplate:new {
  initialScreen = "first_screen",
  templateType = "Lua",
  luaClassHandler = "hanSoloConvoHandler",
  screens = {}
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  leftDialog = "@conversation/custom_string:han_solo_glowing_first_screen",
  stopConversation = "false",
  options = {
    { "@conversation/custom_string:han_solo_glowing_first_screen_response", "accept" },
  }
}
han_solo_glowing_convo_template:addScreen(first_screen)

imperial = ConvoScreen:new {
  id = "imperial",
  leftDialog = "@conversation/custom_string:han_solo_glowing_imperial",
  stopConversation = "false",
  options = {
    { "@conversation/custom_string:han_solo_glowing_imperial_response_one", "accept" },
    { "@conversation/custom_string:han_solo_glowing_imperial_response_two", "leave" }
  }
}
han_solo_glowing_convo_template:addScreen(imperial)

accept = ConvoScreen:new {
  id = "accept",
  leftDialog = "@conversation/custom_string:han_solo_glowing_accept",
  stopConversation = "false",
  options = {
    { "@conversation/custom_string:han_solo_glowing_accept_response", "accept_quest" },
  }
}
han_solo_glowing_convo_template:addScreen(accept)

leave = ConvoScreen:new {
  id = "leave",
  leftDialog = "@conversation/custom_string:han_solo_glowing_leave",
  stopConversation = "true",
  options = {}
}
han_solo_glowing_convo_template:addScreen(leave)

accept_quest = ConvoScreen:new {
  id = "accept_quest",
  leftDialog = "@conversation/custom_string:han_solo_glowing_accept_quest",
  stopConversation = "true",
  options = {}
}
han_solo_glowing_convo_template:addScreen(accept_quest)

accept_quest_active = ConvoScreen:new {
	id = "accept_quest_active",
  leftDialog = "@conversation/custom_string:han_solo_glowing_accept_quest_active",
	stopConversation = "true",
	options = {}
}
han_solo_glowing_convo_template:addScreen(accept_quest_active);

quest_complete = ConvoScreen:new {
	id = "quest_complete",
  leftDialog = "@conversation/custom_string:han_solo_glowing_quest_complete",
	stopConversation = "true",
	options = {}
}
han_solo_glowing_convo_template:addScreen(quest_complete);

quest_complete_return = ConvoScreen:new {
	id = "quest_complete_return",
  leftDialog = "@conversation/custom_string:han_solo_glowing_quest_complete_return",
	stopConversation = "true",
	options = {}
}
han_solo_glowing_convo_template:addScreen(quest_complete_return);

not_ready = ConvoScreen:new {
	id = "not_ready",
  leftDialog = "@conversation/custom_string:han_solo_glowing_not_ready",
  -- I wouldn't hang around here kid, there's some scruffy lookin' nerf herders about.
	stopConversation = "true",
	options = {}
}
han_solo_glowing_convo_template:addScreen(not_ready);

addConversationTemplate("han_solo_glowing_convo_template", han_solo_glowing_convo_template);