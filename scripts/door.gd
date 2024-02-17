class_name Door

extends Sprite2D

signal Chosen(inside)

signal Close_Finished()

var inside = "hi"
var open = false
var checking = false
var monster : Monster = null
var trap : Trap = null
var is_trap = false
var pos : Vector2i

static var trap_phase = false
static var results_phase = false

@export var animator : AnimationPlayer
@export var outline_width = 10.0

#Set up function, called when created by the level scene
func setup(internal):
	inside = internal
	is_trap = inside in MatchSuits.TRAP_SUITS
	if !is_trap:
		monster = MatchSuits.get_resource_mon(internal)
		get_node("Node2D/Mon").texture = monster.tex
	else:
		trap = MatchSuits.get_resource_trap(internal)
		get_node("Node2D/Mon").texture = trap.tex


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Node2D/Mon").hide()
	results_phase = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func highlight(): #Effectively turns the shader outline on
	if Player_data.is_peeking:
		material.set_shader_parameter("outline_color", Color(0.81, 0.49, 0.88, 255))
	else:
		material.set_shader_parameter("outline_color", Color(0.11, 0.49, 0.88, 255))
	material.set_shader_parameter("width", outline_width)
	
func dehighlight(): #Effectively turns the shader outline off
	material.set_shader_parameter("width", 0.0)

func check_door():
	material.set_shader_parameter("outline_color", Color(0.11, 0.89, 0.88, 255))
	material.set_shader_parameter("width", outline_width)
	checking = true
	animator.play("Door_Open")
	await get_tree().create_timer(0.5).timeout
	get_node("Node2D/Mon").show()
	
func peek_door(tween : Tween):
	material.set_shader_parameter("outline_color", Color(0.61, 0.29, 0.68, 255))
	material.set_shader_parameter("width", outline_width)
	checking = true
	#await get_tree().create_timer(0.5).timeout
	var mon = get_node("Node2D/Mon")
	mon.show()
	mon.modulate.a = 0.0
	tween.set_parallel()
	tween.tween_property(mon, 'modulate:a', 1.0, 1.05)
	tween.tween_method(fade, 1.0, .5, .75)
	
func unpeek_door(tween : Tween):
	material.set_shader_parameter("width", 0.0)
	
	var mon = get_node("Node2D/Mon")
	print(str(mon.modulate))
	tween.set_parallel()
	tween.tween_property(mon, 'modulate:a', 0.0, 1.05)
	tween.tween_method(fade, .5, 1.0, 1.5)
	await get_tree().create_timer(1.5).timeout
	checking = false
	mon.hide()
	mon.modulate.a = 1.0
	
func uncheck_door(close_door = true):
	material.set_shader_parameter("width", 0.0)
	checking = false
	if close_door:
		await get_tree().create_timer(0.8).timeout
		get_node("Node2D/Mon").hide()
		animator.play("Door_Close")
		
func reveal_trap():
	material.set_shader_parameter("outline_color", Color(0.91, 0.29, 0.28, 255))
	material.set_shader_parameter("width", outline_width)
	animator.play("Door_Open")
	checking = true
	await get_tree().create_timer(0.5).timeout
	get_node("Node2D/Mon").show()


func open_door():
	uncheck_door(false)
	open = true
	animator.play("Door_Open")

func close_door():
	open = false
	material.set_shader_parameter("outline_color", Color(0.91, 0.91, 0.20, 255))
	material.set_shader_parameter("width", outline_width)
	await get_tree().create_timer(0.8).timeout
	material.set_shader_parameter("width", 0.0)
	get_node("Node2D/Mon").hide()
	animator.play("Door_Close")
	
func fade_out(tween : Tween):
	material.set_shader_parameter("outline_color", Color(0.91, 0.91, 0.20, 255))
	material.set_shader_parameter("width", outline_width)
	tween.tween_method(fade, 1.0, 0.0, 0.75)
	
func fade_in(tween: Tween):
	material.set_shader_parameter("width", 0.0)
	tween.tween_method(fade, 0.0, 1.0, 0.75)
	
func fade(fade_amount):
	material.set_shader_parameter("fade", fade_amount)

func spring_trap():
	open = true
	material.set_shader_parameter("width", 0.0)
	animator.play("Door_Open")
	await get_tree().create_timer(0.5).timeout
	get_node("Node2D/Mon").show()

func _on_area_2d_mouse_entered():
	if !checking && !open && !trap_phase && !results_phase:
		highlight()

func _on_area_2d_mouse_exited():
	if !checking && !open:
		dehighlight()

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		Chosen.emit(self)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Door_Close":
		Close_Finished.emit()
