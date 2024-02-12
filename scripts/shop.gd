extends Node

@export var available_upgrades = []
@export var labels = []
@export var texs = []
@export var buttons = []

var shop_upgrades = []

func set_available_upgrades():
	
	pass
	

func set_shop():
	for i in labels.size():
		labels[i] = get_node(labels[i])
		texs[i] = get_node(texs[i])
		buttons[i] = get_node(buttons[i])
	
	var index = randi() % available_upgrades.size()
	shop_upgrades.append(available_upgrades[index])
	available_upgrades.remove_at(index)
	index = randi() % available_upgrades.size()
	shop_upgrades.append(available_upgrades[index])
	available_upgrades.remove_at(index)
	shop_upgrades.append(available_upgrades[randi() % available_upgrades.size()])
	
	for i in shop_upgrades.size():
		labels[i].text = shop_upgrades[i].name
		texs[i].texture = shop_upgrades[i].tex
		texs[i].tooltip_text = shop_upgrades[i].description
		buttons[i].text = str(shop_upgrades[i].cost)
		
func _ready():
	set_shop()
	
func _on_button_1_pressed():
	pass # Replace with function body.

func _on_button_2_pressed():
	pass # Replace with function body.

func _on_button_3_pressed():
	pass # Replace with function body.
