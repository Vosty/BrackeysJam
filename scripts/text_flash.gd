extends Node2D

@export var y_speed = 50.0
var lifespan = 100000
@onready var canvas = $CanvasLayer/Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(tween : Tween, texture : Texture2D, display_message : String, x : float, y : float, display_time : int = 100):
	get_node("CanvasLayer/Control/PanelContainer/MarginContainer/GridContainer/TextureRect").texture = texture
	get_node("CanvasLayer/Control/PanelContainer/MarginContainer/GridContainer/Label").text = display_message
	position.x = x
	position.y = y
	lifespan = display_time
	var canvas = get_node("CanvasLayer/Control")
	tween.tween_property(canvas, 'modulate:a', 0.0, 0.75)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_y(y_speed * delta)
	get_node("CanvasLayer/Control").position = position
	lifespan = lifespan - 1
	if lifespan <= 0:
		queue_free() #Destroys Node
