extends Control




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
	
