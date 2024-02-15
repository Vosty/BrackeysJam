extends Node2D

@export var clouds_tex = []

@export var min_clouds : int = 1
@export var max_clouds : int = 6
var height = 720
var width = 1080
var clouds = []
@export var cloud_speed : float = 5.0
var cloud_direction = [-1, 1].pick_random()
var cloud_count = randi_range(min_clouds, max_clouds)


func _ready():
	for i in cloud_count:
		clouds.append(create_cloud(clouds_tex.pick_random()))

func create_cloud(cloud_tex):
	var new_cloud = Sprite2D.new()
	new_cloud.texture = cloud_tex
	self.add_child(new_cloud)
	new_cloud.position.x = randi_range(0,width)
	new_cloud.position.y = randi_range(0, height)
	return new_cloud

func _physics_process(delta): # Use physics_process for updating only when drawing to screen
	# move clouds
	for cloud in clouds:
		cloud.position.x += (cloud_direction * cloud_speed * delta)
		if cloud_direction == -1 && cloud.position.x < (-cloud.texture.get_width()):
			cloud.position.x = width + cloud.texture.get_width()
		elif cloud_direction == 1 && cloud.position.x > (width + cloud.texture.get_width()):
			cloud.position.x = -cloud.texture.get_width()

