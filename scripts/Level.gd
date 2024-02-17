extends Node2D

@export var width = 1080
@export var height = 720
@export var bufferx = 200
@export var buffery = 200
@export var starting_keys = 10
@export var baseboard_tex : Texture
@export var wall_tex : Texture
@export var floor_tex : Texture
@export var light_tex : Texture
@export var v_beam_tex : Texture
@onready var sfx_effects = $SFX_Effects
@onready var sfx_doors: = $SFX_Doors
@onready var sfx_status = $SFX_Status

@export var match_sound : AudioStream
@export var fail_sound : AudioStream
@export var trap_sound : AudioStream
@export var gain_key_sound : AudioStream
@export var lose_key_sound : AudioStream
@export var save_key_sound : AudioStream
@export var trap_save_sound : AudioStream
@export var win_sound : AudioStream
@export var game_over_sound : AudioStream
@export var peek_sound : AudioStream
@export var shades_sound : AudioStream
@export var swap_sound : AudioStream

@export var open_door_sound : AudioStream
@export var close_door_sound : AudioStream


enum CHOOSE_STATES {NO_CHOICE, CHOICE_ONE, CHOICE_TWO, RESULTS_SCREEN, PEEK_STAGE, TRAP_REVEAL}


const doorScene = preload("res://scenes/door.tscn")
const flash = preload("res://scenes/text_flash.tscn")
const key_tex : Texture2D = preload("res://assets/key.png")

const horn_tex : Texture2D = preload("res://assets/Upgrades/greebo_horn.png")
const cloth_tex : Texture2D = preload("res://assets/Upgrades/stranger_cloth.png")
const cuff_links_tex : Texture2D = preload("res://assets/Upgrades/cufflinks.png")
const eye_tex : Texture2D = preload("res://assets/Upgrades/seeker_eye.png")
const shades_tex : Texture2D = preload("res://assets/Upgrades/shades.png")


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
	
	draw_walls()
	draw_sides()
	player.set_keys(starting_keys+player.keys_extra)
	player.attempts = 0
	player.traps_hit = 0
	player.time_elapsed = 0.0
	prepare_doors()
	player.check_upgrades()
	match_extra = player.match_extra
	fail_extra = player.fail_extra
	
	if trap_number > 0:
		state = CHOOSE_STATES.TRAP_REVEAL
		Door.trap_phase = true
		var traps = doors.filter(func (d): return d.is_trap)
		for t in traps:
			reveal_trap(t)
		await get_tree().create_timer(5).timeout
		for t in traps:
			uncheck_door(t)
		Door.trap_phase = false
		
	peek = player.peek
	if peek > 0:
		player.is_peeking = true
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
	var scale = 1.0
	match player.round:
		7,8,9,10:
			#scale = 0.9
			buffery *= 0.80
		11,12:
			buffery *= 0.6
			scale = scale * 0.85
	while i < rows:
		setup_baseboards((i * ((height-(buffery * 2)) / (rows-1))) + buffery, scale)
		while j < columns:
			var door = doorScene.instantiate()
			var doorSpri = door.get_node("Sprite2D")
			
			## Creates a door, adjusts it to rest nicely on the screen within a window
			doorSpri.setup(choose_suit()) ## Assign

			door.position.x = (j * ((width-(bufferx * 2)) / (columns-1))) + bufferx
			# ^ width - 2x buffer leaves total usable width
			# ^ dividing by the columns minus 1 leaves the horizontal distance between doors.
			door.position.y = (i * ((height-(buffery * 2)) / (rows-1))) + buffery
			
	
			
			doorSpri.pos = Vector2i(i, j)
			doorSpri.scale = Vector2(scale,scale)
			# Add lights between doors
			if j < columns -1 :
				add_lights(door.position.x, door.position.y, ((width-(bufferx * 2)) / (columns-1)), scale)
			doorSpri.Chosen.connect(handle_click)
			doorSpri.Close_Finished.connect(play_close_sound)
			doors.append(doorSpri)
			add_child(door)
			j = j+1
		j = 0
		
		i = i+1
		
func setup_baseboards(door_y_position, scale = 1.0):
	var baseboard_length : int = bufferx - 108
	var segment_length : int = baseboard_tex.get_width()
	
	while baseboard_length <= width - bufferx + (segment_length):
		#Add new baseboard sprite
		var new_segment = Sprite2D.new()
		var new_floor = Sprite2D.new()
		new_segment.texture = baseboard_tex
		new_floor.texture = floor_tex
		self.add_child(new_segment)
		self.add_child(new_floor)
		new_segment.position.x = baseboard_length + 32
		new_segment.position.y = door_y_position + (32 * scale)
		new_floor.position.x = baseboard_length + 32
		new_floor.position.y = door_y_position + (32 * scale) + 32
		baseboard_length += segment_length
	
func add_lights(x_pos, y_pos, h_diff, scale):
	# the lights should be midway between doors
	# Easiest way to add lights after each door except the last in the row.
	var new_light = Sprite2D.new()
	new_light.texture = light_tex
	self.add_child(new_light)
	new_light.position.x = x_pos + (h_diff / 2)
	new_light.position.y = y_pos - 32
	new_light.scale = Vector2(scale,scale)
	
func draw_floor_bottom(): # Draws floor tiles through the bottom buffery region
	var floor_segment_height : int = 16
	var floor_segment_width : int = floor_tex.get_width()
	var current_floor_height : int = height - buffery
	var current_floor_width : int = 0
	while current_floor_height < height:
		current_floor_width = 0
		while current_floor_width < width:
			var new_floor = Sprite2D.new()
			new_floor.texture = floor_tex
			self.add_child(new_floor)
			new_floor.position.x = current_floor_width + 32
			new_floor.position.y = current_floor_height
			current_floor_width += floor_segment_width
		current_floor_height += floor_segment_height

func draw_sides():
	var current_height = buffery - 128
	var beam_width = v_beam_tex.get_width()
	var beam_height = v_beam_tex.get_height()
	while current_height < height:
		var new_beam_left = Sprite2D.new()
		var new_beam_right = Sprite2D.new()
		new_beam_left.texture = v_beam_tex 
		new_beam_right.texture = v_beam_tex
		self.add_child(new_beam_left)
		self.add_child(new_beam_right)
		new_beam_left.position.x = bufferx - (beam_width * 7)
		new_beam_right.position.x = width - bufferx + (beam_width * 7)
		new_beam_left.position.y = current_height
		new_beam_right.position.y = current_height
		current_height += beam_height
	
func draw_walls():
	var wall_length : int = bufferx - 108
	var segment_length : int = wall_tex.get_width()
	var wall_height : int = wall_tex.get_height()
	var current_height : int =0
	while current_height < height:
		wall_length = bufferx - 108
		while wall_length <= width - bufferx + (segment_length):
			var new_wall = Sprite2D.new()
			new_wall.texture = wall_tex
			self.add_child(new_wall)
			new_wall.position.x = wall_length + 32
			new_wall.position.y = current_height
			wall_length += segment_length
		current_height += wall_height
	
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
				uncheck_door(pick_one)
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
			if peek <= 0:
				return
			peek -= 1
			peek_door(door)
			create_flash(eye_tex, "PEEKING!", 300.0, 100.0, 100)
			if peek <= 0:
				player.is_peeking = false
				await get_tree().create_timer(1).timeout
				for d in doors:
					if d.checking:
						unpeek_door(d)
				state = CHOOSE_STATES.NO_CHOICE
			
			pass
func check_match(door):
	if pick_one.inside == pick_two.inside:
		print("match!")
		create_flash(door.monster.tex, door.monster.name, get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y)
		sfx_status.stream = match_sound
		sfx_status.play()
		open_door(pick_one)
		open_door(pick_two)
		matches_found = matches_found + 1
		# Match_Extra powerup
		if rng.randf() <= match_extra:
			player.update_keys(1)
			sfx_effects.stream = gain_key_sound
			sfx_effects.play()
			await get_tree().create_timer(.30).timeout
			create_flash(horn_tex, "+1", 100.0, 100.0, 100.0)
			print("Match extra")
			
		if matches_found >= suits_to_win:
			state = CHOOSE_STATES.RESULTS_SCREEN
			await get_tree().create_timer(0.85).timeout
			sfx_effects.stream = win_sound
			sfx_effects.play()
			await get_tree().create_timer(3).timeout
			if player.round == 12:
				game_over()
				return
			Door.results_phase = true
			get_node("ResultsScreen").show_results_screen()
			return
		# Shades Power-up	
		if player.nearby_show > 0:
			var nearby = get_nearby_doors(door)
			if nearby.size() == 0:
				state = CHOOSE_STATES.NO_CHOICE
				return
			create_flash(shades_tex, "PEEKING!", 300.0, 100.0, 100)
			sfx_effects.stream = shades_sound
			sfx_effects.play()
			nearby.shuffle()
			var show = []	
			for i in player.nearby_show:
				if nearby.size() > 0:
					show.append(nearby.pop_front())
			for d in show:
				check_door(d)
				await get_tree().create_timer(0.75).timeout
				uncheck_door(d)
			
		## Do not decrement attempts!
	else:
		print("die")
		sfx_status.stream = fail_sound
		sfx_status.play()
		uncheck_door(pick_one)
		uncheck_door(pick_two)
		lose_key()

	state = CHOOSE_STATES.NO_CHOICE

func check_door(door):
	sfx_doors.stream = open_door_sound
	sfx_doors.play()
	door.check_door()
	
func uncheck_door(door, close = true):
	door.uncheck_door(close)
	
func open_door(door):
	sfx_doors.stream = open_door_sound
	sfx_doors.play()
	door.open_door()

func close_door(door):
	door.close_door()
	
func play_close_sound():
	sfx_doors.stream = close_door_sound
	sfx_doors.play()
	
func reveal_trap(door):
	sfx_doors.stream = open_door_sound
	sfx_doors.play()
	door.reveal_trap()
	
func peek_door(door):
	sfx_effects.stream = peek_sound
	sfx_effects.play()
	var tween = create_tween()
	door.peek_door(tween)
	
func unpeek_door(door):
	var tween = create_tween()
	door.unpeek_door(tween)
	
func lose_key():
	if rng.randf() > fail_extra: #fail extra powerup implementation
		player.update_keys(-1)
		await get_tree().create_timer(0.30).timeout
		create_flash(key_tex, "-1", 100.0, 100.0, 100) # This should be better lol
		sfx_effects.stream = lose_key_sound
		sfx_effects.play()
		if player.keys <= 0:
				game_over()
	else:
		await get_tree().create_timer(0.30).timeout
		create_flash(cloth_tex, "SAVED", 100.0, 100.0, 100.0)
		sfx_effects.stream = save_key_sound
		sfx_effects.play()

func spring_trap(door):
	sfx_doors.stream = open_door_sound
	sfx_doors.play()
	door.spring_trap()
	player.traps_hit += 1
	if rng.randf() <= player.trap_avoid:
		create_flash(cuff_links_tex, "TRAP AVOIDED!", get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y)
		sfx_effects.stream = trap_save_sound
		sfx_effects.play()
	else:
		create_flash(door.trap.tex, door.trap.name, get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y)
	
	#create_flash(door.trap.tex, door.inside, get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y)
	sfx_status.stream = trap_sound
	sfx_status.play()
	match traps.get(door.inside):
		traps.MINUS_KEY:
			for i in 3:
				await get_tree().create_timer(0.20).timeout
				player.update_keys(-1)
				create_flash(key_tex, "-1", 100.0, 100.0, 100)
				sfx_effects.stream = lose_key_sound
				sfx_effects.play()
				if player.keys <= 0:
					game_over()
		traps.CLOSE_DOOR:
			sfx_effects.stream = lose_key_sound
			sfx_effects.play()
			var open_doors = doors.filter(func(d): return d.open && !d.is_trap)
			if open_doors.size() < 2:
				return
			open_doors.shuffle()
			var dx = open_doors.pop_front()
			var dy = open_doors.filter(func(d): return d.inside == dx.inside).pop_front()
			close_door(dx)
			close_door(dy)
			matches_found -= 1
			open_doors.erase(dy)
			if open_doors.size() < 2:
				return
			open_doors.shuffle()
			dx = open_doors.pop_front()
			dy = open_doors.filter(func(d): return d.inside == dx.inside).pop_front()
			close_door(dx)
			close_door(dy)
			matches_found -= 1
		traps.SWAP_DOOR:
			var closed_doors = doors.filter(func(d): return !d.open && !d.is_trap && !d.checking)
			if closed_doors.size() < 2:
				return
			closed_doors.shuffle()
			var dx = closed_doors.pop_front()
			closed_doors.shuffle()
			var dy = closed_doors.pop_front()
			await get_tree().create_timer(1).timeout
			sfx_effects.stream = swap_sound
			sfx_effects.play()
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


func game_over(win = false):
	if !win:
		sfx_effects.stream = game_over_sound
		sfx_effects.play()
	state = CHOOSE_STATES.RESULTS_SCREEN
	Door.results_phase = true

	await get_tree().create_timer(2).timeout
	get_node("GameOverScreen").show_gameover_screen()

func create_flash(texture : Texture2D, display_message : String, x : float, y : float, display_time : int = 100):
	var element = flash.instantiate()
	var tween = create_tween()
	element.setup(tween, texture, display_message, x, y, display_time)
	add_child(element)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == CHOOSE_STATES.TRAP_REVEAL || state == CHOOSE_STATES.RESULTS_SCREEN:
		return
	else:
		player.time_elapsed += delta
	
func _input(event):
	if Input.is_action_pressed("Skip"):
		#get_node("ResultsScreen").show_results_screen()
		get_tree().change_scene_to_file("res://scenes/shop.tscn")
	if Input.is_action_pressed("money"):
		player.update_coins(5)
		
