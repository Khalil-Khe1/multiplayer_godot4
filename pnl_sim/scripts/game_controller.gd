extends Node

enum gameStates {NEWTURN, ROLL, MOVE, ACTION}

var seed : String
var dice : Array
var roll : int
var turn : int = 0
var players : Array
var buttons : Dictionary

func _set_turn(value): #FIGURE OUT GODOT 4 SETGET IMPLEMENTATION
	print("turn set to ", value)
	turn = value

func _input(event):
	pass

func _ready():
	pass

func load_resources():
	load_players()
	load_dice()

func load_players():
	print(self.get_node("Players").get_children())

func load_dice():
	for i in 6:
		var texture : Texture = load("res://resources/dice/d" + str(i+1) + ".png")
		dice.append(texture)

func load_buttons():
	buttons["roll"] = self.get_parent().get_node("control/game_ui/roll_panel/roll")
	buttons["move"] = self.get_parent().get_node("control/game_ui/roll_panel/move")

func _on_move_pressed():
	var howmuch : int = int(self.get_parent().get_node("control/game_ui/roll_panel/howmuch").text)
	if(howmuch == 0):
		print("xdd")
		return
	

func _on_roll_pressed():
	var rng = RandomNumberGenerator.new()
	var r1 : int
	var r2 : int
	rng.set_seed(hash(Time.get_ticks_msec() % rng.randi()))
	r1 = rng.randi_range(0, 5)
	rng.set_seed(hash(rng.get_seed() * r1))
	r2 = rng.randi_range(0, 5)
	set_dice(1, r1)
	set_dice(2, r2)
	self.get_parent().get_node("control/game_ui/roll_panel/howmuch").set_text(str(r1 + r2 + 2))
	rpc("sync_roll", r1, r2)

func _on_start_pressed():
	var server  = self.get_parent()
	server.get_node("control/lobby").set_visible(false)
	server.get_node("control/game_ui").set_visible(true)
	load_resources()

func set_dice(n : int, roll : int):
	self.get_parent().get_node("control/game_ui/roll_panel/D" + str(n)).set_texture(dice[roll])

@rpc("any_peer")
func sync_roll(r1 : int, r2 :int):
	set_dice(1, r1)
	set_dice(2, r2)
	self.get_parent().get_node("control/game_ui/roll_panel/howmuch").set_text(r1 + r2)

