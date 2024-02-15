extends Node2D

@export var width = 1080
@export var height = 720
@export var bufferx = 200
@export var buffery = 200
@export var starting_keys = 10
@export var baseboard_tex : Texture
@export var wall_tex : Texture
@export var floor_tex : Texture
@onready var sfx_player = $SFX_Player

@export var match_sound : AudioStream
@export var gain_key_sound : AudioStream
@export var lose_key_sound : AudioStream
@export var save_key_sound : AudioStream
@export var win_sound : AudioStream
enum CHOOSE_STATES {NO_CHOICE, CHOICE_ONE, CHOICE_TWO, RESULTS_SCREEN, PEEK_STAGE, TRAP_REVEAL}


const doorScene = preload("res://scenes/door.tscn")
const flash = preload("res://scenes/text_flash.tscn")
const key_tex : Texture2D = preload("res://assets/Iron_Key.png")
const coin_tex : Texture2D = preload("res://assets/Temp_Coin.png")

const clover_tex : Texture2D = preload("res://assets/Upgrades/Clover.png")
const cuff_links_tex : Texture2D = preload("res://assets/Upgrades/cufflinks.png")
const eye_tex : Texture2D = preload("res://assets/eye.png")


var suits = MatchSuits.MATCH_SUITS
var traps = MatchSuits.TRAP_SUITS
var player : Player

var rng = RandomNumberGenerator.new()
var doors = []
var suits_in_use = []
var state = CHOOSE_STATES.NO_CHOICE
var suits_to_win : int
var matches_found : int = 0
var trap_number : int = 0
var pick_one : Door
var pick_two : Door
var match_extra : float
var fail_extra : float
var peek : int
# Called when the node enters the scene tree for the first time.
func _ready():
	## Set-up
	player = get_node("/root/Player_data")
	
	
	player.set_keys(starting_keys+player.keys_extra)
	player.attempts = 0
	player.traps_hit = 0
	prepare_doors()
	player.check_upgrades()
	match_extra = player.match_extra
	fail_extra = player.fail_extra
	
	if trap_number > 0:
		state = CHOOSE_STATES.TRAP_REVEAL
		var traps = doors.filter(func (d): return d.is_trap)
		for t in traps:
			t.reveal_trap()
		await get_tree().create_timer(5).timeout
		for t in traps:
			t.uncheck_door()
	
		
	peek = player.peek
	if peek > 0:
		state = CHOOSE_STATES.PEEK_STAGE
	else:
		state = CHOOSE_STATES.NO_CHOICE

func prepare_doors():
	var rows = player.level / 3
	var columns = (player.level+2) / 3
	## Prepare all doors
	var i = 0
	var j = 0
	setup_suits(rows, columns)
	while i < rows:
		setup_baseboards((i * ((height-(buffery * 2)) / (rows-1))) + buffery)
		while j < columns:
			var door = doorScene.instantiate()
			var doorSpri = door.get_node("Sprite2D")
			
			## Creates a door, adjusts it to rest nicely on the screen within a window
			doorSpri.setup(choose_suit()) ## Assign

			door.position.x = (j * ((width-(bufferx * 2)) / (columns-1))) + bufferx
			door.position.y = (i * ((height-(buffery * 2)) / (rows-1))) + buffery
			
			doorSpri.pos = Vector2i(i, j)
			
			doorSpri.Chosen.connect(handle_click)
			doors.append(doorSpri)
			add_child(door)
			j = j+1
		j = 0
		
		i = i+1
		
func setup_baseboards(door_y_position):
	var baseboard_length : int = 0
	var segment_length : int = wall_tex.get_width()
	
	while baseboard_length < width:
		#Add new baseboard sprite
		var new_wall = Sprite2D.new()
		var new_segment = Sprite2D.new()
		var new_floor = Sprite2D.new()
		new_wall.texture = wall_tex
		new_segment.texture = baseboard_tex
		new_floor.texture = floor_tex
		self.add_child(new_wall)
		self.add_child(new_segment)
		self.add_child(new_floor)
		new_wall.position.x = baseboard_length + 32
		new_wall.position.y = door_y_position - 12
		new_segment.position.x = baseboard_length + 32
		new_segment.position.y = door_y_position + 30
		new_floor.position.x = baseboard_length + 32
		new_floor.position.y = door_y_position + 64
		baseboard_length += segment_length
	
	
func setup_suits(rows, columns):
	trap_number = floor(sqrt(rows * columns)) - 2
	print("Traps: " + str(trap_number))
	var num_suits = (((rows * columns) - trap_number) / 2)
	var odd = ((num_suits * 2) + trap_number) != rows * columns
	if odd:
		trap_number += 1
		print("ODD")
	suits_to_win = num_suits
	print("Traps: " + str(trap_number))
	print("Num Suits: " + str(num_suits))
	var using_suits = suits.keys()
	# Shuffle list of all possible suits
	using_suits.shuffle()
	# Remove suits we don't need:
	using_suits.resize(num_suits)
	# Now make two copies of all of these suits
	suits_in_use = []
	for s in using_suits:
		suits_in_use.append(s)
		suits_in_use.append(s)
		
	# Clone suits, very stupid logic
	var index = 0
	for c in player.clone_pairs:
		# Replace the two in the front with the two in the back, works inwords
		# Works because we shuffle everytime we pick suits
		suits_in_use[index] = suits_in_use[suits_in_use.size() - 1 - index]
		suits_in_use[index + 1] = suits_in_use[suits_in_use.size() - 2 - index]
		index += 2

	#Finally, add traps
	for t in trap_number:
		suits_in_use.append(roll_trap())

func roll_trap():
	var traps_list = traps.keys()
	traps_list.shuffle()
	return traps_list.pop_front()

func choose_suit():
	suits_in_use.shuffle()
	var index = randi() % suits_in_use.size()
	return suits_in_use.pop_at(index)


func handle_click(door):
	print(door.inside)
	if door.checking || door.open:
		return
	player.attempts +=1
	match state:
		CHOOSE_STATES.RESULTS_SCREEN || CHOOSE_STATES.TRAP_REVEAL:
			return
		CHOOSE_STATES.NO_CHOICE:
			if door.is_trap:
				spring_trap(door)
				return
			pick_one = door
			check_door(door)
			state = CHOOSE_STATES.CHOICE_ONE
		CHOOSE_STATES.CHOICE_ONE:
			if door.is_trap:
				spring_trap(door)
				pick_one.uncheck_door()
				lose_key()
				state = CHOOSE_STATES.NO_CHOICE
				return
			pick_two = door
			check_door(door)
			state = CHOOSE_STATES.CHOICE_TWO
			check_match(door)
		CHOOSE_STATES.CHOICE_TWO:
			pass
		CHOOSE_STATES.PEEK_STAGE: #Allows looking behind door at beginning if able
			peek -= 1
			check_door(door)
			create_flash(eye_tex, "PEEKING!", 300.0, 100.0, 100)
			if peek <= 0:
				for d in doors:
					if d.checking:
						d.uncheck_door(true)
				state = CHOOSE_STATES.NO_CHOICE
			
			pass
func check_match(door):
	if pick_one.inside == pick_two.inside:
		print("match!")
		sfx_player.stream = match_sound
		sfx_player.play()
		open_door(pick_one)
		open_door(pick_two)
		matches_found = matches_found + 1
		# Match_Extra powerup
		if rng.randf() <= match_extra:
			player.update_keys(1)
			create_flash(clover_tex, "+1", 100.0, 100.0, 100.0)
			print("Match extra")
			
		if matches_found >= suits_to_win:
			state = CHOOSE_STATES.RESULTS_SCREEN
			await get_tree().create_timer(3).timeout
			get_node("ResultsScreen").show_results_screen()
		
		# Shades Power-up	
		if player.nearby_show > 0:
			var nearby = get_nearby_doors(door)
			if nearby.size() == 0:
				return
			create_flash(eye_tex, "PEEKING!", 300.0, 100.0, 100)
			nearby.shuffle()
			var show = []	
			for i in player.nearby_show:
				if nearby.size() > 1:
					show.append(nearby.pop_front())
			for d in show:
				d.check_door()
				await get_tree().create_timer(0.75).timeout
				d.uncheck_door()
			
		## Do not decrement attempts!
	else:
		print("die")
		pick_one.uncheck_door()
		pick_two.uncheck_door()
		lose_key()

	state = CHOOSE_STATES.NO_CHOICE

func check_door(door):
	create_flash(key_tex, door.inside, get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y)
	door.check_door()
	
func open_door(door):
	door.open_door()
	
func lose_key():
		if rng.randf() > fail_extra: #fail extra powerup implementation
			player.update_keys(-1)
			create_flash(key_tex, "-1", 100.0, 100.0, 100) # This should be better lol
			sfx_player.stream = lose_key_sound
			sfx_player.play()
		else:
			create_flash(clover_tex, "SAVED", 100.0, 100.0, 100.0)
			sfx_player.stream = save_key_sound
			sfx_player.play()
	
func spring_trap(door):
	door.spring_trap()
	player.traps_hit += 1
	if rng.randf() <= player.trap_avoid:
		create_flash(cuff_links_tex, "TRAP AVOIDED!", get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y)
		sfx_player.stream = save_key_sound
		sfx_player.play()
		return
	
	create_flash(key_tex, door.inside, get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y)
	match traps.get(door.inside):
		traps.MINUS_KEY:
			player.update_keys(-3)
			create_flash(key_tex, "-3", 100.0, 100.0, 100)
			sfx_player.stream = lose_key_sound
			sfx_player.play()
		traps.CLOSE_DOOR:
			sfx_player.stream = lose_key_sound
			sfx_player.play()
			var open_doors = doors.filter(func(d): return d.open && !d.is_trap)
			if open_doors.size() < 2:
				return
			open_doors.shuffle()
			var dx = open_doors.pop_front()
			var dy = open_doors.filter(func(d): return d.inside == dx.inside).pop_front()
			dx.close_door()
			dy.close_door()
			matches_found -= 1
			open_doors.erase(dy)
			if open_doors.size() < 2:
				return
			open_doors.shuffle()
			dx = open_doors.pop_front()
			dy = open_doors.filter(func(d): return d.inside == dx.inside).pop_front()
			dx.close_door()
			dy.close_door()
			matches_found -= 1
		traps.SWAP_DOOR:
			var closed_doors = doors.filter(func(d): return !d.open && !d.is_trap && !d.checking)
			if closed_doors.size() < 2:
				return
			closed_doors.shuffle()
			var dx = closed_doors.pop_front()
			closed_doors.shuffle()
			var dy = closed_doors.pop_front()
			var tween = create_tween()
			tween.set_parallel(true)
			dx.fade_out(tween)
			dy.fade_out(tween)
			tween = tween.chain()
			dx.fade_in(tween)
			dy.fade_in(tween)
			var inside = dx.inside
			dx.setup(dy.inside)
			dy.setup(inside)
			

func get_nearby_doors(door):
	var nearby = []
	var up = find_door(door.pos.x, door.pos.y - 1)
	if up:
		nearby.append(up)
	var down = find_door(door.pos.x, door.pos.y + 1)
	if down:
		nearby.append(down)
	var left = find_door(door.pos.x - 1, door.pos.y)
	if left:
		nearby.append(left)
	var right = find_door(door.pos.x + 1, door.pos.y)
	if right:
		nearby.append(right)
	return nearby

func find_door(x : int, y : int):
	return doors.filter(func(test : Door): return test.pos == Vector2i(x,y) && !test.checking && !test.open).pop_front()


func create_flash(texture : Texture2D, display_message : String, x : float, y : float, display_time : int = 100):
	var element = flash.instantiate()
	var tween = create_tween()
	element.setup(tween, texture, display_message, x, y, display_time)
	add_child(element)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
