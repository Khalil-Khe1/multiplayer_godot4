extends Node

class_name Card

var id : int
var title : String
var description : String
var count : int
var tier : int
var is_ethereal : bool
var is_passive : bool
var player : Player

func _init():
	default_init()

func default_init():
	id = -1
	title = ""
	count = 1
	tier = 1
	is_ethereal = false
	is_passive = false

func set_id(i : int):
	self.id = i

func get_id():
	return self.id

func set_title(t : String):
	self.title = t

func get_title():
	return self.title

func set_description(d : String):
	self.description = d

func get_description():
	return self.description

func set_count(c : int):
	self.count = c

func get_count():
	return self.count

func set_tier(t : int):
	self.tier = t

func get_tier():
	return self.tier

func set_ethereal(e : bool):
	self.is_ethereal = e

func get_ethereal():
	return self.is_ethereal

func set_passive(p : bool):
	self.is_passive = p

func get_passive():
	return self.passive

func set_player(p : Player):
	self.player = p

func get_player():
	return self.player

func on_activate():
	pass
