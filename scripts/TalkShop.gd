extends Node

@export var talkable_monsters = []
@export var positions = []
var monsters = []
@export var group_size : int = 2
var rng = RandomNumberGenerator.new()

func _ready():
	for i in group_size:
		monsters.append(talkable_monsters.pop_at(rng.randi_range(0, talkable_monsters.size() -1)))
	create_sprites()
	
func create_sprites():
	var i : int = 0
	for monster in monsters:
		var new_monster = Sprite2D.new()
		new_monster.texture = monster.tex
		self.add_child(new_monster)
		new_monster.position.x = get_node(positions[i]).position.x
		new_monster.position.y = get_node(positions[i]).position.y
		new_monster.set_flip_h(monster.facing_right == bool(i))
		new_monster.set_scale(Vector2(2,2))
		
		i += 1
		
