extends Node

enum gameStates {NEWTURN, ROLL, MOVE, ACTION, ENDTURN}

#GAME STATE
var gameState : gameStates
var turn : int = 0

#rng
var seed : String
var roll : int

#UI
var dice : Array
var panels : Dictionary
var default_land_panel
var videostream : VideoStreamPlayer = VideoStreamPlayer.new()
var audiostream : AudioStreamPlayer = AudioStreamPlayer.new()

#PLAYERS AND LANDS
var players : Array
var shares : Shares
var repo : InteractionRepo

func increment_turn():
	turn = turn + 1
	if(turn >= players.size()):
		turn = 0
	rpc("sync_turn", turn)

@rpc("any_peer")
func sync_turn(t : int):
	turn = t
	for p in players:
		if(multiplayer.get_unique_id() == p.get_id()):
			if(turn == p.get_order()):
				set_game_state(gameStates.NEWTURN)
				p.print_self()

func set_game_state(value : gameStates):
	gameState = value
	var keywords : Array
	match(gameState):
		gameStates.NEWTURN:
			set_game_state(gameStates.ROLL)
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

func _process(delta):
	if(videostream.visible):
		if(!videostream.is_playing()):
			videostream.play()

func ui_init():
	var server  = self.get_parent()
	server.get_node("control/lobby").set_visible(false)
	server.get_node("control/game_ui").set_visible(true)
	server.get_node("control/game_ui/roll_panel").set_visible(true)
	server.get_node("control/game_ui/gameplay_panel").set_visible(false)
	server.get_node("control/game_ui/land_panel").set_visible(false)
	videostream = server.get_node("control/game_ui/land_panel/misc/land_vid")
	videostream.set_visible(false)
	audiostream = server.get_node("control/game_ui/land_panel/misc/AudioStreamPlayer")

func load_resources():
	load_dice()
	load_lands()
	load_buttons()
	load_panels()
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
			rpc_id(p.get_id(), "sync_lobby_start_ui")

@rpc("any_peer")
func sync_players(players_array : Dictionary):
	players = self.get_node("Players").get_children()
	for p in players:
		for rp in players_array.keys():
			if(p.get_id() == rp):
				p.set_order(players_array[rp])
				break
	for p in players:
		p.print_self()

func load_dice():
	for i in 6:
		var texture : Texture = load("res://resources/dice/d" + str(i+1) + ".png")
		dice.append(texture)

func load_panels():
	panels["roll"] = self.get_parent().get_node("control/game_ui/roll_panel")
	panels["gameplay"] = self.get_parent().get_node("control/game_ui/gameplay_panel")
	panels["land"] = self.get_parent().get_node("control/game_ui/land_panel")
	panels["land"].position = Vector2(175, 105)
	default_land_panel = panels["land"]

func load_lands():
	shares = load("res://scripts/shares.gd").new()

func load_buttons():
	repo = load("res://scripts/interaction_repository.gd").new()

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
	var passed = players[turn].move(int(self.get_parent().get_node("control/game_ui/roll_panel/howmuch").text))
	for p in passed:
		await shares.find(p).on_pass(players[turn], panels["land"])
	set_game_state(gameStates.ACTION)
	shares.find(players[turn].get_square()).on_enter(players[turn])

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

func _on_start_pressed():
	ui_init()
	load_players()
	load_resources()
	sync_peers_on_init()
	for p in players:
		p.print_self()

func set_dice(n : int, roll : int):
	self.get_parent().get_node("control/game_ui/roll_panel/D" + str(n)).set_texture(dice[roll])

@rpc("any_peer")
func sync_lobby_start_ui():
	var empty : Array
	empty.append("empty")
	self.get_parent().get_node("control/lobby").set_visible(false)
	self.get_parent().get_node("control/game_ui").set_visible(true)
	hide_unhide_ui(empty)

@rpc("any_peer")
func sync_roll(r1 : int, r2 :int):
	set_dice(1, r1)
	set_dice(2, r2)
	self.get_parent().get_node("control/game_ui/roll_panel/howmuch").set_text(r1 + r2)

func _on_end_turn_pressed():
	set_game_state(gameStates.ENDTURN)


func _on_land_button_pressed():
	#declarations
	var keywords : Array = ["land"]
	hide_unhide_ui(keywords)
	var current_land = shares.find(players[turn].get_square())
	var land_ui = panels["land"]
	
	#get and set descriptions
	land_ui.get_node("square/land_title").set_text("[center]" + current_land.get_land_name())
	land_ui.get_node("square/land_title").add_theme_color_override("default_color", current_land.get_font_color_raw())
	land_ui.get_node("square/color").get_theme_stylebox("panel").bg_color = current_land.get_color_raw()
	land_ui.get_node("Sprite2D").set_texture(current_land.get_image().get_texture())
	land_ui.get_node("misc/description_panel/description").set_text(current_land.get_description())
	if(current_land.get_video() != ""):
		videostream.stream = load(current_land.get_video())
		videostream.set_visible(true)
	if(current_land.get_audio() != ""):
		audiostream.stream = load(current_land.get_audio())
		audiostream.play(current_land.get_play_at())
	
	#initialize by removing children
	for c in land_ui.get_node("misc/hbox").get_children():
		land_ui.get_node("misc/hbox").remove_child(c)
		c.queue_free()
	#adding corresponding buttons
	if(!current_land.get_buttons().is_empty()):
		for btn_id in current_land.get_corresponding_buttons(turn):
			repo.append_button(repo.find(btn_id), land_ui.get_node("misc/hbox"), players[turn], current_land)

func _on_exit_pressed():
	panels["land"] = default_land_panel
	videostream.stream = null
	videostream.set_visible(false)
	audiostream.stream = null
	var keywords : Array = ["gameplay"]
	hide_unhide_ui(keywords)
