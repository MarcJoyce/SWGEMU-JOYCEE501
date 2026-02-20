arena_inviter_convo_template = ConvoTemplate:new {
  initialScreen = "hello",
  templateType = "Lua",
  luaClassHandler = "arenaInviterConvoHandler",
  screens = {}
}

invite = ConvoScreen:new {
  id = "invite",
  customDialogText = "Hello, brave soul! Vask the Pitmaster has summoned you to the arena of Lok to prove your mettle. Do you accept the challenge to fight for glory and honor?",
  stopConversation = "false",
  options = {
    { "I accept!", "accept" },
    { "No, I decline.", "decline" }
  }
}
arena_inviter_convo_template:addScreen(invite)

accept = ConvoScreen:new {
  id = "accept",
  customDialogText = "Excellent choice, champion! You have been granted entry to the arena. May the crowd's roar echo in your ears as you face your first opponent. I will add a waypoint to Vask the Pitmaster for your journey.",
  stopConversation = "true",
  options = {}
}
arena_inviter_convo_template:addScreen(accept)

decline = ConvoScreen:new {
  id = "decline",
  customDialogText = "A wise decision, perhaps. The arena is not for the faint of heart. I will add the waypoint to Vask the Pitmaster, should you find courage in the future.",
  stopConversation = "true",
  options = {}
}
arena_inviter_convo_template:addScreen(decline)

already_accepted = ConvoScreen:new {
  id = "already_accepted",
  customDialogText = "You have already accepted the challenge to fight in the arena. Prepare yourself and seek out Vask the Pitmaster when you are ready.",
  stopConversation = "true",
  options = {}
}
arena_inviter_convo_template:addScreen(already_accepted)

nothing_to_discuss = ConvoScreen:new {
  id = "nothing_to_discuss",
  customDialogText = "I have nothing to discuss with you.",
  stopConversation = "true",
  options = {}
}
arena_inviter_convo_template:addScreen(nothing_to_discuss)

addConversationTemplate("arena_inviter_convo_template", arena_inviter_convo_template);

