extends Node

class_name PlayerController

var players : Array

func _init():
	pass

func load_players(player_array : Array):
	var order : int = 0
	for c in player_array:
		var p : Player = c
		p.set_order(order)
		order = order + 1
		players.append(p)

func sync_names(id : int, username : String):
	print(username)
	for p in players:
		if(p.get_id() == id):
			p.set_player_name(username)
			return

func get_players():
	return self.players

func find(turn : int):
	return self.players[turn]

func find_id(id : int):
	for p in players:
		if(p.get_id() == id):
			return p

func get_order_id() -> Array:
	var order_id : Array
	for p in players:
		order_id.append(p.get_id())
	return order_id
	
func set_reputation(id : int, rep : int):
	var target : Player = find_id(id)
	target.set_rep(rep)
	sort_rep()

func sort_rep():
	var temp : Array = players
	var callable : Callable = Callable(self, "custom_sort")
	var rank : int = 1
	temp.sort_custom(callable)
	for p in temp:
		p.set_rank(rank)
		rank = rank + 1

func custom_sort(a : Player, b : Player):
	return a.get_rep() < b.get_rep()

