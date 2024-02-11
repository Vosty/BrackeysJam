extends Node2D

@export var level: int = 5
@export var width = 1920
@export var height = 1080
@export var bufferx = 200
@export var buffery = 400

var doors = []
const doorScene = preload("res://scripts/door.tscn")

	
# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	var j = 0
	while i < level:
		while j < level:
			var door = doorScene.instantiate()
			var doorSpri = door.get_node("Sprite2D")

			doorSpri.setup("hi")
			door.position.x = (i * ((width-(bufferx * 2)) / (level-1))) + bufferx
			door.position.y = (j * ((height-(buffery * 2)) / (level-1))) + buffery
		
			doors.append(door)
			add_child(door)
			j = j+1
		j = 0
		i = i+1
	print(i)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
