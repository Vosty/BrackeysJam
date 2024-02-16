extends Node

enum MATCH_SUITS { WORM, GREEBO , GUNWICH, FACIST, MOOSE, TOMBSTONE, FROG, CHATMERA, FUZZY, BORKS, SKROB, SKELPY, GLOPER, BARREL, TRUNKR, MORRIMANCER, PIZZA, SPIDER, FLIP, STRANGER, RELC, SNAKESHIFTER, SQUIDRAGON }

enum TRAP_SUITS { MINUS_KEY, CLOSE_DOOR, SWAP_DOOR }

func get_resource_mon(suit):
	match MATCH_SUITS.get(suit):
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
		MATCH_SUITS.BORKS:
			return load("res://Monsters/borks.tres")
		MATCH_SUITS.SKROB:
			return load("res://Monsters/skrob.tres")
		MATCH_SUITS.SKELPY:
			return load("res://Monsters/minotaur.tres")
		MATCH_SUITS.BARREL:
			return load("res://Monsters/Barrel.tres")
		MATCH_SUITS.GLOPER:
			return load("res://Monsters/Gloper.tres")
		MATCH_SUITS.MORRIMANCER:
			return load("res://Monsters/Morrimancer.tres")
		MATCH_SUITS.SNAKESHIFTER:
			return load("res://Monsters/Snakeshifter.tres")
		MATCH_SUITS.SPIDER:
			return load("res://Monsters/Spider_princess.tres")
		MATCH_SUITS.SQUIDRAGON:
			return load("res://Monsters/Squidragon.tres")
		MATCH_SUITS.TRUNKR:
			return load("res://Monsters/trunkr.tres")
		MATCH_SUITS.FLIP:
			return load("res://Monsters/flip.tres")
		MATCH_SUITS.STRANGER:
			return load("res://Monsters/stranger.tres")
		MATCH_SUITS.RELC:
			return load("res://Monsters/Relc.tres")
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
