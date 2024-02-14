extends CanvasLayer

@onready var sfx_bus_ID = AudioServer.get_bus_index("SFX")
@onready var music_bus_ID = AudioServer.get_bus_index("Music")

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus_ID, linear_to_db(value/100))
	AudioServer.set_bus_mute(music_bus_ID, value < 1.0)
	


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_ID, linear_to_db(value/100))
	AudioServer.set_bus_mute(sfx_bus_ID, value < 1.0)
