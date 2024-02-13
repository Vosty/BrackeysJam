extends Node

enum MATCH_SUITS { WORM, GREEBO , GUNWICH, FACIST, DONKEY, HORSE, COW, ZEBRA, BIRD, DOG, CAT, SUPERMAN, BATMAN, SPIDERMAN, BAGELS, BREAD, RICE, PIZZA, WATER, SODA, PISS, GRASS, FIRE, STEEL, GROUND, PSYCHIC, FAIRY, SLIME }


func get_resource(suit):
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
		_:
			return load("res://Monsters/test_monster.tres")
