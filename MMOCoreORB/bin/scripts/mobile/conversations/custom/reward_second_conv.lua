reward_second_convo_template = ConvoTemplate:new {
  initialScreen = "greeting",
  templateType = "Lua",
  luaClassHandler = "rewardSecondConvoHandler",
  screens = {}
}

greeting = ConvoScreen:new {
  id = "greeting",
  customDialogText = "Congratulations on your victory in the arena! As a champion, you have earned a reward. Please accept this token of your triumph.",
  stopConversation = "true",
  options = {}
}
reward_second_convo_template:addScreen(greeting)

nothing_to_discuss = ConvoScreen:new {
  id = "nothing_to_discuss",
  customDialogText = "I have nothing to discuss with you.",
  stopConversation = "true",
  options = {}
}
arena_inviter_convo_template:addScreen(nothing_to_discuss)

addConversationTemplate("reward_second_convo_template", reward_second_convo_template);