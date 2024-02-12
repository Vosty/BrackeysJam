extends Node

##const flash = preload("res://scenes/text_flash.tscn")
##const key = preload("res://assets/Iron_Key.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_coins(coin_count: String):
	var coin_node = get_node("CanvasLayer/PanelContainer/MarginContainer/GridContainer/Coin Label")
	coin_node.text = coin_count
	
func update_keys(key_count: String):
	var key_node = get_node("CanvasLayer/PanelContainer/MarginContainer/GridContainer/Key Label")
	key_node.text = key_count

##func create_flash(texture : Texture2D, display_message : String, x : float, y : float, display_time : int = 100):
##	var element = flash.instantiate()
##	element.setup(texture, display_message, x, y, display_time) 
##	add_child(element)
