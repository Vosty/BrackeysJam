class_name Player

extends Node

signal Coins_Updated()

signal Keys_Updated()

var coins = 0
var keys = 10
var attempts = 0
var round = 1
var level = 8
var power_ups = []

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
