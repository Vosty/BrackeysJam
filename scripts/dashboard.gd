extends Node

##const flash = preload("res://scenes/text_flash.tscn")
##const key = preload("res://assets/Iron_Key.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(player: Player):
	update_coins(str(player.coins))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_coins(coin_count: String):
	var coin_node = get_node("CanvasLayer/PanelContainer/MarginContainer/GridContainer/Coin Label")
	coin_node.text = coin_count
	
func update_keys(key_count: String):
	var key_node = get_node("CanvasLayer/PanelContainer/MarginContainer/GridContainer/Key Label")
	key_node.text = key_count
