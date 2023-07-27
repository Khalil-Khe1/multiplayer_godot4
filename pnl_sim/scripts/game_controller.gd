extends Node

enum gameStates {NEWTURN, ROLL, MOVE, ACTION}

const step : float = -0.12

var seed : String
var dice : Array
var roll : int
var turn : int = 0
var players : Array
var buttons : Dictionary
var shares : Shares

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
	load_lands()
	setup_ui_navbar()

func load_players():
	for c in self.get_node("Players").get_children():
		players.append(c)

func load_dice():
	for i in 6:
		var texture : Texture = load("res://resources/dice/d" + str(i+1) + ".png")
		dice.append(texture)

func load_buttons():
	buttons["roll"] = self.get_parent().get_node("control/game_ui/roll_panel/roll")
	buttons["move"] = self.get_parent().get_node("control/game_ui/roll_panel/move")

func load_lands():
	shares = load("res://scripts/shares.gd").new()

func setup_ui_navbar():
	for p in players:
		p.init_navbar()

func _on_move_pressed():
	var howmuch : int = int(self.get_parent().get_node("control/game_ui/roll_panel/howmuch").text)
	if(howmuch == 0):
		print("xdd")
		return
	var s : Vector3 = Vector3(0, 0, 0)
	for i in howmuch:
		print(range(0, 9))
		if(players[0].square in range(0, 10)):
			s = Vector3(0, 0, 1)
		if(players[0].square in range(10, 20)):
			s = Vector3(-1, 0, 0)
		if(players[0].square in range(20, 30)):
			s = Vector3(0, 0, -1)
		if(players[0].square in range(30, 40)):
			s = Vector3(1, 0, 0)
		players[0].position = players[0].position + (s * step)
		players[0].square = players[0].square + 1
		if(players[0].square > 39):
			players[0].square = 0
		print(players[0].position, "   ", players[0].square)
		await get_tree().create_timer(0.4).timeout

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
	test_lands()

func set_dice(n : int, roll : int):
	self.get_parent().get_node("control/game_ui/roll_panel/D" + str(n)).set_texture(dice[roll])

@rpc("any_peer")
func sync_roll(r1 : int, r2 :int):
	set_dice(1, r1)
	set_dice(2, r2)
	self.get_parent().get_node("control/game_ui/roll_panel/howmuch").set_text(r1 + r2)

func test_lands():
	shares.assign_share(players[1], 1, shares.find(1))
	shares.assign_share(players[0], 0.6, shares.find(3))
	shares.assign_share(players[1], 0.4, shares.find(3))
	print(players[0])

func _on_generate_pressed():
	shares.find(1).generate()
	shares.find(3).generate()
