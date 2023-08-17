extends Node

class_name Card

var title : String
var description : String
var count : int
var tier : int
var is_ethereal : bool
var player : Player

func _init():
	default_init()

func default_init():
	title = ""
	count = 1
	tier = 1
	is_ethereal = false

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

func set_player(p : Player):
	self.player = p

func get_player():
	return self.player

func on_activate():
	pass
