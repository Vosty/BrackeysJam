extends Node2D

const flash = preload("res://scenes/text_flash.tscn")
const coin_tex : Texture2D = preload("res://assets/Temp_Coin.png")
const key_tex : Texture2D = preload("res://assets/key.png")

var player : Player
var closed = false
@onready var sfx_player = $SFX_Player

@export var coin_sound : AudioStream


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Player_data")
	get_node("CanvasLayer/Control/PanelContainer/MarginContainer/GridContainer/KeyCount").text = str(player.keys)
	player.Keys_Updated.connect(update_keys)
	get_node("CanvasLayer/Control/PanelContainer/MarginContainer/GridContainer/RoundCount").text = str(player.round)
	hide_results_screen()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_results_screen():
	get_node("CanvasLayer/Control/PanelContainer/MarginContainer/GridContainer/AttemptsCount").text = str(player.attempts)
	get_node("CanvasLayer/Control/PanelContainer/MarginContainer/GridContainer/TrapsCount").text = str(player.traps_hit)
	get_node("CanvasLayer/Control/PanelContainer/MarginContainer/GridContainer/TimeCount").text = format_time(player.time_elapsed)
	get_node("CanvasLayer/Control").show()

func format_time(time):
	var minutes = time / 60
	var seconds = fmod(time,60)
	var formatted = "%02d:%02d" % [minutes, seconds]
	return formatted


func hide_results_screen():
	get_node("CanvasLayer/Control").hide()
	

func _on_button_pressed():
	if closed:
		return
	closed = true
	player.total_attempts += player.attempts
	player.total_traps += player.traps_hit
	player.total_time += player.time_elapsed
	var reward = 5 + player.bonus_money
	sfx_player.stream = coin_sound
	sfx_player.play()
	create_flash(coin_tex, "+" + str(reward), 50, 100, 100)
	player.update_coins(reward)
	await get_tree().create_timer(0.5).timeout
	for i in player.keys:
		await get_tree().create_timer(0.2).timeout
		player.update_keys(-1)
		create_flash(key_tex, "-1", 150, 100, 100)
		await get_tree().create_timer(0.05).timeout
		create_flash(coin_tex, "+1", 50, 100, 100)
		sfx_player.stream = coin_sound
		sfx_player.play()
		player.update_coins(1)
		
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
	pass # Replace with function body.


func update_keys():
	get_node("CanvasLayer/Control/PanelContainer/MarginContainer/GridContainer/KeyCount").text = str(player.keys)
	

func create_flash(texture : Texture2D, display_message : String, x : float, y : float, display_time : int = 100):
	var element = flash.instantiate()
	var tween = create_tween()
	element.setup(tween, texture, display_message, x, y, display_time)
	add_child(element)
