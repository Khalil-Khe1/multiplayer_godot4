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
var npcs : Array
var cops : Array
var controller : PlayerController
var shares : Shares
var repo : InteractionRepo
var cards : CardRepo

func increment_turn():
	turn = turn + 1
	if(turn >= controller.get_players().size()):
		turn = 0
	if(controller.find(turn).get_is_stunned()):
		controller.find(turn).set_is_stunned(false)
		increment_turn()
		return
	#set_global_current(controller.find(turn))
	rpc("sync_turn", turn)

@rpc("any_peer")
func sync_turn(t : int):
	turn = t
	for p in controller.get_players():
		if(multiplayer.get_unique_id() == p.get_id()):
			print(p.get_player_name() + " NEW TURN")
			print(str(turn) + "     " + str(p.get_order()))
			if(turn == p.get_order()):
				set_game_state(gameStates.NEWTURN)
				#set_global_current(controller.find(turn))
				p.print_self()
				print("SYNC TURN")
		if(turn == 0):
			pass

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

func get_current() -> Player:
	return controller.get_players()[turn]

func get_players() -> Array:
	return controller.get_players()

func get_shares() -> Shares:
	return shares

func _process(delta):
	if(videostream.stream != null):
		if(!videostream.is_playing()):
			videostream.play()

func ui_init():
	var server  = self.get_parent()
	server.get_node("control/lobby").set_visible(false)
	server.get_node("control/game_ui").set_visible(true)
	server.get_node("control/game_ui/roll_panel").set_visible(true)
	server.get_node("control/game_ui/gameplay_panel").set_visible(false)
	server.get_node("control/game_ui/land_panel").set_visible(false)
	server.get_node("control/game_ui/land_panel/Sprite2D").set_texture(null)
	videostream = server.get_node("control/game_ui/land_panel/misc/land_vid")
	videostream.set_visible(false)
	audiostream = server.get_node("control/game_ui/land_panel/misc/AudioStreamPlayer")

func load_resources():
	load_dice()
	load_controllers()
	load_panels()
	setup_ui_navbar()

func load_players():
	controller = PlayerController.new()
	controller.load_players(self.get_node("Players").get_children())

func load_npcs():
	var npc : Player = Player.new()
	npc.set_player_name("CIA")
	npc.set_id(16)
	npc.set_order(0)
	npc.init_resources()
	npcs.append(npc)
	npc = Player.new()
	npc.set_player_name("سعود")
	npc.set_id(17)
	npc.set_order(1)
	npc.init_resources()
	npcs.append(npc)

func sync_peers_on_init():
	for p in controller.get_players():
		if(p.get_id() != 1):
			rpc_id(p.get_id(), "sync_players", controller.get_order_id())
			rpc_id(p.get_id(), "rpc_load_resources")
			rpc_id(p.get_id(), "sync_lobby_start_ui")

@rpc("any_peer")
func rpc_load_resources():
	load_resources()

@rpc("any_peer")
func sync_players(order_id : Array):
	load_players()
	for p in controller.get_players():
		for o in order_id.size():
			if(p.get_id() == order_id[o]):
				p.set_order(o)
		#p.print_self()

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

func load_controllers():
	shares = load("res://scripts/shares.gd").new() #lands
	repo = load("res://scripts/interaction_repository.gd").new() #interactions
	cards = load("res://scripts/cards/card_repository.gd").new() #cards
	

func setup_ui_navbar():
	for p in controller.get_players():
		p.init_navbar()

func hide_unhide_ui(keywords : Array):
	for k in panels.keys():
		if k in keywords:
			panels[k].set_visible(true)
		else:
			panels[k].set_visible(false)

func _on_move_pressed():
	var roll = int(self.get_parent().get_node("control/game_ui/roll_panel/howmuch").text)
	if(!controller.find(turn).check_imprisoned(roll)):
		var passed = await controller.find(turn).move(roll)
#		for p in passed:
#			await shares.find(p).on_pass(controller.find(turn), panels["land"])
	set_game_state(gameStates.ACTION)

func _on_roll_pressed():
	for p in controller.get_players():
		p.print_self()
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
	load_players()
	ui_init()
	load_resources()
	sync_peers_on_init()
	set_names()
	test()

func test():
	for l in shares.list_all():
		shares.assign_share(controller.get_players()[0], 1, l)

func set_names():
	for p in controller.get_players():
		rpc_id(p.get_id(), "start_name_sync")
	var peer : Player = controller.get_players()[0]
	rpc("sync_names", peer.get_id(), peer.get_player_name())

@rpc("any_peer", "call_local")
func start_name_sync():
	rpc("sync_names", multiplayer.get_unique_id(), controller.get_players()[0].get_player_name())

@rpc("any_peer")
func sync_names(id : int, username : String):
	print("etner")
	print(username)
	for p in controller.get_players():
		if(p.get_id() == id):
			print(id)
			p.set_player_name(username)

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
	var current_land = shares.find(controller.find(turn).get_square())
	var land_ui = panels["land"]
	
	#get and set descriptions
	land_ui.get_node("square/land_title").set_text("[center]" + current_land.get_land_name())
	land_ui.get_node("square/land_title").add_theme_color_override("default_color", current_land.get_font_color_raw())
	land_ui.get_node("square/color").get_theme_stylebox("panel").bg_color = current_land.get_color_raw()
	land_ui.get_node("misc/description_panel/description").set_text(current_land.get_description())
	if(current_land.get_image() != null):
		land_ui.get_node("Sprite2D").set_texture(current_land.get_image().get_texture())
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
			repo.append_button(repo.find(btn_id), land_ui.get_node("misc/hbox"), controller.find(turn), current_land)

func _on_exit_pressed():
	panels["land"] = default_land_panel
	videostream.stream = null
	videostream.set_visible(false)
	audiostream.stream = null
	var keywords : Array = ["gameplay"]
	hide_unhide_ui(keywords)

func _on_information_mouse_entered():
	panels["land"].get_node("misc/description_panel").set_visible(true)


func _on_information_mouse_exited():
	panels["land"].get_node("misc/description_panel").set_visible(false)


func _on_inventory_button_pressed():
	var scene : Control = load("res://scenes/inventory.tscn").instantiate()
	var parent = get_node("/root/server/control/game_ui")
	var card = load("res://scenes/land_inv.tscn")
	var grid : GridContainer = scene.get_node("Panel/scroll_lands/grid")
	var x = 0.1
	for l in controller.get_players()[turn].get_inventory()["lands"]:
		var instance : Control = card.instantiate()
		var style_box : StyleBoxFlat = StyleBoxFlat.new()
		style_box.bg_color = shares.find(l).get_color_raw()
		instance.get_node("Panel").add_theme_stylebox_override("panel", style_box)
		instance.get_node("Panel/square").set_text(str(l))
		grid.add_child(instance)
	var close_btn : Button = scene.get_node("Panel/close")
	close_btn.set_action_mode(0)
	close_btn.set_text("X")
	close_btn.pressed.connect(
		func():
			for ch in grid.get_children():
				grid.remove_child(ch)
				ch.queue_free()
			parent.remove_child(scene)
			scene.queue_free()
	)
	scene.scale = Vector2(0.8, 0.8)
	scene.position = Vector2(240, 95)
	parent.add_child(scene)
