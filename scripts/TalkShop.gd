extends Node

@export var talkable_monsters = []
@export var positions = []
var monsters = []
@export var group_size : int = 2
var rng = RandomNumberGenerator.new()

func _ready():
	for i in group_size:
		monsters.append(talkable_monsters.pop_at(rng.randi_range(0, talkable_monsters.size -1)))
	
func create_sprites():
	for monster in monsters:
		var new_monster = Sprite2D.new()
		new_monster.texture = monster.tex
		self.add_child(new_monster)
		
