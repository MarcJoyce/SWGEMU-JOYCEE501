klik_klak_convo_template = ConvoTemplate:new {
  initialScreen = "first_screen",
  templateType = "Lua",
  luaClassHandler = "klikKlakConvoHandler",
  screens = {}
};

first_screen = ConvoScreen:new {
  id = "first_screen",
  customDialogText = "Ootini! Stranger come… looking shiny? Hmm? Maybe Klik-Klak has shiny thing stranger wants?",
  stopConversation = "false",
  options = {
    { "I'm looking for something shiny, something rare, do you have something like that?", "klik_klak_offer" },
    { "Cut the games Jawa. You know what I'm looking for!", "klik_klak_offer" }
  }
}
klik_klak_convo_template:addScreen(first_screen)

klik_klak_offer = ConvoScreen:new {
  id = "klik_klak_offer",
  customDialogText = "Hehehe… yes, yes! Klik-Klak has shiny! How stranger pay, hmm?",
  stopConversation = "false",
  options = {
    { "Republic credits will do fine", "klik_klak_offer_two" },
    { "What did you have in mind?", "klik_klak_offer_two" }
  }
}
klik_klak_convo_template:addScreen(klik_klak_offer)

klik_klak_offer_two = ConvoScreen:new {
  id = "klik_klak_offer_two",
  customDialogText = "Credits! Yes, yes! Klik-Klak loves credits! For stranger, 10 million credits… Or stranger can bring Tusken Queen head! Ootini!",
  stopConversation = "false",
  options = {
    { "10 million credits is too much, I will kill the Tusken.", "accept_kill" }
  }
}
klik_klak_convo_template:addScreen(klik_klak_offer_two)

accept_kill = ConvoScreen:new {
  id = "accept_kill",
  customDialogText = "Good, good! Stranger must hurry! Queen live in Fort Tusken… go, go! Klik-Klak wait… maybe.",
  stopConversation = "true",
  options = {}
}
klik_klak_convo_template:addScreen(accept_kill)

success_paid = ConvoScreen:new {
  id = "success_paid",
  customDialogText = "Ootini!! Klik-Klak thanks stranger! Shiny is yours… Klik-Klak forgets stranger come. Leave now, yes yes!",
  stopConversation = "true",
  options = {}
}
klik_klak_convo_template:addScreen(success_paid)

failed_payment = ConvoScreen:new {
  id = "failed_payment",
  customDialogText = "Oh no… stranger poor! Come back when have credits, or with Tusken Queen head! Ootini!",
  stopConversation = "false",
  options = {
    { "I'll be back with the credits Klik Klak, dont go anywhere", "goodbye" },
    { "Fine, I'll deal with this queen", "accept_kill" }
  }
}
klik_klak_convo_template:addScreen(failed_payment)

go_away = ConvoScreen:new {
  id = "go_away",
  customDialogText = "Ootini! Stranger lost… Stranger shouldn't be here. Leave Klik-Klak alone, yes yes.",
  stopConversation = "true",
  options = {}
}
klik_klak_convo_template:addScreen(go_away)

goodbye = ConvoScreen:new {
  id = "goodbye",
  customDialogText = "Klik-Klak forgets stranger come. Leave now… leave now!",
  stopConversation = "true",
  options = {}
}
klik_klak_convo_template:addScreen(goodbye)

no_head = ConvoScreen:new {
  id = "no_head",
  customDialogText = "No head, no shiny! Stranger must kill Queen or pay credits! Ootini!",
  stopConversation = "true",
  options = {
    { "I'll pay.", "klik_klak_offer_two" },
    { "No, the queen will die.", "accept_kill" },
  }
}
klik_klak_convo_template:addScreen(no_head)

success_kill = ConvoScreen:new {
  id = "success_kill",
  customDialogText = "Klik-Klak pleased! Shiny is yours, stranger! Ootini!",
  stopConversation = "true",
  options = {}
}
klik_klak_convo_template:addScreen(success_kill)

addConversationTemplate("klik_klak_convo_template", klik_klak_convo_template);