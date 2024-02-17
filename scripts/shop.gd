extends Node

@export var available_upgrades = []
@export var labels = []
@export var texs = []
@export var buttons = []
@export var buy_sound : AudioStream
@export var reroll_sound : AudioStream
@export var free_reroll_sound : AudioStream
@export var broke_sound : AudioStream
@export var leave_sound : AudioStream
@onready var sfx_player = $SFX_Player

@onready var bell = $CanvasLayer/Bell_Button
@export var outline_width = 5

var shop_upgrades = []
var sold_status = []
var player : Player
var free_rolls_remaining


const flash = preload("res://scenes/text_flash.tscn")
const coin_tex : Texture2D = preload("res://assets/coin.png")


func get_available_upgrades():
	var avail = available_upgrades
	if player.get_upgrade_hold_count(player.UPGRADES.MATCH_EXTRA) >= 5:
		avail = avail.filter(func(u : Upgrade) : return u.type != player.UPGRADES.MATCH_EXTRA)
	if player.get_upgrade_hold_count(player.UPGRADES.FAIL_EXTRA) >= 10:
		avail = avail.filter(func(u : Upgrade) : return u.type != player.UPGRADES.FAIL_EXTRA)
	if player.get_upgrade_hold_count(player.UPGRADES.FREE_REROLLS) >= 10:
		avail = avail.filter(func(u : Upgrade) : return u.type != player.UPGRADES.FREE_REROLLS)
	if player.get_upgrade_hold_count(player.UPGRADES.TRAP_AVOID) >= 5:
		avail = avail.filter(func(u : Upgrade) : return u.type != player.UPGRADES.TRAP_AVOID)
	if player.get_upgrade_hold_count(player.UPGRADES.NEARBY_SHOW) >= 4:
		avail = avail.filter(func(u : Upgrade) : return u.type != player.UPGRADES.NEARBY_SHOW)
	if player.get_upgrade_hold_count(player.UPGRADES.CLONE_PAIR) >= player.round:
		avail = avail.filter(func(u : Upgrade) : return u.type != player.UPGRADES.CLONE_PAIR)
	return avail

	

func set_shop():
	free_rolls_remaining = player.free_rerolls
	if free_rolls_remaining > 0:
		bell.material.set_shader_parameter("outline_color", Color(0.91, 0.91, 0.20, 255))
		bell.material.set_shader_parameter("width", outline_width)
	for i in labels.size():
		labels[i] = get_node(labels[i])
		texs[i] = get_node(texs[i])
		buttons[i] = get_node(buttons[i])
	roll_shop()
	if player.round == 1:
		$CanvasLayer/Hover_Hint.show()
		$CanvasLayer/Bell_Hint.show()
	
	
func roll_shop():
	shop_upgrades = []
	sold_status = []
	if available_upgrades.size() < 3:
		create_flash(coin_tex, "No upgrades left!", 500, 600)
		return false # I don't think this should happen anymore
		
	for i in 3:
		var item = roll_item()
		shop_upgrades.append(roll_item())	
	
	for i in shop_upgrades.size():
		labels[i].text = shop_upgrades[i].name
		texs[i].texture = shop_upgrades[i].tex
		texs[i].tooltip_text = shop_upgrades[i].description
		buttons[i].text = str(shop_upgrades[i].cost)
		sold_status.append(false)
	return true
	
func roll_item():
	var avail = get_available_upgrades()
	var index = randi() % avail.size()
	return avail[index]
	

func create_flash(texture : Texture2D, display_message : String, x : float, y : float, display_time : int = 100):
	var element = flash.instantiate()
	var tween = create_tween()
	element.setup(tween, texture, display_message, x, y, display_time)
	add_child(element)


func _ready():
	player = get_node("/root/Player_data")
	set_shop()
	player.check_upgrades()
	
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
		sfx_player.stream = broke_sound
		sfx_player.play()
		return
	player.update_coins(-1 * shop_upgrades[i].cost)
	create_flash(coin_tex, "-" + str(shop_upgrades[i].cost), 100, 100)
	sfx_player.stream = buy_sound
	sfx_player.play()
	player.upgrades.append(shop_upgrades[i])
	buttons[i].text = "SOLD"
	sold_status[i] = true
	player.check_upgrades()


func _on_exit_pressed():
	player.level += 1
	player.round += 1
	sfx_player.steam = leave_sound
	sfx_player.play()
	get_tree().change_scene_to_file("res://scenes/Level.tscn")



func _on_bell_button_pressed():

	if player.coins <= 0 && free_rolls_remaining <= 0:
		create_flash(coin_tex, "You're Broke!", 500, 100)
		sfx_player.stream = broke_sound
		sfx_player.play()
		return
	if roll_shop():
		if free_rolls_remaining > 0:
			sfx_player.stream = free_reroll_sound
			sfx_player.play()
			create_flash(coin_tex, "FREE!", 500, 100)
			free_rolls_remaining -= 1
			if free_rolls_remaining <= 0:
				bell.material.set_shader_parameter("width", 0)
		else:
			sfx_player.stream = reroll_sound
			sfx_player.play()
			player.update_coins(-1)
			create_flash(coin_tex, "-1", 100, 100)


func _on_texture_button_pressed():
	player.level += 1
	player.round += 1
	get_tree().change_scene_to_file("res://scenes/Level.tscn")

