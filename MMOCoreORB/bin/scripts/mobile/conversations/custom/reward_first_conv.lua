reward_first_convo_template = ConvoTemplate:new {
  initialScreen = "greeting",
  templateType = "Lua",
  luaClassHandler = "rewardFirstConvoHandler",
  screens = {}
}

greeting = ConvoScreen:new {
  id = "greeting",
  customDialogText = "Congratulations on your victory in the arena! As the champion, you have earned a reward. Please accept this token of your triumph.",
  stopConversation = "true",
  options = {}
}
reward_first_convo_template:addScreen(greeting)

nothing_to_discuss = ConvoScreen:new {
  id = "nothing_to_discuss",
  customDialogText = "I have nothing to discuss with you.",
  stopConversation = "true",
  options = {}
}
arena_inviter_convo_template:addScreen(nothing_to_discuss)

addConversationTemplate("reward_first_convo_template", reward_first_convo_template);