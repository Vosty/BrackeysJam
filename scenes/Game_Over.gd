extends Node2D

var player : Player
var closed = false



# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Player_data")
	hide_gameover_scene()
	pass # Replace with function body.

func hide_gameover_scene():
	get_node("CanvasLayer/Control").hide()

func show_gameover_screen(win = false):
	#Update totals with current stats
	if win:
		get_node("CanvasLayer/Control/PanelContainer/MarginContainer/VBoxContainer/Game Over").text = "You Win!"
	player.total_attempts += player.attempts
	player.total_traps += player.traps_hit
	player.total_time += player.time_elapsed
	get_node("CanvasLayer/Control/PanelContainer/MarginContainer/VBoxContainer/GridContainer/RoundCount").text = str(player.round)
	get_node("CanvasLayer/Control/PanelContainer/MarginContainer/VBoxContainer/GridContainer/AttemptsCount").text = str(player.total_attempts)
	get_node("CanvasLayer/Control/PanelContainer/MarginContainer/VBoxContainer/GridContainer/TrapsCount").text = str(player.total_traps)
	get_node("CanvasLayer/Control/PanelContainer/MarginContainer/VBoxContainer/GridContainer/TimeCount").text = format_time(player.total_time)
	get_node("CanvasLayer/Control").show()

func format_time(time):
	var minutes = time / 60
	var seconds = fmod(time,60)
	var formatted = "%02d:%02d" % [minutes, seconds]
	return formatted


func _on_button_pressed():
	if closed:
		return
	closed = true
	player.new_game()
	get_tree().change_scene_to_file("res://scenes/Main_Menu.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
