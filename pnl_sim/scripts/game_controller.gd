extends Node

enum gameStates {NEWTURN, ROLL, MOVE, ACTION, ENDTURN}

const step : float = -0.12

#GAME STATE
var gameState : gameStates
var turn : int = 0

#rng
var seed : String
var roll : int

#UI
var dice : Array
var buttons : Dictionary
var panels : Dictionary

#PLAYERS
var players : Array
var shares : Shares

func increment_turn():
	turn = turn + 1
	if(turn >= players.size()):
		turn = 0
#		for l in shares.list_all():
#			l.generate()
	#GENERATE NEEDS RPC TESTING
	rpc("sync_turn", turn)

@rpc("any_peer")
func sync_turn(t : int):
	print(multiplayer.get_unique_id())
	turn = t
	for p in players:
		if(multiplayer.get_unique_id() == p.get_id()):
			if(turn == p.get_order()):
				set_game_state(gameStates.NEWTURN)

func set_game_state(value : gameStates):
	gameState = value
	var keywords : Array
	match(gameState):
		gameStates.NEWTURN:
			pass
		gameStates.ROLL:
			keywords.append("roll")
			hide_unhide_ui(keywords)
		gameStates.MOVE:
			pass
		gameStates.ACTION:
			keywords.append("gameplay")
			hide_unhide_ui(keywords)
		gameStates.ENDTURN:
			hide_unhide_ui(keywords)
			increment_turn()

func _input(event):
	pass

func _ready():
	pass

func load_resources():
	load_dice()
	load_lands()
	setup_ui_navbar()

@rpc("any_peer")
func rpc_load_resources():
	load_resources()

func load_players():
	var order : int = 0
	for c in self.get_node("Players").get_children():
		c.set_order(order)
		order = order + 1
		players.append(c)

func temp_players() -> Dictionary:
	var tmp_array : Dictionary = {}
	for p in players:
		tmp_array[p.get_id()] = p.get_order()
	return tmp_array

func sync_peers_on_init():
	var tmp = temp_players()
	for p in players:
		if(p.get_id() != 1):
			rpc_id(p.get_id(), "sync_players", tmp)
			rpc_id(p.get_id(), "rpc_load_resources")

@rpc("any_peer")
func sync_players(players_array : Dictionary):
	var local_players : Array = self.get_node("Players").get_children()
	for p in local_players:
		for rp in players_array.keys():
			if(p.get_id() == rp):
				p.set_order(players_array[rp])
				break
	for p in local_players:
		p.print_self()
		

func load_dice():
	for i in 6:
		var texture : Texture = load("res://resources/dice/d" + str(i+1) + ".png")
		dice.append(texture)

func load_buttons():
	buttons["roll"] = self.get_parent().get_node("control/game_ui/roll_panel/roll")
	buttons["move"] = self.get_parent().get_node("control/game_ui/roll_panel/move")

func load_panels():
	panels["roll"] = self.get_parent().get_node("control/game_ui/roll_panel")
	panels["gameplay"] = self.get_parent().get_node("contolr/game_ui/gameplay_panel")

func load_lands():
	shares = load("res://scripts/shares.gd").new()

func setup_ui_navbar():
	for p in players:
		p.init_navbar()

func hide_unhide_ui(keywords : Array):
	for k in panels.keys():
		if k in keywords:
			panels[k].set_visible(true)
		else:
			panels[k].set_visible(false)

func _on_move_pressed():
	var howmuch : int = int(self.get_parent().get_node("control/game_ui/roll_panel/howmuch").text)
	if(howmuch == 0):
		return
	var s : Vector3 = Vector3(0, 0, 0)
	for i in howmuch:
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
		#print(players[0].position, "   ", players[0].square)
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
	load_players()
	load_resources()
	sync_peers_on_init()
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

func _on_generate_pressed():
	shares.find(1).generate()
	shares.find(3).generate()


func _on_end_turn_pressed():
	set_game_state(gameStates.ENDTURN)
