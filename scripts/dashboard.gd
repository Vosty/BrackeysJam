extends Node

var player

@export var match_extra_icon : TextureRect
@export var fail_extra_icon : TextureRect
@export var peek_icon : TextureRect
@export var fang_icon : TextureRect
@export var key_ring_icon : TextureRect
@export var milk_icon : TextureRect
@export var hand_icon : TextureRect
@export var cuff_links_icon : TextureRect
@export var shades_icon : TextureRect
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Player_data")
	player.Coins_Updated.connect(update_coins)
	player.Keys_Updated.connect(update_keys)
	player.Upgrades_Updated.connect(update_upgrades)
	update_keys()
	update_coins()
	update_upgrades()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_coins():
	var coin_node = get_node("CanvasLayer/PanelContainer/MarginContainer/GridContainer/Coin Label")
	coin_node.text = str(player.coins)
	
func update_keys():
	var key_node = get_node("CanvasLayer/PanelContainer/MarginContainer/GridContainer/Key Label")
	key_node.text = str(player.keys)
	
func update_upgrades():
	match_extra_icon.visible = (player.match_extra > 0)
	match_extra_icon.tooltip_text = ""
	match_extra_icon.get_node("Label").text = str(100 * player.match_extra) + "% chance to gain an extra key when succesfully matching doors."
	
	fail_extra_icon.visible = (player.fail_extra > 0)
	fail_extra_icon.tooltip_text = ""
	fail_extra_icon.get_node("Label").text = str(100 * player.fail_extra) + "% chance to save a key when failing to match doors."
	
	peek_icon.visible = (player.peek > 0)
	peek_icon.tooltip_text = ""
	peek_icon.get_node("Label").text = "Peek behind " +str(player.peek) + " door(s) at the beginning of each round."
	
	fang_icon.visible = (player.clone_pairs > 0)
	fang_icon.tooltip_text = ""
	fang_icon.get_node("Label").text = "At start of round, turns " + str(player.clone_pairs) + " pair(s) into other existing pairs."
	
	key_ring_icon.visible = player.keys_extra > 0
	key_ring_icon.tooltip_text = ""
	key_ring_icon.get_node("Label").text = "Start each round with " + str(player.keys_extra) + " extra key(s)."
	
	milk_icon.visible = player.bonus_money > 0
	milk_icon.tooltip_text =""
	milk_icon.get_node("Label").text = "At end of round, gain " + str(player.bonus_money) + " bonus money."
	
	hand_icon.visible = player.free_rerolls > 0
	hand_icon.tooltip_text = ""
	hand_icon.get_node("Label").text = "At each shop, receive " + str(player.free_rerolls) + " free reroll(s)."
	
	cuff_links_icon.visible = player.trap_avoid > 0
	cuff_links_icon.tooltip_text = ""
	cuff_links_icon.get_node("Label").text = str(100 * player.trap_avoid) + "% chance to not trigger a trap door when opened."
	
	shades_icon.visible = player.nearby_show > 0
	shades_icon.tooltip_text = ""
	shades_icon.get_node("Label").text = "After matching a door, reveal " + str(player.nearby_show) + " nearby doors."



func _on_match_extra_texture_mouse_entered():
	match_extra_icon.get_node("Label").visible = true


func _on_match_extra_texture_mouse_exited():
	match_extra_icon.get_node("Label").visible = false
	



func _on_fail_extra_texture_mouse_entered():
	fail_extra_icon.get_node("Label").visible = true


func _on_fail_extra_texture_mouse_exited():
	fail_extra_icon.get_node("Label").visible = false


func _on_peek_texture_mouse_entered():
	peek_icon.get_node("Label").visible = true


func _on_peek_texture_mouse_exited():
	peek_icon.get_node("Label").visible = false
	



func _on_fang_texture_mouse_entered():
	fang_icon.get_node("Label").visible = true


func _on_fang_texture_mouse_exited():
	fang_icon.get_node("Label").visible = false
	



func _on_key_ring_texture_mouse_entered():
	key_ring_icon.get_node("Label").visible = true


func _on_key_ring_texture_mouse_exited():
	key_ring_icon.get_node("Label").visible = false



func _on_milk_texture_mouse_entered():
	milk_icon.get_node("Label").visible = true


func _on_milk_texture_mouse_exited():
	milk_icon.get_node("Label").visible = false
	



func _on_hand_texture_mouse_entered():
	hand_icon.get_node("Label").visible = true


func _on_hand_texture_mouse_exited():
	hand_icon.get_node("Label").visible = false


func _on_cuff_links_texture_mouse_entered():
	cuff_links_icon.get_node("Label").visible = true


func _on_cuff_links_texture_mouse_exited():
	cuff_links_icon.get_node("Label").visible = false



func _on_shades_texture_mouse_entered():
	shades_icon.get_node("Label").visible = true


func _on_shades_texture_mouse_exited():
	shades_icon.get_node("Label").visible = false
