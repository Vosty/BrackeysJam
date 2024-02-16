class_name Player

extends Node

signal Coins_Updated()

signal Keys_Updated()

signal Upgrades_Updated()

enum UPGRADES {NO_EFFECT, MATCH_EXTRA, FAIL_EXTRA, KEYS_EXTRA, PEEK, CLONE_PAIR, BONUS_MONEY, FREE_REROLLS, TRAP_AVOID, NEARBY_SHOW}

var coins = 0
var keys = 10
var attempts = 0
var traps_hit = 0
var round = 1
var level = 8
var upgrades = []

var match_extra : float = 0.0
var fail_extra : float = 0.0
var keys_extra : int = 0
var clone_pairs : int = 0
var peek : int = 0
var bonus_money : int = 0
var free_rerolls : int = 0
var trap_avoid : float = 0.0
var nearby_show : int = 0

var is_peeking = false

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
	keys_extra = 0
	clone_pairs = 0
	bonus_money = 0
	free_rerolls = 0
	trap_avoid = 0.0
	nearby_show = 0
	for power_up in upgrades:
		match power_up.type:
			UPGRADES.NO_EFFECT:
				pass
			UPGRADES.MATCH_EXTRA:
				match_extra = clamp(match_extra + 0.10, 0.0, 0.5)
			UPGRADES.FAIL_EXTRA:
				fail_extra = clamp(fail_extra +0.05, 0.0, 0.5)
			UPGRADES.PEEK:
				peek += 1
			UPGRADES.KEYS_EXTRA:
				keys_extra += 1
			UPGRADES.CLONE_PAIR:
				clone_pairs += 1
			UPGRADES.BONUS_MONEY:
				bonus_money += 1
			UPGRADES.FREE_REROLLS:
				free_rerolls = clamp(free_rerolls + 1, 0,  5)
			UPGRADES.TRAP_AVOID:
				trap_avoid = clamp(trap_avoid + .10, 0.0, 0.5)
			UPGRADES.NEARBY_SHOW:
				nearby_show = clamp(nearby_show + 1, 0, 4)
	Upgrades_Updated.emit()
	print( "Match extra: " + str(match_extra))
	print( "Fail extra: " + str(fail_extra))
	print( "Peek: " + str(peek))
	print("Extra Keys: " + str(keys_extra))
	print("Clone Pairs: " + str(clone_pairs))
	print("Bonus Money: " + str(bonus_money))
	print("Free Rerolls: " + str(free_rerolls))

func get_upgrade_hold_count(upgrade : UPGRADES):
	var count = 0
	for power_up in upgrades:
		if power_up.type == upgrade:
			count += 1
	return count
