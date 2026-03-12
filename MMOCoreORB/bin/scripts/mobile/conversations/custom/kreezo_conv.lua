kreezo_convo_template = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "kreezoConvoHandler",
	screens = {}
}

greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "Utinni! Stan-man say you might come. Kreezo is master of scrap-craft. Bring parts and credits and Kreezo can attempt powerful modifications. What service you want?",
	stopConversation = "false",
	options = {
		{"Tell me about your crafting services.", "services"},
		{"Goodbye.", "goodbye"}
	}
}

services = ConvoScreen:new {
	id = "services",
	leftDialog = "Kreezo can extract modifications from armor and clothing. Different tools mean different chances of success. The better the chance, the more rare the tools and credits required. I can provide poor, average, good or great tools",
	stopConversation = "false",
	options = {
		{"Show me the poor success option.", "tier1_info"},
		{"Show me the average success option.", "tier2_info"},
		{"Show me the good success option.", "tier3_info"},
		{"Show me the great success option.", "tier4_info"},
		{"Maybe later.", "goodbye"}
	}
}

tier1_info = ConvoScreen:new {
	id = "tier1_info",
	leftDialog = "For a poor success chance Kreezo needs:\n\n150,000 credits\nArmor: Mag-Seal Breaker\nClothing: Fiber Matrix Separator\n\nBring these and Kreezo will attempt the work.",
	stopConversation = "false",
	options = {
		{"I have the items. Begin the crafting.", "tier1_confirm"},
		{"Show me the other options.", "services"},
		{"Nevermind.", "goodbye"}
	}
}

tier1_confirm = ConvoScreen:new {
	id = "tier1_confirm",
	leftDialog = "Once Kreezo begins the process the parts are consumed and success is not guaranteed. Do you want Kreezo to proceed?",
	stopConversation = "false",
	options = {
		{"Yes, begin crafting.", "tier1_start"},
		{"No, stop.", "services"}
	}
}

tier1_start = ConvoScreen:new {
	id = "tier1_start",
	leftDialog = "Very well. Kreezo begins the work...",
	stopConversation = "true",
	options = {}
}

tier2_info = ConvoScreen:new {
	id = "tier2_info",
	leftDialog = "For an average success chance Kreezo needs:\n\n400,000 credits\nArmor: Servo-Torque Extractor\nClothing: Nano-Stitch Dissolver",
	stopConversation = "false",
	options = {
		{"I have the items. Begin the crafting.", "tier2_confirm"},
		{"Show me the other options.", "services"},
		{"Nevermind.", "goodbye"}
	}
}

tier2_confirm = ConvoScreen:new {
	id = "tier2_confirm",
	leftDialog = "Kreezo warns again: parts will be consumed and outcome uncertain. Continue?",
	stopConversation = "false",
	options = {
		{"Yes, do it.", "tier2_start"},
		{"No, go back.", "services"}
	}
}

tier2_start = ConvoScreen:new {
	id = "tier2_start",
	leftDialog = "Kreezo begins careful work with delicate tools...",
	stopConversation = "true",
	options = {}
}

tier3_info = ConvoScreen:new {
	id = "tier3_info",
	leftDialog = "For a good success chance Kreezo needs:\n\n700,000 credits\nArmor: Kinetic Resonance Hammer\nClothing: Micro Loom Reverser",
	stopConversation = "false",
	options = {
		{"I have the items. Begin the crafting.", "tier3_confirm"},
		{"Show me the other options.", "services"},
		{"Nevermind.", "goodbye"}
	}
}

tier3_confirm = ConvoScreen:new {
	id = "tier3_confirm",
	leftDialog = "This is dangerous work. Once Kreezo begins there is no turning back. Proceed?",
	stopConversation = "false",
	options = {
		{"Yes, begin.", "tier3_start"},
		{"No, return.", "services"}
	}
}

tier3_start = ConvoScreen:new {
	id = "tier3_start",
	leftDialog = "Kreezo activates heavy machinery and begins...",
	stopConversation = "true",
	options = {}
}

tier4_info = ConvoScreen:new {
	id = "tier4_info",
	leftDialog = "For a great success chance Kreezo needs:\n\n1,050,000 credits\nArmor: Micro Fusion Arc Probe\nClothing: Spectral Fabric Analyzer",
	stopConversation = "false",
	options = {
		{"I have the items. Begin the crafting.", "tier4_confirm"},
		{"Show me the other options.", "services"},
		{"Nevermind.", "goodbye"}
	}
}

tier4_confirm = ConvoScreen:new {
	id = "tier4_confirm",
	leftDialog = "This is Kreezo's finest work. But still not guaranteed. Proceed?",
	stopConversation = "false",
	options = {
		{"Yes. Begin the work.", "tier4_start"},
		{"No. Maybe later.", "services"}
	}
}

tier4_start = ConvoScreen:new {
	id = "tier4_start",
	leftDialog = "Kreezo carefully prepares the most advanced tools...",
	stopConversation = "true",
	options = {}
}

goodbye = ConvoScreen:new {
	id = "goodbye",
	leftDialog = "Utinni! Come back if you find more scrap.",
	stopConversation = "true",
	options = {}
}

kreezo_convo_template:addScreen(greeting)
kreezo_convo_template:addScreen(services)

kreezo_convo_template:addScreen(tier1_info)
kreezo_convo_template:addScreen(tier1_confirm)
kreezo_convo_template:addScreen(tier1_start)

kreezo_convo_template:addScreen(tier2_info)
kreezo_convo_template:addScreen(tier2_confirm)
kreezo_convo_template:addScreen(tier2_start)

kreezo_convo_template:addScreen(tier3_info)
kreezo_convo_template:addScreen(tier3_confirm)
kreezo_convo_template:addScreen(tier3_start)

kreezo_convo_template:addScreen(tier4_info)
kreezo_convo_template:addScreen(tier4_confirm)
kreezo_convo_template:addScreen(tier4_start)

kreezo_convo_template:addScreen(goodbye)

addConversationTemplate("kreezo_convo_template", kreezo_convo_template)