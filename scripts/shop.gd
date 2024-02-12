extends Node

@export var available_upgrades = []
@export var labels = []
@export var texs = []
@export var buttons = []

var shop_upgrades = []
var sold_status = []
var player : Player

const flash = preload("res://scenes/text_flash.tscn")
const coin_tex : Texture2D = preload("res://assets/Temp_Coin.png")


func set_available_upgrades():
	# Remove upgrades that the player should not be able to get here.
	pass
	

func set_shop():
	for i in labels.size():
		labels[i] = get_node(labels[i])
		texs[i] = get_node(texs[i])
		buttons[i] = get_node(buttons[i])
	
	roll_shop()
	
	
func roll_shop():
	shop_upgrades = []
	sold_status = []
	if available_upgrades.size() < 3:
		create_flash(coin_tex, "No upgrades left!", 500, 600)
		return false
	var index = randi() % available_upgrades.size()
	shop_upgrades.append(available_upgrades[index])
	available_upgrades.remove_at(index)
	index = randi() % available_upgrades.size()
	shop_upgrades.append(available_upgrades[index])
	available_upgrades.remove_at(index)
	index = randi() % available_upgrades.size()
	shop_upgrades.append(available_upgrades[index])
	available_upgrades.remove_at(index)
	
	for i in shop_upgrades.size():
		labels[i].text = shop_upgrades[i].name
		texs[i].texture = shop_upgrades[i].tex
		texs[i].tooltip_text = shop_upgrades[i].description
		buttons[i].text = str(shop_upgrades[i].cost)
		sold_status.append(false)
	return true

func create_flash(texture : Texture2D, display_message : String, x : float, y : float, display_time : int = 100):
	var element = flash.instantiate()
	var tween = create_tween()
	element.setup(tween, texture, display_message, x, y, display_time)
	add_child(element)


func _ready():
	set_shop()
	player = get_node("/root/Player_data")
	
func _on_button_1_pressed():
	buy_upgrade(0)

func _on_button_2_pressed():
	buy_upgrade(1)

func _on_button_3_pressed():
	buy_upgrade(2)
	
func buy_upgrade(i):
	if sold_status.size() < 3 || sold_status[i]:
		return
	if player.coins < shop_upgrades[i].cost:
		create_flash(coin_tex, "You're Broke!", 500, 100)
		return
	player.update_coins(-1 * shop_upgrades[i].cost)
	create_flash(coin_tex, "-" + str(shop_upgrades[i].cost), 100, 100)
	player.power_ups.append(shop_upgrades[i])
	buttons[i].text = "SOLD"
	sold_status[i] = true

func _on_reroll_pressed():
	if player.coins <= 0:
		create_flash(coin_tex, "You're Broke!", 500, 600)
		return
	if roll_shop():
		player.update_coins(-1)
		create_flash(coin_tex, "-1", 100, 100)

func _on_exit_pressed():
	player.level += 1
	player.round += 1
	get_tree().change_scene_to_file("res://scenes/Level.tscn")
