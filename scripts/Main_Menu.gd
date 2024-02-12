extends Control

@export var play_button : TextureButton
@export var tutorial_button : TextureButton
@export var quit_button : TextureButton
@export var options_button : TextureButton


func _on_play_pressed():
	#Loads game scene
	get_tree().change_scene_to_file("res://scenes/Level.tscn")
	pass # Replace with function body.


func _on_directions_pressed():
	pass # Replace with function body.


func _on_options_pressed():
	#Allows the player to turn off the music for the best experience
	pass # Replace with function body.


func _on_quit_pressed():
	#Exits the Game
	get_tree().quit()
	

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
