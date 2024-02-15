extends CanvasLayer

@onready var sfx_bus_ID = AudioServer.get_bus_index("SFX")
@onready var music_bus_ID = AudioServer.get_bus_index("Music")
var is_shown : bool = false
@onready var grid_container = $VBoxContainer/GridContainer
@onready var show_hide_button = $VBoxContainer/Show_hide_button



func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus_ID, linear_to_db(value/100))
	AudioServer.set_bus_mute(music_bus_ID, value < 1.0)
	


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_ID, linear_to_db(value/100))
	AudioServer.set_bus_mute(sfx_bus_ID, value < 1.0)


func _on_texture_button_pressed():
	if is_shown:
		is_shown = false
		grid_container.visible = false
		show_hide_button.set_flip_v(true)
	else:
		is_shown = true
		grid_container.visible = true
		show_hide_button.set_flip_v(false)
		
	 
