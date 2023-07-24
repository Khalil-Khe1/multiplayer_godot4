extends Node

var player_id : int
var player_name : String
var order : int
var square : int
var turf : Array

func print_self():
	print(self.player_id)
	print(self.player_name)
	print(self.order)
	print("OUT")
