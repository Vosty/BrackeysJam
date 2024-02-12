class_name Player

extends Node

signal Coins_Updated()

signal Keys_Updated()

enum UPGRADES {NO_EFFECT, MATCH_EXTRA, FAIL_EXTRA, PEEK }

var coins = 0
var keys = 10
var attempts = 0
var round = 1
var level = 8
var upgrades = []
var match_extra : float = 0.0
var fail_extra : float = 0.0
var peek : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func update_coins(delta: int):
	coins += delta
	Coins_Updated.emit()

func update_keys(delta: int):
	keys += delta
	Keys_Updated.emit()
	
func set_keys(number: int):
	keys = number
	Keys_Updated.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_upgrades():
	match_extra = 0
	fail_extra = 0
	peek = 0
	for power_up in upgrades:
		match power_up.type:
			UPGRADES.NO_EFFECT:
				pass
			UPGRADES.MATCH_EXTRA:
				match_extra += 0.1
				
			UPGRADES.FAIL_EXTRA:
				fail_extra += 0.1
			UPGRADES.PEEK:
				peek += 1
	print( "Match extra: " + str(match_extra))
	print( "Fail extra: " + str(fail_extra))
	print( "Peek: " + str(peek))
	
