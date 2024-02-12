extends Node2D

@export var level: int = 10
@export var width = 1920
@export var height = 1080
@export var bufferx = 200
@export var buffery = 200

enum CHOOSE_STATES {NO_CHOICE, CHOICE_ONE, CHOICE_TWO}


const doorScene = preload("res://scenes/door.tscn")
const suits = preload("res://scripts/match_suits.gd").MATCH_SUITS

var doors = []
var state
var pick_one
var pick_two
var attempts

	
# Called when the node enters the scene tree for the first time.
func _ready():
	## Set-up
	prepare_doors()
	attempts = 10
	state = CHOOSE_STATES.NO_CHOICE


func prepare_doors():
	## Prepare all doors
	var i = 0
	var j = 0
	while i < level:
		while j < level:
			var door = doorScene.instantiate()
			var doorSpri = door.get_node("Sprite2D")
			
			## Creates a door, adjusts it to rest nicely on the screen within a window
			doorSpri.setup(choose_suit()) ## Assign
			door.position.x = (i * ((width-(bufferx * 2)) / (level-1))) + bufferx
			door.position.y = (j * ((height-(buffery * 2)) / (level-1))) + buffery
		
			doorSpri.Chosen.connect(handle_click)
			doors.append(door)
			add_child(door)
			j = j+1
		j = 0
		i = i+1
	print(i)


func choose_suit():
	## Currently assigns a random suit
	return suits.keys()[randi() % suits.keys().size()]


func handle_click(inside):
	print(inside)
	match state:
		CHOOSE_STATES.NO_CHOICE:
			pick_one = inside
			state = CHOOSE_STATES.CHOICE_ONE
		CHOOSE_STATES.CHOICE_ONE:
			pick_two = inside
			state = CHOOSE_STATES.CHOICE_TWO
			check_match()
		CHOOSE_STATES.CHOICE_TWO:
			pass
			
func check_match():
	if pick_one == pick_two:
		print("match!")
		## Do not decrement attempts!
	else:
		print("die")
		attempts = attempts - 1
	state = CHOOSE_STATES.NO_CHOICE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
