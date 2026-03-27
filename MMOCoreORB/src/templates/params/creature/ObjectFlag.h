/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef OBJECTFLAG_H_
#define OBJECTFLAG_H_

class ObjectFlag {
public:
	enum {
		NONE					= 0x00,
		ATTACKABLE				= 0x01,
		AGGRESSIVE				= 0x02,
		OVERT					= 0x04,
		TEF						= 0x08,
		PLAYER					= 0x10,
		ENEMY					= 0x20,
		WILLBEDECLARED			= 0x40,
		WASDECLARED				= 0x80,

		NPC					= 0x00000001,
		PACK					= 0x00000002,
		HERD					= 0x00000004,
		KILLER					= 0x00000008,
		STALKER					= 0x00000010,
		BABY					= 0x00000020,
		LAIR					= 0x00000040,
		HEALER					= 0x00000080,
		SCOUT					= 0x00000100,
		PET					= 0x00000200,
		DROID_PET				= 0x00000400,
		FACTION_PET				= 0x00000800,
		ESCORT					= 0x00001000,
		FOLLOW					= 0x00002000,
		STATIC					= 0x00004000,
		STATIONARY				= 0x00008000,
		NOAIAGGRO				= 0x00010000,
		SCANNING_FOR_CONTRABAND 		= 0x00020000,
		IGNORE_FACTION_STANDING 		= 0x00040000,
		SQUAD					= 0x00080000,
		EVENTCONTROL				= 0x00100000,
		NOINTIMIDATE				= 0x00200000,
		NODOT					= 0x00400000,
		TEST					= 0x00800000,
		NOKNOCKDOWN				= 0x01000000,
		NOSTATE			    		= 0x02000000,
		NODIZZY			    		= 0x04000000,
		NOBLIND			    		= 0x08000000,
		NOSTUN			    		= 0x10000000,
		LASTAIMASK				= 0x20000000, // keep this updated so we can loop through the masks

		CARNIVORE				= 0x01,
		HERBIVORE				= 0x02
	};
};

#endif /* OBJECTFLAG_H_ */
