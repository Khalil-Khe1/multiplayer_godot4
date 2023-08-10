extends Node

class_name InteractionRepo

var interactions : Array

var dictionary : Dictionary

func _init():
	dictionary = {
		1 : "contest",
		2 : "purchase",
		3 : "build",
		4 : "buy_firearms",
		5 : "sell_firearms",
		6 : "buy_weed",
		7 : "sell_weed",
		8 : "buy_coke",
		9 : "sell_coke",
		16 : "launder"
	}

func find(id : int) -> Interaction:
	var path = "res://scripts/land_interactions/" + dictionary[id] + ".gd"
	return load(path).new()

func append_button(btn : Interaction, parent : Node, player : Player, land : Turf):
	btn.set_parent(parent)
	btn.set_up(player, land)
	parent.add_child(btn.get_button())
