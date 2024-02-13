extends Node2D

@export var width = 1080
@export var height = 720
@export var bufferx = 200
@export var buffery = 200
@export var starting_keys = 10

enum CHOOSE_STATES {NO_CHOICE, CHOICE_ONE, CHOICE_TWO, RESULTS_SCREEN, PEEK_STAGE}


const doorScene = preload("res://scenes/door.tscn")
const flash = preload("res://scenes/text_flash.tscn")
const key_tex : Texture2D = preload("res://assets/Iron_Key.png")
const coin_tex : Texture2D = preload("res://assets/Temp_Coin.png")
var suits = MatchSuits.MATCH_SUITS
var player : Player

var rng = RandomNumberGenerator.new()
var doors = []
var suits_in_use = []
var state = CHOOSE_STATES.NO_CHOICE
var suits_to_win : int
var matches_found : int = 0
var pick_one : Door
var pick_two : Door
var match_extra : float
var fail_extra : float
var peek : int
# Called when the node enters the scene tree for the first time.
func _ready():
	## Set-up
	player = get_node("/root/Player_data")
	state = CHOOSE_STATES.NO_CHOICE
	
	player.set_keys(starting_keys+player.keys_extra)
	player.attempts = 0
	prepare_doors()
	player.check_upgrades()
	match_extra = player.match_extra
	fail_extra = player.fail_extra
	peek = player.peek
	if peek > 0:
		state = CHOOSE_STATES.PEEK_STAGE

func prepare_doors():
	var rows = player.level / 3
	var columns = (player.level+2) / 3
	## Prepare all doors
	var i = 0
	var j = 0
	setup_suits(rows, columns)
	while i < rows:
		while j < columns:
			var door = doorScene.instantiate()
			var doorSpri = door.get_node("Sprite2D")
			
			## Creates a door, adjusts it to rest nicely on the screen within a window
			doorSpri.setup(choose_suit()) ## Assign
			door.position.x = (i * ((width-(bufferx * 2)) / (rows-1))) + bufferx
			door.position.y = (j * ((height-(buffery * 2)) / (columns-1))) + buffery
		
			doorSpri.Chosen.connect(handle_click)
			doors.append(doorSpri)
			add_child(door)
			j = j+1
		j = 0
		i = i+1

func setup_suits(rows, columns):
	var num_suits = rows * columns / 2
	suits_to_win = num_suits
	var odd = rows * columns % 2 == 1
	print(str(num_suits))
	var using_suits = suits.keys()
	# Shuffle list of all possible suits
	using_suits.shuffle()
	# Remove suits we don't need
	if odd:
		using_suits.resize(num_suits+1)
	else:
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
		CHOOSE_STATES.RESULTS_SCREEN:
			return
		CHOOSE_STATES.NO_CHOICE:
			pick_one = door
			check_door(door)
			state = CHOOSE_STATES.CHOICE_ONE
		CHOOSE_STATES.CHOICE_ONE:
			pick_two = door
			check_door(door)
			state = CHOOSE_STATES.CHOICE_TWO
			check_match()
		CHOOSE_STATES.CHOICE_TWO:
			pass
		CHOOSE_STATES.PEEK_STAGE: #Allows looking behind door at beginning if able
			peek -= 1
			check_door(door)
			create_flash(key_tex, "PEEKING!", 300.0, 100.0, 100)
			if peek <= 0:
				for d in doors:
					if d.checking:
						d.uncheck_door(true)
				state = CHOOSE_STATES.NO_CHOICE
			
			pass
func check_match():
	if pick_one.inside == pick_two.inside:
		print("match!")
		open_door(pick_one)
		open_door(pick_two)
		matches_found = matches_found + 1
		# Match_Extra powerup
		if rng.randf() <= match_extra:
			player.update_keys(1)
			create_flash(key_tex, "+1", 100.0, 100.0, 100.0)
			print("Match extra")
			
		if matches_found >= suits_to_win:
			state = CHOOSE_STATES.RESULTS_SCREEN
			await get_tree().create_timer(3).timeout
			get_node("ResultsScreen").show_results_screen()
		## Do not decrement attempts!
	else:
		print("die")
		pick_one.uncheck_door()
		pick_two.uncheck_door()
		
		if rng.randf() > fail_extra: #fail extra powerup implementation
			player.update_keys(-1)
			create_flash(key_tex, "-1", 100.0, 100.0, 100) # This should be better lol
		else:
			create_flash(key_tex, "SAVED", 100.0, 100.0, 100.0)
	state = CHOOSE_STATES.NO_CHOICE

func check_door(door):
	create_flash(key_tex, door.inside, height/2, width/2)
	door.check_door()
	
func open_door(door):
	door.open_door()

func create_flash(texture : Texture2D, display_message : String, x : float, y : float, display_time : int = 100):
	var element = flash.instantiate()
	var tween = create_tween()
	element.setup(tween, texture, display_message, x, y, display_time)
	add_child(element)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
