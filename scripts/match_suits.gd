extends Node

enum MATCH_SUITS { CLUBS, SPADES , HEARTS, DIAMONDS, DONKEY, HORSE, COW, ZEBRA, BIRD, DOG, CAT, SUPERMAN, BATMAN, SPIDERMAN, BAGELS, BREAD, RICE, PIZZA, WATER, SODA, PISS, GRASS, FIRE, STEEL, GROUND, PSYCHIC, FAIRY, SLIME }


func get_resource(suit):
	match MATCH_SUITS.get(suit):
		MATCH_SUITS.SLIME:
			return load("res://Monsters/test_monster.tres")
		_:
			return load("res://Monsters/test_monster.tres")
