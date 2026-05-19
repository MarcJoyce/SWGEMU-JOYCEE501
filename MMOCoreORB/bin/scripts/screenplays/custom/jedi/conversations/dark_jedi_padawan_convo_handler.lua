darkJediConvoHandler = conv_handler:new {}

function darkJediConvoHandler:getInitialScreen(pPlayer, nNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  logToFile("Player " .. SceneObject(pPlayer):getObjectID() .. " initiated conversation with NPC " .. SceneObject(nNpc):getObjectID(), "log/jedi_converastion.log")

 return convoTemplate:getScreen("hello")
end

function darkJediConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
  local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

  local responses = {
    "Yes... Master.",
    "You called?",
    "I am here.",
    "Speak your will.",
    "What is your command?",
    "I feel your power.",
    "The darkness stirs.",
    "I am ready.",
    "Your will is mine.",
    "Say the word.",
    "I await orders.",
    "The Force bends.",
    "I sense weakness.",
    "It will be done.",
    "As you command..."
  }

  if (screenID == "hello") then
    local response = responses[getRandomNumber(1, #responses)]
    logToFile("Player " .. playerID .. " greeted NPC " .. npcID .. " with response: " .. response, "log/jedi_converastion.log")
    clonedConversation:setCustomDialogText(response)
  end

  return pConvScreen
end
