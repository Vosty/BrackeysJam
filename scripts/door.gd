extends Sprite2D

signal Chosen(inside)

var inside = "hi"
@export var outline_width = 10.0

#Set up function, called when created by the level scene
func setup(internal):
	inside = internal


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func highlight(): #Effectively turns the shader outline on
	material.set_shader_parameter("width", outline_width)
	
func dehighlight(): #Effectively turns the shader outline off
	material.set_shader_parameter("width", 0.0)


func _on_area_2d_mouse_entered():
	highlight()

func _on_area_2d_mouse_exited():
	dehighlight()
	


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		Chosen.emit(inside)
