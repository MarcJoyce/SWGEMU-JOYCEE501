kreezo_convo_template = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "kreezoConvoHandler",
	screens = {}
}

greeting = ConvoScreen:new {
	id = "greeting",
	customDialogText = "Utinni! Stan-man say you might come. Kreezo is master of scrap-craft. Bring parts and credits and Kreezo can help with your enhancement modifications. What service you want?",
	stopConversation = "false",
	options = {
		{"Tell me about your crafting services.", "services"},
		{"Goodbye.", "goodbye"}
	}
}
kreezo_convo_template:addScreen(greeting)

services = ConvoScreen:new {
	id = "services",
	customDialogText = "Kreezo can extract modifications from armor and clothing. Different tools mean different chances of success. The better the chance, the more rare the tools and credits required. I can provide weak, moderate, good or great tools",
	stopConversation = "false",
	options = {
		{"Show me the weak success option.", "tier1_info"},
		{"Show me the moderate success option.", "tier2_info"},
		{"Show me the strong success option.", "tier3_info"},
		{"Show me the powerful success option.", "tier4_info"},
		{"Maybe later.", "goodbye"}
	}
}
kreezo_convo_template:addScreen(services)

tier1_info = ConvoScreen:new {
	id = "tier1_info",
	customDialogText = "Is it Armor or Clothing you want to extract from?",
	stopConversation = "false",
	options = {
		{"Armor", "tier1_armor"},
		{"Clothing", "tier1_clothing"},
		{"Show me the other options.", "services"},
		{"Nevermind.", "goodbye"}
	}
}
kreezo_convo_template:addScreen(tier1_info)

tier1_armor = ConvoScreen:new {
	id = "tier1_armor",
	customDialogText = "For a weak success chance Kreezo needs:\n\n150,000 credits\nArmor: Mag-Seal Breaker\nDisk: a Blank Armor Enhancement Disk\n\nBring these and Kreezo will attempt the work.",
	stopConversation = "false",
	options = {}
}
kreezo_convo_template:addScreen(tier1_armor)

tier1_clothing = ConvoScreen:new {
	id = "tier1_clothing",
	customDialogText = "For a weak success chance Kreezo needs:\n\n150,000 credits\nClothing: Fiber Matrix Separator\nDisk: a Blank Clothing Enhancement Disk\n\nBring these and Kreezo will attempt the work.",
	stopConversation = "false",
	options = {}
}
kreezo_convo_template:addScreen(tier1_clothing)

tier1_armor_confirm = ConvoScreen:new {
	id = "tier1_armor_confirm",
	customDialogText = "Once Kreezo begins the process the parts are consumed and success is not guaranteed. Do you want Kreezo to proceed?",
	stopConversation = "false",
	options = {
		{"Yes, begin crafting.", "tier1_armor_start"},
		{"No, stop.", "services"}
	}
}
kreezo_convo_template:addScreen(tier1_armor_confirm)

tier1_clothing_confirm = ConvoScreen:new {
	id = "tier1_clothing_confirm",
	customDialogText = "Once Kreezo begins the process the parts are consumed and success is not guaranteed. Do you want Kreezo to proceed?",
	stopConversation = "false",
	options = {
		{"Yes, begin crafting.", "tier1_clothing_start"},
		{"No, stop.", "services"}
	}
}
kreezo_convo_template:addScreen(tier1_clothing_confirm)

tier1_armor_start = ConvoScreen:new {
	id = "tier1_armor_start",
	customDialogText = "Very well. Kreezo can retrofit this old hyperdrive part and...",
	stopConversation = "true",
	options = {}
}
kreezo_convo_template:addScreen(tier1_armor_start)

tier1_clothing_start = ConvoScreen:new {
	id = "tier1_clothing_start",
	customDialogText = "Very well. Kreezo can retrofit this old hyperdrive part and...",
	stopConversation = "true",
	options = {}
}
kreezo_convo_template:addScreen(tier1_clothing_start)

tier2_info = ConvoScreen:new {
	id = "tier2_info",
	customDialogText = "Is it Armor or Clothing you want to extract from?",
	stopConversation = "false",
	options = {
		{"Armor", "tier2_armor"},
		{"Clothing", "tier2_clothing"},
		{"Show me the other options.", "services"},
		{"Nevermind.", "goodbye"}
	}
}
kreezo_convo_template:addScreen(tier2_info)

tier2_armor = ConvoScreen:new {
	id = "tier2_armor",
	customDialogText = "For a moderate success chance Kreezo needs:\n\n400,000 credits\nArmor: Servo-Torque Extractor\nDisk: a Blank Armor Enhancement Disk\n\nBring these and Kreezo will attempt the work.",
	stopConversation = "false",
	options = {}
}
kreezo_convo_template:addScreen(tier2_armor)

tier2_clothing = ConvoScreen:new {
	id = "tier2_clothing",
	customDialogText = "For a moderate success chance Kreezo needs:\n\n400,000 credits\nClothing: Nano-Stitch Dissolver\nDisk: a Blank Clothing Enhancement Disk\n\nBring these and Kreezo will attempt the work.",
	stopConversation = "false",
	options = {}
}
kreezo_convo_template:addScreen(tier2_clothing)

tier2_armor_confirm = ConvoScreen:new {
	id = "tier2_armor_confirm",
	customDialogText = "Once Kreezo begins the process the parts are consumed and success is not guaranteed. Do you want Kreezo to proceed?",
	stopConversation = "false",
	options = {
		{"Yes, begin crafting.", "tier2_armor_start"},
		{"No, stop.", "services"}
	}
}
kreezo_convo_template:addScreen(tier2_armor_confirm)

tier2_clothing_confirm = ConvoScreen:new {
	id = "tier2_clothing_confirm",
	customDialogText = "Once Kreezo begins the process the parts are consumed and success is not guaranteed. Do you want Kreezo to proceed?",
	stopConversation = "false",
	options = {
		{"Yes, begin crafting.", "tier2_clothing_start"},
		{"No, stop.", "services"}
	}
}
kreezo_convo_template:addScreen(tier2_clothing_confirm)

tier2_armor_start = ConvoScreen:new {
	id = "tier2_armor_start",
	customDialogText = "Very well. Kreezo can retrofit this old hyperdrive part and...",
	stopConversation = "true",
	options = {}
}
kreezo_convo_template:addScreen(tier2_armor_start)

tier2_clothing_start = ConvoScreen:new {
	id = "tier2_clothing_start",
	customDialogText = "Very well. Kreezo can retrofit this old hyperdrive part and...",
	stopConversation = "true",
	options = {}
}
kreezo_convo_template:addScreen(tier2_clothing_start)

tier3_info = ConvoScreen:new {
	id = "tier3_info",
	customDialogText = "Is it Armor or Clothing you want to extract from?",
	stopConversation = "false",
	options = {
		{"Armor", "tier3_armor"},
		{"Clothing", "tier3_clothing"},
		{"Show me the other options.", "services"},
		{"Nevermind.", "goodbye"}
	}
}
kreezo_convo_template:addScreen(tier3_info)

tier3_armor = ConvoScreen:new {
	id = "tier3_armor",
	customDialogText = "For a strong success chance Kreezo needs:\n\n700,000 credits\nArmor: Kinetic Resonance Hammer\nDisk: a Blank Armor Enhancement Disk\n\nBring these and Kreezo will attempt the work.",
	stopConversation = "false",
	options = {}
}
kreezo_convo_template:addScreen(tier3_armor)

tier3_clothing = ConvoScreen:new {
	id = "tier3_clothing",
	customDialogText = "For a strong success chance Kreezo needs:\n\n700,000 credits\nClothing: Micro Loom Reverser\nDisk: a Blank Clothing Enhancement Disk\n\nBring these and Kreezo will attempt the work.",
	stopConversation = "false",
	options = {}
}
kreezo_convo_template:addScreen(tier3_clothing)

tier3_armor_confirm = ConvoScreen:new {
	id = "tier3_armor_confirm",
	customDialogText = "Once Kreezo begins the process the parts are consumed and success is not guaranteed. Do you want Kreezo to proceed?",
	stopConversation = "false",
	options = {
		{"Yes, begin crafting.", "tier3_armor_start"},
		{"No, stop.", "services"}
	}
}
kreezo_convo_template:addScreen(tier3_armor_confirm)

tier3_clothing_confirm = ConvoScreen:new {
	id = "tier3_clothing_confirm",
	customDialogText = "Once Kreezo begins the process the parts are consumed and success is not guaranteed. Do you want Kreezo to proceed?",
	stopConversation = "false",
	options = {
		{"Yes, begin crafting.", "tier3_clothing_start"},
		{"No, stop.", "services"}
	}
}
kreezo_convo_template:addScreen(tier3_clothing_confirm)

tier3_armor_start = ConvoScreen:new {
	id = "tier3_armor_start",
	customDialogText = "Very well. Kreezo can retrofit this old hyperdrive part and...",
	stopConversation = "true",
	options = {}
}
kreezo_convo_template:addScreen(tier3_armor_start)

tier3_clothing_start = ConvoScreen:new {
	id = "tier3_clothing_start",
	customDialogText = "Very well. Kreezo can retrofit this old hyperdrive part and...",
	stopConversation = "true",
	options = {}
}
kreezo_convo_template:addScreen(tier3_clothing_start)

tier4_info = ConvoScreen:new {
	id = "tier4_info",
	customDialogText = "Is it Armor or Clothing you want to extract from?",
	stopConversation = "false",
	options = {
		{"Armor", "tier4_armor"},
		{"Clothing", "tier4_clothing"},
		{"Show me the other options.", "services"},
		{"Nevermind.", "goodbye"}
	}
}
kreezo_convo_template:addScreen(tier4_info)

tier4_armor = ConvoScreen:new {
	id = "tier4_armor",
	customDialogText = "For a powerful success chance Kreezo needs:\n\n1,050,000 credits\nArmor: Micro Fusion Arc Probe\nDisk: a Blank Armor Enhancement Disk\n\nBring these and Kreezo will attempt the work.",
	stopConversation = "false",
	options = {}
}
kreezo_convo_template:addScreen(tier4_armor)

tier4_clothing = ConvoScreen:new {
	id = "tier4_clothing",
	customDialogText = "For a powerful success chance Kreezo needs:\n\n1,050,000 credits\nClothing: Spectral Fabric Analyzer\nDisk: a Blank Clothing Enhancement Disk\n\nBring these and Kreezo will attempt the work.",
	stopConversation = "false",
	options = {}
}
kreezo_convo_template:addScreen(tier4_clothing)

tier4_armor_confirm = ConvoScreen:new {
	id = "tier4_armor_confirm",
	customDialogText = "Once Kreezo begins the process the parts are consumed and success is not guaranteed. Do you want Kreezo to proceed?",
	stopConversation = "false",
	options = {
		{"Yes, begin crafting.", "tier4_armor_start"},
		{"No, stop.", "services"}
	}
}
kreezo_convo_template:addScreen(tier4_armor_confirm)

tier4_clothing_confirm = ConvoScreen:new {
	id = "tier4_clothing_confirm",
	customDialogText = "Once Kreezo begins the process the parts are consumed and success is not guaranteed. Do you want Kreezo to proceed?",
	stopConversation = "false",
	options = {
		{"Yes, begin crafting.", "tier4_clothing_start"},
		{"No, stop.", "services"}
	}
}
kreezo_convo_template:addScreen(tier4_clothing_confirm)

tier4_armor_start = ConvoScreen:new {
	id = "tier4_armor_start",
	customDialogText = "Very well. Kreezo can retrofit this old hyperdrive part and...",
	stopConversation = "true",
	options = {}
}
kreezo_convo_template:addScreen(tier4_armor_start)

tier4_clothing_start = ConvoScreen:new {
	id = "tier4_clothing_start",
	customDialogText = "Very well. Kreezo can retrofit this old hyperdrive part and...",
	stopConversation = "true",
	options = {}
}
kreezo_convo_template:addScreen(tier4_clothing_start)

does_not_have_items = ConvoScreen:new {
	id = "does_not_have_items",
	customDialogText = "Kreezo is sad you don't have the items. Utinni! Come back when you have the parts and credits.",
	stopConversation = "false",
	options = {
		{"Show me the other options.", "services"},
		{"Where can I find these items", "items"},
		{"I'll be back.", "goodbye"}
	}
}
kreezo_convo_template:addScreen(does_not_have_items)

items = ConvoScreen:new {
	id = "items",
	customDialogText = "Utinni! Filty Tuskens, Dangerous Death Watch, Scary Nightsisters and Bug-eyed Geonosians.",
	stopConversation = "false",
	options = {
		{"Show me the other options.", "services"},
		{"Ok, Thanks.", "goodbye"}
	}
}
kreezo_convo_template:addScreen(items)

goodbye = ConvoScreen:new {
	id = "goodbye",
	customDialogText = "Utinni! Come back if you find more scrap.",
	stopConversation = "true",
	options = {}
}

kreezo_convo_template:addScreen(goodbye)

addConversationTemplate("kreezo_convo_template", kreezo_convo_template)