extends Sprite2D


var inside
# Called when the node enters the scene tree for the first time.
func _ready():
	inside = "hey"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed && get_rect().has_point(event.position):
			print("Click: " + inside)
	elif event is InputEventMouseMotion:
		if get_rect().has_point(event.position):
			print("Look at me")

