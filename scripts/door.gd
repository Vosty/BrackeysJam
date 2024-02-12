class_name Door

extends Sprite2D

signal Chosen(inside)

var inside = "hi"
var open = false
var checking = false

@export var animator : AnimationPlayer
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
	material.set_shader_parameter("outline_color", Color(0.11, 0.49, 0.88, 255))
	material.set_shader_parameter("width", outline_width)
	
func dehighlight(): #Effectively turns the shader outline off
	material.set_shader_parameter("width", 0.0)

func check_door():
	material.set_shader_parameter("outline_color", Color(0.11, 0.89, 0.88, 255))
	material.set_shader_parameter("width", outline_width)
	checking = true
	animator.play("Door_Open")
	
func uncheck_door():
	material.set_shader_parameter("width", 0.0)
	checking = false
	animator.play("Door_Close")
func open_door():
	uncheck_door()
	material.set_shader_parameter("outline_color", Color(0.91, 0.29, 0.28, 255))
	material.set_shader_parameter("width", outline_width)
	open = true



func _on_area_2d_mouse_entered():
	if !checking && !open:
		highlight()

func _on_area_2d_mouse_exited():
	if !checking && !open:
		dehighlight()
	


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		Chosen.emit(self)
