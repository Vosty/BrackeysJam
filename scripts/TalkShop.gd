extends Node

@export var talkable_monsters = []

@export var positions = []
var monsters = []
@export var group_size : int = 2
var rng = RandomNumberGenerator.new()
@export var dialog_array = []
@onready var dialogue_panel_1 = $"Dialogue Panel 1"
@onready var dialogue_label_1 = $"Dialogue Panel 1/DialogueLabel1"
@onready var next_char = $next_char
@onready var next_message = $next_message
@onready var dialogue_panel_2 = $"Dialogue Panel 2"
@onready var dialogue_label_2 = $"Dialogue Panel 2/DialogueLabel2"


var display : String = ""

var chosen_dialogue : Dialogue
var current_message_index : int = 0
var current_char_index : int = 0

func _ready():
	chosen_dialogue = dialog_array.pick_random()
	for monster in chosen_dialogue.required_monsters:
		monsters.append(monster)
		talkable_monsters.remove_at(talkable_monsters.find(monster,0))
	while monsters.size() < group_size:
		monsters.append(talkable_monsters.pop_at(randi_range(0,talkable_monsters.size() - 1)))
		
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
		
		



func _on_next_char_timeout():
	var message = chosen_dialogue.dialogues[current_message_index]
	if message == null:
		message = ""
		next_char.stop()
		_on_next_message_timeout()
	if display.length() < message.length():
		display += message[current_char_index]
		current_char_index += 1
		if current_message_index % 2:
			dialogue_label_2.text = display
		else:
			dialogue_label_1.text = display
	else:
		next_char.stop()
		display = ""
		current_message_index += 1
		current_char_index = 0
		next_message.one_shot = true
		next_message.start()
	
	


func _on_next_message_timeout():
	dialogue_label_1.text = ""
	dialogue_label_2.text = ""
	dialogue_panel_1.visible = !(current_message_index % 2)
	dialogue_panel_2.visible = current_message_index % 2
	if current_message_index >= chosen_dialogue.dialogues.size():
		dialogue_panel_1.visible = false
		dialogue_panel_2.visible = false
	else:
		next_char.start()
