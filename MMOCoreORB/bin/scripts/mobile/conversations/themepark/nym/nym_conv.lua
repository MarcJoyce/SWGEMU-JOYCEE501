nymConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "theme_park_nym_conv_handler",
	screens = {}
}

----------
--Nym initial convo
----------
first_time_hello = ConvoScreen:new {
	id = "first_time_hello",
	leftDialog = "@celebrity/nym:first_time_hello", -- I don't know who you are or why you're here, and I don't really care. I assume you want some work, just like every other fringer who wanders into my stronghold. But just because you're tough enough to survive on my planet doesn't mean you're ready to join the Lok Revenants. I only take the meanest mercenaries into my crew. You gotta prove yourself before I'll even think about giving you any assignments. In the interest of keeping the peace, I'll let you stick around. But step out of line, and I'll send a blaster bolt through your brain.
	stopConversation = "false",
	options = {
		{"@celebrity/nym:quienne_esta", "yo_es_nym"}, -- Who are you?
	}
}
nymConvoTemplate:addScreen(first_time_hello);

yo_es_nym = ConvoScreen:new {
	id = "yo_es_nym",
	leftDialog = "@celebrity/nym:yo_es_nym", -- I'm Nym, captain of the Lok Revenants. We're the largest pirate crew on Lok, and I'll crush anyone who claims different.
	stopConversation = "false",
	options = {
		{"@celebrity/nym:who_is_kole", "kole_is"}, -- Who is Kole?
		{"@celebrity/nym:who_is_jinkins", "jinkins_is"}, -- Tell me about Jinkins.
	}
}
nymConvoTemplate:addScreen(yo_es_nym);

kole_is = ConvoScreen:new {
	id = "kole_is",
	leftDialog = "@celebrity/nym:kole_is", -- Kole's my Chadra-Fan first mate and co-pilot. Rescued me from more than one assassination attempt, so watch your back and keep your hands where Kole can see 'em. We've been working together since before the Battle of Naboo. There isn't anyone I trust more.
	stopConversation = "false",
	options = {
		{"@celebrity/nym:koles_story", "kole_quest_info"}, -- What kind of help does Kole need?
		{"@celebrity/nym:ill_see_kole", "something_funny_kole"}, -- Don't make him mad. He hasn't killed anyone in two weeks and I think he's gettin' bored.
	}
}
nymConvoTemplate:addScreen(kole_is);

jinkins_is = ConvoScreen:new {
	id = "jinkins_is",
	leftDialog = "@celebrity/nym:jinkins_is", -- Jinkins? He's the best engineer this side of Corellia. Anything I can blow up, he can put back together.
	stopConversation = "false",
	options = {
		{"@celebrity/nym:jinkins_story", "jinkins_quest_info"}, -- What can I do for Jinkins?
		{"@celebrity/nym:ill_see_jinkins", "something_funny_jinkins"}, -- Good. Just remember that we're watching you. Put a leg outta line, and I'll cut it off.
	}
}
nymConvoTemplate:addScreen(jinkins_is);

quest_info = ConvoScreen:new {
	id = "quest_info",
	leftDialog = "@celebrity/nym:quest_info", -- You're persistent, I'll give you that. I might have work for someone too stupid to know when to give up, and you look like you fit that description. There's an Imperial research facility on Lok that my spies think is filled with experimental weapons. I want whatever that base is building. You'll need help from Jinkins and Kole if you want to pull this off.
	stopConversation = "false",
	options = {
		{"@celebrity/nym:imggcu", "lab_info"}, -- What is it you need from the research lab?
		{"@celebrity/nym:imperial_bribe", "retired_officer"}, -- What can I do for you?
	}
}
nymConvoTemplate:addScreen(quest_info);

lab_info = ConvoScreen:new {
	id = "lab_info",
	leftDialog = "@celebrity/nym:lab_info", -- There are two things I want: First, I want all the research the scientists have done. Just grab a memory unit from one of the lab's computers. Second, I need some Imperial Military Grade Grenade Casing Units. The Imps call them IMGGCUs. There should be a stash of them somewhere in that base. Bring me the memory unit and the IMGGCUs, and I'll make sure you're well-paid.
	stopConversation = "false",
	options = {
		{"@celebrity/nym:ill_go_lab", "go_lab"}, -- I'm going into the lab, and nothing can stop me.
	}
}
nymConvoTemplate:addScreen(lab_info);

go_lab = ConvoScreen:new {
	id = "go_lab",
	leftDialog = "@celebrity/nym:go_lab", -- Get outta here, then. Bring me back what I asked for, and we'll do some business.
	stopConversation = "true",
	options = {
	}
}
nymConvoTemplate:addScreen(go_lab);

retired_officer = ConvoScreen:new {
	id = "retired_officer",
	leftDialog = "@celebrity/nym:retired_officer", -- You might be able to help both of us out by talking to a "friend" of mine, an informant who might have some information about the research facility and its defenses. If you can stand talkin' to an immoral slug, I'll give you directions to his favorite hangout.
	stopConversation = "false",
	options = {
		{"@celebrity/nym:ill_see_officer", "go_to_officer"}, -- I'll go talk to this guy.
	}
}
nymConvoTemplate:addScreen(retired_officer);

go_to_officer = ConvoScreen:new {
	id = "go_to_officer",
	leftDialog = "@celebrity/nym:go_to_officer", -- Tell him I sent you, and he should squawk.
	stopConversation = "true",
	options = {
	}
}
nymConvoTemplate:addScreen(go_to_officer);

kole_quest_info = ConvoScreen:new {
	id = "kole_quest_info",
	leftDialog = "@celebrity/nym:kole_quest_info", -- Kole's interested in an Imperial mining facility on Lok. He'll give you more information about it.
	stopConversation = "true",
	options = {
	}
}
nymConvoTemplate:addScreen(kole_quest_info);

jinkins_quest_info = ConvoScreen:new {
	id = "jinkins_quest_info",
	leftDialog = "@celebrity/nym:jinkins_quest_info", -- Jinkins has some information about a crashed starship carrying an Imperial droid. It could be useful to us. Ask him about it.
	stopConversation = "true",
	options = {
	}
}
nymConvoTemplate:addScreen(jinkins_quest_info);

help_others = ConvoScreen:new {
	id = "help_others",
	leftDialog = "@celebrity/nym:help_others", -- I'm not going to take a chance on you until you earn Jinkins' trust and Kole's respect. Better get to work.
	stopConversation = "true",
	options = {
	}
}
nymConvoTemplate:addScreen(help_others);

something_funny_kole = ConvoScreen:new {
	id = "something_funny_kole",
	leftDialog = "@celebrity/nym:something_funny_kole", -- Don't make him mad. He hasn't killed anyone in two weeks and I think he's gettin' bored.
	stopConversation = "true",
	options = {
	}
}
nymConvoTemplate:addScreen(something_funny_kole);

something_funny_jinkins = ConvoScreen:new {
	id = "something_funny_jinkins",
	leftDialog = "@celebrity/nym:something_funny_jinkins", -- Good. Just remember that we're watching you. Put a leg outta line, and I'll cut it off.
	stopConversation = "true",
	options = {
	}
}
nymConvoTemplate:addScreen(something_funny_jinkins);

hello_again = ConvoScreen:new {
	id = "hello_again",
	leftDialog = "@celebrity/nym:hello_again", -- Well, well, you're back. Need something else?
	stopConversation = "false",
	options = {
		{"@celebrity/nym:tell_me_again", "quest_info_again"}, -- Tell me again what you need from me...
	}
}
nymConvoTemplate:addScreen(hello_again);

quest_info_again = ConvoScreen:new {
	id = "quest_info_again",
	leftDialog = "@celebrity/nym:quest_info_again", -- Like I said, I'm looking for someone who can bust into an Imperial research facility.
	stopConversation = "false",
	options = {
		{"@celebrity/nym:imggcu", "lab_info"}, -- What is it you need from the research lab?
		{"@celebrity/nym:imperial_bribe", "retired_officer"}, -- What can I do for you?
	}
}
nymConvoTemplate:addScreen(quest_info_again);

wheres_drive = ConvoScreen:new {
	id = "wheres_drive",
	leftDialog = "@celebrity/nym:wheres_drive", -- Have you found that memory module yet? That should be your top priority now.
	stopConversation = "false",
	options = {
		{"@celebrity/nym:working_on_it", "get_to_it_chief"}, -- No, I'm still working on that.
	}
}
nymConvoTemplate:addScreen(wheres_drive);

wheres_imggcu = ConvoScreen:new {
	id = "wheres_imggcu",
	leftDialog = "@celebrity/nym:wheres_imggcu", -- Get your hands on those IMGGCUs. I need the grenade casings to start causing some serious trouble here on Lok.
	stopConversation = "false",
	options = {
		{"@celebrity/nym:working_on_it", "get_to_it_chief"}, -- No, I'm still working on that.
	}
}
nymConvoTemplate:addScreen(wheres_imggcu);

get_to_it_chief = ConvoScreen:new {
	id = "get_to_it_chief",
	leftDialog = "@celebrity/nym:get_to_it_chief", -- Well, get back to work!
	stopConversation = "true",
	options = {
	}
}
nymConvoTemplate:addScreen(get_to_it_chief);

your_the_best = ConvoScreen:new {
	id = "your_the_best",
	leftDialog = "@celebrity/nym:your_the_best", -- Great work. Kole and Jinkins can vouch for you, and now you've done your part for me. Feel free to visit the stronghold whenever you need supplies. Just don't bring along any trouble, and you'll always be welcome here.
	stopConversation = "true",
	options = {
	}
}
nymConvoTemplate:addScreen(your_the_best);

youre_done = ConvoScreen:new {
	id = "youre_done",
	leftDialog = "@celebrity/nym:youre_done", -- I appreciate the work you did for us. You're still in my good graces, so feel free to roam around on Lok.
	stopConversation = "false",
	options = {
		{ "Let me know if you need any more muscle.", "get_out_of_here" }
	}
}
nymConvoTemplate:addScreen(youre_done);

get_out_of_here = ConvoScreen:new {
	id = "get_out_of_here",
	customDialogText = "Why? Do you know someone that has any? Ha, Get out of here!",
	stopConversation = "true",
	options = {}
}
nymConvoTemplate:addScreen(get_out_of_here);

piece_of_eight_five_one = ConvoScreen:new {
	id = "piece_of_eight_five_one",
	customDialogText = "They're still out there? I told them all to leave. What's so important about this dammed shard",
	stopConversation = "false",
	options = {
		{ "Shard?", "piece_of_eight_five_two" }
	}
}
nymConvoTemplate:addScreen(piece_of_eight_five_one);

piece_of_eight_five_two = ConvoScreen:new {
	id = "piece_of_eight_five_two",
	customDialogText = "Yeah, one of the boys picked this up on Tatooine and ever since I've had it, I've had the Empire, the Rebels, Jabba and every other syndicate out there trying to get their hands on it. To be honest, I'm tired of the attention. Too many eyes and all that.",
	stopConversation = "false",
	options = {
		{ "I could take it off your hands, I'd be willing to pay, of course.", "piece_of_eight_five_three" }
	}
}
nymConvoTemplate:addScreen(piece_of_eight_five_two);

piece_of_eight_five_three = ConvoScreen:new {
	id = "piece_of_eight_five_three",
	customDialogText = "Ha, just what I wanted to hear. I'm not interested in your credits; I need something else from you. Ever heard of the Gorax?",
	stopConversation = "false",
	options = {
		{ "Can't say I have.", "piece_of_eight_five_four" },
		{ "I have.", "piece_of_eight_five_four" }
	}
}
nymConvoTemplate:addScreen(piece_of_eight_five_three);

piece_of_eight_five_four = ConvoScreen:new {
	id = "piece_of_eight_five_four",
	customDialogText = "Nasty piece of work they are. They're confined to Endor now, rumours say. Well, I want you to go kill one, and bring me back it's skull, I'll mount it out front to ward off anyone who thinks they can challenge us. Shouldn't be too hard for someone of your... skills.",
	stopConversation = "false",
	options = {
		{ "Ok, I'll be back soon Nym.", "piece_of_eight_five_accept" }
	}
}
nymConvoTemplate:addScreen(piece_of_eight_five_four);

piece_of_eight_five_accept = ConvoScreen:new {
	id = "piece_of_eight_five_accept",
	customDialogText = "That's the spirit. I'll be here.",
	stopConversation = "true",
	options = {}
}
nymConvoTemplate:addScreen(piece_of_eight_five_accept);

piece_of_eight_five_ongoing = ConvoScreen:new {
	id = "piece_of_eight_five_ongoing",
	customDialogText = "I know Lok's a beautiful place, but Endor is where the Gorax live.",
	stopConversation = "true",
	options = {}
}
nymConvoTemplate:addScreen(piece_of_eight_five_ongoing);

piece_of_eight_five_complete = ConvoScreen:new {
	id = "piece_of_eight_five_complete",
	customDialogText = "My god you've done it; and here's your reward. Be careful mate, if the Empire, the Rebels and Jabba are after it; you'll have a target on your back for sure.",
	stopConversation = "true",
	options = {}
}
nymConvoTemplate:addScreen(piece_of_eight_five_complete);

addConversationTemplate("nymConvoTemplate", nymConvoTemplate);