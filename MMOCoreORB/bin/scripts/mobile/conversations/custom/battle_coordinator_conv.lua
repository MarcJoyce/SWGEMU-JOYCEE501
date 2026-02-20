battle_coordinator_convo_template = ConvoTemplate:new {
  initialScreen = "hello",
  templateType = "Lua",
  luaClassHandler = "battleCoordinatorConvoHandler",
  screens = {}
}

hello = ConvoScreen:new {
  id = "hello",
  customDialogText = "Step forth trembling morsel, and know this place as your final confession. Blood will purchase your moment of glory. Fight well, die loudly and perhaps your name will linger, longer than your corpse!?",
  stopConversation = "false",
  options = {
    { "What is this place?", "games" },
    { "Who are you?", "who_are_you" }
  }
}
battle_coordinator_convo_template:addScreen(hello)

hello = ConvoScreen:new {
  id = "hello",
  customDialogText = "Step forth trembling morsel, and know this place as your final confession. Blood will purchase your moment of glory. Fight well, die loudly and perhaps your name will linger, longer than your corpse!?",
  stopConversation = "false",
  options = {
    { "What is this place?", "games" },
    { "Who are you?", "who_are_you" }
  }
}
battle_coordinator_convo_template:addScreen(hello)

who_are_you = ConvoScreen:new {
  id = "who_are_you",
  customDialogText = "I am Vrax, but you can call me 'Pitmaster'. I am the keeper of the games and the one who will depose of your worthless corpse when you fall, and you will fall, as they all do.",
  stopConversation = "false",
  options = {
    { "Games?", "games" },
  }
}
battle_coordinator_convo_template:addScreen(who_are_you)

games = ConvoScreen:new {
  id = "games",
  customDialogText = "The great games of Lok, where all kinds of scum and villians come to seek glory to the sound of the roaring crowd. Test your strength against my titans, and survive as long as you can. Glory awaits those brave enough to embrace their fate. Win the crowd and you shall be rewarded.",
  stopConversation = "false",
  options = {

  }
}
battle_coordinator_convo_template:addScreen(games)

begin = ConvoScreen:new {
  id = "begin",
  customDialogText = "Rend flesh and shatter bones... for the crowd grow weary in anticipation!",
  stopConversation = "true",
  options = {}
}
battle_coordinator_convo_template:addScreen(begin)

ranking = ConvoScreen:new {
  id = "ranking",
  customDialogText = "",
  stopConversation = "false",
  options = {}
}
battle_coordinator_convo_template:addScreen(ranking)

busy = ConvoScreen:new {
  id = "busy",
  customDialogText = "Another champion is currently fighting in the arena. Watch on, you might learn a thing or two. Come talk to me again after I scrape their face from the floor.",
  stopConversation = "true",
  options = {}
}
battle_coordinator_convo_template:addScreen(busy)

cooldown = ConvoScreen:new {
  id = "cooldown",
  customDialogText = "",
  stopConversation = "true",
  options = {}
}
battle_coordinator_convo_template:addScreen(cooldown)

goodbye = ConvoScreen:new {
  id = "goodbye",
  customDialogText = "The arena is not for the weak, and cowardly. Leave now, and only return when you have found your courage.",
  stopConversation = "true",
  options = {}
}
battle_coordinator_convo_template:addScreen(goodbye)

not_eligible = ConvoScreen:new {
  id = "not_eligible",
  customDialogText = "You shouldn't be out here. Leave, before someone mistakes you for a fighter and throws you to the wolves.",
  stopConversation = "true",
  options = {}
}
battle_coordinator_convo_template:addScreen(not_eligible)

addConversationTemplate("battle_coordinator_convo_template", battle_coordinator_convo_template);

