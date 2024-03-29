extends Control

@export var play_button : TextureButton
@export var tutorial_button : TextureButton
@export var quit_button : TextureButton
@export var options_button : TextureButton
@onready var instructions_panel = $Instructions_Panel
@onready var credits_panel = $"Credits Panel"



func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Level.tscn")
	pass # Replace with function body.
	
func _on_play_button_mouse_entered():
	play_button.set_scale(Vector2(0.8, 0.8))
	

func _on_play_button_mouse_exited():
	play_button.set_scale(Vector2(0.7, 0.7))
	


func _on_directions_mouse_entered():
	tutorial_button.set_scale(Vector2(0.8, 0.8))


func _on_directions_mouse_exited():
	tutorial_button.set_scale(Vector2(0.7, 0.7))



func _on_options_button_mouse_entered():
	options_button.set_scale(Vector2(0.8, 0.8))
	

func _on_options_button_mouse_exited():
	options_button.set_scale(Vector2(0.7, 0.7))
	



func _on_quit_button_mouse_entered():
	quit_button.set_scale(Vector2(0.8, 0.8))


func _on_quit_button_mouse_exited():
	quit_button.set_scale(Vector2(0.7, 0.7))


func _on_quit_button_pressed():
	get_tree().quit()


func _on_directions_pressed():
	instructions_panel.visible = true
	
	
func _on_back_button_pressed():
	instructions_panel.visible = false
	credits_panel.visible = false
	
	


func _on_options_button_pressed():
	credits_panel.visible = true
