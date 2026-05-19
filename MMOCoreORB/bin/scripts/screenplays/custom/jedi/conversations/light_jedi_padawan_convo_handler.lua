lightJediConvoHandler = conv_handler:new {}

function lightJediConvoHandler:getInitialScreen(pPlayer, nNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

 return convoTemplate:getScreen("hello")
end

function lightJediConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
  local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

  local responses = {
    "Good day, Master.",
    "Hello, Master.",
    "Master...",
    "I am here, Master.",
    "At your service.",
    "Peace be with you.",
    "I sense your presence.",
    "The Force is calm.",
    "Ready when you are.",
    "I will follow your lead.",
    "Your guidance is welcome.",
    "I stand ready.",
    "All is as it should be.",
    "The Force guides us.",
    "I await your command."
  }

  if (screenID == "hello") then
    local response = responses[getRandomNumber(1, #responses)]
    clonedConversation:setCustomDialogText(response)
  end

  return pConvScreen
end
