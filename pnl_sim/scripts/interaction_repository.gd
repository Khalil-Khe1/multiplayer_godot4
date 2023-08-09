extends Node

class_name InteractionRepo

var interactions : Array

var dictionary : Dictionary

func _init():
	dictionary = {
		1 : "contest",
		2 : "purchase",
		3 : "build",
		16 : "launder"
	}

func find(id : int):
	var path = "res://scripts/land_interactions/" + dictionary[id] + ".gd"
	return load(path).new()
