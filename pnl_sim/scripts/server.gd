extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 3234
const SPAWN_POS : Vector3 = Vector3(-0.708, 0.801, 0.583)
const STEP = 0.2

var peer = ENetMultiplayerPeer.new()
var connected_peers = []

var dice : Array

var test : bool = false

func _ready():
	ui_initial_setup()

func ui_initial_setup():
	$control/Panel.set_visible(true)
	$control/lobby.set_visible(false)
	$control/game_ui.set_visible(false)

func _on_host_pressed():
	var current_port = DEFAULT_PORT
	if ($control/Panel/menu/labels/port.text):
		current_port = int($control/Panel/menu/labels/port.text)
	peer.create_server(current_port)
	multiplayer.multiplayer_peer = peer
	add_player(1)
	print("SERVER")
	print(connected_peers)
	
	peer.peer_connected.connect(
		func(new_peer_id):
			await get_tree().create_timer(1).timeout
			rpc("add_connected_players", new_peer_id)
			rpc_id(new_peer_id, "add_previous_players", connected_peers)
			add_player(new_peer_id)
	)
	
	$control/Panel.set_visible(false)
	$control/lobby.set_visible(true)

func _on_join_pressed():
	var current_port = DEFAULT_PORT
	var current_ip = DEFAULT_IP
	if ($control/Panel/menu/labels/port.text):
		current_port = int($control/Panel/menu/labels/port.text)
	if($control/Panel/menu/labels/address.text):
		current_ip = str($control/Panel/menu/labels/address.text)
	peer.create_client(current_ip, current_port)
	multiplayer.multiplayer_peer = peer
	
	$control/Panel.set_visible(false)
	$control/lobby.set_visible(true)
	$control/lobby/start.set_visible(false)

func add_player(peer_id):
	connected_peers.append(peer_id)
	var player_name = "PLAYER"
	if($control/Panel/menu/labels/name.text):
		player_name = str($control/Panel/menu/labels/name.text)
	var player = preload("res://scenes/player.tscn").instantiate()
	player.position = SPAWN_POS
	player.player_name = player_name
	player.player_id = peer_id
	self.get_node("gamescene/Players").add_child(player)
	#player.print_self()

@rpc
func add_connected_players(new_peer_id):
	add_player(new_peer_id)
	print(connected_peers)

@rpc
func add_previous_players(peers):
	for id in peers:
		add_player(id)

@rpc("any_peer")
func flip_bool(t):
	test = t

func _on_host_2_pressed():
	test = !test
	rpc("flip_bool", test)
