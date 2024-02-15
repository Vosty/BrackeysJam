extends Node

enum MATCH_SUITS { WORM, GREEBO , GUNWICH, FACIST, MOOSE, TOMBSTONE, FROG, CHATMERA, FUZZY, DOG, CAT, SUPERMAN, BATMAN, SPIDERMAN, BAGELS, BREAD, RICE, PIZZA, WATER, SODA, PISS, GRASS, FIRE, STEEL, GROUND, PSYCHIC, FAIRY, SLIME }

enum TRAP_SUITS { MINUS_KEY, CLOSE_DOOR, SWAP_DOOR }

func get_resource_mon(suit):
	match MATCH_SUITS.get(suit):
		MATCH_SUITS.SLIME:
			return load("res://Monsters/test_monster.tres")
		MATCH_SUITS.WORM:
			return load("res://Monsters/eye_worm.tres")
		MATCH_SUITS.GREEBO:
			return load("res://Monsters/greebo.tres")
		MATCH_SUITS.GUNWICH:
			return load("res://Monsters/ostrich.tres")
		MATCH_SUITS.FACIST:
			return load("res://Monsters/facist.tres")
		MATCH_SUITS.PIZZA:
			return load("res://Monsters/pizza_man.tres")
		MATCH_SUITS.MOOSE:
			return load("res://Monsters/moose.tres")
		MATCH_SUITS.TOMBSTONE:
			return load("res://Monsters/tombstone.tres")
		MATCH_SUITS.FROG:
			return load("res://Monsters/frog_freak.tres")
		MATCH_SUITS.CHATMERA:
			return load("res://Monsters/cat_chimera.tres")
		MATCH_SUITS.FUZZY:
			return load("res://Monsters/suit_sprite.tres")
		_:
			return load("res://Monsters/test_monster.tres")


func get_resource_trap(suit):
	match TRAP_SUITS.get(suit):
		TRAP_SUITS.MINUS_KEY:
			return load("res://Traps/key_eater.tres")
		TRAP_SUITS.CLOSE_DOOR:
			return load("res://Traps/door_closer.tres")
		TRAP_SUITS.SWAP_DOOR:
			return load("res://Traps/door_swapper.tres")
