extends Node

var player

@export var match_extra_label : Label
@export var fail_extra_label : Label
@export var peek_label : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Player_data")
	player.Coins_Updated.connect(update_coins)
	player.Keys_Updated.connect(update_keys)
	player.Upgrades_Updated.connect(update_upgrades)
	update_keys()
	update_coins()
	update_upgrades()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_coins():
	var coin_node = get_node("CanvasLayer/PanelContainer/MarginContainer/GridContainer/Coin Label")
	coin_node.text = str(player.coins)
	
func update_keys():
	var key_node = get_node("CanvasLayer/PanelContainer/MarginContainer/GridContainer/Key Label")
	key_node.text = str(player.keys)
	
func update_upgrades():
	match_extra_label.text = str(player.match_extra * 100) + "%"
	fail_extra_label.text = str(player.fail_extra * 100) + "%"
	peek_label.text = str(player.peek)
	
	
