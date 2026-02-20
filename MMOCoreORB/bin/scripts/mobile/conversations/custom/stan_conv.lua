stan_convo_template = ConvoTemplate:new {
  initialScreen = "hello",
  templateType = "Lua",
  luaClassHandler = "stanConvoHandler",
  screens = {}
}

hello = ConvoScreen:new {
  id = "hello",
  customDialogText = "Hello there, traveler! Welcome to our humble town. I see you have a few credits in your pocket, why don't you browse my wares?",
  stopConversation = "false",
  options = {
    { "Who are you?", "who_are_you" },
    { "What do you sell?", "what_do_you_sell" }
  }
}
stan_convo_template:addScreen(hello)

who_are_you = ConvoScreen:new {
  id = "who_are_you",
  customDialogText = "I'm Stan, the best merchant in this part of the galaxy! Well, the whole galaxy, actually! I've been trading goods for as long as I've been able to walk and have the widest variety of items for sale than anyone you'll ever meet.",
  stopConversation = "false",
  options = {
    { "What do you sell?", "what_do_you_sell" },
    { "Is there anything else you can do?", "what_else" }
  }
}
stan_convo_template:addScreen(who_are_you)

what_else = ConvoScreen:new {
  id = "what_else",
  customDialogText = "I'm quite the cunning linguist, here let me teach you some. I have... other skills... but I don't think you, or this side of the galaxy for that matter, are ready for that yet.",
  stopConversation = "false",
  options = {
    { "And what sort of things do you sell?", "what_do_you_sell" },
  }
}
stan_convo_template:addScreen(what_else)

what_do_you_sell = ConvoScreen:new {
  id = "what_do_you_sell",
  customDialogText = "I sell all sorts of things! From basic supplies like food and drink to advanced tech gadgets and rare artifacts. If you need it, I've probably listed it on the bazaar. Take a look around and see if anything catches your eye!",
  stopConversation = "false",
  options = {
    { "Thanks, I'll take a look.", "goodbye" },
  }
}
stan_convo_template:addScreen(what_do_you_sell)

glowy_trial_1_rumour = ConvoScreen:new {
  id = "glowy_trial_1_rumour",
  customDialogText = "You look like someone who could handle a bit of adventure. I'll tell you this for free. I've heard rumors about a glowing artifact, that was broken and must be reassembled. The rumors suggest that the great Hutt, hiding in his palace, has acquired one. As has the mighty Nym in his Stronghold on Lok. Then there's the notorious cultist leader on Dantooine that everyone is talking about. Believe me, he's not the messiah, he's a very naughty boy!! If you can retrieve these pieces, you might be able to reassemble the artifact and unlock its secrets.",
  stopConversation = "false",
  options = {}
}
stan_convo_template:addScreen(glowy_trial_1_rumour)

glowy_trial_1_rumour_two = ConvoScreen:new {
  id = "glowy_trial_1_rumour_two",
  customDialogText = "Keep your credits, friend. I'll tell you what I know. There's an old Jedi sympathiser somewhere on Naboo, they move around so I can't be sure where, exactly, but I'm sure they'll have more information about what you seek.",
  stopConversation = "false",
  options = {
    { "Thanks for the tip!", "goodbye" }
  }
}
stan_convo_template:addScreen(glowy_trial_1_rumour_two)

goodbye = ConvoScreen:new {
  id = "goodbye",
  customDialogText = "Safe travels, friend! If you need anything else, you know where to find me.",
  stopConversation = "true",
  options = {}
}
stan_convo_template:addScreen(goodbye)

addConversationTemplate("stan_convo_template", stan_convo_template);

