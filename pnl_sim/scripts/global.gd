extends Node

var players : Array
var current_player : Player

func set_players(p : Array):
	self.players = p

func get_players():
	return self.players

func set_current(p : Player):
	self.current_player = p

func get_current():
	return self.current_player
