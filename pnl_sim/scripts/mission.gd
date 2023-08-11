extends Node

class_name Mission

var requested : Variant
var description : String
var confirm_btn : Button
var player : Player

func set_player(p : Player):
	self.player = p

func get_player():
	return self.player

func get_confirm():
	return self.confirm_btn
